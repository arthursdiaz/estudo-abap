*&---------------------------------------------------------------------*
*& Report ZPROGRAMAXX01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprogramaxx01.

DATA: v_idadmes TYPE I, "variavel para calcular idade em meses
      lv_ano_atual TYPE I, "variavel que pega o ano atual utilizando o SY-DATUM
      lv_ano_nasc TYPE I. "variavel para calcular o ano de nascimento

" C = string até 65k de caracteres
" I = inteiro 4 byte +/- 2.1 bi
PARAMETERS: v_nome TYPE C LENGTH 50, "pede ao usuario nome e idade com campos a serem preenchidos
            v_idade TYPE I.

"validações para os parametros que o sistema pede
at SELECTION-SCREEN on v_nome.
  if v_nome is initial. "não permite campo vazio
    message 'Digite seu nome por favor.' type 'E'.
  ENDIF.

at SELECTION-SCREEN ON v_idade.
  if v_idade is initial. "não permite campo vazio e idade = 0
    message 'Digite sua idade por favor.' type 'E'.
  ENDIF.

  if v_idade > 100. "Valida idade muito alta e não permite valor a cima de 100
    message 'Idade muito alta, revise por favor.' type 'E'.
  ENDIF.

START-OF-SELECTION. "começa o sistema após preenchimento e validações

v_idadmes = v_idade * 12. "multiplica a idade por 12 para estimar idade em meses
lv_ano_atual = sy-datum(4). "pega os 4 primeiros digitos do ano atual (AAAA)
lv_ano_nasc = lv_ano_atual - v_idade. "calcula ano de nascimento (ano atual - idade inserida)

Write:/'Nome: ', v_nome. "exibe nome
Write:/'Idade: ', v_idade. "exibe idade

if v_idade >= 60.
  Write:/'Idoso'. "caso idade maior que 60 = idoso
  ELSEIF v_idade >= 18. "caso idade maior que 18 = adulto (colocado após o idoso para evitar que mostrasse somente adulto)
    Write:/'Adulto'.
  else.
     Write:/'Menor de idade'. "se não se encaixa nas condições acima = menor de idade
endif.

Write:/'Idade em meses (aprox.): ', v_idadmes, 'Meses'. "exibe idade em meses
Write:/'Ano de nascimento: ', lv_ano_nasc. "exibe ano de nascimento
