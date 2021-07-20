// Bibliotecas necess�rias
#Include "TOTVS.ch"
#Include "RWMAKE.ch"
#Include "RPTDEF.ch"

/*/{Protheus.doc} BLTITAU
	Imprime boleto do Ita�
	@type Function
	@version 12.1.25
	@author Greice Wicks
	@since 08/11/2012
/*/
User Function BLTITAU()
	Local lOK      := .T. // Controle de impress�o da rotina
	Private cAlias := ""  // Alias da tabela tempor�ria

	// Cria o Pergunte()
	FCriaSX1()

	// Verifica se a execu��o est� sendo realizada via
	// interface gr�fica, caso sim, abre a tela do Pergunte()
	If (!IsBlind())
		lOK := Pergunte("BLTITAU", .T.)
	Else
		Pergunte("BLTITAU", .F.)
	EndIf

	// Se o usu�rio clicou em OK ou o fonte est� sendo
	// excutado via job, monta a tabela tempor�ria
	If (lOK)
		cAlias := TableDef()
	EndIf

	// Se estive sendo executa via interface gr�fica,
	// monta e exibe a tela de sele��o de t�tulos
	If (lOK .And. !IsBlind())
		Private cMark   := GetMark()
		Private aCpoBro := FieldDef(1)
		Private oDlg    := NIL
		Private oMark   := NIL

		DEFINE MSDIALOG oDlg TITLE "T�tulos" FROM 9,0 TO 400,800 PIXEL
			oMark := MSSelect():New(cAlias, "E1_OK", "", aCpoBro, .F., @cMark, {17, 1, 150, 400}, NIL, NIL, NIL, NIL, NIL)
			oMark:bMark := {|| DoMark(cAlias, cMark)}
			@ C(120),C(20)  Button "Marcar Todos" Size C(061),C(010) Action MsgRun("Marcando os pedidos..... Aguarde...", "Selecionando os Pedidos", {|| Marcar()}) PIXEL OF oDlg
			@ C(120),C(100) Button "Desmarcar Todos" Size C(061),C(010) Action MsgRun("Desmarcando os pedidos..... Aguarde...", "Selecionando os Pedidos", {|| Desmarcar()}) PIXEL OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| lOK := .T., oDlg:End()}, {|| lOK := .F., oDlg:End()})
	EndIf

	// Se o clicado em OK, imprime
	// Se via interface gr�fica, tamb�m imprime
	If (lOK)
		Processa({||MontaRel()})
	EndIf

	// Fecha a tabela ap�s o uso
	DBSelectArea(cAlias)
	DBCloseArea()
Return (NIL)

