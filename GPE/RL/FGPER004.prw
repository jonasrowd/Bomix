#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"

User Function FGPER004()

	Local c_Perg		:= "FGPER004"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Relacao de Funcionarios ","Esta rotina tem a finaldade de imprimir a relacao de funcionarios .", "Desenvolvido pela Totvs Bahia", "","FGPER005")

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

Static Function printPage()

	Local      n_pag 			:=	0
	Local      n_Count     	:=	0
	private    Matricula  	:=	''
	private 	c_Nome		    :=	''
	private 	d_Admissa		:=	''
	private 	c_Cargo		:=	''
	private 	c_CartPonto	:=	''
	private    nI				:=	0
	public 	n_Row	       := 0442
	c_Emp 	:= SM0->M0_NOMECOM
	c_CNPJ := SM0->M0_CGC

	BEGINSQL ALIAS "QRY"

		SELECT	RA_MAT, RA_NOME, RA_ADMISSA, RA_CRACHA, RJ_DESC
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SRJ% SRJ ON (SRJ.RJ_FUNCAO = SRA.RA_CODFUNC AND SRA.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND RA_ADMISSA BETWEEN  %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		--AND RA_SITFOLH = " "
		AND SRA.%NOTDEL%

	ENDSQL

	If !(Select("QRY") > 0 )
		QRY->(DBCLOSEAREA())
		DbSelectArea("QRY")
	Endif

	If QRY->( Eof() )

		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		QRY->(DBCLOSEAREA())
		Return()

	Endif

	//imprime cabe�alho
	f_header (c_Emp,c_CNPJ)
	While QRY->(!Eof())

			n_Row := n_Row + 50
			f_grid(n_Row - 20)
			c_Matricula	:=	 QRY->RA_MAT
			c_Nome		    :=	 QRY->RA_NOME
			d_Admissa		:=	 QRY->RA_ADMISSA
			c_Cargo		:=  QRY->RJ_DESC
			c_CartPonto  	:=  QRY->RA_CRACHA
			oPrinter:Say(n_Row,0109,c_Matricula,o9N,,0)
			oPrinter:Say(n_Row,0401,c_Nome,o9N,,0)
			oPrinter:Say(n_Row,1140, DtoC(StoD(d_Admissa)),o9N,,0)
			oPrinter:Say(n_Row,1412,c_Cargo,o9N,,0)
			oPrinter:Say(n_Row,2046,c_CartPonto,o9N,,0)
			n_Count++
			//quebra de p�gina a cada 56 registro
			If (MOD(n_Count, 56) = 0)

				n_Row := 0442
				n_Count:= 0
				oPrinter:EndPage()
				f_header (c_Emp,c_CNPJ)

			EndIf

		QRY->(DbSkip())

	Enddo

	QRY->(DBCLOSEAREA())

Return

Static Function f_RelatPadrao()

	Private oArial30  	:=	TFont():New("Arial",,30,,.F.,,,,,.F.,.F.)
	Private o11N			:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private o9N			:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
	Private o10N			:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("Rela��o de Funcionarios")
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
static function f_header (c_Emp,c_CNPJ)
	//oPrinter:Box(0044,0046,3257,2366)/*Margem*/
	//box cabe�alho
	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	//cabe�alho
	oPrinter:Say(0175,0742,"Rela��o de Funcionarios",oArial30,,0)
	oPrinter:Box(0288,0098,0340,1505)
	oPrinter:Box(0288,1505,0340,2321)
	oPrinter:Say(0293,0128,"Empresa :" + c_Emp,o11N,,0)
	oPrinter:Say(0300,1530,"CNPJ: "+  Transform(c_CNPJ,"@R 99.999.999/9999-99") ,o9N,,0)

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
	oPrinter:Say(0377,0420,"NOME",o10N,,0)
	oPrinter:Say(0380,1140,"ADMISS�O",o10N,,0)
	oPrinter:Say(0375,1471,"CARGO",o10N,,0)
	oPrinter:Say(0373,2048,"CRACH�",o10N,,0)

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

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}

	Aadd(a_PAR01, "Informe o Periodo de:")
	Aadd(a_PAR02, "Informe o Periodo ate:")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Periodo de?   ","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Periodo ate?   ","","","mv_ch2","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return