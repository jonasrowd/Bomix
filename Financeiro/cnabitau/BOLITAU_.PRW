#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include "colors.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º BOLETOITAU º AUTOR -    DANIEL SOUZA     º DATA º MAIO/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º PROGRAMA ESPECIFICO PARA EMISSAO DO BOLETO ITAU ATRAVES DOS º±±
±±º              º DADOS DOS TÍTULOS COBRANCA CADASTRADOS NO SISTEMA           º±±
±±º              º DESDE QUE A FORMA DE PAGAMENTO ASSIM O JUSTIFIQUE.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ¹±±
±±º TABS.UTILIZ  º DESCRICAO                                          º ACESSO º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍ¹±±
±±º   SA1010     º CADASTRO DE CLIENTES                               º READ   º±±
±±º   SA6010     º CADASTRO DE BANCOS                                 º READ   º±±                             
±±º   SE1010     º CONTAS A RECEBER                                   º WRITE  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¹±±
±±º PROPRIETARIO º CUSTOMIZADO PARA ONÇA TRANSPORTES                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BOLITAU1(aGerbol )
//User Function BOLITAU1(cPref,cNum,cCliente,cLoja )

LOCAL   nOpc := 0
PRIVATE Exec    := .F.
//PRIVATE aGerbol := {}
//
//cPerg     :="BOLETOITAU"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ValidPerg()
//
//If !Pergunte(cPerg,.T.)
//	Return()
//EndIf
//
//CRIA_MV()
//
PRIVATE nCB1Linha	:= 14.5   //GETMV("PV_BOL_LI1") //14.5
PRIVATE nCB2Linha	:= 26.1   //GETMV("PV_BOL_LI2") //26.1
Private nCBColuna	:= 1.3    //GETMV("PV_BOL_COL") //1.3
Private nCBLargura	:= 0.0280 //GETMV("PV_BOL_LAR") //0.0280
Private nCBAltura	:= 1.4    //GETMV("PV_BOL_ALT") //1.4
Private _cNossoNum	:= ""
Private cBanco     := '341'
Private cAgenc     := '0585'
Private cConta     := '14677'
Private _cNossoNum := ""

//
DbselectArea("SE1")
DbSetOrder(1)
//Processa({|lEnd|MontaRe2(cPref,cNum,cCliente,cLoja)})

Processa({|lEnd|MontaRe2(Agerbol)})
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaRel()   ³Descri‡ão³Montagem e Impressao de boleto Gra- ³±±
±±³          ³             ³         ³fico do Banco Itau.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRe2(AgerBol) //cPref,cNum,cCliente,cLoja)
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\logo_itau.bmp"


LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                              ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
//LOCAL aBolText     := {"Desconto até o vencimento de R$ "						,;
LOCAL aBolText     := {"Desconto até o vencimento de R$ "						,;
"Após o Vencimento Cobrar Multa de R$ "						,;
"Após o Vencimento Cobrar Mora Diaria de R$ "            ,;
"Sujeito a Protesto apos 05 (cinco) dias do vencimento"  ,;
"Conceder Abatimento de R$ "						             }

// "Após o vencimento cobrar multa de R$ "

