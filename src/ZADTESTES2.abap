*&---------------------------------------------------------------------*
*& Report ZADTESTES2
*&---------------------------------------------------------------------*
*& Teste prático: Relatório ALV com cores dinâmicas usando SFLIGHT
*&---------------------------------------------------------------------*
REPORT zadtestes2.

TABLES: sflight.

" Estrutura da tabela de saída (a coluna t_color é essencial pro SALV pintar a linha)
TYPES: BEGIN OF ty_result,
         carrid   TYPE sflight-carrid,
         fldate   TYPE sflight-fldate,
         customid TYPE sbook-customid,
         seatsmax TYPE sflight-seatsmax,
         seatsocc TYPE sflight-seatsocc,
         ocupacao TYPE p DECIMALS 2,
         t_color  TYPE lvc_t_scol, " Tabela de cores interna
       END OF ty_result.

DATA: lt_results TYPE TABLE OF ty_result,
      ls_color   TYPE lvc_s_scol,
      go_alv     TYPE REF TO cl_salv_table,
      gx_msg     TYPE REF TO cx_salv_msg.

" Telinha de seleção básica
SELECT-OPTIONS: v_carrid FOR sflight-carrid,
                v_fldate FOR sflight-fldate.

" Checkbox pra filtrar só os voos lotados
PARAMETERS: p_crit AS CHECKBOX.

START-OF-SELECTION.
  PERFORM lcl_processor.

*&---------------------------------------------------------------------*
*& Form LCL_PROCESSOR
*&---------------------------------------------------------------------*
FORM lcl_processor.

  " Puxando os dados das tabelas de voo (SFLIGHT, SCARR, SBOOK)
  SELECT a~carrid, a~fldate, c~customid, a~seatsmax, a~seatsocc
    FROM sflight AS a
    INNER JOIN scarr AS b ON b~carrid = a~carrid
    INNER JOIN sbook AS c ON c~carrid = a~carrid
                         AND c~fldate = a~fldate
                         AND c~connid = a~connid
    INTO CORRESPONDING FIELDS OF TABLE @lt_results
    WHERE a~carrid IN @v_carrid
      AND a~fldate IN @v_fldate.

  IF sy-subrc IS INITIAL.
    " Limpa a sujeira pra não dar dor de cabeça com dados duplicados
    SORT lt_results BY carrid fldate.
    DELETE ADJACENT DUPLICATES FROM lt_results COMPARING carrid fldate.

    LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<fs_result>).
      " Tratamento ALPHA para o ID
      <fs_result>-customid = |{ <fs_result>-customid ALPHA = OUT }|.

      " Calcula a porcentagem de ocupação do voo (evitando dump de divisão por zero)
      IF <fs_result>-seatsmax > 0.
        <fs_result>-ocupacao = ( <fs_result>-seatsocc / <fs_result>-seatsmax ) * 100.
      ENDIF.

      " Regrinha visual: pintando as linhas dependendo da lotação do voo
      CLEAR ls_color.
      IF <fs_result>-ocupacao >= 90.
        ls_color-color-col = 6. " Vermelho (Tá quase lotado/crítico)
        ls_color-color-int = 1.
      ELSEIF <fs_result>-ocupacao >= 60.
        ls_color-color-col = 3. " Amarelo (Atenção, enchendo)
        ls_color-color-int = 1.
      ELSE.
        ls_color-color-col = 5. " Verde (Tranquilo)
        ls_color-color-int = 1.
      ENDIF.
      APPEND ls_color TO <fs_result>-t_color.

    ENDLOOP.

    " Se o usuário marcou o checkbox, joga fora o que não é crítico
    IF p_crit = abap_true.
      DELETE lt_results WHERE ocupacao < 90.
    ENDIF.
  ENDIF.

  " Chama o SALV pra mostrar tudo na tela
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = lt_results ).

      " Otimiza o tamanho das colunas e avisa qual coluna tem a cor
      DATA(lo_columns) = go_alv->get_columns( ).
      lo_columns->set_optimize( abap_true ).
      lo_columns->set_color_column( 'T_COLOR' ).

      " Liga os botões padrão do ALV e exibe
      go_alv->get_functions( )->set_all( abap_true ).
      go_alv->display( ).

    CATCH cx_salv_msg INTO gx_msg.
      " Se der ruim, mostra o erro
      MESSAGE gx_msg->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.
