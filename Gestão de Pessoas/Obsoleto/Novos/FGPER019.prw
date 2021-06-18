#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER019()

   Local c_Perg		:= "FGPER019"
   Private o_Telas	:= clsTelasGen():New()
   Private l_Opcao	:= o_Telas:mtdOkCancel("","Esta rotina tem a finaldade de imprimir a relacao de funcionarios.", "Desenvolvido pela Totvs Bahia", "")

	If l_Opcao

		f_RelatPadrao()

	Else

		Return()

	EndIf

Return

Static Function printPage()

	Local    n_pag 		 :=	0
	Local    n_Count      :=	0
	Local    c_Matricula  :=	 ''
	Local 	  c_Nome	     := ''
	Local	  c_Demissa	 :=	 ''
	Local	  c_Cargo	     := ''
	Local    c_CartPonto	  := ''
	Local 	  n_Row		  := 0370

	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA") ))
	If SRA->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	//imprime cabeçalho
	f_header ()
	While SRA->(!Eof())  //.AND. (SRA->RA_SITFOLH = "" .OR. SRA->RA_SITFOLH = "A")

		DbSelectArea("SRD")
		DbSetOrder(1)
		DbSeek(xFilial("SRD")+SRA->RA_MAT)

		DbSelectArea("SRC")
		DbSetOrder(1)
		DbSeek(xFilial("SRC")+SRA->RA_MAT)

			n_Row := n_Row + 50
			c_Matricula	:=	 SRA->RA_MAT
			c_Nome		    :=	 SRA->RA_NOME

			do Case
		  		Case SRA->RA_SITFOLH = ""
		  			c_Situacao  := "Normal"
		  		Case SRA->RA_SITFOLH = "A"
		  			c_Situacao  := "Afastado"
		  		Case SRA->RA_SITFOLH = "D"
		  			c_Situacao  := "Demitido"
		  		Case SRA->RA_SITFOLH = "F"
		  			c_Situacao  := "Ferias"
		  		Case SRA->RA_SITFOLH = "T"
		  			c_Situacao  := "Transferido"
	  		ENDCASE

			d_DataPgt		:=	 DTOC(SRD->RD_DATPGT)
			c_Salario  	:=  TRANSFORM(SRC->RC_VALOR, "@E 999,999,999.99")

			f_grid(n_Row)
			oPrinter:Say(n_Row + 16,0109,c_Matricula,o9N,,0)
			oPrinter:Say(n_Row + 16,0401,c_Nome,o9N,,0)
			oPrinter:Say(n_Row + 16,1140,c_Situacao ,o9N,,0)
			oPrinter:Say(n_Row + 16,1412,d_DataPgt,o9N,,0)
			oPrinter:Say(n_Row + 16,1700,c_Salario,o9N,,0)
			n_Count++

			//quebra de página a cada 56 registro
			if (MOD(n_Count, 56) = 0)
				//imprime cabeçalho
				f_header ()
				oPrinter:Box(0177,0098,0288,2321)
				n_Row := 0442

				n_Count:= 0
				oPrinter:EndPage()

			ENDIF
	//	Endif
		SRA->( DbSkip() )

	Enddo

Return

Static Function f_RelatPadrao()

	Private oArial30  	:=	TFont():New("Arial",,30,,.F.,,,,,.F.,.F.)
	Private o11N			:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private o9N			:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
	Private o10N			:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("RELACAO DE LIQUIDOS DA FOLHA")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

//--------------------------------------------------------------
/*/{Protheus.doc}  f_header
Description  tela de opção de impressão
@param     xParam Parameter Description
@return    xRet Return Description
@author  - Ivan Amado
@since     04/05/2015
/*/
Static Function f_header()

	//oPrinter:Box(0044,0046,3257,2366)/*Margem*/
	//box cabeçalho
	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	//cabeçalho
	oPrinter:Say(0175,0742,"Relação de Liquidos da Folha",oArial30,,0)
	oPrinter:Box(0288,0098,0340,1505)
	oPrinter:Box(0288,1505,0340,2321)
	oPrinter:Say(0293,0128,"Empresa :" + ALLTRIM(SM0->M0_NOMECOM),o11N,,0)
	oPrinter:Say(0300,1530,"CNPJ: "  + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),o9N,,0)
	//box matricula
	oPrinter:Box(0362,0102,0428,0392)
	//box nome
	oPrinter:Box(0362,0392,0428,1132)
	//box demissão
	oPrinter:Box(0362,1134,0428,1400)
	//box cargo
	oPrinter:Box(0362,1400,0428,1686)
	//box Cartão de Ponto
	oPrinter:Box(0362,1686,0428,2319)
	oPrinter:Say(0380,0109,"MATRÍCULA",o10N,,0)
	oPrinter:Say(0380,0400,"NOME",o10N,,0)
	oPrinter:Say(0380,1140,"SITUACAO",o10N,,0)
	oPrinter:Say(0380,1405,"PAGAMENTO",o10N,,0)
	oPrinter:Say(0380,1730,"VALOR",o10N,,0)

Return

Static Function f_grid(n_line)

  Local  n_altura := n_line + 60
  //  n_line := + 10
   //box matricula
	oPrinter:Box(n_line + 10 ,0102,n_altura,0392)
	//box nome
	oPrinter:Box(n_line + 10,0392,n_altura,1132)
	//box demissão
	oPrinter:Box(n_line + 10,1134,n_altura,1400)
	//box cargo
	oPrinter:Box(n_line + 10 ,1400,n_altura,1686)
	//box Cartão de Ponto
	oPrinter:Box(n_line + 10,1686,n_altura,2319)

Return


