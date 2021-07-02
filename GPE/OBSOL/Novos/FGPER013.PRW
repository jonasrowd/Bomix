#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"


User Function FGPER013()

Local c_Perg		:= "FGPER013"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("COMUNICADO","Esta rotina tem a finaldade de imprimir comunicado de ponto eletronico.", "Desenvolvido pela Totvs Bahia", "","FGPER013")

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


Static Function f_RelatPadrao()

Private o14N		   :=	TFont():New("",,14,,.T.,,,,,.F.,.F.)
Private o13N		   :=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private o11N		   :=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
Private oPrinter     :=	tAvPrinter():New("FGPER013")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()


  Local c_Data := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4)

//.AND. SRA->RA_SITFOLH = " "

  DbSelectArea("SRA")
  SRA->( DbSetOrder(1) )
  IF DbSeek(xFilial("SRA")+mv_par01)  .AND. SRA->RA_SITFOLH = ' '

	  oPrinter:Say(0111,740,"COMUNICADO",o14N,,0)

	  oPrinter:Say(0255,0650,"MARCAÇÃO DE PONTO ELETRÔNICO",o13N,,0)

	  oPrinter:Say(0391,0354,"Devido ao repetitivo descumprimento dos procedimentos de marcação de Ponto Eletrônico, ",o13N,,0)
	  oPrinter:Say(0442,0354,"pela maioria dos nossos colaboradores, a BOMIX adverte que:",o13N,,0)

	  //oPrinter:Say(0837,0466,"na sua pela maioria dos nossos colaboradores, a BOMIX adverte que:",o13N,,0)


	  oPrinter:Say(0560,0424,"-  Todos os colaboradores estão obrigados a registrar diariamente o horário de:",o13N,,0)
	  oPrinter:Say(0604,0471,"entrada, intervalo de almoço e saída, nos pontos eletrônicos localizados nas áreas:",o13N,,0)
	  oPrinter:Say(0653,0471,"industrial, serigrafia, almoxarifado e administrativa, conforme legislação",o13N,,0)
	  oPrinter:Say(0704,0471,"trabalhista vigente.",o13N,,0)

	  oPrinter:Say(0791,0424,"-  Os colaboradores deverão realizar a marcação do ponto no relógio localizado  ",o13N,,0)
	  oPrinter:Say(0840,0471,"na área de atuação.",o13N,,0)


	  oPrinter:Say(0964,0424,"-  Caso surja algum problema técnico com o relógio de ponto da área, que impeça a ",o13N,,0)
	  oPrinter:Say(1013,0471,"marcação, o colaborador devera imediatamente comunicar ao seu gerente que ",o13N,,0)
	  oPrinter:Say(1062,0471,"indicara o relógio de ponto mais próximo para a marcação.",o13N,,0)

	  oPrinter:Say(1157,0424,"-  Os funcionários deverão realizar a marcação do ponto obedecendo a sua escala de ",o13N,,0)
	  oPrinter:Say(1213,0471,"trabalho.",o13N,,0)

	  oPrinter:Say(1308,0424,"-  Qualquer alteração do horário de marcação devera ser imediatamente comunicada ao",o13N,,0)
	  oPrinter:Say(1362,0471,"gerente responsável pela área, que registrara a ocorrência.",o13N,,0)

	  oPrinter:Say(1491,0760,"ATENÇÃO",o13N,,0)
	  oPrinter:Say(1584,0660,"Horário para a marcação do Ponto:",o13N,,0)

	  oPrinter:Say(1657,0737,"a)  Na Entrada: Inicio da Jornada",o13N,,0)
	  oPrinter:Say(1722,0737,"b)  Intervalo: Inicio do horário de descanso intrajornada",o13N,,0)
	  oPrinter:Say(1780,0737,"c)  Retorno do Intervalo: até dois minutos(2), do reinicio da jornada",o13N,,0)
	  oPrinter:Say(1844,0737,"d)  Na Saída: Imediatamente após o termino da jornada.",o13N,,0)

	  oPrinter:Say(1977,0354,"Nao serao descontadas e nem computadas como jornada extaordinarias as variacoes de registro no horario ",o13N,,0)
	  oPrinter:Say(2026,0354,"nao excedentes de (05) minutos, observando o limite maximo de dez minutos(10) diarios, (art.58, ",o13N,,0)
	  oPrinter:Say(2075,0354,"paragrafo 1º da CLT).",o13N,,0)

	  oPrinter:Say(2171,0354,"A marcacao fora do horario ou a falta da marcacao consiste em falta grava, e resultara em advertencia por",o13N,,0)
	  oPrinter:Say(2220,0354,"escrito, sendo que a repeticao desta, sera seguida de suspensao, podendo levar a aplicacao da pena de",o13N,,0)
	  oPrinter:Say(2269,0354,"demissao por justa causa, caso o colaborador nao corrija o seu procedimento.",o13N,,0)

	  oPrinter:Say(2365,0650,"ESPERAMOS A COLABORACAO DE TODOS",o13N,,0)

	  oPrinter:Say(2461,0354,"Declaro que recebi copia do regulamento interno para marcação de ponto eletrônico, bem ",o13N,,0)
	  oPrinter:Say(2510,0354,"como estou ciente e de acordo com seu conteúdo.",o13N,,0)

	  oPrinter:Say(2653,0368,"Salvador, "+ c_Data ,o13N,,0)
	  oPrinter:Say(2749,0368,"___________________________________",o13N,,0)
	  oPrinter:Say(2798,0380,Alltrim(SRA->RA_NOME ),o13N,,0)
	  oPrinter:Say(2847,0375,"Matricula: " + Alltrim(SRA->RA_MAT),o13N,,0)

  ELSE

  	 Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")  
	 Return()

  ENDIF
 
Return



Static Function f_ValidPerg(c_Perg)

Local a_PAR01        := {}

Aadd(a_PAR01, "Informe a matricula")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()