// Bibliotecas necess�rias
#Include "TOTVS.ch"

/*/{Protheus.doc} FFATA001
	Job para manuten��o dos status dos pedidos de vendas
	@type Function
	@author R�mulo Ferreira
	@since 03/04/2021
	@version 12.1.25
/*/
User Function FFATA001()
	Local lAtualiza := .T. // Altera��o da cabe�alho do pedido de venda

	// Prepara��o do ambiente
	RPCSetEnv("01", "010101")
		// Fecha o alias da tabela tempor�ria, caso esteja aberto
		If (Select("C5TEMP") > 0)
			DBSelectArea(C5TEMP)
			DBCloseArea()
		EndIf

		// Realiza consulta para retorno do c�digo da filial
		// e o n�mero do pedido de venda
		BEGINSQL ALIAS "C5TEMP"
			SELECT DISTINCT
				C5_FILIAL FILIAL,
				C5_NUM NUM
			FROM
				SC5010 C5
			INNER JOIN
				SC6010 C6
			ON
				C5_FILIAL  = C6_FILIAL
				AND C5_NUM = C6_NUM
				AND C6.%NOTDEL%
			WHERE
				C5.%NOTDEL%
				AND C6_QTDENT < C6_QTDVEN
				AND (
					C5_NOTA       = ''
					OR C5_NOTA LIKE '%X'
				)
				AND C6_NUMORC  <> ''
				AND C5_LIBEROK <> 'E'
				AND C6_BLQ     <> 'R'
		ENDSQL

		// Posiciona a �rea corrente como C5TEMP
		DBSelectArea("C5TEMP")
		DBGoTop()

		// Percorre os registros trazidos pela query
		While (!EOF())
			// Posiciona no cabe�alho do pedido de venda
			DBSelectArea("SC5")
			DBSetOrder(1)
			DBSeek(C5TEMP->FILIAL + C5TEMP->NUM)

			// Fecha o alias da tabela tempor�ria, caso esteja aberto
			If (Select("E1TEMP") > 0)
				DBSelectArea("E1TEMP")
				DBCloseArea()
			EndIf

			// Realiza consulta para retorno da somat�ria
			// dos t�tulos � receber de um cliente
			BEGINSQL ALIAS "E1TEMP"
				SELECT
					SUM(E1_SALDO) VALOR
				FROM
					%TABLE:SE1% SE1
				WHERE
					E1_SALDO > 0
					AND E1_CLIENTE = %EXP:SC5->C5_CLIENTE%
					AND E1_LOJA    = %EXP:SC5->C5_LOJACLI%
					AND	SE1.%NOTDEL%
					AND	E1_TIPO = 'NF'
					AND	E1_VENCREA >= '20210101'
					AND E1_VENCREA < %EXP:DToS(dDataBase)%
					AND E1_SALDO <> E1_JUROS
			ENDSQL

			// Redefine a vari�vel de controle
			lAtualiza := .T.

			// Posiciona na tabela de libera��o de pedido
			DBSelectArea("Z07")
			DBSetOrder(1)
			DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)

			// Se o pedido o foi liberado anteriormente, define lAtualiza como "N�O ATUALIZA"
			If (Found())
				While (!EOF() .And. Z07_PEDIDO == SC5->C5_NUM)
					lAtualiza := !("VENDA" $ Upper(Z07_JUSTIF) .Or. "PRODU" $ Upper(Z07_JUSTIF))
					DBSkip()
				End
			EndIf

			// Se o pedido foi n�o liberado anteriormente, atualiza
			// os campos do cabe�alho do pedido de venda
			If (lAtualiza)
				DBSelecArea("SC5")
				RecLock("SC5", .F.)
					If (E1TEMP->(VALOR) != 0)
						C5_BXSTATU := "B"
						C5_BLQ     := "B"
						C5_LIBEROK := "S"
					Else
						C5_BXSTATU := "L"
						C5_BLQ     := " "
						C5_LIBEROK := "L"
					EndIf
				MsUnlock()
			EndIf

			// Posiciona a �rea corrente como C5TEMP
			DBSelectArea("C5TEMP")
			DBSkip()
		End
	RPCClearEnv() // Encerra o ambiente atual
Return (NIL)
