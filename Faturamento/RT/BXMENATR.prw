#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} BXMENATR
Fun��o que inclui tela para, valida��o / visualiza��o da composi��o do saldo devedor / inclus�o / Bloqueio de an�lise de cr�dito dos cientes
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_BXMENATR()
/*/

user function BXMENATR(pMensagem, pCliente, pLoja)
	
Local oBtnOK
Local oBtnCancel
Local lRet := .F.
Local xLinha := 40
Public oDlg


DEFINE MSDIALOG oDlg TITLE OemToAnsi("Aten��o") FROM 000,000 TO 180,550 PIXEL
	@ 010, 010 Say OemToAnsi(substr(pMensagem,1,at('#',pMensagem)-1)) PIXEL
	@ 020, 010 Say OemToAnsi(substr(pMensagem,at('#',pMensagem)+1,len(pMensagem))) PIXEL
	oBtnOK 		 := TButton():New(060,010+xLinha,"Visualizar",oDlg,{||u_BXVISATR(pCliente,pLoja)},50,20,,,,.T.,,"",,,,.F.)
	oBtnLiberar  := TButton():New(060,070+xLinha,"Liberar",oDlg,{||lRet := .T., oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
	oBtnCancel   := TButton():New(060,130+xLinha,"N�o Liberar",oDlg,{||lRet:= .F., oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
ACTIVATE MSDIALOG oDlg CENTERED



Return  lRet