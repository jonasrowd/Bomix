#include "rwmake.ch"

/*      
PROGRAMA  : CODBAR
DATA      : 14/11/09
DESCRIÇÃO : Converte a linha digitavel em codigo de barras, para os CNAB's a Pagar.
UTILIZAÇÃO: Gatilho no campo E2_CODBAR, retorno para o mesmo campo.
*/

User Function CODBAR()

SetPrvt("_CRETORNO,")

_cRetorno := M->E2_CODBAR

IF LEN(ALLTRIM(M->E2_CODBAR))== 47
   _cRetorno := Substr(M->E2_CODBAR,1,4) + ;                 // BANCO + MOEDA
   Substr(M->E2_CODBAR,33,1) + ;                             // DV GERAL
   Substr(M->E2_CODBAR,34,4) + ;                             // FATOR VENCIMENTO
   StrZero(Val(Alltrim(Substr(M->E2_CODBAR,38,10))),10) + ;  // VALOR
   Substr(M->E2_CODBAR,5,5) + ;                              // CAMPO LIVRE
   Substr(M->E2_CODBAR,11,10) + ;
   Substr(M->E2_CODBAR,22,10)
ELSEIF LEN(ALLTRIM(M->E2_CODBAR)) <> 47 .AND. LEN(ALLTRIM(M->E2_CODBAR)) <> 44
    // Concessionarias e tributos
   _cRetorno := Substr(M->E2_CODBAR,1,11) + Substr(M->E2_CODBAR,13,11) + Substr(M->E2_CODBAR,25,11) + Substr(M->E2_CODBAR,37,11)
ENDIF

Return(_cRetorno)