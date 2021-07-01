#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"         
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FFINR002     º Autor ³ AP6 IDE            º Data ³  28/09/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE1.                                º±±
±±º          ³                                FLUXO DE CAIXA               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
User Function FFINR002
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Declaracao de Variaveis                                             ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  	Local cDesc3         := "Fluxo de Caixa"
  	Local cPict          := ""
  	Local titulo         := "Fluxo de Caixa"
	Local nLin           := 80
	Local Cabec1         := ""
//	Local Cabec2         := "Cliente/Fornecedor                                           Emissão   Num.        Pc       Venc Real  Vencimento            Valor         "
	Local Cabec2         := "Cliente/Fornecedor   Nat/CC                 Emissão   Num.        Pc       Venc Real  Vencimento        Receber             Pagar             Saldo"	
	Local imprime        := .T.
	Local aOrd 			 := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	//Private limite       := 132    
	Private limite       := 240 
	Private tamanho      := "M"
	Private nomeprog     := "FFINR002" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFINR002" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private c_Perg       := "FFINR002" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString   	 := ""                      
	MPCC := 0.00

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
  
	Cabec1 := "Saldo inicial: " + Transform(MV_PAR09, "@E 999,999,999.99")

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
  	Local n_TotDiaRc := 0
  	Local n_Total    := 0
  	Local n_TotalRec := 0
  	Local d_Dia      := Stod("  /  /  ")
  	Local a_Titulos  := {}
  	Local n_Saldo    := MV_PAR09

  	c_Qry := f_Qry()

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If QRY->(Eof())
		ShowHelpDlg(SM0->M0_NOME, {"Nenhum registro encontrado."},5,{"Verifique os parâmetros informados."},5)
	  	QRY->(dbCloseArea())
	  	Return
	Endif

  	While QRY->(!Eof())
     	c_Tipo := QRY->TIPO

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
           		If (a_Parcelas[i][1] >= MV_PAR07) .And. (a_Parcelas[i][1] <= MV_PAR08)
           			//Fornecedor              Observação                                                     Num.        Pc       Emissão    Vencimento               Valor
	            	AADD( a_Titulos, {QRY->FORNECE, QRY->OBS, QRY->NOTA, QRY->PEDIDO, QRY->EMISSAO, Dtos(a_Parcelas[i][1]), a_Parcelas[i][2], "Pagar", Dtos(DataValida(a_Parcelas[i][1], .T.))})
           		Endif
         	Next
		Elseif AllTrim(QRY->TIPO) == 'Receber'
			AADD( a_Titulos, {QRY->FORNECE, QRY->OBS, QRY->NOTA, QRY->PEDIDO, QRY->EMISSAO, QRY->VENC, QRY->VALOR, QRY->TIPO, Dtos(DataValida(DaySum(Stod(QRY->VENC), 1), .T.))})
        Else
			AADD( a_Titulos, {QRY->FORNECE, QRY->OBS, QRY->NOTA, QRY->PEDIDO, QRY->EMISSAO, QRY->VENC, QRY->VALOR, QRY->TIPO, QRY->VENC})
        Endif

        QRY->(dbSkip())
  	End

  	QRY->(dbCloseArea())
//  	aSort(a_Titulos,,, {|x, y| x[6]+x[8]+x[1] < y[6]+y[8]+y[1]})
  	aSort(a_Titulos,,, {|x, y| x[9]+x[8]+x[1] < y[9]+y[8]+y[1]})

  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ SETREGUA -> Indica quantos registros serao processados ?para a regua ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
// 	SetRegua(RecCount())
  	SetRegua(Len(a_Titulos))  
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
  	//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
  	//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
  	//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
  	//³                                                                     ³
  	//³ dbSeek(xFilial())                                                   ³
  	//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	
  	i:=1
  
  	While i <= Len(a_Titulos)
//   		d_Dia      := Stod(a_Titulos[i][6])
   		d_Dia      := Stod(a_Titulos[i][9])
		n_TotDia   := 0
		n_TotDiaRc := 0
  
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
     
		//If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		//	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//  nLin := 8
		//Endif
//        While i <= Len(a_Titulos) .And. (Stod(a_Titulos[i][6]) == d_Dia)
        While i <= Len(a_Titulos) .And. (Stod(a_Titulos[i][9]) == d_Dia)
	     	c_Tipo    := AllTrim(a_Titulos[i][8])
           	n_TotTipo := 0

	    	nLin++

        	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            	nLin := 8
         	Endif

	    	@nLin,000 PSAY "Títulos a " + c_Tipo
	    	nLin++

