#INCLUDE "RWMAKE.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa      � BLTCD001 � Autor �SANDRO SANTOS               20\10\12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o     � IMPRESSAO DO BOLETO COM CODIGO DE BARRAS PARA OS BANCOS���
���                BB, BRADESCO, BNB E ITAU                               ���
�������������������������������������������������������������������������Ĵ��
���Uso           � Especifico para Clientes Microsiga                     ���
��������������������������������������������������������������������������ٱ�
���Implementa��o � Beatriz-TBA087 - Abril/2009 			          ��� 
���				 � Incluir Banco CEF                      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BLTCD001()

LOCAL	aPergs := {} 
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''      
PRIVATE oFont21N   := TFont():New("Arial",21,21,,.T.,,,,.T.,.F.)
PRIVATE cFilter    := ''    
cBitMap:= "C:\Microsiga\Protheus_Data\sigaadv\ITAU.bmp"

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBAR"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

/*
Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch7","C",6,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_ch8","C",6,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_ch9","C",2,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_cha","C",2,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chb","D",8,0,0,"G","","MV_PAR11","","","","01/01/12","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_chc","D",8,0,0,"G","","MV_PAR12","","","","31/12/12","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/12","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/12","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Desconto","","","mv_chf","N",11,2,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Impressora","","","mv_chg","N",1,0,0,"C","","MV_PAR15","Hp","Hp","Hp","","","Generico","Generico","Generico","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1("BLTBAR",aPergs)
*/

If	Pergunte (cPerg,.T.)=.F.
	Set Filter to
	Return
Endif

oPrint:= TMSPrinter():New( "Boleto Laser" )
If  oPrint:Setup() = .F. // para configurar impressora
	Set Filter to
	Return
Endif    

//Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

//If nLastKey == 27
//	Set Filter to
//	Return
//Endif

//SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		:= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR07 + "'.And.E1_CLIENTE<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR09 + "'.And.E1_LOJA<='"+MV_PAR10+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par11)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par12)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par13)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par14)+'".And.'
cFilter		+= "!(E1_TIPO$MVABATIM).And."
cFilter		+= "DTOS(E1_BAIXA)='        '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()
cMarca := GetMark()

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Sele��o de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK" Object _oMark
@ 180,001 BUTTON "Desmarca Todos" SIZE 45,15 ACTION Desmarca()
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
���������������������
��������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MontaRel� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS		      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaRel()
//LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     ,; //[2]Endere�o
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
/*
LOCAL _cMsg1 := GetMV("MV_MENBOL1")
LOCAL _cMsg2 := GetMV("MV_MENBOL2")
LOCAL _cMsg3 := GetMV("MV_MENBOL3")

LOCAL aBolText     := {_cMsg1                ,;
								_cMsg2                                   ,;
								_cMsg3}
*/
LOCAL aBolText     := {"Ap�s o vencimento cobrar multa de R$ "                ,;
					   " Protestar Ap�s 03 (tr�s) dias de atraso"}

//LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

//oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova p�gina


dbGoTop()
ProcRegua(RecCount())
Do While !EOF()
	If !Marked("E1_OK")
   	   dbSkip()
   	   Loop
	Endif
	//Posiciona o SA1 (Cliente) - Adriano
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
    _nJur := 0
    //_nJur := SA1->A1_PBJR - ADRIANO
	/* Adriano
    If Empty(SA1->A1_BCOBOL) .or. Empty(c_Agencia) .or. Empty(SA1->A1_CCBOL) .or. Empty(SA1->A1_SBBOL)
       MsgBox("Cliente " + SA1->A1_COD + "-" + SA1->A1_LOJA + " esta sem banco/agencia/conta/subconta! Favor cadastrar.")
       DbSelectArea("SE1")
   	   dbSkip()
   	   Loop
	Endif */
	
    c_Banco		:= "341"
    c_Agencia	:= "7225 "
    c_Conta		:= "16216     "
    c_SubCta	:= "001"   
  	
  	//Posiciona o SA6 (Bancos)
   	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+Alltrim(c_Banco)+Alltrim(c_Agencia)+Alltrim(c_Conta),.F.) //Adriano
	If !Found()
       MsgBox("Banco/agencia/conta do cliente " + SA1->A1_COD + "-" + SA1->A1_LOJA + " invalido SA6!")
       DbSelectArea("SE1")
   	   dbSkip()
   	   Loop
	Endif
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+Alltrim(c_Banco)+Alltrim(c_Agencia)+Alltrim(c_Conta)+Alltrim(c_SubCta),.F.) //Adriano
	If !Found()
       MsgBox("Banco/agencia/conta do cliente " + SA1->A1_COD + "-" + SA1->A1_LOJA + " invalido SEE!")
       DbSelectArea("SE1")
   	   dbSkip()
   	   Loop
	Endif
	
    xNumCon := LimpaCC(SA6->A6_NUMCON)
    DbSelectArea("SE1")
/*
    aDadosBanco  := {SA6->A6_COD                                            						,;  // [1]Numero do Banco
   	 		         IF(c_Banco="104",SA6->A6_NOME,SA6->A6_NREDUZ)   						,;  // [2]Nome do Banco
                     SUBSTR(SA6->A6_AGENCIA, 1, 4)                           						,; 	// [3]Ag�ncia
                     SUBSTR(xNumCon,1,Len(AllTrim(xNumCon))-2)               						,; 	// [4]Conta Corrente
                     SUBSTR(xNumCon,Len(AllTrim(xNumCon)),1)                 						,; 	// [5]D�gito da conta corrente
                     If(SA6->A6_COD$"104/341",ALLTRIM(SEE->EE_CODCOBE)+"9",ALLTRIM(SEE->EE_CODCOBE)),;	// [6]Codigo da Carteira
                     SUBSTR(SEE->EE_AGENCIA,5,1)	}		                    						// [7]Digito da agencia
*/
    aDadosBanco  := {"341"                                            									,;  // [1]Numero do Banco
    	 		     IF(Alltrim(SEE->EE_CODIGO)="104",SA6->A6_NOME,SA6->A6_NREDUZ)					   			,;  // [2]Nome do Banco
                     SUBSTR(SEE->EE_AGENCIA, 1, 4)                           			   						,; 	// [3]Ag�ncia
                     SUBSTR(xNumCon,1,Len(AllTrim(xNumCon))-1)              	 		   						,; 	// [4]Conta Corrente
                     SUBSTR(xNumCon,Len(AllTrim(xNumCon)),1)                 				 					,; 	// [5]D�gito da conta corrente
                     IF(Alltrim(SEE->EE_CODIGO)="341",ALLTRIM(SEE->EE_CODCOBE)+"109",ALLTRIM(SEE->EE_CODCOBE)) 	,;	// [6]Codigo da Carteira
                     SUBSTR(SEE->EE_AGENCIA,5,1) }												  					// [7]Digito da agencia

