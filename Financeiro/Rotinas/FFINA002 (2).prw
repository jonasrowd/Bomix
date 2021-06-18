#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"  


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FFINA002     � Autor � TBA001 -XXX     � Data �  09/12/15���
�������������������������������������������������������������������������͹��
���Descricao � Alterar os vencimentos dos T�tulos baseando em acrescimo de���
���          � dias e condi��o de pagamento                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function FFINA002           


	// alterado wellington  13/09/2018 desabilitado




	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio e ALTERAR os vencimentos dos T�tulos Previstos "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "T�tulos a Pagar"
	Local cPict          := ""
	Local titulo         := "Alterar Vencimento - T�tulos a Pagar - Previstos"
	Local nLin           := 80
	//	Local Cabec1         := "Fornecedor              Observa��o                                      Num.        Pc       Emiss�o    Vencimento            Valor         "
	Local Cabec1         := "Fornecedor                                                       Emiss�o Ant        Pc       Emiss�o    Vencimento            Valor         "
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd 			 := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "FFINA002" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFINA002" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private c_Perg       := "FFINA002" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString   	 := ""

	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������

	CriaPerg(c_Perg)
	Pergunte(c_Perg,.F.)

	wnrel := SetPrint(cString,NomeProg,c_Perg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � TBA001 -XXX     � Data �  09/12/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local nOrdem
	Local c_Tipo     	:= ""
	Local n_TotTipo  	:= 0
	Local n_TotDia   	:= 0
	Local n_Total    	:= 0
	Local d_Dia      	:= Stod("  /  /  ")
	Local a_Titulos  	:= {}  
	Local a_Parcelas  	:= {}
	Local a_1Parcelas 	:= {}
	Local i

	c_Qry 				:= f_Qry() 
	c_Historico 		:= ""

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If QRY->(Eof())
		ShowHelpDlg(SM0->M0_NOME, {"Nenhum registro encontrado."},5,{"Verifique os par�metros informados."},5)
		QRY->(dbCloseArea())
		Return
	Endif

	While QRY->(!Eof())
		c_Tipo := QRY->TIPO

		If AllTrim(c_Tipo) == 'Previstos'

			a_Parcelas  := Condicao(QRY->VALOR, QRY->CONDICAO, 0, Stod(QRY->EMISSAO))
			a_1Parcelas := Condicao(QRY->VALOR, QRY->CONDICAO, 0, Stod(QRY->EMISSAO)+mv_par09)

			For i:=1 To Len(a_Parcelas)
				If (a_Parcelas[i][1] >= MV_PAR05) .And. (a_Parcelas[i][1] <= MV_PAR06)
					//Fornecedor              Observa��o                                                     Num.        Pc       Emiss�o    Vencimento               Valor           			
					AADD( a_Titulos, {QRY->FORNECE, QRY->OBS, QRY->EMISSAO, QRY->PEDIDO, DTOS(STOD(QRY->EMISSAO)+mv_par09), Dtos(DataValida(a_1Parcelas[i][1], .T.)), a_1Parcelas[i][2], QRY->TIPO}) 
					f_AtuSC7(QRY->PEDIDO, DTOS(STOD(QRY->EMISSAO)+mv_par09))
				Endif
			Next
		Endif

		QRY->(dbSkip())
	End

	QRY->(dbCloseArea())
	aSort(a_Titulos,,, {|x, y| x[6]+x[8]+x[1] < y[6]+y[8]+y[1]})

	//���������������������������������������������������������������������Ŀ
	//� SETREGUA -> Indica quantos registros serao processados para a regua �
	//�����������������������������������������������������������������������

	// 	SetRegua(RecCount())
	SetRegua(Len(a_Titulos))  

	i:=1

	While i <= Len(a_Titulos)
		d_Dia    := Stod(a_Titulos[i][6])
		n_TotDia := 0

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
			nLin := 8
		Endif

		//If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		//	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//  nLin := 8
		//Endif
		While i <= Len(a_Titulos) .And. (Stod(a_Titulos[i][6]) == d_Dia)
			c_Tipo    := a_Titulos[i][8]
			n_TotTipo := 0

			If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			While i <= Len(a_Titulos) .And. (Stod(a_Titulos[i][6]) == d_Dia) .And. (a_Titulos[i][8] == c_Tipo)
				If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif

				// Coloque aqui a logica da impressao do seu programa...
				// Utilize PSAY para saida na impressora. Por exemplo: 
				//Fornecedor              Observa��o                               EMISSAO ANT        Pc       Emiss�o    Vencimento            Valor         
				//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
				//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
				@nLin,000 PSAY PADR(a_Titulos[i][1], 70)
				@nLin,067 PSAY PADR(stod(a_Titulos[i][3]), 10)
				@nLin,084 PSAY PADR(a_Titulos[i][4], 6)
				@nLin,093 PSAY PADR(Stod(a_Titulos[i][5]), 10)
				@nLin,104 PSAY PADR(Stod(a_Titulos[i][6]), 10)
				@nLin,117 PSAY Transform(a_Titulos[i][7],"@E 999,999,999.99")

				n_TotTipo  += (a_Titulos[i][7])
				n_TotDia   += (a_Titulos[i][7])
				n_Total    += (a_Titulos[i][7])

				nLin := nLin + 1 // Avanca a linha de impressao
				i++
				IncRegua()
			End

			@nLin,000 PSAY Replicate("-",limite)              
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Total T�tulos " + c_Tipo + " - "
			@nLin,117 PSAY Transform(n_TotTipo,"@E 999,999,999.99")
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY Replicate("-",limite)              
			nLin := nLin + 1 // Avanca a linha de impressao
		End

		@nLin,000 PSAY Replicate("-",limite)              
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Total a Pagar no dia " + Dtoc(d_Dia) + " - "
		@nLin,117 PSAY Transform(n_TotDia,"@E 999,999,999.99")
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY Replicate("-",limite)              
		nLin := nLin + 1 // Avanca a linha de impressao
	End

	@nLin,000 PSAY Replicate("-",limite)              
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin,000 PSAY "Total a Pagar no Per�odo - "
	@nLin,117 PSAY Transform(n_Total,"@E 999,999,999.99")
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin,000 PSAY Replicate("-",limite)

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



Static Function f_Qry()
	c_Qry := " SELECT * FROM " + chr(13)
	c_Qry += " (SELECT A2_NOME FORNECE, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_FSDTPRE EMISSAO, '' VENC, SUM(C7_TOTAL)+SUM(C7_VALIPI) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO" + chr(13)
	c_Qry += " FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
	c_Qry += " JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '" + xFilial("SA2") + "' AND (A2_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') AND SA2.D_E_L_E_T_<>'*' " + chr(13)
	c_Qry += " WHERE C7_CONAPRO = 'L' AND C7_QUJE < C7_QUANT AND  (C7_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "') AND SC7.D_E_L_E_T_<>'*' " + chr(13)
	c_Qry += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + chr(13)
	c_Qry += " AND C7_NUM  BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' " + chr(13)
	c_Qry += " AND C7_NUM NOT IN (SELECT C7_NUM FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
	c_Qry += " JOIN " + RetSqlName("SD1") + " SD1 ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM AND D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_<>'*' " + chr(13)
	c_Qry += " WHERE SC7.D_E_L_E_T_<>'*' AND C7_FILIAL = '" + xFilial("SC7") + "' GROUP BY C7_NUM) " + chr(13)
	c_Qry += " GROUP BY C7_NUM, A2_NOME, C7_OBS, C7_FSDTPRE, C7_COND " + chr(13)
	c_Qry += " ) TAB " + chr(13)
	c_Qry += " ORDER BY EMISSAO

	MemoWrit("C:\BOMIX\FFINR002.SQL",c_Qry)
Return c_Qry



Static Function CriaPerg(c_Perg)
	PutSx1(c_Perg,"01","Fornecedor de?"  ,"","","mv_ch1","C",06,0,0,"G","","SA2","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"02","Fornecedor at�?" ,"","","mv_ch2","C",06,0,0,"G","","SA2","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"03","Emiss�o de?"     ,"","","mv_ch3","D",08,0,0,"G","",""   ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"04","Emiss�o at�?"    ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"05","Vencimento de?"  ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"06","Vencimento at�?" ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"07","Pedido de?"  	 ,"","","mv_ch7","C",06,0,0,"G","","SC7","","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"08","Pedido at�?" 	 ,"","","mv_ch8","C",06,0,0,"G","","SC7","","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"09","Dias      ?" 	 ,"","","mv_ch9","N",05,0,0,"G","",""   ,"","","mv_par09","","","","","","","","","","","","","","","","")
Return Nil    


Static Function f_AtuSC7 (c_Pedido, c_Data)
	Local c_QryUp := ""
	Local cCRLF          := CRLF
	Local cMsgOut        := ""


	//c_QryUp   := " BEGIN TRAN " + chr(13)
	// Atualiza os Pedidos de Compra
	c_QryUp := " UPDATE " + RetSqlName("SC7") + " SET C7_FSDTPRE = '" + c_Data + "' " + chr(13)
	c_QryUp += " WHERE D_E_L_E_T_<>'*'  AND C7_FILIAL = '" + xFilial("SC7") + "' AND C7_NUM = '" + c_Pedido + "' " + chr(13)

	c_Historico +=c_QryUp

	MemoWrit("C:\BOMIX\FFINHIST.SQL",c_Historico)

	/*
	If TcSqlExec(c_QryUp) < 0
	MsgStop("SQL Error: " + TcSqlError())
	TcSqlExec("ROLLBACK")
	Else
	TcSqlExec("COMMIT")	
	Endif
	*/


	// TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ACIMA DE GRAVA��O  ESTAVA GERANDO ERRO NO DBACCESS ATUAL


	TRYEXCEPTION

	TcCommit(1,ProcName())    //Begin Transaction


	IF ( TcSqlExec( c_QryUp ) < 0 )
		MsgStop("SQL Error: " + TcSqlError())
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

	/*
	1 Begin Transaction
	2 End Transaction
	3 RollBack
	4 Commit
	5 Especifico para AS/400?
	*/

	// FIM TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ANTERIOR DE GTRAVA��O ESTAVA GERANDO ERRO NO DBACCESS ATUAL











Return 