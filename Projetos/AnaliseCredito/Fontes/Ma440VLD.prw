#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} Ma440VLD
	Valida se o cliente est� devendo e se n�o foi liberado anteriormente.
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 09/08/2021
	@return Logical, Se verdadeiro, deixa prosseguir, sen�o, apresenta o Help.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784532
/*/
User Function Ma440VLD()

	Local lRet			:= .T.
	Local nAtrasados	:= 0
	Local cNome			:= ""
	Local _CALIAS    	:= GETAREA()

	If (FWCodFil() != '030101') .AND. cValToChar(DOW(DATE())) $ ('3456')
		nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
		cNome := SA1->A1_NOME
		
		If nAtrasados != 0 .AND. (!estaLib(SC5->C5_NUM))
			lRet := .F.
			Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Cliente: " + AllTrim(cNome)  + " Pedido: "+SC5->C5_NUM+", possui restri��es financeiras no total de R$ " ;
			+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a libera��o ao departamento comercial."})
		EndIf

		RestArea(_CALIAS)
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

	DbSelectArea('Z07')
	DbSetOrder(1)

	If DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)
		While Z07->(!Eof()) .And. SC5->C5_NUM == Z07->Z07_PEDIDO
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
