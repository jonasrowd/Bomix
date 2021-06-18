#include "rwmake.ch"

/*
PROGRAMA  : BBPAG03A
DATA      : 04/12/09
DESCRIÇÃO : Efetua o tratamento da agencia e conta para a transacao de transferencia.
UTILIZAÇÃO: CNAB Brasil a Pagar - Posições 024-043
*/

User Function BBPAG03A()

SetPrvt("_CAGCC,_CAG,_CAGDV,_TAMCC,_CCC,_CCCDV")

_cAGCC := Space(19)

If SE2->E2_BCOFOR == "001" 

   _cAG := SubStr(SE2->E2_AGPGTO,1,4)
   _cAGDV := substr(SE2->E2_AGPGTO,5,1)

   _tamCC := Len(Alltrim(SE2->E2_CTAPGTO))
   _cCC   := SubStr(SE2->E2_CTAPGTO,1,_tamCC-1)
   _cCCDV := SubStr(SE2->E2_CTAPGTO,_tamCC,1)

   _cAGCC := StrZero(Val(_cAG),5)+_cAGDV+StrZero(Val(_cCC),12)+_cCCDV

Else
   _cAGCC := StrZero(Val(SE2->E2_AGPGTO),5)+" "+StrZero(Val(SE2->E2_CTAPGTO),13)
EndIf

Return(_cAGCC)