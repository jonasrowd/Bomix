#Include 'Totvs.ch'

/*/{Protheus.doc} MT440LIB
	Redefinir a quantidade a ser liberada, s� funciona no autom�tico?
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 09/08/2021
	@return Logical, l_Ret, vari�vel de controle para prosseguir
	@see https://tdn.totvs.com/display/public/PROT/MT440LIB+-+Redefinir+quantidade+a+ser+liberada
/*/
User Function MT440LIB()
	
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
			Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Cliente: " + AllTrim(cNome)  + " Pedido: "+ SC9->C9_PEDIDO+", possui restri��es financeiras no total de R$ " ;
			+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a libera��o ao departamento comercial."})
		EndIf

		RestArea(cAlias)
	EndIf
	
Return lRet

/*/{Protheus.doc} estaLib
	Verifica se o pedido j� foi liberado anteriormente.
	@type Function
	@version 12.1.25
	@author Sandro Santos
	@since 04/08/2021
	@param _cPed, variant, N�mero do pedido capturado pelo ponto de entrada
	@return Logical, lOK, Controle de libera��o
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
