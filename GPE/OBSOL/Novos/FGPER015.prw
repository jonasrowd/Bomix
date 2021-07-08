#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER015()

Local c_Perg		:= "FGPER015"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Relacao de Aniversariantes","Esta rotina tem a finaldade de imprimir a relacao de aniversariantes.", "Desenvolvido pela Totvs Bahia", "FGPER015")

If l_Opcao
   
	f_ValidPerg(c_Perg)
	If !Pergunte(c_Perg,.T.)
	   Return()
	Endif
	f_GeraRel()

Else

	Return()

EndIf

Return

Static Function f_GeraRel()

Private oArial11N	    :=	TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)
Private oArial10N	    :=	TFont():New("Arial",,10,,.T.,,,,,.F.,.F.)
Private oArial8N	    :=	TFont():New("Arial",,8,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("FGPER015")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

  Local c_Situacao := ""
  Local n_LinBox1 := 0231
  Local n_LinBox2 := 0268
  Local n_Alt     := 0342
  Local n_Lin	    := 0
  Local nX        := 0

  BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH, RA_ADMISSA, RA_NASC, RA_CRACHA, RJ_DESC
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:Srj% SRJ ON (SRJ.RJ_FUNCAO = SRA.RA_CODFUNC AND SRJ.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND SRJ.RJ_FILIAL = %EXP:XFILIAL("SRJ")%
		AND month(SRA.RA_NASC) BETWEEN month(%EXP:MV_PAR01%) AND month(%EXP:MV_PAR02%)
		AND SRA.RA_SITFOLH = %EXP:" "%
		AND SRA.%NOTDEL%

  ENDSQL

  a_Query := getlastQuery()
  memowrit("c:/temp/fgper015.sql", a_Query[2])

  DBSELECTAREA("QRY")
  If QRY->( Eof() )

		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		QRY->(DBCLOSEAREA())
		Return()

  Endif

  f_Cabec()

  While QRY->(!EOF()) 

	  n_LinBox1  += 111
	  n_LinBox2  += 111
	  n_Alt	   += 111
	  n_Lin++

	  oPrinter:Box(n_LinBox1,0028,n_Alt,2377)
	  oPrinter:Box(n_LinBox1,1101,n_Alt,1101)
	  oPrinter:Box(n_LinBox1,0317,n_Alt,0317)
	  oPrinter:Box(n_LinBox1,1300,n_Alt,1300)
	  oPrinter:Box(n_LinBox1,2107,n_Alt,2107)
	  oPrinter:Box(n_LinBox1,1800,n_Alt,1800)
	  oPrinter:Say(n_LinBox2,0067, ALLTRIM(QRY->RA_MAT) ,oArial8N,,0)
	  oPrinter:Say(n_LinBox2,0357, SUBSTR(ALLTRIM(QRY->RA_NOME) , 1,40), oArial8N,,0)
	  oPrinter:Say(n_LinBox2,1124, DtoC(StoD(QRY->RA_ADMISSA))  ,oArial8N,,0)
	  oPrinter:Say(n_LinBox2,1330, SUBSTR(ALLTRIM(QRY->RJ_DESC),1, 40) ,oArial8N,,0)
	  oPrinter:Say(n_LinBox2,2128, ALLTRIM(QRY->RA_CRACHA)  ,oArial8N,,0)
	  do Case
	  		Case QRY->RA_SITFOLH = ""
	  			c_Situacao  := "Normal"
	  		Case QRY->RA_SITFOLH = "A"
	  			c_Situacao  := "Afastado"
	  		Case QRY->RA_SITFOLH = "D"
	  			c_Situacao  := "Demitido"
	  		Case QRY->RA_SITFOLH = "F"
	  			c_Situacao  := "Ferias"
	  		Case QRY->RA_SITFOLH = "T"
	  			c_Situacao  := "Transferido"
	  ENDCASE

	 /* A AFASTADO
	  D DEMITIDO
	  F FERIAS
	  T TRANSFERIDO
	  */

	  oPrinter:Say(n_LinBox2,1900, c_Situacao ,oArial8N,,0)

	  IF (MOD(n_Lin, 19) = 0)

		 oPrinter:EndPage()
		 f_Cabec()
		 oPrinter:Box(0015,0028,0342,2377)
	  	 n_Lin     := 0
	  	 n_LinBox1 := 0231
	   	 n_LinBox2 := 0268
	     n_Alt     := 0342

	  EndIf

	  QRY->(DBSKIP())

	Enddo

	QRY->(DBCLOSEAREA())

Return

Static function f_Cabec()

  //BOX RELACAO DE ANIVERSARIANTES
  oPrinter:Box(0015,0028,0342,2377)
 // oPrinter:Box(0008,0028,0120,2377)
  oPrinter:Say(0046,0826,"RELACAO DE ANIVERSARIANTES",oArial11N,,0)
  //Box EMPRESA e CNPJ
  oPrinter:Box(0120,0028,0231,1122)
  oPrinter:Box(0120,1122,0231,2377)
  oPrinter:Say(0162,1152,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") ,oArial10N,,0)
  oPrinter:Say(0162,0070,"EMPRESA: " + ALLTRIM(SM0->M0_NOMECOM)  ,oArial10N,,0)

  //BOX PRINCIPAL
  oPrinter:Box(0231,0028,0342,2377)
  //BOX MATRICULA E NOME
  oPrinter:Box(0231,1101,0342,1101)
  //BOX ADMISSAO
  oPrinter:Box(0231,0317,0342,0317)
  //BOX CARGO
  oPrinter:Box(0231,1300,0342,1300)
  ////BOX CARTAO DE PONTO
  oPrinter:Box(0231,2107,0342,2107)
  //SIT. ATUAL
  oPrinter:Box(0231,1800,0342,1800)

  oPrinter:Say(0268,0067,"MATRICULA",oArial8N,,0)
  oPrinter:Say(0268,0357,"NOME",oArial8N,,0)
  oPrinter:Say(0268,1124,"ADMISS�O",oArial8N,,0)
  oPrinter:Say(0268,1477,"CARGO",oArial8N,,0)
  oPrinter:Say(0268,2128,"CART. PONTO",oArial8N,,0)
  oPrinter:Say(0268,1900,"SIT. ATUAL",oArial8N,,0)

Return


Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}

	Aadd(a_PAR01, "Informe o per�odo de:")
	Aadd(a_PAR02, "Informe o per�odo at�:")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Per�odo de?   ","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Per�odo at�?   ","","","mv_ch2","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()