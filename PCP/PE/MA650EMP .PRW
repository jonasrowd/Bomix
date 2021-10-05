#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE "RWMAKE.CH"

USER FUNCTION MA650EMP()
    Local cOp			:= SD4->D4_OP //SD4 está posicionada na ultima op gerada
    Local i				:= 0
	Local aMATA650		:= {} //-Array com os campos
    Local DDATABASE		:= DATE()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ 3 - Inclusao ³
    //³ 4 - Alteracao ³
    //³ 5 - Exclusao ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local nOpc 			:= 5
    Private lMsErroAuto := .F.

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
			aMATA650 := {;
                {'C2_FILIAL'    , CFILAUX   ,NIL},;
                {'C2_NUM'       , CNUMAUX   ,NIL},; 
                {'C2_ITEM'      , CITEMAUX  ,NIL},; 
                {'C2_SEQUEN'    , CSEQAUX   ,NIL},;
                {'C2_PRODUTO'   , CPRODAUX  ,NIL},;
                {'C2_LOCAL'     , CLOCALAUX ,NIL},;
                {'C2_QUANT'     , CQUANTAUX ,NIL},;
                {'C2_DATPRI'    , DDATABASE ,NIL},;
                {'C2_DATPRF'    , DDATABASE ,NIL},;
                {'AUTEXPLODE'   , "S"       ,NIL};
                }


    ConOut("Inicio : "+Time())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se alteracao ou exclusao, deve-se posicionar no registro ³
    //³ da SC2 antes de executar a rotina automatica ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpc == 4 .Or. nOpc == 5
        SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
        SC2->(DbSeek(xFilial("SC2")+aMATA650[2][2]+aMATA650[3][2]+aMATA650[4][2]))
    EndIf

    msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
    If !lMsErroAuto
        ConOut("Sucesso! ")
    Else
        ConOut("Erro!")
        MostraErro()
    EndIf

    ConOut("Fim : "+Time())
	DBSkip()
	End

Return
