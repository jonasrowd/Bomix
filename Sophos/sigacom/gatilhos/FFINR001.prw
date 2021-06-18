#include "rwmake.ch"     
#include "protheus.ch"     
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'   

/*/
Programa : FFINR001 
Autor    : Eliene Cerqueira     
Data     : 13/09/12 
Descricao: IMPRESSAO DE BOLETO PARA ITAU                             
Uso      : Financeiro                                          
/*/

User Function FFINR001()

LOCAL   aCampos := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
                    {"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCREA","Vencimento"}}
LOCAL   nOpc := 0
LOCAL   aMarked := {}
Local _stru:={}
Local aCpoBro := {}
Local aCores := {}
Local n_Clic:= 0
Private lInverte := .F.
Private cMark   := GetMark()   
Private oMark 
PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

cPerg  :="FFINR001"
CriaPerg()

If !Pergunte(cPerg,.T.)
	Return()
EndIf

/*
cIndexName := Criatrab(Nil,.F.)
cIndexKey  := 	"E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter    := 	"E1_VENCTO >= CTOD('" + DTOC(MV_PAR05) + "') .And. E1_VENCTO <= CTOD('" + DTOC(MV_PAR06) + "') .And. " + ;
				"E1_CLIENTE >= '" + MV_PAR07 + "' .And. E1_CLIENTE <= '" + MV_PAR08 + "' .And. " + ;
				"E1_FILIAL   = '"+xFilial()+"' .And. E1_SALDO > 0 .And. " + ;
				"SubsTring(E1_TIPO,3,1) != '-'"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Impressao Boleto Itau"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK" 	 	
@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec:=.T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec:=.F.,Close(oDlg))

ACTIVATE DIALOG oDlg CENTERED
*/
c_QRY := "SELECT * FROM "+RETSQLNAME("SE1")+" WHERE "
c_QRY += "E1_VENCTO >= '" + DTOS(MV_PAR05) + "' And E1_VENCTO <= '" + DTOS(MV_PAR06) + "' And "
c_QRY += "E1_CLIENTE >= '" + MV_PAR07 + "' And E1_CLIENTE <= '" + MV_PAR08 + "' And "
c_QRY += "E1_FILIAL   = '"+xFilial()+"' And E1_SALDO > 0 And "
c_QRY += "E1_NUM BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
c_QRY += "AND SubsTring(E1_TIPO,3,1) != '-'"

TcQuery c_QRY New Alias 'TRB'

DbSelectArea("TRB")

AADD(_stru,{"OK"     	,"C"	,2		,0		})
AADD(_stru,{"E1_PREFIXO"   ,"C"	,3		,0		})
AADD(_stru,{"E1_NUM"   	,"C"	,9		,0		})
AADD(_stru,{"E1_TIPO"   	,"C"	,3		,0		})
AADD(_stru,{"E1_CLIENTE"	,"C"	,6		,2		})
AADD(_stru,{"E1_LOJA"    	,"C"	,2		,0		})
AADD(_stru,{"E1_VALOR" 	,"N"	,17		,2		})
AADD(_stru,{"E1_VENCREA" 	,"D"	,8		,0		})
AADD(_stru,{"E1_NUMBOR" 	,"C"	,6		,0		})
AADD(_stru,{"E1_PORTADO" 	,"C"	,8		,0		})
AADD(_stru,{"E1_AGEDEP" 	,"C"	,8		,0		})
AADD(_stru,{"E1_CONTA" 	,"C"	,8		,0		})
AADD(_stru,{"E1_PARCELA" 	,"C"	,3		,0		})
AADD(_stru,{"E1_SITUACA" 	,"C"	,4		,0		})
AADD(_stru,{"E1_SALDO" 	,"N"	,17		,2		})
AADD(_stru,{"E1_EMISSAO" 	,"D"	,8		,0		})
AADD(_stru,{"E1_NUMBCO" 	,"C"	,17		,0		})

cArq:=Criatrab(_stru,.T.)
DBUSEAREA(.t.,,carq,"TTRB")

//#IFNDEF TOP
//	DbSetIndex(cIndexName + OrdBagExt())
//#ENDIF
DBSELECTAREA("TRB")
TRB->(dbGoTop())

