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
	Local a_Area  := GetArea()
	Local c_Prod  := PARAMIXB[1]
	Local c_OP    := PARAMIXB[2]
	Local n_Qtd   := PARAMIXB[3]
//	Local c_Local := Posicione("SC2", 1, xFilial("SC2") + c_OP, "C2_LOCAL")
	Local c_Local := M->H6_LOCAL

	If 	Len(aCols) >0
		aCols[Len(aCols)][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRODUTO'})] := c_Prod
	//	aCols[Len(aCols)][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_LOCORIG'})] := c_Local
		aCols[Len(aCols)][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]   := n_Qtd
	EndIf	

	RestArea(a_Area)
Return Nil



User Function FPCPV002
	Local n_QtdPer := 0
	Local n_QtdApt := M->BC_QUANT
	Local a_Area   := GetArea()
	Local l_Ret    := .T.

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
/*
				If c_LocOrig <> c_LocalSH6
					ShowHelpDlg(SM0->M0_NOME,;
						{"O campo Armazem Orig do item " + StrZero(i, 2) + " da Classificação da Perda está divergente do valor informado no campo Armazem da Produção PCP Mod2"},5,;
						{"Verifique se o valor do campo Armazem Orig da Classificação da Perda foi digitado corretamente"},5)
					l_Ret := .F.
					Exit
				Endif

				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_LocOrig)
					If Z7_TPMOV == 'E'
						ShowHelpDlg(SM0->M0_NOME,;
							{"O seu usuário não possui permissão para efetuar saídas no armazém " + c_LocOrig + "."},5,;
							{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
						Exit						
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuário não possui permissão para efetuar saídas no armazém " + c_LocOrig + "."},5,;
						{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
					Exit
				Endif
*/
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