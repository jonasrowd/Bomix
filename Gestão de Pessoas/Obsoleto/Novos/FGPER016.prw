#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER016()

Local c_Perg		:= "FGPER016"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Recibo","Esta rotina tem a finaldade de imprimir definicao o recibo de integracao e kit ISO 9001.", "Desenvolvido pela Totvs Bahia", "","FGPER016")

If l_Opcao

	f_ValidPerg(c_Perg)
	If !Pergunte(c_Perg,.T.)
		Return()
	Endif
	f_GeraRelatorio()

Else

	Return()

EndIf

Return

Static Function f_GeraRelatorio()

Private cImag001	:=	"D:\SISTEMAS\Totvs\Protheus11\Protheus_Data\system\RODAPÉ.png"
Private o14N			:=	TFont():New("",,14,,.T.,,,,,.F.,.F.)
Private o10N	       :=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private oArial10N	    :=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private oArialó32N	:=	TFont():New("Arial Narrow",,32,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("Recibo")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()
                                                         
  Local c_Data   := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + STRZERO(Year(dDataBase), 4)
  Local c_Cidade := Alltrim(SM0->M0_CIDCOB)


  BEGINSQL ALIAS "QRY"

		SELECT	RA_NOME, RA_MAT
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


		oPrinter:Say(0122,0950,"RECIBO",o14N,,0)
		oPrinter:Say(0353,0200,"Recebi da " + ALLTRIM(SM0->M0_NOMECOM) + " , o manual de Integração IT-PES-3 e o Kit ISO 9001, declarando, portanto ter tomado " ,oArial10N,,0)
		oPrinter:Say(0410,0200,"conhecimento de todo seu conteúdo.",oArial10N,,0)

		oPrinter:Say(0500,1380, c_Cidade +", " + c_Data ,oArial10N,,0)
		oPrinter:Say(0638 ,0200,"________________" ,oArialó32N,,0)
		oPrinter:Say(0776,0220, ALLTRIM(QRY->RA_NOME) ,oArial10N,,0)
		oPrinter:Say(0845,0220,"Registro: " + QRY->RA_MAT,oArial10N,,0)

		oPrinter:SayBitMap(2980,0261,cImag001)

		oPrinter:EndPage()

		QRY->(DBSKIP())

   EndDo

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


