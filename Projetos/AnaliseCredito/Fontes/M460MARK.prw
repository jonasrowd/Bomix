//Bibliotecas necessárias
#Include 'Totvs.ch'

/*/{Protheus.doc} M460MARK
	Ponto de entrada para validação de pedidos marcados
	@type Function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 04/08/2021
	@return Logical, l_Ret
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784189
/*/
User Function M460MARK()

	Local lRet			:= .T.
	Local nAtrasados	:= 0
	Local cNome			:= ""
	Local _CALIAS    	:= GETAREA()

	If (FWCodFil() != '030101') .AND. cValToChar(DOW(DATE())) $ ('23456')
		nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
		cNome := SA1->A1_NOME
		
		If nAtrasados != 0 .AND. (!estaLib(SC5->C5_NUM))
			lRet := .F.
			Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Cliente: " + AllTrim(cNome)  + " Pedido: "+SC5->C5_NUM+", possui restrições financeiras no total de R$ " ;
			+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a liberação ao departamento comercial."})
		EndIf

		RestArea(_CALIAS)
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

	DbSelectArea('Z07')
	DbSetOrder(1)

	If DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)
		While Z07->(!Eof()) .And. SC5->C5_NUM == Z07->Z07_PEDIDO
			If 'Venda' $ Z07->Z07_JUSTIF .OR. 'Produ' $ Z07->Z07_JUSTIF .OR. 'Exped' $ Z07->Z07_JUSTIF
				lOK := .T.
			EndIf
			Z07->(dbSkip())
		End
	ElseIf SC5->C5_BXSTATU $ 'L|A' //POSSIVELMENTE INCLUIR O 'E'
		lOK := .T.
	Else
		lOK := .F.
	EndIf

Return (lOK)
