#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "Topconn.CH"

#DEFINE ENTER CHR(13)+CHR(10)

#DEFINE IMP_SPOOL 2
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*/{Protheus.doc} PCOMR002
Programa responsavel pela impressao do Pedido de compas grafico

@author Francisco
@since 11/11/2016
@version 11.8

@param nTipo, numeric, Tipo do relatorio
@param cImprime, characters, P=Protheus F=Fluig
@type function
/*/
User Function PCOMR002( nTipo, cImprime )
	Private a_AreaC7	:= SC7->(GetArea())
	Private nLinha := 0
	Private nLinFim:= 0
	//Private aAlias := SC7->(GetArea())//getarea()
	Private c_SC7ALIAS
	


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamar funcao para validacao de CNPJ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private o_vldTemp  	 := clsVldTemplate():new()

	Private oPrn

	/*If	!o_vldTemp:mtdMapaCotacaoExcel()

		RestArea(a_SD1Area)
		RestArea(a_SF1Area)
		RestArea(a_SC7Area)
		RestArea(a_SB1Area)
		RestArea(a_SA5Area)
		RestArea(a_SA1Area)
		RestArea(a_SA2Area)

		Return()

	Endif*/

	If valtype(nTipo) == "N"

		mv_par01 := SC7->C7_NUM
		mv_par02 := SC7->C7_NUM
		mv_par03 := SC7->C7_EMISSAO
		mv_par04 := SC7->C7_EMISSAO

		mv_par05 := 2
		mv_par06 := "C7_DESCRI"
		mv_par07 := 3
		mv_par08 := 1
		mv_par09 := 1
		mv_par10 := 3
		mv_par11 := 3
		mv_par12 := 1
		mv_par13 := " "
		mv_par14 := 1

	Else

		If !Pergunte("MTR110",.T.)
			Return()
		EndIf

	Endif

	lAdjustToLegacy := .T.
	lDisableSetup  := .T.

	If cImprime == "P" //Impressao Protheus

		n_Flags := PD_ISTOTVSPRINTER + PD_DISABLEDESTINATION + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW
		oPrn := FWPrintSetup():New(n_Flags, "PEDIDO DE COMPRAS")

		oPrn:SetProperty(PD_PRINTTYPE , 6)//PDF
		oPrn:SetProperty(PD_DESTINATION , 2)//Local
		oPrn:SetProperty(PD_MARGIN , {10,10,10,10})
		oPrn:SetProperty(PD_PAPERSIZE , 2)//A4
		oPrn:aOptions[PD_VALUETYPE] := AllTrim(GetTempPath())

		If 	oPrn:Activate() == PD_OK

			cArquivo:="PCOMR002.rel"
			oPrn:=FWMSPrinter():New(cArquivo,IMP_PDF,.T.,,.T.,,@oPrn)
			oPrn:SetResolution(72)
			oPrn:SetLandscape()
			oPrn:SetPaperSize(DMPAPER_A4)
			oPrn:SetMargin(10,10,10,10)

			Private PixelX := oPrn:nLogPixelX()
			Private PixelY := oPrn:nLogPixelY()

			Private li      :=_PROW()
			Private Titulo  :="PEDIDO DE COMPRAS"
			Private lEnvioOk:=.F.

			C110PC()//RptStatus({|lEnd| C110PC()},"Imprimindo Pedidos...")

			FreeObj(oPrn)

			oPrn := Nil

		Endif

	ElseIf cImprime == "F" //gera arquivo p/ envio de anexo para o fluig

		n_Flags	:= PD_ISTOTVSPRINTER + PD_DISABLEDESTINATION + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW
		oPrn 	:= 	FWPrintSetup():New(n_Flags, "PEDIDO DE COMPRAS")

		//oPrn:Activate()
		oPrn:SetProperty(PD_PRINTTYPE , 6)//PDF
		oPrn:SetProperty(PD_DESTINATION , 2)//Local
		oPrn:SetProperty(PD_MARGIN , {10,10,10,10})
		oPrn:SetProperty(PD_PAPERSIZE , 2)//A4
		//	oPrn:aOptions[PD_VALUETYPE] := AllTrim(GetTempPath())

		cArquivo			:=  "pedido_"+Alltrim(mv_par01)
		cPasta				:= 	"\system\"
		oPrn:aOptions[6] 	:= 	"spool\"
		oPrn				:=	FWMSPrinter():New(cArquivo,	IMP_PDF, lAdjustToLegacy,cPasta, lDisableSetup,,@oPrn,,,,.F.)
		oPrn:LVIEWPDF		:=	.F.
		oPrn:cPathPDF		:= 	cPasta

		oPrn:SetResolution(72)
		oPrn:SetLandscape()
		oPrn:SetPaperSize(DMPAPER_A4)
		oPrn:SetMargin(10,10,10,10)

		Private PixelX 		:= 	oPrn:nLogPixelX()
		Private PixelY 		:= 	oPrn:nLogPixelY()

		Private li      	:= _PROW()
		Private Titulo  	:= "PEDIDO DE COMPRAS"
		Private lEnvioOk	:= .F.

		C110PC()//RptStatus({|lEnd| C110PC()},"Imprimindo Pedidos...")
		//	cFilePrint := cPasta+cArquivo
		//	File2Printer( cFilePrint, "PDF" )

		//FreeObj(oPrn)
		oPrn := Nil


		/*_aFiles := {} // O array receberï¿½ os nomes dos arquivos e do diretï¿½rio
		_aSizes := {} // O array receberï¿½ os tamanhos dos arquivos e do diretorio
		cPastaCompleta	:=	"C:\TOTVS\PROTHEUS11\PROTHEUS_DATA_OFICIAL\spool\fluig\anexos\"
		ADir(cPastaCompleta+cArquivo+".PDF", _aFiles, _aSizes)

		aRet := {}
		AADD(aRet, 	cPasta)
		AADD(aRet, 	cArquivo+".PDF")
		AADD(aRet, 	cPastaCompleta)

		If !empty(_aSizes) .and. !empty(_aFiles) .and. Len(_aFiles) == 1
			AADD(aRet, 	_aSizes[len(_aSizes)])
		Else
			AADD(aRet, 	0)
		Endif*/

		//oPrn:Preview()
		RestArea(a_AreaC7)
		//Return(aRet)
	Endif

