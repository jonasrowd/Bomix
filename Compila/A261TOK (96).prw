/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A261TOK      º Autor ³ AP6 IDE            º Data ³  28/09/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação da Transferência Mod 2                           º±±
±±º          ³ O ponto sera disparado no inicio da chamada da funcao de   º±±
±±º          ³ validacao geral dos itens digitados. Serve para validar se º±±
±±º          ³ o movimento pode ser efetuado ou nao.					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A261TOK( )
	Local l_Ret    := .T.
	Local c_Orig   := ''									//Armazem de Origem
	Local c_Dest   := ''    								//Armazem de Destino
	Local c_Menu   := Upper(NoAcento(AllTrim(FunDesc())))   //Nome do menu executado
	Local a_Area   := GetArea()

    If INCLUI .And. c_Menu == 'TRANSF. (MOD.2)'
		For i:=1 To Len(aCols)
		   	If aCols[i][Len( aHeader )+1] == .F.
				c_Orig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'ARMAZEM ORIG.' .And. Alltrim(x[2]) == 'D3_LOCAL'})]
				c_Dest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'ARMAZEM DESTINO' .And. Alltrim(x[2]) == 'D3_LOCAL'})]
		
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Orig)
					If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
						dbSelectArea("SZ7")
						dbSetOrder(1)
						If dbSeek(xFilial("SZ7") + __CUSERID + c_Dest)
							If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
								l_Ret := .T.
							Else
								ShowHelpDlg(SM0->M0_NOME,;
								{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Dest + "."},5,;
								{"Contacte o administrador do sistema."},5)
								l_Ret := .F.
								Exit
							Endif
						Else
							ShowHelpDlg(SM0->M0_NOME,;
							{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Dest + "."},5,;
							{"Contacte o administrador do sistema."},5)
							l_Ret := .F.
							Exit
						Endif
					Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Orig + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
						Exit
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Orig + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
					Exit
				Endif
				
				If l_Ret
					c_ProdOrig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'PROD.ORIG.' .And. Alltrim(x[2]) == 'D3_COD'})]
					c_GrupoOri := Posicione("SB1", 1, xFilial("SB1") + c_ProdOrig, "B1_GRUPO")
					c_Classe_D := SB1->B1_FSPRODD

					c_ProdDest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'PROD.DESTINO' .And. Alltrim(x[2]) == 'D3_COD'})]
					c_GrupoDes := Posicione("SB1", 1, xFilial("SB1") + c_ProdDest, "B1_GRUPO")

					If (c_GrupoOri <> c_GrupoDes) .And. (c_ProdDest <> c_Classe_D) .And. (SubStr(c_GrupoOri, 1, 1) $ "BT")
						ShowHelpDlg(AllTrim(SM0->M0_NOME),;
							{"Não é permitido realizar transferências entre produtos de grupos diferentes."},5,;
							{"Contacte o administrador do sistema para informar sobre este problema no item " + StrZero(i, 2) + "."},5)
						l_Ret := .F.
						Exit
					Endif
				Endif
			Endif
		Next

		If l_Ret
			If DA261DATA <> DDATABASE
				ShowHelpDlg(SM0->M0_NOME,;
					{"Data de Emissão inválida."},5,;
					{"Preencha a Data de Emissão com a data atual do sistema."},5)
				l_Ret := .F.
			Endif
		Endif
	Endif
	
	RestArea(a_Area)
Return l_Ret