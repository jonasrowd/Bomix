//Bibliotecas necessárias
#Include 'Totvs.ch'

/*/{Protheus.doc} M460MARK
	Ponto de entrada para verificar os itens dos pedidos selecionados e atualizar os status
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 29/09/2021
	@return Logical, lLiber, se verdadeiro, permite o faturamento dos pedidos selecionados.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784189
/*/
User Function M460MARK()

	Local lLiber		:= .T.
    Local aArea		:= GetArea()
	Local aAreaSc5	:= SC5->(GetArea("SC5"))
	Local aAreaSc6	:= SC6->(GetArea("SC6"))
	Local aAreaSc9	:= SC9->(GetArea("SC9"))
	Local cMarca 	:= PARAMIXB[1] //Marca utilizada

	If (FWCodFil() != '030101') .AND. cValToChar(DOW(DATE())) $ ('23456') //Se não for a filial 03 e for dia da semana.

		//Verifica se o alias está aberto e o fecha caso esteja
		If Select("QRYSC9") > 0 
			DbSelectArea("QRYSC9")
			QRYSC9->(DbCloseArea())
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

		If lLiber
			While !QRYSC9->(EOF())
				//Verifica títulos em aberto ou se ouve liberação manual do pedido
				nAtrasados := u_FFATVATR(QRYSC9->CLIENTE, QRYSC9->LOJA)
				If (nAtrasados > 0 .Or. (!estaLib(QRYSC9->PEDIDO)))
					//Caso a condição seja .T. exibe mensagem com o número do pedido bloqueado e não permite o faturamento.
					lLiber := .F.
					Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Pedido: "+ QRYSC9->PEDIDO+" possui restrições financeiras no total de R$ " ;
						+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a liberação ao departamento comercial."})
				EndIf
				QRYSC9->(DbSkip())
			End
			QRYSC9->(dbCloseArea())
		EndIf

		//Atualiza o status do pedido se, e somente se, a liberação passe verdadeira
		If lLiber
			//Percorre os pedidos encontrados na Sc9 e verifica se é de cliente com títulos em aberto (FFATVATR) ou se ele já foi liberado anteriormente
			While !QRYSC9->(EOF())
				//Verifica se o alias está aberto e o fecha caso esteja
				If Select("cAliasSc6") > 0
					DbSelectArea("cAliasSc6")
					cAliasSc6->(DbCloseArea())
				EndIf

				//Percorre os itens da Sc6 para verificar com qual status irá salvar na Sc5
				BEGINSQL ALIAS "cAliasSc6"
					SELECT	DISTINCT
						C6_NUM AS PEDC6,
						C6_ITEM AS ITEM6,
						C6_QTDVEN AS VEN,
						C6_QTDENT AS ENT
					FROM
						%TABLE:SC6% C6
					WHERE
						C6_BLQ	<> 'R' AND 
						C6_FILIAL	= %XFILIAL:SC6% AND 
						C6_NUM	= %EXP:QRYSC9->PEDIDO% AND 
						%NOTDEL%
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
					 //Se a quantidade de venda for maior que a entregue e a entregue for maior que 0, pedido fica parcial
					ElseIf (cAliasSc6->VEN > cAliasSc6->ENT .And. cAliasSc6->ENT > 0)
						DbSelectArea("SC5")
						DbSetOrder(1)
						DbSeek(FwXFilial("SC5") + cAliasSc6->PEDC6)
						If Found()
							RecLock("SC5", .F.)
								SC5->C5_FSSTBI := 'PARCIAL'
								SC5->C5_BLQ     := ''
								SC5->C5_BXSTATU := 'A'
								SC5->C5_LIBEROK := ''
								EXIT
							MsUnlock()
						EndIf
					EndIf
					//Próximo item da Sc6
					cAliasSc6->(DbSkip())
				End
				//Fecha a área cAliasSc6
				cAliasSc6->(DbCloseArea())
				//Vai para o próximo registro da QRYSC9
				QRYSC9->(DbSkip())
			End
			//Fecha a área da QRYSC9
			QRYSC9->(dbCloseArea())
		EndIf
	EndIf

	RestArea(aArea)
	RestArea(aAreaSc5)
	RestArea(aAreaSc6)
	RestArea(aAreaSc9)

Return lLiber

/*/{Protheus.doc} estaLib
	Verifica se o pedido já foi liberado anteriormente.
	@type Function
	@version 12.1.25
	@author Jonas Machado
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
