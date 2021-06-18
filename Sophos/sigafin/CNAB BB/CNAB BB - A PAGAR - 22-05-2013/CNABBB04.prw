#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

User Function CNABBB04()        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

SetPrvt("_CAGCC,_CAG,_CAGDV,_TAMCC,_CCC,_CCCDV")

_cAGCC := space(19)

_cAG   := substr(SA2->A2_AGENCIA,1,4)
_cAGDV := substr(SA2->A2_AGENCIA,5,1)

IF 	AT("-",SA2->A2_NUMCON) == 0 
	_cCC   := substr(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON))-1)
	_cCCDV := substr(SA2->A2_NUMCON,Len(Alltrim(SA2->A2_NUMCON)),1)
Else
	_cCC   := substr(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON)-1)
	_cCCDV := substr(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON)+1,1)
Endif

/*
   _tamCC   := len(trim(SA2->A2_NUMCON))

   _cCC   := substr(SA2->A2_NUMCON,1,_tamCC-1)  //alterado em 17/12/01
   _cCCDV := substr(SA2->A2_NUMCON,_tamCC,1)   //alterado em 17/12/01
*/

_cAGCC := "0"+STRZERO(VAL(_cAG),4)+_cAGDV+STRZERO(VAL(_cCC),12)+_cCCDV

RETURN(_cAGCC)