While  TRB->(!Eof())
	DbSelectArea("TTRB")
	RecLock("TTRB",.T.)
	TTRB->E1_PREFIXO     :=  TRB->E1_PREFIXO
	TTRB->E1_NUM    	  :=  TRB->E1_NUM
	TTRB->E1_TIPO    	  :=  TRB->E1_TIPO
	TTRB->E1_CLIENTE     :=  TRB->E1_CLIENTE
	TTRB->E1_LOJA	      :=  TRB->E1_LOJA
	TTRB->E1_VALOR       :=  TRB->E1_VALOR
	TTRB->E1_VENCREA      :=  stod(TRB->E1_VENCREA)
	TTRB->E1_NUMBOR	  :=  TRB->E1_NUMBOR
	TTRB->E1_PORTADO     :=  TRB->E1_PORTADO
	TTRB->E1_AGEDEP      :=  TRB->E1_AGEDEP
	TTRB->E1_CONTA	      :=  TRB->E1_CONTA
	TTRB->E1_PARCELA     :=  TRB->E1_PARCELA
	TTRB->E1_SITUACA	  :=  TRB->E1_SITUACA
	TTRB->E1_SALDO       :=  TRB->E1_SALDO
	TTRB->E1_EMISSAO     :=  STOD(TRB->E1_EMISSAO)
	TTRB->E1_NUMBCO	  :=  TRB->E1_NUMBCO
	MsunLock()
	TRB->(DbSkip())
Enddo

DBSELECTAREA("TRB")
TRB->(DBCLOSEAREA())

aCpoBro	:= {{ "OK"			,, " "           ,"@!"},;
			{ "E1_PREFIXO"		,, "Prefixo"   				,"@!"},;
			{ "E1_NUM"		    ,, "Numero"    				,"@!"},;
			{ "E1_TIPO"		,, "Tipo"      				,"@X"},;
			{ "E1_CLIENTE"		,, "Cliente"   				,"@!"},;
			{ "E1_VALOR"		,, "Valor"     				,"@E 999,999,999.99"},;
			{ "E1_VENCREA"		,, "Vencimento"           	,"@!"},;
			{ "E1_NUMBOR"		,, "Bordero"           		,"@!"}}
			
DEFINE MSDIALOG oDlg TITLE "Titulos" From 9,0 To 315,800 PIXEL
DbSelectArea("TTRB")
TTRB->(DbGotop())

oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,400},,,,,)
oMark:bMark := {|| Disp()} 
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| n_Clic:= 1, oDlg:End()},{|| n_Clic:= 2, oDlg:End()})

IF n_Clic = 1
	TTRB->(dbGoTop())
	While TTRB->(!Eof())
		If TTRB->OK = cMark
			AADD(aMarked,.T.)
		Else
			AADD(aMarked,.F.)
		EndIf
		TTRB->(dbSkip())
	EndDo

	dbGoTop()

	//IF Exec
		Processa({|lEnd|MontaRel(aMarked)})
	//EndIF

ENDIF

DBSELECTAREA("TTRB")
DBCLOSEAREA("TTRB")

//RetIndex("SE1")
//fErase(cIndexName+OrdBagExt())

Return Nil     

Static Function Disp()
RecLock("TTRB",.F.)
If Marked("OK")
	TTRB->OK := cMark
Else
	TTRB->OK := ""
Endif
MSUNLOCK()
oMark:oBrowse:Refresh()
Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³                       ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aMarked)
LOCAL   oPrint
LOCAL   n := 0   
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                                             ,; //[1]Nome da Empresa
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
LOCAL aBolText     := {"Valor por dia de atraso de  "                ,;
                       "PAGAMENTO EXCLUSIVAMENTE VIA BOLETO BANCARIO",;
                       "TITULO SUJEITO A PROTESTO APÓS 10 DIAS DO VENCIMENTO",;
                       "O NÃO PAGAMENTO DESTE BOLETO IMPLICA EM NÃO IDENTIFICAÇÃO DO CRÉDITO",;
                       "",;
                       ""}

Local nMulta       := 4
LOCAL nMark        := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0

//Posiciona o SA6 (Bancos)
DbSelectArea("SA6")
DbSetOrder(1)
If	!DbSeek(xFilial("SA6")+MV_PAR01+MV_PAR02+MV_PAR03,.T.)
	Msgbox("Banco/agencia/conta não localizado!")
	Return
Endif
	
