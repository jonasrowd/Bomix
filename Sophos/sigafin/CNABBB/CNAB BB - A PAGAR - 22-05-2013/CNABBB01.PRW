#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

User Function codbar()        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RPCODBAR ³ Autor ³ Patricia P. Santos    ³ Data ³ 08/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte Cod. Barras p/ Linha Digitavel e o contrario      ³±±
±±³          ³ Desenvolvido para ROYALPLAS- Gatilho                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteacao  ³ Alterado em 20/09/00 para validar novo padrao de Codigo de ³±±
±±³          ³ Barras da FEBRABAN de 01/09/00 - Vitor Luis Fattori        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

SetPrvt("_CRETORNO,")

_cRetorno := M->E2_CODBAR

IF LEN(ALLTRIM(M->E2_CODBAR))== 47
   _cRetorno := Substr(M->E2_CODBAR,1,4) + ;             // BANCO + MOEDA
   Substr(M->E2_CODBAR,33,1) + ;                      // DV GERAL
   Substr(M->E2_CODBAR,34,4) + ;                       // FATOR VENCIMENTO
   StrZero(Val(Alltrim(Substr(M->E2_CODBAR,38,10))),10) + ; // VALOR
   Substr(M->E2_CODBAR,5,5) + ;                              // CAMPO LIVRE
   Substr(M->E2_CODBAR,11,10) + ;
   Substr(M->E2_CODBAR,22,10)
ELSEIF LEN(ALLTRIM(M->E2_CODBAR)) <> 47 .AND. LEN(ALLTRIM(M->E2_CODBAR)) <> 44
// Concessionarias e tributos
   _cRetorno := Substr(M->E2_CODBAR,1,11) + Substr(M->E2_CODBAR,13,11) + Substr(M->E2_CODBAR,25,11) + Substr(M->E2_CODBAR,37,11)
ENDIF
Return(_cRetorno)

