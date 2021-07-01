#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �         � Autor � Christian Rocha       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � 			Tela de Libera��o de Arte     					  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function FESTA001
	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/
	Private a_Strut    := {}
	Private a_Campos   := {}
	Private a_Cores    := {}
	Private c_Produto  := Space(TamSX3("B1_COD")[1])
	Private c_Desc     := Space(TamSX3("B1_DESC")[1])
	Private c_Qry      := ''
	Private l_OPsInt   := .F.
	Private l_AllOPs   := .F.
	Private l_HabOpc1  := .F.	//Flag para habilitar a op��o de libera��o de OPs intermedi�rias relacionadas ao produto
	Private l_HabOpc2  := .F.	//Flag para habilitar a op��o de libera��o de todas as OPs relacionadas ao produto

	Aadd(a_Strut,{"TB_NUM"		,"C",TamSX3("C2_NUM")[1]	,0})
	Aadd(a_Strut,{"TB_ITEM"		,"C",TamSX3("C2_ITEM")[1]	,0})
	Aadd(a_Strut,{"TB_SEQUEN"	,"C",TamSX3("C2_SEQUEN")[1]	,0})
	Aadd(a_Strut,{"TB_PRODUTO"	,"C",TamSX3("C2_PRODUTO")[1],0})
	Aadd(a_Strut,{"TB_LOCAL"	,"C",TamSX3("C2_LOCAL")[1]	,0})
	Aadd(a_Strut,{"TB_PEDIDO"	,"C",TamSX3("C2_PEDIDO")[1]	,0})
	Aadd(a_Strut,{"TB_ITEMPV"	,"C",TamSX3("C2_ITEMPV")[1]	,0})
	Aadd(a_Strut,{"TB_CC"		,"C",TamSX3("C2_CC")[1]		,0})
	Aadd(a_Strut,{"TB_QUANT"	,"N",TamSX3("C2_QUANT")[1]	,TamSX3("C2_QUANT")[2]})
	Aadd(a_Strut,{"TB_UM"		,"C",TamSX3("C2_UM")[1]		,0})
	Aadd(a_Strut,{"TB_DATPRI"	,"D",TamSX3("C2_DATPRI")[1]	,0})
	Aadd(a_Strut,{"TB_DATPRF"	,"D",TamSX3("C2_DATPRF")[1]	,0})
	Aadd(a_Strut,{"TB_OBS"		,"C",TamSX3("C2_OBS")[1]	,0})
	Aadd(a_Strut,{"TB_EMISSAO"	,"D",TamSX3("C2_EMISSAO")[1],0})
	Aadd(a_Strut,{"TB_STATUS"	,"C",TamSX3("C2_STATUS")[1]	,0})
	Aadd(a_Strut,{"TB_TPOP"		,"C",TamSX3("C2_TPOP")[1]	,0})
	Aadd(a_Strut,{"TB_FSTPOPI"	,"C",TamSX3("C2_FSTPOPI")[1],0})

	c_Pro := CriaTrab(a_Strut, .T.)
	Use &c_Pro Shared Alias TRB New
	Index on TB_NUM To &c_Pro

	Aadd(a_Campos,{"TB_NUM"		,,'Ord. Prod.'  	,'@!'})
	Aadd(a_Campos,{"TB_ITEM"	,,'Item'			,'@!'})
	Aadd(a_Campos,{"TB_SEQUEN"	,,'Sequencia'		,'@!'})
	Aadd(a_Campos,{"TB_PRODUTO"	,,'Produto'  		,'@!'})
	Aadd(a_Campos,{"TB_LOCAL"	,,'Armazem'			,'@!'})
	Aadd(a_Campos,{"TB_PEDIDO"	,,'Pedido Venda'	,'@!'})
	Aadd(a_Campos,{"TB_ITEMPV"	,,'Item PV'			,'@!'})
	Aadd(a_Campos,{"TB_CC"		,,'Centro Custo'	,'@!'})
	Aadd(a_Campos,{"TB_QUANT"	,,'Quantidade'		,'@R 999999999.99'})
	Aadd(a_Campos,{"TB_UM"		,,'Unid Medida'		,'@!'})
	Aadd(a_Campos,{"TB_DATPRI"	,,'Previsao Ini'	,'@!'})
	Aadd(a_Campos,{"TB_DATPRF"	,,'Entrega'			,'@!'})
	Aadd(a_Campos,{"TB_OBS"		,,'Observacao'		,'@!'})
	Aadd(a_Campos,{"TB_EMISSAO"	,,'Dt Emissao'		,'@!'})
	Aadd(a_Campos,{"TB_STATUS"	,,'Situacao'	  	,'@!'})
	Aadd(a_Campos,{"TB_TPOP"	,,'Tipo OP'			,'@!'})
	Aadd(a_Campos,{"TB_FSTPOPI"	,,'Tipo OPs Int'	,'@!'})

	Aadd(a_Cores,{"TB_FSTPOPI == 'F'"	,"BR_VERDE"		})
	Aadd(a_Cores,{"TB_FSTPOPI <> 'F'"	,"BR_VERMELHO"	})
	
	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oGet2","oGrp1","oBrw1","oGrp2","oCBox1","oCBox2","oBtn1","oBtn2")

	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 091,232,556,908,"Libera��o de Arte",,,.F.,,,,,,.T.,,,.T. )

	oSay1      := TSay():New( 008,004,{||"Produto:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	@ 08, 026 MSGET c_Produto  F3 "SB1FS" PICTURE "@!" VALID f_VldCod()  SIZE 76,08 PIXEL OF oDlg1
//	oGet1      := TGet():New( 008,028,{|u| IIF(PCOUNT()>0,c_Produto:=u, c_Produto)},oDlg1,076,008,'',{|| f_VldCod()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)

	oSay2      := TSay():New( 008,116,{||"Descri��o:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 008,144,{|u| IIF(PCOUNT()>0,c_Desc:=u, c_Desc)},oDlg1,192,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oGrp1      := TGroup():New( 024,004,156,336,"Ordens de Produ��o Previstas do Produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBrw1      := MsSelect():New( "TRB","","",a_Campos,.F.,,{036,012,148,328},,,oGrp1,,a_Cores )

	oGrp2      := TGroup():New( 160,004,204,336,"Op��es de Libera��o",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oCBox1     := TCheckBox():New( 172,012,"Fotolito em desenvolvimento",{|| l_OPsInt},oGrp2,172,008,,{|| l_OPsInt := !l_OPsInt},,,CLR_BLACK,CLR_WHITE,,.T.,"",,{|| l_HabOpc1} )
	oCBox2     := TCheckBox():New( 188,012,"Produto pronto para impress�o",{|| l_AllOPs},oGrp2,164,008,,{|| l_AllOPs := !l_AllOPs},,,CLR_BLACK,CLR_WHITE,,.T.,"",,{|| l_HabOpc2} )

	oBtn1      := TButton():New( 212,128,"&Liberar",oDlg1,{|| f_Liberar()},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 212,168,"&Cancelar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	TRB->(dbCloseArea())

Return

//Fun��o para valida��o do c�digo do produto
Static Function f_VldCod()
	Local l_Ret := .T.

	If	!Empty(c_Produto) 
		If ExistCpo("SB1")
			c_Desc := Posicione("SB1", 1, xFilial("SB1") + c_Produto, "B1_DESC")

			f_GetOPs()
	    Else
			l_Ret := .F.
		Endif
	Endif
Return l_Ret

//Fun��o para selecionar as OPs previstas do produto acabado
Static Function f_GetOPs
	l_HabOpc1 := .F.
	l_HabOpc2 := .F.

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
			If QRY->C2_QTDPREV > 0					//Se existirem OPs intermedi�rias previstas deve atualizar o campo C2_FSTPOPI da OP pai
				dbSelectArea("SC2")
				dbGoTop()
				dbSetOrder(9)
				dbSeek(xFilial("SC2") + QRY->C2_NUM + QRY->C2_ITEM + QRY->C2_PRODUTO)
				RecLock("SC2", .F.)
				SC2->C2_FSTPOPI := 'P'
				MsUnlock()
			Endif

			dbSelectArea("TRB")
			RecLock("TRB", .T.)
			TRB->TB_NUM   	:= QRY->C2_NUM
			TRB->TB_ITEM    := QRY->C2_ITEM
			TRB->TB_SEQUEN	:= QRY->C2_SEQUEN
			TRB->TB_PRODUTO := QRY->C2_PRODUTO
			TRB->TB_LOCAL	:= QRY->C2_LOCAL
			TRB->TB_PEDIDO	:= QRY->C2_PEDIDO
			TRB->TB_ITEMPV	:= QRY->C2_ITEMPV
			TRB->TB_CC		:= QRY->C2_CC
			TRB->TB_QUANT	:= QRY->C2_QUANT
			TRB->TB_UM		:= QRY->C2_UM
			TRB->TB_DATPRI	:= STOD(QRY->C2_DATPRI)
			TRB->TB_DATPRF  := STOD(QRY->C2_DATPRF)
			TRB->TB_OBS  	:= QRY->C2_OBS
			TRB->TB_EMISSAO := STOD(QRY->C2_EMISSAO)
			TRB->TB_STATUS	:= QRY->C2_STATUS
			TRB->TB_TPOP 	:= QRY->C2_TPOP
			TRB->TB_FSTPOPI	:= IIF(QRY->C2_QTDPREV > 0, 'P', 'F')
			MsUnlock()

			If TRB->TB_FSTPOPI == 'P'
				l_HabOpc1 := .T.			//Se existir OPs intermedi�rias prevista, habilita a op��o de liberar as ordens de produ��o intermedi�rias
			Endif

			QRY->(dbSkip())
		End

	  	If l_HabOpc1						//Se a op��o de liberar as OPs intermedi�rias estiver habilitada, desabilita a op��o de liberar todas as OPs
	 		l_HabOpc2 := .F.
		Else
 			l_HabOpc2 := .T.
	  	Endif
	Else
 		l_HabOpc2 := .F.					//Se n�o houver OPs previstas, desabilita as op��es de libera��o de OPs
		l_HabOpc2 := .F.
	Endif

    dbSelectArea("TRB")
	TRB->(dbGoTop())
	
	oBrw1:oBrowse:GoTop()

	QRY->(dbCloseArea())
Return

//Fun��o para gerar a query que busca as OPs previstas do produto acabado
Static Function f_Qry
	c_Qry := " SELECT " + CHR(13)
	c_Qry += " 	C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_LOCAL, C2_PEDIDO, C2_ITEMPV, C2_CC, C2_QUANT, C2_UM, C2_DATPRI, C2_DATPRF, C2_OBS, C2_EMISSAO, C2_STATUS, C2_TPOP, " + CHR(13)
	c_Qry += " 	(SELECT COUNT(*) FROM " + RETSQLNAME("SC2") + " C2 WHERE C2.C2_NUM = SC2.C2_NUM AND C2.C2_ITEM = SC2.C2_ITEM AND C2_SEQUEN <> SC2.C2_SEQUEN AND C2.C2_TPOP = 'P' AND C2.D_E_L_E_T_<>'*') C2_QTDPREV " + CHR(13)
	c_Qry += " FROM  " + RETSQLNAME("SC2") + " SC2 " + CHR(13)
	c_Qry += " WHERE   " + CHR(13)
	c_Qry += "	C2_FILIAL = '" + XFILIAL("SC2") + "' AND C2_PRODUTO = '" + c_Produto + "' AND  " + CHR(13)
	c_Qry += "	C2_TPOP = 'P' AND  C2_SEQPAI = '000' AND C2_PEDIDO <> '' AND " 	 + CHR(13)
	c_Qry += "	D_E_L_E_T_ <> '*' " + CHR(13)
	c_Qry += " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN "

	MemoWrit("C:\FESTA001.sql",c_Qry)
Return c_Qry

//Fun��o que verifica qual op��o de libera��o foi selecionada pelo usu�rio
Static Function f_Liberar
	If l_AllOps
		f_UpdOPs(l_AllOps)
		f_LibArte()
	Else
		If l_OpsInt
			f_UpdOPs(l_AllOps)
		Else
			Alert("Selecione uma das op��es de libera��o para efetuar essa opera��o.")
			Return
		Endif
	Endif
	Alert("Atualiza��o efetuada com sucesso.")
	l_OPsInt   := .F.
	l_AllOPs   := .F.
	f_GetOPs()
Return

//Fun��o que atualiza o tipo da OP de prevista para firme de acordo com a op��o selecionada pelo usu�rio
Static Function f_UpdOPs(l_UpdPai)
	dbSelectArea("TRB")
	dbGoTop()
	While TRB->(!Eof())
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

		TRB->(dbSkip())
	End
Return c_Qry

Static Function f_LibArte
	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+c_Produto)
		dbSelectArea("SZ2")
		dbGoTop()
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
			RecLock("SZ2", .F.)
			SZ2->Z2_BLOQ := '2'		//Desbloqueia a arte do produto
			MsUnlock()
		Endif
	Endif
Return