//Posiciona na Arq de Parametros CNAB
DbSelectArea("SEE")
DbSetOrder(1)
If	!DbSeek(xFilial("SEE")+MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04,.T.)                  
	Msgbox("Parametros de banco não localizado!")
	Return
Endif

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:Setup()
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

DbSelectArea("TTRB")
TTRB->(dbGoTop())
While TTRB->(!EOF())
	nRec := nRec + 1
	TTRB->(dbSkip())
EndDo
dbGoTop()       

ProcRegua(nRec)
			
Do While TTRB->(!EOF())

	If TTRB->OK = cMark
    	If	Empty(TTRB->E1_NUMBCO) .or. MV_PAR09 = 1
			cBco    := MV_PAR01
			cAge    := MV_PAR02
			cConta  := MV_PAR03
			cCart   := "109"
			
			RecLock("SEE",.F.)
			  SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,8)
			MsUnlock()            
			
			cNroDoc:=cCart+Strzero(Val(SEE->EE_FAXATU),8)
			
			cNros := ALLTRIM(cAge)+ALLTRIM(cConta)+Alltrim(cNroDoc)
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
			      
			DbSelectArea("SE1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SE1")+TTRB->PREFIXO+TTRB->NUM+TTRB->PARCELA+TTRB->TIPO)
			RecLock("SE1",.F.)
			   SE1->E1_NUMBCO:=cNroDoc+cNroDV
			MsUnlock()
		  	_cCart		:= cCart
		  	_cNossoNum  := Substr(cNroDoc,4,8)
	  		_cNroDV     := cNroDV
    	Else
		  	_cCart		:= If(!Empty(TTRB->E1_NUMBCO),Substr(TTRB->E1_NUMBCO,1,3),'109')
		  	_cNossoNum  := Substr(TTRB->E1_NUMBCO,4,8)
	  		_cNroDV     := Substr(TTRB->E1_NUMBCO,12,1)
	  	Endif
	    DBSELECTAREA("TTRB")
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+TTRB->E1_CLIENTE+TTRB->E1_LOJA,.T.)
		
		DbSelectArea("TTRB")
		aDadosBanco  := {Alltrim(SA6->A6_COD)           		                ,; // [1]Numero do Banco
	   	            	 SA6->A6_NOME      	            	                    ,; // [2]Nome do Banco
	    	             SUBSTR(SA6->A6_AGENCIA, 1, 4)                          ,; // [3]Agência
	        	         Subs(SA6->A6_NUMCON,1,5)    							,; // [4]Conta Corrente Itau
	            	     SA6->A6_DVCTA                                          ,; // [5]Dígito da conta corrente
	                	 _cCart                                            		 } // [6]Codigo da Carteira
	
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Razão Social
			                 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
			                 AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endereço
			                 AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
			                 SA1->A1_EST                                       ,;     // [5]Estado
			                 SA1->A1_CEP                                       ,;     // [6]CEP
			                 SA1->A1_CGC									   ,;     // [7]CGC
			                 SA1->A1_PESSOA									  }       // [8]CGC
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Razão Social
			                 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
			                 AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
			                 AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
			                 SA1->A1_ESTC	                                      ,;   // [5]Estado
			                 SA1->A1_CEPC                                         ,;   // [6]CEP
			                 SA1->A1_CGC									   ,;     // [7]CGC
			                 SA1->A1_PESSOA									  }       // [8]CGC
		Endif
	
	Endif
	If TTRB->OK = cMark	
       _nVlrAbat   :=  SomaAbat(TTRB->E1_PREFIXO,TTRB->E1_NUM,TTRB->E1_PARCELA,"R",1,,TTRB->E1_CLIENTE,TTRB->E1_LOJA)
	
	   CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),TTRB->E1_SALDO,Datavalida(TTRB->E1_VENCREA,.T.))
	
	   aDadosTit    := {AllTrim(TTRB->NUM)+AllTrim(TTRB->PARCELA)							,;  // [1] Número do título
	                    TTRB->E1_EMISSAO                              					,;  // [2] Data da emissão do título
	                    Date()                                  					,;  // [3] Data da emissão do boleto
	                    Datavalida(TTRB->VENCREA,.T.)                 					,;  // [4] Data do vencimento
	                    (TTRB->SALDO)   				               					,;  // [5] Valor do título
	                    CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
	                    TTRB->PREFIXO                               					,;  // [7] Prefixo da NF
	                    TTRB->TIPO	                               						}  // [8] Tipo do Titulo
	  			 
	   Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,nMulta)
	   n := n + 1
    EndIf                  
	
	DbSelectArea("TTRB")
	TTRB->(dbSkip())
	IncProc()
	nMark++
