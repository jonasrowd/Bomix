/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTDGPERD/DIGPEROK  ºAutor  ³ Christian Rocha    º    ³     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ MDDGPERD - Ponto de entrada para preencher campos da	  	  º±±
±±º          ³ Classificação da Perda na Produção PCP Mod2				  º±±
±±ºDesc.     ³ DIGPEROK - Ponto de entrada para validar as informações da º±±
±±º          ³ Classificação da Perda na Produção PCP Mod2				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAPCP													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTDGPERD
	Local a_Area  := FwGetArea() // 
	Local c_Prod  := PARAMIXB[1] // 
	Local c_OP    := PARAMIXB[2] // 
	Local n_Size  := 0           // 
	Local n_Count := 0

	// Carrega as informações de perda da master
	Table01Def(c_OP)

	// Percorre os itens da master
	While (!MASTER->(EOF()))
		// Incrementa o contador
		n_Count++

		// Adiciona nova linha no aCols
		If (n_Count > 1)
			AddNewLine()
		EndIf

		// Preenche os campos da primeira linha
		n_Size := Len(aCols)
		GDFieldPut("BC_PRODUTO", c_Prod, n_Size)
		GDFieldPut("BC_CODDEST", MASTER->B1_FSPRODC, n_Size)
		GDFieldPut("BC_DTVALID", dDatabase, n_Size)

		// Carrega as informações de perda da resina
		Table02Def(MASTER->B1COR, MASTER->B1_SERIE)

		// Percorre os itens da resina
		While (!ESPEC->(EOF()))
			// Adiciona uma nova linha no aCols
			AddNewLine()
			n_Size := Len(aCols)

			// Preenche os campos da primeira linha
			GDFieldPut("BC_PRODUTO", c_Prod, n_Size)
			GDFieldPut("BC_CODDEST", ESPEC->B1_COD, n_Size)
			GDFieldPut("BC_DTVALID", dDatabase, n_Size)

			// Salta para o próximo registro de resina
			ESPEC->(DBSkip())
		End

		// Salta para o próximo registro da master
		MASTER->(DBSkip())
	End

	// Fecha o alias do produto móido
	If (Select("ESPEC") > 0)
		DBSelectArea("ESPEC")
		DBCloseArea()
	EndIf

		// Fecha o alias da master
	If (Select("MASTER") > 0)
		DBSelectArea("MASTER")
		DBCloseArea()
	EndIf

	// Restaura a área de trabalho anterior
	FwRestArea(a_Area)
Return (NIL)

/*/{Protheus.doc} Table01Def
	Monta tabela temporária que trás o produto de perda (MASTER e RESINA)
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 21/09/2021
	@param c_OP, Character, Número da OP
/*/
Static Function Table01Def(c_OP)
	Local aArea := FwGetArea() // Armazena a área corrente

	// Fecha o alias se ele já estiver em uso
	If (Select("MASTER") > 0)
		DBSelectArea("MASTER")
		DBCloseArea()
	EndIf

	// Realiza a consulta SQL
	BEGINSQL ALIAS "MASTER"
		SELECT TOP 100
			C2_NUM + C2_ITEM + C2_SEQUEN AS OP,
			C2_PRODUTO,
			B12.B1_FSPRODC,
			B12.B1_PESO,
			D4.D4_FSTP AS D4RESINA,
			B1.B1_DESC AS B1DESCRICAORESINA,
			D4.D4_COD,
			B1.B1_SERIE,
			D4_MASTER.D4_FSTP AS D4TIPOMASTER,
			D4_MASTER.D4_COD AS B1MASTER_ID,
			D4_MASTER.D4_FSDSC AS D4MASTER,
			B1_MASTER.B1_SERIE AS B1COR
		FROM
			%TABLE:SC2% C2 (NOLOCK)
			INNER JOIN
				%TABLE:SB1% B12 (NOLOCK)
				ON B12.B1_FILIAL = %XFILIAL:SB1%
				AND B12.B1_COD   = C2_PRODUTO
				AND B12.%NOTDEL%
			INNER JOIN
				%TABLE:SD4% D4 (NOLOCK)
				ON D4_FILIAL = %XFILIAL:SD4%
				AND D4_OP    = C2_NUM + C2_ITEM + C2_SEQUEN
				AND D4_FSTP  = 'RESINA'
				AND D4.%NOTDEL%
			INNER JOIN
				%TABLE:SB1% B1 (NOLOCK)
				ON B1.B1_FILIAL = %XFILIAL:SB1%
				AND B1.B1_COD   = D4.D4_COD
				AND B1.%NOTDEL%
			LEFT JOIN
				%TABLE:SD4% D4_MASTER (NOLOCK)
				ON D4_MASTER.D4_FILIAL = %XFILIAL:SD4%
				AND D4_MASTER.D4_OP    = C2_NUM + C2_ITEM + C2_SEQUEN
				AND D4_MASTER.D4_FSTP  = 'MASTER'
				AND D4_MASTER.%NOTDEL%
			LEFT JOIN
				%TABLE:SB1% B1_MASTER (NOLOCK)
				ON B1_MASTER.B1_FILIAL = %XFILIAL:SB1%
				AND B1_MASTER.B1_COD   = D4_MASTER.D4_COD
				AND B1_MASTER.%NOTDEL%
		WHERE
			C2_FILIAL                        = %XFILIAL:SC2%
			AND C2_NUM + C2_ITEM + C2_SEQUEN = %EXP:AllTrim(c_OP)%
			AND C2.%NOTDEL%
		ORDER BY
			C2.R_E_C_N_O_ DESC
	ENDSQL

	// Restaura a área anterior
	FwRestArea(aArea)
