#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
/*******************************************************************************************************/
/*** Descricao : Rotina para emissao de etiquetas apartir das ordens de produção                     ***/
/*** Programa  : EST_010            		                          								 ***/
/*** Criado em : 20/10/2009                 					      								 ***/
/*** Autor     : TBA092 - Eliene Cerqueira         													 ***/
/*******************************************************************************************************/

User Function EST_010()                              
Local oDlg
Private cCadastro	:= "Emissão de Etiquetas"
Private aCores:= {{"NUMETIQ < NUMMAX .AND. TIPOETQ <> '3'"	,'ENABLE'}, ; // Impressão Etiqueta 100 x 50
			      {"NUMETIQ < NUMMAX .AND. TIPOETQ = '3'"	,'BR_AZUL'},; // Impressão Etiqueta 102 x 85
			      {"NUMETIQ >= NUMMAX"	,'BR_VERMELHO'}} // Impressão Atendida
			      
aRotina   := {	{ "Imprimir"       , 'ExecBlock("ImpEtq",.F.,.F.)' , 0, 2},;
                { "Mostrar Todas"  , 'ExecBlock("MstOP",.F.,.F.)' , 0, 3},;
                { "Zerar Impressas", 'ExecBlock("ZrOP",.F.,.F.)' , 0, 4},;
                { "Legenda"        , 'ExecBlock("LegEtq",.F.,.F.)' , 0, 7}}

Private aBrowse :={ {"Num OP"	    , "OP"        , "C", 06, 0, "@!"}, ;
                	{"Produto"      , "CODPROD"   , "C", 15, 0, "@!"}, ;
                	{"Desc.Prod"    , "DESCPROD"  , "C", 50, 0, "@!"}, ;
                	{"Qtd.Prod."    , "QUANT"     , "N", 15, 3, "@E 999,999,999.99"}, ;
                	{"Emissao"      , "EMISSAO"   , "D", 08, 0, "@!"}, ;
                	{"Validade"     , "VALIDADE"  , "C", 20, 0, "@!"}, ;
                	{"Qtd.Etiq."    , "NUMMAX"    , "N", 10, 0, "@E 999,999,999"}, ;
                	{"Impressa"     , "NUMETIQ"   , "N", 10, 0, "@E 999,999,999"}, ;
                	{"Dimensão"     , "DIMENS"    , "C", 15, 0, "@!"}, ;
                	{"Peso"         , "PESO"      , "C", 30, 0, "@!"}, ;
                	{"Espessura"    , "ESPESS"    , "C", 10, 0, "@!"}, ;
                	{"Armadura"     , "ARMAD"     , "C", 30, 0, "@!"}, ;
                	{"Armazenagem"  , "ARMAZEM"   , "C", 40, 0, "@!"}, ;
                	{"Tipo Etiqueta", "TIPOETQ"   , "C", 01, 0, "@!"}, ;
                	{"Cod. Barras"  , "CODBAR"    , "C", 15, 0, "@!"}}

If	SC2->(FieldPos("C2_NUMETIQ")) = 0
	Aviso("Emissão de etiquetas","Esta empresa não está habilitada para executar esta rotina!",{"Ok"})
	Return
Endif
aUsuTip2 := {}
xVar := Alltrim(getmv("MV_ETQUSR1"))
Do	While !Empty(xVar)
	xUsu := SUBSTR(xVar,1,AT(";",xVar)-1)
	AADD(aUsuTip2,upper(xUsu))
	xVar := Substr(xVar,AT(";",xVar)+1)
Enddo
	
aUsuTip3 := {}
xVar := Alltrim(getmv("MV_ETQUSR2"))
Do	While !Empty(xVar)
	xUsu := SUBSTR(xVar,1,AT(";",xVar)-1)
	AADD(aUsuTip3,upper(xUsu))
	xVar := Substr(xVar,AT(";",xVar)+1)
Enddo

xUsu := upper(Alltrim(Substr(cUsuario,7,15)))
xNivel := 1
nPos := Ascan(aUsuTip2,xUsu)
If nPos <> 0
	xNivel := 2
