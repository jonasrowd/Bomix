#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} Ma440VLD
Ponto de Entrada para valida��o das retri��es financeiras dos clientes na libera��o do pedido de venda
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_Ma440VLD()
/*/

user function Ma440VLD ()

	
Local lRet			:= .T.
Local nAtrasados 	:= 0
Local cNome 		:= ""
Local _CALIAS    	:= GETAREA()
Local c_UserLib 	:= GETMV("BM_USERLIB")

nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)/// SA1->A1_ATR
cNome := SA1->A1_NOME
If nAtrasados <> 0
	ShowHelpDlg(SM0->M0_NOME,;
	{"O Cliente: " + AllTrim(cNome)  + " Pedido: "+SC5->C5_NUM+", possue restri��es financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
	{"Caso queira concluir a libera��o deste pedido, solicite a libera��o dos respons�veis."},5) 
	
	lRet := .F.
	M->C5_BXSTATU

EndIf

If !lRet
	If  __CUSERID$(c_UserLib)
		If MsgYesNo ("O pedido encontra-se com bloqueio, devido a restri��o financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+", gostaria de realizar o desbloqueio?", "Aten��o")
						
			lRet := .T.
			M->C5_BXSTATU := 'A'	
		EndIf
		
	Endif
EndIf

If lRet .AND. !__CUSERID$(c_UserLib)

	M->C5_BXSTATU
Endif

RESTAREA(_CALIAS)
	
return lRet