//	        While i <= Len(a_Titulos) .And. (Stod(a_Titulos[i][6]) == d_Dia) .And. (AllTrim(a_Titulos[i][8]) == c_Tipo)
	        While i <= Len(a_Titulos) .And. (Stod(a_Titulos[i][9]) == d_Dia) .And. (AllTrim(a_Titulos[i][8]) == c_Tipo)
	        	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
	            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	            	nLin := 8
	         	Endif
	         
				// Coloque aqui a logica da impressao do seu programa...
	    		// Utilize PSAY para saida na impressora. Por exemplo: 
				//Cliente/Fornecedor                          Emissão   Num.        Pc       Venc Real  Vencimento        Receber          Pagar          Saldo
	    		//0123556789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	    		//         10        20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
//		       	@nLin,000 PSAY PADR(a_Titulos[i][1], 20) 
                
                
                // BUSCA NAT FINANCEIRA ////////////////////////////////////////////////////wellington
                     
                   m_codforn ="  "  
                   M_NAT = "   "
                   M_DESC_NAT = "  "
                   
                   m_valor = Transform(a_Titulos[i][7],"@E 999,999,999,999.99")
                   M_DOC = ALLTRIM(PADR(a_Titulos[i][3], 9))    
				   m_fornec = PADR(a_Titulos[i][1], 40)  
                   m_fornec2 = PADR(a_Titulos[i][1], 20)
                   M_NOMERED = PADR(a_Titulos[i][1], 40) 
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
                    
                   IF  M_NAT = "   " 
                       dbSelectArea("SE2")
	                   dbSetOrder(19)
				       dbGoTop()
				       If dbSeek(m_DOC) 
				          DO while SE2->E2_NUM = M_DOC  
				             IF xFilial("SE2") = SE2->E2_FILIAL .AND. SUBSTR(m_fornec2,1,6) = SUBSTR(SE2->E2_NOMFOR,1,6) 
				                M_NAT = SE2->E2_NATUREZ   
				                
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
                   ENDIF        
                   
                                   
                
                ////// CONTAS A RECEBER BUSCA NATUREZA       
                
                M_DOC = ALLTRIM(PADR(a_Titulos[i][3], 9))  
                       
                
                
                dbSelectArea("SD2")
	            dbSetOrder(3)
				dbGoTop()  
				If dbSeek(xFilial("SD2") + M_DOC)  
					 										   		                                                
				      M_ESPECIE = SD2->D2_SERIE    
				     				     				      
                      dbSelectArea("SE1")
	                  dbSetOrder(1)
				      dbGoTop()           
				      If dbSeek(xFilial("SE1")+M_ESPECIE+M_DOC)
				         M_NAT = SE1->E1_NATUREZ   
				         
				         dbSelectArea("SED")
	                     dbSetOrder(1)
				         dbGoTop()
				         dbSeek(xFilial("SED")+M_NAT)
				         M_DESC_NAT = SUBSTR(SED->ED_DESCRIC,1,15)  
				         
				         dbSelectArea("SE1")
				      ENDIF  
                
                ENDIF                                                 
                
                /// BUSCA CC DO PEDIDO PARA A NATUREZA
                
                M_CCPED = " " 
                M_PED = PADR(a_Titulos[i][4], 6)
               	dbSelectArea("SC7")
            	dbGoTop()
	            dbSetOrder(1)
	            If dbSeek(xFilial("SC7")+M_PED)
	               M_CCPED = SC7->C7_CC  
	               dbSelectArea("CTT")
            	   dbGoTop()
	               dbSetOrder(1)
	               If dbSeek(xFilial("CTT")+M_CCPED)
	                  M_DESC_NAT = Substr(CTT->CTT_DESC01,1,10)
	                  M_NAT = M_CCPED
	               ENDIF   
	               
	            ELSE
	               M_CCPED = " "     
                ENDIF
                
               
                
                
                
		       	@nLin,000 PSAY PADR(a_Titulos[i][1], 20)+" "+alltrim(M_NAT)+" "+alltrim(M_DESC_NAT)
//		   		@nLin,024 PSAY PADR(MemoLine(AllTrim(a_Titulos[i][2]),55,1), 45)
                
		       	@nLin,044 PSAY PADR(Stod(a_Titulos[i][5]), 10)
		       	
		   		@nLin,056 PSAY PADR(a_Titulos[i][3], 9)
		       	@nLin,067 PSAY PADR(a_Titulos[i][4], 6)
		       	@nLin,075 PSAY PADR(Stod(a_Titulos[i][9]), 10)
	    		@nLin,086 PSAY PADR(Stod(a_Titulos[i][6]), 10)
				If AllTrim(c_Tipo) == 'Pagar'               
				    apagar =  a_Titulos[i][7] - MPCC 
		    	//	@nLin,112 PSAY Transform(a_Titulos[i][7],"@E 999,999,999.99")
      		  		@nLin,112 PSAY Transform(apagar,"@E 999,999,999,999.99")
		  		Else
		    		@nLin,097 PSAY Transform(a_Titulos[i][7],"@E 999,999,999,999.99")
		  		Endif
		  		
		  		If AllTrim(c_Tipo) == 'Receber'
	      			n_Saldo += a_Titulos[i][7]
	     		Else
	      			n_Saldo -= a_Titulos[i][7]
	     		Endif
	     		
	    		@nLin,133 PSAY Transform(n_Saldo,"@E 999,999,999,999.99")	   