/*/{Protheus.doc} MontaRel
	Montagem do relat�rio que ser� impresso
	@type function
	@version  12.1.25
	@author Microsiga
	@since 21/11/05
/*/
Static Function MontaRel()
	Local oPrint
	Local nX			:= 0
	Local cNroDoc 		:= " "
	Local aDadosEmp    	:= {SM0->M0_NOMECOM                                    	  ,; //[1]Nome da Empresa
		SM0->M0_ENDCOB                                     						  ,; //[2]Endere�o
		AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
		"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
		"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
		"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          	   ; //[6]
		Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
		Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
		"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
		Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
	Local aDadosTit   	:= {}
	Local aDadosBanco 	:= {}
	Local aDatSacado  	:= {}
	Local aBolText    	:= {"AP�S O VENCIMENTO COBRAR JUROS DE R$", "PROTESTAR AP�S 3 DIAS DE ATRASO. ","AO DIA"}
	Local nI          	:= 1
	Local aCB_RN_NN   	:= {}
	Local nVlrAbat	  	:= 0
	Local cLocal		:= "\BoletoBomix\Itau\"
	Local cAlias := GetArea()
	Private cStartPath  := GetSrvProfString("Startpath","")

	dbSelectArea(cAlias)
	ProcRegua(RecCount())

	Do While (SE1)->(!EOF())

	   IF  (SE1)->E1_PORTADO == "CX1"
	       (SE1)->(DBSKIP())
	       LOOP
	   ELSE
	       DBSELECTAREA("SC5")
	       SC5->(DBSETORDER(1))
	       IF SC5->(DBSEEK(XFILIAL("SC5") + (SE1)->E1_PEDIDO))
				IF SC5->C5_BANCO == "CX1"
					(SE1)->(DBSKIP())
					LOOP
				ENDIF
	       ENDIF

	       DBSELECTAREA("SF2")
	       SF2->(DBSETORDER(1))

	       IF SF2->(DBSEEK(XFILIAL("SF2") + (SE1)->(E1_NUM + E1_SERIE + E1_CLIENTE + E1_LOJA)))
		       CCONDPAG := SF2->F2_COND
		       DbSelectArea("SE4")
			   SE4->(DbSetOrder(1))

			   //DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21)
			   IF SE4->(DbSeek(xFilial("SE4") + CCONDPAG))
				  IF (SE4->E4_TIPO == "1") .OR. (SE4->E4_TIPO == "5")
				  		APAGAMENTOS := STRTOKARR(SE4->E4_COND, ",")
				  		IF (VAL(APAGAMENTOS[1]) == 0) .AND. (VAL((SE1)->E1_PARCELA) <= 1)
				             (SE1)->(DBSKIP())
				             LOOP
				  		ENDIF
				  ELSEIF (SE4->E4_TIPO == "8")
				  		APAGAMENTOS := STRTOKARR(STRTRAN(STRTRAN(SE4->E4_COND, "["), "]"), ",")
				  		IF (VAL(APAGAMENTOS[1]) == 0) .AND. (VAL((SE1)->E1_PARCELA) <= 1)
				             (SE1)->(DBSKIP())
				             LOOP
				  		ENDIF
				  ENDIF
		       ENDIF
	       ENDIF
	   ENDIF

		If Marked("E1_OK")
			If Empty(MV_PAR19)

				//Posiciona o SA6 (Bancos)
				DbSelectArea("SA6")
				DbSetOrder(1)
				//DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21)
				If DbSeek(xFilial("SA6")+(SE1)->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
						Help(NIL, NIL, "CADASTRO BANCO", NIL, ("Banco " + MV_PAR19 + "/ Ag�ncia: " + MV_PAR20 + " /Conta: " + MV_PAR21 + " inv�lidos.");
						,1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique se os par�metros est�o preenchidos corretamente."})
					Return
				Endif
				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				//DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21)
				If DbSeek(xFilial("SEE")+(SE1)->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
						Help(NIL, NIL, "CADASTRO BANCO", NIL, ("Banco " + MV_PAR19 + "/ Ag�ncia: " + MV_PAR20 + " /Conta: " + MV_PAR21 + " inv�lidos.");
						,1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique se os par�metros est�o preenchidos corretamente."})
					Return
				Endif
			Else
				//Posiciona o SA6 (Bancos)
				DbSelectArea("SA6")
				DbSetOrder(1)
				If DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21) == .F.
					Help(NIL, NIL, "CADASTRO BANCO", NIL, ("Banco " + MV_PAR19 + "/ Ag�ncia: " + MV_PAR20 + " /Conta: " + MV_PAR21 + " inv�lidos.");
					,1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique se os par�metros est�o preenchidos corretamente."})
					Return
				Endif
				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				If DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21) == .F.
					Help(NIL, NIL, "CADASTRO BANCO", NIL, ("Par�metros de Banco " + MV_PAR19 + "/ Ag�ncia: " + MV_PAR20 + " /Conta: " + MV_PAR21 + " inv�lidos.");
					,1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique se os par�metros est�o preenchidos corretamente."})
					Return
				Endif
			Endif

			//posiciona no pedido
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+(SE1)->E1_PEDIDO,.T.)

			If !empty(SC5->C5_CLIENTE+SC5->C5_LOJACLI).and.(SC5->C5_FILIAL+SC5->C5_NUM==(SE1)->E1_FILIAL+(SE1)->E1_PEDIDO)
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.T.)
			Else
				//Posiciona o SA1 (Cliente)
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+(SE1)->E1_CLIENTE+(SE1)->E1_LOJA,.T.)
			Endif

			aAdd(aDadosBanco, Alltrim(SA6->A6_COD))     // [1]Numero do Banco
			aAdd(aDadosBanco, Alltrim(SA6->A6_NOME))    // [2]Nome do Banco
			aAdd(aDadosBanco, Alltrim(SA6->A6_AGENCIA)) // [3]Ag�ncia
			aAdd(aDadosBanco, Alltrim(SA6->A6_NUMCON))  // [4]Conta Corrente
			aAdd(aDadosBanco, Alltrim(SA6->A6_DVCTA))   // [5]D�gito da conta corrente
			aAdd(aDadosBanco, Alltrim("109"))     // [6]Codigo da Carteira

			If Empty(SA1->A1_ENDCOB)
				aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Raz�o Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]C�digo
				AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endere�o
				AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
				SA1->A1_EST                                      ,;     	// [5]Estado
				SA1->A1_CEP                                      ,;      	// [6]CEP
				SA1->A1_CGC										 ,;         // [7]CGC
				SA1->A1_PESSOA									  }         // [8]PESSOA
			Else
				aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Raz�o Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]C�digo
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endere�o
				AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
				SA1->A1_ESTC	                                    ,;   	// [5]Estado
				SA1->A1_CEPC                                        ,;   	// [6]CEP
				SA1->A1_CGC											,;		// [7]CGC
				SA1->A1_PESSOA										 }		// [8]PESSOA
			Endif

			//nVlrAbat   :=  SomaAbat((SE1)->E1_PREFIXO,(SE1)->E1_NUM,(SE1)->E1_PARCELA,"R",1,,(SE1)->E1_CLIENTE,(SE1)->E1_LOJA)
			/*
			--------------------------------------------------------------
			Parte do Nosso Numero. Sao 8 digitos para identificar o titulo
			--------------------------------------------------------------
			*/
			cNroDoc	:= StrZero(	Val(Alltrim((SE1)->E1_NUM)+Alltrim((SE1)->E1_PARCELA)),8)
			DbSelectArea("SE1")
			RecLock("SE1",.F.)
			(SE1)->E1_NUMBCO 	:=	cNroDoc   		// Nosso n�mero (Ver f�rmula para calculo)
			(SE1)->E1_PORTADO :=	aDadosBanco[1]
			(SE1)->E1_AGEDEP  :=	aDadosBanco[3]
			(SE1)->E1_CONTA   :=	aDadosBanco[4]
			MsUnlock()
			/*
			----------------------
			Monta codigo de barras
			----------------------
			*/
			//mostra = str(nVlrAbat,12,2)
		    //MsgBox(mostra)
			aCB_RN_NN := fLinhaDig(aDadosBanco[1]      ,; // Numero do Banco
			"9"            ,; // Codigo da Moeda
			aDadosBanco[6]      ,; // Codigo da Carteira
			aDadosBanco[3]      ,; // Codigo da Agencia
			aDadosBanco[4]      ,; // Codigo da Conta
			aDadosBanco[5]      ,; // DV da Conta
		    (E1_VALOR-nVlrAbat) ,; // Valor do Titulo
			E1_VENCTO           ,; // Data de Vencimento do Titulo
			cNroDoc              ) // Numero do Documento no Contas a Receber
			dvNN := Alltrim(Str(Modulo10(aDadosBanco[3]+aDadosBanco[4]+aDadosBanco[6]+cNroDoc)))

			//FALAR COM BIGOIS DESSE MEU IF QUE EM TESE RESOLVEU OS TITULOS SEM PARCELAS.
			If Empty((SE1)->E1_PARCELA)
		    	cNumTit := AllTrim(E1_NUM)+"-1"
			Elseif  (SE1)->E1_SALDO == 0 .And. Empty((SE1)->E1_PARCELA)
				cNumTit := AllTrim(E1_NUM)+"-1PG"
			Elseif (SE1)->E1_SALDO == 0 .And. !Empty((SE1)->E1_PARCELA)
				cNumTit := AllTrim(E1_NUM)+"-"+AllTrim(E1_PARCELA)+"PG"
			Else
			    cNumTit := AllTrim(E1_NUM)+"-"+AllTrim(E1_PARCELA)
		    Endif

	       // MsgBox(STR(nVlrAbat))
			aDadosTit	:= {cNumTit				,;  // [1] N�mero do t�tulo
			E1_EMISSAO                          ,;  // [2] Data da emiss�o do t�tulo
			dDataBase                    		,;  // [3] Data da emiss�o do boleto
			E1_VENCTO                           ,;  // [4] Data do vencimento
			(E1_SALDO - nVlrAbat)               ,;  // [5] Valor do t�tulo
			aCB_RN_NN[3]                        ,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
			E1_PREFIXO                          ,;  // [7] Prefixo da NF
			E1_TIPO	                           	}   // [8] Tipo do Titulo

			If (File(cLocal + cNumTit + ".pdf"))
				FErase(cLocal + cNumTit + ".pdf")
			EndIf

			oPrint := FWMsPrinter():New(cNumTit + ".rel", IMP_PDF, .T., cLocal, .T.,,,,,,,.F.,)
			oPrint:SetPortrait()
			oPrint:SetParm( "-RFS")
			oPrint:SetPaperSize(9)
			oPrint:cPathPDF := cLocal //Acrescentado destino na vari�vel
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,dvNN)
			Sleep(3000) //Acrescentado um Sleep para que possa gerar todos os boletos cadenciados.
			nX := nX++
		EndIf
			dbSelectArea("SE1")
			(SE1)->(DbSkip())
			IncProc()
		nI++
	EndDo
	RestArea(cAlias)
