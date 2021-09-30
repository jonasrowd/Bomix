//Bibliotecas necess�rias
#Include 'Totvs.ch'

/*/{Protheus.doc} M460MARK
	Ponto de entrada para verificar os itens dos pedidos selecionados e atualizar os status
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 29/09/2021
	@return Logical, l_Ret
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784189
/*/
User Function M460MARK()

	Local lRet		:= .T.
    Local aArea		:= GetArea()
	Local aAreaSc5	:= SC5->(GetArea("SC5"))
	Local aAreaSc6	:= SC6->(GetArea("SC6"))
	Local aAreaSc9	:= SC9->(GetArea("SC9"))
	Local cMarca 	:= PARAMIXB[1] //Marca utilizada

	If (FWCodFil() != '030101') .AND. cValToChar(DOW(DATE())) $ ('23456') //Se n�o for a filial 03 e for dia da semana.

		//Verifica se o alias est� aberto e o fecha caso esteja
		If Select("QRYSC9") > 0 
			DbSelectArea("QRYSC9")
			DbCloseArea()
		EndIf
		
		//Seleciona os pedidos de venda com a Marca do ParamIxb[1]
		BEGINSQL ALIAS "QRYSC9"

			SELECT DISTINCT
				C9_PEDIDO AS PEDIDO,
				C9_CLIENTE AS CLIENTE,
				C9_LOJA AS LOJA
			FROM
				%TABLE:SC9%
			WHERE
				C9_OK = %EXP:cMarca% AND
				%NOTDEL% AND
				C9_FILIAL = %XFILIAL:SC9%
		ENDSQL

		//Percorre os pedidos encontrados na Sc9 e verifica se � de cliente com t�tulos em aberto (FFATVATR) ou se ele j� foi liberado anteriormente
		While !QRYSC9->(EOF())
			nAtrasados := u_FFATVATR(QRYSC9->CLIENTE, QRYSC9->LOJA)
			If (nAtrasados > 0 .Or. (!estaLib(QRYSC9->PEDIDO)))
				lRet := .F.
				Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Pedido: "+ QRYSC9->PEDIDO+" possui restri��es financeiras no total de R$ " ;
					+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a libera��o ao departamento comercial."})
			Else
				//Verifica se o alias est� aberto e o fecha caso esteja
				If Select("cAliasSc6") > 0
					DbSelectArea("cAliasSc6")
					DbCloseArea()
				EndIf

				//Percorre os itens da Sc6 para verificar com qual status ir� salvar na Sc5
				BEGINSQL ALIAS "cAliasSc6"
					SELECT	DISTINCT
						C6_NUM AS PEDC6,
						C6_ITEM AS ITEM6,
						C6_QTDVEN AS VEN,
						C6_QTDENT AS ENT
					FROM
						%TABLE:SC6% C6
					WHERE
						C6_BLQ	<> 'R'
						AND C6_FILIAL	= %XFILIAL:SC6%
						AND C6_NUM	= %EXP:QRYSC9->PEDIDO%
						AND %NOTDEL%
				ENDSQL

				//Percorre os itens do pedido de venda
				While !cAliasSc6->(EOF())
					
					//Se a quantidade de venda for exatamente igual ao faturado o pedido fica encerrado
					If cAliasSc6->VEN == cAliasSc6->ENT .And. cAliasSc6->ITEM6 == cAliasSc6->ITEM6
						DbSelectArea("SC5")
						DbSetOrder(1)
						DbSeek(FwXFilial("SC5") + cAliasSc6->PEDC6)
						If Found()
							RecLock("SC5", .F.)
								SC5->C5_FSSTBI := 'ENCERRADO'
								SC5->C5_BLQ     := ''
								SC5->C5_BXSTATU := ''
								SC5->C5_LIBEROK := 'E'
							MsUnlock()
						EndIf
					EndIf
					//Pr�ximo item da Sc6
					cAliasSc6->(DbSkip())
				End
				
				cAliasSc6->(DbGoTop())
				//Fiz este While redundante para evitar utilizar o Exit no parcial e testar se ele procurando duas vezes, ele grava correto.
				While !cAliasSc6->(EOF())
					If (cAliasSc6->VEN > cAliasSc6->ENT .And. cAliasSc6->ENT > 0)
						DbSelectArea("SC5")
						DbSetOrder(1)
						DbSeek(FwXFilial("SC5") + cAliasSc6->PEDC6)
						If Found()
							RecLock("SC5", .F.)
								SC5->C5_FSSTBI := 'PARCIAL'
								SC5->C5_BLQ     := ''
								SC5->C5_BXSTATU := 'A'
								SC5->C5_LIBEROK := ''
							MsUnlock()
						EndIf
					EndIf
					//Pr�ximo item da Sc6
					cAliasSc6->(DbSkip())
				End
			EndIf
			QRYSC9->(DbSkip())
		End
		QRYSC9->(dbCloseArea())
	EndIf

	RestArea(aArea)
	RestArea(aAreaSc5)
	RestArea(aAreaSc6)
	RestArea(aAreaSc9)

Return lRet

/*/{Protheus.doc} estaLib
	Verifica se o pedido j� foi liberado anteriormente.
	@type Function
	@version 12.1.25
	@author Jonas Machado
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