//	    		@nLin,158 PSAY IIF(dDataBase > a_Parcelas[i][1], StrZero(DateDiffDay(dDataBase, a_Parcelas[i][1]), 2, 0) + " dia(s)", "")
/*	
		   		If MLCount(AllTrim(a_Titulos[i][2]), 45) > 1
		   			nLin := nLin + 1 // Avanca a linha de impressao
			
		        	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		            	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   		    	nLin := 8
		         	Endif
			
		       		@nLin,024 PSAY MemoLine(AllTrim(a_Titulos[i][2]),45,2)
		   		Endif
*/	  
	    		n_TotTipo  += (a_Titulos[i][7])

				If AllTrim(c_Tipo) == 'Receber'
		    		n_TotDiaRc += (a_Titulos[i][7])
		        	n_TotalRec += (a_Titulos[i][7])
		      	Else
		    		n_TotDia   += (a_Titulos[i][7])
		        	n_Total    += (a_Titulos[i][7])
		      	Endif
		      	
	        	nLin := nLin + 1 // Avanca a linha de impressao
	        	i++
	        	IncRegua()
	        End

//	    	@nLin,000 PSAY Replicate("-",limite)              
//	 		nLin := nLin + 1 // Avanca a linha de impressao
//	    	@nLin,000 PSAY "Total Títulos a " + c_Tipo + " - "
//	    	@nLin,117 PSAY Transform(n_TotTipo,"@E 999,999,999.99")
//	    	nLin := nLin + 1 // Avanca a linha de impressao
//	    	@nLin,000 PSAY Replicate("-",limite)              
//	    	nLin := nLin + 1 // Avanca a linha de impressao
		End

//		n_Saldo += n_TotDiaRc - n_TotDia

	  	@nLin,000 PSAY Replicate("-",limite)              
	  	nLin := nLin + 1 // Avanca a linha de impressao
	  	@nLin,000 PSAY "Total a Pagar no dia " + Dtoc(d_Dia) + " - "
//	  	@nLin,117 PSAY Transform(n_TotDia,"@E 999,999,999.99")
	  	@nLin,097 PSAY Transform(n_TotDia,"@E 999,999,999,999.99")
	  	nLin := nLin + 1 // Avanca a linha de impressao
	  	@nLin,000 PSAY "Total a Receber no dia " + Dtoc(d_Dia) + " - "
//	  	@nLin,120 PSAY Transform(n_TotDiaRc,"@E 999,999,999.99")
	  	@nLin,97 PSAY Transform(n_TotDiaRc,"@E 999,999,999,999.99")
	  	nLin := nLin + 1 // Avanca a linha de impressao
	  	@nLin,000 PSAY "Saldo no dia " + Dtoc(d_Dia) + " - "
	  	@nLin,133 PSAY Transform(n_Saldo,"@E 999,999,999,999.99")
	  	nLin := nLin + 1 // Avanca a linha de impressao
	  	@nLin,000 PSAY Replicate("-",limite)              
	  	nLin := nLin + 1 // Avanca a linha de impressao
	End
	
  	@nLin,000 PSAY Replicate("-",limite)              
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY "Total a Pagar no Período - "
//  	@nLin,117 PSAY Transform(n_Total,"@E 999,999,999.99")
  	@nLin,097 PSAY Transform(n_Total,"@E 999,999,999,999.99")
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY "Total a Receber no Período - "
//  	@nLin,120 PSAY Transform(n_TotalRec,"@E 999,999,999.99")
  	@nLin,097 PSAY Transform(n_TotalRec,"@E 999,999,999,999.99")
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY "Saldo no Período - "
  	@nLin,133 PSAY Transform(n_Saldo,"@E 999,999,999,999.99")
  	nLin := nLin + 1 // Avanca a linha de impressao
  	@nLin,000 PSAY Replicate("-",limite)

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
//  	c_Qry += " (SELECT A2_NOME FORNECE, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_EMISSAO EMISSAO, '' VENC, SUM(C7_TOTAL)+SUM(C7_VALIPI) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO" + chr(13)
  	c_Qry += " (SELECT A2_NOME FORNECE, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_FSDTPRE EMISSAO, '' VENC, SUM(C7_TOTAL)+SUM(C7_VALIPI) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO" + chr(13)
  	c_Qry += " FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND (A2_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL = '" + XFILIAL("SA2") + "'" + chr(13)
  	c_Qry += " WHERE C7_CONAPRO = 'L' AND C7_QUJE < C7_QUANT AND SC7.C7_RESIDUO <> 'S' AND (C7_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') AND SC7.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + chr(13)
  	c_Qry += " AND C7_NUM NOT IN (SELECT C7_NUM FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SD1") + " SD1 ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM AND D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_<>'*' " + chr(13)
 // ALTERACAO PARA EXCLUIR PEDIDOS COM RESIDUO ELIMINADO-----------04/05/2017 WELLINGTON  	
  	c_Qry += " WHERE SC7.D_E_L_E_T_<>'*' AND SC7.C7_RESIDUO <> 'S' AND C7_FILIAL = '" + xFilial("SC7") + "' GROUP BY C7_NUM)
  	c_Qry += " GROUP BY C7_NUM, A2_NOME, C7_OBS, C7_FSDTPRE, C7_COND " + chr(13)
  	c_Qry += " 		UNION ALL " + chr(13)
 	c_Qry += " SELECT CASE WHEN E2_ORIGEM='MATA460' THEN A1_NOME ELSE A2_NOME END, E2_HIST, E2_NUM, '', E2_EMISSAO, E2_VENCREA, E2_SALDO, '', 'Pagar' " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SE2") + " SE2 " + chr(13)
  	c_Qry += " LEFT JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL = '" + XFILIAL("SA2") + "'" + chr(13)
  	c_Qry += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = E2_FORNECE AND A1_LOJA = E2_LOJA AND SA1.D_E_L_E_T_<>'*' AND A1_FILIAL = '" + XFILIAL("SA1") + "'" + chr(13)
