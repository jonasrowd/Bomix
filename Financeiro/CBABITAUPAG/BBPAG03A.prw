#include "rwmake.ch"

/*
PROGRAMA  : BBPAG03A
DATA      : 04/12/09
DESCRIÇÃO : Efetua o tratamento da agencia e conta para a transacao de transferencia.
UTILIZAÇÃO: CNAB Brasil a Pagar - Posições 024-043
*/

User Function BBPAG03A()

SetPrvt("_CAGCC,_CAG,_CAGDV,_TAMCC,_CCC,_CCCDV,_cBanco,_cAgencia,_cConta")

_cAGCC   := Space(19)
_cBanco  := Space(3)
_cAgencia:= Space(5)
_cConta  := Space(13)
 
If !Empty(SE2->E2_BCOFOR)
	_cBanco  := Alltrim(SE2->E2_BCOFOR)
	_cAgencia:= Alltrim(SE2->E2_AGPGTO)
	_cConta  := Alltrim(SE2->E2_CTAPGTO)
Else     
	_cBanco  := Alltrim(SA2->A2_BANCO)
	_cAgencia:= Alltrim(SA2->A2_AGENCIA)
	_cConta  := Alltrim(SA2->A2_NUMCON)
Endif

If _cBanco == "001" 

   _cAG := SubStr(_cAgencia,1,4)
   _cAGDV := substr(_cAgencia,5,1)

   _tamCC := Len(Alltrim(_cConta))
   _cCC   := SubStr(_cConta,1,_tamCC-1)
   _cCCDV := SubStr(_cConta,_tamCC,1)

   _cAGCC := StrZero(Val(_cAG),5)+_cAGDV+StrZero(Val(_cCC),12)+_cCCDV

Else
   _cAGCC := StrZero(Val(_cAgencia),5)+" "+StrZero(Val(_cAgencia),13)
EndIf

Return(_cAGCC) 