Return Nil

/*/{Protheus.doc} Impress
	Impressao dos dados do boleto em modo grafico
	@type function
	@version 12.1.25
	@author Microsiga
	@since 21/11/05
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,dvNN)
	Local oFont6
	Local oFont7
	Local oFont8
	Local oFont9
	Local oFont11c
	Local oFont10
	Local oFont14
	Local oFont16n
	Local oFont15
	Local oFont14n
	Local oFont24
	Local nI := 0
	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont6   := TFont():New("Arial",9,6,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont7   := TFont():New("Arial",9,7,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont9   := TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont9   := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oFont15n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.,.F.)
	oPrint:StartPage()   // Inicia uma nova p�gina
	/******************/
	/* PRIMEIRA PARTE */
	/******************/
	nRow1 := 20
	oPrint:Line (0150,500,0070,500)
	oPrint:Line (0150,710,0070,710)
	oPrint:Say  (nRow1+0110,100,aDadosBanco[2],oFont10 )       // [2]Nome do Banco
	oPrint:Say  (nRow1+0110,513,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco
	oPrint:Say  (nRow1+0110,1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (0150,100,0150,2300)
	oPrint:Say  (nRow1+0150,100,"Benefici�rio",oFont8)
	oPrint:Say  (nRow1+0200,100,aDadosEmp[1],oFont10)				//Nome + CNPJ
	oPrint:Say  (nRow1+0150,1060,"Ag�ncia/C�digo Benefici�rio",oFont8)
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	oPrint:Say  (nRow1+0150,1510,"Nro.Documento-Parcela",oFont8)
	//oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow1+0200,1510,aDadosTit[1]						,oFont10) //Numero do Titulo
	oPrint:Say  (nRow1+0250,100,"Pagador",oFont8)
	oPrint:Say  (nRow1+0300,100,aDatSacado[1],oFont10)				//Nome
	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
	oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1510,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/t�tulo",	oFont10)
	oPrint:Say  (nRow1+0450,0100,"com as caracter�sticas acima.",	oFont10)

	oPrint:Say  (nRow1+0350,1060,"Data",							oFont8)
	oPrint:Say  (nRow1+0350,1410,"Assinatura",						oFont8)
	oPrint:Say  (nRow1+0450,1060,"Data",							oFont8)
	oPrint:Say  (nRow1+0450,1410,"Entregador",						oFont8)

	oPrint:Line (0250,100,0250,1900 )
	oPrint:Line (0350,100,0350,1900 )
	oPrint:Line (0450,1050,0450,1900 )
	oPrint:Line (0550,100,0550,2300 )
	oPrint:Line (0550,1050,0150,1050 )
	oPrint:Line (0550,1400,0350,1400 )
	oPrint:Line (0350,1500,0150,1500 )
	oPrint:Line (0550,1900,0150,1900 )
	oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
	oPrint:Say  (nRow1+0245,1910,"(  )N�o existe n� indicado"                  	,oFont8)
	oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (nRow1+0325,1910,"(  )N�o procurado"                            ,oFont8)
	oPrint:Say  (nRow1+0365,1910,"(  )Endere�o insuficiente"                  	,oFont8)
	oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
	oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  ,oFont8)
	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	nRow2 := 20
	//Pontilhado separador
	/*
	For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI
	*/
	oPrint:Line (0710,100,0710,2300)
	oPrint:Line (0710,500,0630,500)
	oPrint:Line (0710,710,0630,710)
	oPrint:Say  (nRow2+0670,100,aDadosBanco[2],oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0670,513,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco
	oPrint:Say  (nRow2+0670,1800,"Recibo do Pagador",oFont10)
	oPrint:Line (0810,100,0810,2300 )
	oPrint:Line (0910,100,0910,2300 )
	oPrint:Line (0980,100,0980,2300 )
	oPrint:Line (1050,100,1050,2300 )
	oPrint:Line (0910,500,1050,500)
	oPrint:Line (0980,750,1050,750)
	oPrint:Line (0910,1000,1050,1000)
	oPrint:Line (0910,1300,0980,1300)
	oPrint:Line (0910,1480,1050,1480)
	oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
	//oPrint:Say (nRow2+0725,400 ,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont10)
	oPrint:Say  (nRow2+0765,100 ,"AP�S O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)
	oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)
	oPrint:Say  (nRow2+0810,100 ,"Benefici�rio"                                        ,oFont8)
	oPrint:Say  (nRow2+0850,100 ,allTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	oPrint:Say  (nRow2+0810,1810,"Ag�ncia/C�digo Benefici�rio",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)
	oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (nRow2+0940,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4),oFont10)
	//oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Numero do Titulo
	oPrint:Say  (nRow2+0910,1005,"Esp�cie Doc."                                   ,oFont8)
	oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
	oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)
	oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
	oPrint:Say  (nRow2+0910,1810,"Nosso N�mero"                                   ,oFont8)
	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Right(AllTrim((cAlias)->E1_NUMBCO),8)+"-"+dvNN)   //Substr(aDadosTit[6],4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)
	oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)
	oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10)
	oPrint:Say  (nRow2+0980,755 ,"Esp�cie"                                        ,oFont8)
	oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)
	oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)
	oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)
	oPrint:Say  (nRow2+1050,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio)",oFont8)
	oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*0.09)/30),"@E 99,999.99"))+" AO DIA"       ,oFont10)
	//oPrint:Say  (nRow2+1150,100 ,aBolText[1],oFont10)+" "+AllTrim(Transform(((aDadosTit[5]*(10/30))/100),"@E 99,999.99"))+" AO DIA"  ,oFont10)
	oPrint:Say  (nRow2+1200,100 ,aBolText[2]   ,oFont10)
	//oPrint:Say  (nRow2+1250,100 ,aBolText[3]                                        ,oFont10)
	oPrint:Say  (nRow2+1250,100,"INSTRU��ES DE RESPONSABILIDADE DO BENEFICI�RIO. QUALQUER"                        ,oFont10)
	oPrint:Say  (nRow2+1300,100,"D�VIDA SOBRE ESTE BOLETO, CONTATE O BENEFICI�RIO."                               ,oFont10)
	oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Dedu��es"                             ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acr�scimos"                           ,oFont8)
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)
	//Temp
	//oPrint:Say  (nRow2+1350,100,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"                               ,oFont10)
	oPrint:Say  (nRow2+1400,100 ,"Pagador"                                         ,oFont8)
	oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	oPrint:Say  (nRow2+1483,400 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	if aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1430,1750 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1430,1750 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
	oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
	oPrint:Say  (nRow2+1645,1500,"Autentica��o Mec�nica",oFont8)
	oPrint:Line (0710,1800,1400,1800 )
	oPrint:Line (1120,1800,1120,2300 )
	oPrint:Line (1190,1800,1190,2300 )
	oPrint:Line (1260,1800,1260,2300 )
	oPrint:Line (1330,1800,1330,2300 )
	oPrint:Line (1400,100,1400,2300  )
	oPrint:Line (1640,100,1640,2300  )
	/******************/
	/* TERCEIRA PARTE */
	/******************/
	nRow3 := 20
	nRecuo := 100
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880-nRecuo, nI, nRow3+1880-nRecuo, nI+30)
	Next nI
	oPrint:Line (2000-nRecuo,100,2000-nRecuo,2300)
	oPrint:Line (2000-nRecuo,500,1920-nRecuo, 500)
	oPrint:Line (2000-nRecuo,710,1920-nRecuo, 710)
	oPrint:Say  (nRow3+1960-nRecuo,100,aDadosBanco[2],oFont10)			// 	[2]Nome do Banco
	oPrint:Say  (nRow3+1960-nRecuo,513,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco
	oPrint:Say  (nRow3+1960-nRecuo,755,aCB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras
	oPrint:Line (2100-nRecuo,100,2100-nRecuo,2300 )
	oPrint:Line (2200-nRecuo,100,2200-nRecuo,2300 )
	oPrint:Line (2270-nRecuo,100,2270-nRecuo,2300 )
	oPrint:Line (2340-nRecuo,100,2340-nRecuo,2300 )
	oPrint:Line (2200-nRecuo,500 ,2340-nRecuo,500 )
	oPrint:Line (2270-nRecuo,750 ,2340-nRecuo,750 )
	oPrint:Line (2200-nRecuo,1000,2340-nRecuo,1000)
	oPrint:Line (2200-nRecuo,1300,2270-nRecuo,1300)
	oPrint:Line (2200-nRecuo,1480,2340-nRecuo,1480)
	oPrint:Say  (nRow3+2000-nRecuo,100 ,"Local de Pagamento",oFont8)
	//oPrint:Say  (nRow3+2015,400 ,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont10)
	oPrint:Say  (nRow3+2055-nRecuo,100 ,"AP�S O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)
	oPrint:Say  (nRow3+2000-nRecuo,1810,"Vencimento",oFont8)
	cString 	 := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040-nRecuo,nCol,cString,oFont11c)
	oPrint:Say  (nRow3+2100-nRecuo,100 ,"Benefici�rio",oFont8)
	oPrint:Say  (nRow3+2140-nRecuo,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	oPrint:Say  (nRow3+2100-nRecuo,1810,"Ag�ncia/C�digo Benefici�rio",oFont8)
	cString 	 := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	nCol 	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140-nRecuo,nCol,cString ,oFont11c)
	oPrint:Say  (nRow3+2200-nRecuo,100 ,"Data do Documento"                             ,oFont8)
	oPrint:Say  (nRow3+2230-nRecuo,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4), oFont10)
	oPrint:Say  (nRow3+2200-nRecuo,505 ,"Nro.Documento"                                 ,oFont8)
	//oPrint:Say (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow3+2230-nRecuo,605 ,aDadosTit[1]						,oFont10) //Numero do Titulo
	oPrint:Say  (nRow3+2200-nRecuo,1005,"Esp�cie Doc."                                  ,oFont8)
	oPrint:Say  (nRow3+2230-nRecuo,1050,aDadosTit[8]									,oFont10) //Tipo do Titulo
	oPrint:Say  (nRow3+2200-nRecuo,1305,"Aceite"                                        ,oFont8)
	oPrint:Say  (nRow3+2230-nRecuo,1400,"N"                                             ,oFont10)
	oPrint:Say  (nRow3+2200-nRecuo,1485,"Data do Processamento"                        ,oFont8)
	oPrint:Say  (nRow3+2230-nRecuo,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao
	oPrint:Say  (nRow3+2200-nRecuo,1810,"Nosso N�mero"                                 ,oFont8)
	cString 	 := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Right(AllTrim((cAlias)->E1_NUMBCO),8)+"-"+dvNN)   //Substr(aDadosTit[6],4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230-nRecuo,nCol,cString,oFont11c)
	oPrint:Say  (nRow3+2270-nRecuo,100 ,"Uso do Banco"                                 ,oFont8)
	oPrint:Say  (nRow3+2270-nRecuo,505 ,"Carteira"                                     ,oFont8)
	oPrint:Say  (nRow3+2300-nRecuo,555 ,aDadosBanco[6]                                 ,oFont10)
	oPrint:Say  (nRow3+2270-nRecuo,755 ,"Esp�cie"                                      ,oFont8)
	oPrint:Say  (nRow3+2300-nRecuo,805 ,"R$"                                           ,oFont10)
	oPrint:Say  (nRow3+2270-nRecuo,1005,"Quantidade"                                   ,oFont8)
	oPrint:Say  (nRow3+2270-nRecuo,1485,"Valor"                                        ,oFont8)
	oPrint:Say  (nRow3+2270-nRecuo,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300-nRecuo,nCol,cString,oFont11c)
	oPrint:Say  (nRow3+2340-nRecuo,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio)",oFont8)
	oPrint:Say  (nRow3+2440-nRecuo,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*0.09)/30),"@E 99,999.99"))+" AO DIA"      ,oFont10)
	//oPrint:Say  (nRow3+2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  ,oFont10)
	//oPrint:Say  (nRow3+2540,100 ,aBolText[3]                                    ,oFont10)
	//oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(10/30))/100),"@E 99,999.99"))+" AO DIA"  ,oFont10)
	oPrint:Say  (nRow3+2490-nRecuo,100 ,aBolText[2]   ,oFont10)
	oPrint:Say  (nRow3+2540-nRecuo,100,"INSTRU��ES DE RESPONSABILIDADE DO BENEFICI�RIO. QUALQUER"                        ,oFont10)
	oPrint:Say  (nRow3+2590-nRecuo,100,"D�VIDA SOBRE ESTE BOLETO, CONTATE O BENEFICI�RIO."                               ,oFont10)
	oPrint:Say  (nRow3+2340-nRecuo,1810,"(-)Desconto/Abatimento"                       ,oFont8)
	oPrint:Say  (nRow3+2410-nRecuo,1810,"(-)Outras Dedu��es"                           ,oFont8)
	oPrint:Say  (nRow3+2480-nRecuo,1810,"(+)Mora/Multa"                                ,oFont8)
	oPrint:Say  (nRow3+2550-nRecuo,1810,"(+)Outros Acr�scimos"                         ,oFont8)
	oPrint:Say  (nRow3+2620-nRecuo,1810,"(=)Valor Cobrado"                             ,oFont8)
	// TEMP
	//oPrint:Say  (nRow2+2640,100,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"                               ,oFont10)
	oPrint:Say  (nRow3+2690-nRecuo,100 ,"Pagador"                                       ,oFont8)
	oPrint:Say  (nRow3+2700-nRecuo,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"           ,oFont10)
	if aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2700-nRecuo,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow3+2700-nRecuo,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	oPrint:Say  (nRow3+2753-nRecuo,400 ,aDatSacado[3]                                    	,oFont10)
	oPrint:Say  (nRow3+2806-nRecuo,400 ,aDatSacado[6]+"    "+aDatSacado[4]+ aDatSacado[5]	,oFont10) // CEP+Cidade+Estado
	oPrint:Say  (nRow3+2806-nRecuo,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  	,oFont10)
	oPrint:Say  (nRow3+2815-nRecuo,100 ,"Sacador/Avalista"                    		        ,oFont8)
	oPrint:Say  (nRow3+2855-nRecuo,1500,"Autentica��o Mec�nica - Ficha de Compensa��o" 	,oFont8)
	oPrint:Line (2000-nRecuo,1800,2690-nRecuo,1800 )
	oPrint:Line (2410-nRecuo,1800,2410-nRecuo,2300 )
	oPrint:Line (2480-nRecuo,1800,2480-nRecuo,2300 )
	oPrint:Line (2550-nRecuo,1800,2550-nRecuo,2300 )
	oPrint:Line (2620-nRecuo,1800,2620-nRecuo,2300 )
	oPrint:Line (2690-nRecuo,100,2690-nRecuo,2300  )
	oPrint:Line (2850-nRecuo,100,2850-nRecuo,2300  )
	//Utilizando MSBAR()
	//MSBAR("INT25",25.5,1,StrTran(StrTran(aCB_RN_NN[2],oPrint,.F.,Nil,Nil,0.1,4,Nil,Nil,"A",.F.)
	//C�digo de barras utilizando FWMsBar()
	oPrint:FwMsBar("INT25",65.5,2,StrTran(StrTran(aCB_RN_NN[2], ".", ""), " ", ""),oPrint,.F.,Nil,Nil,0.0225,1,Nil,Nil,"A",.F.)
	//DbSelectArea("SE1")
		//RecLock("SE1",.f.)
		//(cAlias)->E1_NUMBCO 	:=	aCB_RN_NN[3]   // Nosso n�mero (Ver f�rmula para calculo)
	//MsUnlock()
	oPrint:EndPage() // Finaliza a p�gina
	oPrint:Print()
Return Nil

/*/{Protheus.doc} fLinhaDig
	Obtencao da linha digitavel/codigo de barras
	@type function
	@version 12.1.25
	@author Microsiga
	@since 21/11/05
/*/
Static Function fLinhaDig (cCodBanco, 	; // Codigo do Banco (341)
	cCodMoeda, 							; // Codigo da Moeda (9)
	cCarteira, 							; // Codigo da Carteira
	cAgencia , 							; // Codigo da Agencia
	cConta   , 							; // Codigo da Conta
	cDvConta , 							; // Digito verificador da Conta
	nValor   , 							; // Valor do Titulo
	dVencto  , 							; // Data de vencimento do titulo
	cNroDoc	 )			  				  // Numero do Documento Ref ao Contas a Receber

	Local cValorFinal   := StrZero(int(nValor*100),10)
	Local cFator        := StrZero(dVencto - CtoD("07/10/97"),4)
	Local cCodBar   	:= Replicate("0",43)
	Local cCampo1   	:= Replicate("0",05)+"."+Replicate("0",05)
	Local cCampo2   	:= Replicate("0",05)+"."+Replicate("0",06)
	Local cCampo3   	:= Replicate("0",05)+"."+Replicate("0",06)
	Local cCampo4   	:= Replicate("0",01)
	Local cCampo5   	:= Replicate("0",14)
	Local cTemp     	:= ""
	Local cNossoNum 	:= Right(AllTrim((cAlias)->E1_NUMBCO),8) // Nosso numero
	Local cDV			:= "" // Digito verificador dos campos
	Local cLinDig		:= ""
	/*
	-------------------------
	Definicao do NOSSO NUMERO
	-------------------------
	*/
	If At("-",cConta) > 0
		cDig   := Right(AllTrim(cConta),1)
		cConta := AllTrim(Str(Val(Left(cConta,At('-',cConta)-1) + cDig)))
	Else
		cConta := Val(cConta)
	Endif
	cConta = StrZero(cConta,5)
	cNossoNum   := Alltrim(cAgencia) + Left(Alltrim(cConta),5) + cCarteira + Right(AllTrim((cAlias)->E1_NUMBCO),8) //cNroDoc
	//cNossoNum   := Alltrim(cAgencia) + Left(Alltrim(cConta),5) + Right(alltrim(cConta),1) + cCarteira + Right(AllTrim((cAlias)->E1_NUMBCO),8) //cNroDoc
	cDvNN 		:= Alltrim(Str(Modulo10(cNossoNum)))
	cNossoNum   := cCarteira + cNroDoc + cDvNN
	//cNossoNum   := cCarteira + cNroDoc + '-' + cDvNN
	/*
	-----------------------------
	Definicao do CODIGO DE BARRAS
	-----------------------------
	*/
	//Alltrim(cNroDoc)            			+ ; // 23 a 30
	cTemp := Alltrim(cCodBanco)   			+ ; // 01 a 03
	Alltrim(cCodMoeda)            			+ ; // 04 a 04
	Alltrim(cFator)               			+ ; // 06 a 09
	Alltrim(cValorFinal)          			+ ; // 10 a 19
	Alltrim(cCarteira)            			+ ; // 20 a 22
	Right(AllTrim((cAlias)->E1_NUMBCO),8) 		+ ; // 23 A 30
	Alltrim(cDvNN)                			+ ; // 31 a 31
	Alltrim(cAgencia)             			+ ; // 32 a 35
	Alltrim(Left(cConta,5))               	+ ; // 36 a 40
	Alltrim(cDvConta)             			+ ; // 41 a 41
	"000"                             			// 42 a 44
	cDvCB  := Alltrim(Str(modulo11(cTemp)))	// Digito Verificador CodBarras
	cCodBar:= SubStr(cTemp,1,4) + cDvCB + SubStr(cTemp,5)// + cDvNN + SubStr(cTemp,31)
	/*
	-----------------------------------------------------
	Definicao da LINHA DIGITAVEL (Representacao Numerica)
	-----------------------------------------------------
	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
	CAMPO 1:
	AAA = Codigo do banco na Camara de Compensacao
	B = Codigo da moeda, sempre 9
	CCC = Codigo da Carteira de Cobranca
	DD = Dois primeiros digitos no nosso numero
	X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	*/
	cTemp   := cCodBanco + cCodMoeda + cCarteira + Substr(Right(AllTrim((cAlias)->E1_NUMBCO),8),1,2)
	cDV		:= Alltrim(Str(Modulo10(cTemp)))
	cCampo1 := SubStr(cTemp,1,5) + '.' + Alltrim(SubStr(cTemp,6)) + cDV + Space(2)
	/*
	CAMPO 2:
	DDDDDD = Restante do Nosso Numero
	E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	FFF = Tres primeiros numeros que identificam a agencia
	Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	*/
	cTemp	:= Substr(Right(AllTrim((cAlias)->E1_NUMBCO),8),3) + cDvNN + Substr(cAgencia,1,3)
	cDV		:= Alltrim(Str(Modulo10(cTemp)))
	cCampo2 := Substr(cTemp,1,5) + '.' + Substr(cTemp,6) + cDV + Space(3)
	/*
	CAMPO 3:
	F = Restante do numero que identifica a agencia
	GGGGGG = Numero da Conta + DAC da mesma
	HHH = Zeros (Nao utilizado)
	Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	*/
	cTemp   := Substr(cAgencia,4,1) + Strzero(Val(cConta),5) + Alltrim(cDvConta) + "000"
	cDV		:= Alltrim(Str(Modulo10(cTemp)))
	cCampo3 := Substr(cTemp,1,5) + '.' + Substr(cTemp,6) + cDV + Space(2)
	/*
	CAMPO 4:
	K = DAC do Codigo de Barras
	*/
	cCampo4 := cDvCB + Space(2)
	/*
	CAMPO 5:
	UUUU = Fator de Vencimento
	VVVVVVVVVV = Valor do Titulo
	*/
	cCampo5 := cFator + StrZero(int(nValor * 100),14 - Len(cFator))
	cLinDig := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5
Return {cCodBar, cLinDig, cNossoNum}

/*/{Protheus.doc} Modulo10
	C�lculo do Modulo 10 para obten��o do DV dos campos do
	@type function
	@version  12.1.25
	@author Microsoga
	@since 21/11/05
/*/
Static Function Modulo10(cData)
	Local  L,D,P := 0
	Local B     := .F.
	L := Len(cData)
	B := .T.
	D := 0

	While L > 0
		P := Val(SubStr(cData, L, 1))

			If (B)
				P := P * 2
					If P > 9
						P := P - 9
				End
			End

		D := D + P
		L := L - 1
		B := !B
	End

	D := 10 - (Mod(D,10))
		If D = 10
			D := 0
		End

Return D
/*/{Protheus.doc} Modulo11
	Calculo do Modulo 11 para obtencao do DV do Codigo de Barras
	@type function
	@version  12.1.25
	@author Microsoga
	@since 21/11/05
/*/
Static Function Modulo11(cData)
	Local L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	// Some o resultado de cada produto efetuado e determine o total como (D);
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
		L := L - 1
	End
	// DAC = 11 - Mod 11(D)
	D := 11 - (mod(D,11))
	// OBS: Se o resultado desta for igual a 0, 1, 10 ou 11, considere DAC = 1.
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return D

/*/{Protheus.doc} FCriaSX1
	Fun��o para cria��o de registros na SX1
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 06/07/2021
/*/
Static Function FCriaSX1()
	Local oSX1 := CreateSX1():New("BLTITAU") // Cria inst�ncia do objeto

	// Adiciona novos itens da SX1
	oSX1:NewItem({01, "De Prefixo",     "MV_CH1", "C", 03, 00, "G", NIL})
	oSX1:NewItem({02, "Ate Prefixo",    "MV_CH2", "C", 03, 00, "G", NIL})
	oSX1:NewItem({03, "De Numero",      "MV_CH3", "C", 09, 00, "G", "SE1"})
	oSX1:NewItem({04, "Ate Numero",     "MV_CH4", "C", 09, 00, "G", "SE1"})
	oSX1:NewItem({05, "De Parcela",     "MV_CH5", "C", 01, 00, "G", NIL})
	oSX1:NewItem({06, "Ate Parcela",    "MV_CH6", "C", 01, 00, "G", NIL})
	oSX1:NewItem({07, "De Portador",    "MV_CH7", "C", 03, 00, "G", NIL})
	oSX1:NewItem({08, "Ate Portador",   "MV_CH8", "C", 03, 00, "G", NIL})
	oSX1:NewItem({09, "De Cliente",     "MV_CH9", "C", 06, 00, "G", "SA1"})
	oSX1:NewItem({10, "Ate Cliente",    "MV_CHA", "C", 06, 00, "G", "SA1"})
	oSX1:NewItem({11, "De Loja",        "MV_CHB", "C", 02, 00, "G", NIL})
	oSX1:NewItem({12, "Ate Loja",       "MV_CHC", "C", 02, 00, "G", NIL})
	oSX1:NewItem({13, "De Emissao",     "MV_CHD", "D", 08, 00, "G", NIL})
	oSX1:NewItem({14, "Ate Emissao",    "MV_CHE", "D", 08, 00, "G", NIL})
	oSX1:NewItem({15, "De Vencimento",  "MV_CHF", "D", 08, 00, "G", NIL})
	oSX1:NewItem({16, "Ate Vencimento", "MV_CHG", "D", 08, 00, "G", NIL})
	oSX1:NewItem({17, "Do Bordero",     "MV_CHH", "C", 06, 00, "G", NIL})
	oSX1:NewItem({18, "Ate Bordero",    "MV_CHI", "C", 06, 00, "G", NIL})
	oSX1:NewItem({19, "Banco",          "MV_CHJ", "C", 03, 00, "G", "SA6"})
	oSX1:NewItem({20, "Agencia",        "MV_CHL", "C", 05, 00, "G", NIL})
	oSX1:NewItem({21, "Conta",          "MV_CHM", "C", 10, 00, "G", NIL})

	// Grava as informa��es
	oSX1:Commit()
Return (NIL)

/*/{Protheus.doc} TableDef
	Monta a tabela tempor�ria que ser� usada no boleto
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 09/07/2021
	@return Character, Alias da tabela tempor�ria
/*/
Static Function TableDef()
	Local cAlias  := GetNextAlias()                          // Alias da tabela tempor�ria
	Local aFields := FieldDef(2)                             // Campos para a tabela tempor�ria
	Local oTable  := FwTemporaryTable():New(cAlias, aFields) // Monta a tabela tempor�ria
	Local cQuery  := QueryDef()                              // Defini��o da query

	// Adiciona um �ndice e cria a tabela
	oTable:AddIndex("01", StrTokArr2(SE1->(IndexKey()), "+"))
	oTable:Create()

	// Preenche a tabela tempor�ria
	SQLToTrb(cQuery, aFields, cAlias)
	DBSelectArea(cAlias)
	DBGoTop()

	// Limpa os objetos da mem�ria
	FreeObj(oTable)
	FwFreeArray(aFields)
Return (cAlias)

/*/{Protheus.doc} QueryDef
	Monta o comando SQL para montagem da tabela tempor�ria
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 09/07/2021
	@return Character, Comando de pesquisa SQL
/*/
Static Function QueryDef()
	Local cAux    := ""          // Auxiliar de montagem de MVABATIM
	Local cQuery  := "SELECT "   // Base da query
	Local aFields := FieldDef(3) // Retorna os campos da query

	// Adiciona os campos na query
	aEval(aFields, {|x| cQuery += x + ", "} )
	cQuery := SubStr(cQuery, 1, Len(cQuery) - 2) + " "

	// Restante do corpo da query
	cQuery += "FROM " + RetSQLName("SE1") + " WHERE "
	cQuery += "E1_FILIAL = '" + FwXFilial("SE1")  + "' AND "
	cQuery += "E1_SALDO > 0 "                     +   "AND "
	cQuery += "E1_PREFIXO >= '" + MV_PAR01        + "' AND "
	cQuery += "E1_PREFIXO <= '" + MV_PAR02        + "' AND "
	cQuery += "E1_PORTADO <> 'CX1' "              +   "AND "
	cQuery += "E1_NUM >= '" + MV_PAR03            + "' AND "
	cQuery += "E1_NUM <= '" + MV_PAR04            + "' AND "
	cQuery += "E1_PARCELA >= '" + MV_PAR05        + "' AND "
	cQuery += "E1_PARCELA <= '" + MV_PAR06        + "' AND "
	cQuery += "E1_CLIENTE >= '" + MV_PAR09        + "' AND "
	cQuery += "E1_CLIENTE <= '" + MV_PAR10        + "' AND "
	cQuery += "E1_LOJA >= '" + MV_PAR11           + "' AND "
	cQuery += "E1_LOJA <= '" + MV_PAR12           + "' AND "
	cQuery += "E1_EMISSAO >= '" + DToS(MV_PAR13)  + "' AND "
	cQuery += "E1_EMISSAO <= '" + DToS(MV_PAR14)  + "' AND "
	cQuery += "E1_VENCREA >= '" + DToS(MV_PAR15)  + "' AND "
	cQuery += "E1_VENCREA <= '" + DToS(MV_PAR16)  + "' AND "
	cQuery += "E1_NUMBOR >= '" + MV_PAR17         + "' AND "
	cQuery += "E1_NUMBOR <= '" + MV_PAR18         + "' AND "

	// Monta a cl�usula IN de MVABATIM
	AEval(StrTokArr2(MVABATIM, "|"), {|x| cAux += "'" + x + "', "})
	cAux := SubStr(cAux, 1, Len(cAux) - 2)
	cQuery += "E1_TIPO NOT IN (" + cAux + ") "

	// Se o banco for preenchido, adiciona o banco na query
	// Caso n�o, usa o portador "de at�"
	If (!Empty(MV_PAR19))
		cQuery += "AND "
		cQuery += "(E1_PORTADO = '" + MV_PAR19 + "' OR E1_PORTADO = '') "
	Else
		cQuery += "AND "
		cQuery += "E1_PORTADO >= '" + MV_PAR07 + "' AND "
		cQuery += "E1_PORTADO <= '" + MV_PAR08 + "' AND "
		cQuery += "E1_PORTADO <> ''"
	EndIf

	// Se a ag�ncia for preenchida, adiciona na query
	If (!Empty(MV_PAR20))
		cQuery += "AND "
		cQuery += "(E1_AGEDEP = '" + MV_PAR20 + "' OR E1_AGEDEP = '') "
	EndIf

	// Se a conta for preenchida, adiciona na query
	If (!Empty(MV_PAR21))
		cQuery += " AND  (E1_CONTA = '" + MV_PAR21 + "' OR E1_CONTA = '') "
	EndIf

	// Portador n�o pode ser vazio
	cQuery += "AND E1_PORTADO <> ''"
Return (cQuery)

/*/{Protheus.doc} FieldDef
	description
	@type function
	@version
	@author Guilherme Bigois
	@since 15/07/2021
	@param nType, numeric, param_description
	@return variant, return_description
/*/
Static Function FieldDef(nType)
	Local nX      := 0  // Contador do la�o de campos
	Local aAux    := {} // Auxiliar da montagem de estrutura de campos
	Local aFields := {} // Campos do cabe�alho ou tabela tempor�ria

	// Monta vetor com os campos utilizados
	AEval(StrTokArr2(SE1->(IndexKey()), "+"), {|x| AAdd(aAux, x)})
	AAdd(aAux, "E1_CLIENTE")
	AAdd(aAux, "E1_VALOR")
	AAdd(aAux, "E1_VENCREA")
	AAdd(aAux, "E1_NUMBOR")

	// Define o retorno da fun��o
	If (nType == 1) // Se o tipo for 1 (grid), retorna a estrutura de cabe�alho
		AAdd(aFields, {"E1_OK", NIL, " ", "@!"})
		For nX := 1 To Len(aAux)
			AAdd(aFields, {aAux[nX], NIL, GetSX3Cache(aAux[nX], "X3_TITULO"), GetSX3Cache(aAux[nX], "X3_PICTURE")})
		Next nX
	ElseIf (nType == 2) // Se o tipo for 2 (table), retorna a estrutura da SX3
		AAdd(aFields, {"E1_OK", "C", 2, 0})
		For nX := 1 To Len(aAux)
			AAdd(aFields, {aAux[nX], GetSX3Cache(aAux[nX], "X3_TIPO"), GetSX3Cache(aAux[nX], "X3_TAMANHO"), GetSX3Cache(aAux[nX], "X3_DECIMAL")})
		Next nX
	ElseIf (nType == 3) // Se o tipo for 3 (query), retorna os campos para query
		aFields := aAux
	EndIf
Return (aFields)

/*/{Protheus.doc} DoMark
	Marca o registro atualmente posicionado
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 15/07/2021
/*/
Static Function DoMark(cAlias, cMark)
	// Trava o registro para altera��o
	RecLock(cAlias, .F.)
		// Inverte a marca��o da linha
		If (Marked("E1_OK"))
			E1_OK := cMark
		Else
			E1_OK := ""
		Endif
	MsUnlock()

	// Atualiza a grid
	oMark:oBrowse:Refresh()
Return (NIL)

/*/{Protheus.doc} CreateSX1
	Classe para cria��o de registros na SX1
	@type Class
	@version 12.1.25
	@author Jonas Machado
	@since 13/06/2021
/*/
Class CreateSX1
	Public Data aSX1   As Array     // Vetor de registros da SX1
	Public Data cGroup As Character // Grupo de Pergunte()

	// M�todos da classe
	Public Method New(cGroup) CONSTRUCTOR
	Public Method NewItem()
	Public Method Commit()
EndClass

/*/{Protheus.doc} CreateSX1::New
	M�todo construtor da classe
	@type Method
	@version 12.1.25
	@author Jonas Machado
	@since 13/06/2021
	@param cGroup, Character, Grupo de perguntas a ser criado
	@return Object, Objeto da classe CreateSX1
/*/
Method New(cGroup) Class CreateSX1
	::aSX1   := {}                               // Vetor com registros da SX1
	::cGroup := Padr(cGroup, Len(SX1->X1_GRUPO)) // Grupo de perguntas a ser criado
Return (Self)

/*/{Protheus.doc} CreateSX1::NewItem
	Adiciona uma nova linha no vetor da SX1
	@type Method
	@version 12.1.25
	@author Jonas Machado
	@since 13/06/2021
	@param aList, Array, Campos a serem adicionados na SX1
	@return Numeric, Tamanho do vetor da SX1
/*/
Method NewItem(aList) Class CreateSX1
	Local nX      := 0                 // Contador do la�o
	Local aPos    := {}                // Vetor de posi��es da estrutura da SX1
	Local aItem   := {}                // Vetor auxiliar para cria��o da nova linha
	Local aStruct := SX1->(DBStruct()) // Estrutura da SX1

	// Percorre a estrutura da SX1 e monta a base do registro
	For nX := 1 To Len(aStruct)
		AAdd(aItem, IIf(aStruct[nX][2] == "N", 0, ""))
	Next nX

	// Campos utilizados na SX1
	AAdd(aPos, {"X1_GRUPO",   AScan(aStruct, {|x| x[1] == "X1_GRUPO"})})
	AAdd(aPos, {"X1_ORDEM",   AScan(aStruct, {|x| x[1] == "X1_ORDEM"})})
	AAdd(aPos, {"X1_PERGUNT", AScan(aStruct, {|x| x[1] == "X1_PERGUNT"})})
	AAdd(aPos, {"X1_VARIAVL", AScan(aStruct, {|x| x[1] == "X1_VARIAVL"})})
	AAdd(aPos, {"X1_TIPO",    AScan(aStruct, {|x| x[1] == "X1_TIPO"})})
	AAdd(aPos, {"X1_TAMANHO", AScan(aStruct, {|x| x[1] == "X1_TAMANHO"})})
	AAdd(aPos, {"X1_DECIMAL", AScan(aStruct, {|x| x[1] == "X1_DECIMAL"})})
	AAdd(aPos, {"X1_GSC",     AScan(aStruct, {|x| x[1] == "X1_GSC"})})
	AAdd(aPos, {"X1_VAR01",   AScan(aStruct, {|x| x[1] == "X1_VAR01"})})
	AAdd(aPos, {"X1_F3",      AScan(aStruct, {|x| x[1] == "X1_F3"})})

	// Preencher com os dados enviados pelo usu�rio
	aItem[aPos[1][2]]  := ::cGroup                           // X1_GRUPO
	aItem[aPos[2][2]]  := StrZero(aList[1], 2)               // X1_ORDEM
	aItem[aPos[3][2]]  := aList[2]                           // X1_PERGUNT
	aItem[aPos[4][2]]  := aList[3]                           // X1_VARIAVL
	aItem[aPos[5][2]]  := aList[4]                           // X1_TIPO
	aItem[aPos[6][2]]  := aList[5]                           // X1_TAMANHO
	aItem[aPos[7][2]]  := aList[6]                           // X1_DECIMAL
	aItem[aPos[8][2]]  := aList[7]                           // X1_GSC
	aItem[aPos[9][2]]  := "MV_PAR" + StrZero(aList[1], 2)    // X1_VAR01
	aItem[aPos[10][2]] := IIf(aList[8] == NIL, "", aList[8]) // X1_F3

	// Adiciona a linha criada no total de registro e limpa a mem�ria
	AAdd(::aSX1, AClone(aItem))
	FwFreeArray(aItem)
	FwFreeArray(aStruct)
Return (NIL)

/*/{Protheus.doc} CreateSX1::Commit
	Persiste os campos da SX1 no banco
	@type Method
	@version 12.1.25
	@author Jonas Machado
	@since 13/06/2021
/*/
Method Commit() Class CreateSX1
	Local nX     := 0         // Contador do la�o de registros da SX1
	Local nY     := 0         // Contador do la�o de campos de cada registro da SX1
	Local aArea  := GetArea() // Tabela posicionada anteriormente
	Local lFound := .F.       // Verifica��o de exist�ncia de registro

	// Isola a transa��o para manter a atomicidade
	BEGIN TRANSACTION
		// Percorre as linhas adicionadas no objeto
		For nX := 1 To Len(::aSX1)
			// Posiciona na SX1 e verifica se o registo j� existe
			DBSelectArea("SX1")
			DBSeek(::cGroup + ::aSX1[nX][2])
			lFound := Found()

			// Se o grupo de perguntas j� existir, altera, se n�o, cria
			RecLock("SX1", !lFound)
				For nY := 1 To Len(::aSX1[1])
					FieldPut(nY, ::aSX1[nX][nY])
				Next nY
			MsUnlock()
		Next nX
	END TRANSACTION

	// Restaura a tabela posicionada anteriormente
	RestArea(aArea)
Return (NIL)

Static Function Marcar()
    dbSelectArea( cAlias )
    Do While !EoF()
        If 	RecLock( cAlias, .F. )
           	E1_OK := cMark
           	msUnLock()
        EndIf

        dbSelectArea( cAlias )
        dbSkip()
    EndDo
Return

Static Function Desmarcar()
    dbSelectArea( cAlias )
    Do While !EoF()
        If RecLock( cAlias, .F. )
            E1_OK := ' '
            msUnLock()
        EndIf
        dbSelectArea( cAlias )
        dbSkip()
    EndDo
Return