#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FFINR001     º Autor ³ AP6 IDE            º Data ³  28/09/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
User Function FFINR001
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Declaracao de Variaveis                                             ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  	Local cDesc3         := "Títulos a Pagar"
  	Local cPict          := ""
  	Local titulo         := "Títulos a Pagar"
	Local nLin           := 80
	Local Cabec1         := "Fornecedor              Observação                                                     Num.        Pc       Emissão    Vencimento               Valor         Dias Atraso"
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd 			 := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "G"
	Private nomeprog     := "FFINR001" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFINR001" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private c_Perg       := "FFINR001" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString   	 := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  
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
  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local nOrdem
  	Local c_Tipo     := ""
  	Local n_TotTipo  := 0
  	Local n_TotDia   := 0
  	Local n_Total    := 0
  	Local d_Dia      := Stod("  /  /  ")
  
  	c_Qry := f_Qry()
  
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()
  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	SetRegua(RecCount())
  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
  	//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
  	//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
  	//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
  	//³                                                                     ³
  	//³ dbSeek(xFilial())                                                   ³
  	//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	dbGoTop()
  	While QRY->(!Eof())
   		d_Dia  := Stod(QRY->EMISSAO)
		//   n_TotDia := 0
  
     	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     	//³ Verifica o cancelamento pelo usuario...                             ³
     	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
     	If lAbortPrint
        	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        	Exit
     	Endif
  
     	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     	//³ Impressao do cabecalho do relatorio. . .                            ³
     	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
     	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        	nLin := 8
     	Endif
     
		//While QRY->(!Eof()) .And. (Stod(QRY->EMISSAO) == d_Dia)
     	c_Tipo := QRY->TIPO
     	n_TotTipo := 0
    
		//If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		//	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//  nLin := 8
		//Endif
  
        While QRY->(!Eof()) .And. (Stod(QRY->EMISSAO) == d_Dia) .And. (QRY->TIPO == c_Tipo)
        	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            	nLin := 8
         	Endif
         
         	If AllTrim(c_Tipo) == 'Previstos'
        		/*
         		Condicao
  				Esta função permite avaliar uma condição de pagamento, retornando um array
    			multidimensional com informações referentes ao valor e vencimento de cada
    			parcela, de acordo com a condição de pagamento.
  
    			Sintaxe
    			Condicao(nValTot,cCond,nVIPI,dData,nVSol)
    
    			Parametros
    			nValTot – Valor total a ser parcelado
    			cCond – Código da condição de pagamento
    			nVIPI – Valor do IPI, destacado para condição que obrigue o pagamento
    			do IPI na 1ª parcela
    			dData – Data inicial para considerar
  
    			Retorna
    			aRet – Array de retorno ( { {dVencto, nValor} , ... } )
        		*/
        		a_Parcelas := Condicao(QRY->VALOR, QRY->CONDICAO, 0, Stod(QRY->EMISSAO))
  
        		For i:=1 To Len(a_Parcelas)
            		If (a_Parcelas[i][1] >= MV_PAR05) .And. (a_Parcelas[i][1] <= MV_PAR06)
             			// Coloque aqui a logica da impressao do seu programa...
              			// Utilize PSAY para saida na impressora. Por exemplo: 
             			//Fornecedor              Observação                                                     Num.        Pc       Emissão    Vencimento               Valor         Dias Atraso
              			//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
              			//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
		            	@nLin,000 PSAY PADR(QRY->FORNECE, 20)
		          		@nLin,024 PSAY PADR(MemoLine(AllTrim(QRY->OBS),60,1), 60)
		          		@nLin,087 PSAY PADR(QRY->NOTA, 9)
		            	@nLin,099 PSAY PADR(QRY->PEDIDO, 6)
		            	@nLin,108 PSAY PADR(Stod(QRY->EMISSAO), 10)
              			@nLin,119 PSAY PADR(a_Parcelas[i][1], 10)
              			@nLin,132 PSAY Transform(a_Parcelas[i][2],"@E 99,999,999,999,999.99")
              			@nLin,158 PSAY IIF(dDataBase > a_Parcelas[i][1], StrZero(DateDiffDay(dDataBase, a_Parcelas[i][1]), 2, 0) + " dia(s)", "")

		          		If MLCount(AllTrim(QRY->OBS), 60) > 1
		           			nLin := nLin + 1 // Avanca a linha de impressao
		
				        	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		        		    	nLin := 8
				         	Endif
		
			          		@nLin,024 PSAY MemoLine(AllTrim(QRY->OBS),60,2)
		          		Endif
  
               			n_TotTipo  += (a_Parcelas[i][2])
      					n_TotDia   += (a_Parcelas[i][2])
              			n_Total    += (a_Parcelas[i][2])
   
            			nLin := nLin + 1 // Avanca a linha de impressao
            		Endif
        		Next
    		Else
           		// Coloque aqui a logica da impressao do seu programa...
            	// Utilize PSAY para saida na impressora. Por exemplo: 
           		//Fornecedor              Observação                                                     Num.        Pc       Emissão    Vencimento               Valor         Dias Atraso
            	//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
            	//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
            	@nLin,000 PSAY PADR(QRY->FORNECE, 20)
          		@nLin,024 PSAY PADR(MemoLine(AllTrim(QRY->OBS),60,1), 60)
          		@nLin,087 PSAY PADR(QRY->NOTA, 9)
            	@nLin,099 PSAY PADR(QRY->PEDIDO, 6)
            	@nLin,108 PSAY PADR(Stod(QRY->EMISSAO), 10)
            	@nLin,119 PSAY PADR(Stod(QRY->VENC), 10)
            	@nLin,132 PSAY Transform(QRY->VALOR,"@E 99,999,999,999,999.99")
       			@nLin,158 PSAY IIF(dDataBase > Stod(QRY->VENC), StrZero(DateDiffDay(dDataBase, Stod(QRY->VENC)), 2, 0) + " dia(s)", "")

          		If MLCount(AllTrim(QRY->OBS), 60) > 1
           			nLin := nLin + 1 // Avanca a linha de impressao

		        	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        		    	nLin := 8
		         	Endif

	          		@nLin,024 PSAY MemoLine(AllTrim(QRY->OBS),60,2)
          		Endif

             	n_TotTipo  += (QRY->VALOR)
    			n_TotDia   += (QRY->VALOR)
            	n_Total    += (QRY->VALOR)
 
          		nLin := nLin + 1 // Avanca a linha de impressao
    		Endif
  
       		QRY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
       	End

		If n_TotTipo > 0 
	    	@nLin,000 PSAY Replicate("-",220)              
	 		nLin := nLin + 1 // Avanca a linha de impressao
	    	@nLin,000 PSAY "Total Títulos " + c_Tipo + " - "
	    	@nLin,132 PSAY Transform(n_TotTipo,"@E 99,999,999,999,999.99")
	    	nLin := nLin + 1 // Avanca a linha de impressao
	    	@nLin,000 PSAY Replicate("-",220)              
	    	nLin := nLin + 1 // Avanca a linha de impressao
		Endif
	/*
	End
 
  	@nLin,000 PSAY Replicate("-",220)              
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY "Total a Pagar no Dia " + Dtoc(d_Dia) + " - "
  	@nLin,102 PSAY Transform(n_TotDia,"@E 999,999,999.99")
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY Replicate("-",220)              
  	nLin := nLin + 1 // Avanca a linha de impressao
	*/
	End
  
  	@nLin,000 PSAY Replicate("-",220)              
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY "Total a Pagar no Período - "
  	@nLin,132 PSAY Transform(n_Total,"@E 99,999,999,999,999.99")
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY Replicate("-",220)              
 
  	QRY->(dbCloseArea())
  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Finaliza a execucao do relatorio...                                 ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	SET DEVICE TO SCREEN
  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	If aReturn[5]==1
    	dbCommitAll()
     	SET PRINTER TO
     	OurSpool(wnrel)
  	Endif
  
  	MS_FLUSH()
