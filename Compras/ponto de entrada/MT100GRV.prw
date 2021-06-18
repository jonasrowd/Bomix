#include 'protheus.ch'
#include 'parmtype.ch'

user function MT100GRV()
Local cRat := M->D1_RATEIO
Local cConta := M->D1_CONTA
//local nResult
Local lRet:= .T.	

     if cRat = "2"  .and. EMPTY(cConta)
          Alert ("Favor preencher a conta contábil")
          lRet := .F. 
     elseIf cRat = "1"
          cConta := " "
          lRet:= .T.
     endif     
             
     
Return lRet