LOCAL i          := 1
LOCAL CB_RN_NN   := {}
LOCAL nRec       := 0
LOCAL _nVlrAbat  := 0
LOCAL cParcela	 := ""
Local Z			:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
//
for Z := 1 to Len(aGerbol)
	cPref     := aGerbol[Z][1]
	cNum      := aGerbol[Z][2]
	cCliente  := aGerbol[Z][3]
	cLoja     := aGerbol[Z][4]

	dbSelectArea("SE1")
	SE1->(dbSetorder(1)) // E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	SE1->(DBSEEK(xFilial("SE1")+padr(cPref,3)+padr(cNum,9),.t.))
	//MsgStop("DANIEL - Procurando... -> "+cPref+'-'+cNum+' ' )                             //cPref,cNum,cCliente,cLoja
	Do While !EOF() .and. SE1->E1_PREFIXO+SE1->E1_NUM == cPref+cNum .AND. SE1->E1_CLIENTE+SE1->E1_LOJA == cCliente+cLoja
		IF SE1->E1_SALDO <= 0
			MsgStop("Atenção... O Saldo deste título esta zerado, Verifique ")
			SE1->(DBSKIP())
			LOOP
		ENDIF
		IF EMPTY(SE1->E1_NUMBCO)
			cBanco     := '341'
			cAgenc     := '0585'
			cConta     := '14677'
			_cNossoNum := xGerNossoNum(cBAnco,cAgenc,cConta,"109")
		eLSE
			_cNossoNum := SE1->E1_NUMBCO
			cBanco     := SE1->E1_PORTADO
			cAgenc     := SE1->E1_AGEDEP
			cConta     := SE1->E1_CONTA
		Endif
		//Posiciona o SA6 (Bancos)
		DbSelectArea("SA6")
		SA6->(DbSetOrder(1))   //A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON, R_E_C_N_O_, D_E_L_E_T_
		SA6->(DbSeek(xFilial("SA6")+cBAnco+PADR(cAgenc,5)+PADR(cConta,10),.T.))
		//    MsgStop("DANIEL - Achei BANCO .. -> "+SA6->A6_COD+'-'+A6_AGENCIA+' -' +A6_NUMCON)
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.))
		//
		DbSelectArea("SE1")
		//
		/*	aDadosBanco  := {"341"           											,;	// [1]Numero do Banco
		"Banco Itaú S.A."      								  		,;	// [2]Nome do Banco
		SUBSTR(SA6->A6_AGENCIA, 1, 4)                         		,;	// [3]Agência
		SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)	,;	// [4]Conta Corrente
		SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)		,;	// [5]Dígito da conta corrente
		"109"                  										}	// [6]Codigo da Carteira
		*/

		aDadosBanco  := {"341"           											,;	// [1]Numero do Banco
		"Banco Itaú S.A."      								  		,;	// [2]Nome do Banco
		SUBSTR(SA6->A6_AGENCIA, 1, 4)                         		,;	// [3]Agência
		AllTrim(SA6->A6_NUMCON)										,;	// [4]Conta Corrente
		AllTrim(SA6->A6_DVCTA)										,;	// [5]Dígito da conta corrente
		"109"                  										}	// [6]Codigo da Carteira

		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endereço
			AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
			SA1->A1_EST                                       ,;     // [5]Estado
			SA1->A1_CEP                                       ,;     // [6]CEP
			SA1->A1_CGC									  }       // [7]CGC
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
			AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
			SA1->A1_ESTC	                                      ,;   // [5]Estado
			SA1->A1_CEPC                                         ,;   // [6]CEP
			SA1->A1_CGC										   }    // [7]CGC
		Endif

		//If aMarked[i]
		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,ALLTRIM(SE1->E1_NUM),SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

		// Comentado Robson totalit 
		//CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(E1_VALOR-_nVlrAbat),Datavalida(E1_VENCTO,.T.))
		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(E1_VALOR-_nVlrAbat),E1_VENCREA)

		aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
		E1_EMISSAO                         	,;  // [2] Data da emissão do título
		dDataBase              				,;  // [3] Data da emissão do boleto
		E1_VENCREA                          ,;  // [4] Data do vencimento
		(E1_SALDO - _nVlrAbat)              ,;  // [5] Valor do título
		CB_RN_NN[3]                         ,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                          ,;  // [7] Prefixo da NF
		E1_TIPO	                           	,;  // [8] Tipo do Titulo
		E1_DESCFIN							,;  // [9] Desconto titulo
		E1_DECRESC                           }  // [10] Abatimento

		Impres2(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1

		dbSkip()
		IncProc()
		i := i + 1
	EndDo
next Z

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Impress      ³Descri‡ão³Impressao de Boleto Grafico do Banco³±±
±±³          ³             ³         ³Itau.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impres2(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL _nTxper    := GETMV("MV_TXPER")
LOCAL cParametro := GETMV("HP_BORAUTO")
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
LOCAL oBrush
//
aBmp 	:= "\System\ITAU.BMP"
aBmp2 	:= "\System\logo_itau.BMP"
//
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
//
oBrush := TBrush():New("",5)//4
//
oPrint:StartPage()   // Inicia uma nova página
//
/*oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)*/
//
// LOGOTIPO
If File(aBmp2)
	oPrint:SayBitmap( 0040,0100,aBmp2,0175,0100 )
Else
	oPrint:Say  (0084,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0084,1860,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Beneficiario"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Beneficiario"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Pagador"                                         ,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]                                    ,oFont10)	//Nome
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1085,DTOC(aDadosTit[4])      ,oFont10)
//oPrint:Say  (0300,1060,SubStr(DTOC(aDadosTit[4]),1,6)+SubStr(DTOC(aDadosTit[4]),7,2)       ,oFont10)
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))   ,oFont10)
if cFilant == "06" .or. cFilant == "18"
	oPrint:Say  (0370,0100,"Recebi(emos) o bloqueto/título com"  		,oFont10)
	oPrint:Say  (0410,0100,"as características acima."             		,oFont10)
	oPrint:Say  (0450,0100,"Favor devolver assinado juntamente"  		,oFont10)
	oPrint:Say  (0490,0100,"com o canhoto da Nota Fiscal." 				,oFont10)