Return .T.

Static Function C110PC

	Private oFont, cCode

	oFont09s:= TFont():New( "Times New Roman",,09,,,,.t.,,,.f.)
	oFont09	:= TFont():New( "Times New Roman",,09,,.f.,,,,,.f.)
	oFont10	:= TFont():New( "Times New Roman",,10,,.f.,,,,,.f.)
	oFont12	:= TFont():New( "Times New Roman",,12,,.f.,,,,,.f.)
	oFont14	:= TFont():New( "Times New Roman",,14,,.f.,,,,,.f.)
	oFont16	:= TFont():New( "Times New Roman",,16,,.f.,,,,,.f.)
	oFont18	:= TFont():New( "Times New Roman",,18,,.f.,,,,,.f.)
	oFont20	:= TFont():New( "Times New Roman",,20,,.f.,,,,,.f.)
	oFont22 := TFont():New( "Times New Roman",,22,,.f.,,,,,.f.)
	oFont24	:= TFont():New( "Times New Roman",,24,,.f.,,,,,.f.)
	oFont28 := TFont():New( "Times New Roman",,28,,.f.,,,,,.f.)


	oFont10n:= TFont():New( "Times New Roman",,10,,.t.,,,,,.f.)
	oFont12n:= TFont():New( "Times New Roman",,12,,.t.,,,,,.f.)
	oFont14n:= TFont():New( "Times New Roman",,14,,.t.,,,,,.f.)
	oFont16n:= TFont():New( "Times New Roman",,16,,.t.,,,,,.f.)
	oFont18n:= TFont():New( "Times New Roman",,18,,.t.,,,,,.f.)
	oFont20n:= TFont():New( "Times New Roman",,20,,.t.,,,,,.f.)
	oFont22n:= TFont():New( "Times New Roman",,22,,.t.,,,,,.f.)
	oFont24n:= TFont():New( "Times New Roman",,24,,.t.,,,,,.f.)
	oFont28n:= TFont():New( "Times New Roman",,28,,.t.,,,,,.f.)

	Private tamanho     := "G"
	Private limite		:= 250


	aSavRec := {}

	limite   	:= 130
	li       	:= 80
	nTotNota 	:= 0
	nTotImp  	:= 0
	nTotIpi  	:= 0
	nTotIcms 	:= 0
	nTotFrete 	:= 0
	nTotDesp 	:= 0
	nTotSeguro 	:= 0
	nDescProd	:= 0
	nTotal   	:= 0
	nTotMerc 	:= 0
	NumPed   	:= Space(6)

	If ( cPaisLoc=="ARG" )
		cCondBus	:=	"1"+strzero(val(mv_par01),6)
		nOrder	:=	10
		nTipo		:= 1
	Else
		cCondBus	:=mv_par01
		nOrder	:=	16
	EndIf
	dbSelectArea("SC7")
	DbSetOrder(1)
	dbSeek(xFilial("SC7")+cCondBus,.T.)
	While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
	C7_NUM <= mv_par02

		nOrdem   := 1
		nPag := 1
		nReem    := 0
		cObs01   := " "
		cObs02   := " "
		cObs03   := " "
		cObs04   := " "

		If C7_EMITIDO == "S" .And. mv_par05 == 1
			dbSkip()
			Loop
		Endif
		If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
			dbSkip()
			Loop
		Endif
		If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
			dbSkip()
			Loop
		Endif
		If C7_TIPO == 2
			dbSkip()
			Loop
		EndIf

		If !MtrAValOP(mv_par11, 'SC7')
			dbSkip()
			Loop
		EndIf

		lLiberador := .F.
		//	If GetMV("MV_ALCADA") == "S"
		//If !File(cArqAlca)
		//			lLiberador := .F.
		//	EndIf

		oPrn:StartPage()

		ImpCabec()

		nBaseIPI 	:= 0
		nTotNota 	:= 0
		nTotImp 	:= 0
		nTotal   	:= 0
		nTotMerc 	:= 0
		nTotIpi  	:= 0
		nTotIcms 	:= 0
		nTotFrete 	:= 0
		nTotDesp 	:= 0
		nTotSeguro 	:= 0
		nDescProd	:= 0
		nReem    	:= SC7->C7_QTDREEM + 1
		nSavRec  	:= SC7->(Recno())
		NumPed   	:= SC7->C7_NUM
		nTotImp 	:= SC7->C7_VALIPI
		nTotProd 	:= 0
		nQtdProd 	:= 0
		nImpTot 	:= 0
		Produto 	:= SC7->C7_PRODUTO

		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed

			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif

			If li > nLinFim
				nOrdem++
				nPag++
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				oPrn:EndPage()
				oPrn:StartPage()
				ImpCabec()
			Endif

			li:=li+30
			oPrn:Say(li,0055,C7_ITEM,oFont10,100)
			oPrn:Say(li,0155,C7_PRODUTO,oFont10,100)

			ImpProd()

			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			nBaseIPI 	+= 	SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
			nTotIpi		+=	SC7->C7_VALIPI	//nTotIpi+NoRound(nBaseIPI*SC7->C7_IPI/100,2)
			nTotIcms 	+= 	SC7->C7_VALICM
			nTotFrete 	+= 	SC7->C7_VALFRE
			nTotDesp 	+= 	SC7->C7_DESPESA
			nTotSeguro 	+= 	SC7->C7_SEGURO
			nTotProd 	+= 	SC7->C7_TOTAL
			nQtdProd 	+= 	SC7->C7_QUANT
			nImpTot++
			li := li + 30

			dbSelectArea("SC7")
			dbSkip()

		EndDo

		dbGoto(nSavRec)

		If li>nLinFim
			nOrdem++
			nPag++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			oPrn:EndPage()
			oPrn:StartPage()
			ImpCabec()
		Endif

		FinalPed(nTotIcms, nTotIpi, nTotFrete, nDescProd, nTotProd, nTotDesp, nTotSeguro)		// Imprime os dados complementares do PC
		oPrn:EndPage()

		If Len(aSavRec)>0
			For i:=1 to Len(aSavRec)
				dbGoto(aSavRec[i])
				RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
				//Replace C7_QTDREEM With (C7_QTDREEM+1)
				Replace C7_EMITIDO With "S"
				MsUnLock()
			Next
			dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
		Endif

		aSavRec := {}

		dbSkip()
	EndDo

	dbSelectArea("SC7")
	Set Filter To
	dbSetOrder(1)

	dbSelectArea("SX3")
	dbSetOrder(1)

	oPrn:Preview()

	//MS_FLUSH()

