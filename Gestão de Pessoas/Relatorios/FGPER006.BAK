#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function FGPER006()

	Local c_Perg		:= "FGPER006"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("CARTA DE REFERÊNCIA","Esta rotina tem a finaldade de imprimir a carta de referencia.", "Desenvolvido pela Totvs Bahia", "","FGPER006")

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

Private oArial11N	    :=	TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)
Private oArial10N	    :=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private oArial10  	:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("Carta de Referência")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

  	Local c_Ctps   := ""
  	Local c_Cidade := Alltrim(SM0->M0_CIDENT)
  	Local d_Data 	 := STRZERO(Day(dDataBase),2,0) + " de " + MesExtenso(dDataBase) + " de " + STRZERO(Year(dDataBase),4,0)

	DbSelectArea("SRA")
	DbSetOrder(1)
	IF DbSeek(xFilial("SRA")+ MV_PAR01) .AND. SRA->RA_SITFOLH = "D"

		DbSelectArea("SQ3")
		DbSetOrder(1)
		DbSeek(xFilial("SQ3")+SRA->RA_CARGO)
		c_Ctps := Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)

	  

		   oPrinter:Say(0148,0865,"CARTA DE REFERÊNCIA",oArial11N,,0)
		   oPrinter:Say(0360,0401,"Declaramos para os devidos fins que o Sr.(a) " + Alltrim(SRA->RA_NOME) + " portador da CTPS: ",oArial10N,,0)
		   oPrinter:Say(0460,0403,"no período de " + DtoC(SRA->RA_ADMISSA) + " a " + DtoC(SRA->RA_DEMISSA) + ", nada constando em nossos arquivos contra o mesmo.",oArial10N,,0)
		   oPrinter:Say(0411,0403, c_Ctps + ", trabalhou em nossa empresa na função de " + ALLTRIM(SQ3->Q3_DESCSUM) ,oArial10N,,0)
		   oPrinter:Say(0666,0415, c_Cidade +", " + d_Data ,oArial10N,,0)
		   oPrinter:Say(0917,0413,"_____________________________________",oArial10N,,0)
		   oPrinter:Say(0966,0420, Alltrim(SM0->M0_NOMECOM) ,oArial10,,0)

	ELSE

		Aviso("Atenção" ,"Funcionário não encontrado ou nao está demitido!",{"Ok"},2,"Atenção")
		Return()

	ENDIF

Return



Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}

	Aadd(a_PAR01, "Informe a matricula")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()
