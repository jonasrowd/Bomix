//Bibliotecas necess�rias
#Include 'Totvs.ch'

/*/{Protheus.doc} M460MARK
	Ponto de entrada para valida��o de pedidos marcados
	@type Function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 04/08/2021
	@return Logical, l_Ret
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784189
/*/
User Function M460MARK()

	Local l_Ret		 := .T.
	Local _cAlias    := GetArea()
	Local nAtrasados := U_FFATVATR(SA1->A1_COD,SA1->A1_LOJA) //Valida se h� t�tulos em aberto

	If !FWCodFil() = '030101' //Se n�o for filial 03, segue o fonte

		DbSelectArea('SC9')
		DbSetOrder(1)

		If nAtrasados != 0 .And. (!estaLib(SC5->C5_NUM)) //Verifica se h� pedidos em atraso e j� n�o foi liberado anteriormente, n�o deixa passar
			l_Ret := .F.
			Help(NIL, NIL, 'CLI_BLOCKED', NIL, 'O Cliente ' + AllTrim(SA1->A1_NOME)  + 'Pedido ' + SC5->C5_NUM + ;
				', possui restri��es financeiras no total de R$ ' + AllTrim(Transform(nAtrasados,'@e 9,999,999,999,999.99')) + '.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Caso queira concluir a libera��o deste pedido, solicite a libera��o do setor comercial.'})
		Else
			l_Ret := .T.
			DbSelectArea('SC9')
			DbSetOrder(1)

			If (DBSeek(FwXFilial('SC9') + SC5->C5_NUM)) //Se j� est� liberado
				RecLock('SC9', .F.)
				SC9->C9_BLCRED := ''
				MsUnlock()
			EndIf
		EndIf
	EndIf

	RestArea(_cAlias)

Return(lRet)

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
