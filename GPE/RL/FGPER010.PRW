#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"               


User Function FGPER010()
	Local c_Perg		:= "FGPER010"
	Private o_Telas	:= clsTelasGen():New()
	Private l_opção	:= o_Telas:mtdParOkCan("Vale Transporte","Esta rotina tem a finaldade de", "imprimir definição vale transporte", "Desenvolvido pela Totvs Bahia","FGPER010")
	If l_opção
		f_RelatPadrao()
	Else
		Return()
	EndIf
Return
static Function f_RelatPadrao()
	Private cImag001	:=	"\RODAPE.png"
	Private oArial10N	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
	Private oArial12N	:=	TFont():New("Arial",,12,,.T.,,,,,.F.,.F.)
	Private oArial11N	:=	TFont():New("Arial Narrow",,12,,.F.,,,,,.F.,.F.)
	Private o10N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oArial10  	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
	Private oArialó32N	:=	TFont():New("Arial Narrow",,32,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("Vale Transporte")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

Static Function printPage()


   Local c_Data   := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + STRZERO(Year(dDataBase), 4)
   Local c_Cidade := Alltrim(SM0->M0_CIDCOB)

	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA")+mv_PAR01 ))

	If SRA->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif
	n_Count := 0
	If SRA->( !Eof() )  
	                                          
	    c_bairro    := Alltrim(SRA->RA_BAIRRO) 
		c_Carteira 	:= Alltrim(SRA->RA_NUMCP)   + "-" + Alltrim(SRA->RA_SERCP) + "-" + Alltrim(SRA->RA_UFCP)
		c_End 	    := Alltrim(SRA->RA_ENDEREC) + "-" + Alltrim(SRA->RA_COMPLEM) +" - "+c_bairro
		c_Mun 	   		:= Alltrim(SRA->RA_MUNICIP) + "-" + Alltrim(SRA->RA_ESTADO)+ " CEP: " + Alltrim(SRA->RA_CEP)
		//	If Alltrim(SRA->RA_SITFOLH) == " "
		c_Nome 		:= Alltrim(SRA->RA_NOME )
		c_Matricula 	:= Alltrim(SRA->RA_MAT )
		c_Carteira 	:= c_Carteira
		//	Endif
		n_Count++

		SRA->( DbSkip() )

		n_col := 410  
		
		oPrinter:Say(0380,n_col,"Esclarecimentos Legais: ",oArial10N,,0)
		//oPrinter:Box(0044,0046,3277,2403)/*Margem*/
		oPrinter:Say(0448,n_col,"1. O vale transporte sera pago pelo beneficiario ate o limite de 6% (seis por cento) de seu salario",oArial10N,,0)
		oPrinter:Say(0495,n_col,"(excluindo quaisquer adicionais ou vantagens) e pelo empregador, no que exceder a  esse limite",oArial10N,,0)

		oPrinter:Say(0586,n_col,"2. No caso em que o valor limite dos vales recebidos for inferior a  6% (seis por cento) do salario,    ",oArial10N,,0)
		oPrinter:Say(0631,n_col,"empregado  podera  optar  pelo  recebimento  antecipado  do  vale  transporte, cujo  valor  sera ",oArial10N,,0)
		oPrinter:Say(0673,n_col,"integralmente descontado por ocasião do pagamento do respectivo salário.",oArial10N,,0)

		oPrinter:Say(0751,n_col,"3. Não e permitido  substituir o fornecimento do Vale Transporte por antecipação em dinheiro ou",oArial10N,,0)
		oPrinter:Say(0795,n_col,"qualquer outra forma de pagamento,salvo caso de falta ou insuficiência de estoque de vales trans-",oArial10N,,0)
		oPrinter:Say(0848,n_col,"porte.",oArial10N,,0)

		oPrinter:Say(0142,0697,"VALE TRANSPORTE - DECLARAÇÃO / TERMO DE COMPROMISSO",oArial12N,,0)
		oPrinter:Say(0917,1024,"DADOS DO EMPREGADO",oArial12N,,0)

		oPrinter:Say(1108,n_col,"Nome: "  + c_Nome,oArial10N,,0)
		oPrinter:Say(1202,n_col,"Registro: " + c_Matricula,oArial10N,,0)
		oPrinter:Say(1286,n_col,"Carteira Profissional: " + c_Carteira,oArial10N,,0)
        oPrinter:Say(1435,0707,"OPÇÃO PELO SISTEMA DO VALE TRANSPORTE",oArial12N,,0)   
		oPrinter:Say(1542,n_col,"O vale transporte e um direito do trabalhador,  faça sua opção por recebe-lo ou  não, ",oArial10N,,0)
		oPrinter:Say(1642,n_col,"assinalando um dos quadros abaixo:",oArial10N,,0)
		oPrinter:Say(1763,n_col,"Sim (  )                      não (  )",oArial10N,,0)

		oPrinter:Say(1888,n_col,"Qualquer que  seja sua  opção, o formulario, total  ou parcialmente preenchido e  assinado,",oArial10N,,0)
		oPrinter:Say(1951,n_col,"deve ser encaminhado ao setor de pessoal.",oArial10N,,0)
		oPrinter:Say(2058,n_col,"Para ter uso do Vale Transporte, declaro:",oArial10N,,0)
		
		oPrinter:Say(2100,n_col,"",oArial10N,,0)

		oPrinter:Say(2140,n_col,"1. Residir a : ",oArial10N,,0)
		oPrinter:Say(2197,n_col,"endereço: " + c_End,oArial10N,,0)
		oPrinter:Say(2255,n_col,"Muncipio: "   + c_Mun ,oArial10N,,0)

		oPrinter:Say(2320,n_col,"2. Utilizar os seguintes meios de transporte de minha residencia ate o trabalho e vice-versa:",oArial10N,,0)
		oPrinter:Say(2377,n_col,"(  ) ONIBUS 	(  )  TREM  (  ) ONIBUS/TREM ",oArial10N,,0)
		oPrinter:Say(2460,n_col,"3. No perimetro:",oArial10N,,0)
		oPrinter:Say(2504,n_col,"(  ) MUNICIPAL 	(  )  INTERMUNICIPAL  	(  ) INTERESTADUAL",oArial10N,,0)

		oPrinter:Say(2564,n_col,"4. Utilizar diariamente 01 (uma) condução para locomover-me de minha residencia ao traba-",oArial10N,,0)
		oPrinter:Say(2615,n_col,"lho e 01 (uma) para  retorno do trabalho para a residencia.",oArial10N,,0)
		oPrinter:Say(2680,n_col,"5. Para informações complementares, utilize o espaço abaixo:",oArial10N,,0)
		oPrinter:SayBitMap(2980,0261,cImag001,1811,0217)
       oPrinter:EndPage()
       oPrinter:Say(0122,0476,"TERMO DE COMPROMISSO/AUTORIZAÇÃO DE DESCONTO",oArial12N,,0)
		oPrinter:Say(0353,0200,"Comprometo-me a atualizar as informações anualmente ou sempre que ocorrem alterações, e a utilizar os",oArial10N,,0)
		oPrinter:Say(0411,0200,"vale transporte que me forem concedidos exclusivamente no percurso residência/trabalho/residência. Es-",oArial10N,,0)
		oPrinter:Say(0470,0200,"ciente de que, na hipótese de infringir tal compromisso, a empresa poderá dispensar-me por justa causa,",oArial10N,,0)
		oPrinter:Say(0518,0200,"nos termos do artigo parágrafo nr. 03, do Decreto nr. 95.247/87.",oArial10N,,0)
		oPrinter:Say(0577,0200,"Autorizo a empresa a descontar mensalmente de meus vencimentos até olimite de 6%(seis por cento) do sa-",oArial10N,,0)
		oPrinter:Say(0615,0200,"lário o valor destinado a cobrir o fornecimento dos vale transporte por mim utilizados.",oArial10N,,0)
		oPrinter:Say(0746,1250, c_Cidade +", " + c_Data ,oArial10N,,0)
		oPrinter:Say(1080,0220, c_Nome ,oArial10N,,0)
  		oPrinter:Say(1080,1150, ALLTRIM(SM0->M0_NOMECOM),oArial10N,,0)
  		oPrinter:Say(1360,0220,"Responsavel Legal (Quando Menor)",oArial10N,,0)
  		oPrinter:Say(1120,0220,"Registro: " + c_Matricula,oArial10N,,0)
 		oPrinter:Say(0953,1140,"_______________" ,oArialó32N,,0)
  		oPrinter:Say(1240,0200,"_______________" ,oArialó32N,,0)
		oPrinter:Say(0953,0210,"_______________" ,oArialó32N,,0)
		if (MOD(n_Count,1) = 0)
			oPrinter:EndPage()

		endIf
	EndIf
Return

Static Function f_ValidPerg(c_Perg)
	Local a_PAR01        := {}
	Aadd(a_PAR01, "Informe a matricula")
	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()
