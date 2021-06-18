#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FFINR001     � Autor � AP6 IDE            � Data �  18/09/18���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
 
User Function FFINR01A
 
	//���������������������������������������������������������������������Ŀ
  	//� Declaracao de Variaveis                                             �
  	//�����������������������������������������������������������������������
  
  	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  	Local cDesc3         := "T�tulos a Pagar"
  	Local cPict          := ""
  	Local titulo         := "T�tulos a Pagar Com PCC"
	Local nLin           := 80
//	Local Cabec1         := "Fornecedor              Observa��o                                      Num.        Pc       Emiss�o    Vencimento            Valor         "
	Local Cabec1         := "Fornecedor              Num.        Pc       Emiss�o    Vencimento            Valor         Valor C/PCC"
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd 			 := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "M"
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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/09/12   ���
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
  	Local c_Tipo     := ""
  	Local n_TotTipo  := 0
  	Local n_TotDia   := 0.00
  	Local n_Total    := 0
  	Local d_Dia      := Stod("  /  /  ")
  	Local a_Titulos  := {}
  
  	c_Qry := f_Qry()
  
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
       		/*
       		Condicao
			Esta fun��o permite avaliar uma condi��o de pagamento, retornando um array
  			multidimensional com informa��es referentes ao valor e vencimento de cada
   			parcela, de acordo com a condi��o de pagamento.
  
   			Sintaxe
   			Condicao(nValTot,cCond,nVIPI,dData,nVSol)
 
   			Parametros
   			nValTot � Valor total a ser parcelado
   			cCond � C�digo da condi��o de pagamento
   			nVIPI � Valor do IPI, destacado para condi��o que obrigue o pagamento
   			do IPI na 1� parcela
   			dData � Data inicial para considerar
  
   			Retorna
   			aRet � Array de retorno ( { {dVencto, nValor} , ... } )
       		*/
       		a_Parcelas := Condicao(QRY->VALOR, QRY->CONDICAO, 0, Stod(QRY->EMISSAO))
  
       		For i:=1 To Len(a_Parcelas)
           		If (a_Parcelas[i][1] >= MV_PAR05) .And. (a_Parcelas[i][1] <= MV_PAR06)
           			//Fornecedor              Observa��o                                                     Num.        Pc       Emiss�o    Vencimento               Valor
	            	AADD( a_Titulos, {QRY->FORNECE, QRY->OBS, QRY->NOTA, QRY->PEDIDO, QRY->EMISSAO, Dtos(DataValida(a_Parcelas[i][1], .T.)), a_Parcelas[i][2], QRY->TIPO})
           		Endif
         	Next
         Else
			AADD( a_Titulos, {QRY->FORNECE, QRY->OBS, QRY->NOTA, QRY->PEDIDO, QRY->EMISSAO, QRY->VENC, QRY->VALOR, QRY->TIPO})
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
  	//���������������������������������������������������������������������Ŀ
  	//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
  	//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
  	//� cessa enquanto a filial do registro for a filial corrente. Por exem �
  	//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
  	//�                                                                     �
  	//� dbSeek(xFilial())                                                   �
  	//� While !EOF() .And. xFilial() == A1_FILIAL                           �
  	//�����������������������������������������������������������������������
  	
  	i:=1
  
  	While i <= Len(a_Titulos)
   		d_Dia    := Stod(a_Titulos[i][6])
		n_TotDia := 0.00
  
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
�	            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	            	nLin := 8
	         	Endif
	         
				// Coloque aqui a logica da impressao do seu programa...
	    		// Utilize PSAY para saida na impressora. Por exemplo: 
	    		//Fornecedor              Observa��o                                      Num.        Pc       Emiss�o    Vencimento            Valor        Prefixo     Aprovadores        
	    		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	    		//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
//		       	@nLin,000 PS�AY PADR(a_Titulos[i][1], 20)
		       	@nLin,000 PSAY PADR(a_Titulos[i][1], 20)
