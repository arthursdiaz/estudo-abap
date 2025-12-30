# Programa ABAP – Cadastro Simples e Processamento de Idade (Estudos)

Este projeto é um programa ABAP desenvolvido para estudos pessoais, com o objetivo de
praticar conceitos básicos da linguagem e do ambiente SAP.

O programa utiliza tela de seleção para entrada de dados, validações, processamento
lógico e exibição de resultados na saída padrão do ABAP.

> Projeto de estudos desenvolvido por estudante de Análise e Desenvolvimento de Sistemas.

---

## Funcionalidades

- Entrada de nome e idade via tela de seleção (`PARAMETERS`)
- Validação de campos obrigatórios
- Validação de idade máxima
- Classificação por faixa etária:
  - Menor de idade
  - Adulto
  - Idoso
- Cálculo da idade aproximada em meses
- Cálculo do ano de nascimento com base no ano atual
- Exibição organizada das informações processadas

---

## Conceitos ABAP utilizados

- Programas executáveis (SE38)
- Tela de seleção (`PARAMETERS`)
- Eventos (`AT SELECTION-SCREEN`, `START-OF-SELECTION`)
- Validações com mensagens de erro
- Operações aritméticas
- Uso de variáveis internas
- Saída formatada com `WRITE`

---

## Como funciona

1. O usuário informa o nome e a idade na tela de seleção.
2. O sistema valida se os campos foram preenchidos corretamente.
3. Após a validação, o programa:
   - Classifica a faixa etária
   - Calcula a idade em meses
   - Calcula o ano de nascimento
4. Os dados processados são exibidos na tela.

---

## Tecnologias e ferramentas

- SAP ABAP
- SAP GUI
- Editor ABAP (SE38)

---

## Observações

- Este programa foi desenvolvido exclusivamente para fins de aprendizado.
- O código não utiliza banco de dados ou tabelas Z.
- O objetivo principal é demonstrar lógica, organização e entendimento do fluxo ABAP.

---

## Autor

Arthur Santos Diaz  
Estudante de Análise e Desenvolvimento de Sistemas  
GitHub: https://github.com/arthursdiaz