//	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;  // [1]Raz�o Social
		                 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;  // [2]C�digo
		                 AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)   ,;  // [3]Endere�o
		                 AllTrim(SA1->A1_MUN )                               ,;  // [4]Cidade
		                 SA1->A1_EST                                         ,;  // [5]Estado
		                 SA1->A1_CEP                                         ,;  // [6]CEP
		                 SA1->A1_CGC									     ,;  // [7]CGC
		                 SA1->A1_PESSOA										  }	 // [8]PESSOA
/*
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	                 ,;  // [1]Raz�o Social
		                 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;  // [2]C�digo
		                 AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;  // [3]Endere�o
		                 AllTrim(SA1->A1_MUNC)	                             ,;  // [4]Cidade
		                 SA1->A1_ESTC	                                     ,;  // [5]Estado
		                 SA1->A1_CEPC                                        ,;  // [6]CEP
		                 SA1->A1_CGC								 		 ,;	 // [7]CGC
		                 SA1->A1_PESSOA									     }	 // [8]PESSOA
	Endif
*/	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Monta codigo de barras
	aCB_RN_NN    :=Ret_cBarra(	SE1->E1_PREFIXO	,SE1->E1_NUM	,SE1->E1_PARCELA	,SE1->E1_TIPO	,;
						Subs(aDadosBanco[1],1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,;
						cNroDoc		,(E1_VALOR-nVlrAbat)	, aDadosBanco[6]	,"9"	)

	DbSelectArea("SE1")
	aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] N�mero do t�tulo
						E1_EMISSAO                         	,;  // [2] Data da emiss�o do t�tulo
						dDataBase                    	    ,;  // [3] Data da emiss�o do boleto
						E1_VENCTO                           ,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)               ,;  // [5] Valor do t�tulo
						aCB_RN_NN[3]                        ,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
						E1_PREFIXO                          ,;  // [7] Prefixo da NF
						E1_TIPO	                            ,;  // [8] Tipo do Titulo
						aCB_RN_NN[4]                       	}   // [9] Digito verificar do nosso numero
	
	Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
//	nX := nX + 1
	dbSkip()
	IncProc()
//	nI := nI + 1
EndDo
oPrint:EndPage()     // Finaliza a p�gina
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Impress � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",10,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p�gina

/******************/
/* PRIMEIRA PARTE */
/******************/
If 	c_Banco = "104" // CEF
	nRow1 := 150
	oPrint:Line (nRow1+0150,650,nRow1+0070, 650)
	oPrint:Line (nRow1+0150,860,nRow1+0070, 860)
Else
	nRow1 := 0
	oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
	oPrint:Line (nRow1+0150,710,nRow1+0070, 710)
Endif	

/*********************
COMPROVANTE DE ENTREGA
**********************/
//Box 1
/*******/
If 		c_Banco = "001" // BANCO DO BRASIL
		oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont11 )	// [2]Nome do Banco
   		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-9",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "237" // BRADESCO
		oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont11 )	// [2]Nome do Banco
   		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "004" // BNB
		oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont11 )	// [2]Nome do Banco
   		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-3",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "341" // ITAU
		oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont11 )	// [2]Nome do Banco
   		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "104" // CEF
        //oPrint:SayBitmap( nRow1+0084,100,cBitMap,400,120 )    
        
        oPrint:SayBitmap( nRow1+0045,000,cBitMap,350,100 )         //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	    //	oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont10 )		// 	[2]Nome do Banco
   		oPrint:Say  (nRow1+0075,660,aDadosBanco[1]+"-0",oFont21 )		// [1]Numero do Banco
Endif
If 	c_Banco = "104" // CEF
	oPrint:Say  (nRow1+0084,0940, "Emissao: "+StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
Else
	oPrint:Say  (nRow1+0084,0900, "Emissao: "+StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
Endif	
//If 	c_Banco = "341" // BANCO ITAU
//	oPrint:Say  (nRow1+0084,1500,Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9]),oFont10)
//Else
	oPrint:Say  (nRow1+0084,1500,Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9]),oFont10) //Nosso Numero+DV
//Endif	
oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
If 	c_Banco = "104" // CEF
	oPrint:Line (nRow1+0150,000,nRow1+0150,2300) //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
Else
	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)
Endif	

//Box 2
/*******/
If 	c_Banco = "104" //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow1+0150,000 ,"Cedente",oFont8) 
	oPrint:Say  (nRow1+0200,000 ,aDadosEmp[1],oFont10)				//Nome  
Else
	oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome
Endif	
oPrint:Say  (nRow1+0150,1060,"Ag�ncia/C�digo Cedente",oFont8)
If 	c_Banco = "341" // BANCO ITAU
   		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
ElseIf 	c_Banco = "104" // CEF                 
//AAAA.870.XXXXXXXX-D //870000000294
    	_cCC1:=Substr(SEE->EE_CODEMP,1,3)
    	_cCC2:=Substr(SEE->EE_CODEMP,4,8)
    	_cCC3:=Substr(SEE->EE_CODEMP,12,1)
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"."+_cCC1+"."+_cCC2+"-"+_cCC3,oFont10)
Else
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
Endif
oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+"-"+substr(aDadosTit[1],1,9)+" "+substr(aDadosTit[1],7,3),oFont10) //Prefixo +Numero+Parcela

//Box 3
/*******/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow1+0250,000 ,"Sacado",oFont8) 
	oPrint:Say  (nRow1+0300,000 ,aDatSacado[1],oFont10)				//Nome
Else
	oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
	oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome
Endif
oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

//Box 4
/*******/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow1+0400,000,"Recebi(emos) o bloqueto/t�tulo",oFont10)
	oPrint:Say  (nRow1+0450,000,"com as caracter�sticas acima.",oFont10)
Else
	oPrint:Say  (nRow1+0400,100,"Recebi(emos) o bloqueto/t�tulo",oFont10)
	oPrint:Say  (nRow1+0450,100,"com as caracter�sticas acima.",oFont10)
Endif
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

If 	c_Banco = "104" // CEF  //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Line (nRow1+0250,0000,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350,0000,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 )
	oPrint:Line (nRow1+0550,0000,nRow1+0550,2300 )
Else
	oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 )
	oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )
Endif

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) 
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
           

/*********************
Recibo do Sacado
**********************/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	nRow2 := 300
	//Pontilhado separador
	For nI := 000 to 2300 step 50
		oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI
	oPrint:Line (nRow2+0710,000,nRow2+0710,2300)
	oPrint:Line (nRow2+0710,650,nRow2+0630, 650)
	oPrint:Line (nRow2+0710,860,nRow2+0630, 860)
