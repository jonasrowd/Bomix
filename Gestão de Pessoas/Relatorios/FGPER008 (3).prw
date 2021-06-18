#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

#DEFINE OLECREATELINK  400
#DEFINE OLECLOSELINK   401
#DEFINE OLEOPENFILE    403
#DEFINE OLESAVEASFILE  405
#DEFINE OLECLOSEFILE   406
#DEFINE OLESETPROPERTY 412
#DEFINE OLEWDVISIBLE   "206"
#DEFINE WDFORMATTEXT   "2"
#DEFINE WDFORMATPDF    "17" // FORMATO PDF
#DEFINE ENTER CHR(10)+CHR(13)
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

User Function FGPER008()
                                                                           

	Local c_Perg		:= "FGPER008"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Ficha Recastramento","Esta rotina tem a finaldade de", "imprimir a ficha para recastramento", "Desenvolvido pela Totvs Bahia","FGPER008")
	
//	f_ValidPerg()

	If l_Opcao

		f_RelatPadrao()

	Else

		Return()

	EndIf

Return

static Function f_RelatPadrao()
	Private cImag001	:=	"C:\Users\ivan.cardoso\Documents\TDS\Workspace\TDS112\BOMIX\IMAGENS\RODAPÉ.png"
	Private o12N		:=	TFont():New("",,12,,.T.,,,,,.F.,.F.)
	Private o10N		:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private o11N		:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private oArial10N	:=	TFont():New("Arial Narrow",,10,,.T.,,,,,.F.,.F.)
	Private o9N		:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
	Private oGadug10N	:=	TFont():New("Gadugi",,10,,.T.,,,,,.F.,.F.)
	Private oGadugi10 :=	TFont():New("Gadugi",,10,,.F.,,,,,.F.,.F.)
	Private o11  		:=	TFont():New("",,11,,.F.,,,,,.F.,.F.)
	Private oPrinter :=	tAvPrinter():New("Ficha de Cadastramento")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()
return

