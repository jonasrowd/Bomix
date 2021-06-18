#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  

                                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT680VAL   ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar os dados da Produção PCP Mod2º±±
±±º          ³    														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAPCP													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT680VAL
	Local a_Area    := GetArea()
	Local a_AreaSB1 := SB1->(GetArea())
	Local a_AreaSB2 := SB2->(GetArea())
	Local a_AreaSC2 := SC2->(GetArea())
	Local a_AreaSD4 := SD4->(GetArea())
	Local a_AreaSG1 := SG1->(GetArea())
	Local a_Produto := {}
	Local l_Ret     := .T.

	If l681
		dbSelectArea("SC2")
		dbSetOrder(1)
		If dbSeek(xFilial("SC2") + M->H6_OP)
			If (M->H6_QTDPROD + M->H6_QTDPERD) > (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
				n_Perc := ((M->H6_QTDPROD + M->H6_QTDPERD) - (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))/SB1->B1_QB

				dbSelectArea("SG1")
				SG1->(dbSetOrder(1))
				SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
				While SG1->(!EoF()) .And. SG1->G1_COD == SC2->C2_PRODUTO
					dbSelectArea("SD4")
					SD4->(dbSetOrder(2))
					SD4->(dbSeek(xFilial("SD4") + M->H6_OP + SG1->G1_COMP))
					If Found()
						n_QtdOri  := SD4->D4_QTDEORI + (SG1->G1_QUANT * n_Perc)
						n_Quant   := SD4->D4_QUANT + (SG1->G1_QUANT * n_Perc)

						dbSelectArea("SB2")
						SB2->(dbSetOrder(1))
						If SB2->(dbSeek(xFilial("SB2") + SD4->D4_COD + SD4->D4_LOCAL))
							If n_Quant > SB2->B2_QATU
								AADD(a_Produto, {SB2->B2_COD, SB2->B2_LOCAL, (SB2->B2_QATU - n_Quant), "Sem Saldo em Estoque"})
							Endif
						Endif
					Endif

					SG1->(dbSkip())
				End
			Endif
		Endif
	Endif

	If Len(a_Produto) > 0
		ShowHelpDlg(SM0->M0_NOME, {"Não existe quantidade suficiente em estoque para atender esta requisição."},5,;
                       			  {"Digite uma quantidade menor para que o produto tenha seus componentes disponíveis em estoque."},5)

		Private c_Bord   := ""   //Borda da tabela temporária
		Private a_Bord   := {}   //Array da tabela temporária
		Private a_Campos := {}   //Campos da tabela temporária

		Aadd(a_Bord,{"TB_PRODUTO" ,"C",TamSX3("B1_COD")[1], 0})
		Aadd(a_Bord,{"TB_LOCAL"   ,"C",TamSX3("B1_LOCPAD")[1], 0})
		Aadd(a_Bord,{"TB_SALDO"   ,"N",TamSX3("B2_QATU")[1], TamSX3("B2_QATU")[2]})
		Aadd(a_Bord,{"TB_OCORREN" ,"C",25, 0})

		c_Bord := CriaTrab(a_Bord,.t.)
		Use &c_Bord Shared Alias TRC New
		Index On TB_PRODUTO To &c_Bord

		SET INDEX TO &c_Bord

		For j:=1 To Len(a_Produto)
			RECLOCK("TRC", .T.)
			TRC->TB_PRODUTO := a_Produto[j][1]
			TRC->TB_LOCAL   := a_Produto[j][2]
			TRC->TB_SALDO   := a_Produto[j][3]
			TRC->TB_OCORREN := a_Produto[j][4]
			MSUNLOCK()
		Next

		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  	,'@!'})
		Aadd(a_Campos,{"TB_LOCAL" 	,,'Armazem'  	,'@!'})
		Aadd(a_Campos,{"TB_SALDO"   ,,'Saldo'		,X3Picture("B2_QATU")})
		Aadd(a_Campos,{"TB_OCORREN" ,,'Ocorrencia'  ,''})

		o_Dlg:= MSDialog():New( 090,230,230,745,"Itens Sem Saldo / Bloqueados",,,.F.,,,,,,.T.,,,.T. )
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{005,005,65,255},,, o_Dlg )

		o_Dlg:Activate(,,,.T.)

		DBSELECTAREA("TRC")
		TRC->(DBCLOSEAREA())

		l_Ret := .F.
	Endif

	If l_Ret .And. l681
		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7") + __CUSERID + M->H6_LOCAL)
			If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
				l_Ret := .T.
			Else
				ShowHelpDlg(SM0->M0_NOME,;
				{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + M->H6_LOCAL + "."},5,;
				{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME,;
			{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + M->H6_LOCAL + "."},5,;
			{"Contacte o administrador do sistema."},5)
			l_Ret := .F.
		Endif

		If (M->H6_QTDPERDA > 0) .And. lSavePerda == .F.
			ShowHelpDlg(SM0->M0_NOME,;
			{"Não foi realizada a Classificação da Perda da Produção PCP Mod2"},5,;
			{"Efetue a Classificação da Perda antes de prosseguir"},5)
			l_Ret := .F.
		Endif
	Endif      
	
	
	RestArea(a_AreaSB1)
	RestArea(a_AreaSB2)
	RestArea(a_AreaSC2)
	RestArea(a_AreaSD4)
	RestArea(a_AreaSG1)
	RestArea(a_Area)
Return l_Ret