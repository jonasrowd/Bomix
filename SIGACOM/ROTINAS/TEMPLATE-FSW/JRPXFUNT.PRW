#INCLUDE "TOTVS.CH"
#include 'Ap5Mail.ch'
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JRPXFUNG  ºAutor  ³FABRICA SOFTWARE BA º Data ³  JAN/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa com as funcoes genericas da Fabrica de Software    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fabrica de Software - Unidade Bahia                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNPJXTEM  ºAutor  ³Francisco Rezende   º Data ³  jan/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao generica para gravacao dos CNPJs dos clientes        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ c_Rotina		Rotina que esta fazendo a chamada             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Retorna .T. Se encontrar a empresa                         º±±
±±º          ³ Retorna .F. Se nao encontrar a empresa                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    A T U A L I Z A C O E S                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      |PROGRAMADOR       |ALTERACOES                               º±±
±±º          |                  |                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TBCNPJXTEM(c_Rotina)

	Local l_Ret		:= .T.
	Local a_CNPJ	:= {}

	IF c_Rotina == "PCOMA001"	//XML da Nota Fiscal de Entrada

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ := {	"01120386000134",;	//Carboflex;
		"16180770000101",;		//Motiva;
		"13210696000122",;		//Motiva;
		"12029427000100",;		//Motiva;
		"12029427000282",;		//Motiva;
		"12029427001505",;		//Motiva;
		"12029427001254",;		//Motiva;
		"12029427001335",;		//Motiva;
		"12021427001416",;		//Motiva;
		"12029427001688",;		//Motiva;
		"15851413000157",;		//Pedreiras Valeria;
		"34153866000154",;		//Pedreiras Valeria;
		"13194410000405",;		//Pedreiras Valeria;
		"13194410000162",;		//Pedreiras Valeria;
		"13194410000596",;		//Pedreiras Valeria;
		"73463408000173",;		//Pedreiras Valeria;
		"32631657000739",;		//Pedreiras Valeria;
		"32631657000496",;		//Pedreiras Valeria;
		"32631657000143",;		//Pedreiras Valeria;
		"32631657001549",;		//Pedreiras Valeria;
		"32631657002600",;		//Pedreiras Valeria;
		"32631657000305",;		//Pedreiras Valeria;
		"32631657000810",;		//Pedreiras Valeria;
		"10538497000150",;		//Pedreiras Valeria;
		"03763491000200",;		//Moinho;
		"03763491000110",;		//Moinho;
		"03763491000382",;		//Moinho;
		"03763491000544",;		//Moinho;
		"03763491000625",;		//Moinho;
		"03763491000463",;		//Moinho;
		"03763491000706",;		//Moinho;
		"15257819000106",;		//EGBA;
		"07761036000137",;		//SC MED;
		"08112678000178",;		//Renco;
		"16167009000121",;		//Hydros;
		"16167009000393",;		//Hydros;
		"16167009000202",;		//Hydros;
		"16167009000474",;		//Hydros;
		"13937479000139",;		//Hydros;
		"13937479000210",;		//Hydros;
		"13937479000309",;		//Hydros;
		"07515742000107",;		//Hydros;
		"07515742000280",;		//Hydros;
		"00653937000166",;		//Hydros;
		"18716724000100",;		//Hydros;
		"18755153000104",;		//Hydros;
		"18593510000185",;		//Hydros;
		"06198623000123",;		//Hydros;
		"04463152000181",;		//Masterlub;
		"04463152000343",;		//Masterlub;
		"04463152000262",;		//Masterlub;
		"04463152000363",;		//Masterlub;
		"15102809000100",;		//Morais de Castro;
		"15102809000282",;		//Morais de Castro;
		"15102809000363",;		//Morais de Castro;
		"04159894000118",;		//Triunfo;
		"10473144000119",;		//Triunfo;
		"10532954000107",;		//Triunfo;
		"05800732000180",;		//Triunfo;
		"11267319000528",;		//Dulce;
		"18811987000190",;		//Dulce;
		"18759010000170",;		//Dulce;
		"18251848000159",;		//Dulce;
		"05776105000150",;		//Dulce;
		"19009535000151",;		//Dulce;
		"11267319000102",;		//Avatim;
		"10450580000253",;		//Avatim;
		"11267319000366",;		//Avatim;
		"11267319000447",;		//Avatim;
		"11267319000528",;		//Avatim;
		"11438882000279",;		//Avatim;
		"11819413000119",;		//Avatim;
		"12252653000147",;		//Avatim;
		"12495315000136",;		//Avatim;
		"12530014000104",;		//Avatim;
		"12615582000108",;		//Avatim;
		"12723317000135",;		//Avatim;
		"13634758000123",;		//Avatim;
		"13677267000160",;		//Avatim;
		"14262241000113",;		//Avatim;
		"14420028000192",;		//Avatim;
		"14428639000187",;		//Avatim;
		"14685042000118",;		//Avatim;
		"15536686000107",;		//Avatim;
		"15652206000173",;		//Avatim;
		"16384878000108",;		//Avatim;
		"16799452000115",;		//Avatim;
		"16821013000161",;		//Avatim;
		"16897732000166",;		//Avatim;
		"16949665000186",;		//Avatim;
		"16949665000267",;		//Avatim;
		"16949665000348",;		//Avatim;
		"16979380000198",;		//Avatim;
		"17023038000182",;		//Avatim;
		"17234640000169",;		//Avatim;
		"17290449000134",;		//Avatim;
		"17845305000105",;		//Avatim;
		"17872885000111",;		//Avatim;
		"17914119000172",;		//Avatim;
		"18287541000108",;		//Avatim;
		"18759010000170",;		//Avatim;
		"18811987000190",;		//Avatim;
		"18251848000159",;		//Avatim;
		"19009535000151",;		//Avatim;
		"29981297000103",;		//VESCON;
		"07673609000170",;		//HomeSign;
		"05083714000124",;		//HomeSign;
		"13549848000116",;		//HomeSign;
		"07673609000170",;		//HomeSign;
		"05083714000124",;		//HomeSign;
		"07673609000251",;		//HomeSign;
		"07292680000103",;		//Inoquimica;
		"18413548000129",;		//MONTERREY;
		"18413548000200",;		//MONTERREY;
		"18413548000390",;		//MONTERREY;
		"18413548000471",;		//MONTERREY;
		"18413548000552",;		//MONTERREY;
		"18413548000633",;		//MONTERREY;
		"18413548000714",;		//MONTERREY;
		"18413548000803",;		//MONTERREY;
		"18413548000986",;		//MONTERREY;
		"18413548001010",;		//MONTERREY;
		"18413548001109",;		//MONTERREY;
		"18413548001281",;		//MONTERREY;
		"18413548001362",;		//MONTERREY;
		"18413548001443",;		//MONTERREY;
		"18413548001524",;		//MONTERREY;
		"20650167000105",;		//MONTERREY;
		"18413548002687",;		//MONTERREY;
		"18413548002768",;		//MONTERREY;
		"18413548002849",;		//MONTERREY;
		"18413548002920",;		//MONTERREY;
		"18413548003063",;		//MONTERREY;
		"18413548002334",;		//MONTERREY;
		"18413548001605",;		//MONTERREY;
		"18413548002253",;		//MONTERREY;
		"18413548001796",;		//MONTERREY;
		"18413548004205",;		//MONTERREY;
		"18413548004388",;		//MONTERREY;
		"18413548004540",;		//MONTERREY;
		"18413548004469",;		//MONTERREY;
		"18413548001877",;		//MONTERREY;
		"18413548001958",;		//MONTERREY;
		"18413548002172",;		//MONTERREY;
		"18413548002415",;		//MONTERREY;
		"18413548002091",;		//MONTERREY;
		"18413548002504",;		//MONTERREY;
		"18413548003497",;		//MONTERREY;
		"18413548003810",;		//MONTERREY;
		"18413548003144",;		//MONTERREY;
		"18413548003578",;		//MONTERREY;
		"18413548003900",;		//MONTERREY;
		"18413548004035",;		//MONTERREY;
		"18413548003659",;		//MONTERREY;
		"18413548003306",;		//MONTERREY;
		"18413548004116",;		//MONTERREY;
		"18413548003225",;		//MONTERREY;
		"18413548003730",;		//MONTERREY;
		"18413548004701",;		//MONTERREY;
		"18413548004620",;		//MONTERREY;
		"18413548004892",;		//MONTERREY;
		"15183098000137",;		//INDEBA;
		"07656156000174",;		//INDEBA;
		"03925555000132",;		//INDEBA;
		"07947473000140",;		//INDEBA;
		"07947473000220",;		//INDEBA;
		"07947473000301",;		//INDEBA;
		"07947473000492",;		//INDEBA;
		"07947473000573",;		//INDEBA;
		"07947473000654",;		//INDEBA;
		"07947473000735",;		//INDEBA;
		"07947473000816",;		//INDEBA;
		"18585951000135",;		//INDEBA;
		"15183098001613",;		//INDEBA;
		"15183098001702",;		//INDEBA;
		"15183098001885",;		//INDEBA;
		"15183098000218",;		//INDEBA;
		"15183098000307",;		//INDEBA;
		"15183098000480",;		//INDEBA;
		"15183098000722",;		//INDEBA;
		"15183098000803",;		//INDEBA;
		"15183098000994",;		//INDEBA;
		"15183098001028",;		//INDEBA;
		"15183098001109",;		//INDEBA;
		"15183098001370",;		//INDEBA;
		"15183098001451",;		//INDEBA;
		"15183098001532",;		//INDEBA;
		"15183098000641",;		//INDEBA;
		"15183098001966",;		//INDEBA;
		"15183098002008"}		//INDEBA;

		l_Ret := f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "GPER030"	//Importacao do Ativo Fixo

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= {;
		"19387353000114",;		//MAXXLOG;
		"19448277000100",;		//MAXXLOG;
		"05232089000135";		//GRUPO B3;
		}

		l_Ret 		:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "PATFM001"	//Importacao do Ativo Fixo

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= {	"01120386000138",;		//Unijorge;
		"13554910000168",;					//CBPM;
		"00141269000279",;					//EAO;
		"13595251000108"}				//conder

		l_Ret 		:= f_VldCNPJ( a_CNPJ )


	ELSEIF c_Rotina == "PCFGA003"

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= {"15191786000149",;
		"07673609000170",;
		"05232089000135",;
		"05232089000216",;
		"05480302000128",;
		"13547484000135",;
		"13547484000135",;
		"13547484002502",;
		"13547484002260",;
		"13547484000305",;
		"13547484000488",;
		"13547484002693",;
		"13547484000640",;
		"13547484000720",;
		"13547484002774",;
		"13547484000992",;
		"13547484001026",;
		"13547484002855",;
		"13547484001611",;
		"13547484001883",;
		"13547484002189",;
		"05949989000289",;
		"13547484001611",;
		"15183098000137",;
		"07656156000174",;
		"03925555000132",;
		"07947473000140",;
		"07947473000220",;
		"07947473000301",;
		"07947473000492",;
		"07947473000573",;
		"07947473000654",;
		"07947473000735",;
		"07947473000816"}

		l_Ret 		:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "ALCXCC"	//Controle de Alcada por Centro de Custo

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= {	"03763491000200",;		//Moinho;
		"03763491000200",;		//Moinho;
		"03763491000110",;		//Moinho;
		"03763491000382",;		//Moinho;
		"03763491000544",;		//Moinho;
		"03763491000625",;		//Moinho;
		"03763491000463",;		//Moinho;
		"03763491000706",;		//Moinho;
		"16167009000121",;		//Hydros;
		"16167009000393",;		//Hydros;
		"16167009000202",;		//Hydros;
		"16167009000474",;		//Hydros;
		"13937479000139",;		//Hydros;
		"13937479000210",;		//Hydros;
		"13937479000309",;		//Hydros;
		"07515742000107",;		//Hydros;
		"07515742000280",;		//Hydros;
		"00653937000166",;		//Hydros;
		"18716724000100",;		//Hydros;
		"18755153000104",;		//Hydros;
		"18593510000185",;		//Hydros;
		"06198623000123",;		//Hydros;
		"13526884000164",;		//FACS;
		"13526884001802",;		//FACS;
		"13526884001640"}		//FACS;

		l_Ret 		:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "BOOKFIN"	//Book de relatorios do Financeiro

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= { "96823398000135",;	//GRUPO ESTRELA;
		"03212079000102",;			//GRUPO ESTRELA;
		"05654919000112",;			//GRUPO ESTRELA;
		"03895272000156",;			//GRUPO ESTRELA;
		"96821608000156",;			//GRUPO Estrela;
		"16167009000121",;			//Hydros;
		"16167009000393",;			//Hydros;
		"16167009000202",;			//Hydros;
		"16167009000474",;			//Hydros;
		"13937479000139",;			//Hydros;
		"13937479000210",;			//Hydros;
		"13937479000309",;			//Hydros;
		"07515742000107",;			//Hydros;
		"07515742000280",;			//Hydros;
		"00653937000166",;			//Hydros;
		"18716724000100",;			//Hydros;
		"18755153000104",;			//Hydros;
		"18593510000185",;			//Hydros;
		"06198623000123",;			//Hydros;
		"15257819000106",;			//EGBA;
		"02534128000160",;			//VIPAC
		"01768141000111"}			//VIPAC

		l_Ret 		:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "FCOMR001"	//MAPA DE COTACAO

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= { "00858151000185",;		//BETUMAT;
		"00858151000266",; 				//BETUMAT;
		"00858151000428",; 				//BETUMAT;
		"00858151000509"} 				//BETUMAT;

		l_Ret 	:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "PGLIM001"	//Lei de Informatica

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= { "05480302000128",;		//QBEX;
		"07157915000154" }				//Accept;
		l_Ret 	:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "MAPCOT"	//Mapa de Cotacao

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= { "13526884000164",;		//FACS;
		"13526884001802",;				//FACS;
		"13526884001640"}				//FACS;

		l_Ret 	:= f_VldCNPJ( a_CNPJ )

	ELSEIF c_Rotina == "SERASA"	//SERASA

		IF SM0->M0_CODIGO == "99"	//Empresa teste nao faz validacao
			Return(l_Ret)
		ENDIF

		a_CNPJ	:= { "03763491000200",;		//Moinho;
		"03763491000200",;		//Moinho;
		"03763491000110",;		//Moinho;
		"03763491000382",;		//Moinho;
		"03763491000544",;		//Moinho;
		"03763491000625",;		//Moinho;
		"03763491000463",;		//Moinho;
		"03763491000706",;		//Moinho;
		"08112678000178"}

		l_Ret 	:= f_VldCNPJ( a_CNPJ )

	ENDIF

Return( l_Ret )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f_VldCNPJ ºAutor  ³Francisco Rezende   º Data ³  ABR/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao generica para gravacao dos CNPJs dos clientes        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ a_CNPJ    	Vetor com os CNPJs liberados.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Retorna .T. Se encontrar a empresa                         º±±
±±º          ³ Retorna .F. Se nao encontrar a empresa                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    A T U A L I Z A C O E S                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      |PROGRAMADOR       |ALTERACOES                               º±±
±±º          |                  |                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f_VldCNPJ(a_CNPJ)

	Local l_RetCNPJ	:= .T.

	DBSELECTAREA("SM0")
	DBSETORDER(1)
	DBSEEK(cEmpAnt+cFilAnt)
	IF ASCAN(a_CNPJ,SM0->M0_CGC) == 0

		Aviso(SM0->M0_NOMECOM,"A empresa "+SM0->M0_CGC+" não está autorizada para utilizar esta rotina",{"Voltar"},2,"Atenção")

		l_RetCNPJ    := .F.

	ENDIF

Return( l_RetCNPJ )