Return .T.

Static Function ImpProd()

	LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0

	If Empty(mv_par06)
		mv_par06 := "B1_DESC"
	EndIf

	If AllTrim(mv_par06) == "B1_DESC"
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(SB1->B1_DESC)
		dbSelectArea("SC7")
	EndIf

	If AllTrim(mv_par06) == "B1_DESC"
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(SB1->B1_DESC)
		dbSelectArea("SC7")
	EndIf

	If AllTrim(mv_par06) == "B5_CEME"
		dbSelectArea("SB5")
		dbSetOrder(1)
		If dbSeek( xFilial()+SC7->C7_PRODUTO )
			cDescri := Alltrim(B5_CEME)
		EndIf
		dbSelectArea("SC7")
	EndIf

	dbSelectArea("SC7")
	If AllTrim(mv_par06) == "C7_DESCRI"
		cDescri := Alltrim(SC7->C7_DESCRI)
	EndIf

	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
		cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
	EndIf
	dbSelectArea("SC7")

	nLinha:= MLCount(cDescri,35)

	oPrn:Say(li,355,MemoLine(cDescri,35,1),oFont10,100)

	ImpCampos()

	For nBegin := 2 To nLinha
		li:=li+30
		If li > nLinFim
			nOrdem++
			ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
			oPrn:EndPage()
			oPrn:StartPage()
			ImpCabec()
		Endif

		oPrn:Say(li,355,MemoLine(cDescri,35,nBegin),oFont10,100)

	Next nBegin

	If !Empty(SC7->C7_OBS)
		li:=li+50
		oPrn:Box(li,350 ,li,900)
		cOBS  := "OBS: "+Alltrim(SC7->C7_OBS)
		nLinha:= MLCount(cOBS,35)
		li:=li+30
		oPrn:Say(li,355,MemoLine(cOBS,35,1),oFont10,100)
		For nBegin := 2 To nLinha
			li:=li+30
			If li > nLinFim
				nOrdem++
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				oPrn:EndPage()
				oPrn:StartPage()
				ImpCabec()
			Endif

			oPrn:Say(li,355,MemoLine(cOBS,35,nBegin),oFont10,100)

		Next nBegin

	Endif

	li:=li+50
	oPrn:Box(li,050 ,li,3000)