Else
	nRow2 := 0	
	//Pontilhado separador
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI
	oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
	oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
	oPrint:Line (nRow2+0710,710,nRow2+0630, 710)
Endif	

/*******/
//Box 1
/*******/
If 		c_Banco = "001" // BANCO DO BRASIL
		oPrint:Say(nRow2+0644,100,aDadosBanco[2],oFont11 )		// [2]Nome do Banco
   		oPrint:Say(nRow2+0635,513,aDadosBanco[1]+"-9",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "237" // BRADESCO
		oPrint:Say(nRow2+0644,100,aDadosBanco[2],oFont11 )		// [2]Nome do Banco
   		oPrint:Say(nRow2+0635,513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "004" // BNB
		oPrint:Say(nRow2+0644,100,aDadosBanco[2],oFont11 )		// [2]Nome do Banco
   		oPrint:Say(nRow2+0635,513,aDadosBanco[1]+"-3",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "341" // ITAU
		oPrint:Say(nRow2+0644,100,aDadosBanco[2],oFont11 )		// [2]Nome do Banco
   		oPrint:Say(nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "104" // CEF   //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia 
        oPrint:SayBitmap(nRow2+0600,000,cBitMap,350,100 )	    	//  [2]Nome do Banco
   		oPrint:Say  (nRow2+0635,660,aDadosBanco[1]+"-0",oFont21 )		// [1]Numero do Banco
Endif
oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)

If 	c_Banco = "104" // CEF  //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia  
	oPrint:Line (nRow2+0810,000,nRow2+0810,2300 )
	oPrint:Line (nRow2+0910,000,nRow2+0910,2300 )
	oPrint:Line (nRow2+0980,000,nRow2+0980,2300 )
	oPrint:Line (nRow2+1050,000,nRow2+1050,2300 )
Else
	oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
	oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
	oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
	oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )
Endif

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

/*******/
//Box 2
/*******/
//oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
//If 		c_Banco = "001" // BANCO DO BRASIL
//   		oPrint:Say  (nRow2+0750,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
If 		c_Banco = "237" // BRADESCO
		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
   		oPrint:Say  (nRow2+0750,100 ,"PAG�VEL PREFERENCIALMENTE NAS AG�NCIAS BRADESCO OU BANCO POSTAL",oFont10)
//ElseIf 	c_Banco = "004" // BNB
//   		oPrint:Say  (nRow2+0750,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
ElseIf 	c_Banco = "341" // ITAU
		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
   		oPrint:Say  (nRow2+0750,100 ,"AT� O VENCIMENTO, PREFERENCIALMENTE NO ITA�, AP�S SOMENTE NO ITA�",oFont10)                  
ElseIf 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
		oPrint:Say  (nRow2+0710,000 ,"Local de Pagamento",oFont8)
   		oPrint:Say  (nRow2+0750,000 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO, AP�S NA CAIXA ECON�MICA FEDERAL",oFont10)                  
Else   		
		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
   		oPrint:Say  (nRow2+0750,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
Endif
oPrint:Say  (nRow2+0765,400 ,"",oFont10)
oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
If 	c_Banco $ "104/341" // CEF ou BANCO ITAU
	nCol := 2280
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c,,,,1)
Else
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)
Endif	

/*******/
//Box 3
/*******/
If 	c_Banco = "104" // CEF                  //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow2+0810,000 ,"Cedente",oFont8)
	oPrint:Say  (nRow2+0850,000 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
Else
	oPrint:Say  (nRow2+0810,100 ,"Cedente",oFont8)
	oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
Endif
oPrint:Say  (nRow2+0810,1810,"Ag�ncia/C�digo Cedente",oFont8)
If 	c_Banco $ "104/341" // BANCO CEF ou ITAU
	If 	c_Banco = "104" // CEF                 
//AAAA.870.XXXXXXXX-D //870000000294
    	_cCC1:=Substr(SEE->EE_CODEMP,1,3)
    	_cCC2:=Substr(SEE->EE_CODEMP,4,8)
    	_cCC3:=Substr(SEE->EE_CODEMP,12,1)
		cString:=aDadosBanco[3]+"."+_cCC1+"."+_cCC2+"-"+_cCC3
	Else
	   	cString:=Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])          
	Endif
   	oPrint:Say  (nRow2+0850,2280,cString,oFont11c,,,,1)
Else
	cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)
Endif	

/*******/
//Box 4
/*******/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say(nRow2+0910,000 ,"Data do Documento"                              ,oFont8)
	oPrint:Say(nRow2+0940,000, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
Else
	oPrint:Say(nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say(nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
Endif
oPrint:Say(nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say(nRow2+0940,605 ,aDadosTit[7]+"-"+substr(aDadosTit[1],1,9)+" "+substr(aDadosTit[1],7,3),oFont10) //Prefixo +Numero+Parcela
oPrint:Say(nRow2+0910,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say(nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
oPrint:Say(nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say(nRow2+0940,1400,"N"                                             ,oFont10)
oPrint:Say(nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say(nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
oPrint:Say(nRow2+0910,1810,"Nosso N�mero"                                   ,oFont8)
If 		c_Banco = "001" // BANCO DO BRASIL e convenio com 6 digitos
   		cString := Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "237"
   		cString := Substr(Alltrim(aDadosTit[6]),1,2)+"/"+Substr(Alltrim(aDadosTit[6]),3,9)+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "004" // BNB
   		cString := Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "341" // ITAU
   		cString := Substr(Alltrim(aDadosTit[6]),1,3)+"/"+Substr(Alltrim(aDadosTit[6]),4,8)+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "104" // CEF
   		cString := Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9])
Endif
If 	c_Banco $ "104/341" // BANCO CEF ou ITAU
	nCol := 2280
	oPrint:Say  (nRow2+0940,nCol,cString,oFont11c,,,,1)
Else
	nCol := 1830+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0940,nCol,cString,oFont10)
Endif	

/*******/
//Box 5
/*******/
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow2+0980,000 ,"Uso do Banco",oFont8)
Else
	oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)
Endif	
oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
IF 		aDadosBanco[1] == "399"
  		oPrint:Say  (nRow2+1010,555 ,"CSB",oFont10)
ElseIf 	aDadosBanco[1] = "104" // CEF
  		oPrint:Say  (nRow2+1010,555 ,"CR",oFont10)
Else
   		oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6],oFont10)
Endif
oPrint:Say  (nRow2+0980,755 ,"Esp�cie",oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)
oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor",oFont8)
If 	aDadosBanco[1] = "104" // CEF
	oPrint:Say  (nRow2+0980,1810,"(=)Valor do Documento",oFont8)
Else	
	oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
Endif
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
If 	c_Banco $ "104/341" // BANCO ITAU
	nCol := 2280
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c,,,,1)
Else
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)
Endif	