Endif
nPos := Ascan(aUsuTip3,xUsu)
If nPos <> 0
	xNivel := 3
Endif

cArqTrb1 := ''           
xFil := xFilial("SC2")
xData := Dtos(dDatabase - 8)
cQry := " SELECT C2_NUM, C2_PRODUTO, B1_DESC, C2_QUANT, C2_EMISSAO, C2_NUMETIQ, B1_DIMENS, B1_ESPESS, B1_PRVALID, B1_CODBAR, B1_ARMAD, B1_ARMAZEM, 
cQry += " B1_ETIQLAY, B1_ETIQMED, B1_PESO, B1_UM"
cQry += " FROM "+RetSqlName('SC2')+" SC2"
cQry += " LEFT JOIN "+RetSqlName('SB1')+" SB1 ON (C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '')"
cQry += " WHERE SC2.D_E_L_E_T_ = ' '"
cQry += " AND C2_FILIAL = '"+xFil+"'"
cQry += " AND C2_EMISSAO > '"+xData+"'"
cQry += " ORDER BY C2_NUM" 
Tcquery cQry new alias "QRY"

dbSelectArea("QRY")
dbGoTop()

aStru:={}

AADD( aStru, {"OP"      , "C", 06, 0} )
AADD( aStru, {"CODPROD" , "C", 15, 0} )
AADD( aStru, {"DESCPROD", "C", 50, 0} )
AADD( aStru, {"QUANT"	, "N", 15, 3} )
AADD( aStru, {"EMISSAO"	, "D", 08, 0} )
AADD( aStru, {"VALIDADE", "C", 20, 0} )
AADD( aStru, {"NUMMAX"	, "N", 10, 0} )
AADD( aStru, {"NUMETIQ"	, "N", 10, 0} )
AADD( aStru, {"DIMENS"	, "C", 20, 0} )
AADD( aStru, {"PESO"	, "C", 30, 0} )
AADD( aStru, {"ESPESS"	, "C", 10, 0} )
AADD( aStru, {"CODBAR"	, "C", 15, 0} )
AADD( aStru, {"ARMAD"	, "C", 30, 0} )
AADD( aStru, {"ARMAZEM"	, "C", 55, 0} )
AADD( aStru, {"TIPOETQ"	, "C", 01, 0} )

cArqTrb1:=CriaTrab(aStru,.T.)
DbUseArea(.T.,"DBFCDX",cArqTrb1,"TRB",.F.)
//DbUseArea(.T.,,cArqTrb1,"TRB",.T.)
IndRegua("TRB",cArqTrb1,"OP")

