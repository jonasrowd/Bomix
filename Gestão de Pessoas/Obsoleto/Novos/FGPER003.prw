#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"


User Function FGPER003()

	Local c_Perg		:= "FGPER003"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Relação de Demitidos","Esta rotina tem a finaldade de imprimir a relação de demitidos.", "Desenvolvido pela Totvs Bahia", "","FGPER003")

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

	Local    n_pag 		:=	0
	Local   n_Count      :=	0
	Local 	 c_Matricula  :=	''
	Local	 c_Nome		:=	''
	Local 	 c_Demissa	    :=	''
	Local 	 c_Cargo	   :=	''
	Local 	 c_CartPonto	:=	''
	Local	 n_Row			:= 0370


	BEGINSQL ALIAS "QRY"

		SELECT	RA_MAT, RA_NOME, RA_DEMISSA, RA_CRACHA, RJ_DESC
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SRJ% SRJ ON (SRJ.RJ_FUNCAO = SRA.RA_CODFUNC AND SRA.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND RA_DEMISSA BETWEEN  %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		AND RA_SITFOLH = "D"
		AND SRA.%NOTDEL%

	ENDSQL

	If !(Select("QRY") > 0 )
		QRY->(DBCLOSEAREA())
		DbSelectArea("QRY")
	Endif

	If QRY->( Eof() )

		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		QRY->(DBCLOSEAREA())
		Return()

	Endif

	//imprime cabeçalho
	f_header ()

	While  QRY->( !Eof() )

		n_Row := n_Row + 50
		c_Matricula	:=	 QRY->RA_MAT
		c_Nome		    :=	 QRY->RA_NOME
		c_Demissa		:=	 QRY->RA_DEMISSA
		c_Cargo		:=  QRY->RJ_DESC
		c_CartPonto  	:=  QRY->RA_CRACHA

		f_grid(n_Row)//imprime a grid dos itens

		oPrinter:Say(n_Row + 16,0109,c_Matricula,o9N,,0)
		oPrinter:Say(n_Row + 16,0401,SUBSTR(c_Nome,1,40),o9N,,0)
		oPrinter:Say(n_Row + 16,1140,DtoC(StoD(c_Demissa)),o9N,,0)
		oPrinter:Say(n_Row + 16,1412,SUBSTR(c_Cargo,1,40),o9N,,0)
		oPrinter:Say(n_Row + 16,2046,c_CartPonto,o9N,,0)
		n_Count++

			//quebra de página a cada 56 registro
		if (MOD(n_Count, 56) = 0)
				//imprime cabeçalho

			n_Count:= 0
			oPrinter:EndPage()
			f_header ()
			oPrinter:Box(0177,0098,0288,2321)
			n_Row := 0442
		endIf

	QRY->( DbSkip() )

 Enddo

	QRY->(DBCLOSEAREA())

return

static Function f_RelatPadrao()
	Private oArial30  	:=	TFont():New("Arial",,30,,.F.,,,,,.F.,.F.)
	Private o11N	:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private o9N	:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
	Private o10N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("Relação de Demitidos")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()
Return


//--------------------------------------------------------------
/*/{Protheus.doc}  frmR001
Description  tela de opção de impressão

@param     xParam Parameter Description
@return    xRet Return Description
@author  - Ivan Amado
@since     04/05/2015
/*/
static function f_header ()

	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	//cabeçalho
	oPrinter:Say(070,2052,'Emissão:'   + DTOC(dDataBase),o11N,,0)
	oPrinter:Say(0175,0742,"Relação de Demitidos",oArial30,,0)
	oPrinter:Box(0288,0098,0340,1505)
	oPrinter:Box(0288,1505,0340,2321)
	oPrinter:Say(0293,0128,"Empresa :" +    ALLTRIM(SM0->M0_NOMECOM) ,o11N,,0)
	oPrinter:Say(0300,1530,"CNPJ:"     +    ALLTRIM(SM0->M0_CGC) ,o9N,,0)
	//box matricula
	oPrinter:Box(0362,0102,0428,0392)
	//box nome
	oPrinter:Box(0362,0392,0428,1132)
	//box demissão
	oPrinter:Box(0362,1132,0428,1400)
	//box cargo
	oPrinter:Box(0362,1400,0428,2034)
	//box Cartão de Ponto
	oPrinter:Box(0362,2034,0428,2319)
	oPrinter:Say(0380,0109,"MATRÍCULA",o10N,,0)
	oPrinter:Say(0380,0400,"NOME",o10N,,0)
	oPrinter:Say(0380,1140,"DEMISSÃO",o10N,,0)
	oPrinter:Say(0380,1410,"CARGO",o10N,,0)
	oPrinter:Say(0380,2040,"CRACHÁ",o10N,,0)

return

static function f_grid(n_line)

	local  n_altura := n_line + 60
  //  n_line := + 10
   //box matricula
	oPrinter:Box(n_line + 10 ,0102,n_altura,0392)
	//box nome
	oPrinter:Box(n_line + 10,0392,n_altura,1132)
	//box demissão
	oPrinter:Box(n_line + 10,1134,n_altura,1400)
	//box cargo
	oPrinter:Box(n_line + 10 ,1400,n_altura,2034)

	//box Cartão de Ponto
	oPrinter:Box(n_line + 10,2034,n_altura,2319)

return


Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}

	Aadd(a_PAR01, "Informe o Periodo de:")
	Aadd(a_PAR02, "Informe o Periodo ate:")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Periodo de?   ","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Periodo ate?   ","","","mv_ch2","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()


