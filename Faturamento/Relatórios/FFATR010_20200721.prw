#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"    


//Constantes
#Define CRLF    Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  FFATR010      º Autor ³ VICTOR SOUSA       º Data ³  05/04/20º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATÓRIO GERA OS INSUMOS CONSUMIDOS NA PRODUÇÃO           º±±
±±º          ³ DA NOTA FISCAL                                             º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function FFATR010


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local aArea        := GetArea()
	Local cQuery        := ""
	Local oFWMsExcel
	Local oExcel

	Local cDesc1         := "Este programa tem como objetivo exportar o relatório de CONSUMO DE INSUMOS POR NF"
	Local cDesc2         := "para o EXCEL de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "SERÁ GRAVADO NA PASTA c:\bomix\"
	Local cPict          := ""
	Local titulo         := "INSUMO POR NF - EXCEL"
	Local nLin           := 80
	Local Cabec1         := ""
	//	Local Cabec2         := "Cliente/Fornecedor                                           Emissão   Num.        Pc       Venc Real  Vencimento            Valor         "
	Local Cabec2         := "Cliente/Fornecedor   Nat/CC                 Emissão   Num.        Pc       Venc Real  Vencimento        Receber          Pagar          Saldo      Usuario"	
	Local imprime        := .T.
	Local aOrd 			 := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	//Private limite       := 132    
	Private limite       := 240 
	Private tamanho      := "M"
	Private nomeprog     := "FFATR010" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFATR010" // Coloque aqui o nome do arquivo usado para impressao em disco        
	Private c_Perg       := "FFATR010" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString   	 := ""                      
	MPCC := 0.00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	CriaPerg(c_Perg)
	Pergunte(c_Perg,.F.)

	wnrel := SetPrint(cString,NomeProg,c_Perg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Cabec1 := "Saldo inicial: " + Transform(MV_PAR09, "@E 999,999,999.99")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local nOrdem
	Local c_Tipo     := ""
	Local n_TotTipo  := 0
	Local n_TotDia   := 0
	Local n_TotDiaRc := 0
	Local n_Total    := 0
	Local n_TotalRec := 0
	Local d_Dia      := Stod("  /  /  ")
	Local a_Titulos  := {}
	Local n_Saldo    := MV_PAR09


	c_Qry := f_Qry()

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If QRY->(Eof())
		ShowHelpDlg(SM0->M0_NOME, {"Nenhum registro encontrado."},5,{"Verifique os parâmetros informados."},5)
		QRY->(dbCloseArea())
		Return
	Endif
	QRY->(dbCloseArea())

RETURN


Static Function f_Qry()
	Local aArea        := GetArea()
	Local cQuery        := ""
	Local cAliasTrb        := "QRYPRO"
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := "c:\bomix\" //FFATR010.xml GetTempPath()+'FFATR010.xml'
	local ccodant :=""
	local cnotafiscal :=""
	Local aCODIGO 	 := {}

	//	cQuery := "Exec P12OFICIAL.dbo.Bomix_Insumos_NF '" +MV_PAR01+ "', '"+MV_PAR02+"', '"+DTOS(MV_PAR03)+"', '"+DTOS(MV_PAR04)+ "', '" + xFilial("SD2") +"'"
	//	cQuery := "Exec P12OFICIAL.dbo.Bomix_Insumos_NF '" +MV_PAR01+ "'"+", '" + xFilial("SD2") +"'"
	cQuery := "Exec P12OFICIAL.dbo.Bomix_Insumos_NF '" +MV_PAR01+ "', '"+MV_PAR02+"', '"+ xFilial("SD2") +"'"

	MemoWrit("FFATR010.SQL",cQuery)

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), (cAliasTrb), .F., .T.)

	dbSelectArea(cAliasTrb)
	dbGoTop()



	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()





	//FLUXO DE CAIXA
	oFWMsExcel:AddworkSheet("INSUMO")
	//Criando a Tabela
	oFWMsExcel:AddTable("INSUMO","INSUMO")     
	oFWMsExcel:AddColumn("INSUMO","INSUMO","FIIAL                 ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","CODIGO                ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","DESCRICAO             ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","UNIDADE               ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","QUANTIDADE            ",3,2,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","PREÇO VENDA           ",3,3,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","TOTAL                 ",3,3,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","PESO_TOTAL            ",3,2,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","LOTE                  ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","IMPOSTOS              ",3,3,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","PEDIDO                ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","NOTA FISCAL           ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","CLIENTE               ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","LOJA                  ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","RAZÃO SOCIAL          ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","EMISSAO               ",1,4,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","INSUMO                ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","DESC_INSUMO           ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","UM_INSUMO             ",1,1,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","QTD_INSUMO            ",3,2,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","CUSTO UNIT INSUMO     ",3,2,.F.)	
	oFWMsExcel:AddColumn("INSUMO","INSUMO","CUSTO_INSUMO          ",3,3,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","CUSTO INSUMO / PRODUTO ",3,3,.F.)	
	oFWMsExcel:AddColumn("INSUMO","INSUMO","ULTIMA COMPRA INSUMO  ",1,4,.F.)
	oFWMsExcel:AddColumn("INSUMO","INSUMO","VAL ULTIMA COMPRA INSUMO",3,3,.F.)


	//Criando as Linhas... Enquanto não for fim da query   

	ccodant:=""
	cnotafiscal=""
	While !QRYPRO->(eoF()) .AND. QRYPRO->QTD_INS<>0 //.AND. ccodant<>aLLTRIM(QRYPRO->INSUMO)

		//IF alltrim(QRYPRO->VENC)<>''

		IF alltrim(QRYPRO->INSUMO)<>""  .AND. ccodant<>aLLTRIM(QRYPRO->INSUMO)//.AND. QRYPRO->COD_INS_P=""
			oFWMsExcel:AddRow("INSUMO","INSUMO",{ALLTRIM(QRYPRO->D2_FILIAL                     ),;      
			ALLTRIM(QRYPRO->D2_COD                    ),;
			ALLTRIM(QRYPRO->DESCRICAO                 ),;
			ALLTRIM(QRYPRO->D2_UM                     ),;
			(QRYPRO->D2_QUANT                  ),;
			(QRYPRO->D2_PRCVEN                 ),;
			(QRYPRO->D2_TOTAL                  ),;
			(QRYPRO->PESO_TOTAL                ),;  
			ALLTRIM(QRYPRO->D2_LOTECTL                ),;
			(QRYPRO->IMPOSTOS                         ),;
			ALLTRIM(QRYPRO->D2_PEDIDO                 ),;
			ALLTRIM(QRYPRO->NOTA_FISCAL               ),;
			ALLTRIM(QRYPRO->D2_CLIENTE                ),;
			ALLTRIM(QRYPRO->D2_LOJA                   ),;
			ALLTRIM(QRYPRO->A1_NOME                   ),;
			STOD(QRYPRO->D2_EMISSAO                ),;
			ALLTRIM(QRYPRO->INSUMO                    ),;
			ALLTRIM(QRYPRO->DESC_INS1                 ),;
			ALLTRIM(QRYPRO->UM_INSUMO                 ),;
			(QRYPRO->QTD_INS                    ),;
			(QRYPRO->CUSTO_INSUMO/QRYPRO->QTD_INS),;
			(QRYPRO->CUSTO_INSUMO              ),;
			(QRYPRO->CUSTO_INSUMO/QRYPRO->D2_QUANT ),;
			STOD(QRYPRO->U_COMPR_I                ),;
			(QRYPRO->U_PRECO_I                );
			})         

		ENDIF
		//Pulando Registro   
		//Endif


		ccodant:=aLLTRIM(QRYPRO->INSUMO)
		QRYPRO->(DbSkip())
	EndDo                           


	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo+wnrel+".xml")


	//Abrindo o excel e abrindo o arquivo xml

	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo+wnrel+".xml")     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas 

	QRYPRO->(DbCloseArea())
	RestArea(aArea)		


Return cQuery

Static Function CriaPerg(c_Perg)
	PutSx1(c_Perg,"01","Nota Fiscal?"  	 ,"","","mv_ch1","C",09,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	/*
	PutSx1(c_Perg,"02","Cliente até?" 	 ,"","","mv_ch2","C",06,0,0,"G","","SA1","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"03","Fornecedor de?"  ,"","","mv_ch3","C",06,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"04","Fornecedor até?" ,"","","mv_ch4","C",06,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"05","Emissão de?"     ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"06","Emissão até?"    ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"07","Vencimento de?"  ,"","","mv_ch7","D",08,0,0,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"08","Vencimento até?" ,"","","mv_ch8","D",08,0,0,"G","",""   ,"","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"09","Saldo inicial?"  ,"","","mv_ch9","N",TamSX3("E1_VALOR")[1],TamSX3("E1_VALOR")[2],0,"G","",""   ,"","","mv_par09","","","","","","","","","","","","","","","","")
	*/
Return Nil