dbSelectArea("QRY")
DbGoTop()
Do	While !EOF() 
	nMax := Int(QRY->C2_QUANT * QRY->B1_ETIQMED)
	If	nMax < QRY->C2_QUANT * QRY->B1_ETIQMED
		nMax ++
	Endif
	
    If	QRY->C2_NUMETIQ = nMax
		dbSelectArea("QRY")
    	DbSkip()
    	Loop
    Endif
    If	QRY->B1_PRVALID = 0
	    xValid := ''
    ElseIf	QRY->B1_PRVALID > 0 .and. QRY->B1_PRVALID < 365
    	nValid := Int(QRY->B1_PRVALID / 30)
    	nResto := QRY->B1_PRVALID - (nValid * 30)
    	If 	nResto = 0
    		If	nValid = 1
	    		xValid := Alltrim(Str(nValid)) + " mes"
			Else
	    		xValid := Alltrim(Str(nValid)) + " meses"
	  		Endif
		Else
		    xValid := Dtos(Stod(QRY->C2_EMISSAO) + QRY->B1_PRVALID)
		    xValid := Substr(xValid,7,2)+"/"+Substr(xValid,5,2)+"/"+Substr(xValid,3,2)
		Endif
    ElseIf	QRY->B1_PRVALID >= 365
    	nValid := Int(QRY->B1_PRVALID / 365)
    	nResto := QRY->B1_PRVALID - (nValid * 365)
    	If 	nResto = 0
    		If	nValid = 1
	    		xValid := Alltrim(Str(nValid)) + " ano"
			Else
	    		xValid := Alltrim(Str(nValid)) + " anos"
	  		Endif
		Else
		    xValid := Dtos(Stod(QRY->C2_EMISSAO) + QRY->B1_PRVALID)
		    xValid := Substr(xValid,7,2)+"/"+Substr(xValid,5,2)+"/"+Substr(xValid,3,2)
		Endif
	Endif		

	xDimens := ''
	xEspess := ''
	xArmaz  := ''
	xArmad  := ''      
	xCodbar := ''
	
	DbSelectArea("SX5")
	If 	dbSeek(xFilial("SX5")+"ZW"+QRY->B1_DIMENS)
		xDimens := SX5->X5_DESCRI
	Endif
	If 	dbSeek(xFilial("SX5")+"ZV"+QRY->B1_ESPESS)
		xEspess := SX5->X5_DESCRI
	Endif
	If 	dbSeek(xFilial("SX5")+"ZU"+QRY->B1_ARMAZEM)
		xArmaz := SX5->X5_DESCRI
	Endif     
	If	QRY->B1_ARMAD = '1'
		xArmad  := 'NAO TECIDO DE POLIESTER'
	ElseIf	QRY->B1_ARMAD = '2'
		xArmad  := 'POLIETILENO'
	ElseIf	QRY->B1_ARMAD = '3'
		xArmad  := 'VEU DE FIBRA DE VIDRO'
	Endif
	
	If	QRY->B1_CODBAR <> '' .and. QRY->B1_CODBAR <> QRY->C2_PRODUTO .and. Val(QRY->B1_CODBAR) <> 0
		xCodbar := QRY->B1_CODBAR
	Endif
                                 
	xPeso := Alltrim(Str(QRY->B1_PESO,15,2)) + " Kg / " + QRY->B1_UM

 	Reclock("TRB",.T.)
		TRB->OP      := QRY->C2_NUM
		TRB->CODPROD := QRY->C2_PRODUTO
		TRB->DESCPROD:= QRY->B1_DESC
		TRB->QUANT   := QRY->C2_QUANT
		TRB->EMISSAO := Stod(QRY->C2_EMISSAO)
		TRB->VALIDADE:= xValid
		TRB->NUMMAX  := nMax
		TRB->NUMETIQ := QRY->C2_NUMETIQ
		TRB->DIMENS  := xDimens
		TRB->PESO    := xPeso
		TRB->ESPESS  := xEspess
		TRB->CODBAR  := xCodbar
		TRB->ARMAD   := xArmad
		TRB->ARMAZEM := xArmaz
		TRB->TIPOETQ := QRY->B1_ETIQLAY
	MSUnlock()
	DBSELECTAREA("QRY")
	dbskip()
Enddo
	
MBrowse(18,07,248,498, "TRB", aBrowse,,,,, aCores)

dbSelectArea("TRB")
dbCloseArea()
FErase( cArqTrb1+".*")

dbSelectArea("QRY")
DbCloseArea()

Return(nil)

User Function ImpEtq()
If	TRB->NUMMAX = 0
	Aviso("Impressão de etiquetas","Quantidade total a ser impressa está zerada!",{"Ok"})
	Return
Endif
If	AllTrim(TRB->TIPOETQ) = ''
	Aviso("Impressão de etiquetas","Tipo da etiqueta não está definido!",{"Ok"})
	Return
Endif

cPerg:= "EST010    "  // Nome da Pergunta

_fPerg()                                                

IF !Pergunte(cPerg,.T.)  // Pergunta no SX1
	Return
Endif

nQtd := MV_PAR01

If	xNivel = 1 .and. nQtd > TRB->NUMMAX - TRB->NUMETIQ
	Aviso("Impressão de etiquetas","Quantidade solicitada não pode ser superior a "+Alltrim(Str(TRB->NUMMAX - TRB->NUMETIQ)),{"Ok"})
	Return