EndDo
            
//oPrint:Print()
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³                       ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,nMulta)
LOCAL _nTxper := GETMV("MV_TXPER")
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
LOCAL aCoords1 := {0210,1900,0300,2300}
LOCAL aCoords2 := {0480,1900,0500,2300}
LOCAL aCoords3 := {0830,1900,0900,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2280,1900,2380,2300}     // 2000 - 2100
LOCAL aCoords7 := {2550,1900,2620,2300}     // 2270 - 2340
LOCAL aCoords8 := {2900,1900,2970,2300}     // 2620 - 2690
LOCAL oBrush                 
      
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)    

oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
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

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

nRow1 := 150
oPrint:Say  (nRow1+0025,100,"ITAU",oFont21 )
//oPrint:SayBitmap( 0200,0100,aBmp,0400,0100 )

oPrint:Line (nRow1+0020,500,nRow1+0100, 500)
oPrint:Line (nRow1+0020,710,nRow1+0100, 710)

oPrint:Say  (nRow1+0025,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0034,1880,"Recibo do Sacado",oFont14n)

oPrint:Line (nRow1+100,100,nRow1+100,2300 )
oPrint:Line (nRow1+200,100,nRow1+200,2300 )
oPrint:Line (nRow1+300,100,nRow1+300,2300 )
oPrint:Line (nRow1+370,100,nRow1+370,2300 )
oPrint:Line (nRow1+440,100,nRow1+440,2300 )
oPrint:Line (nRow1+790,100,nRow1+790,2300 )

oPrint:Line (nRow1+100,1800,nRow1+790,1800)
oPrint:Line (nRow1+300,500 ,nRow1+440,500 )
oPrint:Line (nRow1+370,750 ,nRow1+440,750 )
oPrint:Line (nRow1+300,1000,nRow1+440,1000)
oPrint:Line (nRow1+300,1300,nRow1+370,1300)
oPrint:Line (nRow1+300,1480,nRow1+440,1480)


