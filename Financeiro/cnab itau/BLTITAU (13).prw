#include "TOTVS.ch"
#include "RWMAKE.ch"          

#DEFINE __cCarteira "109"
#DEFINE __cMoeda    "9"
/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |BOLITAU   |Autor  |Greice Wicks        | Data |  08/11/12   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Impressao de boleto Itau                                    |
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | Transilva LOG                                              |
+-----------+------------------------------------------------------------+
*/
User Function BLTITAU(cNota)
Local oSX1 := NIL // Objeto de cria��o de Pergunte()

Private lExec    := .F.
Private cIndexName := ''
Private cIndexKey  := ''
Private cFilter    := ''

DEFAULT cNota := Space(09)

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg   := Padr("BLTITAU",10)
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

cNf	:= cNota

// Cria inst�ncia do objeto
oSX1 := CreateSX1():New("BLTITAU")

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

oSX1:Commit()

If !Pergunte (cPerg,.T.)
	Return
Endif

If Empty(cNF)
	/*	Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)
	
	If nLastKey == 27
	Set Filter to
	Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	Set Filter to
	Return
	Endif
	*/
	cIndexName	:= Criatrab(Nil,.F.)
//	cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"
	cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
	cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."  
	cfilter     += "E1_PORTADO<>'"+"CX1"+"'.And."
	cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
	cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
	cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
	cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
	cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.And.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
	cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par15)+"'.And.DTOS(E1_VENCREA)<='"+DTOS(mv_par16)+"'.And."
	cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
	cFilter		+= "!(E1_TIPO$MVABATIM)
   	
	
	If Empty(MV_PAR19)
		cFilter		+= ".And. E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "' "
		cFilter		+= ".And. E1_PORTADO<>'   '"
	Else
		cFilter		+= ".And. (E1_PORTADO =='" + MV_PAR19 + "' .Or. Empty(E1_PORTADO)) "
	Endif

	If !Empty(MV_PAR20)
		cFilter		+= ".And. (E1_AGEDEP=='" + MV_PAR20 + "' .Or. Empty(E1_AGEDEP)) "
	Endif

	If !Empty(MV_PAR21)
		cFilter		+= ".And. (E1_CONTA=='" + MV_PAR21 + "' .Or. Empty(E1_CONTA)) "
	Endif
Else
	cFilter		+= "E1_NUM = '" + cNF + "' "
Endif                                                                                    

cfilter     += " .And. E1_PORTADO <> 'CX1' "        
     


    

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()

If Empty(cNF)
	
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Sele��o de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
	
	dbGoTop()
Else
	lExec := .t.
Endif

If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())
Return