/*******/
//Box 6
/*******/
_LiqJ := 0
_LiqJ := ((aDadosTit[5]*_nJur)/100)
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow2+1050,000 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1150,000 ,"Juros por dia de atraso = R$ "+ AllTrim(Transform(NOROUND((_LiqJ/30)),"@E 99,999.99")),oFont10)
	oPrint:Say  (nRow2+1200,000 ,"Protestar no 5 dia �til ap�s o vencimento",oFont10)
	oPrint:Say  (nRow2+1250,000 ,""                                        ,oFont10)
Else
	oPrint:Say  (nRow2+1050,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1150,100 ,"Juros por dia de atraso = R$ "+ AllTrim(Transform(NOROUND((_LiqJ/30)),"@E 99,999.99")),oFont10)
	oPrint:Say  (nRow2+1200,100 ,"Protestar no 5 dia �til ap�s o vencimento",oFont10)
	oPrint:Say  (nRow2+1250,100 ,""                                        ,oFont10)
Endif

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

/*******/
//Box 7
/*******/
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow2+1400,000 ,"Sacado"                                         ,oFont8)
Else
	oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
Endif
oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow2+1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf
oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10) //Nosso Numero
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow2+1605,000 ,"Sacador/Avalista",oFont8)
Else
	oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
Endif
oPrint:Say  (nRow2+1645,1500,"Autentica��o Mec�nica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 ) 
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Line (nRow2+1400,000 ,nRow2+1400,2300 )
	oPrint:Line (nRow2+1640,000 ,nRow2+1640,2300 )
Else
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )
Endif	


/*********************
Ficha de compensacao
**********************/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	nRow3 := 320
	For nI := 000 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI
	oPrint:Line (nRow3+2000,000,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,650,nRow3+1920, 650)
	oPrint:Line (nRow3+2000,860,nRow3+1920, 860)
Else
	nRow3 := 0
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI
	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)
Endif	

/*******/
//Box 1
/*******/
If 		c_Banco = "001" // BANCO DO BRASIL
		oPrint:Say(nRow3+1934,100,aDadosBanco[2],oFont11 )		// 	[2]Nome do Banco
   		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-9",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "237" // BRADESCO
		oPrint:Say(nRow3+1934,100,aDadosBanco[2],oFont11 )		// 	[2]Nome do Banco
   		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "004" // BNB
		oPrint:Say(nRow3+1934,100,aDadosBanco[2],oFont11 )		// 	[2]Nome do Banco
   		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-3",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "341" // ITAU
		oPrint:Say(nRow3+1934,100,aDadosBanco[2],oFont11 )		// 	[2]Nome do Banco
   		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
ElseIf 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	    oPrint:SayBitmap( nRow3+1890,000,cBitMap,350,100 )	    	//  [2]Nome do Banco
   		oPrint:Say  (nRow3+1925,660,aDadosBanco[1]+"-0",oFont21 )		// [1]Numero do Banco
		/*oPrint:Say(nRow3+1934,100,aDadosBanco[2],oFont10 )		// 	[2]Nome do Banco
   		oPrint:Say  (nRow3+1925,660,aDadosBanco[1]+"-0",oFont21 )		// [1]Numero do Banco*/
Endif
//Linha digit�vel
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow3+1934,870,aCB_RN_NN[2],oFont14n)			//		Linha Digitavel do Codigo de Barras
	oPrint:Line (nRow3+2100,000,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,000,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,000,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,000,nRow3+2340,2300 )
Else
	oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras
	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )
Endif

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

/*******/
//Box 2
/*******/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow3+2000,000 ,"Local de Pagamento",oFont8)
Else
	oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
Endif	
//If c_Banco = "001" // BANCO DO BRASIL
//   oPrint:Say  (nRow3+2040,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
If 		c_Banco = "237" // BRADESCO
   		oPrint:Say  (nRow3+2040,100 ,"PAG�VEL PREFERENCIALMENTE NAS AG�NCIAS BRADESCO OU BANCO POSTAL",oFont10)
//ElseIf c_Banco = "004" // BNB
//   oPrint:Say  (nRow3+2040,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
ElseIf 	c_Banco = "341" // ITAU
   		oPrint:Say  (nRow3+2040,100 ,"AT� O VENCIMENTO, PREFERENCIALMENTE NO ITA�, AP�S SOMENTE NO ITA�",oFont10)
ElseIf 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
   		oPrint:Say  (nRow3+2040,000 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO, AP�S NA CAIXA ECON�MICA FEDERAL",oFont10)                  
Else   		
		oPrint:Say  (nRow3+2040,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
Endif
oPrint:Say  (nRow3+2055,400 ,"",oFont10)          
oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
If 	c_Banco $ "104/341" // CEF ou BANCO ITAU
	nCol := 2280
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c,,,,1)
Else
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)
Endif	

/*******/
//Box 3
/*******/
If 	c_Banco = "104" // CEF                  //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow3+2100,000 ,"Cedente",oFont8)
	oPrint:Say  (nRow3+2140,000 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
Else
	oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
	oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
Endif
oPrint:Say  (nRow3+2100,1810,"Ag�ncia/C�digo Cedente",oFont8)
If 	c_Banco $ "104/341" // CEF ou BANCO ITAU
	If 	c_Banco = "104" // CEF                 
		//AAAA.870.XXXXXXXX-D //870000000294
    	_cCC1:=Substr(SEE->EE_CODEMP,1,3)
    	_cCC2:=Substr(SEE->EE_CODEMP,4,8)
    	_cCC3:=Substr(SEE->EE_CODEMP,12,1)
		cString:=aDadosBanco[3]+"."+_cCC1+"."+_cCC2+"-"+_cCC3
	Else
	   	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])          
	Endif
   	oPrint:Say  (nRow3+2140,2280,cString,oFont11c,,,,1)
Else
	cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)
Endif	

/*******/
//Box 4
/*******/
If 	c_Banco = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say(nRow3+2200,000 ,"Data do Documento"                              ,oFont8)
	oPrint:Say(nRow3+2230,000, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)
Else
	oPrint:Say(nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say(nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)
Endif
oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+"-"+substr(aDadosTit[1],1,9)+" "+substr(aDadosTit[1],7,3) ,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (nRow3+2200,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow3+2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)
oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao
oPrint:Say  (nRow3+2200,1810,"Nosso N�mero"                                   ,oFont8)
If 		c_Banco = "001" // BANCO DO BRASIL e convenio com 6 digitos
   		cString := Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "237"
   		cString := Substr(Alltrim(aDadosTit[6]),1,2)+"/"+Substr(Alltrim(aDadosTit[6]),3,9)+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "004" // BNB
   		cString := Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "341" // ITAU
   		cString := Substr(Alltrim(aDadosTit[6]),1,3)+"/"+Substr(Alltrim(aDadosTit[6]),4,8)+"-"+Alltrim(aDadosTit[9])
ElseIf 	c_Banco = "104" // CEF
   		cString := Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9])