Return (NIL)

/*/{Protheus.doc} Table02Def
	Monta tabela temporária que trás o material moído da perda
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 21/09/2021
	@param c_Serie, Character, Série da resina
	@param c_Cor, Character, Cor da master
/*/
Static Function Table02Def(c_Serie, c_Cor)
	Local aArea := FwGetArea() // Armazena a área corrente

	// Prepara os valores para inserção na query
	c_Cor   := "%'%" + AllTrim(c_Cor) + "%'%"
	c_Serie := "%'%" + AllTrim(c_Serie) + "%'%"

	// Fecha o alias se ele já estiver em uso
	If (Select("ESPEC") > 0)
		DBSelectArea("ESPEC")
		DBCloseArea()
	EndIf

	// Realiza a consulta SQL
	BEGINSQL ALIAS "ESPEC"
		SELECT
			B1_COD,
			B1_DESC,
			B1_SERIE,
			B1_MSBLQL
		FROM
			%TABLE:SB1%
		WHERE
			B1_BRTPPR   LIKE 'MATERIAL MOIDO'
			AND B1_DESC LIKE %EXP:c_Serie%
			AND B1_DESC LIKE %EXP:c_Cor%
	ENDSQL

	// Restaura a área anterior
	FwRestArea(aArea)
Return (NIL)

/*/{Protheus.doc} AddNewLine
	Adiciona uma nova linha no aCols segundo a estrutura de aHeader
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 21/09/2021
/*/
Static Function AddNewLine()
	Local nX    := 0 // Contador de campos do aHeader
	Local nSize := 0 // Tamanho atual do aCols

	// Adiciona uma posição vazia no aCols e conta o tamanho
	AAdd(aCols, {})
	nSize := Len(aCols)

	// Monta uma nova linha baseado na estrutura
	For nX := 1 To Len(aHeader)
		If (!AllTrim(aHeader[nX][2]) $ "BC_ALI_WT|BC_REC_WT") // Se não for os campos BC_ALI_WT ou BC_REC_WT, segue normal
			AAdd(aCols[nSize], CriaVar(aHeader[nX][2], .T.))
		ElseIf (AllTrim(aHeader[nX][2]) == "BC_ALI_WT") // Se for o campo BC_ALI_WT, inicializa com a tabela atual
			AAdd(aCols[nSize], "SBC")
		ElseIf (AllTrim(aHeader[nX][2]) == "BC_REC_WT") // Se for o campo BC_REC_WT, inicializa com zero
			AAdd(aCols[nSize], 0)
		EndIf
	Next nX

	// Adiciona a flag de registro não deletado
	AAdd(aCols[nSize], .F.)
Return (NIL)

User Function FPCPV002
	Local n_QtdPer := 0
	Local n_QtdApt := M->BC_QUANT
	Local a_Area   := GetArea()
	Local l_Ret    := .T.
	Local j

	If Type("M->H6_QTDPERD") <> "U" .And. Upper(AllTrim(FunName())) == "MATA681"
		n_QtdPer := M->H6_QTDPERD

		For j:=1 To Len(aCols)
			If aCols[j][Len(aHeader) + 1] == .F. .And. (j <> n)
				n_QtdApt += aCols[j][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]
			Endif
		Next

		If n_QtdApt > n_QtdPer
			ShowHelpDlg(SM0->M0_NOME, {"O somatório do valor do campo Qtd Perda da Classificação da Perda está superior ao valor informado no campo Qtd. Perda da Produção PCP Mod2"}, 5, {"Verifique se o valor do campo Qtd Perda da Classificação da Perda foi digitado corretamente"},5)
			l_Ret := .F.
		Endif
	Endif

	RestArea(a_Area)
Return l_Ret