Return
 
 
 
Static Function f_Qry()
	c_Qry := " SELECT * FROM " + chr(13)
  	c_Qry += " (SELECT A2_NREDUZ FORNECE, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_EMISSAO EMISSAO, '' VENC, SUM(C7_TOTAL) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO" + chr(13)
  	c_Qry += " FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = C7_FORNECE AND (A2_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') AND SA2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE C7_CONAPRO = 'L' AND C7_QUJE < C7_QUANT AND (C7_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "') AND SC7.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + chr(13)
  	c_Qry += " AND C7_NUM NOT IN (SELECT C7_NUM FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SD1") + " SD1 ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM AND D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE SC7.D_E_L_E_T_<>'*' AND C7_FILIAL = '" + xFilial("SC7") + "' GROUP BY C7_NUM)
  	c_Qry += " GROUP BY C7_NUM, A2_NREDUZ, C7_OBS, C7_EMISSAO, C7_COND " + chr(13)
  	c_Qry += " UNION ALL " + chr(13)
 	c_Qry += " SELECT E2_NOMFOR, E2_HIST, E2_NUM, '', E2_EMISSAO, E2_VENCREA, E2_VALOR, '', 'Confirmados' " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SE2") + " SE2 " + chr(13)
  	c_Qry += " WHERE E2_TIPO <> 'PA' AND E2_MULTNAT <> '1' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND E2_FILIAL = '" + xFilial("SE2") + "' " + chr(13)
  	c_Qry += " AND (E2_FORNECE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') " + chr(13)
  	c_Qry += " AND (E2_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "') " + chr(13)
  	c_Qry += " AND (E2_VENCREA BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "')) TAB " + chr(13)
  	c_Qry += " ORDER BY EMISSAO

  	MemoWrit("C:\TEMP\FFINR001.SQL",c_Qry)
Return c_Qry



Static Function CriaPerg(c_Perg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 	PutSx1(c_Perg,"01","Fornecedor de?"  ,"","","mv_ch1","C",06,0,0,"G","","SA2","","","mv_par01","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"02","Fornecedor até?" ,"","","mv_ch2","C",06,0,0,"G","","SA2","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Emissão de?"     ,"","","mv_ch3","D",08,0,0,"G","",""   ,"","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Emissão até?"    ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Vencimento de?"  ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Vencimento até?" ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
Return Nil