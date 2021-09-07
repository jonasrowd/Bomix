#Include 'Totvs.ch'

/*/{Protheus.doc} MT440AT
	Permite impedir a liberação do pedido de venda.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@return Logical, l_Ret, Controle lógico para liberação
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784362
/*/
User Function MT440AT()

	Local lRet			:= .T.
	Local nAtrasados	:= 0
	Local cNome			:= ""
	Local cAlias    	:= GETAREA()

	DBSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(FWxFilial("SA1")+SC9->C9_CLIENTE + SC9->C9_LOJA)

	If (FWCodFil() != '030101') .AND. cValToChar(DOW(DATE())) $ ('23456')
		nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
		cNome := SA1->A1_NOME

		If nAtrasados > 0 .AND. (!estaLib(SC9->C9_PEDIDO))
			lRet := .F.
			Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Cliente: " + AllTrim(cNome)  + " Pedido: "+ SC9->C9_PEDIDO+", possui restrições financeiras no total de R$ " ;
			+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a liberação ao departamento comercial."})
		EndIf

		RestArea(cAlias)
	EndIf
	
Return lRet

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
	
	Local lOK	  := .F.
	Default _cPed := ''

	DBSelectArea("SC5")
	DBSetOrder(1)
	DBSeek(FwXFilial("SC5") + _cPed)

	DbSelectArea('Z07')
	DbSetOrder(1)
	If DBSeek(FWXFILIAL('Z07') + _cPed)
		While Z07->(!Eof()) .And. _cPed == Z07->Z07_PEDIDO
			If 'Venda' $ Z07->Z07_JUSTIF .OR. 'Exped' $ Z07->Z07_JUSTIF
				lOK := .T.
			EndIf
			Z07->(dbSkip())
		End
	ElseIf SC5->C5_BXSTATU $ 'L|A|E'
		lOK := .T.
	Else
		lOK := .F.
	EndIf

Return (lOK)

