#Include 'Totvs.ch'

/*/{Protheus.doc} MA650EMP
	Ponto de entrada desenvolvido para preencher campos personalizados na SD4
	e excluir as Op's e Empenhos que não querem que gere.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 05/10/2021
/*/
User Function MA650EMP()

    Local i,j,k			:= 0
    Local nOpc 			:= 5 //3 - Inclusao, 4 - Alteracao, 5 - Exclusao
    Local cOp			:= SD4->D4_OP //SD4 está posicionada na ultima op gerada
	Local cProd			:= SD4->D4_PRODUTO
	Local aMATA650		:= {} //-Array com os campos
    Local DDATABASE		:= DATE()
    Local nResori 		:= 0   //Quantidade origem da Resina
    Local nMasori 		:= 0   //Quantidade origem da Master
    Local nTotal  		:= 0   //Total Master+Resina
    Local nPerc   		:= 0   //Percentual de Master e Resina
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
                B1.B1_BRTPPR AS BRITO1,
				G1.G1_QUANT AS BRITO2
            FROM  %TABLE:SD4% D4 (NOLOCK)
                INNER JOIN %TABLE:SB1% B1 (NOLOCK)
                ON B1.B1_FILIAL = %XFILIAL:SB1%
                AND B1.%NOTDEL%
                AND B1.B1_COD = %EXP:aCols[i][1]%
				LEFT JOIN %TABLE:SG1% G1 (NOLOCK)
				ON G1.G1_FILIAL=%XFILIAL:SG1% AND
				D4.%NOTDEL% AND G1.G1_COMP=%EXP:aCols[i][1]%
				AND G1.G1_COD=D4.D4_PRODUTO
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
				SD4->D4_FSQTDES := PEGALA->BRITO2
            MsUnlock()
        EndIf

		DBSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(FWXFILIAL("SB1")+cProd)
		If Found()
			cPeso := SB1->B1_FSPESOP
			cQb	  := SB1->B1_QB
		EndIf

        DbSelectArea("SD4")
        DbSetOrder(1)
        If dbSeek(FwXFilial("SD4")+aCols[i][1]+cOp)
            RecLock("SD4", .F.)
                SD4->D4_FSPESO  := cPeso
				SD4->D4_FSQTDBS := cQb
            MsUnlock()
        EndIf
    Next

	For j:=1 to Len(Acols)
		If "RESINA" $ AllTrim(Acols[j][14])
			nResori := nResori + Acols[j][2] //Soma se tiver mais de uma resina no Acols
		EndIf
		If "MASTER" $ Alltrim(Acols[j][14])
			nMasori := nMasori + Acols[j][2] //Soma caso algum dia tenha mais de uma master
		EndIf
	Next j

	nTotal := nResori + nMasori

	For k:=1 to Len(Acols)
		If ("MASTER" $ Alltrim(Acols[k][14]) .Or. "RESINA" $ Alltrim(Acols[k][14]))
			nPerc := ((Acols[k][2]) / nTotal) * 100 //Calcula o percentual de cada Master / resina
			DbSelectArea("SD4")
			DbSetOrder(1)
			DbSeek(FwXFilial("SD4") + Acols[k][1] + cOp)
			RecLock("SD4", .F.)
				SD4->D4_FSPM_R := Round(nPerc,2) //Grava no campo específico a proporção de cada item
			MsUnlock()
		EndIf
	Next k

	// Gera um novo alias para a tabela temporária
	c_AliasAux := GetNextAlias()

	// Pesquisa pelos produtos que não devem
	// gerar Ordem de Produção
	BEGINSQL ALIAS c_AliasAux
		SELECT
			C2.C2_FILIAL   CFILAUX  ,
			C2.C2_NUM      CNUMAUX  ,
			C2.C2_ITEM     CITEMAUX ,
			C2.C2_SEQUEN   CSEQAUX  ,
			C2.C2_PRODUTO  CPRODAUX ,
			B1.B1_BRTPPR   CBRITOAUX,
			C2.C2_LOCAL	   CLOCALAUX,
			C2.C2_QUANT	   CQUANTAUX,
			Z05.Z05_GERAOP CCARROAUX
		FROM
			%TABLE:SC2% C2 (NOLOCK)
			INNER JOIN
				%TABLE:SB1% B1
				ON B1.B1_FILIAL = %XFILIAL:SB1%
				AND B1.B1_COD   = C2.C2_PRODUTO
				AND B1.%NOTDEL%
			INNER JOIN 
				%TABLE:Z05% Z05 (NOLOCK)
				ON Z05.Z05_FILIAL = %XFILIAL:Z05%
				AND Z05.Z05_NOME  = B1.B1_BRTPPR
				AND Z05.%NOTDEL%
		WHERE
			C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = %EXP:AllTrim(cOp)%
			AND Z05.Z05_GERAOP = 'N'
			AND C2.%NOTDEL%
			AND C2.C2_FILIAL= %XFILIAL:SC2%
	ENDSQL

	//Execauto para excluir as op's e empenhos 
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

    // Se alteracao ou exclusao, deve-se posicionar no registro da SC2 antes de executar a rotina automática
    If nOpc == 4 .Or. nOpc == 5
        SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
        SC2->(DbSeek(xFilial("SC2")+aMATA650[2][2]+aMATA650[3][2]+aMATA650[4][2]))
    EndIf

    msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)

	//Se Erro, apresenta mensagem para que o usuário possa nos informar
    If lMsErroAuto
		Help(NIL, NIL, 'ERR_OP', NIL, 'Erro na inclusão do Empenho e Op.',;
			1, 0, NIL, NIL, NIL, NIL, NIL, {'Encaminhe esta Op ao time de TI para acompanhar o processo.'})
        MostraErro()
    EndIf

	DBSkip()
	End

Return (Nil)