/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |BOLITAU   |Autor  |Microsiga           | Data |  11/21/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |                                                            |
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | AP                                                         |
+-----------+------------------------------------------------------------+
*/
Static Function MontaRel()
Local oPrint
Local nX		:= 0
Local cNroDoc 	:= " "
Local aDadosEmp    := {	SM0->M0_NOMECOM                                    ,;                        //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     ,;                        //[2]Endere�o
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ;     //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
						
Local aDadosTit   := {}
Local aDadosBanco := {}
Local aDatSacado  := {}
Local aBolText    := {"AP�S O VENCIMENTO COBRAR JUROS DE R$", "PROTESTAR AP�S 3 DIAS DE ATRASO. ","AO DIA"}

Local nI          := 1
Local aCB_RN_NN   := {}
Local nVlrAbat	  := 0

Private cStartPath       := GetSrvProfString("Startpath","")

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:Setup()   // Inicia uma nova p�gina

dbSelectArea("SE1")
//SE1->(DbGoTop())
ProcRegua(RecCount())
Do While SE1->(!EOF())

// WELL 16/08/2018    
    
   IF  SE1->E1_PORTADO == "CX1"         
       SE1->(DBSKIP())
       LOOP
   ELSE
       DBSELECTAREA("SC5")
       SC5->(DBSETORDER(1))
       IF SC5->(DBSEEK(XFILIAL("SC5") + SE1->E1_PEDIDO))
			IF SC5->C5_BANCO == "CX1"
				SE1->(DBSKIP())
				LOOP
			ENDIF
       ENDIF

       DBSELECTAREA("SF2")
       SF2->(DBSETORDER(1))
       IF SF2->(DBSEEK(XFILIAL("SF2") + SE1->(E1_NUM + E1_SERIE + E1_CLIENTE + E1_LOJA)))
	       CCONDPAG := SF2->F2_COND
	       DbSelectArea("SE4")
		   SE4->(DbSetOrder(1))
		   //DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21)
		   IF SE4->(DbSeek(xFilial("SE4") + CCONDPAG))
			  IF (SE4->E4_TIPO == "1") .OR. (SE4->E4_TIPO == "5")
			  		APAGAMENTOS := STRTOKARR(SE4->E4_COND, ",")
			  		IF (VAL(APAGAMENTOS[1]) == 0) .AND. (VAL(SE1->E1_PARCELA) <= 1)
			             SE1->(DBSKIP())
			             LOOP
			  		ENDIF
			  ELSEIF (SE4->E4_TIPO == "8")
			  		APAGAMENTOS := STRTOKARR(STRTRAN(STRTRAN(SE4->E4_COND, "["), "]"), ",")
			  		IF (VAL(APAGAMENTOS[1]) == 0) .AND. (VAL(SE1->E1_PARCELA) <= 1)
			             SE1->(DBSKIP())
			             LOOP
			  		ENDIF
			  ENDIF
	       ENDIF 
       ENDIF
   ENDIF
    
   

// WELL 02/10/2018
    
   
   
      
   
	If Marked("E1_OK")
		If Empty(MV_PAR19)
			//Posiciona o SA6 (Bancos)
			DbSelectArea("SA6")
			DbSetOrder(1)                                    
			//DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21)
			If DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Banco/Ag�ncia/Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif

			//Posiciona na Arq de Parametros CNAB
			DbSelectArea("SEE")
			DbSetOrder(1)
			//DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21)
			If DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Par�metros de Banco do Banco/Ag�ncia/Conta/Sub-Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif
		Else
			//Posiciona o SA6 (Bancos)
			DbSelectArea("SA6")
			DbSetOrder(1)
			If DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Banco/Ag�ncia/Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif			

			//Posiciona na Arq de Parametros CNAB
			DbSelectArea("SEE")
			DbSetOrder(1)
			If DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Par�metros de Banco do Banco/Ag�ncia/Conta/Sub-Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif
		Endif

		//inserido por raul em 28/08/12                   
		//posiciona no pedido
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+SE1->E1_PEDIDO,.T.)
		
		If !empty(SC5->C5_CLIENTE+SC5->C5_LOJACLI).and.(SC5->C5_FILIAL+SC5->C5_NUM==SE1->E1_FILIAL+SE1->E1_PEDIDO)        
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.T.)
		Else
			//Posiciona o SA1 (Cliente)
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		Endif                          
		
		// Luiz Alberto - 06-02-2012 - Athena
		// Efetua o Preenchimento do Campo E1_NUMBCO com
		// o Numero Sequencial da Tabela E1_FAIXATU.         
		//DbSelectArea("SE1")
		//If Empty(SE1->E1_NUMBCO)
		//	NossoNum()
		//Endif
		
		aAdd(aDadosBanco, Alltrim(SA6->A6_COD))     // [1]Numero do Banco
		aAdd(aDadosBanco, Alltrim(SA6->A6_NOME))    // [2]Nome do Banco
		aAdd(aDadosBanco, Alltrim(SA6->A6_AGENCIA)) // [3]Ag�ncia
		aAdd(aDadosBanco, Alltrim(SA6->A6_NUMCON))  // [4]Conta Corrente
		aAdd(aDadosBanco, Alltrim(SA6->A6_DVCTA))  // [5]D�gito da conta corrente
		aAdd(aDadosBanco, Alltrim(__cCarteira))     // [6]Codigo da Carteira
		
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
		// WELL 04/05
		//nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
		/*
		--------------------------------------------------------------
		Parte do Nosso Numero. Sao 8 digitos para identificar o titulo
		--------------------------------------------------------------
		*/
		cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO 	:=	cNroDoc   // Nosso n�mero (Ver f�rmula para calculo) 
		SE1->E1_PORTADO :=	aDadosBanco[1]
		SE1->E1_AGEDEP  :=	aDadosBanco[3]
		SE1->E1_CONTA   :=	aDadosBanco[4]
		MsUnlock()
		
		/*
		----------------------
		Monta codigo de barras
		----------------------
		*/                  
		//mostra = str(nVlrAbat,12,2)
	    //MsgBox(mostra)
		
		aCB_RN_NN := fLinhaDig(aDadosBanco[1]      ,; // Numero do Banco
		__cMoeda            ,; // Codigo da Moeda
		aDadosBanco[6]      ,; // Codigo da Carteira
		aDadosBanco[3]      ,; // Codigo da Agencia
		aDadosBanco[4]      ,; // Codigo da Conta
		aDadosBanco[5]      ,; // DV da Conta
	    (E1_VALOR-nVlrAbat) ,; // Valor do Titulo		
		E1_VENCTO           ,; // Data de Vencimento do Titulo
		cNroDoc              ) // Numero do Documento no Contas a Receber
		       
		dvNN := Alltrim(Str(Modulo10(aDadosBanco[3]+aDadosBanco[4]+aDadosBanco[6]+cNroDoc)))		

		If Empty(E1_PARCELA)
	    	cNumTit := AllTrim(E1_NUM)
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
		
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,dvNN)
		nX := nX + 1
	EndIf

	dbSelectArea("SE1")
	SE1->(DbSkip())
	IncProc()
	nI++