//		   		@nLin,024 PSAY PADR(MemoLine(AllTrim(a_Titulos[i][2]),45,1), 45)
		   		@nLin,024 PSAY PADR(a_Titulos[i][3], 9) 
		   	   
		   		M_DOC = ALLTRIM(PADR(a_Titulos[i][3], 9)) 
		   		
		   		
		   		//PCC CONTAS A PAGAR    
		   		m_fornec = PADR(a_Titulos[i][1], 20)
		   		
		   		dbSelectArea("SA2")
	            dbSetOrder(2)
			    dbGoTop()
				If dbSeek(xFilial("SA2") + m_fornec)
				   M_CODFORN = SA2->A2_COD 
				ENDIF
		   	  
		   		 	     
		   		
		   		MPCC = 0.00
			    dbSelectArea("SE2")
	            dbSetOrder(19)
			    dbGoTop()
			    If dbSeek(m_DOC) 
				      DO while SE2->E2_NUM = M_DOC     
				   		   		    	   		
				      				      
				         IF xFilial("SE2") = SE2->E2_FILIAL .AND.  M_CODFORN = SE2->E2_FORNECE     
			            	msgbox(M_CODFORN+"  "+SE2->E2_FORNECE)
				            M_NAT = SE2->E2_NATUREZ 
				            MPCC =  MPCC+E2_COFINS+E2_PIS+E2_CSLL+E2_DECRESC
				            dbSelectArea("SED")
	                        dbSetOrder(1)
				            dbGoTop()
				            dbSeek(xFilial("SED")+M_NAT)
				            M_DESC_NAT = SUBSTR(SED->ED_DESCRIC,1,15)
				            
				            dbSelectArea("SE2")
				            
				            EXIT 
				         ENDIF 
				         DBSKIP()
				      ENDDO    
                   endif 
		   		
		   				   		
		   		
		       	@nLin,035 PSAY PADR(a_Titulos[i][4], 6)
		       	mpedido = trim(PADR(a_Titulos[i][4], 6))
		       	
		       	@nLin,045 PSAY PADR(Stod(a_Titulos[i][5]), 10)
	    		@nLin,060 PSAY PADR(Stod(a_Titulos[i][6]), 10)
	    		@nLin,070 PSAY Transform(a_Titulos[i][7],"@E 999,999,999.99")
	    		@nLin,095 PSAY Transform(MPCC,"@E 999,999,999.99")
