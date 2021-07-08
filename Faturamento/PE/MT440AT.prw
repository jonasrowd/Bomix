#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MT440AT
Ponto de Entrada para validação das retrições financeiras dos clientes na liberação do pedido de venda
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MT440AT()
/*/

user function MT440AT()

Local lRet:= .T.	
Local nAtrasados := 0
Local cNome := ""
Local _CALIAS    :=GETAREA()
Local c_UserLib := GETMV("BM_USERLIB")


nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME
If nAtrasados <> 0

	ShowHelpDlg(SM0->M0_NOME,;
	{"O Cliente: " + AllTrim(cNome)  + " Pedido: "+SC5->C5_NUM+", possue restrições financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
	{"Caso queira concluir a liberação deste pedido, solicite a liberação dos responsáveis."},5) 
	
	lRet := .F.
	DbSelectArea("SC5")
	DbSetOrder(1)
	
	If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		RecLock("SC5", .F.)
			SC5->C5_BXSTATU := 'B'		//Bloqueado Financeiro
		MsUnlock()
	EndIf

EndIf

If !lRet
	If  __CUSERID$(c_UserLib)
	  If MsgYesNo ("O pedido encontra-se com bloqueio, devido a restrição financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+", gostaria de realizar o desbloqueio?", "Atenção")	
			lRet := .T.			
			DbSelectArea("SC5")
			DbSetOrder(1)
			
			If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
				RecLock("SC5", .F.)
					SC5->C5_BXSTATU := 'A'		//Bloqueado Financeiro
				MsUnlock()
			EndIf
		
		EndIf
		
	Endif
EndIf

If lRet .AND. !__CUSERID$(c_UserLib)

	DbSelectArea("SC5")
	DbSetOrder(1)		
	If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		RecLock("SC5", .F.)
			SC5->C5_BXSTATU := ''		//Bloqueado Financeiro
		MsUnlock()
	EndIf
Endif

RESTAREA(_CALIAS)	

return lRet