Endif
If 	c_Banco $ "104/341" // BANCO CEF ou ITAU
	nCol := 2280
	oPrint:Say  (nRow3+2230,nCol,cString,oFont11c,,,,1)
Else
	nCol 	 := 1830+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230,nCol,cString,oFont10)
Endif	

/*******/
//Box 5
/*******/
IF 		aDadosBanco[1] == "399"
		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)
		oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
  		oPrint:Say  (nRow3+2300,555 ,"CSB"                                  	,oFont10)
ElseIf 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
		oPrint:Say  (nRow3+2270,000 ,"Uso do Banco"                                   ,oFont8)
		oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
  		oPrint:Say  (nRow3+2300,555 ,"CR",oFont10)
Else
		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)
		oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
 		oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10)
Endif
oPrint:Say  (nRow3+2270,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)
oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)
If 	aDadosBanco[1] = "104" // CEF
	oPrint:Say  (nRow3+2270,1810,"(=)Valor do Documento",oFont8)
Else	
	oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
Endif	
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
If 	c_Banco $ "104/341" // BANCO CEF ou ITAU
	nCol := 2280
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c,,,,1)
Else
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)
Endif	

/*******/
//Box 6
/*******/
_LiqJ := 0
_LiqJ := ((aDadosTit[5]*_nJur)/100)
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow3+2340,000 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow3+2390,000 ,"Juros por dia de atraso = R$"+ AllTrim(Transform(NOROUND((_LiqJ/30)),"@E 99,999.99")),oFont10)
	oPrint:Say  (nRow3+2440,000 ,"Protestar no 5 dia �til ap�s o vencimento",oFont10)
	oPrint:Say  (nRow3+2540,000 ,""                                        ,oFont10)
Else
	oPrint:Say  (nRow3+2340,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow3+2390,100 ,"Juros por dia de atraso = R$"+ AllTrim(Transform(NOROUND((_LiqJ/30)),"@E 99,999.99")),oFont10)
	oPrint:Say  (nRow3+2440,100 ,"Protestar no 5 dia �til ap�s o vencimento",oFont10)
	oPrint:Say  (nRow3+2540,100 ,""                                        ,oFont10)
Endif
oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

/*******/
//Box 7
/*******/
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Say  (nRow3+2690,000 ,"Sacado"                                         ,oFont8)
Else
	oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
Endif	
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf
oPrint:Say  (nRow3+2753,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2855,1500,"Autentica��o Mec�nica - Ficha de Compensa��o"                        ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
If 	aDadosBanco[1] = "104" // CEF //zerada a margem esquerda, para atender a dist�ncia de 5mm exigida pela CEF - Bia
	oPrint:Line (nRow3+2690,000 ,nRow3+2690,2300 )
	oPrint:Line (nRow3+2850,000,nRow3+2850,2300  )
Else
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
	oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
Endif

/******************/
//Codigo de Barras
/******************/
//MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)

//TIREI DO IF ESSA PARTE. O TIPO DE IMPRESSORA NAO IMPORTA
MSBAR3("INT25",25.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)

//ADRIANO - COMENTEI - ESPECIFICO MOTIVA
/*If 	MV_PAR15 = 2             
	If	c_Banco = "341" // BANCO ITAU
	   	MSBAR3("INT25",25.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	ElseIf	c_Banco = "104" // CEF
//	   	MSBAR3("INT25",22.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	   	MSBAR3("INT25",23.5,0,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.1,Nil,Nil,"A",.F.)
	Else
	   	MSBAR3("INT25",24.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	Endif	   	
Else                                                                
	If	c_Banco = "104" // CEF
//   		MSBAR3("INT25",22.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
   		MSBAR3("INT25",22.5,0,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	Else
   		MSBAR3("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)	
// 		MSBAR3("INT25",20.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	Endif
Endif
*/
/**********************/
//Fim da impress�o
/**********************/

//Gravacao do Nosso Numero
If 	Empty(SE1->E1_NUMBCO)
	DbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO 	:=	aCB_RN_NN[3]   // Nosso n�mero (Ver f�rmula para calculo)
	SE1->E1_NUMDV 	:=  "341"//	aCB_RN_NN[4]
	//SE1->E1_BCO   	:=	SA6->A6_COD
	//SE1->E1_AGE   	:=	SA6->A6_AGENCIA
	//SE1->E1_CC    	:=	SA6->A6_NUMCON
	MsUnlock()
endif

oPrint:EndPage() // Finaliza a p�gina

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RetDados  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera SE1                        					          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
						cBanco		,cAgencia	,cConta		,cDacCC	,;
						cNroDoc		,nValor		,cCart		,cMoeda	)

Local cNosso		:= ""
Local cDigNosso		:= ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra		:= ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}

//DEFAULT nValor := 0

cAgencia:=STRZERO(Val(cAgencia),4)
		
If 		c_Banco = "001" // BANCO DO BRASIL
	    /*
    	COMPOSI��O DO NOSSO-N�MERO DOS BLOQUETOS DE COBRAN�A:             
	    b) Conv�nio de seis posi��es:                                     
    	   I      - CCCCCCNNNNN-X;                                        
	
    	c) Conv�nios de sete posi��es, numera��o superior a 1.000.000 (um milh�o):                                                       
	       I      - CCCCCCCNNNNNNNNNN                                     
    	   OBS: N�o existe DV - D�gito Verificador - na composi��o do nosso-n�mero para conv�nios
        	    de sete posi��es, superior a 1.000.000.                  
	       OBS:  "C" - N�mero do conv�nio atribu�do pelo Sistema Cobran�a 
    	        "N" - Seq�encial atribu�do pelo cliente ou sistema Cobran�a 
         
	    */
    	if empty(SE1->E1_NUMBCO)
	       cNosso    :=SubStr(SEE->EE_CODEMP,1,6)+Strzero(Val(SEE->EE_FAXATU),5) // Conv�nio de seis posi��es
//  	     cDigNosso:=Modulo11(cNosso)
	       L := Len(cNosso)
    	   D := 0
	       P := 10
    	   cDV:= " "

	       TbVlr:=Array(L)
    	   For I = 1 To L
        	   TbVlr[I]:=Val(Substr(cNosso,I,1))
	       Next

    	   D:=L 
	       nTot:=0      
    	   Do  While D > 0
        	   P:=Iif(P>2,P-1,9)
	           nTot:=nTot+(TbVlr[D]*P)
    	       D--
	       Enddo  

    	   nDiv:=Int(nTot/11)
	       nResto:=nTot-(nDiv*11)