Return NIL

Static Function ImpCampos()

	nQTEntreg	:= SC7->C7_QUANT-SC7->C7_QUJE
	nPreco		:= SC7->C7_PRECO
	nQTOrig		:= SC7->C7_QUANT
	cUM			:= SC7->C7_UM
	c_Grupo		:= POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO, "B1_GRUPO")
	c_Fabric	:= POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO, "B1_FABRIC")

	dbSelectArea("SC7")
	c_CC 		:= POSICIONE( "CTT", 1, XFILIAL("CTT")+SC7->C7_CC,"CTT_DESC01")
	//c_Grupo 	:= POSICIONE( "SBM", 1, XFILIAL("SBM")+c_Grupo,"BM_DESC") //REPLICATE("X",10)) //IDENTIFICAR CAMPO
	dbSelectArea("SBM")
	dbSetOrder(1)
	dbSeek(xFilial("SBM") + c_Grupo )
	c_Grupo	:= SUBSTR(SBM->BM_DESC,1,12)

	c_NumCot 	:= SC7->C7_NUMCOT
	cC7_NUMSC	:= SC7->( C7_NUMSC + C7_ITEMSC )

	//oPrn:Say(li,0910,c_CC											,oFont10,100)
	oPrn:Say(li,1360,cUM													,oFont10,100)
	oPrn:Say(li,1460,Trans(nQTEntreg		,PesqPict("SC7","C7_QUANT"))		,oFont10,100)
	oPrn:Say(li,1660,'R$ ' + ALLTRIM(Trans(nPreco	,PesqPict("SC7","C7_PRECO")))		,oFont10,100)
	oPrn:Say(li,1860,'R$ ' + ALLTRIM(Trans(SC7->C7_TOTAL		,PesqPict("SC7","C7_TOTAL")))		,oFont10,100)
	oPrn:Say(li,2010,Trans(SC7->C7_PICM,PesqPict("SC7","C7_PICM"))		,oFont10,100)
	oPrn:Say(li,2207,Trans(SC7->C7_IPI,PesqPict("SC7","C7_IPI"))								,oFont10,100)
	oPrn:Say(li,2335,DTOC(SC7->C7_DATPRF)									,oFont10,100)
	oPrn:Say(li,2455,SC7->C7_CC											,oFont10,100)
	oPrn:Say(li,2655,SUBSTR(c_Fabric,1,10)												,oFont10,100)
	oPrn:Say(li,2880,cC7_NUMSC												,oFont10,100)

	nTotNota	:=	nTotNota+SC7->C7_TOTAL
	nTotImp 	+= 	SC7->C7_TOTAL
	nTotal  	:=	nTotal+SC7->C7_TOTAL
	nTotMerc	:=	SC7->C7_TOTAL


