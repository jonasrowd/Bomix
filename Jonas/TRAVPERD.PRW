#INCLUDE 'Totvs.ch'

/*
User Function TRAVPERD()

Local cProd := M->H6_QTDPROD
Local cPerd := M->H6_QTDPERD

IF IsInCallStack( "MATA681" )

    IF cProd > 0
       cPerd := 0
    ENDIF

    IF cPerd > 0
       cProd :=0
    ENDIF

ENDIF

RETURN ()

*/

User Function VLDPRDPE()

Local TudoOk := .T.
Local cProd := M->H6_QTDPROD
Local cPerd := M->H6_QTDPERD                                            


IF cProd > 0
   SH6->H6_QTDPERD:= 0
   TudoOk:=.F.   
   MsgAlert("Não é permitido apontar a perda junto com a produção!!!","Atenção!!")

ENDIF

IF cPerd > 0
   SH6->H6_QTDPROD:= 0
   TudoOk:= .T.   
   MsgAlert("Já foi!!")
ENDIF                                                      

Return(TudoOk)  


IIF(M->H6_QTDPROD>0,0,M->H6_QTDPERD)  
IIF(M->H6_QTDPERD>0,0,M->H6_QTDPROD)  