//  	     nResto:=11-nResto
	       If  nResto=10
    	       cDv:="X"
	       ElseIf  nResto=0
    	       cDv:="0"
	       Else
    	       cDv:=Str(nResto,1)
	       Endif    
    	   cDigNosso := cDv

		   DbSelectArea("SEE")
    	   RecLock("SEE",.F.)
	         SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,10)
    	   MsUnlock()
	    else
		   cDigNosso  := "341"//SE1->E1_NUMDV
		   cNosso     := ALLTRIM(SE1->E1_NUMBCO)
    	endif
	    //Campo Livre
    	cCampoL := cNosso+cAgencia+STRZERO(VAL(cConta),8)+cCart  // Convenio de seis posi��es
	//    cCampoL := "000000"+cNosso+cCart  // Convenio de sete posi��es
ElseIf 	c_Banco = "237" // BRADESCO
		If Empty(SE1->E1_NUMBCO)
    	   nSoma := 0
	       nBaseMod11 := 7			//----- Banco Bradesco usa Modulo 11 Base 7
    	   nDivisor	  := 2			//----- Divisor das parcelas, iniciando em 2
	       cMes		  := StrZero(Month(SE1->E1_EMISSAO),2)
    	   cSequencia := StrZero(Val(SEE->EE_FAXATU),6)

		   DbSelectArea("SEE")
    	   RecLock("SEE",.F.)
	         SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,6)
    	   MsUnlock()

	//       cNossoNum := StrZero(Month(SE1->E1_EMISSAO),2)+'999'+cSequencia
    	   cNossoNum := cCart+'999'+cSequencia
	       cNros 	 := cCart+cNossoNum
    	   aNros := {}
	       For i := 1 to Len(cNros)
    	       AADD(aNros,Subs(cNros,i,1))
	       Next

    	   For i := Len(aNros)  to  1  step -1
        	   nSoma := nSoma+ (   Val(aNros[i]) * nDivisor   )
	           nDivisor	:= iif( nDivisor >= nBaseMod11 , 2 , nDivisor+1	)
    	   Next
	       nDV	:= 11 -( Mod(nSoma,11) )
    	   nDV 	:= IIF( nDV==11, 0, nDV ) 
	       nDV 	:= IIF( nDV==10, "P", Str(nDV) )

    	   cNosso    := cNossoNum
	       cDigNosso := Alltrim(nDv)
		Else
		   cNosso    := Alltrim(SE1->E1_NUMBCO)
		   cDigNosso := "341"//SE1->E1_NUMDV
		Endif
    	cCampoL := cAgencia+cCart+cNosso+Strzero(val(cConta),7)+"0"
ElseIf	c_Banco = "004" // BNB
	    cNosso := ""
    	if empty(SE1->E1_NUMBCO)
	   	   //Nosso Numero
    	   nSoma := 0
	       nBaseMod11 := 8			//----- Banco BnB usa Modulo 11 Base 8
    	   nDivisor	  := 2			//----- Divisor das parcelas, iniciando em 2
	       cSequencia := StrZero(Val(SEE->EE_FAXATU),7)

		   DbSelectArea("SEE")
	       RecLock("SEE",.F.)
    	     SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,7)
	       MsUnlock()

    	   cNossoNum := cSequencia
	       cNros 	 := cNossoNum
    	   aNros := {}
	       For i := 1 to Len(cNros)
    	       AADD(aNros,Subs(cNros,i,1))
	       Next

    	   For i := Len(aNros)  to  1  step -1
        	   nSoma := nSoma+ (   Val(aNros[i]) * nDivisor   )
	           nDivisor	:= iif( nDivisor >= nBaseMod11 , 2 , nDivisor+1	)
    	   Next

	       nDiv:=Int(nSoma/11)
    	   nResto:=nSoma-(nDiv*11)
	       cDv:=Iif(Alltrim(Str(nResto,2))$"0/1/","0",Str(11-nResto,1))

    	   cNosso    := cNossoNum
	       cDigNosso := Alltrim(cDv)
    	else
		   //Nosso Numero
		   cNosso     := ALLTRIM(SE1->E1_NUMBCO)
		   cDigNosso  := "341"//SE1->E1_NUMDV
    	endif
	    // campo livre			// verificar a conta e carteira
    	cCampoL := STRZERO(VAL(cAgencia),4)+STRZERO(VAL(cConta),7)+cDacCC+cNosso+cDigNosso+"50000"
ElseIf  c_Banco = "341" // ITAU
	    cNosso := ""
    	if empty(SE1->E1_NUMBCO)
	   	   //Nosso Numero
    	   cNroDoc := cCart+StrZero(Val(SEE->EE_FAXATU),8)

		   DbSelectArea("SEE")
    	   RecLock("SEE",.F.)
	         SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,8)
    	   MsUnlock()

	       cNros := cAgencia+cConta+cNroDoc
    	   aNros := {}
	       For i := 1 to Len(cNros)
    	       AADD(aNros,Subs(cNros,i,1))
	       Next       
    	   nResul:= {}                                  
	       nSoma:=0
    	   nMult:=2
	       For i := Len(aNros)  to  1  step -1
		       Resul:= Val(aNros[i]) * nMult
	           If Resul < 10
    	          AADD(nResul,Resul)
	           Else
    	          AADD(nResul,Val(Subs(Str(Resul,2),1,1)))
	              AADD(nResul,Val(Subs(Str(Resul,2),2,1)))
		       Endif
	    	   nMult := iif( nMult = 1 , 2 , 1 )
	       Next    
    	   For i := 1 to Len(nResul)
        	   nSoma := nSoma + nResul[i]
	       Next
    	   resto:= MOD(nSoma,10)
	       If resto = 0
    	      cNroDV := "0"
	       Else
    	      cNroDV := Str(10-RESTO,1)
	       Endif

    	   cNosso    := cNroDoc
	       cDigNosso := cNroDV
    	else
		   //Nosso Numero
		   cNosso     := ALLTRIM(SE1->E1_NUMBCO)
		   cDigNosso  := "341"//SE1->E1_NUMDV
    	endif
	    cCampoL := cNosso+ cDigNosso+cAgencia+cConta+cDacCC+'000'