Return .T.

Static Function FinalPed(nTotIcms, nTotIpi, nTotFrete, nDescProd, nTotProd, nTotDesp, nTotSeguro)//FinalPed(nDescProd)

	Local nk 		:= 	1	,	lImpLeg 	:= 	.T.
	Local nQuebra 	:= 	0
	Local lNewAlc	:= 	.F.	,	cComprador	:=	""	,cAlter	:=	""	,cAprov	:=	""	,lLiber := .F.

	cFrete 			:= 	Iif(Empty(SC7->C7_TPFRETE) .Or. SC7->C7_TPFRETE == "S" ,"Sem Frete", Iif(SC7->C7_TPFRETE == "T" , "Por Conta de Terceiros",Iif(SC7->C7_TPFRETE=="F","FOB","CIF")))
	nvDesc1	   		:=	0//(nTotalNota * C7_DESC1)/100
	nvDesc2	   		:=	0//(nTotalNota * C7_DESC2)/100
	nvDesc3	   		:=	0//(nTotalNota * C7_DESC3)/100
	nTotDESC		:=	nDescProd + nvDesc1 + nvDesc2 + nvDesc3

	//nTotalNota 		:= 	nTotalNota + nTotFrete + nTotDesp + IIF(cFrete=="CIF", nTotFrete, 0)
	nTotalNota 		:= 	(nTotProd + nTotIPI + nTotFrete  + nTotDesp + nTotSeguro)- nTotDESC
	li 				:=	nLinFim
	oPrn:Box(li,050,li+100,3000) // box totais //oPrn:Box(1570,050,1670,3600)
	oPrn:Say(li+50,0100 ,"ICMS: R$ "							+Trans(nTotIcms		,"@E@R 999,999,999.99"),oFont10,100)
	oPrn:Say(li+50,0350 ,"IPI: R$ " 							+Trans(nTotIpi 		,"@E@R 999,999,999.99"),oFont10,100)
	oPrn:Say(li+50,0600	,"FRETE: R$ " 							+Trans(nTotFrete 	,"@E@R 999,999,999.99"),oFont10,100)
	oPrn:Say(li+50,1200	,"DESCONTO: R$ " 						+Trans(nTotDESC		,"@E@R 999,999,999.99"),oFont10,100)
	oPrn:Say(li+50,1600	,"TOTAL DOS MATERIAIS: R$ " 			+Trans(nTotProd		,"@E@R 999,999,999.99"),oFont10,100)
	oPrn:Say(li+50,2200	,"TOTAL COM IMPOSTOS E FRETE: R$ " 	+Trans(nTotalNota	,"@E@R 999,999,999.99"),oFont10,100)

	li				:=	li+100
	oPrn:Box(li,050	,li+200,3000) 	// 	box Observaï¿½ï¿½es //oPrn:Box(1700,050	,1900,3600)
	cC7_OBS := IIF(SC7->(FieldPos("C7_OBS")) >0, SC7->C7_OBS, "") //REPLICATE("X",250)) //SC7->C7_OBS
	oPrn:Say(li+30,060,SubStr(cC7_OBS,1  ,90),oFont10,100)
	oPrn:Say(li+60,060,SubStr(cC7_OBS,91 ,90),oFont10,100)
	oPrn:Say(li+90,060,SubStr(cC7_OBS,181,90),oFont10,100)

	oPrn:Box(li,1700	,li+200,1700) 	//	Divisoria para observaï¿½ï¿½es - mensagem do pedido
	//   012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678
	MensL1	:=	SUBSTR( SUPERGETMV("FS_MENS1",.F.,""),1,30 )
	MensL2	:=	SUBSTR( SUPERGETMV("FS_MENS2",.F.,""),1,30 )
	MensL3	:=	SUBSTR( SUPERGETMV("FS_MENS3",.F.,""),1,30 )
	MensL4	:=	SUBSTR( SUPERGETMV("FS_MENS4",.F.,""),1,30 )
	MensL5	:=	SUBSTR( SUPERGETMV("FS_MENS5",.F.,""),1,30 )
	MensL6	:=	SUBSTR( SUPERGETMV("FS_MENS6",.F.,""),1,30 )

	oPrn:Say(li+30 ,1710,MensL1,oFont10,100)
	oPrn:Say(li+60 ,1710,MensL2,oFont10,100)
	oPrn:Say(li+90 ,1710,MensL3,oFont10,100)
	oPrn:Say(li+120,1710,MensL4,oFont10,100)
	oPrn:Say(li+150,1710,MensL5,oFont10,100)
	oPrn:Say(li+180,1710,MensL6,oFont10,100)