else
	oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
	oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
endif
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)
//
oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 )
oPrint:Line (0550, 100,0550,2300 )
//
oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 )
oPrint:Line (0550,1900,0150,1900 )
//
oPrint:Say  (0165,1910,"(  ) Mudou-se"                                	,oFont8)
oPrint:Say  (0205,1910,"(  ) Ausente"                                    ,oFont8)
oPrint:Say  (0245,1910,"(  ) Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0285,1910,"(  ) Recusado"                                	,oFont8)
oPrint:Say  (0325,1910,"(  ) Não procurado"                              ,oFont8)
oPrint:Say  (0365,1910,"(  ) Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0405,1910,"(  ) Desconhecido"                            	,oFont8)
oPrint:Say  (0445,1910,"(  ) Falecido"                                   ,oFont8)
oPrint:Say  (0485,1910,"(  ) Outros(anotar no verso)"                  	,oFont8)
//
For i := 100 to 2300 step 50
	oPrint:Line( 0590, i, 0590, i+30)
Next i
//
oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)
//
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 0600,0100,aBmp,0100,0100 )
	oPrint:Say  (0640,240,"Banco Itaú SA",oFont10 )	// [2]Nome do Banco
Else
	oPrint:Say  (0644,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0618,569,"341-7",oFont24 )	// [1]Numero do Banco
oPrint:Say  (0644,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//
oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )
//
oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)
//
oPrint:Say  (0710,100 ,"Local de Pagamento"                          	,oFont8)
oPrint:Say  (0730,400 ,"Até o vencimento, preferencialmente no Itaú." 	,oFont9)
oPrint:Say  (0770,400 ,"Após o vencimento, somente no Itaú."        	,oFont9)
//
oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2025,DTOC(aDadosTit[4]) ,oFont10)
//oPrint:Say  (0750,2010,SubStr(DTOC(aDadosTit[4]),1,6)+"20"+SubStr(DTOC(aDadosTit[4]),7,2) ,oFont10)
//
oPrint:Say  (0810,100 ,"Beneficiario"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oPrint:Say  (0810,1910,"Agência/Código Beneficiario"                         ,oFont8)
oPrint:Say  (0850,2025,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
//
oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont10) //Prefixo +Numero+Parcela
//
oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)
//
oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao
//
oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)
oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)
//
oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)
//
oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)
//
oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)
//
oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
//
oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiario)",oFont8)

