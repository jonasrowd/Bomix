#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"    


//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
 
//Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FFINR004     º Autor ³ AP6 IDE            º Data ³  04/11/19º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE1.                               º±±
±±º          ³                        ==>>  FLUXO DE CAIXA EXCEL <<==     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
User Function FFINR004

 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Declaracao de Variaveis                                             ³
  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    Local aArea        := GetArea()
    Local cQuery        := ""
    Local oFWMsExcel
    Local oExcel
 
  	Local cDesc1         := "Este programa tem como objetivo exportar o relatório de FLUXO DE CAIXA"
  	Local cDesc2         := "para o EXCEL de acordo com os parametros informados pelo usuario."
  	Local cDesc3         := "SERÁ GRAVADO NA PASTA c:\bomix\"
  	Local cPict          := ""
  	Local titulo         := "Fluxo de Caixa - EXCEL
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
	Private nomeprog     := "FFINR004" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFINR004" // Coloque aqui o nome do arquivo usado para impressao em disco        
	Private c_Perg       := "FFINR002" // Coloque aqui o nome do arquivo usado para impressao em disco
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
    Local oFWMsExcel
    Local oExcel
    Local cArquivo    := "c:\bomix\" //FFINR004.xml GetTempPath()+'FFINR004.xml'








	c_Qry := " SELECT * FROM " + chr(13)
  	c_Qry += " (SELECT SC7.C7_DESCRI, A2_NOME FORNECE, C7_CC AS NATUREZA, CTT_DESC01 AS ED_DESCRIC, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_DESCRI AS DESC_PEDIDO,C7_FSDTPRE EMISSAO, '' VENC, " +chr(13)
	c_Qry += " CASE WHEN C7_QUJE > 0 AND C7_QUJE < C7_QUANT THEN (SUM(C7_QUJE*C7_PRECO)+SUM(C7_VALIPI)) ELSE (SUM(C7_TOTAL)+SUM(C7_VALIPI)) END AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SC7") + " SC7 (NOLOCK)" + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SA2") + " SA2  (NOLOCK) ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND (A2_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL = '" + XFILIAL("SA2") + "'" + chr(13)
	c_Qry += " LEFT JOIN "+RetSqlName("CTT") +" CTT (NOLOCK) ON " + chr(13)
	c_Qry += " C7_CC=CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*' AND CTT.CTT_FILIAL= '" + XFILIAL("CTT") + "'" + chr(13)
    c_Qry += " WHERE C7_QUJE < C7_QUANT AND SC7.C7_RESIDUO <> 'S' AND (C7_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') AND SC7.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + chr(13)
//  	c_Qry += " AND C7_NUM NOT IN (SELECT C7_NUM FROM " + RetSqlName("SC7") + " SC7 " + chr(13)
//  	c_Qry += " JOIN " + RetSqlName("SD1") + " SD1  (NOLOCK) ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM AND D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_<>'*' " + chr(13)
//  	c_Qry += " WHERE SC7.D_E_L_E_T_<>'*' AND SC7.C7_RESIDUO <> 'S' AND C7_FILIAL = '" + xFilial("SC7") + "' GROUP BY C7_NUM) " + chr(13)
  	c_Qry += " GROUP BY C7_NUM, A2_NOME, C7_OBS, C7_FSDTPRE, C7_COND,  C7_CC, CTT_DESC01, SC7.C7_DESCRI " + chr(13)

  	c_Qry += " UNION ALL " + chr(13)

 	c_Qry += " SELECT '' AS C7_DESCRI,CASE WHEN E2_ORIGEM='MATA460' THEN A1_NOME ELSE A2_NOME END, E2_NATUREZ AS NATUREZA, SED.ED_DESCRIC, E2_HIST OBS, E2_NUM NOTA, '' PEDIDO, '' AS DESC_PEDIDO, E2_EMISSAO EMISSAO, E2_VENCREA VENC, E2_SALDO VALOR, '', 'Pagar' TIPO " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SE2") + " SE2 (NOLOCK) " + chr(13)
  	c_Qry += " LEFT JOIN " + RetSqlName("SA2") + " SA2 (NOLOCK) ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL = '" + XFILIAL("SA2") + "'" + chr(13)
  	c_Qry += " LEFT JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON A1_COD = E2_FORNECE AND A1_LOJA = E2_LOJA AND SA1.D_E_L_E_T_<>'*' AND A1_FILIAL = '" + XFILIAL("SA1") + "'" + chr(13)
  	c_Qry += " INNER JOIN "+ RetSqlName("SED")+ " SED (NOLOCK) ON " + chr(13)
  	c_Qry += " SED.ED_CODIGO=SE2.E2_NATUREZ AND SED.D_E_L_E_T_ <>'*' AND SED.ED_FILIAL='" + XFILIAL("SED") + "'" + chr(13)
	c_Qry += " WHERE E2_TIPO <> 'PA' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND E2_FILIAL = '" + xFilial("SE2") + "' " + chr(13)
  	c_Qry += " AND (E2_FORNECE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') " + chr(13)
  	c_Qry += " AND (E2_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') " + chr(13)
  	c_Qry += " AND (E2_VENCREA BETWEEN '" + Dtos(MV_PAR07) + "' AND '" + Dtos(MV_PAR08) + "') " + chr(13)
  	c_Qry += "   	UNION ALL " + chr(13)
 	c_Qry += " SELECT '' AS C7_DESCRI,A1_NOME, E1_NATUREZ AS NATUREZA, SED.ED_DESCRIC, E1_HIST OBS, E1_NUM NOTA, '' PEDIDO, '' AS DESC_PEDIDO, E1_EMISSAO EMISSAO, E1_VENCREA VENC, E1_SALDO VALOR, '', 'Receber' TIPO " + chr(13)
  	c_Qry += " FROM " + RetSqlName("SE1") + " SE1 (NOLOCK) " + chr(13)
  	c_Qry += " JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_<>'*' AND A1_FILIAL = '" + XFILIAL("SA1") + "'" + chr(13)
	c_Qry += " INNER JOIN "+ RetSqlName("SED") +" SED (NOLOCK) ON SED.ED_CODIGO=SE1.E1_NATUREZ AND SED.D_E_L_E_T_ <>'*' AND SED.ED_FILIAL = '" +XFILIAL("SED") + "'" + chr(13)
  	c_Qry += " WHERE E1_SALDO <> 0 AND SE1.D_E_L_E_T_<>'*' " + chr(13)
  	c_Qry += " AND E1_FILIAL = '" + xFilial("SE1") + "' " + chr(13)
  	c_Qry += " AND (E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') " + chr(13)
  	c_Qry += " AND (E1_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') " + chr(13)
  	c_Qry += " AND (E1_VENCREA BETWEEN '" + Dtos(DaySub(MV_PAR07, 1)) + "' AND '" + Dtos(MV_PAR08) + "')) TAB " + chr(13)
  	c_Qry += " ORDER BY EMISSAO"



		MemoWrit("FFINR004.SQL",c_Qry)
		
		
    TCQuery c_Qry New Alias "QRYPRO"		
		
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //FLUXO DE CAIXA
    oFWMsExcel:AddworkSheet("FLUXO")
        //Criando a Tabela
        oFWMsExcel:AddTable("FLUXO","FLUXO")     
        oFWMsExcel:AddColumn("FLUXO","FLUXO","CLIENTE/FORNECEDOR",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","NATUREZA/CC",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","DESCRICAO",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","OBS",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","EMISSAO",1,4,.F.)
		oFWMsExcel:AddColumn("FLUXO","FLUXO","NOTA",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","PEDIDO",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","DESCRICAO_PEDIDO",1,1,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","VENC REAL",1,4,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","VENC",1,4,.F.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","RECEBER",3,3,.T.)
        oFWMsExcel:AddColumn("FLUXO","FLUXO","PAGAR",3,3,.T.)
          

        //Criando as Linhas... Enquanto não for fim da query   
         
          oFWMsExcel:AddRow("FLUXO","FLUXO",{"S A L D O  I N I C I A L ",;
																	"",;           
																	"",;
																	"",;
																	STOD(QRYPRO->EMISSAO),;
									   								"",;
																	"",;
														 			"",;   
														 			"",;
														 			STOD(QRYPRO->VENC),;
																	mv_par09,;  
																0;   
																	})         
        
        While !QRYPRO->(eoF())         
          IF alltrim(QRYPRO->VENC)<>''
          oFWMsExcel:AddRow("FLUXO","FLUXO",{QRYPRO->FORNECE,;      
          															ALLTRIM(QRYPRO->NATUREZA),;
																	ALLTRIM(QRYPRO->ED_DESCRIC),;
																	ALLTRIM(QRYPRO->OBS),;
																	STOD(QRYPRO->EMISSAO),;
									   								(QRYPRO->NOTA),;
																	(QRYPRO->PEDIDO),;
														 			 "",;
														 			Iif(alltrim(QRYPRO->VENC)<>'',Iif(ALLTRIM(QRYPRO->TIPO) = "Receber",(DataValida(DaySum(Stod(QRYPRO->VENC), 1), .T.)),(DataValida(Stod(QRYPRO->VENC), .T.))),''),;          
														 			STOD(QRYPRO->VENC),;
																	Iif(ALLTRIM(QRYPRO->TIPO) = "Receber",(QRYPRO->VALOR),0),;  
																	Iif(ALLTRIM(QRYPRO->TIPO) = "Pagar",(QRYPRO->VALOR),0);   
																	})         



																         
            //Pulando Registro   
         Endif

            QRYPRO->(DbSkip())
        EndDo                           

	dbSelectArea("QRYPRO")
	dbGoTop()

        While !QRYPRO->(eoF())         

       		a_Parcelas2 := Condicao(QRYPRO->VALOR, QRYPRO->CONDICAO, 0, Stod(QRYPRO->EMISSAO))

       		For i:=1 To Len(a_Parcelas)
           		If (a_Parcelas2[i][1] >= MV_PAR07) .And. (a_Parcelas2[i][1] <= MV_PAR08)

          oFWMsExcel:AddRow("FLUXO","FLUXO",{QRYPRO->FORNECE,;
																	ALLTRIM(QRYPRO->NATUREZA),;
																	ALLTRIM(QRYPRO->ED_DESCRIC),;
																	ALLTRIM((QRYPRO->OBS)),;
																	STOD(QRYPRO->EMISSAO),;
									   								(QRYPRO->NOTA),;
																	(QRYPRO->PEDIDO),;
														 			(QRYPRO->C7_DESCRI),;
														 			Stod(Dtos(DataValida(a_Parcelas2[i][1],.T.))),;	
														 			Stod(Dtos(a_Parcelas2[i][1])),;
																	0,;
														   			a_Parcelas2[i][2];   
																	})         


            //Pulando Registro   

           		Endif
         	Next
         	
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
		
		
Return c_Qry

Static Function CriaPerg(c_Perg)
 	PutSx1(c_Perg,"01","Cliente de?"  	 ,"","","mv_ch1","C",06,0,0,"G","","SA1","","","mv_par01","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"02","Cliente até?" 	 ,"","","mv_ch2","C",06,0,0,"G","","SA1","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Fornecedor de?"  ,"","","mv_ch3","C",06,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Fornecedor até?" ,"","","mv_ch4","C",06,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Emissão de?"     ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Emissão até?"    ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"07","Vencimento de?"  ,"","","mv_ch7","D",08,0,0,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"08","Vencimento até?" ,"","","mv_ch8","D",08,0,0,"G","",""   ,"","","mv_par08","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"09","Saldo inicial?"  ,"","","mv_ch9","N",TamSX3("E1_VALOR")[1],TamSX3("E1_VALOR")[2],0,"G","",""   ,"","","mv_par09","","","","","","","","","","","","","","","","")
Return Nil
