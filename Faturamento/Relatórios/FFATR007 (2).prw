#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FFATR007     º Autor ³ AP6 IDE            º Data ³  28/09/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
User Function FFATR007
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Declaracao de Variaveis                                             ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  	Local cDesc3         := "Romaneio de Saída"
  	Local cPict          := ""
  	Local titulo         := "Romaneio de Saída"
	Local nLin           := 80
	Local Cabec1         := "OP              Produto                          Descrição                                            Lote             Quantidade   Arm Orig   Arm Dest   Documento   Dt Emissão"
				    	   //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	    				   //         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10

	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd 			 := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "FFATR007" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFATR007" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private c_Perg       := "FFATR007" // Coloque aqui o nome do arquivo usado para impressao em disco
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
  
  	c_Qry := f_Qry()
  
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()
	
	If QRY->(Eof())
		ShowHelpDlg(SM0->M0_NOME, {"Nenhum registro encontrado."},5,{"Verifique os parâmetros informados."},5)
	  	QRY->(dbCloseArea())
	  	Return
	Endif
	
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
     	c_Produto := QRY->ZW_PRODUTO
     	c_Descri  := AllTrim(Posicione("SB1", 1, xFIlial("SB1") + QRY->ZW_PRODUTO, "B1_DESC"))
     	n_TotProd := 0

		While QRY->(!Eof()) .And. c_Produto == QRY->ZW_PRODUTO  
			c_Lote    := QRY->ZW_LOTECTL
	     	n_TotLote := 0			

			While QRY->(!Eof()) .And. c_Produto == QRY->ZW_PRODUTO .And. c_Lote == QRY->ZW_LOTECTL
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
		     	
				// Coloque aqui a logica da impressao do seu programa...
	    		// Utilize PSAY para saida na impressora. Por exemplo: 
				//OP              Produto                          Descrição                                            Lote             Quantidade   Arm Orig   Arm Dest   Documento   Dt Emissão"
	    		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	    		//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
		       	@nLin,000 PSAY QRY->ZW_OP
		   		@nLin,016 PSAY c_Produto
		   		@nLin,049 PSAY MemoLine(c_Descri, 50, 1)
		       	@nLin,102 PSAY c_Lote
	    		@nLin,115 PSAY Transform(QRY->ZW_QUANT, "@E 999,999,999.99")
		       	@nLin,135 PSAY QRY->ZW_LOCORIG
		       	@nLin,146 PSAY QRY->ZW_LOCDEST
		       	@nLin,154 PSAY QRY->ZW_DOC
		       	@nLin,166 PSAY Dtoc(Stod(QRY->ZW_EMISSAO))

		   		If MLCount(c_Descri, 50) > 1
		   			nLin := nLin + 1 // Avanca a linha de impressao
					
		        	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   		    	nLin := 8
		         	Endif
					
		       		@nLin,044 PSAY MemoLine(c_Descri, 50, 2)
		   		Endif

			    n_TotLote  += QRY->ZW_QUANT
			    n_TotProd  += QRY->ZW_QUANT

	        	nLin := nLin + 1 // Avanca a linha de impressao

		        QRY->(dbSkip())	        	
	        End
		
	    	@nLin,000 PSAY Replicate("-",limite)              
	 		nLin := nLin + 1 // Avanca a linha de impressao
	    	@nLin,000 PSAY "Total Lote " + AllTrim(c_Lote) + " - "
	    	@nLin,115 PSAY Transform(n_TotLote,"@E 999,999,999.99")
	    	nLin := nLin + 1 // Avanca a linha de impressao
	    	@nLin,000 PSAY Replicate("-",limite)              
	    	nLin := nLin + 1 // Avanca a linha de impressao
        End

    	@nLin,000 PSAY Replicate("-",limite)              
 		nLin := nLin + 1 // Avanca a linha de impressao
    	@nLin,000 PSAY "Total Produto " + AllTrim(c_Produto) + " - "
    	@nLin,115 PSAY Transform(n_TotProd,"@E 999,999,999.99")
    	nLin := nLin + 1 // Avanca a linha de impressao
    	@nLin,000 PSAY Replicate("-",limite)              
    	nLin := nLin + 1 // Avanca a linha de impressao       	
  	End

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
  	c_Qry := " SELECT * FROM " + RetSqlName("SZW") + " SZW " + chr(13)
  	c_Qry += " WHERE SZW.D_E_L_E_T_<>'*' AND ZW_FILIAL = '" + xFilial("SZW") + "' "  + chr(13)
  	c_Qry += " AND (ZW_OP BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') " + chr(13)
  	c_Qry += " AND (ZW_PRODUTO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') " + chr(13)
  	c_Qry += " AND (ZW_LOTECTL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') " + chr(13)
  	c_Qry += " AND (ZW_EMISSAO BETWEEN '" + Dtos(MV_PAR07) + "' AND '" + Dtos(MV_PAR08) + "') " + chr(13)
  	c_Qry += " AND (ZW_LOCORIG BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "') " + chr(13)
  	c_Qry += " AND (ZW_DOC BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "') " + chr(13)
  	c_Qry += " AND (ZW_LOCDEST BETWEEN '" + MV_PAR13 + "' AND '" + MV_PAR14 + "') " + chr(13)
  	If !Empty(MV_PAR15)
	  	c_Qry += " AND (ZW_USUARIO = '" + MV_PAR15 + "') " + chr(13)
  	Endif
  	c_Qry += " ORDER BY ZW_PRODUTO, ZW_LOTECTL, ZW_OP "

  	MemoWrit("C:\TEMP\FFATR007.SQL",c_Qry)
Return c_Qry



Static Function CriaPerg(c_Perg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 	PutSx1(c_Perg,"01","OP de?"  	    ,"","","mv_ch1","C",08,0,0,"G","","SZW","","","mv_par01","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"02","OP até?" 		,"","","mv_ch2","C",08,0,0,"G","","SZW","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Produto de?"    ,"","","mv_ch3","C",TamSX3("B1_COD")[1],0,0,"G","","SB1"   ,"","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Produto até?"   ,"","","mv_ch4","C",TamSX3("B1_COD")[1],0,0,"G","","SB1"   ,"","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Lote de?"    	,"","","mv_ch5","C",TamSX3("D3_LOTECTL")[1],0,0,"G","",""   	  ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Lote até?"   	,"","","mv_ch6","C",TamSX3("D3_LOTECTL")[1],0,0,"G","",""   	  ,"","","mv_par06","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"07","Emissão de?"    ,"","","mv_ch7","D",8,0,0,"G","",""   	  ,"","","mv_par07","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"08","Emissão até?"   ,"","","mv_ch8","D",8,0,0,"G","",""   	  ,"","","mv_par08","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"09","Local de?"    	,"","","mv_ch9","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par09","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"10","Local até?"   	,"","","mv_cha","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par10","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"11","Documento de?" 	,"","","mv_chb","C",TamSX3("D3_DOC")[1],0,0,"G","",""   	  ,"","","mv_par11","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"12","Documento até?"	,"","","mv_chc","C",TamSX3("D3_DOC")[1],0,0,"G","",""   	  ,"","","mv_par12","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"13","Destino de?"    ,"","","mv_chd","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par13","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"14","Destino até?"   ,"","","mv_che","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par14","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"15","Usuário?"       ,"","","mv_chf","C",TamSX3("ZW_USUARIO")[1],0,0,"G","","SZWU" ,"","","mv_par15","","","","","","","","","","","","","","","","")
Return Nil