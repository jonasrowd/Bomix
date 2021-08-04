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
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return .T.
		endif


nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME
If nAtrasados <> 0 .AND. (!estaLib(SC5->C5_NUM))

	ShowHelpDlg(SM0->M0_NOME,;
	{"O Cliente: " + AllTrim(cNome)  + " Pedido: "+SC5->C5_NUM+", possui restrições financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
	{"Caso queira concluir a liberação deste pedido, solicite a liberação dos responsáveis."},5) 
	
	lRet := .F.
	
EndIf

RESTAREA(_CALIAS)	

Return (lRet)

/*/{Protheus.doc} estaLib
	Verifica se o pedido já foi liberado anteriormente.
	@type Function
	@version 12.1.25
	@author Sandro Santos
	@since 04/08/2021
	@param _cPed, variant, Número do pedido capturado pelo ponto de entrada
	@return Logical, lOK, Controle de liberação
/*/
Static Function estaLib(_cPed)
	
	Local lOK		:= .F.
	Default _cPed 	:= ''

	DbSelectArea('Z07')
	DbSetOrder(1)

	If DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)
		While Z07->(!Eof()) .And. SC5->C5_NUM  == Z07->Z07_PEDIDO
			If 'Venda' $ Z07->Z07_JUSTIF
				lOK := .T.
			EndIf
			Z07->(dbSkip())
		EndDo
	EndIf

Return (lOK)
