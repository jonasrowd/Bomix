#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"    


//Constantes
#Define CRLF    Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FFATR010      � Autor � VICTOR SOUSA       � Data �  05/04/20���
�������������������������������������������������������������������������͹��
���Descricao � RELAT�RIO GERA OS INSUMOS CONSUMIDOS NA PRODU��O           ���
���          � DA NOTA FISCAL                                             ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function FFATR010


	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	//	Local aArea        := GetArea()
	//	Local cQuery        := ""
	Local oFWMsExcel
	Local oExcel

	Local cDesc1         := "Este programa tem como objetivo exportar o relat�rio de CONSUMO DE INSUMOS POR NF"
	Local cDesc2         := "para o EXCEL de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "SER� GRAVADO NA PASTA c:\bomix\"
	//	Local cPict          := ""
	Local titulo         := "INSUMO POR NF - EXCEL"
	Local nLin           := 80
	Local Cabec1         := ""
	//	Local Cabec2         := "Cliente/Fornecedor                                           Emiss�o   Num.        Pc       Venc Real  Vencimento            Valor         "
	Local Cabec2         := "Cliente/Fornecedor   Nat/CC                 Emiss�o   Num.        Pc       Venc Real  Vencimento        Receber          Pagar          Saldo      Usuario"	
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
	//Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "FFATR010" // Coloque aqui o nome do arquivo usado para impressao em disco        
	Private c_Perg       := "FFATR010" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString   	 := ""                      
	MPCC := 0.00

	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������

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

	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/09/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	/*
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

	*/
	c_Qry := f_Qry()

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If QRY->(Eof())
		ShowHelpDlg(SM0->M0_NOME, {"Nenhum registro encontrado."},5,{"Verifique os par�metros informados."},5)
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
	local cnfatual :=""
	Local cnfANT :=""
	//	Local aCODIGO 	 := {}
	Local cQryDel :=""






	cQryDel := "Exec P12OFICIAL.dbo.Bomix_TABELAS_Insumos_NF '" +MV_PAR01+ "', '"+MV_PAR02+"', '"+ xFilial("SD2") +"', '"+MV_PAR04+ "', '"+MV_PAR05+"', '"+MV_PAR06+ "', '"+MV_PAR07+"', '"+DTOS(MV_PAR08)+ "', '"+DTOS(MV_PAR09)+"'"
	TCSQLEXEC(cQryDel)

	cQuery := "Exec P12OFICIAL.dbo.Bomix_Insumos_NF '" +MV_PAR01+ "', '"+MV_PAR02+"', '"+ xFilial("SD2") +"'"

	MemoWrit("FFATR010.SQL",cQuery)

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),cAliasTrb, .F., .T.)


	//	DbUseArea(.T., "TOPCONN", TcGenQry(NIL,NIL, cQuery), (cAliasTrb), .F., .T.)

	dbSelectArea(cAliasTrb)
	dbGoTop()



	IF MV_PAR03=1
	cQuery := "Exec P12OFICIAL.dbo.Bomix_Insumos_NF '" +MV_PAR01+ "', '"+MV_PAR02+"', '"+ xFilial("SD2") +"'"

	MemoWrit("FFATR010.SQL",cQuery)

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),cAliasTrb, .F., .T.)

		//Criando o objeto que ir� gerar o conte�do do Excel
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
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PRE�O VENDA           ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","TOTAL                 ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PESO_TOTAL            ",3,2,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","LOTE                  ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","ICMS                  ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","IMPOSTOS              ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PEDIDO                ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","NOTA FISCAL           ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","CLIENTE               ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","LOJA                  ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","RAZ�O SOCIAL          ",1,1,.F.)
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


		//Criando as Linhas... Enquanto n�o for fim da query   

		ccodant:=""
		cnfatual=""
		dbSelectArea("QRYPRO")
		dbGoTop()
		While !QRYPRO->(eoF()) //.AND. QRYPRO->QTD_INS<>0 //.AND. ccodant<>aLLTRIM(QRYPRO->INSUMO)


			//IF alltrim(QRYPRO->VENC)<>''
			IF QRYPRO->QTD_INS<>0

				IF alltrim(QRYPRO->INSUMO)<>""  .AND. ccodant<>aLLTRIM(QRYPRO->INSUMO)  //.AND. QRYPRO->COD_INS_P=""
					oFWMsExcel:AddRow("INSUMO","INSUMO",{ALLTRIM(QRYPRO->D2_FILIAL                     ),;      
					ALLTRIM(QRYPRO->D2_COD                    ),;
					ALLTRIM(QRYPRO->DESCRICAO                 ),;
					ALLTRIM(QRYPRO->D2_UM                     ),;
					(QRYPRO->D2_QUANT                  ),;
					(QRYPRO->D2_PRCVEN                 ),;
					(QRYPRO->D2_TOTAL                  ),;
					(QRYPRO->PESO_TOTAL                ),;  
					ALLTRIM(QRYPRO->D2_LOTECTL                ),;
					(QRYPRO->ICMS                             ),;
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
				Endif
			ENDIF
			//Pulando Registro   
			//Endif


			ccodant:=aLLTRIM(QRYPRO->INSUMO)
			cnfANT:=aLLTRIM(QRYPRO->NOTA_FISCAL)

			QRYPRO->(DbSkip())

			cnfatual:=aLLTRIM(QRYPRO->NOTA_FISCAL)

			IF cnfatual <> cnfANT //aLLTRIM(QRYPRO->NOTA_FISCAL)
				cnfatual:=cnfatual
			Endif

		EndDo                           


		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo+wnrel+".xml")


		//Abrindo o excel e abrindo o arquivo xml

		oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
		oExcel:WorkBooks:Open(cArquivo+wnrel+".xml")     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas 

	ELSE
	cQuery := "Exec P12OFICIAL.dbo.Bomix_Insumos_NF__Sintetico '" +MV_PAR01+ "', '"+MV_PAR02+"', '"+ xFilial("SD2") +"'"

	MemoWrit("FFATR010.SQL",cQuery)

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),cAliasTrb, .F., .T.)

		//Criando o objeto que ir� gerar o conte�do do Excel
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
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PRE�O VENDA           ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","TOTAL                 ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PESO_TOTAL            ",3,2,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","ICMS                  ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","IMPOSTOS              ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PEDIDO                ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","NOTA FISCAL           ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","CLIENTE               ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","LOJA                  ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","RAZ�O SOCIAL          ",1,1,.F.)
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


		//Criando as Linhas... Enquanto n�o for fim da query   

		ccodant:=""
		cnfatual=""
		dbSelectArea("QRYPRO")
		dbGoTop()
		While !QRYPRO->(eoF()) //.AND. QRYPRO->QTD_INS<>0 //.AND. ccodant<>aLLTRIM(QRYPRO->INSUMO)


			//IF alltrim(QRYPRO->VENC)<>''
			IF QRYPRO->QTD_INS<>0

				IF alltrim(QRYPRO->INSUMO)<>""  .AND. ccodant<>aLLTRIM(QRYPRO->INSUMO)  //.AND. QRYPRO->COD_INS_P=""
					oFWMsExcel:AddRow("INSUMO","INSUMO",{ALLTRIM(QRYPRO->D2_FILIAL                     ),;      
					ALLTRIM(QRYPRO->D2_COD                    ),;
					ALLTRIM(QRYPRO->DESCRICAO                 ),;
					ALLTRIM(QRYPRO->D2_UM                     ),;
					(QRYPRO->D2_QUANT                  ),;
					(QRYPRO->D2_PRCVEN                 ),;
					(QRYPRO->D2_TOTAL                  ),;
					(QRYPRO->PESO_TOTAL                ),;  
					(QRYPRO->ICMS                             ),;
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
				Endif
			ENDIF
			//Pulando Registro   
			//Endif


			ccodant:=aLLTRIM(QRYPRO->INSUMO)
			cnfANT:=aLLTRIM(QRYPRO->NOTA_FISCAL)

			QRYPRO->(DbSkip())

			cnfatual:=aLLTRIM(QRYPRO->NOTA_FISCAL)

			IF cnfatual <> cnfANT //aLLTRIM(QRYPRO->NOTA_FISCAL)
				cnfatual:=cnfatual
			Endif

		EndDo                           


		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo+wnrel+".xml")


		//Abrindo o excel e abrindo o arquivo xml

		oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
		oExcel:WorkBooks:Open(cArquivo+wnrel+".xml")     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas 


		/*
		///// RELAT�RIO SINT�TICO

		//Criando o objeto que ir� gerar o conte�do do Excel
		oFWMsExcel := FWMSExcel():New()

		//FLUXO DE CAIXA
		oFWMsExcel:AddworkSheet("INSUMO")
		//Criando a Tabela
		oFWMsExcel:AddTable("INSUMO","INSUMO")     
		oFWMsExcel:AddColumn("INSUMO","INSUMO","CODIGO                ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","DESCRICAO             ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","QUANTIDADE            ",3,2,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PRE�O VENDA           ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","TOTAL                 ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PRE�O S/ IMP          ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PESO_TOTAL            ",3,2,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","ICMS                  ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","PIS / COFINS          ",3,3,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","NOTA FISCAL           ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","RAZ�O SOCIAL          ",1,1,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","EMISSAO               ",1,4,.F.)
		oFWMsExcel:AddColumn("INSUMO","INSUMO","CUSTO                 ",3,3,.F.)


		//Criando as Linhas... Enquanto n�o for fim da query   
		cnfant:=""
		ccodant:=""
		cproduto:=""
		cnfatual=""
		nCusto:=0
		nRegistro=0
		dbSelectArea("QRYPRO")
		dbGoTop()
		While !QRYPRO->(eoF()) 
		cnfANT:=aLLTRIM(QRYPRO->NOTA_FISCAL)
		cproduto=aLLTRIM(QRYPRO->D2_COD)
		IF QRYPRO->QTD_INS<>0

		IF alltrim(QRYPRO->INSUMO)<>""  .AND. ccodant<>aLLTRIM(QRYPRO->INSUMO) //.And. cnfant<>aLLTRIM(QRYPRO->NOTA_FISCAL)  //.AND. QRYPRO->COD_INS_P=""
		nCusto+=(QRYPRO->CUSTO_INSUMO/QRYPRO->D2_QUANT )

		//nRegistro=RECNO()
		//QRYPRO->(DbSkip())
		If cnfant=aLLTRIM(QRYPRO->NOTA_FISCAL) .AND. cproduto<>aLLTRIM(QRYPRO->D2_COD)
		//DBGOTO(nRegistro)
		// dbSkip(-1)
		oFWMsExcel:AddRow("INSUMO","INSUMO",{ALLTRIM(QRYPRO->D2_COD                     ),;      
		ALLTRIM(QRYPRO->DESCRICAO                 ),;
		(QRYPRO->D2_QUANT                  ),;
		(QRYPRO->D2_PRCVEN                 ),;
		(QRYPRO->D2_TOTAL                  ),;
		((QRYPRO->D2_TOTAL - QRYPRO->ICMS - QRYPRO->IMPOSTOS) / QRYPRO->D2_QUANT   ),;
		(QRYPRO->PESO_TOTAL                ),;  
		(QRYPRO->ICMS                             ),;
		(QRYPRO->IMPOSTOS                         ),;
		ALLTRIM(QRYPRO->NOTA_FISCAL               ),;
		ALLTRIM(QRYPRO->A1_NOME                   ),;
		STOD(QRYPRO->D2_EMISSAO                   ),;
		(nCusto                                   );						
		})    
		nCusto:=0     
		//	QRYPRO->(DbSkip())
		Else
		//DBGOTO(nRegistro-1)
		//dbSkip(-1)
		Endif	

		Endif

		ENDIF

		//Pulando Registro   
		//Endif


		ccodant:=aLLTRIM(QRYPRO->INSUMO)
		cnfANT:=aLLTRIM(QRYPRO->NOTA_FISCAL)
		cproduto=aLLTRIM(QRYPRO->D2_COD)

		QRYPRO->(DbSkip())

		//cnfatual:=aLLTRIM(QRYPRO->NOTA_FISCAL)

		//	IF cnfatual <> cnfANT //aLLTRIM(QRYPRO->NOTA_FISCAL)
		//		cnfatual:=cnfatual
		//	Endif

		EndDo                           


		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo+wnrel+".xml")


		//Abrindo o excel e abrindo o arquivo xml

		oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
		oExcel:WorkBooks:Open(cArquivo+wnrel+".xml")     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas 
		*/
	ENDIF

	QRYPRO->(DbCloseArea())
	RestArea(aArea)		


Return cQuery

Static Function CriaPerg(c_Perg)
	PutSx1(c_Perg,"01","Nota Fiscal?"  	 ,"","","mv_ch1","C",09,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	/*
	PutSx1(c_Perg,"02","Cliente at�?" 	 ,"","","mv_ch2","C",06,0,0,"G","","SA1","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"03","Fornecedor de?"  ,"","","mv_ch3","C",06,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"04","Fornecedor at�?" ,"","","mv_ch4","C",06,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"05","Emiss�o de?"     ,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"06","Emiss�o at�?"    ,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"07","Vencimento de?"  ,"","","mv_ch7","D",08,0,0,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"08","Vencimento at�?" ,"","","mv_ch8","D",08,0,0,"G","",""   ,"","","mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"09","Saldo inicial?"  ,"","","mv_ch9","N",TamSX3("E1_VALOR")[1],TamSX3("E1_VALOR")[2],0,"G","",""   ,"","","mv_par09","","","","","","","","","","","","","","","","")
	*/
Return Nil