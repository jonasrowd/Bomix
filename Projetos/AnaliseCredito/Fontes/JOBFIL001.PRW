// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} FFATA001
	Realiza a manutenção dos status dos pedidos de vendas bloqueando
	ou liberando o cliente em caso de inadimplência
	@type Function
	@author Rômulo Ferreira
	@since 03/04/2021
	@param cBranch, Character, Filial do sistema que será executado o job
	@version 12.1.25
/*/
User Function FFATA001(cBranch)
	Local lAtualiza := .T. // Alteração da cabeçalho do pedido de venda

	// Definição padrão de filial
	Default cBranch := "010101"

	// Preparação do ambiente
	RPCSetType(3)
	RPCSetEnv("01", cBranch)
		// Fecha o alias da tabela temporária, caso esteja aberto
		If (Select("C5TEMP") > 0)
			DBSelectArea(C5TEMP)
			DBCloseArea()
		EndIf

		// Realiza consulta para retorno do código da filial
		// e o número do pedido de venda
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

		// Posiciona a área corrente como C5TEMP
		DBSelectArea("C5TEMP")
		DBGoTop()

		// Percorre os registros trazidos pela query
		While (!EOF())
			// Posiciona no cabeçalho do pedido de venda
			DBSelectArea("SC5")
			DBSetOrder(1)
			DBSeek(C5TEMP->FILIAL + C5TEMP->NUM)

			// Fecha o alias da tabela temporária, caso esteja aberto
			If (Select("E1TEMP") > 0)
				DBSelectArea("E1TEMP")
				DBCloseArea()
			EndIf

			// Realiza consulta para retorno da somatória
			// dos títulos à receber de um cliente
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

			// Redefine a variável de controle
			lAtualiza := .T.

			// // Posiciona na tabela de liberação de pedido
			// DBSelectArea("Z07")
			// DBSetOrder(1)
			// DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)

			// // Se o pedido o foi liberado anteriormente, define lAtualiza como "NÃO ATUALIZA"
			// If (Found())
			// 	While (!EOF() .And. Z07_PEDIDO == SC5->C5_NUM)
			// 		lAtualiza := !("VENDA" $ Upper(Z07_JUSTIF) .Or. "PRODU" $ Upper(Z07_JUSTIF))
			// 		DBSkip()
			// 	End
			// EndIf

			// Se o pedido foi não liberado anteriormente, atualiza
			// os campos do cabeçalho do pedido de venda
			If (lAtualiza)
				DBSelectArea("SC5")
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

			// Posiciona a área corrente como C5TEMP
			DBSelectArea("C5TEMP")
			DBSkip()
		End
	RPCClearEnv() // Encerra o ambiente atual
Return (NIL)