ElseIf  c_Banco = "104" // CEF
    	cNosso := ""
    	If	Empty(SE1->E1_NUMBCO)
   	   		//Nosso Numero
       		cNroDoc := Substr(SEE->EE_FAXATU,1,10)
	   		DbSelectArea("SEE")
       		RecLock("SEE",.F.)
         		SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,10)
       		MsUnlock()
			nCont:=0
			cBarraImp3 	:= space(11)
			cBarraImp3	:= cNroDoc  // Subs(cBarra,19,11)
			nCont :=0
			nCont :=nCont+(Val(Subs(cBarraImp3,10,1))*2)
			nCont :=nCont+(Val(Subs(cBarraImp3,09,1))*3)
			nCont :=nCont+(Val(Subs(cBarraImp3,08,1))*4)
			nCont :=nCont+(Val(Subs(cBarraImp3,07,1))*5)
			nCont :=nCont+(Val(Subs(cBarraImp3,06,1))*6)
			nCont :=nCont+(Val(Subs(cBarraImp3,05,1))*7)
			nCont :=nCont+(Val(Subs(cBarraImp3,04,1))*8)
			nCont :=nCont+(Val(Subs(cBarraImp3,03,1))*9)
			nCont :=nCont+(Val(Subs(cBarraImp3,02,1))*2)
			nCont :=nCont+(Val(Subs(cBarraImp3,01,1))*3)
			nCont1:=int(nCont  / 11)
			nCont2:=ncont1 * 11
			nResto:=ncont - ncont2
			nResto:=11 - nResto
			If 	nResto > 9
          		cNroDV:= "0"
			Else
				cNroDV:=strzero(nResto,1)
			EndIf
       		cNosso   :=cNroDoc
       		cDigNosso:=cNroDV
    	Else
	   		//Nosso Numero
	   		cNosso   :=ALLTRIM(SE1->E1_NUMBCO)
	   		cDigNosso:="341"//SE1->E1_NUMDV
    	Endif                                                  
    	//9NNNNNNNNN AAAA YYY XXXXXXXX
    	cCampoL:=cNosso+cAgencia+Substr(SEE->EE_CODEMP,1,11)
Endif

//campo livre do codigo de barra                   // verificar a conta
If 	nValor > 0
	cFatorValor  := fator()+strzero(nValor*100,10)
Else
	cFatorValor  := fator()+strzero(SE1->E1_VALOR*100,10)
Endif

cLivre := cBanco+cMoeda+cFatorValor+cCampoL
//'237900000000000000364609000000000000000000'

If 		c_Banco = "001" // BANCO DO BRASIL
	   	cDVBarra:=Modulo11(cLivre)
   		cBarra:=Substr(cLivre,1,4)+cDVBarra+Substr(cLivre,5,39)
	   	//Montagem da linha digit�vel	
   		cCampo1:=Substr(cBarra,1,4)+Substr(cBarra,20,5)
	   	cDv1   :=Modulo10(cCampo1)
   		cCampo2:=Substr(cBarra,25,10)
	   	cDv2   :=Modulo10(cCampo2)
   		cCampo3:=Substr(cBarra,35,10)
	   	cDv3   :=Modulo10(cCampo3)
   		cCampo4:=Substr(cBarra,5,1)
	   	cCampo5:=Substr(cBarra,6,14)

   		cDigital := substr(cCampo1,1,5)+"."+substr(cCampo1,6,4)+cDv1+" "+;
					   substr(cCampo2,1,5)+"."+substr(cCampo2,6,5)+cDv2+" "+;
				   substr(cCampo3,1,5)+"."+substr(cCampo3,6,5)+cDv3+" "+;
				   cCampo4+" "+;
				   cCampo5
ElseIf 	c_Banco = "237" // BRADESCO
	   cDVBarra:=CalcMod112(cLivre)
	   cBarra:=Substr(cLivre,1,4)+cDVBarra+Substr(cLivre,5,39)
//
	   cCampo1:=Substr(cBarra,1,4)+Substr(cBarra,20,5)
	   cDv1   :=CalcMod102(cCampo1)
	   cCampo2:=Substr(cBarra,25,10)
	   cDv2   :=CalcMod102(cCampo2)
	   cCampo3:=Substr(cBarra,35,10)
	   cDv3   :=CalcMod102(cCampo3)
	   cCampo4:=Substr(cBarra,5,1)
	   cCampo5:=Substr(cBarra,6,14)

   		cDigital := substr(cCampo1,1,5)+"."+substr(cCampo1,6,4)+cDv1+" "+;
				   substr(cCampo2,1,5)+"."+substr(cCampo2,6,5)+cDv2+" "+;
				   substr(cCampo3,1,5)+"."+substr(cCampo3,6,5)+cDv3+" "+;
				   cCampo4+" "+;
				   cCampo5
ElseIf 	c_Banco = "004" // BNB
	   cDVBarra:=CalcMod112(cLivre)
	   cBarra:=Substr(cLivre,1,4)+cDVBarra+Substr(cLivre,5,39)
//
	   cCampo1:=Substr(cBarra,1,4)+Substr(cBarra,20,5)
	   cDv1   :=CalcMod102(cCampo1)
	   cCampo2:=Substr(cBarra,25,10)
	   cDv2   :=CalcMod102(cCampo2)
	   cCampo3:=Substr(cBarra,35,10)
	   cDv3   :=CalcMod102(cCampo3)
	   cCampo4:=Substr(cBarra,5,1)
	   cCampo5:=Substr(cBarra,6,14)

   		cDigital := substr(cCampo1,1,5)+"."+substr(cCampo1,6,4)+cDv1+" "+;
				   substr(cCampo2,1,5)+"."+substr(cCampo2,6,5)+cDv2+" "+;
				   substr(cCampo3,1,5)+"."+substr(cCampo3,6,5)+cDv3+" "+;
				   cCampo4+" "+;
			   	cCampo5
ElseIf 	c_Banco = "341" // ITAU
   		cDVBarra:=CalcMod112(cLivre)
	   	cBarra:=Substr(cLivre,1,4)+cDVBarra+Substr(cLivre,5,39)
//
   		cCampo1:=Substr(cBarra,1,4)+Substr(cBarra,20,5)
   		cDv1   :=CalcMod102(cCampo1)
   		cCampo2:=Substr(cBarra,25,10)
   		cDv2   :=CalcMod102(cCampo2)
   		cCampo3:=Substr(cBarra,35,10)
   		cDv3   :=CalcMod102(cCampo3)
   		cCampo4:=Substr(cBarra,5,1)
   		cCampo5:=Substr(cBarra,6,14)

   		cDigital := substr(cCampo1,1,5)+"."+substr(cCampo1,6,4)+cDv1+" "+;
					substr(cCampo2,1,5)+"."+substr(cCampo2,6,5)+cDv2+" "+;
			   		substr(cCampo3,1,5)+"."+substr(cCampo3,6,5)+cDv3+" "+;
			   		cCampo4+" "+;
			   		cCampo5
