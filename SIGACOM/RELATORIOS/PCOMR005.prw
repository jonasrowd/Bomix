
#INCLUDE "MATR110.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#Include "TOTVS.ch"
#Include "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} PCOMR005
//PEDIDO DE COMPRAS GRAFICO

//Acionado apartir da aprovação do pedido via Flug no fonte FCOMW001.prw que é acionado do WS_FLUIG.PRW

//Se l_File igual a .T. imprime em PDF na tela
//Se l_File igual a ,F. gera PDF em arquivo

@author carlo
@since 26/05/2019
@version 1.0
@return ${return}, ${return_description}
@param c_Alias, characters, descricao
@param n_Reg, numeric, descricao
@param l_File, logical, descricao
@type function
/*/
User Function PCOMR005( c_Alias, n_Reg, l_File )

Local n_TamCdProd	:= 	TamSX3("C7_PRODUTO")[1]

//Variaveis utilizadas para parametros                         
//mv_par01               Do Pedido                             
//mv_par02               Ate o Pedido                          
//mv_par03               A partir da data de emissao           
//mv_par04               Ate a data de emissao                 
//mv_par05               Somente os Novos                      
//mv_par06               Campo Descricao do Produto    	     
//mv_par07               Unidade de Medida:Primaria ou Secund. 
//mv_par08               Imprime ? Pedido Compra ou Aut. Entreg
//mv_par09               Numero de vias                        
//mv_par10               Pedidos ? Liberados Bloqueados Ambos  
//mv_par11               Impr. SC's Firmes, Previstas ou Ambas 
//mv_par12               Qual a Moeda ?                        
//mv_par13               Endereco de Entrega                   
//mv_par14               todas ou em aberto ou atendidos       

//If !l_File
//	Pergunte("MTR110",.T.)
//ElseIf l_File //gerando pra arquivo
	If n_Reg > 0
		SC7->(dbGoto(n_Reg))
	Endif
	Pergunte("MTR110",.F.)
	Private mv_par01	:= 	SC7->C7_NUM			//Do Pedido                             
	Private mv_par02 	:= 	SC7->C7_NUM			//Ate o Pedido                          
	Private mv_par03 	:= 	CtoD("01/01/2000")  //A partir da data de emissao           
	Private mv_par04	:= 	CtoD("31/12/2049")  //Ate a data de emissao                 
	Private mv_par05	:=	2					//Somente os Novos                      
	Private mv_par06	:=	"C7_DESCRI"			//Campo Descricao do Produto    	    
	Private mv_par07	:=	3					//Unidade de Medida:Primaria ou Secund. 
	Private mv_par08	:=	1					//Imprime ? Pedido Compra ou Aut. Entreg
	Private mv_par09	:=	1					//Numero de vias                        
	Private mv_par10	:=	3					//Pedidos ? Liberados Bloqueados Ambos  
	Private mv_par11	:=	3					//Impr. SC's Firmes, Previstas ou Ambas 
	Private mv_par12	:=	0					//Qual a Moeda ?                        
	Private mv_par13	:=	""					//Endereco de Entrega                   
	Private mv_par14	:=	1					//todas ou em aberto ou atendidos

	Private	c_Arquivo	:=	"PCOMR005_"+SC7->C7_NUM+"_"+DtoS(ddatabase)+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)+".pdf"
	Private o_Aria10  	:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
	Private o_Aria12  	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
	Private o_Aria14N	:=	TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
	Private o_Aria16N	:=	TFont():New("Arial",,16,,.T.,,,,,.F.,.F.)
	Private o_Printer
	Private c_StartPath		:=	GetSrvProfString ("StartPath","\System\")
	Private	l_AdjustToLegacy:= 	.T.
	Private	l_DisableSetup  := 	.T.//l_File
	Private	c_Pasta			:= 	SUPERGetMV("FS_ANFLUIG",.F.,"\system\") //Anexos Fluig  //"\spool\fluig\anexos\"
	If l_File //abrir pasta a ser selecionada para gravacao do arquivo
		Private o_Explorer := clsExplorer():New() //Classe global da fabrica de software aplicada no RPO do cliente por meio de Patche da FSW TOTVS Bahia.
		c_Pasta	:=	Alltrim(o_Explorer:mtdExplorer("Selecione Pasta para gravção", "*.*", , .T.))
		If Substr(c_Pasta,len(c_Pasta),1) <> "\"
			c_Pasta := c_Pasta+"\"
		Endif
	Endif
	
	o_Printer				:=	FWMSPrinter():New(c_Arquivo,	IMP_PDF, l_AdjustToLegacy,c_Pasta, l_DisableSetup,,,,,,.F.)
	
	o_Printer:LVIEWPDF		:=	l_File //.F.
	o_Printer:cPathPDF		:= 	c_Pasta
	o_Printer:SetResolution(72)
	//o_Printer:SetLandscape()
	o_Printer:SetPortrait()
	o_Printer:SetPaperSize(DMPAPER_A4)
	o_Printer:SetMargin(10,10,10,10)
	o_Printer:SetPortrait()
	
	Private PixelX 			:= 	o_Printer:nLogPixelX()
	Private PixelY 			:= 	o_Printer:nLogPixelY()
	
	o_Printer:StartPage()
	
	ReportPrint(c_Alias,n_Reg,l_File) //imprimindo pedidos
	
	o_Printer:EndPage()
	
	o_Printer:Preview()
	
	FreeObj(o_Printer)
	o_Printer 			:= 	Nil
	
//Endif

//If l_File
Return(c_Pasta+c_Arquivo)
//Endif

//Return


/*/{Protheus.doc} ReportPrint
//Imprimindo Pedidos de compras
@author carlo
@since 26/05/2019
@version 1.0
@return ${return}, ${return_description}
@param c_Alias, characters, descricao
@param n_Reg, numeric, descricao
@param l_File, logical, descricao
@type function
/*/
Static Function ReportPrint(c_Alias,n_Reg,l_File) //imprimindo pedidos

Local a_RecnoSave	:= 	{}
Local a_Pedido   	:= 	{}
Local a_PedMail  	:= 	{}
Local a_ValIVA   	:= 	{}

Local c_NumSC7		:= 	Len(SC7->C7_NUM)
Local c_Condicao	:= 	""
Local c_Filtro		:= 	""
Local c_Comprador	:= 	""
LOcal c_Alter		:= 	""
Local c_Aprov		:= 	""
Local c_TipoSC7		:= 	""
Local c_CondBus		:= 	""
Local c_Mensagem	:= 	""
Local c_Var			:= 	""
Local c_PictVUnit	:= 	PesqPict("SC7","C7_PRECO",16)
Local c_PictVTot	:= 	PesqPict("SC7","C7_TOTAL",, mv_par12)
Local l_NewAlc		:= 	.F.
Local l_Liber		:= 	.F.
Local l_Ret			:= 	.T.

Local n_RecnoSC7 	:= 	0
Local n_TotalsX3 	:= 	0
Local n_RecnoSM0 	:= 	0
Local n_X        	:= 	0
Local n_Y        	:= 	0
Local n_Vias     	:= 	0
Local n_TxMoeda  	:= 	0
Local n_TpImp		:= 	0//IIF(ValType(oReport:nDevice)!=Nil,oReport:nDevice,0) // Tipo de Impressao
Local n_PageWidth	:= 	IIF(n_TpImp==1.Or.n_TpImp==6,2435,2435) // oReport:PageWidth()
Local n_Printed  	:= 	0
Local n_ValIVA   	:= 	0
Local n_TotIpi		:= 	0
Local n_TotIcms  	:= 	0
Local n_TotDesp  	:= 	0
Local n_TotFrete 	:= 	0
Local n_TotalNF  	:= 	0
Local n_TotSeguro	:= 	0
Local n_LinPC		:= 	0
Local n_LinObs   	:= 	0
Local n_Desc1 		:= 	0
Local n_Desc2 		:= 	0
Local n_Desc3 		:= 	0
Local n_DescProd 	:= 	0
Local n_Total    	:= 	0
Local n_TotMerc  	:= 	0
Local n_Pagina   	:= 	0
Local n_Order    	:= 	1
Local c_UserId   	:= 	RetCodUsr()
Local c_Cont     	:= 	Nil
Local l_Impri    	:= 	.F.
Local c_Cident		:= 	""
Local c_Cidcob		:= 	""
Local n_LinPC2		:= 	0
Local n_LinPC3		:= 	0
Local n_AprovLin 	:= 	0

Private c_DescPro:= ""
Private c_OPCC   := ""
Private n_VlUnitSC7:= 0
Private n_ValTotSC7:= 0

Private c_Obs01  	:= 	""
Private c_Obs02  	:= 	""
Private c_Obs03  	:= 	""
Private c_Obs04  	:= 	""
Private c_Obs05  	:= 	""
Private c_Obs06  	:= 	""
Private c_Obs07  	:= 	""
Private c_Obs08  	:= 	""
Private c_Obs09  	:= 	""
Private c_Obs10  	:= 	""
Private c_Obs11  	:= 	""
Private c_Obs12  	:= 	""
Private c_Obs13  	:= 	""
Private c_Obs14  	:= 	""
Private c_Obs15  	:= 	""
Private c_Obs16  	:= 	""
Private n_Pagina	:= 	0
Private l_Pedido 	:= 	.T.

dbSelectArea("SC7")

c_Condicao := "@C7_FILIAL = '"+xFilial("SC7")+"' And "
c_Condicao += "C7_NUM >= '"+mv_par01+"' And C7_NUM <= '"+mv_par02+"' And "
c_Condicao += "C7_EMISSAO >= '"+Dtos(mv_par03)+"' And C7_EMISSAO <= '"+Dtos(mv_par04)+"' "

dbSelectArea("SC7")
SET FILTER TO &c_Condicao
		
mv_par12 := MAX(SC7->C7_MOEDA,1)

If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
	If ( cPaisLoc$"ARG|POR|EUA" )
		c_CondBus := "1"+StrZero(Val(mv_par01),6)
		n_Order	 := 10
	Else
		c_CondBus := mv_par01
		n_Order	 := 1
	EndIf
Else
	c_CondBus := "2"+StrZero(Val(mv_par01),6)
	n_Order	 := 10
EndIf

If mv_par14 == 2
	c_Filtro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
Elseif mv_par14 == 3
	c_Filtro := "SC7->C7_QUANT > SC7->C7_QUJE"
EndIf
	
//imprime cabecalho do pedido
Private n_Lin	:=	0100
f_Cabec(c_Alias,n_Reg,l_File)

dbSelectArea("SC7")
dbSetOrder(n_Order)
dbSeek(xFilial("SC7")+c_CondBus,.T.)

c_NumSC7 := SC7->C7_NUM

While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02
	If 	(SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
		(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
		((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
		((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
		(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
		(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
		((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )

		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
		
	MaFisEnd()
	R110FIniPC(SC7->C7_NUM,,,c_Filtro)

	cObs01    := " "
	cObs02    := " "
	cObs03    := " "
	cObs04    := " "
	cObs05    := " "
	cObs06    := " "
	cObs07    := " "
	cObs08    := " "
	cObs09    := " "
	cObs10    := " "
	cObs11    := " "
	cObs12    := " "
	cObs13    := " "
	cObs14    := " "
	cObs15    := " "
	cObs16    := " "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Roda a impressao conforme o numero de vias informado no mv_par09 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nVias := 1 to mv_par09

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dispara a cabec especifica do relatorio.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		n_Pagina  := 0
		n_Printed := 0
		n_Total   := 0
		n_TotMerc := 0
		n_Desc1	  := 0
		n_Desc2   := 0
		n_Desc3   := 0
		n_DescProd:= 0
		n_LinObs  := 0
		n_RecnoSC7:= SC7->(Recno())
		c_NumSC7  := SC7->C7_NUM
		a_Pedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}

		n_LinItem	:=	n_Lin+0335+0020
		
		While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == c_NumSC7

			If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
				(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
				(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
				((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
				((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
				(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
				(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
				((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )

				dbSelectArea("SC7")
				dbSkip()
				Loop

			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Salva os Recnos do SC7 no aRecnoSave para marcar reimpressao.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Ascan(a_RecnoSave,SC7->(Recno())) == 0
				AADD(a_RecnoSave,SC7->(Recno()))
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa o descricao do Produto conf. parametro digitado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			c_DescPro :=  ""
			If Empty(mv_par06)
				mv_par06 := "B1_DESC"
			EndIf

			If AllTrim(mv_par06) == "B1_DESC"
				SB1->(dbSetOrder(1))
				SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))

				dbSelectArea("SC1")
				dbSetOrder(1)
				dbSeek( xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )

				cDescPro := SB1->(Alltrim(B1_DESC))
				If SC1->(FieldPos("C1_FSMARC")) > 0
					If !Empty(SC1->C1_FSMARC)
						cDescPro := cDescPro + " (" + Alltrim( SC1->( Iif(FieldPos("C1_FSMARC")>0,C1_FSMARC,"" ) ) ) + ")"
					endif
				Endif

			ElseIf AllTrim(mv_par06) == "B5_CEME"
				SB5->(dbSetOrder(1))
				If SB5->(dbSeek( xFilial("SB5") + SC7->C7_PRODUTO ))

					dbSelectArea("SC1")
					dbSetOrder(1)
					dbSeek( xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )

					cDescPro := SB5->(Alltrim(B5_CEME))
					If SC1->(FieldPos("C1_FSMARC")) > 0
						If !Empty(SC1->C1_FSMARC)
							cDescPro := cDescPro + " (" + Alltrim( SC1->( Iif(FieldPos("C1_FSMARC")>0,C1_FSMARC,"" ) ) ) + ")"
						endif
					Endif

				EndIf
			ElseIf AllTrim(mv_par06) == "C7_DESCRI"

				dbSelectArea("SC1")
				dbSetOrder(1)
				dbSeek( xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )

				cDescPro := SC7->(Alltrim(C7_DESCRI))
				If SC1->(FieldPos("C1_FSMARC")) > 0
					If !Empty(SC1->C1_FSMARC)
						cDescPro := cDescPro + " (" + Alltrim( SC1->( Iif(FieldPos("C1_FSMARC")>0,C1_FSMARC,"" ) ) ) + ")"
					endif
				Endif

			EndIf

			If Empty(c_DescPro)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))

				dbSelectArea("SC1")
				dbSetOrder(1)
				dbSeek( xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )

				cDescPro := SB1->(Alltrim(B1_DESC))
				If SC1->(FieldPos("C1_FSMARC")) > 0
					If !Empty(SC1->C1_FSMARC)
						cDescPro := cDescPro + " (" + Alltrim( SC1->( Iif(FieldPos("C1_FSMARC")>0,C1_FSMARC,"" ) ) ) + ")"
					endif
				Endif

			EndIf

			SA5->(dbSetOrder(1))
			If SA5->(dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)) .And. !Empty(SA5->A5_CODPRF)

				dbSelectArea("SC1")
				dbSetOrder(1)
				dbSeek( xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )

				cDescPro := Alltrim(c_DescPro)
				If SC1->(FieldPos("C1_FSMARC")) > 0
					If !Empty(SC1->C1_FSMARC)
						cDescPro := cDescPro + " (" + Alltrim( SC1->( Iif(FieldPos("C1_FSMARC")>0,C1_FSMARC,"" ) ) ) + ")"
					endif
				Endif

			EndIf

			If SC7->C7_DESC1 != 0 .Or. SC7->C7_DESC2 != 0 .Or. SC7->C7_DESC3 != 0
				n_Desc1	  := SC7->C7_DESC1
				n_Desc2   := SC7->C7_DESC2
				n_Desc3   := SC7->C7_DESC3
				n_DescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				n_DescProd+=SC7->C7_VLDESC
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SC7->C7_OBS) .And. n_LinObs < 11
				n_LinObs++
				c_Var:="c_Obs"+StrZero(n_LinObs,2)
				Eval(MemVarBlock(c_Var),SC7->C7_ITEM + "-" + SC7->C7_OBS)
			Endif

			n_TxMoeda   := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
			n_ValTotSC7 := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda)

			n_Total     := n_Total + SC7->C7_TOTAL
			n_TotMerc   := MaFisRet(,"NF_TOTAL")

			//calculando valor unitario
			n_VlUnitSC7 := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda)

			If n_LinItem >= 2000
				//imprime cabecalho do pedido
				f_Cabec(c_Alias,n_Reg,l_File)
					n_LinItem	:=	n_Lin+0335+0020
			Endif

			n_TamDesc	:= 30

			o_Printer:Say(n_LinItem,0049,SC7->C7_ITEM											,o_Aria10,,0) //Item 		//1234
			o_Printer:Say(n_LinItem,0135,SC7->C7_PRODUTO										,o_Aria10,,0) //Produto 	//"123456789012345"
			o_Printer:Say(n_LinItem,0375,MemoLine(c_DescPro,n_TamDesc,1)						,o_Aria10,,0) //Descrição	//"123456789012345678901234567890"
			o_Printer:Say(n_LinItem,0875,SC7->C7_UM												,o_Aria10,,0) //UN 			//"12"
			o_Printer:Say(n_LinItem,0954,SC7->(Transform(C7_QUANT	,"@E 99999999.9999"))		,o_Aria10,,0) //Qt 			//"12345678.1234"
			o_Printer:Say(n_LinItem,1171,SC7->C7_SEGUM											,o_Aria10,,0) //2a UN 		//"12"
			o_Printer:Say(n_LinItem,1241,SC7->(Transform(C7_QTSEGUM	,"@E 99999999.9999"))		,o_Aria10,,0) //Qt 2a UN 	//"12345678.1234"
			o_Printer:Say(n_LinItem,1437,Transform(n_VlUnitSC7, "@E 99999999.9999")				,o_Aria10,,0) //Preco unit	//"12345678.1234"
			o_Printer:Say(n_LinItem,1652,SC7->(Transform(C7_IPI, "@E 999"))						,o_Aria10,,0) //Ipi			//"123"
			o_Printer:Say(n_LinItem,1745,SC7->(Transform(C7_TOTAL	,"@E 99999999.99"))			,o_Aria10,,0) //valor total	//"12345678.12"
			o_Printer:Say(n_LinItem,1920,SC7->(Transform(C7_DATPRF,"@D"))						,o_Aria10,,0) //Entreg		//"DD/MM/AAAA"
			o_Printer:Say(n_LinItem,2104,SC7->C7_CC												,o_Aria10,,0) //CC			//"1234"
			o_Printer:Say(n_LinItem,2200,SC7->C7_NUMSC											,o_Aria10,,0) //Num Sc		//"123456"

			If Len(c_DescPro) > n_TamDesc
				n_Linha:= MLCount(c_DescPro,n_TamDesc)
			Else
				n_Linha:= MLCount(c_DescPro,n_TamDesc)
			EndIf

			For n_Begin := 2 To n_Linha
				n_LinItem := n_LinItem + 25
				o_Printer:Say(n_LinItem,0375,MemoLine(c_DescPro,n_TamDesc,n_Begin)				,o_Aria10,,0) //Descrição	//"123456789012345678901234567890"
			Next n_Begin
			
			n_LinItem := n_LinItem + 25
				
			n_Printed ++
			l_Impri  := .T.
			dbSelectArea("SC7")
			dbSkip()

		EndDo

		SC7->(dbGoto(n_RecnoSC7))

		If n_LinItem >= 2000
			//imprime cabecalho do pedido
			f_Cabec(c_Alias,n_Reg,l_File)
			n_LinItem	:=	n_Lin+0335+0020
		Endif

		//Descontos
		c_Desc1		:=	Transform(n_Desc1	, "@E 999.99")
		c_Desc2		:=	Transform(n_Desc2	, "@E 999.99") 
		c_Desc3		:=	Transform(n_Desc2	, "@E 999.99") 
		c_DescProd	:=	Transform(n_DescProd, "@E 99999999.99")

		o_Printer:Box(n_Lin+2020,0032,n_Lin+2100,2320)
		o_Printer:Say(n_Lin+2065,0080,"DESCONTOS --> "+c_Desc1+" %  "+c_Desc2+" %  "+c_Desc3+" %   "+c_DescProd+" ",o_Aria10,,0)
			
		//Endereco de entrega e cobranca
		SM0->(dbSetOrder(1))
		n_RecnoSM0 := SM0->(Recno())
		SM0->(dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))

		c_EndEnt := "Local de Entrega :"+Padr(SM0->M0_ENDENT,40)
		c_CidEnt := "Municipio: "+Padr(IIF(len(SM0->M0_CIDENT)>20,Substr(SM0->M0_CIDENT,1,15),SM0->M0_CIDENT),20)
		c_EstEnt := "Estado: "+SM0->M0_ESTENT
		c_CepEnt := "CEP: "+Padr(Trans(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP")),10)
		c_Entrega:=	c_EndEnt + c_CidEnt + c_EstEnt + c_CepEnt
			
		c_EndCob := "Local de Cobranca: "+Padr(SM0->M0_ENDCOB,40)
		c_CidCob := "Municipio: "+Padr(Rtrim(SM0->M0_CIDCOB),20)
		c_EstCob := "Estado: "+SM0->M0_ESTCOB
		c_CepCob := "CEP: "+Padr(Trans(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP")),10)
		c_Cobranca := c_EndCob +  c_CidCob + c_EstCob + c_CepCob
			
		If Empty(MV_PAR13) //"Local de Entrega  : "
			dbSelectArea( "SC1")
			dbSetOrder( 1 )
			dbSeek(xFilial( "SC1" ) +  SC7->C7_NUMSC + SC7->C7_ITEMSC )
			If SC1->(FieldPos("C1_FSEND")) > 0
				If !Empty( SC1->C1_FSEND )
					c_Entrega := SC1->(SubStr(C1_FSEND,1,110))
				Endif
			Endif
		Endif
			
		SM0->(dbGoto(n_RecnoSM0))
			
		o_Printer:Box(n_Lin+2100,0032,n_Lin+2218,2320)
		o_Printer:Say(n_Lin+2142,0060,c_Entrega,o_Aria10,,0)
		o_Printer:Say(n_Lin+2171,0060,c_Cobranca,o_Aria10,,0)
	
		//Condicao de pagamento
		SE4->(dbSetOrder(1))
		SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
		o_Printer:Box(n_Lin+2218,0032,n_Lin+2322,0849)
		o_Printer:Say(n_Lin+2245,0067,"Condicao de pagamento: "+SubStr(SE4->E4_COND,1,40)	,o_Aria10,,0)
		o_Printer:Say(n_Lin+2285,0067,SubStr(SE4->E4_DESCRI,1,40)							,o_Aria10,,0)

		//Data de emissao
		o_Printer:Box(n_Lin+2218,0849,n_Lin+2322,1131)
		o_Printer:Say(n_Lin+2245,0889,"Data de Emissao:"	,o_Aria10,,0)
		o_Printer:Say(n_Lin+2285,0899,dtoc(SC7->C7_EMISSAO)	,o_Aria10,,0)
			
		//Totais de mercadoria e com impostos
		c_TMerc		:=	Transform(xMoeda(n_Total	,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) , tm(n_Total	,14,MsDecimais(MV_PAR12)) )
		c_TImpostos	:=	Transform(xMoeda(n_TotMerc	,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) , tm(n_TotMerc	,14,MsDecimais(MV_PAR12)) )
			
		o_Printer:Box(n_Lin+2218,1131,n_Lin+2657,2320)
		o_Printer:Say(n_Lin+2245,1491,Padr("Total das Mercadorias.: ",25)+c_TMerc	,o_Aria10,,0)
		o_Printer:Say(n_Lin+2285,1491,Padr("Total com Impostos....: ",25)+c_TImpostos,o_Aria10,,0)

		//Obsrvacoes
		If Empty(c_Obs02)
			If Len(c_Obs01) > 50
				c_Obs := c_Obs01
				c_Obs01 := Substr(c_Obs,1,50)
				For n_X := 2 To 10
					c_Var  := "c_Obs"+StrZero(n_X,2)
					&c_Var := Substr(c_Obs,(50*(n_X-1))+1,50)
				Next n_X5
			EndIf
		Else
			c_Obs01:= Substr(c_Obs01,1,IIf(Len(c_Obs01)<50,Len(c_Obs01),50))
			c_Obs02:= Substr(c_Obs02,1,IIf(Len(c_Obs02)<50,Len(c_Obs01),50))
			c_Obs03:= Substr(c_Obs03,1,IIf(Len(c_Obs03)<50,Len(c_Obs01),50))
			c_Obs04:= Substr(c_Obs04,1,IIf(Len(c_Obs04)<50,Len(c_Obs01),50))
			c_Obs05:= Substr(c_Obs05,1,IIf(Len(c_Obs05)<50,Len(c_Obs01),50))
			c_Obs06:= Substr(c_Obs06,1,IIf(Len(c_Obs06)<50,Len(c_Obs01),50))
			c_Obs07:= Substr(c_Obs07,1,IIf(Len(c_Obs07)<50,Len(c_Obs01),50))
			c_Obs08:= Substr(c_Obs08,1,IIf(Len(c_Obs08)<50,Len(c_Obs01),50))
			c_Obs09:= Substr(c_Obs09,1,IIf(Len(c_Obs09)<50,Len(c_Obs01),50))
			c_Obs10:= Substr(c_Obs10,1,IIf(Len(c_Obs10)<50,Len(c_Obs01),50))
		EndIf
			
			
		n_LinObs	:=	n_Lin+2390
		o_Printer:Box(n_Lin+2322,0032,n_Lin+2667,1131)//,2320)
		o_Printer:Say(n_Lin+2365,0070,"Observacoes:"	,o_Aria10,,0)
		o_Printer:Say(n_LinObs	,0070,c_Obs01			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs02			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs03			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs04			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs05			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs06			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs07			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs08			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs09			,o_Aria10,,0)
		n_LinObs	+=	25
		o_Printer:Say(n_LinObs	,0070,c_Obs10			,o_Aria10,,0)
		//Totais de impostos / fretes e total geral
		n_TotIpi	:= 	MaFisRet(,'NF_VALIPI')
		n_TotIcms  	:= 	MaFisRet(,'NF_VALICM')
		n_TotDesp  	:= 	MaFisRet(,'NF_DESPESA')
		n_TotFrete 	:= 	MaFisRet(,'NF_FRETE')
		n_TotSeguro	:= 	MaFisRet(,'NF_SEGURO')
		n_TotalNF  	:= 	MaFisRet(,'NF_TOTAL')
		
		SM4->(dbSetOrder(1))
		If SM4->(dbSeek(xFilial("SM4")+SC7->C7_REAJUST))
			//oReport:PrintText(  STR0014 + " " + SC7->C7_REAJUST + " " + SM4->M4_DESCR ,nLinPC, 050 )  //"Reajuste :"
		EndIf

		c_TotIPI	:= 	Transform(xMoeda(n_TotIPI 	,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) 	, tm(n_TotIpi 	,14,MsDecimais(MV_PAR12)))
		c_TotICMS	:=	Transform(xMoeda(n_TotIcms	,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) 	, tm(n_TotIcms	,14,MsDecimais(MV_PAR12)))
		c_TotFrete	:=	Transform(xMoeda(n_TotFrete	,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) 	, tm(n_TotFrete	,14,MsDecimais(MV_PAR12)))
		c_TotDesp	:=	Transform(xMoeda(n_TotDesp 	,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) 	, tm(n_TotDesp 	,14,MsDecimais(MV_PAR12)))
		c_TotSeguro	:=	Transform(xMoeda(n_TotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),n_TxMoeda) 	, tm(n_TotSeguro,14,MsDecimais(MV_PAR12)))
		c_TotalNF	:=	Transform(n_TotalNF		,tm(n_TotalNF 		,14,MsDecimais(MV_PAR12)))
	
		o_Printer:Box(n_Lin+2322,1131,n_Lin+2451,1729)
		o_Printer:Say(n_Lin+2365,1220,Padr("IPI....: ",10)+c_TotIPI	,o_Aria10,,0)
		o_Printer:Say(n_Lin+2390,1220,Padr("ICMS...: ",10)+c_TotICMS	,o_Aria10,,0)
		
		o_Printer:Box(n_Lin+2322,1729,n_Lin+2451,2320)
		o_Printer:Say(n_Lin+2365,1831,Padr("Frete......: ",14)+c_TotFrete	,o_Aria10,,0)
		o_Printer:Say(n_Lin+2390,1831,Padr("Despesas...: ",14)+c_TotDesp		,o_Aria10,,0)
		o_Printer:Say(n_Lin+2410,1831,Padr("Seguro.....: ",14)+c_TotSeguro	,o_Aria10,,0)

		o_Printer:Box(n_Lin+2451,1131,n_Lin+2567,2320)
		o_Printer:Say(n_Lin+2495,1507,Padr("Total Geral: ",14)+c_TotalNF,o_Aria10,,0)
		

		//Compradores / Aprovadores
		c_Comprador	:= ""
		c_Alter	  	:= ""
		c_Aprov	  	:= ""
		l_NewAlc	:= .F.
		l_Liber 	:= .F.

		dbSelectArea("SC7")
		//Incluida validação para os pedidos de compras por item do pedido  (IP/alçada)
		c_TipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")

		If c_TipoSC7 == "PC"

			dbSelectArea("SCR")
			dbSetOrder(1)
			If !dbSeek(xFilial("SCR")+c_TipoSC7+SC7->C7_NUM)
				dbSeek(xFilial("SCR")+"IP"+SC7->C7_NUM)
			EndIf

		Else

			dbSelectArea("SCR")
			dbSetOrder(1)
			dbSeek(xFilial("SCR")+c_TipoSC7+SC7->C7_NUM)
		EndIf

		If !Empty(SCR->CR_APROV) .Or. (Empty(SCR->CR_APROV) .And. SCR->CR_TIPO == "IP")

			l_NewAlc := .T.
			c_Comprador := UsrFullName(SC7->C7_USER)
			If SC7->C7_CONAPRO != "B"
				l_Liber := .T.
			EndIf

			While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO $ "PC|AE|IP"
				c_Aprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
				Do Case
					Case SCR->CR_STATUS=="02" //Pendente
					c_Aprov += "BLQ"
					Case SCR->CR_STATUS=="03" //Liberado
					c_Aprov += "Ok"
					Case SCR->CR_STATUS=="04" //Bloqueado
					c_Aprov += "BLQ"
					Case SCR->CR_STATUS=="05" //Nivel Liberado
					c_Aprov += "##"
					OtherWise                 //Aguar.Lib
					c_Aprov += "??"
				EndCase
				c_Aprov += "] - "
				dbSelectArea("SCR")
				dbSkip()
			Enddo
			If !Empty(SC7->C7_GRUPCOM)
				dbSelectArea("SAJ")
				dbSetOrder(1)
				dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
				While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
					If SAJ->AJ_USER != SC7->C7_USER
						If SAJ->(FieldPos("AJ_MSBLQL") > 0)
							If SAJ->AJ_MSBLQL == "1"
								dbSkip()
								LOOP
							EndIf
						EndIf
						c_Alter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
					EndIf
					dbSelectArea("SAJ")
					dbSkip()
				EndDo
			EndIf
		EndIf

		//Status do pedido
		o_Printer:Box(n_Lin+2567,1131,n_Lin+2667,2320)
		If !l_NewAlc
			o_Printer:Say(n_Lin+2600,1232,"P E D I D O   L I B E R A D O",o_Aria10,,0)
		Else
			If l_Liber
				o_Printer:Say(n_Lin+2600,1232,"P E D I D O   L I B E R A D O",o_Aria10,,0)
			Else
				o_Printer:Say(n_Lin+2600,1232,"P E D I D O   B L O Q U E A D O",o_Aria10,,0)
			EndIf
		Endif
				
		o_Printer:Box(n_Lin+2667,0032,n_Lin+2905,2320)
		o_Printer:Say(n_Lin+2700,0060,"Comprador Responsavel...: "+c_Comprador	,o_Aria10,,0)
		o_Printer:Say(n_Lin+2742,0060,"Compradores Alternativos: "+c_Alter		,o_Aria10,,0)
	
		If !l_NewAlc
				
			o_Printer:Say(n_Lin+2791,0060,"Aprovadores.............: "+c_Aprov		,o_Aria10,,0)
				
		Else
			o_Printer:Say(n_Lin+2791,0060,"Aprovadores.............: "+c_Aprov		,o_Aria10,,0)
			
		EndIf

		o_Printer:Box(n_Lin+2847,0032,n_Lin+2905,1367)
		o_Printer:Say(n_Lin+2875,0058,"Legendas de Aprovacao: BLQ: Bloqueado |  OK: Liberado  |  ??: Aguardando Liberacao  |  ##: Nivel Liberado  ",o_Aria10,,0)
		o_Printer:Say(n_Lin+2930,0058,"NOTA: So aceitaremos sua mercadoria se na sua nota fiscal constar nosso pedido de compras.",o_Aria10,,0)

	Next n_Vias

	MaFisEnd()


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava no SC7 as Reemissoes e atualiza o Flag de impressao.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	dbSelectArea("SC7")
	If Len(a_RecnoSave) > 0
		For n_X :=1 to Len(a_RecnoSave)
			dbGoto(a_RecnoSave[n_X])
			If(SC7->C7_QTDREEM >= 99)
				If n_Ret == 1
					RecLock("SC7",.F.)
					SC7->C7_EMITIDO := "S"
					MsUnLock()
				Elseif n_Ret == 2
					RecLock("SC7",.F.)
					SC7->C7_QTDREEM := 1
					SC7->C7_EMITIDO := "S"
					MsUnLock()
				Elseif n_Ret == 3
					//cancelar
				Endif
			Else
				RecLock("SC7",.F.)
				SC7->C7_QTDREEM := (SC7->C7_QTDREEM + 1)
				SC7->C7_EMITIDO := "S"
				MsUnLock()
			Endif
		Next n_X
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona o SC7 com base no ultimo elemento do aRecnoSave. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbGoto(a_RecnoSave[Len(a_RecnoSave)])
	Endif

	//Aadd(a_PedMail,a_Pedido)

	a_RecnoSave := {}

	dbSelectArea("SC7")
	dbSkip()

EndDo

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ChkPergUs ³ Autor ³ Nereu Humberto Junior ³ Data ³21/09/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para buscar as perguntas que o usuario nao pode     ³±±
±±³          ³ alterar para impressao de relatorios direto do browse      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ChkPergUs(ExpC1,ExpC2,ExpC3)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Id do usuario                                     ³±±
±±³          ³ ExpC2 := Grupo de perguntas                                ³±±
±±³          ³ ExpC2 := Numero da sequencia da pergunta                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChkPergUs(cUserId,cGrupo,cSeq)

	Local aArea  := GetArea()
	Local cRet   := Nil
	Local cParam := "MV_PAR"+cSeq

	dbSelectArea("SXK")
	dbSetOrder(2)
	If dbSeek("U"+cUserId+cGrupo+cSeq)
		If ValType(&cParam) == "C"
			cRet := AllTrim(SXK->XK_CONTEUD)
		ElseIf 	ValType(&cParam) == "N"
			cRet := Val(AllTrim(SXK->XK_CONTEUD))
		ElseIf 	ValType(&cParam) == "D"
			cRet := CTOD((AllTrim(SXK->XK_CONTEUD)))
		Endif
	Endif

	RestArea(aArea)
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110FIniPC³ Autor ³ Edson Maricate        ³ Data ³20/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa as funcoes Fiscais com o Pedido de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R110FIniPC(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Numero do Pedido                                  ³±±
±±³          ³ ExpC2 := Item do Pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110,MATR120,Fluxo de Caixa                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R110FIniPC(cPedido,cItem,cSequen,cFiltro)

	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local cValid		:= ""
	Local nPosRef		:= 0
	Local nItem		:= 0
	Local cItemDe		:= IIf(cItem==Nil,'',cItem)
	Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
	Local cRefCols	:= ''
	DEFAULT cSequen	:= ""
	DEFAULT cFiltro	:= ""

	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
		MaFisEnd()
		MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
		While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
		SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

			// Nao processar os Impostos se o item possuir residuo eliminado
			If &cFiltro
				dbSelectArea('SC7')
				dbSkip()
				Loop
			EndIf

			// Inicia a Carga do item nas funcoes MATXFIS
			nItem++
			MaFisIniLoad(nItem)
			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek('SC7')
			While !EOF() .AND. (X3_ARQUIVO == 'SC7')
				cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
				cValid	:= StrTran(cValid,"'",'"')
				If "MAFISREF" $ cValid
					nPosRef  := AT('MAFISREF("',cValid) + 10
					cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
					// Carrega os valores direto do SC7.
					MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
				EndIf
				dbSkip()
			End
			MaFisEndLoad(nItem,2)
			dbSelectArea('SC7')
			dbSkip()
		End
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110Logo  ³ Autor ³ Materiais             ³ Data ³07/01/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna string com o nome do arquivo bitmap de logotipo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R110Logo()

	Local cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao encontrar o arquivo com o codigo do grupo de empresas ³
	//³ completo, retira os espacos em branco do codigo da empresa   ³
	//³ para nova tentativa.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cBitmap )
		cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao encontrar o arquivo com o codigo da filial completo,  ³
	//³ retira os espacos em branco do codigo da filial para nova    ³
	//³ tentativa.                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cBitmap )
		cBitmap := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se ainda nao encontrar, retira os espacos em branco do codigo³
	//³ da empresa e da filial simultaneamente para nova tentativa.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cBitmap )
		cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao encontrar o arquivo por filial, usa o logo padrao     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cBitmap )
		cBitmap := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
	EndIf

Return cBitmap


//============== teste ====================
user function PCOMT005()
Local c_Alias	:=	"SC7"
Local n_Reg		:=	(c_Alias)->(Recno())
Local n_Opcx	:=	1

//PCOMR005( c_Alias, n_Reg, l_File )
Private c_Anexo:=	u_PCOMR005("SC7"	, n_Reg	  ,.T.)

If valtype(c_Anexo) == "C"
	If !Empty(c_Anexo)
		Alert(c_Anexo)
	Endif
Endif

Return


Static Function f_Cabec(c_Alias,n_Reg,l_File)
Local l_Ret		:=	.T.
Local a_SC7Area	:=	SC7->(GetArea())
Local a_SM0Area	:=	SM0->(GetArea())
Private	c_Imag001	:=	R110Logo()//SupergetMV("FS_LOGOPC",.F.,"C:\Totvs\P12\protheus_data_BOMIX\system\lgrl01.bmp")
//Private n_Lin	:=	0100

If SC7->(Recno()) <> n_Reg
	SC7->(dbGoTo(n_Reg))
Endif

SM0->(dbSetOrder(1))  
If SM0->(!dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))
	Conout("Fonte: PCOMR005 - Pedido Grafico no. "+SC7->C7_NUM+" filial "+SC7->C7_FILENT+" nao encontrada no cadastro de empresas.")
	l_Ret	:=	.F.
Else
	o_Printer:Box(n_Lin+0015,0030,n_Lin+0268,1101)
	o_Printer:SayBitMap(n_Lin+0060,0040,c_Imag001,0226,0043)

	o_Printer:Say(n_Lin+0130,0044,"EMPESA: "+SM0->(Substr(M0_NOMECOM,1,30))								,o_Aria10,,0)	//"EMPESA: BOMIX ENGENHARIA LTDA"
	o_Printer:Say(n_Lin+0160,0044,"ENDERECO: "+SM0->(Substr(M0_ENDENT,1,50))							,o_Aria10,,0)	//"ENDERECO: 12345678901234567890123456789012345678901234567890"
	o_Printer:Say(n_Lin+0190,0044,"CEP: "+Trans(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP"))				,o_Aria10,,0)	//"CEP: XX.XXX-XXX"
	o_Printer:Say(n_Lin+0190,0429,"CIDADE: "+SM0->(Substr(M0_CIDENT,1,40))								,o_Aria10,,0)	//"CIDADE: 1234567890123456789012345678901234567890"
	o_Printer:Say(n_Lin+0220,0044,"TEL: "+SM0->M0_TEL													,o_Aria10,,0)	//"TEL: 55-12-12345-1234"
	o_Printer:Say(n_Lin+0220,0431,"FAX> "+SM0->M0_FAX													,o_Aria10,,0)	//"FAX: 55-12-12345-1234"
	o_Printer:Say(n_Lin+0250,0044,"CNPJ/CPF: "+Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC"))			,o_Aria10,,0)	//"CNPJ/CPF: 12.123.123/1234-12"
	o_Printer:Say(n_Lin+0250,0431,"IE: "+InscrEst()														,o_Aria10,,0) 	//"IE: 12345678901234567890"

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))
	
	o_Printer:Box(n_Lin+0015,1106,n_Lin+0271,2320)
	o_Printer:Say(n_Lin+0045,1134,"P E D I D O  D E  C O M P R A S  - REAIS"							,o_Aria14N,,0)
	o_Printer:Say(n_Lin+0045,1880,SC7->C7_NUM															,o_Aria14N,,0) 	//"123456 /1"
	o_Printer:Say(n_Lin+0090,1878,"1a.Emissao   1a.Via"													,o_Aria10,,0)
	o_Printer:Say(n_Lin+0160,1920,"Codigo: "+SC7->C7_FORNECE+" / Loja: "+SC7->C7_LOJA					,o_Aria10,,0) 	//"Codigo: 123456  Loja: 12"
	o_Printer:Say(n_Lin+0160,1131,"EMPRESA: "+SA2->(Substr(A2_NOME,1,40))   							,o_Aria10,,0) 	//"EMPRESA: 1234567890123456789012345678901234567890"
	o_Printer:Say(n_Lin+0190,1131,"ENDERECO: "+Substr(SA2->A2_END,1,40)									,o_Aria10,,0)	//"ENDERECO: 1234567890123456789012345678901234567890"
	o_Printer:Say(n_Lin+0190,1920,"BAIRRO: "+Substr(SA2->A2_BAIRRO,1,20)								,o_Aria10,,0)	//"BAIRRO: 1234567890123456789"
	o_Printer:Say(n_Lin+0220,1131,"MUNICIPIO: "+Left(SA2->A2_MUN, 20)									,o_Aria10,,0)	//"MUNICIPIO: 12345678901234567890"
	o_Printer:Say(n_Lin+0220,1565,"ESTADO: "+SA2->A2_EST												,o_Aria10,,0)	//"ESTADO: 12 "
	o_Printer:Say(n_Lin+0220,1720,"CEP: "+SA2->A2_CEP													,o_Aria10,,0)	//"CEP: 12.123-123"
	cCGC	:= Transform(SA2->A2_CGC,Iif(SA2->A2_TIPO == 'F',Substr(PICPES(SA2->A2_TIPO),1,17),Substr(PICPES(SA2->A2_TIPO),1,21)))
	o_Printer:Say(n_Lin+0220,1920,"CNPJ/CPF: "+cCGC														,o_Aria10,,0)	//"CNPJ/CPF: 12.123.123-1234-12"			
	o_Printer:Say(n_Lin+0250,1131,"TEL: "+ "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) 	,o_Aria10,,0) 	//"TEL: 55-12-12345-1234"
	o_Printer:Say(n_Lin+0250,1442,"FAX: "+"("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)	,o_Aria10,,0)	//"FAX: 55-12-12345-1234"
	o_Printer:Say(n_Lin+0250,1745,"IE:"+SA2->A2_INSCR													,o_Aria10,,0)	//"IE: 12345678901234567890"

	o_Printer:Box(n_Lin+0273,0032,n_Lin+0315,2320)
	o_Printer:Say(n_Lin+0302,0042,"ITEM",o_Aria10,,0)
	o_Printer:Say(n_Lin+0302,0126,"PRODUTO",o_Aria10,,0)
	o_Printer:Say(n_Lin+0302,0371,"DESCRICAO",o_Aria10,,0)
	o_Printer:Say(n_Lin+0302,0872,"UM",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,0970,"QUANTIDADE",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,1155,"2a.UN",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,1271,"QT.2a.UN",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,1446,"Valor Unitar",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,1645,"% IPI",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,1738,"Valor  Total",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,1929,"DT.Entreg",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,2095,"CC",o_Aria10,,0) //menos 70
	o_Printer:Say(n_Lin+0302,2198,"No.Solic",o_Aria10,,0) //menos 70

	o_Printer:Box(n_Lin+0324,0032,n_Lin+2000,0114) //item 
	o_Printer:Box(n_Lin+0324,0114,n_Lin+2000,0354) //produto
	o_Printer:Box(n_Lin+0324,0354,n_Lin+2000,0849) //descricao //menos 70
	o_Printer:Box(n_Lin+0324,0849,n_Lin+2000,0924) //um //menos 70
	o_Printer:Box(n_Lin+0324,0924,n_Lin+2000,1141) //quantidade //menos 70
	o_Printer:Box(n_Lin+0324,1141,n_Lin+2000,1229) //2a.un //menos 70
	o_Printer:Box(n_Lin+0324,1229,n_Lin+2000,1423) //qt.2a.un //menos 70
	o_Printer:Box(n_Lin+0324,1423,n_Lin+2000,1624) //valor unit. //menos 70
	o_Printer:Box(n_Lin+0324,1624,n_Lin+2000,1726) //%ipi //menos 70
	o_Printer:Box(n_Lin+0324,1726,n_Lin+2000,1906) //valor total //menos 70
	o_Printer:Box(n_Lin+0324,1906,n_Lin+2000,2081) //Dt.Entreg. //menos 70
	o_Printer:Box(n_Lin+0324,2081,n_Lin+2000,2186) //CC //menos 70
	o_Printer:Box(n_Lin+0324,2186,n_Lin+2000,2320) //No.Solic //menos 70

Endif

Return(l_Ret)

//======================= pedido grafico - modelo de teste ======================

User Function PCOMTT05()

Local 	c_Arquivo	:=	"PCOMR005_"+SC7->C7_NUM+"_"+DtoS(ddatabase)+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)+".pdf"
Private o_Aria10  	:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private o_Aria12  	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
Private o_Aria14N	:=	TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
Private o_Aria16N	:=	TFont():New("Arial",,16,,.T.,,,,,.F.,.F.)
Private o_Printer
Private c_StartPath		:=	GetSrvProfString ("StartPath","\System\")
Private	l_AdjustToLegacy:= 	.T.
Private	l_DisableSetup  := 	.T.
Private	c_Pasta			:= 	"\system\"//SUPERGetMV("FS_AXFLUIG",.F.,"\spool\fluig\anexos\") //Anexos Fluig  //"C:\totvs\Protheus11\Protheus_Data_oficial\fluig\anexos\PC\"	cArquivo			:=	"Z1TR110"+dtos(ddatabase)+substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)+"_"+__CUSERID+".PDF"

o_Printer				:=	FWMSPrinter():New(c_Arquivo,	IMP_PDF, l_AdjustToLegacy,c_Pasta, l_DisableSetup,,,,,,.F.)

o_Printer:LVIEWPDF		:=	.F.
o_Printer:cPathPDF		:= 	c_Pasta
o_Printer:SetResolution(72)
//o_Printer:SetLandscape()
o_Printer:SetPortrait()
o_Printer:SetPaperSize(DMPAPER_A4)
o_Printer:SetMargin(10,10,10,10)
o_Printer:SetPortrait()

Private PixelX 		:= 	o_Printer:nLogPixelX()
Private PixelY 		:= 	o_Printer:nLogPixelY()

o_Printer:StartPage()

printPage()

o_Printer:EndPage()

o_Printer:Preview()

FreeObj(o_Printer)
o_Printer 			:= 	Nil
/*
Private a_Files 	:= 	{} // O array recebera os nomes dos arquivos e do diretorio
Private a_Sizes 	:= 	{} // O array recebera os tamanhos dos arquivos e do diretorio
Private c_RootPath	:=	GetSrvProfString ("RootPath","C:\TOTVS\P12\protheus_data")
Private	c_PastaCompleta	:= c_RootPath + c_StartPath 	
Private	a_Ret 		:= 	{}

ADir(c_PastaCompleta+c_Arquivo, a_Files, a_Sizes)

AADD(a_Ret, 	c_StartPath)
AADD(a_Ret, 	c_Arquivo)
AADD(a_Ret, 	c_PastaCompleta)

If !empty(a_Sizes) .and. !empty(a_Files) .and. Len(a_Files) == 1
	AADD(a_Ret, 	a_Sizes[len(a_Sizes)])

	alert(c_PastaCompleta+c_Arquivo)
Else
	AADD(a_Ret, 	0)
Endif

//  o_Printer:Setup()
//  o_Printer:SetPortrait()
//  o_Printer:StartPage()
//  printPage()
//  o_Printer:Preview()
*/

