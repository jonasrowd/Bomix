#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"       


User Function FGPER016()

Local c_Perg		:= "FGPER016"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Recibo","Esta rotina tem a finaldade de", "imprimir definicao o recibo de integracao e kit ISO 9001 ", "Desenvolvido pela Totvs Bahia","FGPER016")

If l_Opcao

	If !Pergunte()
		f_ValidPerg(c_Perg)
	EndIf
	f_GeraRelatorio()

Else

	Return()

EndIf

Return

Static Function f_GeraRelatorio()

Private o14N			:=	TFont():New("",,14,,.T.,,,,,.F.,.F.)
Private o10N	       :=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private oArial10N	    :=	TFont():New("Arial",,12,,.T.,,,,,.F.,.F.)
Private oArial�32N	:=	TFont():New("Arial Narrow",,32,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("FGPER016")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

 
  Local c_Cidade := Alltrim(SM0->M0_CIDCOB)

  DbSelectArea("SRA")
  DbSetOrder(1)
  IF DbSeek(xFilial("SRA")+mv_par01)
  c_Data   := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + STRZERO(Year(SRA->RA_ADMISSA), 4)  

		oPrinter:Say(0122,0950,"RECIBO ENTREGA MANUAL DE INTEGRACAO",o14N,,0)
		oPrinter:Say(0353,0200,"Recebi da " + ALLTRIM(SM0->M0_NOMECOM) + " , o manual de Integra��o IT-PES-3 e o Kit ISO 9001, " ,oArial10N,,0)
		oPrinter:Say(0410,0200,"declarando, portanto ter sido informado de todo seu conte�do.",oArial10N,,0)

		oPrinter:Say(0500,1380, c_Cidade +", " + c_Data ,oArial10N,,0)
		oPrinter:Say(0638 ,0200,"________________" ,oArial�32N,,0)
		oPrinter:Say(0776,0220, ALLTRIM(SRA->RA_NOME) ,oArial10N,,0)
		oPrinter:Say(0845,0220,"Registro: " + SRA->RA_MAT,oArial10N,,0)

  Else

     Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
	 Return()

  Endif

Return

Static Function f_ValidPerg(c_Perg)

 Local a_PAR01        := {}

Aadd(a_PAR01, "Informe a matricula")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()