Endif

If	xNivel > 1 .and. nQtd > (TRB->NUMMAX * 4) - TRB->NUMETIQ
	Aviso("Impressão de etiquetas","Quantidade solicitada não pode ser superior a "+Alltrim(Str(((TRB->NUMMAX * 2) - TRB->NUMETIQ))),{"Ok"})
	Return
Endif

cPorta := "LPT1"

If	TRB->TIPOETQ = "1" .or. TRB->TIPOETQ = "2" .or. TRB->TIPOETQ = "4"
	IF MV_PAR02 == 1 //TLP 2844          
		//MSCBPRINTER("TLP 2844",cPorta,,47.3,.f.,,,,,,.T.,) //47.5  //Em 09/01/09 mudei de 47.3 para 47.4 Joao		
		MSCBPRINTER("TLP 2844",cPorta,,,.f.) //Alterado por Matheus
	ELSE  //S4M
	    //MSCBPRINTER("ZEBRA",cPorta,,55,.f.,,,,,,.T.,) // original impressora grande
		MSCBPRINTER("ZEBRA",cPorta,,,.f.) //Alterado por Matheus
	ENDIF
Else
	IF MV_PAR02 == 1 //TLP 2844 
	    //MSCBPRINTER("TLP 2844",cPorta,,83.2,.f.,,,,,,.T.,) //84
		MSCBPRINTER("TLP 2844",cPorta,,,.f.) //Alterado por Matheus
	ELSE //S4M
		//MSCBPRINTER("ZEBRA",cPorta,,83.2,.f.,,,,,,.T.,) //original impressora grande
		MSCBPRINTER("ZEBRA",cPorta,,,.f.)//Alterado por Matheus
	ENDIF
Endif
MSCBCHKSTATUS(.t.)
//MSCBLOADGRF("siga.grf")   // não deve ser utilizado. Provoca salto da etiqueta sem imprimir nada
MSCBLoadGraf("siga.bmp")

cNomEtq := Alltrim(GETMV("MV_ETQLOGO")) //"siga73"
nQtdLoop1 := nQtd / 10  // ALTERACAO FEITA PARA PODER IMPRIMIR UM SEQUENCIAL NA ETIQUETA POR LOTE DE 10 ETIQUETAS
nQtdLoop2 := Int(nQtd / 10)

If	nQtdLoop1 > nQtdLoop2
	nQtdLoop := nQtdLoop2 + 1
Else
	nQtdLoop := nQtdLoop2
Endif

