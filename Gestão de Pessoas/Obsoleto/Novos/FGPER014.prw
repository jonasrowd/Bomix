#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER014()

Local c_Perg		:= "FGPER014"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("TERMO DE HOMOLOGACAO DE RECISAO DE CONTRATO","Esta rotina tem a finaldade de imprimir termo de homologacao de rescisao de contrato.", "Desenvolvido pela Totvs Bahia", "","FGPER014")

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

//Private oArial10N	:=	TFont():New("Arial",,10,,.T.,,,,,.F.,.F.)
Private oArial10N	  :=	TFont():New("Arial Narrow",,10,,.T.,,,,,.F.,.F.)
Private oArial31   :=	TFont():New("Arial Narrow",,31,,.F.,,,,,.F.,.F.)
Private o11N	     :=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
Private oPrinter   :=	tAvPrinter():New("FGPER014")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()


//.AND. SRA->RA_SITFOLH = " "
  DbSelectArea("SRA")
  DbSetOrder(1)
  if DbSeek(xFilial("SRA")+ mv_par01 ) .AND. SRA->RA_SITFOLH = ''


  		  oPrinter:Box(0042,0063,0106,2352)
		  oPrinter:Say(0055,0767,"TERMO DE HOMOLOGACAO DE RECISAO DE CONTRATO",oArial10N,,1)

		  oPrinter:Box(0133,0063,0197,2349)
		  oPrinter:Say(0151,0081,"EMPREGADOR",oArial10N,,1)

		 //DADOS DA EMPRESA
		  oPrinter:Box(0197,0063,0308,2349)
		  oPrinter:Box(0200,1187,0311,1187)
		  oPrinter:Say(0204,1206,"RAZAO SOCIAL:",oArial10N,,1)
		  oPrinter:Say(0248,1215, SM0->M0_NOMECOM,oArial10N,,1) //NOME DA EMPRESA
		  oPrinter:Say(0204,0081,"CNPJ/CEI:",oArial10N,,1)
		  oPrinter:Say(0253,0091, SM0->M0_CGC ,oArial10N,,1)    //dados cnpj

			DbSelectArea("SRG")
		    SRG->( DbSetOrder(1) )
			SRG->( DbSeek(xFilial("SRG")+SRA->RA_MAT ))
			DbSelectArea("RCE")
			RCE->( DbSetOrder(1) )
			RCE->( DbSeek(xFilial("RCE")+SRA->RA_SINDICA ))

			  //DADOS DO FUNCIONARIO
			  oPrinter:Box(0308,0063,0653,2349)
			  oPrinter:Box(0480,0065,0480,2349)
			  oPrinter:Box(0477,0590,0653,0590)
			  oPrinter:Box(0477,1668,0653,1668)
			  oPrinter:Box(0477,1080,0653,1080)

			  oPrinter:Say(0322,0084,"PIS - PASEP",oArial10N,,1)
			  oPrinter:Say(0388,0091, Alltrim(SRA->RA_PIS),oArial10N,,1)
			  oPrinter:Box(0308,0590,0477,0590)

			  oPrinter:Say(0484,0609,"CPF",oArial10N,,1)
			  oPrinter:Say(0546,0609, Alltrim(SRA->RA_CIC) ,oArial10N,,1)

			  oPrinter:Say(0322,0611,"NOME",oArial10N,,1)
			  oPrinter:Say(0388,0618, Alltrim(SRA->RA_MAT) + "-" + Alltrim(SRA->RA_NOME ),oArial10N,,1)

			  oPrinter:Say(0484,0081,"CART. DE TRABALHO",oArial10N,,1)
			  oPrinter:Say(0553,0093, Alltrim(SRA->RA_NUMCP) + "-" + Alltrim(SRA->RA_SERCP) + "-" + Alltrim(SRA->RA_UFCP),oArial10N,,1)

			  oPrinter:Say(0484,1106,"DATA DE NASCIMENTO",oArial10N,,1)
			  oPrinter:Say(0546,1110,dtoc(SRA->RA_NASC),oArial10N,,1)
			  oPrinter:Say(0484,1687,"NOME DA MAE",oArial10N,,1)
			  oPrinter:Say(0551,1696, Alltrim(SRA->RA_MAE),oArial10N,,1)
			  oPrinter:Box(0653,0063,0711,2349)
			  oPrinter:Say(0662,0074,"CONTRATO",oArial10N,,1)
			  //oPrinter:Say(0968,0095,"JJJJ",oArial10N,,1)
			  oPrinter:Box(0711,0063,0888,2349)
			  oPrinter:Say(0722,0074,"CAUSA DO AFASTAMENTO",oArial10N,,1)
			  oPrinter:Say(0788,0098, CVALTOCHAR(SRG->RG_TIPORES),oArial10N,,1)

			  oPrinter:Box(0888,0065,1075,2352)
			  oPrinter:Box(0888,0471,1075,0471)
			  oPrinter:Box(0891,0928,1075,0928)
			  oPrinter:Box(0888,1642,1075,1642)
			  oPrinter:Box(1075,0065,1273,2352)
			  oPrinter:Box(1273,0067,1528,2354)
			  oPrinter:Box(1273,0555,1528,0555)
			  oPrinter:Say(0893,0077,"DATA ADMISSAO",oArial10N,,1)
			  oPrinter:Say(0968,0077, dtoc(SRA->RA_ADMISSA),oArial10N,,1)
			  oPrinter:Say(0895,0490,"DATA AVISO PREVIO",oArial10N,,1)
			//  oPrinter:Say(0968,0490, dtoc(SRG->RG_DAVISO),oArial10N,,1)
			  oPrinter:Say(0893,0949,"COD. AFASTAMENTO",oArial10N,,1)
			  oPrinter:Say(0968,0949, SRG->RG_TIPORES,oArial10N,,1)
			  oPrinter:Say(0895,1659,"PENSAO ALIMENTICIA (%) (FGTS)",oArial10N,,1)
			  oPrinter:Say(0968,1661, Alltrim(SRA->RA_PENSALI),oArial10N,,1)
			  oPrinter:Say(1084,0079,"CATEGORIA DO TRABALHADOR",oArial10N,,1)
			  oPrinter:Say(1151,0088,  Alltrim(SRA->RA_CATFUNC),oArial10N,,1)

			  oPrinter:Say(1288,0084,"CODIGO SINDICAL",oArial10N,,1)
			  oPrinter:Say(1362,0086, Alltrim(SRA->RA_SINDICA),oArial10N,,1)
			  oPrinter:Say(1288,0571,"CNPJ E NOME DA ENTIDADE SINDICAL LABORAL",oArial10N,,1)
			  oPrinter:Say(1362,0571, Alltrim(RCE->RCE_DESCRI),oArial10N,,1)


		  oPrinter:Say(1611,0074,"Foi prestada, gratuitamente, assist�ncia na rescis�o do contrato de trabalho, nos termos do artigo n� 477, ",o11N,,1)
		  oPrinter:Say(1660,0072,"� 1� , da consolida��o das leis do trabalho (CLT), sendo comprovado neste ato efetivo pagamento das ",o11N,,1)
		  oPrinter:Say(1704,0074,"verbas rescis�rias especificadas no corpo do TRCT, no valor liquido de R$ 2 588, 36, o qual, devidamente ",o11N,,1)
		  oPrinter:Say(1744,0072,"rubricado pelas partes, � parte integrante do presente Termo de Homologa��o.",o11N,,1)
		  oPrinter:Say(1788,0070,"As partes assistidas no presente ato da rescis�o contratual foram identificadas como legitimas conforme ",o11N,,1)
		  oPrinter:Say(1880,0070,"Fica ressalvado o direito de o trabalhador pleitear judicialmente os direitos informados no campo 155, abaixo",o11N,,1)
		  oPrinter:Say(1828,0072,"previsto na Instru��o Normativa/SRT n� 15/2010.",o11N,,1)

		  oPrinter:Say(1986, 500,"                                     /              ,                de                                       de                 ",o11N,,1)
		  oPrinter:Say(2091,0072,"_________________",oArial31,,1)
		  oPrinter:Say(2207,0112,"Assinatura do Empregador ou Preposto",o11N,,1)
		  oPrinter:Say(2091,1355,"_________________",oArial31,,1)
		  oPrinter:Say(2207,1350,"Assinatura do Responsavel do Trabalhador",o11N,,1)
		  oPrinter:Say(2295,0070,"_________________",oArial31,,1)
		  oPrinter:Say(2410,0114,"Carimbo e Assinatura do Assistente",o11N,,1)
		  oPrinter:Say(2290,1362,"_________________",oArial31,,1)
		  oPrinter:Say(2414,1437,"Nome do �rg�o Homologador",o11N,,1)
		  oPrinter:Say(2480,0084,"RESSALVAS",o11N,,1)
		  oPrinter:Box(2473,0053,2866,2338)
		  oPrinter:Box(2866,0053,2924,2338)
		  oPrinter:Box(2924,0053,3106,2338)
		  oPrinter:Say(2875,0074,"Informa�oes � CAIXA",o11N,,1)
		  oPrinter:Say(2935,0707,"A ASSISTENCIA NO ATO DE RESCIS�O CONTRATUAL � GRATUITA",o11N,,1)
		  oPrinter:Say(2971,0400,"Pode o trabalhador iniciar a��o judicial quanto aos creditos resultantes das rela��es de trabalho at� o",o11N,,1)
		  oPrinter:Say(3008,0400,"limite de dois anos ap�s a extin��o do contrato de de trabalho  (Inc. XXIX, Art. 7� da Constitui��o ",o11N,,1)
		  oPrinter:Say(3042,0400,"Federal/1998 ).",o11N,,1)

ELSE

	AVISO("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
	Return()

ENDIF

Return


Static Function f_ValidPerg(c_Perg)

Local a_PAR01        := {}

Aadd(a_PAR01, "Informe a matricula")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()