//comentado por Daisy em 01/07/2011 para imprimir instrução de Multa
If aDadosTit[9] > 0
	oPrint:Say  (1100,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[9]/100)*aDadosTit[5]),"@E 99,999.99"))       ,oFont10)
EndIf

//	oPrint:Say  (1150,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]/50)),"@E 99,999.99"))       ,oFont10)


//comentado por Daisy em 01/07/2011 pois esta calculando Mora Diária incorretamente
oPrint:Say  (1200,100 ,aBolText[3]+" "+AllTrim(Transform(((aDadosTit[5]*0.05/30)),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (1250,100 ,aBolText[4]                                        ,oFont10)

If aDadosTit[10] > 0
	oPrint:Say  (1300,100 ,aBolText[5]+" "+AllTrim(Transform(((aDadosTit[10])),"@E 99,999.99"))       ,oFont10)
EndIf


//
oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)
//
oPrint:Say  (1400,100 ,"Pagador"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
if Len(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (1589,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oPrint:Say  (1589,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif
oPrint:Say  (1589,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
//oPrint:Say  (1589,1850,Substr(_cNossoNum,1,8)								,oFont10)
//
oPrint:Say  (1605,100 ,"Pagador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (1645,1900,"Recibo do Pagador"								,oFont10)
//
oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )
//
For i := 100 to 2300 step 50
	oPrint:Line( 1930, i, 1930, i+30)                 // 1850
Next i
//
oPrint:Line (2080,100,2080,2300)                                                       //   2000
oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900
//
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 1970,0100,aBmp,0100,0100 )
	oPrint:Say  (2010,240,"Banco Itaú SA",oFont10 )	// [2]Nome do Banco
Else
	oPrint:Say  (2014,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934
EndIf
//
oPrint:Say  (1988,569,"341-7",oFont24 )	// [1]Numero do Banco                       1912
oPrint:Say  (2014,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//
oPrint:Line (2180,100,2180,2300 )
oPrint:Line (2280,100,2280,2300 )
oPrint:Line (2350,100,2350,2300 )
oPrint:Line (2420,100,2420,2300 )
//
oPrint:Line (2280, 500,2420,500)
oPrint:Line (2350, 750,2420,750)
oPrint:Line (2280,1000,2420,1000)
oPrint:Line (2280,1350,2350,1350)
oPrint:Line (2280,1550,2420,1550)
//
oPrint:Say  (2080,100 ,"Local de Pagamento"                      			,oFont8)
oPrint:Say  (2100,400 ,"Até o vencimento, preferencialmente no Itaú."		,oFont9)
oPrint:Say  (2140,400 ,"Após o vencimento, somente no Itaú."				,oFont9)
//

oPrint:Say  (2080,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2120,2025,DTOC(aDadosTit[4]) ,oFont10)
//oPrint:Say  (2120,2010,SubStr(DTOC(aDadosTit[4]),1,6)+SubStr(DTOC(aDadosTit[4]),7,2) ,oFont10)
//
oPrint:Say  (2180,100 ,"Beneficiario"                                        ,oFont8)
oPrint:Say  (2220,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oPrint:Say  (2180,1910,"Agência/Código Beneficiario"                         ,oFont8)
oPrint:Say  (2220,2015,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
//
oPrint:Say  (2280,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2310,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oPrint:Say  (2280,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2310,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont10) //Prefixo +Numero+Parcela
//
oPrint:Say  (2280,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2310,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oPrint:Say  (2280,1355,"Aceite"                                         ,oFont8)  // 2200
oPrint:Say  (2310,1455,"N"                                             ,oFont10)  // 2230
//
oPrint:Say  (2280,1555,"Data do Processamento"                          ,oFont8)       // 2200
oPrint:Say  (2310,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao  2230
//
oPrint:Say  (2280,1910,"Nosso Número"                                   ,oFont8)       // 2200
oPrint:Say  (2310,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)  // 2230
//oPrint:Say  (2310,2010,Substr(_cNossoNum,1,3)+"/"+Substr(_cNossoNum,4),oFont10)  // 2230
//oPrint:Say  (2310,2010,Substr(_cNossoNum,1,8)							,oFont10)  // 2230
oPrint:Say  (2350,100 ,"Uso do Banco"                                   ,oFont8)       // 2270
//
oPrint:Say  (2350,505 ,"Carteira"                                       ,oFont8)       // 2270
oPrint:Say  (2380,555 ,aDadosBanco[6]                                  	,oFont10)      //  2300
//
oPrint:Say  (2350,755 ,"Espécie"                                        ,oFont8)       //  2270
oPrint:Say  (2380,805 ,"R$"                                             ,oFont10)      //  2300
//
oPrint:Say  (2350,1005,"Quantidade"                                     ,oFont8)       //  2270
oPrint:Say  (2350,1555,"Valor"                                          ,oFont8)       //  2270
//
oPrint:Say  (2350,1910,"Valor do Documento"                          	,oFont8)        //  2270
oPrint:Say  (2380,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300
//
oPrint:Say  (2420,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiario)",oFont8) // 2340

//comentado por Daisy em 01/07/2011 para imprimir instrução de Multa
If aDadosTit[9] > 0
	oPrint:Say  (2470,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[9]/100)*aDadosTit[5]),"@E 99,999.99"))       ,oFont10)
EndIf
//	oPrint:Say  (2520,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]/50)),"@E 99,999.99"))       ,oFont10)
oPrint:Say  (2570,100 ,aBolText[3]+" "+AllTrim(Transform(((aDadosTit[5]*0.05/30)),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (2620,100 ,aBolText[4]                                        ,oFont10)
//oPrint:Say  (2570,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10)  // 2490  // *0.05)/30)
//oPrint:Say  (2620,100 ,aBolText[3]                                        ,oFont10)    //2540
//

If aDadosTit[10] > 0
	oPrint:Say  (2670,100 ,aBolText[5]+" "+AllTrim(Transform(((aDadosTit[10])),"@E 99,999.99"))       ,oFont10)
EndIf

oPrint:Say  (2420,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
oPrint:Say  (2490,1910,"(-)Outras Deduções"                             ,oFont8)      //  3410
oPrint:Say  (2560,1910,"(+)Mora/Multa"                                  ,oFont8)      //  2480
oPrint:Say  (2630,1910,"(+)Outros Acréscimos"                           ,oFont8)      //  2550
oPrint:Say  (2700,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620
//
oPrint:Say  (2770,100 ,"Pagador"                                         ,oFont8)
oPrint:Say  (2800,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2853,400 ,aDatSacado[3]                                    ,oFont10)       // 2773
oPrint:Say  (2906,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado  2826
IF LEN(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (2959,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
ELSE
	oPrint:Say  (2959,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF        2879
ENDIF
oPrint:Say  (2959,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)         //  2879
//oPrint:Say  (2959,1850,Substr(_cNossoNum,1,8)							,oFont10)         //  2879
//
oPrint:Say  (2975,100 ,"Pagador/Avalista"                               ,oFont8)
oPrint:Say  (3015,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (3015,1850,"Ficha de Compensação"                           ,oFont8)      // 2935 + 280      = 3215
//
oPrint:Line (2080,1900,2770,1900 )
oPrint:Line (2490,1900,2490,2300 )
oPrint:Line (2560,1900,2560,2300 )
oPrint:Line (2630,1900,2630,2300 )
oPrint:Line (2700,1900,2700,2300 )
oPrint:Line (2770,100 ,2770,2300 )
//
oPrint:Line (3010,100 ,3010,2300 )
//
MsBar("INT25"  ,nCB1Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
MsBar("INT25"  ,nCB2Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)

//
cParametro := GETMV("HP_BORAUTO")  //Numero do bordero automático atual
dData  := Ctod(SUBSTR(cParametro,8,10))      //000000,18/04/18

If Empty(SE1->E1_NUMBOR)

	if dData == date() //dDatabase
		cNBor:=  substr(cParametro,1,6)
	Else
		cNBor := Getmv("MV_NUMBORR")
		cNbor:= soma1(cNBor,6)
		_pcParametro:="HP_BORAUTO"
		dbSelectArea("SX6")
		SX6->(dbSetOrder(1))
		SX6->(dbGoTop())
		_pcParametro:=padr(_pcParametro,10)
		SX6->(dbSeek(xfilial("SX6")+_pcParametro))
		If SX6->(!Eof())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNbor+","+DTOC(dDatabase)
			SX6->X6_CONTENG := cNbor+","+DTOC(dDatabase)
			SX6->X6_CONTSPA := cNbor+","+DTOC(dDatabase)
			SX6->(MsUnLock())
		Endif
		dbSelectArea("SX6")
		SX6->(dbSetOrder(1))
		SX6->(dbGoTop())
		cParametro:= "MV_NUMBORR"
		cNbor_NV:=soma1(cNbor,6)
		cParametro:=padr(cParametro,10)
		SX6->(dbSeek(xfilial("SX6")+cParametro))
		If SX6->(!Eof())
			SX6->(RecLock("SX6",.F.))
			SX6->X6_CONTEUD := cNbor_NV
			SX6->X6_CONTENG := cNbor_NV
			SX6->X6_CONTSPA := cNbor_NV
			SX6->(MsUnLock())
		Endif
		//Env_Fin(dDatabase) //Comentado por Robson, erro no email do bordero trazia titulos inexistentes naquele bordero
		dDtPar:= date()
		Env_Fin(dDtPar)
	Endif

	DbSelectArea("SE1")
	If empty(SE1->E1_NUMBOR)
		DbSelectArea("SEA")
		SEA->(RecLock("SEA",.T.))
		SEA->EA_FILIAL   := XFilial("SEA")
		SEA->EA_PREFIXO  := SE1->E1_PREFIXO
		SEA->EA_NUM      := SE1->E1_NUM
		SEA->EA_PARCELA  := SE1->E1_PARCELA
		SEA->EA_PORTADO  := cBanco
		SEA->EA_AGEDEP   := cAgenc
		SEA->EA_NUMBOR   := cNBor
		SEA->EA_DATABOR  := DDATABASE
		SEA->EA_TIPO     := SE1->E1_TIPO
		SEA->EA_CART     := 'R'
		SEA->EA_NUMCON   := cConta
		SEA->EA_SITUACA  := '1'
		SEA->EA_SITUANT  := '0'
		SEA->EA_FILORIG  := XFilial("SEA")
		SEA->EA_ORIGEM   := 'AUTOMATI'
		SEA->(MsUnlock())
		DbSelectArea("SE1")
		//ATUALIZA SE1 COM DADOS BANCARIOS
		SE1->(RecLock("SE1",.F.))
		SE1->E1_PORTADO	 := cBanco
		SE1->E1_AGEDEP	 := cAgenc
		SE1->E1_MOVIMENT := DDATABASE
		SE1->E1_SITUACA	 := '1'
		SE1->E1_CONTA	 := cConta
		SE1->E1_NUMBCO   :=	STRZERO(VAL(_cNossoNum),8)
		SE1->E1_NUMBOR	 := cNBor
		SE1->E1_DATABOR	 := DDATABASE
		SE1->(MsUnlock())
	Endif
Endif
////U_GerBord() //somente para acertos iniciais em 20/04/18

//
oPrint:EndPage() // Finaliza a página
	//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
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
Return(D)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
±±³          ³             ³         ³gerando o codigo de barras.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
	//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero((nValor*100),10) //strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "109" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
// RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))   alterado por Daisy em 26/10/11 pois estava gerando valor com 0,01 centavo a menor
RN   := RN + _cfator + StrZero((nValor * 100),14-Len(_cfator))
//
Return({CB,RN,NN})
//


//*****************************************************
// Função que gera e retorna o nosso numero.
//*****************************************************
Static Function xGerNossoNum(_cBanco, _cAgencia, _cConta, _cSubCta)
Local _cNumero:= ""
Local _lAbort := .F.
dbSelectArea("SEE")
SEE->( dbSeek(xfilial("SEE")+padr(_cBanco,3)+padr(_cAgencia,5)+padr(_cConta,10)+_cSubCta) )
If ! Found()
	Help(" ",1,"PAR150")
	_lAbort := .T.
Else
	If int(Val(EE_FAXFIM))-Int(Val(EE_FAXATU)) == 0
		Alert("A faixa de geração do nosso número se esgotou. Faça o ajuste pelo cadastro dos paramentros do banco.")
		_lAbort := .T.
	Endif
Endif

IF ! _lAbort
	// Trava o SEE, soma 1 na faixa atual e pega para o nosso nro.
	RecLock("SEE",.f.)
	SEE->EE_FAXATU := alltrim(str(val(SEE->EE_FAXATU)+1))
	MsUnlock()

	_cNumero:=Alltrim(SEE->EE_FAXATU)
Endif

Return(_cNumero)


Static function Env_Fin(dData)
Local  aArea   := GetArea()
Local cServer  := Rtrim(SuperGetMv("MV_RELSERV"))
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
Local cFrom    := cConta
Local _cEmail  := GetMV("HP_MAILFIN")
Local _ccEmai  := GetMV("HP_CMAILFI")
Local cTitIni  := ''
Local cTitFin  := ''
Local cNumbor  := ''
DbSelectArea("SE1")
SE1->(DbSetOrder(1))
SE1->(DbGotop())
lFaz := .t.
nDia := 1
N:= 0
while lFaz
	N++
	dData := dData-nDia
	cQuery := "SELECT * FROM "+RETSQLNAME("SEA")+" EA WHERE EA_DATABOR = '"+DTOS(dData)+"' AND EA_ORIGEM = 'AUTOMATI' order by EA_NUM "
	IF Select("XTRB") > 0
		XTRB->(dbCloseArea())
	Endif
	TCQUERY cQuery NEW ALIAS xTRB
	XTRB->(DBGOTOP())
	cNumbor := xTRB->EA_NUMBOR
	If XTRB->(!EOF())
		lFaz := .f.
		XTRB->(DbGotop())
		cTitIni := xTRB->EA_NUM
		while XTRB->(!eof())
			cTitFin := xTRB->EA_NUM
			XTRB->(dbSkip())
		Enddo
	Endif
	if !lFaz .OR. N > 10
		exit
	Endif
Enddo


//_cNome       :=  'Daniel  -  Error ' //POSICIONE("SA3", 1, xFilial("SA3")+SUA->UA_VEND  , "A3_NOME"  )
//_cEmail      :=  'daniel.souza@hopelingerie.com.br' // 'dayse.monti@hopelingerie.com.br'  //POSICIONE("SA3", 1, xFilial("SA3")+SUA->UA_VEND  , "A3_EMAIL" )
cBoas:= Iif(time()>= '12:00;00','Boa Tarde','Bom Dia ' )
cTexto := "<html>"
cTexto += "<head>"
cTexto += " <title></title>"
cTexto += "</head>"
cTexto += "<body>"
cTexto += " <br>"
cTexto += '<font color="#000000" face="Arial">'
cTexto += " <br>"
cTexto += " <br>"
cTexto += "      "+ cBoas+"!,   <br><br>"
cTexto += "      Segue abaixo, o último borderô automatíco, finalizado e aguardando envio ao Banco :   <br><br>"
cTexto += '<font color="#FF0000" face="Arial">'
cTexto += '<font color="#000000" face="Arial">'
cTexto += "      Numero do Borderô Disponível :=  "+cNumbor+".  <br><br>"
cTexto += "      Número do Primeiro título := "+cTitIni+".  <br><br>"
cTexto += "       <br><br>"
cTexto += "      Número do Ultimo   título := "+cTitFin+".  <br><br>"
cTexto += '<font color="#FF0000" face="Arial">'
cTexto += '<font color="#000000" face="Arial">'
cTexto += "       <br><br>"
cTexto += "Atenção! <br><br>"
cTexto += "       <br><br>"
cTexto += "       <br><br>"
cTexto += "       <br><br>"
cTexto += "HOPE DO Nordeste Ltda.  <br>"
cTexto += "    Não responder este e-mail  <br>"
cTexto += "    Envio Automático  <br>"
cTexto += "   Qualquer dúvida, acione 0 TI atraves de abertura de Chamado   <br>"
cTexto += "       <br><br>"
cTexto += "   https://helpdeskhope/glpi/index.php?noAUTO=1   <br>"
cTexto += "</body>"
cTexto += "</html>"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// msgstop('Irei enviar e-mail!')
aAtachar := ''
cTo := _cEmail // "daniel.souza@terra.com.br"
oMail := TMailManager():New()
oMail:SetUseSSL(.F.) //.t.
oMail:SetUseTLS(.T.) ////Add autenticação abaixo após troca de servidor de e-mail (office365) - Marcio Frade 2019/03/18.
x_smtp:= substr(Alltrim(GetMv("MV_WFSMTP")),1,len(alltrim(GetMv("MV_WFSMTP"))) )
oMail:Init( '', x_smtp,Alltrim(GetMv("MV_RELACNT")),Alltrim(GetMv("MV_RELPSW")), 0, 587 )   //465
oMail:SetSmtpTimeOut( 120 )
nErro := oMail:SmtpConnect()
If nErro <> 0
	conout( "ERROR: Conectando - " + oMail:GetErrorString( nErro ) )
	oMail:SMTPDisconnect()
	Iif(len(cProc)<> 0,cProc:= "Sem Conexao SMTP  ",cProc:=cProc )
Endif
nErro := oMail:SmtpAuth(Alltrim(GetMv("MV_RELACNT")) ,Alltrim(GetMv("MV_RELPSW")))
If nErro <> 0
	conout( "ERROR:2 autenticando - " + oMail:GetErrorString( nErro ) )
	oMail:SMTPDisconnect()
	Iif(len(cProc)<> 0,cProc:= "Sem Autenticacao no E-mail  " ,cProc:=cProc )
Endif
oMessage := TMailMessage():New()
oMessage:Clear()
oMessage:cFrom 		    := Alltrim(GetMv("MV_RELACNT"))
oMessage:cTo	 		:= cTo
oMessage:cCc 			:= _ccEmai
oMessage:cSubject    	:=  "BORDERO AUTOMATICO -  EMISSAO DE BOLETO PELO FATURAMENTO "
oMessage:cBody 	    	:= cTexto
oMessage:MsgBodyType( "text/html" )
//	 If oMessage:AttachFile(cAnexos ) < 0
//		Conout( "Erro ao atachar o arquivo" )
//	  	Iif(len(cProc)<> 0,cProc:= "Sem anexos  " ,cProc:=cProc )
//	 Else
//	    oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=' + cNomNovArq)
//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=' + cNomNovAr1)
//	 EndIf
nErro := oMessage:Send( oMail )
oMail:SMTPDisconnect()

If nErro == 0
	Conout( " E-mail ENVIADO COM SUCESSO" )
	lRet := .T.
Else
	Conout( "Erro ao enviar e-mail" )
	lRet := .F.
Endif

RestArea(aArea)
Return Nil

