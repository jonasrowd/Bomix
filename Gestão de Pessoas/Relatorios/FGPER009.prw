#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER009()

	Local c_Perg		  := "FGPER009" 
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Ficha Recastramento","Esta rotina tem a finaldade de", "imprimir a ficha para recastramento", "Desenvolvido pela Totvs Bahia","FGPER009")
               

	If l_Opcao

		f_RelatPadrao()

	Else

		Return()

	EndIf

Return


Static Function f_RelatPadrao()

	Private cImag001	:=	"C:\Users\ivan.cardoso\Documents\TDS\Workspace\TDS112\BOMIX\IMAGENS\RODAPÉ.png"
	Private o14N	:=	TFont():New("",,13,,.T.,,,,,.F.,.F.)
	Private oVerda10N		:=	TFont():New("Verdana",,10,,.T.,,,,,.F.,.F.)
	Private oVerdan10  	:=	TFont():New("Verdana",,12,,.F.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("DEVOLUCAO DA CARTEIRA DE TRABALHO")

	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

Static Function printPage()

	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	SRA->( DbSeek(xFilial("SRA")+ mv_par01 ))

	If SRA->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	IF SRA->(!Eof() )

		c_Cbo       := ""
		c_Funcao    := ""
		dbSelectArea("SQ3")
		SQ3->( DbSetOrder(1) )
		SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO ))
		DbSelectArea("SRJ")
		SRJ->( DbSetOrder(1) )
		If SRJ->( DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC) )
			c_Cbo    := Alltrim(SRJ->RJ_CODCBO)
			c_Funcao := Alltrim(SRJ->RJ_DESC)
		Endif
		//If Alltrim(SRA->RA_SITFOLH) == " "
		c_Nome			:= SRA->RA_MAT+" - "+Alltrim( SRA->RA_NOME )
		c_Ctps			:= Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
		c_Cbo			:= c_Cbo
		d_Admissa		:= SRA->RA_ADMISSA
		c_Local		:= SM0->M0_CIDENT
		c_Matricula	:= Alltrim(SRA->RA_MAT )
		c_Funcao		:= c_Funcao
		n_enter		:=	30
		//Endif
		//oPrinter:Box(0044,0046,3257,2403)/*Margem*/
		oPrinter:Box(n_enter + 0098,0140,0250,2279)
		oPrinter:Say(n_enter + 0127,0199,"COMPROVANTE DE DEVOLUÇÃO DA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL",o14N,,0)
		oPrinter:Say(n_enter + 0524,0212,"Nome do Empregado: "  + c_Nome,oVerdan10,,0)
		oPrinter:Say(n_enter + n_enter + 0628,0203,"Carteira de Trabalho: " + c_Ctps ,oVerdan10,,0)
		oPrinter:Say(n_enter + 0713,0203,"CBO: " + c_Cbo,oVerdan10,,0)
		oPrinter:Say(n_enter + 0713,0578,"Função: " + c_Funcao ,oVerdan10,,0)
		oPrinter:Say(n_enter + 0722,1640,"Admissão: "+ dtoc(d_Admissa),oVerdan10,,0)
		n_enter := n_enter + 50
		oPrinter:Say(n_enter + 0982,0177,"Recebi em devolução a carteira de trabalho e previdencia social acima, com as respectivas anotações.",oVerdan10,,0)
		oPrinter:Say(n_enter + 1384,1103, alltrim(c_Local) + ",  ______\______\______" ,oVerdan10,,0)
		oPrinter:Box(n_enter + 1656,1085,n_enter + 1656,2060)
		oPrinter:Say(n_enter + 1700,1103,alltrim(c_nome),oVerdan10,,0)
		oPrinter:SayBitMap(n_enter + 2980,0261,cImag001,1811,0217)
	endif

Return

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}
	Aadd(a_PAR01, "Informe a matricula do colaborador")
	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch0","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()

