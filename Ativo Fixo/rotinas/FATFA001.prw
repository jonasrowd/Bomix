#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATFA001  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma responsavel por importacao de arquivo texto.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATFA001()
	Local c_Texto  := "Esta rotina tem a finalidade de importar os ativos a partir do arquivo CSV selecionado  pelo usuแrio para o Cadastro de Ativos do sistema."
	Local c_Erro   := "ษ necessแrio selecionar o arquivo CSV para efetuar essa opera็ใo."

	Private c_File  := Space(500)	//Arquivo

	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oBtn3","oGrp1")

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
	oDlg1      := MSDialog():New( 090,230,198,670,SM0->M0_NOME,,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 006,004,{||"Arquivo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 004,025,{|u| if( Pcount( )>0, c_File := u, u := c_File) },oDlg1,151,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)

	oBtn1      := TButton():New( 004,180,"&Procurar...",oDlg1,{||c_File:=cGetFile( 'Arquivos CSV |*.csv|' , '', 1, '', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE),.T., .T. ) },037,12,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 021,180,"&Importar",oDlg1,{|| iif(Empty(c_File), ShowHelpDlg("Valida็ใo de Arquivo",{c_Erro},5,{"Selecione um arquivo CSV vแlido."},5), f_MontaRegua())},037,12,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 038,180,"&Sair",oDlg1,{|| oDlg1:End()},037,12,,,,.T.,,"",,,,.F. )

	oGrp1      := TGroup():New( 018,004,050,176,"Descri็ใo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 026,016,{||c_Texto},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,036)
	
	oDlg1:Activate(,,,.T.)
Return()

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ f_MontaRegua บAutor  ณ                     บ Data ณ		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a montagem da r้gua de processamento				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

Static Function f_MontaRegua()
	Processa({|| f_ImportaDados()}, "Aguarde...", "Importando os dados do arquivo...",.F.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_ImportaDadosบAutor  ณ                บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao resposnavel pela leitura do arquivo texto e gravacao บฑฑ
ฑฑบ          ณdos dados                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_ImportaDados()
	Private n_Pos    := 1    //Numero da linha do arquivo
	Private n_QtdInc := 0    //Conta quantas linhas foram importadas
	Private n_QtdErr := 0    //Conta quantas linhas nใo foram importadas	
	Private c_Buffer := ""   //Buffer do arquivo
	Private a_Buffer := {}   //Array com o Buffer do arquivo
	Private c_Linha  := ""

	Private l_CriaTb := .F.  //Controla a criacao da tabela temporaria
	Private c_Bord   := ""   //Borda da tabela temporแria
	Private a_Bord   := {}   //Array da tabela temporแria
	Private a_Campos := {}   //Campos da tabela temporแria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	IF AVISO(SM0->M0_NOMECOM,"Esta rotina irแ importar os ativos a partir do arquivo CSV selecionado  pelo usuแrio para o Cadastro de Ativos do sistema. Deseja realmente continuar?",{"Sim","Nใo"},2,"Aten็ใo") == 1
		IF !l_CriaTb
			Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
			Aadd(a_Bord,{"N1_GRUPO"   ,"C",TamSX3("N1_GRUPO")[1],0})
			Aadd(a_Bord,{"TB_CBASE"   ,"C",TamSX3("N1_CBASE")[1],0})
			Aadd(a_Bord,{"TB_ITEM"    ,"C",TamSX3("N1_ITEM")[1],0})
			Aadd(a_Bord,{"TB_DESCRIC" ,"C",TamSX3("N1_DESCRIC")[1],0})
			Aadd(a_Bord,{"TB_PATRIM"  ,"C",TamSX3("N1_PATRIM")[1],0})
			Aadd(a_Bord,{"TB_AQUISIC" ,"D",TamSX3("N1_AQUISIC")[1],0})
			Aadd(a_Bord,{"TB_QUANTD"  ,"N",TamSX3("N1_QUANTD")[1],TamSX3("N1_QUANTD")[2]})
			Aadd(a_Bord,{"TB_CHAPA"   ,"C",TamSX3("N1_CHAPA")[1],0})
			Aadd(a_Bord,{"TB_CALCPIS" ,"C",TamSX3("N1_CALCPIS")[1],0})	
			Aadd(a_Bord,{"TB_APOLICE" ,"C",TamSX3("N1_APOLICE")[1],0})
			Aadd(a_Bord,{"TB_DTVENC"  ,"D",TamSX3("N1_DTVENC")[1],0})
			Aadd(a_Bord,{"TB_CODSEG"  ,"C",TamSX3("N1_CODSEG")[1],0})
			Aadd(a_Bord,{"TB_CSEGURO" ,"C",TamSX3("N1_CSEGURO")[1],0})
			Aadd(a_Bord,{"TB_FORNEC"  ,"C",TamSX3("N1_FORNEC")[1],0})
			Aadd(a_Bord,{"TB_LOJA"    ,"C",TamSX3("N1_LOJA")[1],0})
			Aadd(a_Bord,{"TB_TIPOSEG" ,"C",TamSX3("N1_TIPOSEG")[1],0})
			Aadd(a_Bord,{"TB_NSERIE"  ,"C",TamSX3("N1_SERIE")[1],0})
			Aadd(a_Bord,{"TB_NFISCAL" ,"C",TamSX3("N1_NFISCAL")[1],0})
			Aadd(a_Bord,{"TB_PROJETO" ,"C",TamSX3("N1_PROJETO")[1],0})
			Aadd(a_Bord,{"TB_STATUS"  ,"C",TamSX3("N1_STATUS")[1],0})
			Aadd(a_Bord,{"TB_CODCIAP" ,"C",TamSX3("N1_CODCIAP")[1],0})
			Aadd(a_Bord,{"TB_ICMSAPR" ,"C",TamSX3("N1_ICMSAPR")[1],TamSX3("N1_ICMSAPR")[2]})
			Aadd(a_Bord,{"TB_CODBAR"  ,"C",TamSX3("N1_CODBAR")[1],0})	
			Aadd(a_Bord,{"TB_PENHORA" ,"C",TamSX3("N1_PENHORA")[1],0})
			Aadd(a_Bord,{"TB_VLAQUIS" ,"C",TamSX3("N1_VLAQUIS")[1],TamSX3("N1_VLAQUIS")[2]})
			Aadd(a_Bord,{"TB_TPCTRAT" ,"C",TamSX3("N1_TPCTRAT")[1],0})
			Aadd(a_Bord,{"TB_ORIGCRD" ,"C",TamSX3("N1_ORIGCRD")[1],0})	
			Aadd(a_Bord,{"TB_CSTPIS"  ,"C",TamSX3("N1_CSTPIS")[1],0})	
			Aadd(a_Bord,{"TB_ALIQPIS" ,"C",TamSX3("N1_ALIQPIS")[1],TamSX3("N1_ALIQPIS")[2]})
			Aadd(a_Bord,{"TB_CSTCOFI" ,"C",TamSX3("N1_CSTCOFI")[1],0})	
			Aadd(a_Bord,{"TB_ALIQCOF" ,"C",TamSX3("N1_ALIQCOF")[1],TamSX3("N1_ALIQCOF")[2]})
			Aadd(a_Bord,{"TB_CODBCC"  ,"C",TamSX3("N1_CODBCC")[1],0})	
			Aadd(a_Bord,{"TB_NUMPRO"  ,"C",TamSX3("N1_NUMPRO")[1],0})	
			Aadd(a_Bord,{"TB_INDPRO"  ,"C",TamSX3("N1_INDPRO")[1],0})	
			Aadd(a_Bord,{"TB_CBCPIS"  ,"C",TamSX3("N1_CBCPIS")[1],0})
			Aadd(a_Bord,{"TB_OBS"     ,"C",150,0})

			c_Bord := CriaTrab(a_Bord,.t.)
			Use &c_Bord Shared Alias TRC New
			Index On TB_POS To &c_Bord

			SET INDEX TO &c_Bord

			l_CriaTb:= .T.	 
		ENDIF	

		IF FT_FUSE(ALLTRIM(c_File)) == -1
	  		ShowHelpDlg("Valida็ใo de Arquivo",;
	  		{"O arquivo "+ALLTRIM(c_File)+" nใo foi encontrado."},5,;
		  	{"Verifique se o caminho estแ correto ou se o arquivo ainda se encontra no local indicado."},5)
			Return()
		Endif

		ProcRegua(FT_FLastRec())

		WHILE !FT_FEOF()
			c_Buffer := FT_FREADLN()
			c_Buffer := StrTran(c_Buffer, ";;", "; ;")
		  	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSTRTOKARR:                                                                       ณ
			//ณFuncao utilizada para retornar um array, de acordo com os dados passados como    ณ
			//ณparametro para a funcao. Esta funcao recebe uma string <cValue> e um caracter    ณ
			//ณ<cToken> que representa um separador, e para toda ocorrencia deste separador     ณ
			//ณem <cValue> e adicionado um item no array.                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
			a_Buffer:= STRTOKARR(c_Buffer,";")        

			//GRUPO 	CำD. BEM 	AQUISIวรO 	STATUS 	N. FISCAL 	ITEM 	DESCRIวรO 	CHASSIS	PLACA 	QUANT. 	VALOR 	CำD. FORNEC.	LOJA 	VIDA ฺTIL 	MESES USO 	PLAQUETA
			//04 		10 			10 			10 		9 			2 		140 		20 		8 		3 		10 		6 				2		3 			3 			8
			//NฺMERO 	NฺMERO 	    DATA 		TEXTO 	NฺMERO 		NฺMERO 	TEXTO 		TEXTO 	TEXTO 	NฺMERO 	NฺMERO 	TEXTO 			TEXTO	NฺMERO 		NฺMERO 		ALFANUMษRICO

			//VENDA 	DEPRECIA 	CATEGORIA 	MARCA	UF		N.C.M. 	CNPJ    VIDA ฺTIL	MESES USO
			//10		10 			10 			20 		2 		10 		18 		3 			3 	
			//DATA 		DATA 		TEXTO 		TEXTO 	TEXTO 	NฺMERO 	NฺMERO 	NฺMERO 		NฺMERO

			c_GRUPO   := PADR(UPPER(AllTrim(a_Buffer[1])), TAMSX3("N1_GRUPO")[1])	  		// Grupo do Bem
			c_CBASE   := PADR(UPPER(AllTrim(a_Buffer[2])), TAMSX3("N1_CBASE")[1])  		    // C๓digo do Bem
			c_ITEM    := PADR(UPPER(AllTrim(a_Buffer[3])), TAMSX3("N1_ITEM")[1])	  		// Item do Bem
			c_DESCRIC := PADR(UPPER(AllTrim(a_Buffer[4])), TAMSX3("N1_DESCRIC")[1])	  		// Descri็ใo do Bem
			c_PATRIM  := PADR(UPPER(AllTrim(a_Buffer[5])), TAMSX3("N1_PATRIM")[1])	  		// Classifica็ใo do Bem
			c_AQUISIC := PADR(UPPER(AllTrim(a_Buffer[6])), TAMSX3("N1_AQUISIC")[1])	  		// Data de Aquisi็ใo
			c_QUANTD  := PADR(UPPER(AllTrim(a_Buffer[7])), TAMSX3("N1_QUANTD")[1])	  		// Quantidade
			c_CHAPA   := PADR(UPPER(AllTrim(a_Buffer[8])), TAMSX3("N1_CHAPA")[1])	  		// Plaqueta
			c_CALCPIS := PADR(UPPER(AllTrim(a_Buffer[9])), TAMSX3("N1_CALCPIS")[1])	  		// Cแlcula PIS/COFINS
			c_APOLICE := PADR(UPPER(AllTrim(a_Buffer[10])), TAMSX3("N1_APOLICE")[1])  		// Ap๓lice
			c_DTVENC  := PADR(UPPER(AllTrim(a_Buffer[11])), TAMSX3("N1_DTVENC")[1])	  		// Data de Vencimento da Ap๓lice
			c_CODSEG  := PADR(UPPER(AllTrim(a_Buffer[12])), TAMSX3("N1_CODSEG")[1])	  		// C๓digo da Seguradora
			c_CSEGURO := PADR(UPPER(AllTrim(a_Buffer[13])), TAMSX3("N1_CSEGURO")[1])  		// Nome da Seguradora
			c_FORNEC  := PADR(UPPER(AllTrim(a_Buffer[14])), TAMSX3("N1_FORNEC")[1])	  		// Fornecedor
			c_LOJA    := PADR(UPPER(AllTrim(a_Buffer[15])), TAMSX3("N1_LOJA")[1])	  		// Loja
			c_TIPOSEG := PADR(UPPER(AllTrim(a_Buffer[16])), TAMSX3("N1_TIPOSEG")[1])  		// Tipo de Seguro
			c_NSERIE  := PADR(UPPER(AllTrim(a_Buffer[17])), TAMSX3("N1_NSERIE")[1])	  		// S้rie da NF
			c_NFISCAL := PADR(UPPER(AllTrim(a_Buffer[18])), TAMSX3("N1_NFISCAL")[1])  		// NF
			c_PROJETO := PADR(UPPER(AllTrim(a_Buffer[19])), TAMSX3("N1_PROJETO")[1])  		// Projeto
			c_STATUS  := PADR(UPPER(AllTrim(a_Buffer[20])), TAMSX3("N1_STATUS")[1])	  		// Status
			c_CODCIAP := PADR(UPPER(AllTrim(a_Buffer[21])), TAMSX3("N1_CODCIAP")[1])  		// C๓digo CIAP
			c_ICMSAPR := PADR(UPPER(AllTrim(a_Buffer[22])), TAMSX3("N1_ICMSAPR")[1])  		// ICMS do Item
			c_CODBAR  := PADR(UPPER(AllTrim(a_Buffer[23])), TAMSX3("N1_CODBAR")[1])	  		// C๓digo de Barra
			c_PENHORA := PADR(UPPER(AllTrim(a_Buffer[24])), TAMSX3("N1_PENHORA")[1])  		// Situa็ใo de Penhora
			c_VLAQUIS := PADR(UPPER(AllTrim(a_Buffer[25])), TAMSX3("N1_VLAQUIS")[1])  		// Valor de Aquisi็ใo
			c_TPCTRAT := PADR(UPPER(AllTrim(a_Buffer[26])), TAMSX3("N1_TPCTRAT")[1])  		// Tipo de Controle
			c_ORIGCRD := PADR(UPPER(AllTrim(a_Buffer[27])), TAMSX3("N1_ORIGCRD")[1])  		// Origem do Bem
			c_CSTPIS  := PADR(UPPER(AllTrim(a_Buffer[28])), TAMSX3("N1_CSTPIS")[1])	  		// Situa็ใo Tributแria PIS
			c_ALIQPIS := PADR(UPPER(AllTrim(a_Buffer[29])), TAMSX3("N1_ALIQPIS")[1])  		// Alํquota PIS
			c_CSTCOFI := PADR(UPPER(AllTrim(a_Buffer[30])), TAMSX3("N1_CSTCOFI")[1])  		// Situa็ใo Tributแria COFINS
			c_ALIQCOF := PADR(UPPER(AllTrim(a_Buffer[31])), TAMSX3("N1_ALIQCOF")[1])  		// Alํquota COFINS
			c_CODBCC  := PADR(UPPER(AllTrim(a_Buffer[32])), TAMSX3("N1_CODBCC")[1])	  		// C๓digo de Base de Cแlculo do Cr้dito
			c_NUMPRO  := PADR(UPPER(AllTrim(a_Buffer[33])), TAMSX3("N1_NUMPRO")[1])	  		// Tipo de Processo Referenciado
			c_CBCPIS  := PADR(UPPER(AllTrim(a_Buffer[34])), TAMSX3("N1_CBCPIS")[1])	  		// Base de Cแlculo do PIS/COFINS
			c_OBS     := ""

			DBSELECTAREA("SN1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SN1") + c_CBASE + c_ITEM)
			IF FOUND()
		    	n_QtdErr++
				c_Obs  := "Ativo " + AllTrim(c_CBASE) + " Item " + AllTrim(c_ITEM)" nใo foi importado pela rotina, porque jแ estแ cadastrado no sistema."
			ELSE
			ENDIF
		END
User Function Myatfa010Inc()
Local aItens := {}
Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica dos itens do ativo 
Local aCab := { {'N1_FILIAL' ,'01' ,NIL},; 
{'N1_CBASE' ,'13 ' ,NIL},; 
{'N1_ITEM' ,'01' ,NIL},; 
{'N1_AQUISIC' ,dDataBase ,NIL},; 
{'N1_DESCRIC' ,'MS EXEC AUTO' ,NIL},; 
{'N1_QUANTD' , 1 ,NIL},; 
{'N1_CHAPA' ,'987' ,NIL} }
// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica da capa do bem 
Private lMsHelpAuto := .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private lMsErroAuto := .f. // Determina se houve alguma inconsistencia na execucao da rotina 
aAdd(aItens,{ {'N3_TIPO' ,'01' , NIL},;
{'N3_HISTOR' ,"INCLUSAOTIPO 01 " , NIL},; 
{'N3_TPSALDO' ,'1' , NIL},; 
{'N3_TPDEPR' ,'1' , NIL},; 
{'N3_CCONTAB' ,'11101001 ' , NIL},; 
{'N3_VORIG1' , 10000 , NIL},; 
{'N3_VORIG2' , 20000 , NIL},; 
{'N3_VORIG3' , 30000 , NIL},; 
{'N3_VMXDEPR' , 0 , NIL},; 
{'N3_VLSALV1' , 0 , NIL},; 
{'N3_PERDEPR' , 0 , NIL},; 
{'N3_PRODMES' , 0 , NIL},; 
{'N3_PRODANO' , 0 , NIL},; 
{'N3_DINDEPR' ,dDataBase ,NIL} } ) 
//array com os dados a serem enviados pela MsExecAuto() para gravacao automatica do item tipo 01
aAdd(aItens,{ {'N3_TIPO' ,'10' , NIL},;
{'N3_HISTOR' ,"INCLUSรO TIPO 10 " , NIL},; 
{'N3_TPSALDO' ,'1' , NIL},; 
{'N3_TPDEPR' ,'1' , NIL},; 
{'N3_CCONTAB' ,'11101001 ' , NIL},; 
{'N3_VORIG1' , 10000 , NIL},; 
{'N3_VORIG2' , 20000 , NIL},; 
{'N3_VORIG3' , 30000 , NIL},; 
{'N3_VMXDEPR' , 0 , NIL},; 
{'N3_VLSALV1' , 0 , NIL},; 
{'N3_PERDEPR' , 0 , NIL},; 
{'N3_PRODMES' , 0 , NIL},; 
{'N3_PRODANO' , 0 , NIL},; 
{'N3_DINDEPR' ,dDataBase ,NIL} } ) //array com os dados a serem enviados pela MsExecAuto() para gravacao automatica do item tipo 10 
MSExecAuto( {|X,Y,Z| ATFA010(X,Y,Z)} ,aCab ,aItens, 3) 
If lMsErroAuto 
lRetorno := .F. 
MostraErro()
Else
lRetorno:=.T.
EndIf
Return








				//N3_FILIAL	N3_CBASE	N3_ITEM	N3_TIPO	N3_TIPREAV	N3_BAIXA	N3_HISTOR	N3_TPSALDO	N3_TPDEPR	N3_CCONTAB	N3_CUSTBEM	N3_CDEPREC	N3_CCUSTO	N3_CCDEPR	N3_CDESP	N3_CCORREC	N3_NLANCTO	N3_DLANCTO	N3_DINDEPR	N3_FIMDEPR	N3_DEXAUST	N3_VORIG1	N3_TXDEPR1	N3_VORIG2	N3_TXDEPR2	N3_VORIG3	N3_TXDEPR3	N3_VORIG4	N3_TXDEPR4	N3_VORIG5	N3_TXDEPR5	N3_VRCBAL1	N3_VRDBAL1	N3_VRCMES1	N3_VRDMES1	N3_VRCACM1	N3_VRDACM1	N3_VRDBAL2	N3_VRDMES2	N3_VRDACM2	N3_VRDBAL3	N3_VRDMES3	N3_VRDACM3	N3_VRDBAL4	N3_VRDMES4	N3_VRDACM4	N3_VRDBAL5	N3_VRDMES5	N3_VRDACM5	N3_INDICE1	N3_INDICE2	N3_INDICE3	N3_INDICE4	N3_INDICE5	N3_AQUISIC	N3_DTBAIXA	N3_VRCDM1	N3_VRCDB1	N3_VRCDA1	N3_PERDEPR	N3_CRIDEPR	N3_CALDEPR	N3_VMXDEPR	N3_VLSALV1	N3_DEPREC	N3_CALCDEP	N3_PRODANO	N3_PRODMES	N3_PRODACM	N3_OK	N3_SEQ	N3_CCDESP	N3_CCCDEP	N3_CCCDES	N3_CCCORR	N3_SUBCTA	N3_SUBCCON	N3_SUBCDEP	N3_SUBCCDE	N3_SUBCDES	N3_SUBCCOR	N3_BXICMS	N3_SEQREAV	N3_AMPLIA1	N3_AMPLIA2	N3_AMPLIA3	N3_AMPLIA4	N3_AMPLIA5	N3_CODBAIX	N3_FILORIG	N3_CLVL	N3_CLVLCON	N3_CLVLDEP	N3_CLVLCDE	N3_CLVLDES	N3_CLVLCOR	N3_IDBAIXA	N3_LOCAL	N3_NOVO	N3_QUANTD	N3_PERCBAI	N3_NODIA	N3_DIACTB	N3_DTACELE	N3_VLACEL1	N3_VLACEL2	N3_VLACEL3	N3_VLACEL4	N3_VLACEL5	N3_CLVRCOA	N3_CLVRDEA	N3_RATEIO	N3_CODRAT	N3_VRCACM2	N3_VRCACM3	N3_VRCACM4	N3_VRCACM5	N3_VRCDA2	N3_VRCDA3	N3_VRCDA4	N3_VRCDA5	D_E_L_E_T_	R_E_C_N_O_	R_E_C_D_E_L_	N3_ATVORIG
				//010101	27020001  	0001	01	               	0	APAR.  DE  AR CONDICIONADO  10.500  BTU 	1	1	103010106           	         	30102010116         	         	103010206           	                    	                    	         	        	19970115	        	        	730	10	0	10	0	10	0	10	0	10	0	0	0	0	0	730	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	19970115	        	0	0	0	0	00             	               	0	0	                                        	 	0	0	0	  	001	         	         	         	         	         	         	         	         	         	         	0	  	0	0	0	0	0	      	      	         	         	         	         	         	         	 	      	S	0	0	          	  	        	0	0	0	0	0	0	0	2	            	0	0	0	0	0	0	0	0	 	164	0	               

				c_NcmAnt := SB1->B1_POSIPI
				c_Desc   := SB1->B1_DESC
		    	n_QtdInc++

				If Upper(AllTrim(c_Ncm)) == "BLOQUEAR"
					RECLOCK("SB1", .F.)
					SB1->B1_MSBLQL := '1'
					MSUNLOCK()

					c_Obs  := "Produto " + AllTrim(c_CBase) + " foi bloqueado pela rotina, porque o Pos.IPI/NCM cadastrado ้ invแlido."
				Else
					RECLOCK("SB1", .F.)
					SB1->B1_POSIPI := c_Ncm
					MSUNLOCK()

					c_Obs  := "Pos.IPI/NCM do Produto " + AllTrim(c_CBase) + " foi atualizado pela rotina."
				Endif
			ENDIF

			RECLOCK("TRC",.T.)
			TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
			TRC->TB_FILIAL  := c_Grupo
			TRC->TB_PRODUTO := c_CBase
			TRC->TB_DESC    := c_Desc
			TRC->TB_NCMANT  := c_NcmAnt
			TRC->TB_NCM     := IIF(Upper(AllTrim(c_Ncm)) == "BLOQUEAR", c_NcmAnt, c_Ncm)
			TRC->TB_OBS     := c_Obs
			MSUNLOCK()

			FT_FSKIP()
			n_Pos++
			IncProc()
		END

		FT_FUSE()
		AVISO(SM0->M0_NOME,"O programa processou todo o arquivo com " + ALLTRIM(STR(n_QtdInc+n_QtdErr)) + " registros. Foram atualizados " + ALLTRIM(STR(n_QtdInc)) + " registros e " + ALLTRIM(STR(n_QtdErr)) + " registros nใo foram atualizados pela rotina.",{"OK"},2,"Aviso")

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

	 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'    ,'@!'})
		Aadd(a_Campos,{"TB_FILIAL"  ,,'Filial'   ,'@!'})
		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  ,'@!'})
		Aadd(a_Campos,{"TB_DESC"    ,,'Descri็ใo'  ,'@!'})
		Aadd(a_Campos,{"TB_NCMANT"  ,,'Pos.IPI/NCM Anterior'  ,X3Picture("B1_POSIPI")})
		Aadd(a_Campos,{"TB_NCM"   	,,'Pos.IPI/NCM'  ,X3Picture("B1_POSIPI")})
		Aadd(a_Campos,{"TB_OBS"     ,,'Observa็ใo' ,'@!'})

		o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de Atualiza็ใo de Pos.IPI/NCM da tabela SB1 - Cadastro de Produtos",,,.F.,,,,,,.T.,,,.T. )
		o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn:= TButton():New( 253,10,"Log p/ Texto" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
		o_Btn:= TButton():New( 253,60,"Sair"   ,o_Dlg,{|| o_Dlg:End() },041,012,,,,.T.,,"",,,,.F. )

		o_Dlg:Activate(,,,.T.)

		DBSELECTAREA("TRC")
		TRC->(DBCLOSEAREA())
	ENDIF
Return() 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ f_ExpLog บ Autor ณ                  บ Data ณ    Julho/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exporta o log de importa็ใo para um arquivo texto          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_ExpLog()
	Local c_Destino := FCREATE("C:\TEMP\LOG_ATUALIZACAO_POSIPI_NCM.TXT")
	Local c_Linha := ""

	// TESTA A CRIAวรO DO ARQUIVO DE DESTINO
	IF c_Destino == -1
		MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
	 	RETURN
	ENDIF

	c_Linha:= "LINHA ;   FILIAL;   "+Padr("PRODUTO", TamSX3('B1_COD')[1])+";   "+Padr("DESCRICAO", TamSX3('B1_COD')[1])+";   "+Padr("NCMANT", TamSX3('B1_COD')[1])+";   "+Padr("NCM", TamSX3('B1_COD')[1])+";   "+Padr("OBSERVACAO", TamSX3('B1_COD')[1]) + CHR(13)+CHR(10)

	IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
		IF !MSGALERT("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?","Aten็ใo")
			FCLOSE(c_Destino)
			DBSELECTAREA("TRC")
			DBGOTOP()
   	   		Return
		ENDIF
 	ENDIF

	DBSELECTAREA("TRC")
	TRC->(DBGOTOP())

	Count To n_Reg
	ProcRegua(n_Reg)

	TRC->(DBGOTOP())
	WHILE !(TRC->(EOF()))
		c_Linha:= STRZERO(TRC->TB_POS,6)+";   "+TRC->TB_FILIAL+";   "+TRC->TB_PRODUTO+";   "+TRC->TB_DESC+";   "+TRC->TB_NCMANT+";   "+TRC->TB_NCM+";   "+TRC->TB_OBS + CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?","Aten็ใo")
				FCLOSE(c_Destino)
				DBSELECTAREA("TRC")
				DBGOTOP()
	   	   		Return
			ENDIF
	 	ENDIF
	 	
	 	IncProc()
	 	TRC->(DBSKIP())
	ENDDO 

	AVISO(SM0->M0_NOMECOM,"Log exportado para o arquivo C:\TEMP\LOG_ATUALIZACAO_POSIPI_NCM.TXT",{"Ok"},2,"Aten็ใo")
	FCLOSE(c_Destino)
	DBSELECTAREA("TRC")
	DBGOTOP()
Return