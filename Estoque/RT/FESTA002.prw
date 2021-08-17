#Include "Totvs.ch"
#Include "Topconn.ch"
#Include "Tryexception.ch" 

#Define c_CRLF Chr(10) + Chr(13)

/*/{Protheus.doc} FESTA002
	Cadastro de Artes
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@return variant, Null
/*/
User Function FESTA002()

	Private cString := "SZ2"

	dbSelectArea("SZ2")
	dbSetOrder(1)

	AxCadastro(cString,"Cadastro de Artes","U_FDELSZ2()", "U_FALTSZ2()")

Return()

/*/{Protheus.doc} FDELSZ2
	Valida��o da Exclus�o de Artes.
	@type Function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@return variant, Query
/*/
User Function FDELSZ2()

	Local l_Ret   := .T.
	Private c_Qry := ""

	f_Qry()

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If !Eof()
		l_Ret := .F.
		ShowHelpDlg(SM0->M0_NOME,;
		{"Essa arte est� relacionada a outros registros e n�o pode ser exclu�da."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif

	QRY->(dbCloseArea())	

Return l_Ret

/*/{Protheus.doc} f_Qry
	Fun��o para selecionar os produtos com arte.
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@return variant, Query
/*/
Static Function f_Qry()

	c_Qry := " SELECT * FROM " + RetSqlName("SB1") + " SB1 " + chr(13)
	c_Qry += " WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_FSARTE = '" + SZ2->Z2_COD + "' AND SB1.D_E_L_E_T_<>'*' " + chr(13)

Return c_Qry

/*/{Protheus.doc} FALTSZ2
	Rotina para altera��o da Arte.
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@return variant, Verdadeiro
/*/
User Function FALTSZ2()
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local l_Ret   		:= .T.
	PRIVATE l_EnviaE    := .F.
	PRIVATE l_EnviaEc   := .F.
	PRIVATE l_EE   		:= .T.
	PRIVATE l_Ec   		:= .F.	

	If !INCLUI

		If l_Ret .And. AllTrim(FunName()) $ 'U_FESTA002' .And. (M->Z2_BLOQ='2' .Or. M->Z2_BLOQ='3')

			l_EnviaEc := .F.
			//l_EnviaE := f_OpsApt(l_EnviaE)
			l_EnviaE := f_OpsApt()			
			l_Ret := .T.
			iF 	l_EnviaE
				l_Ret := .F.
			Endif
		Endif

		If l_Ret .And. AllTrim(FunName()) $ 'U_FESTA002' .And. (M->Z2_BLOQ<>'2')
			l_EnviaE := .F.
			//l_EnviaEc := f_OpsAptc(l_EnviaEc)
			l_EnviaEc := f_OpsAptc()

			l_Ret := .T.
			iF 	l_EnviaEc
				l_Ret := .T.
			Endif
		Endif

		M->Z2_DATA := DDATABASE
		M->Z2_RESP := UsrRetName(__CUSERID)
	Endif
Return l_Ret

/*/{Protheus.doc} f_QryAlt
	Atualiza o bloqueio da arte no or�amento.
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@return variant, Query
/*/
Static Function f_QryAlt()

	//Local c_CRLF := chr(13) + chr(10)

	//c_Qry := " BEGIN TRAN " + c_CRLF
	// Atualiza os Or�amentos
	c_Qry := " UPDATE " + RetSqlName("SCK") + " SET CK_FSTPITE = '" + IIF(IIF(AllTrim(FunName()) == 'FESTA002', M->Z2_BLOQ == '2', SZ2->Z2_BLOQ == '2'), "1' ", "2' ") + c_CRLF
	c_Qry += " WHERE (CK_FILIAL + CK_NUM + CK_ITEM + CK_PRODUTO) IN (" + c_CRLF
	c_Qry += " SELECT (CK_FILIAL + CK_NUM + CK_ITEM + CK_PRODUTO) FROM SCK010 SCK " + c_CRLF
	c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + c_CRLF
	c_Qry += " 			AND B1_COD = CK_PRODUTO " + c_CRLF
	c_Qry += " 			AND B1_FSARTE = '" + SZ2->Z2_COD + "' " + c_CRLF
	c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + c_CRLF
	c_Qry += " 	WHERE SCK.D_E_L_E_T_<>'*' AND CK_FILIAL = '" + xFilial("SCK") + "')" + c_CRLF	
	// Atualiza os Pedidos de Venda
	c_Qry += " UPDATE " + RetSqlName("SC6") + " SET C6_FSTPITE = '" + IIF(IIF(AllTrim(FunName()) == 'FESTA002', M->Z2_BLOQ == '2', SZ2->Z2_BLOQ == '2'), "1' ", "2' ") + c_CRLF
	c_Qry += " WHERE (C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO) IN (" + c_CRLF
	c_Qry += " SELECT (C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO) FROM SC6010 SC6 " + c_CRLF
	c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + c_CRLF
	c_Qry += " 			AND B1_COD = C6_PRODUTO " + c_CRLF
	c_Qry += " 			AND B1_FSARTE = '" + SZ2->Z2_COD + "' " + c_CRLF
	c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + c_CRLF
	c_Qry += " 	WHERE SC6.D_E_L_E_T_<>'*'  AND C6_FILIAL = '" + xFilial("SC6") + "')" + c_CRLF
	// Atualiza as Ordens de Produ��o sem apontamentos
	If IIF(AllTrim(FunName()) == 'FESTA002', M->Z2_BLOQ == '2', SZ2->Z2_BLOQ == '2')
		c_Qry += " UPDATE " + RetSqlName("SC2") + " SET C2_TPOP = 'P' " + c_CRLF
		c_Qry += " WHERE (C2_FILIAL + C2_NUM + C2_ITEM) IN (" + c_CRLF
		c_Qry += " SELECT (C2_FILIAL + C2_NUM + C2_ITEM) FROM SC2010 SC2 " + c_CRLF
		c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + c_CRLF
		c_Qry += " 			AND B1_COD = C2_PRODUTO " + c_CRLF
		c_Qry += " 			AND B1_FSARTE = '" + SZ2->Z2_COD + "' " + c_CRLF
		c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + c_CRLF
		c_Qry += " 	WHERE SC2.D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND C2_QUJE = 0 AND C2_FILIAL = '" + xFilial("SC2") + "')" + c_CRLF
	Elseif IIF(AllTrim(FunName()) == 'FESTA002', M->Z2_BLOQ == '3', SZ2->Z2_BLOQ == '3')
		c_Qry += " UPDATE " + RetSqlName("SC2") + " SET C2_TPOP = 'F' " + c_CRLF
		c_Qry += " WHERE (C2_FILIAL + C2_NUM + C2_ITEM) IN (" + c_CRLF
		c_Qry += " SELECT (C2_FILIAL + C2_NUM + C2_ITEM) FROM SC2010 SC2 " + c_CRLF
		c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + c_CRLF
		c_Qry += " 			AND B1_COD = C2_PRODUTO " + c_CRLF
		c_Qry += " 			AND B1_FSARTE = '" + SZ2->Z2_COD + "' " + c_CRLF
		c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + c_CRLF
		c_Qry += " 	WHERE SC2.D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND C2_QUJE = 0 AND C2_FILIAL = '" + xFilial("SC2") + "') AND C2_SEQPAI NOT IN ('', '000') AND C2_SEQUEN > '001' " + c_CRLF
	Else
		c_Qry += " UPDATE " + RetSqlName("SC2") + " SET C2_TPOP = 'F' " + c_CRLF
		c_Qry += " WHERE (C2_FILIAL + C2_NUM + C2_ITEM) IN (" + c_CRLF
		c_Qry += " SELECT (C2_FILIAL + C2_NUM + C2_ITEM) FROM SC2010 SC2 " + c_CRLF
		c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + c_CRLF
		c_Qry += " 			AND B1_COD = C2_PRODUTO " + c_CRLF
		c_Qry += " 			AND B1_FSARTE = '" + SZ2->Z2_COD + "' " + c_CRLF
		c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + c_CRLF
		c_Qry += " 	WHERE SC2.D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND C2_QUJE = 0 AND C2_FILIAL = '" + xFilial("SC2") + "')" + c_CRLF
	Endif

	/*
	SELECT * FROM SC2010 SC2 
	INNER JOIN SB1010 SB1 ON B1_FILIAL = '0101'
	AND B1_COD = C2_PRODUTO
	AND B1_FSARTE <> ''
	AND SB1.D_E_L_E_T_<>'*'
	INNER JOIN SZ2010 SZ2 ON Z2_FILIAL = '0101'
	AND Z2_COD = B1_FSARTE
	AND SZ2.D_E_L_E_T_<>'*'
	WHERE 
	SC2.D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND C2_QUJE = 0
	*/
/*
	If TcSqlExec(c_Qry) < 0
		MsgStop("SQL Error: " + TcSqlError())
		TcSqlExec("ROLLBACK")
		l_Ret := .F.
	Else
		TcSqlExec("COMMIT")	
		l_Ret := .T.
	Endif
*/
// TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ACIMA DE GRAVA��O  ESTAVA GERANDO ERRO NO DBACCESS ATUAL
					TRYEXCEPTION

					TcCommit(1,ProcName())    //Begin Transaction

					IF ( TcSqlExec( c_Qry ) < 0 )
						cTCSqlError := TCSQLError()
						ConOut( cMsgOut += ( "[ProcName: " + ProcName() + "]" ) )
						cMsgOut += cCRLF
						ConOut( cMsgOut += ( "[ProcLine:" + Str(ProcLine()) + "]" ) )
						cMsgOut += cCRLF
						ConOut( cMsgOut += ( "[TcSqlError:" + cTCSqlError + "]" ) )
						cMsgOut += cCRLF
						UserException( cMsgOut )
					EndIF

					TcCommit(2,ProcName())    //Commit
					TcCommit(4)                //End Transaction

					CATCHEXCEPTION   

					TcCommit(3) //RollBack
					TcCommit(4) //End Transaction

					ENDEXCEPTION

// FIM TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ANTERIOR DE GTRAVA��O ESTAVA GERANDO ERRO NO DBACCESS ATUAL
		
Return l_Ret

/*/{Protheus.doc} f_OpsApt
Verificar o que faz com calma
@type function
@version 12.1.25 
@author Jonas Machado
@since 21/07/2021
@return variant, l_EnviaE
/*/
Static Function f_OpsApt()
	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/
	//Local c_CRLF 	 := chr(13) + chr(10)
	Local a_Area     := GetArea()
	Local c_To       := GETMV("FS_EMAIL")	//Destinat�rio do e-mail
	Local c_Corpo    := ''					//Corpo do e-mail
	Private a_Strut  := {}
	Private a_Campos := {}

	Aadd(a_Strut,{"TB_NUM"		,"C",TamSX3("C2_NUM")[1]	,0})
	Aadd(a_Strut,{"TB_ITEM"		,"C",TamSX3("C2_ITEM")[1]	,0})
	Aadd(a_Strut,{"TB_PRODUTO"	,"C",TamSX3("C2_PRODUTO")[1],0})
	Aadd(a_Strut,{"TB_PEDIDO"	,"C",TamSX3("C2_PEDIDO")[1]	,0})
	Aadd(a_Strut,{"TB_ITEMPV"	,"C",TamSX3("C2_ITEMPV")[1]	,0})

	c_Pro := CriaTrab(a_Strut, .T.)
	Use &c_Pro Shared Alias TRB New
	Index on TB_NUM To &c_Pro

	Aadd(a_Campos,{"TB_NUM"		,,'Ord. Prod.'  	,'@!'})
	Aadd(a_Campos,{"TB_ITEM"	,,'Item'			,'@!'})
	Aadd(a_Campos,{"TB_PRODUTO"	,,'Produto'  		,'@!'})
	Aadd(a_Campos,{"TB_PEDIDO"	,,'Pedido Venda'	,'@!'})
	Aadd(a_Campos,{"TB_ITEMPV"	,,'Item PV'			,'@!'})

	c_Qry := " SELECT C2_NUM, C2_ITEM, C2_PRODUTO, C2_PEDIDO, C2_ITEMPV FROM SC2010 SC2 " + c_CRLF
	c_Qry += " 		INNER JOIN SB1010 SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' " + c_CRLF
	c_Qry += " 			AND B1_COD = C2_PRODUTO " + c_CRLF
	c_Qry += " 			AND B1_FSARTE = '" + SZ2->Z2_COD + "' " + c_CRLF
	c_Qry += " 			AND SB1.D_E_L_E_T_<>'*' " + c_CRLF
	c_Qry += " 	WHERE SC2.D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND (C2_QUJE = 0 OR C2_QUJE < C2_QUANT) AND C2_DATRF = '' AND (C2_DATAPCP<>'' OR C2_PRIOR<500) AND C2_FILIAL = '" + xFilial("SC2") + "' " + c_CRLF

	//	c_Qry += " 	WHERE SC2.D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND C2_QUJE > 0 AND C2_QUJE < C2_QUANT AND C2_DATRF = '' AND C2_DATAPCP<>'' AND C2_PRIOR<500 AND C2_FILIAL = '" + xFilial("SC2") + "' " + c_CRLF


	// '<p>A Arte ' + SZ2->Z2_COD + ' - ' + AllTrim(SZ2->Z2_DESC) + ' foi bloqueada pelo usu�rio ( ' + AllTrim(UsrRetName(__CUSERID)) + ' ), mas as ordens de produ��o listadas abaixo n�o foram bloqueadas porque possuem apontamentos de produ��o:</p>' +;


	c_Corpo :=  '<p>Prezado(a)</p>' +;
	'<p>A Arte ' + SZ2->Z2_COD + ' - ' + AllTrim(SZ2->Z2_DESC) + ' houve uma tentativa de bloqueio da arte pelo usu�rio ( ' + AllTrim(UsrRetName(__CUSERID)) + ' ), verifique com o setor o motivo:</p>' +;
	'<table>' +;
	'<tr>' +;
	'<td align="left" style="padding-top: 10px; padding-bottom: 10px;">' +;
	'<table cellspacing="0" border="1" cellpadding="4">' +;
	'<tr>' +; 
	'  <th style="color: white; background-color: black;" align="center">Ordem de Produ&ccedil;&atilde;o</th> ' +;  
	'  <th style="color: white; background-color: black;" align="center">Item</th> ' +;
	'  <th style="color: white; background-color: black;" align="center">Produto</th> ' +;
	'  <th style="color: white; background-color: black;" align="center">Pedido de Venda</th> ' +; 
	'  <th style="color: white; background-color: black;" align="center">Item PV</th> ' +;
	'</tr> '

	TCQUERY c_Qry NEW ALIAS bQRY
	dbSelectArea("bQRY")
	dbGoTop()
	If bQRY->(!Eof())
		While bQRY->(!Eof())
			RecLock("TRB", .T.)
			TRB->TB_NUM   	:= bQRY->C2_NUM
			TRB->TB_ITEM    := bQRY->C2_ITEM
			TRB->TB_PRODUTO := bQRY->C2_PRODUTO
			TRB->TB_PEDIDO	:= bQRY->C2_PEDIDO
			TRB->TB_ITEMPV	:= bQRY->C2_ITEMPV
			MsUnlock()

			c_Corpo += 	'<tr>' +; 
			'  <td align="center">' + bQRY->C2_NUM + '</td> ' +;
			'  <td align="center">' + bQRY->C2_ITEM + '</td> ' +;
			'  <td align="center">' + AllTrim(bQRY->C2_PRODUTO) + '</td> ' +;
			'  <td align="center">' + bQRY->C2_PEDIDO + '</td> ' +;
			'  <td align="center">' + bQRY->C2_ITEMPV + '</td> ' +;
			'</tr>'

			bQRY->(dbSkip())
		End

		c_Corpo +=  '</table>' +;
		'<br/>' +;
		'<p>Atenciosamente, ' + AllTrim(SM0->M0_NOME) + '</p>'

		If !Empty(c_To)	
			f_Enviar(AllTrim(c_To), c_Corpo)
			l_EnviaE = .T.
			ShowHelpDlg(SM0->M0_NOME,;
			{"Existem OPs em produ��o e n�o � permitido bloquear a arte. " },5,;
			{"Contacte o Setor de PCP."},5)

		Endif

		SetPrvt("oDlg1","oBrw1","oBtn1","oBtn2")

		/*������������������������������������������������������������������������ٱ�
		�� Definicao do Dialog e todos os seus componentes.                        ��
		ٱ�������������������������������������������������������������������������*/
		oDlg1      := MSDialog():New( 091,232,440,908,"Ordens de Produ��o com Apontamentos Parciais",,,.F.,,,,,,.T.,,,.T. )

		oBrw1      := MsSelect():New( "TRB","","",a_Campos,.F.,,{008,012,148,328},,,,, )

		oBtn1      := TButton():New( 154,244,"&Imprimir",oDlg1,{|| oDlg1:End(), f_ImpOps()},040,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 154,288,"&Cancelar",oDlg1,{|| oDlg1:End()},040,012,,,,.T.,,"",,,,.F. )

		oDlg1:Activate(,,,.T.)		
	End	

	bQRY->(dbCloseArea())
	TRB->(dbCloseArea())

	RestArea(a_Area)
Return l_EnviaE




/*/{Protheus.doc} f_OpsAptc
Verificar o que faz
@type function
@version 12.1.25
@author jonas.machado
@since 21/07/2021
@return variant, l_EnviaEc
/*/					
Static Function f_OpsAptc()
	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/

	Local a_Area     := GetArea()
	Local c_To       := GETMV("FS_EMAILC")	//Destinat�rio do e-mail
	Local c_Corpo    := ''					//Corpo do e-mail
	Private a_Strut  := {}
	Private a_Campos := {}


	c_Corpo :=  '<p>Prezado(a)</p>' +;
	'<p>Na Arte ' + SZ2->Z2_COD + ' - ' + AllTrim(SZ2->Z2_DESC) + ' foi alterado seu STATUS pelo usu�rio ( ' + AllTrim(UsrRetName(__CUSERID)) + ' )</p>' +;
	'<table>' +;
	'<tr>' +;
	'<td align="left" style="padding-top: 10px; padding-bottom: 10px;">' +;
	'<table cellspacing="0" border="1" cellpadding="4">' +;
	'<tr>'
//	c_Corpo +=  '</table>' +;
	c_Corpo +='<br/>' +;
	'<p>Atenciosamente, ' + AllTrim(SM0->M0_NOME) + '</p>'

	If !Empty(c_To)	
		f_Enviar(AllTrim(c_To), c_Corpo)
		l_EnviaEc = .T.
	Endif


	RestArea(a_Area)
Return l_EnviaEc


/*/{Protheus.doc} f_ImpOps
Verificar o que faz
@type function
@version 12.1.25
@author jonas.machado
@since 21/07/2021
@return variant, Null
/*/
Static Function f_ImpOps
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local titulo         := "ARTE - " + AllTrim(SZ2->Z2_DESC)
	Local nLin           := 80
	Local Cabec1         := "           Ordens de Produ��o com Apontamentos Parciais"
	Local Cabec2         := "Ord. Prod.  Item  Produto                         Pedido  Item PV"
	Local aOrd 			 := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 080
	Private tamanho      := "P"
	Private nomeprog     := "FESTA002" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FESTA002" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString   	 := ""

	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


/*/{Protheus.doc} RunReport
	Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS monta a janela com a regua de processamento. 
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@param Cabec1, character, Cabe�alho
	@param Cabec2, character, Cabe�alho
	@param Titulo, variant, T�tulo
	@param nLin, numeric, N�mero da linha calculada no for
	@return variant, Null
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	
	//���������������������������������������������������������������������Ŀ
	//� SETREGUA -> Indica quantos registros serao processados para a regua �
	//�����������������������������������������������������������������������

	SetRegua(RecCount())

	//���������������������������������������������������������������������Ŀ
	//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
	//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
	//� cessa enquanto a filial do registro for a filial corrente. Por exem �
	//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
	//�                                                                     �
	//� dbSeek(xFilial())                                                   �
	//� While !EOF() .And. xFilial() == A1_FILIAL                           �
	//�����������������������������������������������������������������������	

	dbSelectArea("bQRY")
	dbGoTop()

	While bQRY->(!Eof())
		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������

		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo: 
		//Ord. Prod.  Item  Produto                         Pedido  Item PV
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
		@nLin,000 PSAY bQRY->C2_NUM
		@nLin,012 PSAY bQRY->C2_ITEM
		@nLin,018 PSAY bQRY->C2_PRODUTO
		@nLin,050 PSAY bQRY->C2_PEDIDO
		@nLin,058 PSAY bQRY->C2_ITEMPV

		nLin := nLin + 1 // Avanca a linha de impressao

		bQRY->(dbSkip())
	End

	//���������������������������������������������������������������������Ŀ
	//� Finaliza a execucao do relatorio...                                 �
	//�����������������������������������������������������������������������

	SET DEVICE TO SCREEN

	//���������������������������������������������������������������������Ŀ
	//� Se impressao em disco, chama o gerenciador de impressao...          �
	//�����������������������������������������������������������������������

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return


/*/{Protheus.doc} f_Enviar
	Envia e-mail notificando sobre bloqueio de arte
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 21/07/2021
	@param c_To, character, Destinat�rio do e-mail
	@param c_Corpo, character, Corpo do e-mail
	@return variant, Null
/*/
Static Function f_Enviar(c_To, c_Corpo)
	Local c_status := ''

	IF M->Z2_BLOQ='1'
		c_status:="Arte Nova"
	ELSE
		IF M->Z2_BLOQ='3'
			c_status:="Fotolito a Desenvolver"
		ELSE
			IF M->Z2_BLOQ='4'
				c_status:="Pronta para Impressao"
			ELSE
			Endif
		Endif
	Endif

	/*
	1 - Arte Nova
	2 - Bloqueada
	3 - Fotolito a Desenvolver
	4 - Pronta para Impressao
	*/

	IF M->Z2_BLOQ='2'
		U_TBSENDMAIL(c_To, c_Corpo, 'Notifica��o de tentativa de bloqueio da Arte ' + AllTrim(SZ2->Z2_DESC), .T.)
	ELSE
		U_TBSENDMAIL(c_To, c_Corpo, 'Altera��o de STATUS da ARTE "'+AllTrim(SZ2->Z2_DESC)+ '" para: "'+c_status+'" ', .T.)
	Endif	
	l_EnviaE := .T.
Return