ElseIf 	c_Banco = "104" // CEF
   		cDVBarra:=CalcMod112(cLivre) 
	   	cBarra:=Substr(cLivre,1,4)+cDVBarra+Substr(cLivre,5,39)

   		cCampo1:=Substr(cBarra,1,4)+Substr(cBarra,20,5)
   		cDv1   :=CalcMod102(cCampo1)
   		cCampo2:=Substr(cBarra,25,10)
   		cDv2   :=CalcMod102(cCampo2)
   		cCampo3:=Substr(cBarra,35,10)
   		cDv3   :=CalcMod102(cCampo3)
   		cCampo4:=Substr(cBarra,5,1)
   		cCampo5:=Substr(cBarra,6,14)

   		cDigital := substr(cCampo1,1,5)+"."+substr(cCampo1,6,4)+cDv1+" "+;
					substr(cCampo2,1,5)+"."+substr(cCampo2,6,5)+cDv2+" "+;
			   		substr(cCampo3,1,5)+"."+substr(cCampo3,6,5)+cDv3+" "+;
			   		cCampo4+" "+;
			   		cCampo5
Endif

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)		
Aadd(aRet,cDigNosso)		

Return aRet

********************************
Static Function Modulo10(cCampo)
********************************
LOCAL L, D, P := 0
L := Len(cCampo)
D := 0
P := 1
cDV:= " "

TbVlr:=Array(L)
For I = 1 To L
    TbVlr[I]:=Val(Substr(cCampo,I,1))
Next

D:=L 
nTot:=0      
Do  While D > 0
    P:=Iif(P=1,2,1)
    nMult:=TbVlr[D]*P
    If  nMult>9 
        nN:=Val(Substr(Str(nMult,2),1,1))+Val(Substr(Str(nMult,2),2,1))
    Else    
        nN:=nMult
    Endif
    nTot:=nTot+nN
    D--
Enddo  

nDez:=(Val(Substr(Str(nTot,2),1,1))+1)*10
cDv:=nDez-nTot
If  cDv=10
    cDv:="0"
Else    
    cDv:=Str(cDv,1)
Endif    

Return(cDV)

********************************
Static Function Modulo11(cCampo) 
********************************
LOCAL L, D, P := 0
L := Len(cCampo)
D := 0
P := 1
cDV:= " "

TbVlr:=Array(L)
For I = 1 To L
    TbVlr[I]:=Val(Substr(cCampo,I,1))
Next

D:=L 
nTot:=0      
Do  While D > 0
    P:=Iif(P<9,P+1,2)
    nTot:=nTot+(TbVlr[D]*P)
    D--
Enddo  

nDiv:=Int(nTot/11)
nResto:=nTot-(nDiv*11)
nResto:=11-nResto
cDv:=Iif(Alltrim(Str(nResto,2))$"0/10/11/","1",Str(nResto,1))

Return(cDV)

STATIC FUNCTION CalcMod102(cNros)
//----- Calcula Digito Verificador usando modulo 10
//----- Sequencia de Numeros para calculo do digito verificador

aNros 		:= {}
cProdutos:= ''
nsoma		:= 0
For i := Len(cNros) to 1 step -1
	AADD(aNros,Subs(cNros,i,1))
Next
For i := 1 to Len(aNros)
	If !( i%2 ) = 0
		/*[ Posicao Par na Sequencia ]*/
		cProdutos := cProdutos+alltrim(str(Val(aNros[i])*2	))
	Else
		/*[ Posicao Impar na Sequencia ]*/
		cProdutos := cProdutos+alltrim(str(Val(aNros[i])*1))
	Endif
Next
For i:= 1 to Len(cProdutos)
	nSoma := nSoma+Val(Subs(cProdutos,i,1))
Next

nDV := 10 - Mod(nSoma,10)
nDV := IIF( nDV==10, 0, nDV )
cDv :=	 Alltrim(Str(nDV))
Return(cDV)

STATIC FUNCTION CalcMod112(cLivre)

aNros 	   := {}
nDivisor   := 2
nSoma	   := 0
nBaseMod11 := 9
For i := 1 to Len(cLivre)
	AADD(aNros,Subs(cLivre,i,1))
Next
For i := Len(aNros)  to  1  step -1
	nSoma    := nSoma+ ( Val(aNros[i]) * nDivisor )
	nDivisor := iif( nDivisor >= nBaseMod11 , 2 , nDivisor+1	)
Next

nDV := 11 -( Mod(nSoma,11) )
nDV := IIF( nDV==11, 1, nDV )
nDV := IIF( nDV==10, 1, nDV )
nDV := IIF( nDV== 1, 1, nDV )
nDV := IIF( nDV== 0, 1, nDV )

cDv :=	Alltrim(Str(nDV))
Return(cDV)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �FATOR		�Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do FATOR  de vencimento para linha digitavel.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function Fator()
If c_Banco = "001" // BANCO DO BRASIL
   dt    :=ctod('07/10/1997')
   cVenc :=SE1->E1_VENCTO
   cFator := alltrim(str(cVenc - dt))
ElseIf c_Banco = "237" // BRADESCO
   dt    :=ctod('07/10/1997')
   cVenc :=SE1->E1_VENCTO
   cFator := Strzero((cVenc - dt),4)
ElseIf c_Banco = "004" // BNB
   dt    :=ctod('07/10/1997')
   cVenc :=SE1->E1_VENCTO
   cFator := Strzero((cVenc - dt),4)
ElseIf c_Banco = "341" // ITAU
   dt    :=ctod('07/10/1997')
   cVenc :=SE1->E1_VENCTO
   cFator := Strzero((cVenc - dt),4)
ElseIf c_Banco = "104" // CEF
   dt    :=ctod('07/10/1997')
   cVenc :=SE1->E1_VENCTO
   cFator := Strzero((cVenc - dt),4)
Endif
Return(cFator)

/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1    � Autor � Microsiga            	� Data � 13/10/03 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica/cria SX1 a partir de matriz para verificacao          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                    	  		���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
//Nao precisa para a Motiva - Adriano
Static Function LimpaCC(xNumCon)
L := Len(xNumCon)

Conta:=""
For I = 1 To L
    If Substr(xNumCon,I,1) <> "."
       Conta := Conta+Substr(xNumCon,I,1)
    Endif
Next
    
Return(Conta)

Static Function DesMarca()
DbSelectArea("SE1")
DbGoTop()
While !EOF()
	If Marked("E1_OK")     //Registro esta marcado
		Reclock("SE1",.F.)
		E1_OK := ThisMark()
		MsUnlock()
	EndIf
	DbSkip()
End
DbGoTop()
_oMark:oBrowse:Refresh()
Return
//
Static Function Marca()
cMarca:=GetMark()
DbSelectArea("TRB")
DbGoTop()
While !EOF()
	
	If !Marked("OK")     //Registro nao esta marcado
		Reclock("TRB",.F.)
		TRB->OK := cMarca
		MsUnlock()
	EndIf
	DbSkip()
End
DbGoTop()
_oMark:oBrowse:Refresh()

Return