Return(c_Pasta+c_Arquivo)

Static Function printPage()
  Local n_Lin	:=	0100
  Private	c_Imag001	:=	R110Logo()//"C:\Totvs\P12\protheus_data_BOMIX\system\lgrl01.bmp"
	  
  o_Printer:Box(n_Lin+0015,0030,n_Lin+0268,1101)

  o_Printer:SayBitMap(n_Lin+0060,0040,c_Imag001,0226,0043)

  o_Printer:Say(n_Lin+0130,0044,"EMPESA: BOMIX ",o_Aria10,,0)

  o_Printer:Say(n_Lin+0160,0044,"ENDERECO: 12345678901234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+0190,0044,"CEP: XX.XXX-XXX",o_Aria10,,0)

  o_Printer:Say(n_Lin+0190,0429,"CIDADE: 1234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+0220,0044,"TEL: 55-12-12345-1234",o_Aria10,,0)

  o_Printer:Say(n_Lin+0220,0431,"FAX: 55-12-12345-1234",o_Aria10,,0)

  o_Printer:Say(n_Lin+0250,0044,"CNPJ/CPF: 12.123.123/1234-12",o_Aria10,,0)

  o_Printer:Say(n_Lin+0250,0431,"IE: 12345678901234567890",o_Aria10,,0)

  o_Printer:Box(n_Lin+0015,1106,n_Lin+0271,2320)

  o_Printer:Say(n_Lin+0045,1134,"P E D I D O  D E  C O M P R A S  - REAIS",o_Aria14N,,0)

  o_Printer:Say(n_Lin+0045,1880,"123456 /1",o_Aria14N,,0)

  o_Printer:Say(n_Lin+0090,1878,"1a.Emissao   1a.Via",o_Aria10,,0)

  o_Printer:Say(n_Lin+0160,1920,"Codigo: 123456  Loja: 12",o_Aria10,,0)

  o_Printer:Say(n_Lin+0160,1131,"EMPRESA: 1234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+0190,1131,"ENDERECO: 1234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+0190,1920,"BAIRRO: 1234567890123456789",o_Aria10,,0)

  o_Printer:Say(n_Lin+0220,1131,"MUNICIPIO: 12345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+0220,1565,"ESTADO: 12 ",o_Aria10,,0)

  o_Printer:Say(n_Lin+0220,1720,"CEP: 12.123-123",o_Aria10,,0)

  o_Printer:Say(n_Lin+0220,1920,"CNPJ/CPF: 12.123.123-1234-12",o_Aria10,,0)

  o_Printer:Say(n_Lin+0250,1131,"TEL: 55-12-12345-1234",o_Aria10,,0)

  o_Printer:Say(n_Lin+0250,1442,"FAX: 55-12-12345-1234",o_Aria10,,0)

  o_Printer:Say(n_Lin+0250,1745,"IE: 12345678901234567890",o_Aria10,,0)

  o_Printer:Box(n_Lin+0273,0032,n_Lin+0315,2320)
 
  o_Printer:Say(n_Lin+0302,0042,"ITEM",o_Aria10,,0)

  o_Printer:Say(n_Lin+0302,0126,"PRODUTO",o_Aria10,,0)

  o_Printer:Say(n_Lin+0302,0371,"DESCRICAO",o_Aria10,,0)

  o_Printer:Say(n_Lin+0302,0872,"UM",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,0970,"QUANTIDADE",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,1155,"2a.UN",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,1271,"QT.2a.UN",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,1446,"Valor Unitar",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,1645,"% IPI",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,1738,"Valor  Total",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,1929,"DT.Entreg",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,2095,"CC",o_Aria10,,0) //menos 70

  o_Printer:Say(n_Lin+0302,2198,"No.Solic",o_Aria10,,0) //menos 70

  o_Printer:Box(n_Lin+0324,0032,n_Lin+2000,0114) //item 

  o_Printer:Box(n_Lin+0324,0114,n_Lin+2000,0354) //produto

  o_Printer:Box(n_Lin+0324,0354,n_Lin+2000,0849) //descricao //menos 70

  o_Printer:Box(n_Lin+0324,0849,n_Lin+2000,0924) //um //menos 70

  o_Printer:Box(n_Lin+0324,0924,n_Lin+2000,1141) //quantidade //menos 70

  o_Printer:Box(n_Lin+0324,1141,n_Lin+2000,1229) //2a.un //menos 70

  o_Printer:Box(n_Lin+0324,1229,n_Lin+2000,1423) //qt.2a.un //menos 70

  o_Printer:Box(n_Lin+0324,1423,n_Lin+2000,1624) //valor unit. //menos 70

  o_Printer:Box(n_Lin+0324,1624,n_Lin+2000,1726) //%ipi //menos 70

  o_Printer:Box(n_Lin+0324,1726,n_Lin+2000,1906) //valor total //menos 70

  o_Printer:Box(n_Lin+0324,1906,n_Lin+2000,2081) //Dt.Entreg. //menos 70

  o_Printer:Box(n_Lin+0324,2081,n_Lin+2000,2186) //CC //menos 70

  o_Printer:Box(n_Lin+0324,2186,n_Lin+2000,2320) //No.Solic //menos 70

  o_Printer:Say(n_Lin+0335+0020,0049,"1234",o_Aria10,,0) //Item

  o_Printer:Say(n_Lin+0335+0020,0135,"123456789012345",o_Aria10,,0) //Produto

  o_Printer:Say(n_Lin+0335+0020,0375,"123456789012345678901234567890",o_Aria10,,0) //Descrição

  o_Printer:Say(n_Lin+0335+0020,0875,"12",o_Aria10,,0) //UN

  o_Printer:Say(n_Lin+0335+0020,0954,"12345678.1234",o_Aria10,,0) //Qt

  o_Printer:Say(n_Lin+0335+0020,1171,"12",o_Aria10,,0) //2a UN

  o_Printer:Say(n_Lin+0335+0020,1241,"12345678.1234",o_Aria10,,0) //Qt 2a UN

  o_Printer:Say(n_Lin+0335+0020,1437,"12345678.1234",o_Aria10,,0) //Preco unit

  o_Printer:Say(n_Lin+0335+0020,1652,"123",o_Aria10,,0) //Ipi

  o_Printer:Say(n_Lin+0335+0020,1745,"12345678.12",o_Aria10,,0) //valor total

  o_Printer:Say(n_Lin+0335+0020,1920,"DD/MM/AAAA",o_Aria10,,0) //Entreg

  o_Printer:Say(n_Lin+0335+0020,2104,"1234",o_Aria10,,0) //CC

  o_Printer:Say(n_Lin+0335+0020,2200,"123456",o_Aria10,,0) //Num Sc

  o_Printer:Box(n_Lin+2020,0032,n_Lin+2100,2320)

  o_Printer:Say(n_Lin+2065,0080,"DESCONTOS --> 000.00 %  000.00 %  000.00 %   12345678.12",o_Aria10,,0)

  o_Printer:Box(n_Lin+2100,0032,n_Lin+2218,2320)
  //							 1234567890123456789012345678901234567890123456789012345678
  o_Printer:Say(n_Lin+2142,0060,"Local de Entrega: 1234567890123456789012345678901234567890",o_Aria10,,0)
  //							 1234567890123456789012345678901
  o_Printer:Say(n_Lin+2142,1036,"Municipio: 12345678901234567890",o_Aria10,,0)
  //							 1234567890
  o_Printer:Say(n_Lin+2142,1521,"Estado: 12",o_Aria10,,0)
  //							 123456789012345
  o_Printer:Say(n_Lin+2142,1689,"CEP: 12.123-123",o_Aria10,,0)

  o_Printer:Say(n_Lin+2169,1521,"Estado: 12",o_Aria10,,0)

  o_Printer:Say(n_Lin+2169,1689,"CEP: 12.123-123",o_Aria10,,0)

  o_Printer:Say(n_Lin+2171,0060,"Local de Cobranca: 1234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+2171,1036,"Municipio: 12345678901234567890",o_Aria10,,0)

  o_Printer:Box(n_Lin+2218,0032,n_Lin+2322,0849)

  o_Printer:Say(n_Lin+2245,0067,"Condicao de pagamento: 123",o_Aria10,,0)

  o_Printer:Say(n_Lin+2285,0067,"123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Box(n_Lin+2218,0849,n_Lin+2657,1131)

  o_Printer:Say(n_Lin+2245,0889,"Data de Emissao:",o_Aria10,,0)

  o_Printer:Say(n_Lin+2285,0899,"DD/MM/AAAA",o_Aria10,,0)

  o_Printer:Box(n_Lin+2218,1131,n_Lin+2657,2320)

  o_Printer:Say(n_Lin+2245,1491,"Total das Mercadorias: 1234567890123.12",o_Aria10,,0)

  o_Printer:Say(n_Lin+2285,1491,"Total com Impostos....: 1234567890123.12",o_Aria10,,0)

  o_Printer:Box(n_Lin+2322,0032,n_Lin+2667,2320)

  o_Printer:Say(n_Lin+2365,0070,"Observacoes:",o_Aria10,,0)

  o_Printer:Say(n_Lin+2390,0070,"0001 - 1234567890123456789012345678901234567891234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+2415,0070,"0002 - 1234567890123456789012345678901234567891234567890",o_Aria10,,0)

  //o_Printer:Box(n_Lin+2657,1131,n_Lin+2102,2303)

  o_Printer:Box(n_Lin+2322,1131,n_Lin+2451,1729)

  o_Printer:Say(n_Lin+2365,1220,"IPI....: 1234567890.12",o_Aria10,,0)

  o_Printer:Say(n_Lin+2390,1220,"Frete: 1234567890.12",o_Aria10,,0)

  o_Printer:Box(n_Lin+2322,1729,n_Lin+2451,2320)

  o_Printer:Say(n_Lin+2365,1831,"ICMS......: 1234567890.12",o_Aria10,,0)

  o_Printer:Say(n_Lin+2390,1831,"Despesas: 1234567890.12",o_Aria10,,0)

  o_Printer:Say(n_Lin+2410,1831,"Seguro....: 1234567890.12",o_Aria10,,0)

  o_Printer:Box(n_Lin+2451,1131,n_Lin+2567,2320)

  o_Printer:Say(n_Lin+2495,1507,"Total Geral: 12345678901234.12",o_Aria10,,0)

  o_Printer:Box(n_Lin+2567,1131,n_Lin+2667,1731)

  o_Printer:Say(n_Lin+2600,1232,"PEDIDO LIBERADO/BLOQUEADO",o_Aria10,,0)

  o_Printer:Box(n_Lin+2667,0032,n_Lin+2905,2320)

  o_Printer:Say(n_Lin+2700,0060,"Comprador Responsavel: 1234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+2742,0060,"Compradores Alternativos: 123456789012345678901234567890123456789012345678901234567890",o_Aria10,,0)

  o_Printer:Say(n_Lin+2791,0060,"Aprovadores: ",o_Aria10,,0)

  o_Printer:Box(n_Lin+2847,0032,n_Lin+2905,1367)

  o_Printer:Say(n_Lin+2875,0058,"Legendas de Aprovacao: BLQ: Bloqueado |  OK: Liberado  |  ??: Aguardando Liberacao  |  ##: Nivel Liberado  ",o_Aria10,,0)

  o_Printer:Say(n_Lin+2930,0058,"NOTA: So aceitaremos sua mercadoria se na sua nota fiscal constar nosso pedido de compras.",o_Aria10,,0)
  //900
  //800
Return


