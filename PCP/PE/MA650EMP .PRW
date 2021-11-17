#Include "Totvs.ch"
#Include "Ap5mail.ch"

/*/{Protheus.doc} MA650EMP
	Ponto de entrada desenvolvido para preencher campos personalizados na SD4
	e excluir as Op"s e Empenhos que não querem que gere.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 05/10/2021
/*/
User Function MA650EMP()

	Local i 		:= 0
	Local j			:= 0
	Local k			:= 0
	Local cOp		:= SD4->D4_OP				//SD4 está posicionada na ultima op gerada
	Local nOpc		:= 5 						//3 - Inclusao, 4 - Alteracao, 5 - Exclusao
	Local nPerc		:= 0						//Percentual de Master e Resina
	Local nTotal	:= 0						//Total Master+Resina
	Local nResori	:= 0						//Quantidade origem da Resina
	Local nMasori	:= 0						//Quantidade origem da Master
	Local aMATA650	:= {}						//-Array com os campos
	Local DDATABASE	:= DATE()
	Private lMsErroAuto := .F.

	For i := 1 To Len(aCols)
		// Fecha a tabela de pedidos em aberto caso o alias esteja em uso
		If (Select("BRITOALIAS") > 0)
			DbSelectArea("BRITOALIAS")
			DBCloseArea()
		EndIf

		//Query utilizada para buscar informações para atualizar campos customizados na tabela SD4 após a inclusão dos empenhos
		BEGINSQL ALIAS "BRITOALIAS"
			SELECT
				B1.B1_DESC AS BRITO, B1.B1_BRTPPR AS BRITO1, G1.G1_QUANT AS BRITO2, B1.B1_FSPESOP AS BRITO3, B1.B1_QB AS BRITO4
			FROM
				%TABLE:SD4% D4 (NOLOCK)
				INNER JOIN %TABLE:SB1% B1 (NOLOCK) ON B1.B1_FILIAL = %XFILIAL:SB1% AND B1.%NOTDEL% AND B1.B1_COD = %EXP:aCols[i][1]%
				LEFT JOIN %TABLE:SG1% G1 (NOLOCK) ON G1.G1_FILIAL=%XFILIAL:SG1% AND D4.%NOTDEL% AND G1.G1_COMP=%EXP:aCols[i][1]% AND G1.G1_COD=D4.D4_PRODUTO
			WHERE
				D4.D4_FILIAL = %XFILIAL:SD4% AND D4.%NOTDEL% AND D4.D4_QUANT <> 0 AND D4.D4_OP = %EXP:cOp% AND D4.D4_COD = %EXP:aCols[i][1]%
		ENDSQL

		//Posiciona no registro e atualiza os campos customizados a pedido de Brito
		DbSelectArea("SD4")
		DbSetOrder(1)
		If DbSeek(FWXFilial("SD4") + aCols[i][1] + cOp)
			RecLock("SD4", .F.)
				SD4->D4_FSDSC	:= BRITOALIAS->BRITO
				SD4->D4_FSTP	:= BRITOALIAS->BRITO1
				SD4->D4_FSQTDES := BRITOALIAS->BRITO2
				SD4->D4_FSPESO  := BRITOALIAS->BRITO3
				SD4->D4_FSQTDBS := BRITOALIAS->BRITO4
			MsUnlock()
		EndIf
	Next

	For j := 1 To Len(Acols)
		If "RESINA" $ AllTrim(Acols[j][14])
			nResori := nResori + Acols[j][2] //Soma se tiver mais de uma resina no Acols
		EndIf
		If "MASTER" $ Alltrim(Acols[j][14])
			nMasori := nMasori + Acols[j][2] //Soma caso algum dia tenha mais de uma master
		EndIf
	Next j

	nTotal := nResori + nMasori

	For k := 1 To Len(Acols)
		If ("MASTER" $ Alltrim(Acols[k][14]) .Or. "RESINA" $ Alltrim(Acols[k][14]))
			nPerc := ((Acols[k][2]) / nTotal) * 100 //Calcula o percentual de cada Master / resina
			DbSelectArea("SD4")
			DbSetOrder(1)
			DbSeek(FWXFilial("SD4") + Acols[k][1] + cOp)
			RecLock("SD4", .F.)
				SD4->D4_FSPM_R := Round(nPerc,2) //Grava no campo específico a proporção de cada item
			MsUnlock()
		EndIf
	Next k

	// Gera um novo alias para a tabela temporária, utilizei a mesma query que já havia feito para o consumo
	c_AliasAux := GetNextAlias()

	//Pesquisa pelos produtos que devem ser deletadas as ordens de produção a pedido da Bomix.
	//Aparentemente as estruturas e cadastros de produtos não seguem o padrão da Totvs,
	//gerando Op's de produtos que deveriam ser MP e que se fossem cadastradas corretamente não iriam gerar, assim como os parâmetros de geração de Op's.
	//Deixando claro que tentei argumentar sobre este processo, porém fui voto vencido.
	BEGINSQL ALIAS c_AliasAux
		SELECT
			C2.C2_FILIAL AS CFILAUX
			, C2.C2_NUM AS CNUMAUX
			, C2.C2_ITEM AS CITEMAUX
			, C2.C2_SEQUEN AS CSEQAUX
			, C2.C2_PRODUTO AS CPRODAUX
			, B1.B1_BRTPPR AS CBRITOAUX
			, C2.C2_LOCAL AS CLOCALAUX
			, C2.C2_QUANT AS CQUANTAUX
			, Z05.Z05_GERAOP AS CGERAOP
		FROM
			%TABLE:SC2% C2 (NOLOCK)
			INNER JOIN %TABLE:SB1% B1 ON B1.B1_FILIAL = %XFILIAL:SB1% AND B1.B1_COD = C2.C2_PRODUTO AND B1.%NOTDEL%
			INNER JOIN %TABLE:Z05% Z05 (NOLOCK) ON Z05.Z05_FILIAL = %XFILIAL:Z05% AND Z05.Z05_NOME  = B1.B1_BRTPPR AND Z05.%NOTDEL%
		WHERE
			C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = %EXP:AllTrim(cOp)% AND Z05.Z05_GERAOP = "N" AND C2.%NOTDEL% AND C2.C2_FILIAL= %XFILIAL:SC2%
	ENDSQL

	//Execauto para excluir as op's acima selecionadas
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
			SC2->(DbSetOrder(1)) //FILIAL + NUM + ITEM + SEQUEN
			SC2->(DbSeek(xFilial("SC2") + aMATA650[2][2] + aMATA650[3][2] + aMATA650[4][2]))
		EndIf

		//Execauto para rotina MATA650
		msExecAuto({|x,Y| Mata650(x,Y)}, aMATA650, nOpc)

		//Se Erro, apresenta mensagem para que o usuário possa nos informar
		If lMsErroAuto
			Help(NIL, NIL, "ERR_OP", NIL, "Erro na exclusão de Op's durante a geração.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Encaminhe o erro ao time de TI para acompanhar o processo."})
			MostraErro()
		EndIf

		DBSkip()
	End

Return (Nil)
