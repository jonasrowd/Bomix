#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"


User Function FGPER004()

	Local c_Perg		:= "FGPER004"
	Private o_Telas	:= clsTelasGen():New()
    Private l_Opcao	:= o_Telas:mtdOkCancel("Relacao de Funcionarios","Esta rotina tem a finaldade de imprimir a relacao de funcionarios.", "Desenvolvido pela Totvs Bahia", "")


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
	DBGOTOP()
	If SRA->( Eof() )
		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		Return()
	Endif

	//imprime cabe�alho
	f_header ()
	While SRA->( !Eof() ) 
	
	 If SRA->RA_SITFOLH <> ' '
	 	SRA->(dbskip() )
	 	loop
	 endif	

		DbSelectArea("SRJ")
		SRJ->( DbSetOrder(1) )
		SRJ->( DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC ))
			n_Row := n_Row + 50
			c_Matricula	:=	 	SRA->RA_MAT
			c_Nome		    :=	 	SRA->RA_NOME
			c_Demissa		:=	 	SRA->RA_ADMISSA
			c_Cargo		:=  	SRJ->RJ_DESC
			c_CartPonto  	:=  	SRA->RA_CRACHA

			f_grid(n_Row)
			oPrinter:Say(n_Row + 16,0109,c_Matricula,o9N,,0)
			oPrinter:Say(n_Row + 16,0401,c_Nome,o9N,,0)
			oPrinter:Say(n_Row + 16,1140,dtoc(c_Demissa),o9N,,0)
			oPrinter:Say(n_Row + 16,1412,c_Cargo,o9N,,0)
			oPrinter:Say(n_Row + 16,2046,c_CartPonto,o9N,,0)
			n_Count++
			//quebra de p�gina a cada 56 registro
			if (MOD(n_Count, 56) = 0)
				//imprime cabe�alho
				f_header ()
				oPrinter:Box(0177,0098,0288,2321)
				n_Row := 0442

				n_Count:= 0
				oPrinter:EndPage()
			ENDIF
	
		SRA->( DbSkip() )

	Enddo

Return

Static Function f_RelatPadrao()

	Private oArial30  	:=	TFont():New("Arial",,30,,.F.,,,,,.F.,.F.)
	Private o11N			:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private o9N			:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
	Private o10N			:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("Rela��o de Empregados")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

//--------------------------------------------------------------
/*/{Protheus.doc}  f_header
Description  tela de op��o de impress�o
@param     xParam Parameter Description
@return    xRet Return Description
@author  - Ivan Amado
@since     04/05/2015
/*/
Static Function f_header()

	//oPrinter:Box(0044,0046,3257,2366)/*Margem*/
	//box cabe�alho
	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	//cabe�alho
	oPrinter:Say(0175,0742,"Rela��o de Empregados",oArial30,,0)
	oPrinter:Box(0288,0098,0340,1505)
	oPrinter:Box(0288,1505,0340,2321)
	oPrinter:Say(0293,0128,"Empresa :" + ALLTRIM(SM0->M0_NOMECOM),o11N,,0)
	oPrinter:Say(0300,1530,"CNPJ: "  + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),o9N,,0)
	//box matricula
	oPrinter:Box(0362,0102,0428,0392)
	//box nome
	oPrinter:Box(0362,0392,0428,1132)
	//box demiss�o
	oPrinter:Box(0362,1134,0428,1400)
	//box cargo
	oPrinter:Box(0362,1403,0428,2034)
	//box Cart�o de Ponto
	oPrinter:Box(0362,2034,0428,2319)
	oPrinter:Say(0380,0109,"MATR�CULA",o10N,,0)
	oPrinter:Say(0380,0400,"NOME",o10N,,0)
	oPrinter:Say(0380,1140,"ADMISS�O",o10N,,0)
	oPrinter:Say(0380,1471,"CARGO",o10N,,0)
	oPrinter:Say(0380,2040,"CRACH�",o10N,,0)

Return

Static Function f_grid(n_line)

  Local  n_altura := n_line + 60
  //  n_line := + 10
   //box matricula
	oPrinter:Box(n_line + 10 ,0102,n_altura,0392)
	//box nome
	oPrinter:Box(n_line + 10,0392,n_altura,1132)
	//box demiss�o
	oPrinter:Box(n_line + 10,1134,n_altura,1400)
	//box cargo
	oPrinter:Box(n_line + 10 ,1403,n_altura,2034)
	//box Cart�o de Ponto
	oPrinter:Box(n_line + 10,2034,n_altura,2319)

Return