EndDo
//oPrint:EndPage()     // Finaliza a p�gina
oPrint:Preview()     // Visualiza antes de imprimir

//cJPEG := Iif(Empty(AllTrim(SE1->E1_NUM)),CriaTrab(,.f.),AllTrim(SE1->E1_NUM))
//oPrint:SaveAllAsJPEG(cStartPath+cJPEG,1000,1400,140)
Return Nil


/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |Impress   |Autor  |Microsiga           | Data |  21/11/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Impressao dos dados do boleto em modo grafico               |
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | AP                                                         |
+-----------+------------------------------------------------------------+
*/
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
oFont6   := TFont():New("Arial",9,6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7   := TFont():New("Arial",9,7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p�gina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0

oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont10 )	        // [2]Nome do Banco
oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont20 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100 ,"Benefici�rio",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Ag�ncia/C�digo Benefici�rio",oFont8)
oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
//oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
oPrint:Say (nRow1+0200,1510,aDadosTit[1]						,oFont10) //Numero do Titulo

oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont9)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1080,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/t�tulo",oFont10)
oPrint:Say  (nRow1+0450,0100,"com as caracter�sticas acima.",oFont10)
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )N�o existe n� indicado"                  	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )N�o procurado"                              ,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Endere�o insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

//Pontilhado separador
/*
For nI := 100 to 2300 step 50
oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI
*/
oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont10 )		// [2]Nome do Banco
oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0644,1800,"Recibo do Pagador",oFont10)

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
//oPrint:Say  (nRow2+0725,400 ,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont10)
oPrint:Say  (nRow2+0765,100 ,"AP�S O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Benefici�rio"                                        ,oFont8)
oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0810,1810,"Ag�ncia/C�digo Benefici�rio",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4),oFont10)
//oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
//oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Numero do Titulo

oPrint:Say  (nRow2+0910,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso N�mero"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Right(AllTrim(SE1->E1_NUMBCO),8)+"-"+dvNN)   //Substr(aDadosTit[6],4)
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

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont10)		// 	[2]Nome do Banco
oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
//oPrint:Say  (nRow3+2015,400 ,"ATE O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAU",oFont10)
oPrint:Say  (nRow3+2055,100 ,"AP�S O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)

oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Benefici�rio",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"Ag�ncia/C�digo Benefici�rio",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]) 
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

oPrint:Say (nRow3+2200,100 ,"Data do Documento"                             ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4), oFont10)

oPrint:Say (nRow3+2200,505 ,"Nro.Documento"                                 ,oFont8)
//oPrint:Say (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Numero do Titulo

oPrint:Say (nRow3+2200,1005,"Esp�cie Doc."                                  ,oFont8)
oPrint:Say (nRow3+2230,1050,aDadosTit[8]									,oFont10) //Tipo do Titulo

oPrint:Say (nRow3+2200,1305,"Aceite"                                        ,oFont8)
oPrint:Say (nRow3+2230,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                        ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso N�mero"                                 ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Right(AllTrim(SE1->E1_NUMBCO),8)+"-"+dvNN)   //Substr(aDadosTit[6],4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)


oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                 ,oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira"                                     ,oFont8)
oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                 ,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Esp�cie"                                      ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                   ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                        ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio)",oFont8)
oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*0.09)/30),"@E 99,999.99"))+" AO DIA"      ,oFont10)
//oPrint:Say  (nRow3+2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  ,oFont10)
//oPrint:Say  (nRow3+2540,100 ,aBolText[3]                                    ,oFont10)
//oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(10/30))/100),"@E 99,999.99"))+" AO DIA"  ,oFont10)
oPrint:Say  (nRow3+2490,100 ,aBolText[2]   ,oFont10)
oPrint:Say  (nRow3+2540,100,"INSTRU��ES DE RESPONSABILIDADE DO BENEFICI�RIO. QUALQUER"                        ,oFont10)
oPrint:Say  (nRow3+2590,100,"D�VIDA SOBRE ESTE BOLETO, CONTATE O BENEFICI�RIO."                               ,oFont10)


oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                       ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Dedu��es"                           ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acr�scimos"                         ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                             ,oFont8)

// TEMP
//oPrint:Say  (nRow2+2640,100,"APOS VCTO ACESSE WWW.ITAU.COM.BR/BOLETOS PARA ATUALIZAR SEU BOLETO"                               ,oFont10)

oPrint:Say  (nRow3+2690,100 ,"Pagador"                                       ,oFont8)
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"           ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2753,400 ,aDatSacado[3]                                  ,oFont10)
oPrint:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista"                             ,oFont8)
oPrint:Say  (nRow3+2855,1500,"Autentica��o Mec�nica - Ficha de Compensa��o" ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )

//MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.) //modali
MSBAR("INT25",24.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.022,1.5,Nil,Nil,"A",.F.) //datasupri


//DbSelectArea("SE1")
//RecLock("SE1",.f.)
//SE1->E1_NUMBCO 	:=	aCB_RN_NN[3]   // Nosso n�mero (Ver f�rmula para calculo)
//MsUnlock()

oPrint:EndPage() // Finaliza a p�gina
Return Nil

/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |BOLITAU   |Autor  |Microsiga           | Data |  11/21/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Obten��o da linha digitavel/codigo de barras                |
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | AP                                                         |
+-----------+------------------------------------------------------------+
*/
Static Function fLinhaDig (cCodBanco, ; // Codigo do Banco (341)
cCodMoeda, ; // Codigo da Moeda (9)
cCarteira, ; // Codigo da Carteira
cAgencia , ; // Codigo da Agencia
cConta   , ; // Codigo da Conta
cDvConta , ; // Digito verificador da Conta
nValor   , ; // Valor do Titulo
dVencto  , ; // Data de vencimento do titulo
cNroDoc   )  // Numero do Documento Ref ao Contas a Receber

Local cValorFinal   := StrZero(int(nValor*100),10)
Local cFator        := StrZero(dVencto - CtoD("07/10/97"),4)
Local cCodBar   	:= Replicate("0",43)
Local cCampo1   	:= Replicate("0",05)+"."+Replicate("0",05)
Local cCampo2   	:= Replicate("0",05)+"."+Replicate("0",06)
Local cCampo3   	:= Replicate("0",05)+"."+Replicate("0",06)
Local cCampo4   	:= Replicate("0",01)
Local cCampo5   	:= Replicate("0",14)
Local cTemp     	:= ""
Local cNossoNum 	:= Right(AllTrim(SE1->E1_NUMBCO),8) // Nosso numero
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

cNossoNum   := Alltrim(cAgencia) + Left(Alltrim(cConta),5) + cCarteira + Right(AllTrim(SE1->E1_NUMBCO),8) //cNroDoc
//cNossoNum   := Alltrim(cAgencia) + Left(Alltrim(cConta),5) + Right(alltrim(cConta),1) + cCarteira + Right(AllTrim(SE1->E1_NUMBCO),8) //cNroDoc
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
Right(AllTrim(SE1->E1_NUMBCO),8) 		+; // 23 A 30
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
cTemp   := cCodBanco + cCodMoeda + cCarteira + Substr(Right(AllTrim(SE1->E1_NUMBCO),8),1,2)
cDV		:= Alltrim(Str(Modulo10(cTemp)))
cCampo1 := SubStr(cTemp,1,5) + '.' + Alltrim(SubStr(cTemp,6)) + cDV + Space(2)
/*
CAMPO 2:
DDDDDD = Restante do Nosso Numero
E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
FFF = Tres primeiros numeros que identificam a agencia
Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
*/
cTemp	:= Substr(Right(AllTrim(SE1->E1_NUMBCO),8),3) + cDvNN + Substr(cAgencia,1,3)
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

/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |MODULO10  |Autor  |Microsiga           | Data |  21/11/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |C�lculo do Modulo 10 para obten��o do DV dos campos do      |
|           |Codigo de Barras                                            |
+-----------+------------------------------------------------------------+
| Uso       | Financeiro Transilva LOG                                   |
+-----------+------------------------------------------------------------+
*/
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

/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |MODULO11  |Autor  |Microsiga           | Data |  21/11/05   |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Calculo do Modulo 11 para obtencao do DV do Codigo de Barras|
|           |                                                            |
+-----------+------------------------------------------------------------+
| Uso       | Financeiro Transilva LOG                                   |
+-----------+------------------------------------------------------------+
*/
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