Return .T.

Static Function ImpRodape()
	li:=li+30
	li:=li+30
	oPrn:Say(li,100,"Continua... ",oFont10,100)
	li:=li+30
	li:=0
Return .T.

Static Function ImpCabec()

	nLinha := 0040
	nLinFim:= 1850
	//Desenho do formulï¿½rio 1o. Cabecalho - dados da empresa
	oPrn:Box(nLinha+0060,0050 , nLinFim		,3000) 	//	box maior 						//oPrn:Box(055,050 ,1570,3000)
	oPrn:Box(nLinha+0340,0050 , nLinha+0340	,3000) 	// 	Linha horizontal cabeï¿½alho 		//oPrn:Box(450,050 , 453,3000)
	oPrn:Box(nLinha+0060,0320 , nLinha+0340	,0320) 	// 	Linha vertical cabeï¿½alho (1) 	//oPrn:Box(055,450 , 450,480)
	oPrn:Box(nLinha+0060,1000,  nLinha+0340	,1003) 	// 	Linha vertical cabeï¿½alho (2) 	//oPrn:Box(055,1000, 450,1003)
	oPrn:Box(nLinha+0060,2800,  nLinha+0340	,2803) 	// 	Linha vertical cabeï¿½alho (4) 	//oPrn:Box(055,2800, 450,2800)

	//Logo
	cBitMap:="LGMID99.Bmp"
	oPrn:SayBitmap( nLinha+0090,090,cBitMap,200,200) //oPrn:SayBitmap( 012,012,cBitMap,080,080)        //

	If ( cPaisLoc=="ARG" )
		cCepPict:="@R 9999"
		cCGCPict:="@R 99-99.999.999-9"
	Else
		cCepPict:="@R 99999-999"
		cCGCPict:="@R 99.999.999/9999-99"
	EndIf

	oPrn:Say(nLinha+0110,2850,"Folha"				 	,oFont10n,100)
	oPrn:Say(nLinha+0210,2850,"    "+Strzero(nPag,3) 	,oFont10n,100) // nordem

	oPrn:Say(nLinha+0360,600,IIf(nOrdem>1," - continuacao"," "),oFont10,100)

	oPrn:Say(nLinha+0100,600," PEDIDO DE COMPRAS"   	,oFont10n,100)
	oPrn:Say(nLinha+0150,600,"      No.: "+SC7->C7_NUM 	,oFont10n,100)
	oPrn:Say(nLinha+0200,600,"   DATA EMISSAO"      	,oFont10n,100)
	cEMISS := DTOS(SC7->C7_EMISSAO)
	cEMISS := SUBSTR(cEMISS,7,2)+"/"+ SUBSTR(cEMISS,5,2)+"/"+ SUBSTR(cEMISS,1,4)
	oPrn:Say(nLinha+0250,600,"      "+cEMISS			,oFont10n,100)

	SM0->(dbSetOrder(1))
	nRecnoSM0 := SM0->(Recno())
	SM0->(dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))

	oPrn:Say(nLinha+0100,1050,"Empresa : "+ SM0->M0_NOMECOM										,oFont10n,100)
	oPrn:Say(nLinha+0150,1050,"CNPJ    : "+ SM0->M0_CGC											,oFont10n,100)
	oPrn:Say(nLinha+0200,1050,"Endereï¿½o: "+ SM0->M0_ENDENT										,oFont10n,100)
	oPrn:Say(nLinha+0250,1050,"Cidade  : "+ Trim(SM0->M0_CIDENT)+"      UF: "+SM0->M0_ESTENT	,oFont10n,100)
	oPrn:Say(nLinha+0300,1050,"CEP     : "+ Trans(SM0->M0_CEPENT,cCepPict)						,oFont10n,100)

	SM0->(dbGoto(nRecnoSM0))

	cComprador 	:=	POSICIONE("SY1",1,xFILIAL("SY1")+SC7->C7_USER,"Y1_NOME")  //Replicate("X",30)
	cTel		:=	POSICIONE("SY1",1,xFILIAL("SY1")+SC7->C7_USER,"Y1_TEL")   //"(099) 99999-9999 / 99999-9999"
	cEmail		:=	POSICIONE("SY1",1,xFILIAL("SY1")+SC7->C7_USER,"Y1_EMAIL") //Replicate("X",30)
	oPrn:Say(nLinha+0100,2000,"Comprador: "+ cComprador										,oFont10n,100)
	oPrn:Say(nLinha+0150,2000,"Telefone : "+ cTel											,oFont10n,100)
	oPrn:Say(nLinha+0200,2000,"e-Mail   : "+ cEmail											,oFont10n,100)


	//Desenho do formulï¿½rio 2o. Cabecalho - dados do fornecedor e do pedido

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
	nLinha += 390
	oPrn:Say(nLinha			,0060 ,"Fornecedor: "+ SA2->A2_NOME										,oFont10n,100)
	oPrn:Say(nLinha+0050	,0060 ,"CNPJ......: "+ SA2->A2_CGC										,oFont10n,100)
	oPrn:Say(nLinha+0100	,0060 ,"Endereço..: "+ SA2->A2_END										,oFont10n,100)
	oPrn:Say(nLinha+0150	,0060 ,"Cidade....: "+ Trim(SA2->A2_MUN)+"      UF: "+SA2->A2_EST+" / CEP: "+ Trans(SA2->A2_CEP,cCepPict)		,oFont10n,100)
	//oPrn:Say(nLinha+0250	,0060 ,"CEP.......: "+ Trans(SA2->A2_CEP,cCepPict)						,oFont10n,100)

	cFrete:= 	Iif(Empty(SC7->C7_TPFRETE) .Or. SC7->C7_TPFRETE == "S" ,"Sem Frete", Iif(SC7->C7_TPFRETE == "T" , "Por Conta de Terceiros",Iif(SC7->C7_TPFRETE=="F","FOB","CIF")))
	cCond := Posicione("SE4",1,xFILIAL("SE4")+SC7->C7_COND,"E4_DESCRI")
	oPrn:Say(nLinha			,1000,"Telefone..............: ("+SA2->A2_DDD+") "+ SA2->A2_TEL			,oFont10n,100) //oPrn:Say(nLIni+020	,250,"Telefone..............: ("+SA2->A2_DDD+") "+ SA2->A2_TEL			,oFont10n,100)//
	oPrn:Say(nLinha+0050	,1000,"Vendedor..............: "+ SC7->C7_CONTATO						,oFont10n,100) //oPrn:Say(nLIni+030	,250,"Vendedor..............: "+ SC7->C7_CONTATO						,oFont10n,100)//
	oPrn:Say(nLinha+0100	,1000,"Condições de Pagamento: "+ cCond									,oFont10n,100) //oPrn:Say(nLIni+010	,250,"Condiï¿½ï¿½es de Pagamento: "+ cCond									,oFont10n,100)//
	oPrn:Say(nLinha+0150	,1000,"Frete.................: "+cFrete						 			,oFont10n,100) //oPrn:Say(nLIni+040	,250,"Frete.................: "+cFrete						 			,oFont10n,100)//

	oPrn:Box(nLinha-50,1600,nLinha+200,1603) // Linha vertical cabeï¿½alho (2) //oPrn:Box(050,1290,450,1293)

	//Desenho do formulï¿½rio Cabecalho - Linha Detalhe
	nLinha += 0200

	oPrn:Box(nLinha,0050,nLinha+3	,3000)  			// Linha horizontal separaï¿½ï¿½o dos itens
	oPrn:Box(nLinha+0120,0050		,nLinha+123,3000)  // Linha horizontal separaï¿½ï¿½o dos itens

	//linhas verticais divisorias dos itens:
	oPrn:Box(nLinha,0150 ,nLinFim,153) 			// item-cï¿½digo
	oPrn:Box(nLinha,0350 ,nLinFim,353) 			// cï¿½digo-descriï¿½ï¿½o
	//oPrn:Box(nLinha,0900,nLinFim,0903)			// descriï¿½ï¿½o-MARCA
	oPrn:Box(nLinha,1350,nLinFim,1353) 			// MARCA-UM
	oPrn:Box(nLinha,1450,nLinFim,1453) 			// Unidade-Quantidade Original
	oPrn:Box(nLinha,1650,nLinFim,1653) 			// Quantidade original-quantidade a receber
	oPrn:Box(nLinha,1850,nLinFim,1853) 			// Quantidade a receber-Valor unitï¿½rio
	oPrn:Box(nLinha,2000,nLinFim,2003) 			// Valor unitï¿½rio-valor total
	oPrn:Box(nLinha,2200,nLinFim,2203) 			// valor total-Ipi
	oPrn:Box(nLinha,2325,nLinFim,2328) 			// Ipi-Data de entrega
	oPrn:Box(nLinha,2450,nLinFim,2453) 			// Dt.Entrega-Aplicaï¿½ï¿½o
	oPrn:Box(nLinha,2650,nLinFim,2653) 			// Aplicaï¿½ï¿½o-Destino
	oPrn:Box(nLinha,2875,nLinFim,2878) 			// Destino-SC

	oPrn:Say(nLinha+50, 055,"Item" 				,oFont10,100)
	oPrn:Say(nLinha+50, 155,"Codigo" 			,oFont10,100)
	oPrn:Say(nLinha+50, 355,"Descricao" 		,oFont10,100)
	//oPrn:Say(nLinha+50,0905," Centro Custo" 	,oFont10,100)
	oPrn:Say(nLinha+50,1355," UM " 				,oFont10,100)
	oPrn:Say(nLinha+50,1455," Quant." 			,oFont10,100)
	oPrn:Say(nLinha+70,1455," Receber" 			,oFont10,100)
	oPrn:Say(nLinha+50,1655," Valor  " 			,oFont10,100)
	oPrn:Say(nLinha+70,1655," Unitario" 			,oFont10,100)
	oPrn:Say(nLinha+50,1855,"Valor  Total "  	,oFont10,100)
	oPrn:Say(nLinha+50,2055,"ICMS" 		,oFont10,100)
	oPrn:Say(nLinha+50,2255,"IPI  " 			,oFont10,100)
	oPrn:Say(nLinha+50,2330,"Dt.Entrega"  		,oFont10,100)
	oPrn:Say(nLinha+50,2455,"Centro Custo"		,oFont10,100)
	oPrn:Say(nLinha+50,2655,"Marca" 			,oFont10,100)
	oPrn:Say(nLinha+50,2880,"No.SC  " 			,oFont10,100)

	dbSelectArea("SC7")
	li := nLinha+150

Return .T.