oPrint:Say  (nRow1+100,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow1+140,100 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO",oFont10)
//oPrint:Say  (nRow1+2055,400 ,"",oFont10)

oPrint:Say  (nRow1+100,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	:= 1850+(374-(len(cString)*22))
oPrint:Say  (nRow1+140,nCol,cString,oFont11c)

oPrint:Say  (nRow1+200,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+240,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow1+200,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])

nCol 	 := 1850+(374-(len(cString)*22))
oPrint:Say  (nRow1+240,nCol,cString ,oFont11c)

oPrint:Say  (nRow1+300,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow1+330,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow1+300,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow1+330,605 ,aDadosTit[7]+"-"+substr(aDadosTit[1],1,9)+" "+substr(aDadosTit[1],10,2) ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+300,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow1+330,1050,"DS",oFont10) //Tipo do Titulo

oPrint:Say  (nRow1+300,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow1+330,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow1+300,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow1+330,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow1+300,1810,"Nosso Número"                                   ,oFont8)
cString := Alltrim(aDadosTit[6])
nCol 	 := 1830+(374-(len(cString)*22))
oPrint:Say  (nRow1+330,nCol,cString,oFont11c)

oPrint:Say  (nRow1+370,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow1+370,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow1+400,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (nRow1+370,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow1+400,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow1+370,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow1+370,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow1+370,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1850+(374-(len(cString)*22))
oPrint:Say  (nRow1+400,nCol,cString,oFont11c)

oPrint:Say  (nRow1+440,100 ,"Instruções (Texodas to de responsabilidade exclusiva do cedente)",oFont8)

nVlrMul := (aDadosTit[5] * nMulta / 100) / 30
oPrint:Say  (nRow1+490,100 ,Alltrim(aBolText[1])+" R$ "+Alltrim(Transform(nVlrMul,"@E 99,999,999.99")),oFont10)
oPrint:Say  (nRow1+540,100 ,aBolText[2],oFont10)
oPrint:Say  (nRow1+590,100 ,aBolText[3],oFont10)
oPrint:Say  (nRow1+640,100 ,aBolText[4],oFont10)
oPrint:Say  (nRow1+690,100 ,aBolText[5],oFont10)
oPrint:Say  (nRow1+740,100 ,aBolText[6],oFont10)

oPrint:Line (nRow1+510,1800 ,nRow1+510,2300 )
oPrint:Line (nRow1+580,1800 ,nRow1+580,2300 )
oPrint:Line (nRow1+650,1800 ,nRow1+650,2300 )
oPrint:Line (nRow1+720,1800 ,nRow1+720,2300 )

oPrint:Say  (nRow1+440,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow1+510,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow1+580,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow1+650,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow1+720,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow1+790,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow1+800,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow1+800,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow1+800,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow1+853,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow1+906,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow1+906,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

//oPrint:Say  (nRow1+955,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow1+955,2000,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow1+955,100 ,nRow1+955,2300 )

/*
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)
oPrint:Line (nRow1+0150,1800,nRow1+0450,1800 )

oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	:= 1850+(374-(len(cString)*22))
oPrint:Say  (nRow1+200,nCol,cString,oFont11c)

oPrint:Line (nRow1+0250, 100,nRow1+0250,2300)
oPrint:Line (nRow1+0250, 710,nRow1+0450, 710)
oPrint:Line (nRow1+0250,1300,nRow1+0450,1300)

oPrint:Say  (nRow1+0250,100,"Nosso Número",oFont8)
oPrint:Say  (nRow1+0300,100,Alltrim(aDadosTit[6]),oFont11c)

oPrint:Say  (nRow1+0250,720,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0300,720,aDadosTit[7]+"-"+substr(aDadosTit[1],1,9)+" "+substr(aDadosTit[1],10,2),oFont11c) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0250,1310,"Data do Documento",oFont8)
oPrint:Say  (nRow1+0300,1310,DTOC(aDadosTit[2]),oFont11c)

oPrint:Say  (nRow1+0250,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1850+(374-(len(cString)*22))
oPrint:Say  (nRow1+300,nCol,cString ,oFont11c)

oPrint:Line (nRow1+0350, 100,nRow1+0350,2300 )

oPrint:Say  (nRow1+0350,100,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0400,100,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont11c)

oPrint:Say  (nRow1+0350,720,"(-) Deduções",oFont8)

oPrint:Say  (nRow1+0350,1310,"(+) Acréscimo",oFont8)

oPrint:Say  (nRow1+0350,1900,"(=) Valor Cobrado",oFont8)

oPrint:Line (nRow1+0450, 100,nRow1+0450,2300 )

oPrint:Say  (nRow1+0450,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0500,100 ,aDatSacado[1],oFont10)				//Nome
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Say  (nRow1+550,2000,"Autenticação Mecânica",oFont8)
*/

/******************/
/* SEGUNDA PARTE  */
/******************/

For nI := 100 to 2300 step 50
	oPrint:Line(1800, nI, 1800, nI+30)
Next nI

nRow2 := 1900

//oPrint:SayBitmap( nRow2,0100,aBmp,0400,0100 )
oPrint:Say  (nRow2+25,100,"ITAU",oFont21 )

oPrint:Line (nRow2+20,500,nRow2+100, 500)
oPrint:Line (nRow2+20,710,nRow2+100, 710)

oPrint:Say  (nRow2+25,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
oPrint:Say  (nRow2+34,745,CB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow2+100,100,nRow2+100,2300 )
oPrint:Line (nRow2+200,100,nRow2+200,2300 )
oPrint:Line (nRow2+300,100,nRow2+300,2300 )
oPrint:Line (nRow2+370,100,nRow2+370,2300 )
oPrint:Line (nRow2+440,100,nRow2+440,2300 )
oPrint:Line (nRow2+790,100,nRow2+790,2300 )

oPrint:Line (nRow2+100,1800,nRow2+790,1800)
oPrint:Line (nRow2+300,500 ,nRow2+440,500 )
oPrint:Line (nRow2+370,750 ,nRow2+440,750 )
oPrint:Line (nRow2+300,1000,nRow2+440,1000)
oPrint:Line (nRow2+300,1300,nRow2+370,1300)
oPrint:Line (nRow2+300,1480,nRow2+440,1480)


oPrint:Say  (nRow2+100,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+140,100 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO",oFont10)
//oPrint:Say  (nRow2+2055,400 ,"",oFont10)

oPrint:Say  (nRow2+100,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	:= 1850+(374-(len(cString)*22))
oPrint:Say  (nRow2+140,nCol,cString,oFont11c)

oPrint:Say  (nRow2+200,100 ,"Cedente",oFont8)
oPrint:Say  (nRow2+240,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+200,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])

nCol 	 := 1850+(374-(len(cString)*22))
oPrint:Say  (nRow2+240,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+300,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow2+330,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow2+300,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+330,605 ,aDadosTit[7]+"-"+substr(aDadosTit[1],1,9)+" "+substr(aDadosTit[1],10,2) ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+300,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+330,1050,"DS",oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+300,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+330,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+300,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+330,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow2+300,1810,"Nosso Número"                                   ,oFont8)
cString := Alltrim(aDadosTit[6])
nCol 	 := 1830+(374-(len(cString)*22))
oPrint:Say  (nRow2+330,nCol,cString,oFont11c)

oPrint:Say  (nRow2+370,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+370,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+400,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (nRow2+370,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+400,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+370,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+370,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+370,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1850+(374-(len(cString)*22))
oPrint:Say  (nRow2+400,nCol,cString,oFont11c)

oPrint:Say  (nRow2+440,100 ,"Instruções (Texodas to de responsabilidade exclusiva do cedente)",oFont8)

nVlrMul := (aDadosTit[5] * nMulta / 100) / 30
oPrint:Say  (nRow2+490,100 ,Alltrim(aBolText[1])+" R$ "+Alltrim(Transform(nVlrMul,"@E 99,999,999.99")),oFont10)
oPrint:Say  (nRow2+540,100 ,aBolText[2],oFont10)
oPrint:Say  (nRow2+590,100 ,aBolText[3],oFont10)
oPrint:Say  (nRow2+640,100 ,aBolText[4],oFont10)
oPrint:Say  (nRow2+690,100 ,aBolText[5],oFont10)
oPrint:Say  (nRow2+740,100 ,aBolText[6],oFont10)

oPrint:Line (nRow2+510,1800 ,nRow2+510,2300 )
oPrint:Line (nRow2+580,1800 ,nRow2+580,2300 )
oPrint:Line (nRow2+650,1800 ,nRow2+650,2300 )
oPrint:Line (nRow2+720,1800 ,nRow2+720,2300 )

oPrint:Say  (nRow2+440,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+510,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow2+580,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+650,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow2+720,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+790,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+800,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+800,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+800,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+853,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+906,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow2+906,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow2+955,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow2+955,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow2+955,100 ,nRow2+955,2300 )

//MsBar("INT25",28,2,CB_RN_NN[1],oPrint,.F.,,,0.028,1.3,,,,.F.)   	    // folha A4 - driver windows 2000 server
MsBar("INT25",25,1,CB_RN_NN[1],oPrint,.F.,,,0.028,1.3,,,,.F.)   	    // folha A4 - driver windows 2000 server

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³                       ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³                       ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³                       ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL blvalorfinal := strzero(int(nValor*100),10)

NN   := _cCart + cNroDoc + '-' + _cNroDV
	
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + '9' + _cfator + blvalorfinal + _cCart + cNroDoc + _cNroDV + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
	
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

s    := cBanco + '9' + _cCart + SubStr(cNroDoc,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + ' '

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

s    := SubStr(cNroDoc, 3, 6) + _cNroDV + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + ' '

// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + ' '

// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + ' '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))

Return({CB,RN,NN})

************************
Static Function CriaPerg
************************
Local _sAlias := Alias()
Local aRegs   := {}
Local i
Local j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Banco ?         ","","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
aAdd(aRegs,{cPerg,"02","Agencia ?       ","","","mv_ch2","C",05,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Conta ?         ","","","mv_ch3","C",10,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","SubConta ?      ","","","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Vencimento ? ","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate Vencimento ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Do Cliente ?    ","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"08","Ate o Cliente ? ","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"09","Gera N.Numero ? ","","","mv_ch9","N",01,0,2,"C","","mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Do Numero ?     ","","","mv_cha","C",09,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Do Numero ?     ","","","mv_chb","C",09,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to Len(aRegs[i])
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next