Static Function printPage()

	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA")+ mv_par01))
	If SRA->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Else
		DbSelectArea("SQ3")
		SQ3->( DbSetOrder(1) )
		SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO ))
		If Alltrim(SRA->RA_SITFOLH) == "A"  .or.  Empty(Alltrim(SRA->RA_SITFOLH))
		Do Case
		Case SRA->RA_ESTCIVI = "C"
			c_Estcivi := "Casado(a)"
		Case SRA->RA_ESTCIVI = "D"
			c_Estcivi := "D-Divorciado(a)"
		Case SRA->RA_ESTCIVI = "M"
			c_Estcivi := "Marital"
		Case SRA->RA_ESTCIVI = "Q"
			c_Estcivi := "Desquitado(a)/Separado(a)"
		Case SRA->RA_ESTCIVI = "S"
			c_Estcivi := "Solteiro(a)"
		Case SRA->RA_ESTCIVI = "V"
			c_Estcivi := "Viuvo(a)"
		EndCase
		c_Nome 		:= SRA->RA_NOME
		c_Matricula 	:= SRA->RA_MAT
		c_Cargo       := SQ3->Q3_DESCSUM
		c_Enderec     := SRA->RA_ENDEREC
		c_Complem     := SRA->RA_COMPLEM
		c_Bairro      := SRA->RA_BAIRRO
		c_Municip     := SRA->RA_MUNICIP
		c_Estado      := SRA->RA_ESTADO
		c_Cep         := SRA->RA_CEP
		c_DDDFone     := SRA->RA_DDDFONE
		c_Telefon     := SRA->RA_TELEFON
		c_DDDCelu     := SRA->RA_DDDCELU
		c_Numcelu     := SRA->RA_NUMCELU
		c_Estcivi     := c_EstCivi
		oPrinter:Box(0075,060,0380,2347)
		oPrinter:Say(0126,0812,"FICHA DE RECADASTRAMENTO",o12N,,0)
		oPrinter:Say(0168,0662,"EM CASO DE ALTERAÇÕES, PREENCHER O(S) CAMPOS ABAIXO",o10N,,0)
		oPrinter:Say(0317,0149,"Nome: " 		  + c_Nome, o11N,,0)
		oPrinter:Say(0315,1778,"Matricula: "     + c_Matricula,o11N,,0)
		oPrinter:Box(0402,0060,0480,2347)
		oPrinter:Say(0435,0165,"DADOS ATUAL",o10N,,0)
		oPrinter:Say(0435,1239,"CORREÇÃO",o10N,,0)

		n_lin  := 0480
		n_alt:= n_lin + 110
		for n_x := 1 to 9
			oPrinter:Box(n_lin,0060,n_alt,1110)
			oPrinter:Box(n_lin,1110,n_alt,2347)
			n_lin := n_lin + 110
			n_alt  := n_lin + 110
		next
		n_lin 		:= 0530
		n_enter 	:= 100
		oPrinter:Say(n_lin  ,0086,"Cargo: " + c_Cargo,o10N,,0)
		n_lin 		:=  n_lin  + n_enter
		oPrinter:Say(n_lin  ,0086,"Endereco: " + c_Enderec,o10N,,0)
		n_lin 		:=  n_lin  + n_enter
		oPrinter:Say(n_lin - 2 ,0086,"Complemento: " + c_Complem,o10N,,0)
		n_lin 		:=  n_lin  +  (n_enter + 10)

		oPrinter:Say(n_lin   ,0086,"CEP: " + c_Cep,oArial10N,,0)
		n_lin 		:=  n_lin + n_enter

		oPrinter:Say(n_lin   + 2  ,0086,"Bairro: " + c_Bairro,oArial10N,,0)
		n_lin 		:=  n_lin + (n_enter + 12)

		oPrinter:Say(n_lin  + 2,0086,"Cidade: "+ c_Municip ,oArial10N,,0)
		n_lin 		:= n_lin  + (n_enter + 15)

		oPrinter:Say(n_lin   ,0086,"Telefone: " + c_DDDCelu ,o9N,,0)
		n_lin 		:=  n_lin + n_enter

		oPrinter:Say(n_lin + 2   ,0086,"Estado Civil: " + c_Estcivi,o10N,,0)
		n_lin 		:=  n_lin + n_enter
		oPrinter:Say(n_lin + 2 ,0086,"Celular: " + c_Numcelu,o10N,,0)
		n_lin 		:=  n_lin + (n_enter + 60)

		oPrinter:Box(1643 ,0063,1644 - 171 ,2349)
		oPrinter:Say(n_lin,0436,"CASO DE EMERGENCIA COMUNICAR A QUEM NOME, TELEFONE E GRAU DE PARENTESCO ",o10N,,0)

		oPrinter:Box(1886 - 242,0063,2128 - 242,2349)
		oPrinter:Box(1886,0063,2128,2349)

		oPrinter:Say(1695,0240,"Perante ao RH de minha empresa, dentro de um prazo de 30 (trinta) dias, caso venha ocorrer alguma alteracao ",o10N,,0)
		oPrinter:Say(1748,0238,"OBS.: Declaro que as informacoes acima sao verdadeiras, bem como me comprometo desde ja a atualiza-las ",o10N,,0)
		oPrinter:Say(1797,0233,"dos meus dados pessoais.",o10N,,0)

		oPrinter:Box(1986,1227,1986,2097)
		oPrinter:Say(2000,1456,"Assinatura do Funcionario",o11N,,0)
		oPrinter:Say(1965,0154,"___/___/___",oArial10N,,0)
		oPrinter:Say(2000,0156,"  Data",o10N,,0)
		EndIf
		oPrinter:SayBitMap(2780,0261,cImag001,1811,0217)
	Endif
Return

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Aadd(a_PAR01, "Informe a matricula")
	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()

