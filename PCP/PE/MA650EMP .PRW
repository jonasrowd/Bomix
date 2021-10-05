#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE "RWMAKE.CH"

USER FUNCTION MA650EMP()
    Local cOp    := SD4->D4_OP //SD4 está posicionada na ultima op gerada
    Local i := 0

    For i:=1 To Len(aCols)

        // Fecha a tabela de pedidos em aberto caso o alias esteja em uso
		If (Select("PEGALA") > 0)
			DBSelectArea("PEGALA")
			DBCloseArea()
		EndIf

        BEGINSQL ALIAS "PEGALA"
            SELECT 
                B1.B1_DESC AS BRITO, 
                B1.B1_BRTPPR AS BRITO1
            FROM  %TABLE:SD4% D4
                INNER JOIN %TABLE:SB1% B1 
                ON B1.B1_FILIAL = %XFILIAL:SB1%
                AND B1.%NOTDEL%
                AND B1.B1_COD = %EXP:aCols[i][1]%
            WHERE D4.D4_FILIAL = %XFILIAL:SD4%
                AND D4.%NOTDEL%
                AND D4.D4_QUANT <> 0
                AND D4.D4_OP = %EXP:cOp%
                AND D4.D4_COD = %EXP:aCols[i][1]%
        ENDSQL

        DbSelectArea("SD4")
        DbSetOrder(1)
        If dbSeek(FwXFilial("SD4")+aCols[i][1]+cOp)
            RecLock("SD4", .F.)
                SD4->D4_FSDSC := PEGALA->BRITO
                SD4->D4_FSTP  := PEGALA->BRITO1
            MsUnlock()
        EndIf
    Next

	// Gera um novo alias para a tabela temporária
	c_AliasAux := GetNextAlias()

	// Pesquisa pelos produtos que não devem
	// gerar Ordem de Produção
	BEGINSQL ALIAS c_AliasAux
		SELECT
			C2.C2_FILIAL  CFILAUX,
			C2.C2_NUM     CNUMAUX,
			C2.C2_ITEM    CITEMAUX,
			C2.C2_SEQUEN  CSEQAUX,
			C2.C2_PRODUTO CPRODAUX,
			B1.B1_BRTPPR  CBRITOAUX,
			C2.C2_LOCAL	  CLOCALAUX,
			C2.C2_QUANT	  CQUANTAUX,
			Z05.Z05_GERAOP CCARROAUX
		FROM
			%TABLE:SC2% C2
			INNER JOIN
				%TABLE:SB1% B1
				ON B1.B1_FILIAL = %XFILIAL:SB1%
				AND B1.B1_COD   = C2.C2_PRODUTO
				AND B1.%NOTDEL%
			INNER JOIN
				%TABLE:Z05% Z05
				ON Z05.Z05_FILIAL = %XFILIAL:Z05%
				AND Z05.Z05_NOME  = B1.B1_BRTPPR
				AND Z05.%NOTDEL%
		WHERE
			C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = %EXP:AllTrim(cOp)%
			AND Z05.Z05_GERAOP = 'N'
			AND C2.%NOTDEL%
	ENDSQL

	// Percorre os registros trazido pela query
	While (!EOF())
		// Monta a chave de busca da SD4
		c_Key := CFILAUX + CNUMAUX + CITEMAUX + CSEQAUX

		// Posiciona no Empenho
		DBSelectArea("SD4")
		DBSetOrder(2)
		DBSeek(c_Key)

		// Percorre os Empenhos da OP
		While (!EOF()) .AND. (AllTrim(D4_OP) == (c_AliasAux)->(CNUMAUX + CITEMAUX + CSEQAUX))
			// Realiza deleção virtual do Empenho
				RecLock("SD4", .F.)
					DBDelete()
				MsUnlock()
			// Salta para o próximo item do Empenho
			DBSkip()
		End

		// Reposiciona na tabela temporária para montagem
		// da chave de pesquisa do Empenho
		DBSelectArea(c_AliasAux)

		c_Key := CFILAUX + CNUMAUX + CITEMAUX + CSEQAUX

		// Posiciona na Ordem de Produção
		DBSelectArea("SC2")
		DBSetOrder(1)
		DBSeek(c_Key)
		// Realiza deleção virtual de Ordem de Produção
		If (Found())
			RecLock("SC2", .F.)
				DBDelete()
			MsUnlock()
		EndIf

		// Reposiciona na tabela temporária
		// para saltar para o registro
		DBSelectArea(c_AliasAux)
		DBSkip()
	End

Return