//	    		@nLin,158 PSAY IIF(dDataBase > a_Parcelas[i][1], StrZero(DateDiffDay(dDataBase, a_Parcelas[i][1]), 2, 0) + " dia(s)", "")
/*	
		   		If MLCount(AllTrim(a_Titulos[i][2]), 45) > 1
		   			nLin := nLin + 1 // Avanca a linha de impressao
			
		        	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   		    	nLin := 8
		         	Endif
			
		       		@nLin,024 PSAY MemoLine(AllTrim(a_Titulos[i][2]),45,2)
		   		Endif
*/	 

	            //busca aprovador do pedido 03/04/17 - wellington ////////////////
          
         /*   
                
                M_DOC = PADR(a_Titulos[i][3], 9)
                dbSelectArea("SD1")
	            dbSetOrder(1)
				dbGoTop()  
				If dbSeek(xFilial("SD1") + M_DOC)
				   MPEDIDO = SD1->D1_PEDIDO
                //   ALERT(xFilial("SCR")+"PC"+mpedido)
                ENDIF
                
                      
                COL = 20            
                nLin = nLin+1
                dbSelectArea("SCR")
	            dbSetOrder(1)
				dbGoTop()
				IF dbSeek(xFilial("SCR")+"PC"+mpedido,.T.) 
	                 
	             //   ALERT(xFilial("SCR")+"PC"+mpedido)
	             
	                do while SCR->CR_NUM = mpedido   
	                   MDATA    = SCR->CR_EMISSAO
	                   USERLIB  = SCR->CR_USERLIB   
	                   LIBAPROV = SCR->CR_LIBAPRO
	                   dbSelectArea("SAK")
	                   dbSetOrder(1)
			           dbGoTop()
			           IF dbSeek(xFilial("SAK")+LIBAPROV,.T.)   
			              nomeaprov = ALLTRIM(SAK->AK_NOME)
	                   ENDIF
	                   	                    
	                   IF COL  = 20
	                      COL = 0
	                      @nLin,COL PSAY "APROVADOR=====>  "
	                      COL = 30
	                   ENDIF
	                   @nLin,COL PSAY LIBAPROV+" - "+nomeaprov 
	                   COL = COL+30
	                   IF COL > 80
	                      nLin = nLin + 1
	                      COL = 20
	                   ENDIF   
	                  
	                   dbSelectArea("SCR")                              
	                   DBSKIP()
	                ENDDO   
	                
	            ENDIF      
           
               */
           
                                
                /////////////////////////////////////////////////
                       
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
	    	@nLin,070 PSAY Transform(n_TotTipo,"@E 999,999,999.99")
	    	nLin := nLin + 1 // Avanca a linha de impressao
	    	@nLin,000 PSAY Replicate("-",limite)              
	    	nLin := nLin + 1 // Avanca a linha de impressao
		End

	  	@nLin,000 PSAY Replicate("-",limite)              
	  	nLin := nLin + 1 // Avanca a linha de impressao
	  	@nLin,000 PSAY "Total a Pagar no dia " + Dtoc(d_Dia) + " - "
	  	@nLin,070 PSAY Transform(n_TotDia,"@E 999,999,999.99")
	  	nLin := nLin + 1 // Avanca a linha de impressao
	  	@nLin,000 PSAY Replicate("-",limite)              
	  	nLin := nLin + 1 // Avanca a linha de impressao
	End
	
  	@nLin,000 PSAY Replicate("-",limite)              
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY "Total a Pagar no Per�odo - "
  	@nLin,070 PSAY Transform(n_Total,"@E 999,999,999.99")
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
                
 // ALTERAR CONAPRO

Static Function f_Qry()
	c_Qry := " SELECT * FROM " + chr(13)
//  	c_Qry += " (SELECT A2_NOME FORNECE, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_EMISSAO EMISSAO, '' VENC, SUM(C7_TOTAL)+SUM(C7_VALIPI) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO" + chr(13)
  	c_Qry += " (SELECT A2_NOME FORNECE, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO,  C7_FSDTPRE EMISSAO, '' VENC, SUM(C7_TOTAL)+SUM(C7_VALIPI) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO" + chr(13)
  	c_Qry += " FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '" + xFilial("SA2") + "' AND (A2_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') AND SA2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE C7_CONAPRO = 'L' AND C7_QUJE < C7_QUANT AND (C7_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "') AND SC7.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + chr(13)
  	c_Qry += " AND C7_NUM NOT IN (SELECT C7_NUM FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SD1") + " SD1 ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM AND D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE SC7.D_E_L_E_T_<>'*' AND C7_FILIAL = '" + xFilial("SC7") + "' GROUP BY C7_NUM)
  	c_Qry += " GROUP BY C7_NUM, A2_NOME, C7_OBS, C7_FSDTPRE, C7_COND " + chr(13)
  	c_Qry += " UNION ALL " + chr(13)
 	c_Qry += " SELECT E2_NOMFOR, E2_HIST, E2_NUM, '', E2_EMISSAO, E2_VENCREA, E2_SALDO, '', 'Confirmados' " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SE2") + " SE2 " + chr(13)
//  	c_Qry += " WHERE E2_TIPO <> 'PA' AND E2_MULTNAT <> '1' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE E2_TIPO <> 'PA' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + chr(13)
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
 	PutSx1(c_Perg,"02","Fornecedor at�?" ,"","","mv_ch2","C",06,0,0,"G","","SA2","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Emiss�o de?"     ,"","","mv_ch3","D",08,0,0,"G","",""   ,"","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Emiss�o at�?"    ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Vencimento de?"  ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Vencimento at�?" ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
    PutSx1(c_Perg,"06","Status Pedido ?" ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","")
    
Return Nil