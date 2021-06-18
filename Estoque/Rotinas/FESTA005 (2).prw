#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³ Christian Rocha       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ 			Tela de Liberação de Arte     					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FESTA005
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private a_Strut    := {}
	Private a_Campos   := {}
	Private a_Cores    := {}
	Private c_Mark     := GetMark()
	Private l_Inverte  := .F.
	
	Private c_Arte     := Space(TamSX3("Z2_COD")[1])
	Private c_Desc     := Space(TamSX3("Z2_DESC")[1])
	Private c_Qry      := ''
	Private l_Fotolito := .F.
	Private l_Impressa := .F.
	Private l_HabFoto  := .T.	//Flag para habilitar a opção de liberação de OPs intermediárias relacionadas ao produto
	Private l_HabImp   := .T.	//Flag para habilitar a opção de liberação de todas as OPs relacionadas ao produto

	Aadd(a_Strut,{"TB_OK"       ,"C",TamSX3("C6_OK")[1]  ,0})
	Aadd(a_Strut,{"TB_PEDIDO"	,"C",TamSX3("C2_PEDIDO")[1]	,0})
	Aadd(a_Strut,{"TB_ITEMPV"	,"C",TamSX3("C2_ITEMPV")[1]	,0})
	Aadd(a_Strut,{"TB_CODCLI"	,"C",TamSX3("A1_COD")[1],0})
	Aadd(a_Strut,{"TB_LOJA"		,"C",TamSX3("A1_LOJA")[1],0})	
	Aadd(a_Strut,{"TB_CLIENTE"	,"C",TamSX3("A1_NREDUZ")[1],0})
	Aadd(a_Strut,{"TB_NUM"		,"C",TamSX3("C2_NUM")[1]	,0})
	Aadd(a_Strut,{"TB_ITEM"		,"C",TamSX3("C2_ITEM")[1]	,0})
	Aadd(a_Strut,{"TB_SEQUEN"	,"C",TamSX3("C2_SEQUEN")[1]	,0})
	Aadd(a_Strut,{"TB_PRODUTO"	,"C",TamSX3("C2_PRODUTO")[1],0})
	Aadd(a_Strut,{"TB_QUANT"	,"N",TamSX3("C2_QUANT")[1]	,TamSX3("C2_QUANT")[2]})
	Aadd(a_Strut,{"TB_TPOP"		,"C",TamSX3("C2_TPOP")[1]	,0})	
	Aadd(a_Strut,{"TB_FSTPOPI"	,"C",TamSX3("C2_FSTPOPI")[1],0})
	Aadd(a_Strut,{"TB_DATPRI"	,"D",TamSX3("C2_DATPRI")[1]	,0})
	Aadd(a_Strut,{"TB_DATPRF"	,"D",TamSX3("C2_DATPRF")[1]	,0})
	Aadd(a_Strut,{"TB_OBS"		,"C",TamSX3("C2_OBS")[1]	,0})
	Aadd(a_Strut,{"TB_EMISSAO"	,"D",TamSX3("C2_EMISSAO")[1],0})
	Aadd(a_Strut,{"TB_STATUS"	,"C",TamSX3("C2_STATUS")[1]	,0})

	c_Pro := CriaTrab(a_Strut, .T.)
	Use &c_Pro Shared Alias TRB New
	Index on TB_NUM To &c_Pro

	Aadd(a_Campos,{"TB_OK"  	,,''      			,'@!'})
	Aadd(a_Campos,{"TB_PEDIDO"	,,'Pedido Venda'	,'@!'})
	Aadd(a_Campos,{"TB_ITEMPV"	,,'Item PV'			,'@!'})
	Aadd(a_Campos,{"TB_CODCLI"	,,'Cod. Cliente'	,'@!'})
	Aadd(a_Campos,{"TB_LOJA"	,,'Loja'			,'@!'})
	Aadd(a_Campos,{"TB_CLIENTE"	,,'Cliente'			,'@!'})
	Aadd(a_Campos,{"TB_NUM"		,,'Ord. Prod.'  	,'@!'})
	Aadd(a_Campos,{"TB_ITEM"	,,'Item'			,'@!'})
	Aadd(a_Campos,{"TB_SEQUEN"	,,'Sequencia'		,'@!'})
	Aadd(a_Campos,{"TB_PRODUTO"	,,'Produto'  		,'@!'})
	Aadd(a_Campos,{"TB_QUANT"	,,'Quantidade'		,'@R 999999999.99'})
	Aadd(a_Campos,{"TB_TPOP"	,,'Tipo OP'			,'@!'})
	Aadd(a_Campos,{"TB_FSTPOPI"	,,'Tipo OPs Int'	,'@!'})
	Aadd(a_Campos,{"TB_DATPRI"	,,'Previsao Ini'	,'@!'})
	Aadd(a_Campos,{"TB_DATPRF"	,,'Entrega'			,'@!'})
	Aadd(a_Campos,{"TB_OBS"		,,'Observacao'		,'@!'})
	Aadd(a_Campos,{"TB_EMISSAO"	,,'Dt Emissao'		,'@!'})
	Aadd(a_Campos,{"TB_STATUS"	,,'Situacao'	  	,'@!'})

	Aadd(a_Cores,{"TB_FSTPOPI == 'F'"	,"BR_VERDE"		})
	Aadd(a_Cores,{"TB_FSTPOPI <> 'F'"	,"BR_VERMELHO"	})
	
	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oGet2","oGrp1","oBrw1","oGrp2","oCBox1","oCBox2","oBtn1","oBtn2")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 091,232,556,908,"Liberação de Arte",,,.F.,,,,,,.T.,,,.T. )

	oSay1      := TSay():New( 008,004,{||"Arte:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	@ 08, 020 MSGET c_Arte  F3 "SZ2" PICTURE "@!" VALID f_VldCod()  SIZE 50,08 PIXEL OF oDlg1
//	oGet1      := TGet():New( 008,028,{|u| IIF(PCOUNT()>0,c_Arte:=u, c_Arte)},oDlg1,076,008,'',{|| f_VldCod()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)

	oSay2      := TSay():New( 008,086,{||"Descrição:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 008,118,{|u| IIF(PCOUNT()>0,c_Desc:=u, c_Desc)},oDlg1,218,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oGrp1      := TGroup():New( 024,004,156,336,"Ordens de Produção Previstas e Pedidos de Venda da Arte",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
 	oBrw1      := MsSelect():New( "TRB","TB_OK","",a_Campos,@l_Inverte,@c_Mark,{036,012,148,328},,,oGrp1,,a_Cores )
 	oBrw1:bMark:= {|| f_ChkItem()}	

	oGrp2      := TGroup():New( 160,004,204,336,"Opções de Liberação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oCBox1     := TCheckBox():New( 172,012,"Fotolito em desenvolvimento",{|| l_Fotolito},oGrp2,172,008,,{|| l_Fotolito := !l_Fotolito, IIF(l_Fotolito, l_HabImp := .F., l_HabImp := .T.)},,,CLR_BLACK,CLR_WHITE,,.T.,"",,{|| l_HabFoto} )
	oCBox2     := TCheckBox():New( 188,012,"Produto pronto para impressão",{|| l_Impressa},oGrp2,164,008,,{|| l_Impressa := !l_Impressa, IIF(l_Impressa, l_HabFoto := .F., l_HabFoto := .T.)},,,CLR_BLACK,CLR_WHITE,,.T.,"",,{|| l_HabImp} )

	oBtn1      := TButton():New( 212,128,"&Liberar",oDlg1,{|| f_Liberar()},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 212,168,"&Cancelar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	TRB->(dbCloseArea())

Return

//Função para validação do código do produto
Static Function f_VldCod()
	Local l_Ret := .T.

	If	!Empty(c_Arte) 
		If ExistCpo("SZ2")
			c_Desc := Posicione("SZ2", 1, xFilial("SZ2") + c_Arte, "Z2_DESC")

			f_GetOPs()
	    Else
			l_Ret := .F.
		Endif
	Endif
Return l_Ret

//Função para selecionar as OPs previstas do produto acabado
Static Function f_GetOPs
	l_HabFoto := .T.
	l_HabImp  := .T.

	c_Qry := f_Qry()

    dbSelectArea("TRB")
    dbGoTop()
	If TRB->(!Eof())
		While TRB->(!Eof())                         //Limpa a tabela TRB
			RecLock("TRB", .F.)
			dbDelete()
			MsUnlock()

			TRB->(dbSkip())
		End
	Endif

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!Eof())
		While QRY->(!Eof())
			If QRY->QTDPREV > 0					//Se existirem OPs intermediárias previstas deve atualizar o campo C2_FSTPOPI da OP pai
				dbSelectArea("SC2")
				dbGoTop()
				dbSetOrder(9)
				dbSeek(xFilial("SC2") + QRY->NUM + QRY->ITEM + QRY->PROD)
				RecLock("SC2", .F.)
				SC2->C2_FSTPOPI := 'P'
				MsUnlock()
			Endif

			dbSelectArea("TRB")
			RecLock("TRB", .T.)
			TRB->TB_NUM   	:= QRY->NUM
			TRB->TB_ITEM    := QRY->ITEM
			TRB->TB_SEQUEN	:= QRY->SEQUEN
			TRB->TB_PRODUTO := QRY->PROD
//			TRB->TB_LOCAL	:= QRY->C2_LOCAL
			TRB->TB_PEDIDO	:= QRY->PEDIDO
			TRB->TB_ITEMPV	:= QRY->ITEMPV
			TRB->TB_CODCLI  := QRY->CODCLI
			TRB->TB_LOJA	:= QRY->LOJA
			TRB->TB_CLIENTE := QRY->CLIENTE			
//			TRB->TB_CC		:= QRY->CC
			TRB->TB_QUANT	:= QRY->QUANT
//			TRB->TB_UM		:= QRY->C2_UM
			TRB->TB_DATPRI	:= STOD(QRY->DATPRI)
			TRB->TB_DATPRF  := STOD(QRY->DATPRF)
			TRB->TB_OBS  	:= QRY->OBS
			TRB->TB_EMISSAO := STOD(QRY->EMISSAO)
			TRB->TB_STATUS	:= QRY->STATUS
			TRB->TB_TPOP 	:= QRY->TPOP
			TRB->TB_FSTPOPI	:= IIF(QRY->QTDPREV > 0, 'P', 'F')
			MsUnlock()

//			If TRB->TB_FSTPOPI == 'P'
//				l_HabOpc1 := .T.			//Se existir OPs intermediárias prevista, habilita a opção de liberar as ordens de produção intermediárias
//			Endif

			QRY->(dbSkip())
		End

//	  	If l_HabOpc1						//Se a opção de liberar as OPs intermediárias estiver habilitada, desabilita a opção de liberar todas as OPs
//	 		l_HabOpc2 := .F.
//		Else
// 			l_HabOpc2 := .T.
//	  	Endif
	Else
 		l_HabOpc2 := .F.					//Se não houver OPs previstas, desabilita as opções de liberação de OPs
		l_HabOpc2 := .F.
	Endif

    dbSelectArea("TRB")
	TRB->(dbGoTop())
	
	oBrw1:oBrowse:GoTop()

	QRY->(dbCloseArea())
Return

//Função para gerar a query que busca as OPs previstas do produto acabado
Static Function f_Qry
	c_Qry := " SELECT " + CHR(13)
	c_Qry += " 	C2_NUM NUM, C2_ITEM ITEM, C2_SEQUEN SEQUEN, C2_PRODUTO PROD, C2_PEDIDO PEDIDO, C2_ITEMPV ITEMPV, C2_QUANT QUANT, C2_DATPRI DATPRI, C2_DATPRF DATPRF, C2_OBS OBS, C2_EMISSAO EMISSAO, C2_STATUS STATUS, C2_TPOP TPOP, " + CHR(13)
	c_Qry += " 	(SELECT COUNT(*) FROM " + RETSQLNAME("SC2") + " C2 WHERE C2.C2_NUM = SC2.C2_NUM AND C2.C2_ITEM = SC2.C2_ITEM AND C2_SEQUEN <> SC2.C2_SEQUEN AND C2.C2_TPOP = 'P' AND C2.D_E_L_E_T_<>'*') QTDPREV, " + CHR(13)
	c_Qry += " 	A1_COD CODCLI,  A1_LOJA LOJA, A1_NREDUZ CLIENTE " + CHR(13)
	c_Qry += " FROM  " + RETSQLNAME("SC2") + " SC2 " + CHR(13)
	c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + CHR(13)
	c_Qry += " 			AND B1_COD = C2_PRODUTO " + CHR(13)
	c_Qry += " 			AND B1_FSARTE = '" + c_Arte + "' " + CHR(13)
	c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + CHR(13)
	c_Qry += " 		INNER JOIN SC5010 SC5 ON C5_FILIAL = '" + xFilial("SC5") + "' " + CHR(13)
	c_Qry += " 			AND C5_NUM = C2_PEDIDO " + CHR(13)
	c_Qry += " 			AND SC5.D_E_L_E_T_<>'*' " + CHR(13)
	c_Qry += " 		INNER JOIN SA1010 SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' " + CHR(13)
	c_Qry += " 			AND A1_COD = C5_CLIENTE " + CHR(13)
	c_Qry += " 			AND A1_LOJA = C5_LOJACLI " + CHR(13)
	c_Qry += " 			AND SA1.D_E_L_E_T_<>'*' " + CHR(13)
	c_Qry += " WHERE   " + CHR(13)
	c_Qry += "	C2_FILIAL = '" + XFILIAL("SC2") + "' AND  " + CHR(13)
	c_Qry += "	C2_TPOP = 'P' AND  C2_SEQPAI = '000' AND C2_PEDIDO <> '' AND " 	 + CHR(13)
	c_Qry += "	SC2.D_E_L_E_T_ <> '*' " + CHR(13)
	c_Qry += "	UNION
	c_Qry += " SELECT C6_NUM NUM, C6_ITEM ITEM, '' SEQUEN, C6_PRODUTO PROD, C6_NUM PEDIDO, C6_ITEM ITEMPV, C6_QTDVEN QUANT, C6_ENTREG DATPRI, C6_ENTREG DATPRF, '' OBS, '' EMISSAO, '' STATUS, '' TPOP, 1 QTDPREV, " + CHR(13)
	c_Qry += " 	A1_COD CODCLI,  A1_LOJA LOJA, A1_NREDUZ CLIENTE " + CHR(13)
	c_Qry += " FROM  " + RETSQLNAME("SC6") + " SC6 " + CHR(13)	
	c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + CHR(13)	
	c_Qry += " 			AND B1_COD = C6_PRODUTO " + CHR(13)	
	c_Qry += " 			AND B1_FSARTE = '" + c_Arte + "' " + CHR(13)	
	c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + CHR(13)	
	c_Qry += " 		INNER JOIN SA1010 SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' " + CHR(13)
	c_Qry += " 			AND A1_COD = C6_CLI " + CHR(13)
	c_Qry += " 			AND A1_LOJA = C6_LOJA " + CHR(13)
	c_Qry += " 			AND SA1.D_E_L_E_T_<>'*' " + CHR(13)
	c_Qry += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' AND NOT EXISTS (SELECT C2_PEDIDO FROM SC2010 SC2  " + CHR(13)	
	c_Qry += " 								INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + CHR(13)	
	c_Qry += " 									AND B1_COD = C2_PRODUTO " + CHR(13)	
	c_Qry += " 									AND B1_FSARTE = '" + c_Arte + "' " + CHR(13)	
	c_Qry += " 									AND SB1.D_E_L_E_T_<>'*' " + CHR(13)		
	c_Qry += "								WHERE SC2.D_E_L_E_T_<>'*' AND C2_FILIAL = '" + xFilial("SC2") + "')" + CHR(13)	


	c_Qry += " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN "

	MemoWrit("C:\TEMP\FESTA005.sql",c_Qry)
Return c_Qry

//Função que verifica qual opção de liberação foi selecionada pelo usuário
Static Function f_Liberar
	If l_Impressa
		f_UpdOPs(.T.)
	Else
		If l_Fotolito
			f_UpdOPs(.F.)
		Else
			Alert("Selecione uma das opções de liberação para efetuar essa operação.")
			Return
		Endif
	Endif

	Alert("Atualização efetuada com sucesso.")

	l_Fotolito := .F.
	l_Impressa := .F.
	f_GetOPs()
Return

//Função que atualiza o tipo da OP de prevista para firme de acordo com a opção selecionada pelo usuário
Static Function f_UpdOPs(l_UpdPai)
	dbSelectArea("TRB")
	dbGoTop()
	While TRB->(!Eof())
		If TRB->TB_OK == c_Mark .And. Empty(TRB->TB_NUM) = .F.
			dbSelectArea("SC2")
			dbGoTop()
			dbSetOrder(1)
			If dbSeek(xFilial("SC2") + TRB->TB_NUM + TRB->TB_ITEM)
				While SC2->(!Eof()) .And. SC2->C2_NUM == TRB->TB_NUM .And. SC2->C2_ITEM == TRB->TB_ITEM
					RecLock("SC2", .F.)
					If l_UpdPai
						SC2->C2_TPOP := 'F'
					Else
						If SC2->C2_SEQPAI == '000'
							SC2->C2_FSTPOPI := 'F'
						Else
							SC2->C2_TPOP := 'F'
						Endif
					Endif
					MsUnlock()
	
					SC2->(dbSkip())
				End
			Endif
		Elseif TRB->TB_OK == c_Mark .And. Empty(TRB->TB_NUM) = .T.
			dbSelectArea("SC6")
			dbGoTop()
			dbSetOrder(1)
			If dbSeek(xFilial("SC6") + TRB->TB_PEDIDO + TRB->TB_ITEMPV + TRB->TB_PRODUTO)
				RecLock("SC6", .F.)
				SC6->C6_FSTPITE := '2'
				MsUnlock()
			Endif
		Endif

		TRB->(dbSkip())
	End
Return c_Qry

//Função executada ao Marcar/Desmarcar um registro
Static Function f_ChkItem
	RecLock("TRB",.F.)
 	If Marked("TB_OK") 
  		TRB->TB_OK := c_Mark
 	Else
  		TRB->TB_OK := ""
 	Endif
	MsUnlock()
 
	oBrw1:oBrowse:Refresh()
Return()