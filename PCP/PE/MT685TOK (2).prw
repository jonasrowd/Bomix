/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT685TOK   ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar os dados do Apontamento de   º±±
±±º          ³ Perda													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAPCP													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             

       
User Function MT685TOK
	Local lInc       := PARAMIXB[1]
	Local l_Ret      := .T.
	Local aArea      := GetArea()
   //Alterado Cop para  cOrdemP em todo programa necessida P12 - wellington 05/02/2018
	Local c_ProdSC2  := Posicione("SC2", 1, xFilial("SC2") + cOrdemP, "C2_PRODUTO")  
	Local c_LocalSC2 := Posicione("SC2", 1, xFilial("SC2") + cOrdemP, "C2_LOCAL")
	
	// retorno .T. ou .F. para validar o Apontamento da perda.
	
	If lInc .And. cFilAnt == "010101"   // --- Validação na inclusao do Apontamento da Perda
		For i:=1 To Len(aCols)
			If aCols[i][Len(aHeader) + 1] == .F.
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

				If cCodProd <> c_ProdSC2
					ShowHelpDlg(SM0->M0_NOME,;
						{"O campo Produto do item " + StrZero(i, 2) + " do Apontamento da Perda está divergente do Produto da Ordem de Produção " + cOrdemP},5,;
						{"Verifique se o valor do campo Produto do Apontamento da Perda foi digitado corretamente"},5)
					l_Ret := .F.
					Exit
				Endif
/*
				If (c_LocOrig <> c_LocalSC2)
					ShowHelpDlg(SM0->M0_NOME,;
						{"O campo Armazem Orig do item " + StrZero(i, 2) + " do Apontamento da Perda é inválido"},5,;
						{"Verifique se o valor do campo Armazem Orig do Apontamento da Perda foi digitado corretamente"},5)
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

				If Empty(c_Local)
					ShowHelpDlg(SM0->M0_NOME, {"O campo Armazem Dest do item " + StrZero(i, 2) + " está em branco."},5,;
                                 			  {"Preencha o campo Armazem Dest antes de prosseguir."},5)
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
						ShowHelpDlg(SM0->M0_NOME, {"O campo Prd. Destino do item " + StrZero(i, 2) + " está preenchido incorretamente."},5,;
                                 			  {"Preencha o campo Prd. Destino com o Código do Produto Classe C do Produto " + AllTrim(cCodProd) + "."},5)
//                                 			  {"Preencha o campo Prd. Destino com o Código do Produto Classe C ou Classe D do Produto " + AllTrim(cCodProd) + "."},5)
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
					ShowHelpDlg(SM0->M0_NOME, {"O campo Qtd Destino do item " + StrZero(i, 2) + " está preenchido incorretamente."},5,;
                                 			  {"Verifique se o cálculo para preencher o campo Qtd Destino foi realizado corretamente."},5)
					l_Ret := .F.
					Exit
				Endif
			Endif
		Next
	Endif

	RestArea(aArea)
Return l_Ret