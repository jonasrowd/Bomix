#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MAAVCRED
Ponto de Entrada para validação das retrições financeiras dos clientes, na Análise de Crédito Customizada dos Pedidos  
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MAAVCRED()
/*/

user function MAAVCRED()

Local _CALIAS    :=GETAREA()
Local c_UserLib := GETMV("BM_USERLIB")
Local cMensagem := ""
Local l_Ret := .T.

//nAtrasados := u_FFATVATR(SC5->C5_CLIENTE, SC5->C5_LOJACLI)//SA1->A1_ATR
nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
cNome := SA1->A1_NOME

If nAtrasados <> 0  

	If !__CUSERID$(c_UserLib)
		ShowHelpDlg(SM0->M0_NOME +" MAAVCRED",;
		{"O Cliente " + AllTrim(cNome) +"Pedido "+SC5->C5_NUM+", possui restrições financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
		{"Caso queira concluir a liberação deste pedido, solicite a liberação dos responsáveis."},5) 
	EndIf
	
	l_Ret := .F.	
	
		DbSelectArea("SC5")
	DbSetOrder(1)
	
	If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		RecLock("SC5", .F.)
			SC5->C5_BXSTATU := 'B'		//Bloqueado Financeiro
		MsUnlock()
	EndIf
	
EndIf

If !l_Ret 
	If  __CUSERID$(c_UserLib)

		cMensagem := "O pedido encontra-se com bloqueio, devido a restrição financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"# gostaria de realizar o desbloqueio?"
		If  u_BXMENATR(cMensagem,SC5->C5_CLIENTE, SC5->C5_LOJACLI)
		
			//MsgYesNo ("O pedido encontra-se com bloqueio, devido a restrição financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+" gostaria de realizar o desbloqueio?", "Atenção")

			l_Ret := .T. 
			
				
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

If l_Ret .AND. !__CUSERID$(c_UserLib)

	DbSelectArea("SC5")
	DbSetOrder(1)		
	If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		RecLock("SC5", .F.)
			SC5->C5_BXSTATU := ''		//Bloqueado Financeiro
		MsUnlock()
	EndIf
	
Endif
RESTAREA(_CALIAS)

	
return l_Ret
	