For nx := 1 to nQtdLoop
	If	nx * 10 <= nQtd
		nEtq := 10
	Else
		nEtq := (nx * 10) - nQtd
		If	nEtq > nQtd
			nEtq := nQtd
		Endif
	Endif

	
	for j := 1 to nEtq 
	MSCBBEGIN(1,6)
	If	TRB->TIPOETQ = "1" //Generico - p/todos os produtos
		IF MV_PAR02 == 1 //TLP 2844
		 
			//MSCBGRAFIC(5,6,cNomEtq) // imagem carregada para a memória da impressora pelo software proprio dela. Parametro MV_ETQLOGO
			MSCBGRAFIC(5,0,cNomEtq)   // Alterado por Matheus
			//MSCBSAY(33,07,SM0->M0_NOMECOM,"N","2","02,02") 
			MSCBSAY(33,02,SM0->M0_NOMECOM,"N","2","02,02")   // Alterado por Matheus
			//MSCBSAY(33,12,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")
			MSCBSAY(33,07,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")   // Alterado por Matheus
			//MSCBSAY(66,12,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01") 
			MSCBSAY(66,07,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01")    // Alterado por Matheus
			If	!Empty(TRB->CODBAR)
				//MSCBSAYBAR(05,45,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,2.4,2) 
				MSCBSAYBAR(05,49,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,3,1)    // Alterado por Matheus
			Endif
			MSCBSAY(25,17,TRB->DESCPROD,"N","2","01,02")
			MSCBSAY(25,28,"ARMAZENAGEM: "+TRB->ARMAZEM,"N","2","01,01")
			MSCBSAY(44,31,"ARMAZENAR EM LOCAL FRESCO E SECO","N","2","01,01")
			MSCBSAY(60,36,"FABRIC:   "+DTOC(TRB->EMISSAO),"N","2","01,02")
			MSCBSAY(25,42,"LOTE: "+TRB->OP,"N","2","01,02")
			MSCBSAY(60,42,"VALIDADE: "+TRB->VALIDADE,"N","2","01,02")
   			//MSCBSAY(05,44,Alltrim(Str(nx-1)), "N", "2", "01,01") 
   			MSCBSAY(98,44,Alltrim(Str(nx-1)), "N", "2", "01,01")   // Alterado por Matheus
   		ELSE //S4M
			MSCBGRAFIC(10,20,"siga")
			MSCBSAY(33,07,SM0->M0_NOMECOM,"N","C","30,20")
			MSCBSAY(33,12,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","D","12,12")
			MSCBSAY(66,12,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","C","12,12")
			If	!Empty(TRB->CODBAR)
				MSCBSAYBAR(05,20,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,2.4,2)
			Endif
			MSCBSAY(25,17,TRB->DESCPROD,"N","C","20,10")
			MSCBSAY(25,28,"ARMAZENAGEM: "+TRB->ARMAZEM,"N","D","20,10")
			MSCBSAY(44,31,"ARMAZENAR EM LOCAL FRESCO E SECO","N","D","20,10")
			MSCBSAY(60,36,"FABRIC:   "+DTOC(TRB->EMISSAO),"N","D","20,10")
			MSCBSAY(25,42,"LOTE: "+TRB->OP,"N","D","20,10")
			MSCBSAY(60,42,"VALIDADE: " + TRB->VALIDADE ,"N","D","20,10")
   			MSCBSAY(05,44,Alltrim(Str(nx-1)), "N", "D", "20,10")    		
   		ENDIF

	ElseIf	TRB->TIPOETQ = "2" //Mantas Asfalticas
		//MSCBGRAFIC(5,6,cNomEtq)    
		MSCBGRAFIC(5,0,cNomEtq)   // Alterado por Matheus               
		//MSCBSAY(33,07,SM0->M0_NOMECOM,"N","2","02,02") 
		MSCBSAY(33,02,SM0->M0_NOMECOM,"N","2","02,02")   // Alterado por Matheus
		//MSCBSAY(33,12,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")  
		MSCBSAY(33,07,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")   // Alterado por Matheus
		//MSCBSAY(66,12,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01")    
		MSCBSAY(66,07,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01")    // Alterado por Matheus

		If	!Empty(TRB->CODBAR)
			//MSCBSAYBAR(05,45,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,2.4,2)
			MSCBSAYBAR(05,49,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,3)    // Alterado por Matheus
		Endif

		MSCBSAY(25,17,TRB->DESCPROD,"N","2","01,02")
		MSCBSAY(25,23,"DIMENSAO/ESPESSURA: "+Alltrim(TRB->DIMENS)+" / "+Alltrim(TRB->ESPESS),"N","2","01,01")
		MSCBSAY(25,28,"ARMADURA:    "+Alltrim(TRB->ARMAD),"N","2","01,01")
		MSCBSAY(25,33,"ARMAZENAGEM: "+TRB->ARMAZEM,"N","2","01,01")
		MSCBSAY(44,36,"ARMAZENAR EM LOCAL FRESCO E SECO","N","2","01,01")
		//MSCBSAY(25,41,"PESO LIQ: "+TRB->PESO,"N","2","01,01")
		MSCBSAY(50,40,"FABRICACAO:           "+DTOC(TRB->EMISSAO),"N","2","01,02")
		MSCBSAY(25,44,"LOTE: "+TRB->OP,"N","2","01,02")
		MSCBSAY(50,44,"VALIDADE P/ESTOCAGEM: "+TRB->VALIDADE,"N","2","01,02")
   		//MSCBSAY(05,44,Alltrim(Str(nx-1)), "N", "2", "01,01") 
   		MSCBSAY(98,44,Alltrim(Str(nx-1)), "N", "2", "01,01")  // Alterado por Matheus
   
	ElseIf	TRB->TIPOETQ = "3" //Mantas Asfalticas Normatizadas
//		MSCBSAY(30,05,"-","N","2","02,02") //Teste de posicionamento
//		MSCBSAY(30,75,"-","N","2","02,02")

		//MSCBGRAFIC(5,6,cNomEtq) // imagem carregada para a memória da impressora pelo software proprio dela. Parametro MV_ETQLOGO
		MSCBGRAFIC(5,0,cNomEtq)   // Alterado por Matheus
		//MSCBSAY(33,07,SM0->M0_NOMECOM,"N","2","02,02") 
		MSCBSAY(33,02,SM0->M0_NOMECOM,"N","2","02,02")   // Alterado por Matheus
		//MSCBSAY(33,12,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")
		MSCBSAY(33,07,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")   // Alterado por Matheus
		//MSCBSAY(66,12,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01") 
		MSCBSAY(66,07,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01")    // Alterado por Matheus

		MSCBLineH(05,16,100,4,"B") 
		MSCBSAY(07,18,MemoLine(TRB->DESCPROD,27,1),"N","2","02,02")
		MSCBSAY(07,23,MemoLine(TRB->DESCPROD,27,2),"N","2","02,02")
		MSCBLineH(05,28,100,4,"B") 

		MSCBSAY(07,33,"DIMENSAO:    "+Alltrim(TRB->DIMENS),"N","2","01,01")
		MSCBSAY(07,38,"ESPESSURA:   "+Alltrim(TRB->ESPESS),"N","2","01,01")
		MSCBSAY(07,43,"ARMADURA:    "+Alltrim(TRB->ARMAD),"N","2","01,01")
		//MSCBSAY(07,48,"PESO LIQ:    "+TRB->PESO,"N","2","01,01")
		MSCBSAY(07,48,"ARMAZENAGEM: "+TRB->ARMAZEM,"N","2","01,01")
		MSCBSAY(26,53,"ARMAZENAR EM LOCAL FRESCO E SECO","N","2","01,01")
  

		MSCBLineH(05,58,100,4,"B") 
		MSCBLineV(56,58,80,3,"B") 

		MSCBSAY(07,61,"LOTE: ","N","2","01,02")
		MSCBSAY(20,61,TRB->OP,"N","2","02,02")
		MSCBSAY(07,70,"FABRICACAO:   "+DTOC(TRB->EMISSAO),"N","2","01,02")
		MSCBSAY(07,75,"VALIDADE P/ESTOCAGEM: "+TRB->VALIDADE,"N","2","01,02")
		If	!Empty(TRB->CODBAR)
			MSCBSAYBAR(59,61,TRB->CODBAR,"N","MB04",15,.F.,.T.,,,3,2)
		Endif
   		MSCBSAY(05,80,Alltrim(Str(nx-1)), "N", "2", "01,01") 
   		
	ElseIf	TRB->TIPOETQ = "4" //Fitas Anti-corrosivas
		//MSCBGRAFIC(5,6,cNomEtq) // imagem carregada para a memória da impressora pelo software proprio dela. Parametro MV_ETQLOGO
		MSCBGRAFIC(5,0,cNomEtq)   // Alterado por Matheus
		//MSCBSAY(33,07,SM0->M0_NOMECOM,"N","2","02,02") 
		MSCBSAY(33,02,SM0->M0_NOMECOM,"N","2","02,02")   // Alterado por Matheus
		//MSCBSAY(33,12,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")
		MSCBSAY(33,07,"Tel.:("+Substr(SM0->M0_TEL,1,2)+")"+Substr(SM0->M0_TEL,3,4)+"-"+Substr(SM0->M0_TEL,7,4),"N","2","01,01")   // Alterado por Matheus
		//MSCBSAY(66,12,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01") 
		MSCBSAY(66,07,"www."+LOWER(Alltrim(SM0->M0_NOME))+".com.br","N","2","01,01")    // Alterado por Matheus
		If	!Empty(TRB->CODBAR)
			//MSCBSAYBAR(05,45,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,2.4,2) 
			MSCBSAYBAR(05,49,TRB->CODBAR,"B","MB04",15,.F.,.T.,,,3)    // Alterado por Matheus
		Endif

		MSCBSAY(25,17,TRB->DESCPROD,"N","2","01,02")
		MSCBSAY(25,23,"EMBALAGEM: "+Alltrim(TRB->DIMENS),"N","2","01,01")
		MSCBSAY(25,28,"ARMAZENAGEM: "+TRB->ARMAZEM,"N","2","01,01")
		MSCBSAY(44,31,"ARMAZENAR EM LOCAL FRESCO E SECO","N","2","01,01")
		//MSCBSAY(25,41,"PESO LIQ: "+TRB->PESO,"N","2","01,01")
		MSCBSAY(60,36,"FABRIC.:  "+DTOC(TRB->EMISSAO),"N","2","01,02")
		MSCBSAY(25,42,"LOTE: "+TRB->OP,"N","2","01,02")
		MSCBSAY(60,42,"VALIDADE: "+TRB->VALIDADE,"N","2","01,02")
   		//MSCBSAY(05,44,Alltrim(Str(nx-1)), "N", "2", "01,01") 
   		MSCBSAY(98,44,Alltrim(Str(nx-1)), "N", "2", "01,01") 
	Endif 
	MSCBEND()
    Next
	
Next	
Reclock("TRB",.F.)
	TRB->NUMETIQ := TRB->NUMETIQ + nQtd
MSUnlock()
DbSelectArea("SC2")
If	DbSeek(xFil+TRB->OP)
	Reclock("SC2",.F.)
		SC2->C2_NUMETIQ := SC2->C2_NUMETIQ + nQtd
	MSUnlock()
Endif

MSCBCLOSEPRINTER()

Return(nil)

User Function MstOP()
If	xNivel = 1
	Aviso("Mostrar todas as OP's","Usuário sem acesso para executar esta rotina.",{"Ok"})
	Return
Endif

dbSelectArea("QRY")  
DbGoTop()
Do	While !EOF() 
 	DbSelectArea("TRB")
 	If	DbSeek(QRY->C2_NUM)
		dbSelectArea("QRY")
    	DbSkip()
    	Loop
    Endif

	nMax := Int(QRY->C2_QUANT * QRY->B1_ETIQMED)
	If	nMax < QRY->C2_QUANT * QRY->B1_ETIQMED
		nMax ++
	Endif
	
    If	nMax = 0
		dbSelectArea("QRY")
    	DbSkip()
    	Loop
    Endif

    If	QRY->B1_PRVALID = 0
	    xValid := ''
    ElseIf	QRY->B1_PRVALID > 0 .and. QRY->B1_PRVALID < 365
    	nValid := Int(QRY->B1_PRVALID / 30)
    	nResto := QRY->B1_PRVALID - (nValid * 30)
    	If 	nResto = 0
    		If	nValid = 1
	    		xValid := Alltrim(Str(nValid)) + " mes"
			Else
	    		xValid := Alltrim(Str(nValid)) + " meses"
	  		Endif
		Else
		    xValid := Dtos(Stod(QRY->C2_EMISSAO) + QRY->B1_PRVALID)
		    xValid := Substr(xValid,7,2)+"/"+Substr(xValid,5,2)+"/"+Substr(xValid,3,2)
		Endif
    ElseIf	QRY->B1_PRVALID >= 365
    	nValid := Int(QRY->B1_PRVALID / 365)
    	nResto := QRY->B1_PRVALID - (nValid * 365)
    	If 	nResto = 0
    		If	nValid = 1
	    		xValid := Alltrim(Str(nValid)) + " ano"
			Else
	    		xValid := Alltrim(Str(nValid)) + " anos"
	  		Endif
		Else
		    xValid := Dtos(Stod(QRY->C2_EMISSAO) + QRY->B1_PRVALID)
		    xValid := Substr(xValid,7,2)+"/"+Substr(xValid,5,2)+"/"+Substr(xValid,3,2)
		Endif
	Endif		

	xDimens := ''
	xEspess := ''
	xArmaz  := ''
	xArmad  := ''      
	xCodbar := ''
	
	DbSelectArea("SX5")
	If 	dbSeek(xFilial("SX5")+"ZW"+QRY->B1_DIMENS)
		xDimens := SX5->X5_DESCRI
	Endif
	If 	dbSeek(xFilial("SX5")+"ZV"+QRY->B1_ESPESS)
		xEspess := SX5->X5_DESCRI
	Endif
	If 	dbSeek(xFilial("SX5")+"ZU"+QRY->B1_ARMAZEM)
		xArmaz := SX5->X5_DESCRI
	Endif     
	If	QRY->B1_ARMAD = '1'
		xArmad  := 'NAO TECIDO DE POLIESTER'
	ElseIf	QRY->B1_ARMAD = '2'
		xArmad  := 'POLIETILENO'
	ElseIf	QRY->B1_ARMAD = '3'
		xArmad  := 'VEU DE FIBRA DE VIDRO'
	Endif
	
	If	QRY->B1_CODBAR <> '' .and. QRY->B1_CODBAR <> QRY->C2_PRODUTO .and. Val(QRY->B1_CODBAR) <> 0
		xCodbar := QRY->B1_CODBAR
	Endif
                                 
	xPeso := Alltrim(Str(QRY->B1_PESO,15,2)) + " Kg / " + QRY->B1_UM

 	Reclock("TRB",.T.)
		TRB->OP      := QRY->C2_NUM
		TRB->CODPROD := QRY->C2_PRODUTO
		TRB->DESCPROD:= QRY->B1_DESC
		TRB->QUANT   := QRY->C2_QUANT
		TRB->EMISSAO := Stod(QRY->C2_EMISSAO)
		TRB->VALIDADE:= xValid
		TRB->NUMMAX  := nMax
		TRB->NUMETIQ := QRY->C2_NUMETIQ
		TRB->DIMENS  := xDimens
		TRB->PESO    := xPeso
		TRB->ESPESS  := xEspess
		TRB->CODBAR  := xCodbar
		TRB->ARMAD   := xArmad
		TRB->ARMAZEM := xArmaz
		TRB->TIPOETQ := QRY->B1_ETIQLAY
	MSUnlock()
	DBSELECTAREA("QRY")
	dbskip()
Enddo
dbSelectArea("TRB")  
DbGoTop()

Return

User Function ZrOP()
If	xNivel <> 3
	Aviso("Zerar contador de impressas","Usuário sem acesso para executar esta rotina.",{"Ok"})
	Return
Endif

If	Msgbox("Confirma a inicialização do contador de impressão de etiquetas?","Atenção","YESNO") = .T.
	Reclock("TRB",.F.)
		TRB->NUMETIQ := 0
	MSUnlock()
	DbSelectArea("SC2")
	If	DbSeek(xFil+TRB->OP)
	 	Reclock("SC2",.F.)
			SC2->C2_NUMETIQ := 0
		MSUnlock()
	Endif
Endif	
Return

User Function LegEtq()
cCadastro	:= "Emissão de Etiquetas"
aCores2 := { {"BR_VERDE"   , "Impressão Etiqueta 100 x 50"},;
             {"BR_AZUL"    , "Impressão Etiqueta 102 x 85"},;
             {"BR_VERMELHO", "Impressão Atendida"}}

BrwLegenda(cCadastro,"Legenda do Browse",aCores2)
Return





Static Function _fPerg()

//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)

PutSx1(cPerg,"01","Quantidade?         ","","","mv_ch1","N",06,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"01","Impressora?         ","","","mv_ch2","N",01,0,0,"C","","","","","MV_PAR02","","","","TLP 2844","","","","","S4M","","","","","","","")

Return