//  	c_Qry += " WHERE E2_TIPO <> 'PA' AND E2_MULTNAT <> '1' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE E2_TIPO <> 'PA' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND E2_FILIAL = '" + xFilial("SE2") + "' " + chr(13)
  	c_Qry += " AND (E2_FORNECE BETWEEN '" + MïV_PAR03 + "' AND '" + MV_PAR04 + "') " + chr(13)
  	c_Qry += " AND (E2_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') " + chr(13)
  	c_Qry += " AND (E2_VENCREA BETWEEN '" + Dtos(MV_PAR07) + "' AND '" + Dtos(MV_PAR08) + "') " + chr(13)
  	c_Qry += "   	UNION ALL " + chr(13)
 	c_Qry += " SELECT A1_NOME, E1_HIST, E1_NUM, '', E1_EMISSAO, E1_VENCREA, E1_SALDO, '', 'Receber' " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SE1") + " SE1 " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_<>'*' AND A1_FILIAL = '" + XFILIAL("SA1") + "'" + chr(13)
//  	c_Qry += " WHERE E1_TIPO <> 'PA' AND E1_MULTNAT <> '1' AND E1_SALDO <> 0 AND SE1.D_E_L_E_T_<>'*' " + chr(13)
//  	c_Qry += " WHERE E1_TIPO <> 'PA' AND E1_SALDO <> 0 AND SE1.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " WHERE E1_SALDO <> 0 AND SE1.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND E1_FILIAL = '" + xFilial("SE1") + "' " + chr(13)
  	c_Qry += " AND (E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') " + chr(13)
  	c_Qry += " AND (E1_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') " + chr(13)
  	c_Qry += " AND (E1_VENCREA BETWEEN '" + Dtos(DaySub(MV_PAR07, 1)) + "' AND '" + Dtos(MV_PAR08) + "')) TAB " + chr(13)
  	c_Qry += " ORDER BY EMISSAO

  	MemoWrit("C:\TEMP\FFINR002.SQL",c_Qry)
Return c_Qry



Static Function CriaPerg(c_Perg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 	PutSx1(c_Perg,"01","Cliente de?"  	 ,"","","mv_ch1","C",06,0,0,"G","","SA1","","","mv_par01","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"02","Cliente até?" 	 ,"","","mv_ch2","C",06,0,0,"G","","SA1","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Fornecedor de?"  ,"","","mv_ch3","C",06,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Fornecedor até?" ,"","","mv_ch4","C",06,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Emissão de?"     ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Emissão até?"    ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"07","Vencimento de?"  ,"","","mv_ch7","D",08,0,0,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"08","Vencimento até?" ,"","","mv_ch8","D",08,0,0,"G","",""   ,"","","mv_par08","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"09","Saldo inicial?"  ,"","","mv_ch9","N",TamSX3("E1_VALOR")[1],TamSX3("E1_VALOR")[2],0,"G","",""   ,"","","mv_par09","","","","","","","","","","","","","","","","")
Return Nil