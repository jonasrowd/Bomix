#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER012()

Local c_Perg		:= "FGPER012"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Acordo Compensacao","Esta rotina tem a finaldade de imprimir definicao o acordo compensacao.", "Desenvolvido pela Totvs Bahia", "","FGPER012")

If l_Opcao

		f_ValidPerg(c_Perg)
		if !Pergunte(c_Perg,.T.)
			Return()
		endif
		f_RelatPadrao()

	Else

		Return()

	EndIf

Return

Static Function f_RelatPadrao()

  Private cImag001	:=	"C:\Users\ivan.cardoso\Documents\TDS\Workspace\TDS112\BOMIX\IMAGENS\RODAPÉ.png"
  Private oArial13N	   :=	TFont():New("Arial",,13,,.T.,,,,,.F.,.F.)
  Private oArial10  	:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
  Private oPrinter  	:=	tAvPrinter():New("Acordo Compensação de Horas")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

  BEGINSQL ALIAS "QRY"

		SELECT RA_MAT, RA_NUMCP, RA_NOME, RA_SERCP, RA_UFCP
		FROM %TABLE:SRA% SRA
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND RA_MAT BETWEEN  %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		AND RA_SITFOLH = " "
		AND SRA.%NOTDEL%

	ENDSQL

  	DBSELECTAREA("QRY")
	If QRY->( Eof() )

		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		QRY->(DBCLOSEAREA())
		Return()

	Endif

	

	While QRY->( !Eof() )
    	n_Lin := 0453
	 	c_Carteira   := Alltrim(QRY->RA_NUMCP) + "-" + Alltrim(QRY->RA_SERCP) + "-" + Alltrim(QRY->RA_UFCP)
		c_EndEmpresa := Alltrim(SM0->M0_CIDCOB) + " - " + Alltrim(SM0->M0_ESTCOB) + "   " + Alltrim(SM0->M0_ENDCOB) + "  " + Alltrim(SM0->M0_CEPCOB)
    	c_Empresa    := Alltrim(SM0->M0_NOMECOM)
		c_Nome       := Alltrim(QRY->RA_NOME )
		c_Data       := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4)

	  	oPrinter:Say(0166,0749,"Acordo Compensação de Horas",oArial13N,,0)

		oPrinter:Say(n_Lin,0387,"Pelo presente acordo para compensação de jornada de trabalho firmado entre a Empresa "  + c_Empresa + ", estabelecida em",oArial10,,0)
		oPrinter:Say(n_Lin += 50,0387,c_EndEmpresa + " com o ramo de Indústria de Embalagens Plásticas, e o (a) funcionário (a)",oArial10,,0)
		oPrinter:Say(n_Lin += 50,0387,"Sr. (a) " + c_Nome + ", portador(a) da CTPS/Série " + c_Carteira ,oArial10 ,,0)
		oPrinter:Say(n_Lin += 50,0387,"convencionado o seguinte:",oArial10,,0)

		oPrinter:Say(n_Lin += 100,0387,"a - Havendo necessidade de prorrogação da jornada, as horas excedentes, atendido o limite legal, serão fica compensadas",oArial10,,0)
		oPrinter:Say(n_Lin += 50,0387,"em outro dia da semana.",oArial10,,0)

		oPrinter:Say(n_Lin += 100,0387,"b - Optando a empresa por não trabalhar no dia de sábado, a jornada diária, de segunda a sexta, será estendida para compensar",oArial10,,0)
		oPrinter:Say(n_Lin += 50,0387,"as horas não trabalhadas no sábado, observando o limite legal de 44 (quarenta e quatro) horas semanais.",oArial10,,0)

		oPrinter:Say(n_Lin += 100,0387,"c - Em havendo trabalho em dia de domingo ou feriado será compensado com outro dia. Não ocorrendo compensação das horas",oArial10,,0)
		oPrinter:Say(n_Lin += 50,0387,"trabalhadas nesses dias, estas serão pagas com acréscimo de 100%.",oArial10,,0)

		oPrinter:Say(n_Lin += 250,0387,"SALVADOR, " + c_Data,oArial10,,0)

		oPrinter:Say(n_Lin += 200,0387,"______________________________________________________",oArial10,,0)

		oPrinter:Say(n_Lin += 50,0387,"" + c_Empresa ,oArial10,,0)

		oPrinter:Say(n_Lin += 100,0387,"______________________________________________________",oArial10,,0)

		oPrinter:Say(n_Lin += 50,0387,"" + c_Nome ,oArial10,,0)

		oPrinter:EndPage()

		 QRY->( DbSkip() )

	 ENDDO

	 QRY->(DBCLOSEAREA())

Return

Static Function f_ValidPerg(c_Perg)

Local a_PAR01  := {}
Local a_PAR02  := {}

Aadd(a_PAR01, "Matricula de:")
Aadd(a_PAR02, "Matricula ate:")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Matricula de?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
PutSx1(c_Perg,"02","Matricula ate?   ","","","mv_ch2","C",06,0,0,"G","","SRA","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()





