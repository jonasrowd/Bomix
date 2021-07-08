#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER009()

	Local c_Perg		  := "FGPER009"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("DEVOLUCAO DA CARTEIRA DE TRABALHO","Esta rotina tem a finaldade de imprimir o comprovante de devolucao da carteira de", "trabalho. ", "Desenvolvido pela Totvs Bahia","FGPER009")

	If l_Opcao

		f_ValidPerg(c_Perg)
		If !Pergunte(c_Perg,.T.)
				Return()
		Endif
		f_RelatPadrao()

	Else

		Return()

	EndIf

Return

Static Function f_RelatPadrao()

	Private cImag001	:=	"C:\Users\ivan.cardoso\Documents\TDS\Workspace\TDS112\BOMIX\IMAGENS\RODAP�.png"
	Private o14N	:=	TFont():New("",,13,,.T.,,,,,.F.,.F.)
	Private oVerda10N		:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
	Private oVerdan10  	:=	TFont():New("Verdana",,12,,.F.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("DEVOLUCAO DA CARTEIRA DE TRABALHO")

	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

Static Function printPage()

	Local	c_Cbo       := ""
	Local	c_Funcao    := ""

	BEGINSQL ALIAS "QRY"

		SELECT	RA_CARGO, RJ_CODCBO, RA_CODFUNC, RJ_CODCBO, RJ_DESC, RA_NOME, RA_NUMCP,
		RA_SERCP, RA_UFCP, RA_ADMISSA, RA_MAT
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SRJ% SRJ ON( SRJ.RJ_FUNCAO = SRA.RA_CODFUNC AND SRJ.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND SRJ.RJ_FILIAL = %EXP:XFILIAL("SRJ")%
		AND RA_MAT BETWEEN  %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		AND RA_SITFOLH = " "
		AND SRA.%NOTDEL%

	ENDSQL

	DBSELECTAREA("QRY")
	If QRY->( Eof() )

		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		QRY->(DBCLOSEAREA())
		Return()

	Endif

	While QRY->( !Eof() )

		c_Cbo    := Alltrim(QRY->RJ_CODCBO)
		c_Funcao := Alltrim(QRY->RJ_DESC)
		c_Nome	   := Alltrim( QRY->RA_NOME )
		c_Ctps	   := Alltrim(QRY->RA_NUMCP) + " - " + Alltrim(QRY->RA_SERCP) + " - " + Alltrim(QRY->RA_UFCP)
		d_Admissa	:= QRY->RA_ADMISSA
		  c_Local	:= SM0->M0_CIDENT
	  c_Matricula	:= Alltrim(SRA->RA_MAT )
        n_enter	:=	30

		//oPrinter:Box(0044,0046,3257,2403)/*Margem*/
	//	oPrinter:Box(n_enter + 0098,0140,0250,2279)
		oPrinter:Say(n_enter + 0127,0199,"COMPROVANTE DE DEVOLU��O DA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL",o14N,,0)
		oPrinter:Say(n_enter + 0524,0212,"Nome do Empregado: "  + c_Nome,oVerdan10,,0)
		oPrinter:Say(n_enter + n_enter + 0628,0203,"Carteira de Trabalho: " + c_Ctps ,oVerdan10,,0)
		oPrinter:Say(n_enter + 0713,0203,"CBO: " + c_Cbo,oVerdan10,,0)
		oPrinter:Say(n_enter + 0713,0578,"Fun��o: " + c_Funcao ,oVerdan10,,0)
		oPrinter:Say(n_enter + 0722,1640,"Admiss�o: "+ DtoC(StoD(d_Admissa)),oVerdan10,,0)
		n_enter := n_enter + 50
		oPrinter:Say(n_enter + 0982,0177,"Recebi em devolu��o a carteira de trabalho e previdencia social acima, com as respectivas anota��es.",oVerdan10,,0)
		oPrinter:Say(n_enter + 1384,1103, alltrim(c_Local) + ",  ______/______/______" ,oVerdan10,,0)
		oPrinter:Box(n_enter + 1656,1085,n_enter + 1656,2060)
		oPrinter:Say(n_enter + 1700,1103,alltrim(c_nome),oVerdan10,,0)
		oPrinter:SayBitMap(n_enter + 2980,0261,cImag001,1811,0217)

       oPrinter:EndPage()

	//	oPrinter:Box(n_enter + 0098,0140,0250,2279)

		QRY->(dbSkip())

	Enddo

	QRY->(DBCLOSEAREA())

Return

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}

	Aadd(a_PAR01, "Informe a Matricula de")
	Aadd(a_PAR02, "Informe a Matricula ate")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula de?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Matricula ate?   ","","","mv_ch2","C",06,0,0,"G","","SRA","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()
