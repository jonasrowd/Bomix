#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER011()           


	Local c_Perg		:= "FGPER011"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Termo de Prorrogacao","Esta rotina tem a finaldade de", "imprimir definicao o termo de prorrogacao", "Desenvolvido pela Totvs Bahia","FGPER011")

	If l_Opcao
		If !Pergunte()
			f_ValidPerg(c_Perg)
		EndIf
			f_RelatPadrao()
	Else
		Return()
	EndIf

Return

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}

	Aadd(a_PAR01, "Informe a matricula")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()

static Function f_RelatPadrao()
       
Local cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP"  
cImag001 := cBitmap 
	
	// Private	cImag001	:=	"D:\Sistemas\totvs\Protheus11\Protheus_Data\system\RODAPE.BMP"
	Private o14N			:=	TFont():New("",,14,,.T.,,,,,.F.,.F.)
	Private o10N			:=	TFont():New("",,12,,.F.,,,,,.F.,.F.)
	Private oVerda10N		:=	TFont():New("Verdana",,12,,.F.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("TERMO DE PRORROGACAO")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

Static Function printPage()

	// oPrinter:Box(0044,0046,3257,2403)/*Margem*/


	DbSelectArea("SRA")
	SRA->(DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA")+mv_par01))

	If SRA->(Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	If SRA->( !Eof() )
		//	If Alltrim(SRA->RA_SITFOLH) == " "
		c_Nome      := Alltrim(SRA->RA_NOME )
		c_Matricula := Alltrim(SRA->RA_MAT )
		c_Empresa 	:= Alltrim(SM0->M0_NOMECOM )
		//	Endif

		oPrinter:Say(0151,0835,"TERMO DE PRORROGAÇÃO",o14N,,0)

		oPrinter:Say(0491,0532,"Por mútuo acordo entre as partes o presente Contrato de Experiência que deveria ",o10N,,0)
		oPrinter:Say(0570,0522,"vencer em _____/_____/_____ , fica prorrogado até _____/_____/_____",oVerda10N,,0)

		oPrinter:Box(1093,0686,1093,1605)
		oPrinter:Box(1586,0676,1586,1605)
		oPrinter:Say(1102,0770,c_Empresa,oVerda10N,,0)
		oPrinter:Say(1604,0720,c_Nome,oVerda10N,,0)
		oPrinter:Say(1704,0900,"REGISTRO:  "+c_Matricula,oVerda10N,,0)
		oPrinter:SayBitMap(2766,0324,cImag001,1811,0218)
		SRA->( DbSkip())
	EndIf		

Return

