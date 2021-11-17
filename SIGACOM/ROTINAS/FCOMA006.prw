#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE "Ap5mail.ch"

#DEFINE ENTER CHR(13) + CHR(10)

Static cTempPath := AllTrim(GetTempPath())

User Function FCOMA006()
Local  c_Docto :=	SC7->C7_NUM
Local c_ChvSA2 := 	xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA
Local a_SC7Area:=	SC7->(GetArea())
Local a_SC2Area:=	SC2->(GetArea())
Local l_AdicCamp:= .F.
Local c_Body
Local l_Visualiza	:=	.F. //msgYesNo("Visualiza Pedido no navegador?","Aten��o")
Local c_Patch		:=	""		
SA2->(dbSetOrder(1))
If SA2->(dbSeek(c_ChvSA2,.T.))
	If !l_Visualiza
		If SA2->(!Empty(A2_EMAIL))
			If msgYesNo("Confirma Envio de E-mail deste pedido para o fornecedor ?","Envio de e-mail")
				l_AdicCamp 	:= 	.F.
				c_Patch		:=	cTempPath
				u_PCOMR003(l_AdicCamp,c_Patch)
	
				c_Body	:= "Prezado " + Alltrim( Capital( SA2->A2_NREDUZ ) ) + ",<br/><br/>" + ENTER
				c_Body	+= "O pedido de compra " + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + " em anexo foi liberado e aguardamos o seu envio.<br/><br/>" + ENTER
				c_Body	+= "Grato, <br/>" + SM0->M0_NOMECOM
			
				//c_Patch	:= "\system\"
				
				c_Anexo	:= c_Patch + "pedido_" + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + ".pdf"
				U_TBSENDMAIL( SA2->A2_EMAIL, c_Body, "BOMIX :: Pedido de compra liberado - " + Padr( c_Docto, TamSX3("C7_NUM")[1] ), .F., c_Anexo )
				//FERASE(c_Anexo)
	
				msginfo("E-Mail enviado !","Aten��o")
			
			Else
				msginfo("E-Mail n�o enviado !","Aten��o")
				
			Endif
		Else
			msgInfo("E-mail do Fornecedor n�o est� cadastrado. E-mail n�o ser� enviado.")
		Endif
	Else
		l_AdicCamp := msgYesNo("Deseja Visualizar campos adicionais de Data e �ltimo pre�o)? ","Aten��o")
		c_Patch	:= cTempPath	
		u_PCOMR003(l_AdicCamp, c_Patch)
		c_Anexo	:= c_Patch + "pedido_" + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + ".html"
		ShellExecute("open",c_Anexo,"","",SW_SHOWMAXIMIZED)
		//FERASE(c_Anexo)
	Endif
Else
	msgInfo("Fornecedor n�o encontrado com a chave ["+c_ChvSA2+"]. E-mail n�o ser� enviado.")

Endif
RestArea(a_SC7Area)
RestArea(a_SC2Area)

Return