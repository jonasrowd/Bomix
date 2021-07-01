#include 'protheus.ch'
#include 'parmtype.ch'

user function SDE100I()
Local cRat := AllTrim(M->D1_RATEIO)
Local cConta := AllTrim(M->D1_CONTA)
Local lRet := .T.	

If  (cRat = "2" .AND. EMPTY(cConta)) 
	     
	Alert ("Favor preencher a conta contábil")      		
		  lRet := .F.
else
      lRet := .T.  		
EndIf


RETURN lRet