User Function DIGPEROK
	Local a_Area := GetArea()
	Local l_Ret  := .T.
	Local c_OP   := M->H6_OP
	Local i

	If cFilAnt == "010101"   // --- Validação na inclusao do Apontamento de Perda

		c_LocalSC2 := Posicione("SC2", 1, xFilial("SC2") + c_OP, "C2_LOCAL")
		c_ProdSH6  := M->H6_PRODUTO
		c_LocalSH6 := M->H6_LOCAL
		n_QtdSH6   := M->H6_QTDPERD
		n_QtdApt   := 0


		For i:=1 To Len(aCols)
			If aCols[i][Len(aHeader) + 1] == .F.
				n_QtdApt += aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]

				cCodProd  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_PRODUTO'})]
				c_LocOrig := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_LOCORIG'})]
				n_QtdPer  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_QUANT'})]
				c_Um      := ""
				n_Peso    := 0
				c_Grupo   := ""

				cCodDest  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_CODDEST'})]
				c_Local   := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_LOCAL'})]
				n_QtdDest := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_QTDDEST'})]
				c_UmDest  := ""

				If Empty(cCodProd) .Or. Empty(c_LocOrig) .Or. Empty(cCodDest) .Or. Empty(c_Local)
					ShowHelpDlg(SM0->M0_NOME,;
					{"Um ou alguns campos obrigatórios do item " + StrZero(i, 2) + " não foram preenchidos"},5,;
					{"Preencha os campos Produto, Armazem Orig, Prd. Destino e Armazem Dest antes de prosseguir"},5)
					l_Ret := .F.
					Exit
				Endif

				If cCodProd <> c_ProdSH6
					ShowHelpDlg(SM0->M0_NOME,;
					{"O campo Produto do item " + StrZero(i, 2) + " da Classificação da Perda está divergente do valor informado no campo Produto da Produção PCP Mod2"},5,;
					{"Verifique se o valor do campo Produto da Classificação da Perda foi digitado corretamente"},5)
					l_Ret := .F.
					Exit
				Endif
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
					If Z7_TPMOV == 'S'
						ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuário não possui permissão para efetuar entradas no armazém " + c_Local + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
						Exit
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usuário não possui permissão para efetuar entradas no armazém " + c_Local + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
					Exit
				Endif

				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1") + cCodProd)
					c_Um   := SB1->B1_UM
					c_Grupo  := SB1->B1_GRUPO

					//					If cCodDest == SB1->B1_FSPRODC .Or. cCodDest == SB1->B1_FSPRODD
					If cCodDest == SB1->B1_FSPRODC
						l_Ret := .T.
					Else
						ShowHelpDlg(SM0->M0_NOME, {"O campo Prd. Destino do item " + StrZero(i, 2) + " está preenchido incorretamente"},5,;
						{"Preencha o campo Prd. Destino com o Código do Produto Classe C do Produto " + AllTrim(cCodProd)},5)
						//                                 			  {"Preencha o campo Prd. Destino com o Código do Produto Classe C ou Classe D do Produto " + AllTrim(cCodProd)},5)
						l_Ret := .F.
						Exit
					Endif
				Endif

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + cCodDest))
					c_UmDest := SB1->B1_UM
				Endif

				n_QtdVal := 0

				If c_Um == c_UmDest
					n_QtdVal := n_QtdPer
				Elseif c_Um $ "UN/PC" .And. c_UmDest $ "UN/PC"
					n_QtdVal := n_QtdPer
				Elseif c_Um $ "UN/PC" .And. c_UmDest == "KG"
					dbSelectArea("SBM")
					SBM->(dbSetOrder(1))
					If SBM->(dbSeek(xFilial("SBM") + c_Grupo))
						If SubStr(SBM->BM_GRUPO, 1, 1) == "B"
							n_Peso := SBM->BM_FSPESOB/1000
						Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "A"
							n_Peso := SBM->BM_FSPALCA/1000
						Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "T"
							n_Peso := SBM->BM_FSPTAMP/1000
						Endif
					Endif

					n_QtdVal := n_QtdPer * n_Peso
				Else
					n_QtdVal := n_QtdDest
				Endif

				If n_QtdDest <> n_QtdVal
					ShowHelpDlg(SM0->M0_NOME, {"O campo Qtd Destino do item " + StrZero(i, 2) + " está preenchido incorretamente"},5,;
					{"Verifique se o cálculo para preencher o campo Qtd Destino foi realizado corretamente"},5)
					l_Ret := .F.
					Exit
				Endif
			Endif
		Next

		If (n_QtdApt <> n_QtdSH6) .And. l_Ret
			ShowHelpDlg(SM0->M0_NOME, {"O somatório do valor do campo Qtd Perda da Classificação da Perda está divergente em relação ao valor informado no campo Qtd. Perda da Produção PCP Mod2"}, 5, {"Verifique se o valor do campo Qtd Perda da Classificação da Perda foi digitado corretamente"},5)
			l_Ret := .F.
		Endif
	EndIf

	RestArea(a_Area)
Return l_Ret
