#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"    


User Function FGPER001()
	Local c_Perg		:= "FGPER001"
	Private oArial10  	:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
	Private oArial30  :=	TFont():New("Arial",,25,,.T.,,,,,.F.,.F.)
	Private oArial13N	:=	TFont():New("Arial",,13,,.T.,,,,,.F.,.F.)
	Private oArial14N	:=	TFont():New("Arial Narrow",,14,,.T.,,,,,.F.,.F.)
	Private oArial11N	:=	TFont():New("Arial Narrow",,11,,.T.,,,,,.F.,.F.)
	Private oArial8N	:=	TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)
	Private oArial7N	:=	TFont():New("Arial Narrow",,7,,.T.,,,,,.F.,.F.)
	Private oArial10N	:=	TFont():New("Arial",,12,,.T.,,,,,.F.,.F.)
     

	Private o9N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private o10N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oArial10N	:=	TFont():New("Arial Narrow",,10,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("FGPER001")
	Private o_Telas	:= clsTelasGen():New()

//	Private l_Opcao	:= o_Telas:mtdOkCancel("Janela de Teste da Classe TestaTelas","Esta rotina tem a finaldade de", "Imprimir o abono pecuniario", "Desenvolvido pela Totvs Bahia")
	Private l_Opcao	:= o_Telas:mtdParOkCan("Abono Pecuniario","Esta rotina tem a finaldade de", "imprimir o abono pecuniario", "Desenvolvido pela Totvs Bahia","FGPER001")

	If l_Opcao

		//imprime relat�rio do oPrinter
		f_ValidPerg(c_Perg)
		if !Pergunte(c_Perg,.T.)
			Return()
		endif
		oPrinter:Setup()
		oPrinter:SetPortrait()
		oPrinter:StartPage()
		printPage()
		oPrinter:Preview()
		Return()

	EndIf

Return()



Static Function printPage()


	f_Consulta()
	DBSELECTAREA("QRY")

	IF QRY->(EOF())

		AVISO("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")

		QRY->(DBCLOSEAREA())
		Return()

	ENDIF

	WHILE	QRY->(!EOF())

		c_CNPJ		:= SM0->M0_CGC //Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
		d_inicio	:= MV_PAR03
		d_final	:= MV_PAR04
		c_Nome  	:= QRY->RA_NOME
		c_Cargo 	:= QRY->RA_CARGO
		c_Cpf	 	:= Transform(QRY->RA_CIC ,"@R 999.999.999-99")
		d_Emissao 	:= cValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + cValToChar(Year(dDataBase)) //STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase),4) )
		c_Dcargo 	:= QRY->Q3_DESCSUM
		c_Mat 		:= QRY->RA_MAT
		d_Per1		:= DTOC(MV_PAR01)
		d_Per2		:= DTOC(MV_PAR02)
		c_Cidade	:= SM0->M0_CIDCOB
		c_Empresa 	:= "BOMIX INDUSTRIA DE EMBALAGENS LTDA."//SM0->M0_NOMECOM
		c_aquisitivo:= d_Per1 + ' a ' + d_Per1

		//oPrinter:Box(0040,0046,3259,2370)/*Margem*/
		oPrinter:Box(0066,0074,0179,2352)
		oPrinter:Say(0071,0534,"Solicita��o de Abono de F�rias",oArial30,,8421504)
		oPrinter:Box(0177,0074,0237,1201)
		oPrinter:Box(0177,1204,0237,2352)
		oPrinter:Say(0184,0091,"Empresa: " + c_Empresa ,oArial13N,,0)
		oPrinter:Say(0188,1215,"CNPJ:" + c_CNPJ,oArial13N,,0)
		oPrinter:Say(0293,0161,"Colaborador: -" + c_Mat+ "  " + c_Nome,oArial11N,,0)
		oPrinter:Say(0348,0165,"Cargo:   -  " + c_Cargo ,oArial11N,,0)
		oPrinter:Say(0411,0165,"CPF: - " + c_Cpf ,oArial11N,,0)
		oPrinter:Say(0800,0360,"Em cumprimento ao disposto no par�grafo 1. do Artigo 143 do Decreto_Lei n�mero 1535 de 13 de Abril de ",oArial8N,,0)
   	    oPrinter:Say(0850,0360,"1977, venho pelo presente requerer o ABONO PECUNI�RIO de 1/3 (um ter�o) das f�rias referente per�odo ",oArial8N,,0)
		oPrinter:Say(0900,0360,"aquisitivo de "+ c_aquisitivo ,oArial8N,,0)
		//oPrinter:Say(0857,0758," "+ d_Per1,oArial7N,,0)
		//oPrinter:Say(0855,1080," "+ d_Per2,oArial7N,,0)
		oPrinter:Say(1104,0360," "+ c_Cidade + " , " + d_Emissao ,oArial8N,,0)
		oPrinter:Box(1337,0360,1340,1101)
		oPrinter:Box(1340,1215,1342,1976)
		oPrinter:Say(1348,0360," " + c_Empresa ,o10N,,0)
		oPrinter:Say(1348,1350," " + c_Nome ,oArial10N,,0)
		oPrinter:Box(0066,0074,0179,2352)
		oPrinter:EndPage()
		oPrinter:Box(0066,0074,0179,2352)

		//finaliza p�gina aqui
		QRY->(DBSKIP())

	ENDDO

	QRY->(DBCLOSEAREA())

Return

static function f_Consulta()

	cQuery := "SELECT RA_MAT, RA_NOME, RA_CIC, RA_CARGO, Q3_DESCSUM "
	cQuery +=" FROM " + RetSqlName("SRA") + " SRA , " + RetSqlName("SQ3") + " SQ3 "
	cQuery +=" WHERE RA_FILIAL = '" + xFilial("SRA") +"' "
	//cQuery +=" AND Q3_FILIAL = '" + xFilial("SQ3") +"' "
	cQuery +=" AND Q3_CARGO = RA_CARGO "
	cQuery +=" AND RA_MAT BETWEEN '" + MV_PAR03 +"' AND '" + MV_PAR04 +"' "
	cQuery +=" AND SRA.D_E_L_E_T_ <> '*' "
	cQuery +=" AND SQ3.D_E_L_E_T_ <> '*' "

	TCQUERY  cQuery NEW ALIAS QRY

return

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}

	Aadd(a_PAR01, "Informe a data do periodo")
	Aadd(a_PAR01, "aquisitivo inicial")
	Aadd(a_PAR02, "Informe a data do periodo")
	Aadd(a_PAR02, "aquisitivo inicial")
	Aadd(a_PAR03, "Informe a matricula de")
	Aadd(a_PAR04, "Informe a matricula ate")
	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Periodo Aquisitivo Inicial?","","","mv_ch0","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Periodo Aquisitivo Final?","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
	PutSx1(c_Perg,"03","Matricula Colaborador de?   ","","","mv_ch2","C",06,0,0,"G","","SRA","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)
	PutSx1(c_Perg,"04","Matricula Colaborador ate?   ","","","mv_ch3","C",06,0,0,"G","","SRA","","","mv_PAR04","","","","","","","","","","","","","","","","",a_PAR04)

Return()
