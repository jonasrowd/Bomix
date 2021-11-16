/*/{Protheus.doc} MTDGPERD
	Ponto de entrada para preencher campos da Classificação da Perda na Produção PCP Mod2
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 22/09/2021
/*/
User Function MTDGPERD
	Local a_Area  := FwGetArea() //
	Local c_Prod  := PARAMIXB[1] //
	Local c_OP    := PARAMIXB[2] //
	Local n_Qtd   := PARAMIXB[3] //
	Local n_Size  := 0           //
	// Local n_Count := 0
	Local oSayTela
	Local oBtnCancel
	Local oBtnMater
	Local oBtnBorra
	Local cRet 			:= ""
	Local xLinha 		:= 10
	Local cMensagem	:= ""
	Public oDlg

	If cFilAnt == '010101' //Para filial Bomix continua carregando a quantidade da perda

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(FwXFilial("SB1")+c_Prod)
			If Found()
				n_Peso := SB1->B1_PESO
				n_Size := Len(aCols)
				If Len(aCols) > 0
					GDFieldPut('BC_PRODUTO', c_Prod, n_Size)
					GDFieldPut("BC_CODDEST", SB1->B1_FSPRODC, n_Size)
					GDFieldPut("BC_PRDEST", POSICIONE("SB1", 1, XFILIAL("SB1") + SB1->B1_FSPRODC, "B1_DESC"), n_Size)
					GDFieldPut('BC_QUANT', n_Qtd, n_Size)
					GDFieldPut("BC_QTDDEST", n_Qtd, n_Size)
					n_QtdSegUm := n_Qtd * n_Peso
					GDFieldPut("BC_QTSEGUM", n_QtdSegUm, n_Size)
					GDFieldPut("BC_QTDDES2", n_QtdSegUm, n_Size)
					GDFieldPut("BC_LOTECTL", M->H6_LOTECTL, n_Size)
					GDFieldPut("BC_DTVALID", dDatabase, n_Size)
				EndIf
			EndIf

			If 	Len(aCols) > 0
			// aCols[Len(aCols)][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRODUTO'})] := c_Prod
			// aCols[Len(aCols)][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_LOCORIG'})] := c_Local
			// aCols[Len(aCols)][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]   := n_Qtd
			EndIf	

	ElseIf cFilAnt == '020101'


				cMensagem := "O Apontamento de perda será para Borra ou Material Reprovado?"

				DEFINE MSDIALOG oDlg TITLE OemToAnsi("Atenção!") FROM 000,000 TO 180,650 PIXEL
				oSayTela	:= TSay():New(10,10,{||AllTrim(cMensagem)},oDlg,,,,,,.T.,,,100,400,,,,,,)
				oBtnBorra	:= TButton():New(060,070+xLinha,"Apontar Borra"					,oDlg,{||cRet := "Borra",oDlg:End()},50,20,,,,.T.,,"",,,,.F.) //P
				oBtnMater	:= TButton():New(060,130+xLinha,"Apontar Mat. Reprovado"		,oDlg,{||cRet := "Material",oDlg:End()},80,20,,,,.T.,,"",,,,.F.) //L
				oBtnCancel	:= TButton():New(060,250+xLinha,"Voltar",oDlg,{||oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
				ACTIVATE MSDIALOG oDlg CENTERED


			// Carrega as informações de perda da MASTER
			fMasRes(c_OP)

			// Carrega as informações de perda da resina
			fSerCor(MASTER->ResinaSerie, MASTER->MasterCor)

			// Percorre os itens da MASTER
			// While (!MASTER->(EOF()))
				// Incrementa o contador
				// n_Count++

				// Adiciona nova linha no aCols
				// If (n_Count > 1)
				// 	AddNewLine()
				// EndIf
				// Preenche os campos da primeira linha
				If Len(aCols) > 1
					n_Size := 1
				Else 
					n_Size := Len(aCols)
				EndIf
		If cRet == "Borra"
			
				GDFieldPut("BC_PRODUTO", c_Prod, n_Size)
				GDFieldPut("BC_CODDEST", ESPEC->B1_FSPRODC, n_Size)
				GDFieldPut("BC_DTVALID", dDatabase, n_Size)
				GDFieldPut("BC_PRDEST", POSICIONE("SB1", 1, XFILIAL("SB1")+ESPEC->B1_FSPRODC, "B1_DESC"), n_Size)
				GDFieldPut("BC_LOCAL", POSICIONE("SB1", 1, XFILIAL("SB1")+ESPEC->B1_FSPRODC, "B1_LOCPAD"), n_Size)
				GDFieldPut("BC_QUANT", n_Qtd, n_Size)
				GDFieldPut("BC_LOTECTL", M->H6_LOTECTL, n_Size)
				GDFieldPut("BC_QTSEGUM", n_Qtd, n_Size)
				GDFieldPut("BC_QTDDEST", n_Qtd, n_Size)
				GDFieldPut("BC_QTDDES2", n_Qtd, n_Size)

				// Percorre os itens da resina
				// While (!ESPEC->(EOF()))
				// If len(acols) == 1
				// 	// Adiciona uma nova linha no aCols
				// 	AddNewLine()
				// EndIf
		ElseIf cRet == "Material"
				n_Size := Len(aCols)
				// Preenche os campos da primeira linha
				GDFieldPut("BC_PRODUTO", c_Prod, n_Size)
				GDFieldPut("BC_CODDEST", ESPEC->B1_COD, n_Size)
				GDFieldPut("BC_DTVALID", dDatabase, n_Size)
				GDFieldPut("BC_PRDEST", POSICIONE("SB1", 1, XFILIAL("SB1")+ESPEC->B1_COD, "B1_DESC"), n_Size)
				GDFieldPut("BC_LOCAL", ESPEC->B1_LOCPAD,n_Size)
				n_Qtd := n_Qtd * (MASTER->Peso)
				GDFieldPut("BC_QUANT", n_Qtd, n_Size)
				n_QtdSegUm := n_Qtd * (MASTER->Peso)
				GDFieldPut("BC_QTSEGUM", n_QtdSegUm, n_Size)
				GDFieldPut("BC_QTDDEST", n_Qtd, n_Size)
				GDFieldPut("BC_QTDDES2", n_QtdSegUm, n_Size)
				GDFieldPut("BC_LOTECTL", M->H6_LOTECTL, n_Size)
		EndIf

					// Salta para o próximo registro de resina
					// ESPEC->(DBSkip())
				// End

			// 	// Salta para o próximo registro da MASTER
				// MASTER->(DBSkip())
			// End

			// Fecha o alias do produto moido
			If (Select("ESPEC") > 0)
			DBSelectArea("ESPEC")
			DBCloseArea()
			EndIf

			// Fecha o alias da MASTER
			If (Select("MASTER") > 0)
				DBSelectArea("MASTER")
				DBCloseArea()
			EndIf

	EndIf

	// Restaura a área de trabalho anterior
	FwRestArea(a_Area)
Return (NIL)

/*/{Protheus.doc} fMasRes
	Monta tabela temporária que trás o produto de perda (MASTER e RESINA)
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 21/09/2021
	@param c_OP, Character, Número da OP
/*/
Static Function fMasRes(c_OP)
	Local aArea := FwGetArea() // Armazena a área corrente

	// Fecha o alias se ele já estiver em uso
	If (Select("MASTER") > 0)
		DBSelectArea("MASTER")
		DBCloseArea()
	EndIf

	// Realiza a consulta SQL
	BEGINSQL ALIAS "MASTER"

		SELECT 
			Top 1 
			C2_NUM + C2_ITEM + C2_SEQUEN as OP, 
			C2_PRODUTO as ProdutoOP, 
			ProdutoOP.B1_PESO as Peso, 
			ProdutoOP.B1_LOCPAD as Armazem, 
			D4.D4_COD as Resina_ID, 
			B1.B1_DESC as Resina, 
			B1.B1_SERIE as ResinaSerie,
			D4_MASTER.D4_COD as Master_ID, 
			D4_MASTER.D4_FSDSC as Master, 
			ISNULL(B1_MASTER.B1_SERIE,'NATURAL') as MasterCor
		FROM
			%TABLE:SC2% C2 (NOLOCK)
			INNER JOIN
			%TABLE:SB1% ProdutoOP (NOLOCK)
			ON ProdutoOP.B1_FILIAL = %XFILIAL:SB1%
			AND ProdutoOP.%NOTDEL%
			AND ProdutoOP.B1_COD = C2.C2_PRODUTO
			INNER JOIN
			%TABLE:SD4% D4 (NOLOCK)
			ON D4.D4_FILIAL = %XFILIAL:SD4%
			AND D4.%NOTDEL%
			AND D4.D4_OP = %EXP:AllTrim(c_OP)%
			AND D4.D4_FSTP = "RESINA"
			INNER JOIN
			%TABLE:SB1% B1 (NOLOCK)
			ON B1.B1_FILIAL = %XFILIAL:SB1%
			AND B1.%NOTDEL%
			AND B1.B1_COD = D4.D4_COD
			LEFT JOIN
			%TABLE:SD4% D4_MASTER (NOLOCK)
			ON D4_MASTER.D4_FILIAL = %XFILIAL:SD4%
			AND D4_MASTER.%NOTDEL%
			AND D4_MASTER.D4_OP = %EXP:AllTrim(c_OP)%
			AND D4_MASTER.D4_FSTP = "MASTER"
			LEFT JOIN
			%TABLE:SB1% B1_MASTER (NOLOCK)
			ON B1_MASTER.B1_FILIAL = %XFILIAL:SB1%
			AND B1_MASTER.%NOTDEL%
			AND B1_MASTER.B1_COD = D4_MASTER.D4_COD
		WHERE
			C2_FILIAL = %XFILIAL:SC2% AND
			C2.%NOTDEL% AND
			C2_NUM + C2_ITEM + C2_SEQUEN = %EXP:AllTrim(c_OP)%
	ENDSQL

	// Restaura a área anterior
	FwRestArea(aArea)
Return (NIL)

/*/{Protheus.doc} fSerCor
	Monta tabela temporária que trás o material moído da perda
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 21/09/2021
	@param c_Serie, Character, Série da resina
	@param c_Cor, Character, Cor da MASTER
/*/

Static Function fSerCor(c_Serie, c_Cor)
	Local aArea := FwGetArea() // Armazena a área corrente

	// Prepara os valores para inserção na query
	//c_Serie := "%'%" + AllTrim(c_Serie) + "%'%"
	//c_Cor   := "%'%" + AllTrim(c_Cor) + "%'%"

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
			B1_MSBLQL,
			B1_COD,
			B1_FSPRODC,
			B1_LOCPAD
		FROM
			%TABLE:SB1%
		WHERE
			B1_MSBLQL <> '1'
			AND B1_SERIE	= %EXP:AllTrim(c_Serie)%
			AND B1_BRTPPR	= 'MATERIAL REPROVADO'
			AND B1_BRCORG	= %EXP:AllTrim(c_Cor)%
			AND B1_FILIAL	= %XFILIAL:SB1%
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

/*/{Protheus.doc} DIGPEROK
	Ponto de entrada para validar as informações da classificação da Perda na Produção PCP Mod2
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 22/09/2021
	@return logical, Se verdadeiro, grava a SBC
/*/
User Function DIGPEROK
	Local a_Area := GetArea()
	Local l_Ret  := .T.
	// LOCAL I := 0
    // LOCAL TRANSFUM := 0
	// Local c_OP   := M->H6_OP
	// Local i

	If cFilAnt == "010101"   // --- Validação na inclusao do Apontamento de Perda

		// c_LocalSC2 := Posicione("SC2", 1, xFilial("SC2") + c_OP, "C2_LOCAL")
		// c_ProdSH6  := M->H6_PRODUTO
		// c_LocalSH6 := M->H6_LOCAL
		// n_QtdSH6   := M->H6_QTDPERD
		// n_QtdApt   := 0


		// For i:=1 To Len(aCols)
		// 	If aCols[i][Len(aHeader) + 1] == .F.
		// 		n_QtdApt += aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]

		// 		cCodProd  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_PRODUTO'})]
		// 		c_LocOrig := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_LOCORIG'})]
		// 		n_QtdPer  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_QUANT'})]
		// 		c_Um      := ""
		// 		n_Peso    := 0
		// 		c_Grupo   := ""

		// 		cCodDest  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_CODDEST'})]
		// 		c_Local   := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_LOCAL'})]
		// 		n_QtdDest := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_QTDDEST'})]
		// 		c_UmDest  := ""

		// 		If Empty(cCodProd) .Or. Empty(c_LocOrig) .Or. Empty(cCodDest) .Or. Empty(c_Local)
		// 			l_Ret := .F.
		// 			Exit
		// 		Endif

		// 		If cCodProd <> c_ProdSH6
		// 			l_Ret := .F.
		// 			Exit
		// 		Endif
		// 		dbSelectArea("SZ7")
		// 		dbSetOrder(1)
		// 		If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
		// 			If Z7_TPMOV == 'S'
		// 				l_Ret := .F.
		// 				Exit
		// 			Endif
		// 		Else
		// 			l_Ret := .F.
		// 			Exit
		// 		Endif

		// 		dbSelectArea("SB1")
		// 		dbSetOrder(1)
		// 		If dbSeek(xFilial("SB1") + cCodProd)
		// 			c_Um   := SB1->B1_UM
		// 			c_Grupo  := SB1->B1_GRUPO

		// 			//If cCodDest == SB1->B1_FSPRODC .Or. cCodDest == SB1->B1_FSPRODD
		// 			If cCodDest == SB1->B1_FSPRODC
		// 				l_Ret := .T.
		// 			Else
		// 				l_Ret := .F.
		// 				Exit
		// 			Endif
		// 		Endif

		// 		dbSelectArea("SB1")
		// 		SB1->(dbSetOrder(1))
		// 		If SB1->(dbSeek(xFilial("SB1") + cCodDest))
		// 			c_UmDest := SB1->B1_UM
		// 		Endif

		// 		n_QtdVal := 0

		// 		If c_Um == c_UmDest
		// 			n_QtdVal := n_QtdPer
		// 		Elseif c_Um $ "UN/PC" .And. c_UmDest $ "UN/PC"
		// 			n_QtdVal := n_QtdPer
		// 		Elseif c_Um $ "UN/PC" .And. c_UmDest == "KG"
		// 			dbSelectArea("SBM")
		// 			SBM->(dbSetOrder(1))
		// 			If SBM->(dbSeek(xFilial("SBM") + c_Grupo))
		// 				If SubStr(SBM->BM_GRUPO, 1, 1) == "B"
		// 					n_Peso := SBM->BM_FSPESOB/1000
		// 				Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "A"
		// 					n_Peso := SBM->BM_FSPALCA/1000
		// 				Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "T"
		// 					n_Peso := SBM->BM_FSPTAMP/1000
		// 				Endif
		// 			Endif

		// 			n_QtdVal := n_QtdPer * n_Peso
		// 		Else
		// 			n_QtdVal := n_QtdDest
		// 		Endif

		// 		If n_QtdDest <> n_QtdVal
		// 			l_Ret := .F.
		// 			Exit
		// 		Endif
		// 	Endif
		// Next

		// If (n_QtdApt <> n_QtdSH6) .And. l_Ret
		// 	l_Ret := .F.
		// Endif
	EndIf

	If cFilAnt == '020101'

		// FOR I:=1 TO LEN(ACOLS)
		// 	IF ("BORRA" $ ACOLS[I][4] .AND. ACOLS[I][33]==.F.)
		// 		TRANSFUM := TRANSFUM + (ACOLS[I][2]/M->H6_FSPESOI)
		// 	ELSE 
		// 		TRANSFUM := TRANSFUM + (ACOLS[I][2])
		// 	ENDIF
		// NEXT

		// NQNTPERD := TRANSFUM
		// M->H6_QTDPERD := TRANSFUM
	EndIf

	// If l_Ret
	// 	M->H6_QTDPROD := 0
	// 	M->H6_PT := "P"
	// EndIf

	RestArea(a_Area)
Return l_Ret
