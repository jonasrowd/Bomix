#INCLUDE "MATR730.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"       


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FFATR003� Autor � Eduardo Jos� Zanardo  � Data � 26.12.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Emissao da Pr�-Nota                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FFATR003

//������������������������������������������������������������������������Ŀ
//�Define Variaveis                                                        �
//��������������������������������������������������������������������������
Local Titulo  := OemToAnsi(STR0001) //"Emissao da Confirmacao do Pedido"
Local cDesc1  := OemToAnsi(STR0002) //"Emiss�o da confirmac�o dos pedidos de venda, de acordo com"
Local cDesc2  := OemToAnsi(STR0003) //"intervalo informado na op��o Par�metros."
Local cDesc3  := " "
Local cString := "SC5"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .F. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. // Habilita/Desabilita o Filtro
Local wnrel   := "FFATR003" // Nome do Arquivo utilizado no Spool
Local nomeprog:= "FFATR003"
Local cPerg   := "MTR730"

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",0 } //"Zebrado"###"Administracao"
//[1] Reservado para Formulario
//[2] Reservado para N� de Vias
//[3] Destinatario
//[4] Formato => 1-Comprimido 2-Normal
//[5] Midia   => 1-Disco 2-Impressora
//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
//[7] Expressao do Filtro
//[8] Ordem a ser selecionada
//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//������������������������������������������������������������������������Ŀ
//�Verifica as Perguntas Seleciondas                                       �
//��������������������������������������������������������������������������
Pergunte(cPerg,.F.)
//������������������������������������������������������������������������Ŀ
//�Envia para a SetPrinter                                                 �
//��������������������������������������������������������������������������
#IFDEF TOP
	lFiltro := .F.
#ENDIF	

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C730Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)


Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � C730Imp   � Autor � Eduardo J. Zanardo   � Data �26.12.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function C730Imp(lEnd,wnrel,cString,nomeprog,Titulo)

Local aPedCli    := {}
Local aStruSC5   := {}
Local aStruSC6   := {}
Local aC5Rodape  := {}
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})
Local aFisGet    := Nil
Local aFisGetSC5 := Nil

Local li         := 100 // Contador de Linhas
Local lImp       := .F. // Indica se algo foi impresso
Local lRodape    := .F.

Local cbCont     := 0   // Numero de Registros Processados
Local cbText     := ""  // Mensagem do Rodape
Local cKey 	     := ""
Local cFilter    := ""
Local cAliasSC5  := "SC5"
Local cAliasSC6  := "SC6"
Local cIndex     := CriaTrab(nil,.f.)
Local cQuery     := ""
Local cQryAd     := ""
Local cName      := ""
Local cPedido    := ""
Local cCliEnt	 := ""
Local cNfOri     := Nil
Local cSeriOri   := Nil

Local nItem      := 0
Local nTotQtd    := 0
Local nTotVal    := 0
Local nDesconto  := 0
Local nPesLiq    := 0
Local nSC5       := 0
Local nSC6       := 0
Local nX         := 0
Local nRecnoSD1  := Nil
Local nG		 := 0
Local nFrete	 := 0
Local nSeguro	 := 0
Local nFretAut	 := 0
Local nDespesa	 := 0
Local nDescCab	 := 0
Local nPDesCab	 := 0
Local nY         := 0
Local nValMerc   := 0
Local nPrcLista  := 0
Local nAcresFin  := 0

Private aItemPed := {}
Private aCabPed	 := {}

FisGetInit(@aFisGet,@aFisGetSC5)

_cQry	   := ""
_nRecTot   := 0
_TBcFiltro := "("
		
_cQry	+=	"SELECT Z6_CODVEND AS CODVEND, Z6_CUSERID AS IDUSR "
_cQry	+=  "FROM " + RetSqlName("SZ6") + " "
_cQry	+=	"WHERE D_E_L_E_T_ <> '*' AND Z6_CUSERID = '"+ __CUSERID +"' "
		
TCQUERY _cQry NEW ALIAS "QRY"
DBSELECTAREA("QRY")
Count to _nRecTot
QRY->(dbGoTop())
		
If _nRecTot > 0
	While QRY->(!EOF())
	    If !Empty(QRY->CODVEND)
	        _TBcFiltro += "'" + QRY->CODVEND + "',"
		EndIf
			
		QRY->(DBSKIP())
	EndDo
			
	If Len(_TBcFiltro) > 2
		_TBcFiltro := Substr(_TBcFiltro, 1, Len(_TBcFiltro) - 1) + ")"
	Endif

	DBSelectArea("QRY")
	DBCloseArea()    
Else
	DBSELECTAREA("QRY")
	DBCloseArea()    
	_TBcFiltro := ''
EndIf

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		cAliasSC5:= "C730Imp"
		cAliasSC6:= "C730Imp"
		lQuery    := .T.
		aStruSC5  := SC5->(dbStruct())		
		aStruSC6  := SC6->(dbStruct())		
		cQuery := "SELECT SC5.R_E_C_N_O_ SC5REC,SC6.R_E_C_N_O_ SC6REC,"
		cQuery += "SC5.C5_FILIAL,SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPO,"
		cQuery += "SC5.C5_TIPOCLI,SC5.C5_TRANSP,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_DESC1,"
		cQuery += "SC5.C5_DESC2,SC5.C5_DESC3,SC5.C5_DESC4,SC5.C5_MENNOTA,SC5.C5_EMISSAO,"
		cQuery += "SC5.C5_CONDPAG,SC5.C5_FRETE,SC5.C5_DESPESA,SC5.C5_FRETAUT,SC5.C5_TPFRETE,SC5.C5_SEGURO,SC5.C5_TABELA,"
		cQuery += "SC5.C5_VOLUME1,SC5.C5_ESPECI1,SC5.C5_MOEDA,SC5.C5_REAJUST,SC5.C5_BANCO,"
		cQuery += "SC5.C5_ACRSFIN,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_VEND3,SC5.C5_VEND4,SC5.C5_VEND5,"
		cQuery += "SC5.C5_COMIS1,SC5.C5_COMIS2,SC5.C5_COMIS3,SC5.C5_COMIS4,SC5.C5_COMIS5,SC5.C5_PDESCAB,SC5.C5_DESCONT,C5_INCISS,"
		If SC5->(FieldPos("C5_CLIENT"))>0
			cQuery += "SC5.C5_CLIENT,"			
		Endif
		//�������������������������������������������������������������������Ŀ
		//�Esta rotina foi escrita para adicionar no select os campos         �
		//�usados no filtro do usuario quando houver, a rotina acrecenta      �
		//�somente os campos que forem adicionados ao filtro testando         �
		//�se os mesmo j� existem no select ou se forem definidos novamente   �
		//�pelo o usuario no filtro                                           �
		//���������������������������������������������������������������������	
		If !Empty(aReturn[7])
			For nX := 1 To SC5->(FCount())
				cName := SC5->(FieldName(nX))
				If AllTrim( cName ) $ aReturn[7]
					If aStruSC5[nX,2] <> "M"
						If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += cName +","
						Endif 	
					EndIf
				EndIf 			       	
			Next nX
		Endif
		For nY := 1 To Len(aFisGet)
			cQryAd += aFisGet[nY][2]+","
		Next nY
		For nY := 1 To Len(aFisGetSC5)
			cQryAd += aFisGetSC5[nY][2]+","
		Next nY		
		cQuery += cQryAd
		cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_PEDCLI,SC6.C6_PRODUTO,"
		cQuery += "SC6.C6_TES,SC6.C6_CF,SC6.C6_QTDVEN,SC6.C6_PRUNIT,SC6.C6_VALDESC,"
		cQuery += "SC6.C6_VALOR,SC6.C6_ITEM,SC6.C6_DESCRI,SC6.C6_UM,SC6.C6_FSMIX, "
		cQuery += "SC6.C6_PRCVEN,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_CLI,"
		cQuery += "SC6.C6_LOJA,SC6.C6_ENTREG,SC6.C6_DESCONT,SC6.C6_LOCAL,"
		cQuery += "SC6.C6_QTDEMP,SC6.C6_QTDLIB,SC6.C6_QTDENT,SC6.C6_NFORI,SC6.C6_SERIORI,SC6.C6_ITEMORI "
		cQuery += "FROM "
		cQuery += RetSqlName("SC5") + " SC5 ,"
		cQuery += RetSqlName("SC6") + " SC6 "		
		cQuery += "WHERE "
		cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "		
		cQuery += "SC5.C5_NUM >= '"+mv_par01+"' AND "
		cQuery += "SC5.C5_NUM <= '"+mv_par02+"' AND "
		cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "		
		cQuery += "SC6.C6_NUM   = SC5.C5_NUM AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		If !Empty(_TBcFiltro)
			cQuery += "AND SC5.C5_VEND1 IN " + _TBcFiltro
		Endif
		cQuery += " ORDER BY SC5.C5_NUM"

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC5,.T.,.T.)

		For nSC5 := 1 To Len(aStruSC5)
			If aStruSC5[nSC5][2] <> "C" .and.  FieldPos(aStruSC5[nSC5][1]) > 0
				TcSetField(cAliasSC5,aStruSC5[nSC5][1],aStruSC5[nSC5][2],aStruSC5[nSC5][3],aStruSC5[nSC5][4])
			EndIf
		Next nSC5
		For nSC6 := 1 To Len(aStruSC6)
			If aStruSC6[nSC6][2] <> "C" .and. FieldPos(aStruSC6[nSC6][1]) > 0
				TcSetField(cAliasSC6,aStruSC6[nSC6][1],aStruSC6[nSC6][2],aStruSC6[nSC6][3],aStruSC6[nSC6][4])
			EndIf
		Next nSC6		    	
	Else
#ENDIF	
	cAliasSC5 := cString
	dbSelectArea(cAliasSC5)
	cKey := IndexKey()	
	cFilter := dbFilter()
	cFilter += If( Empty( cFilter ),""," .And. " )
	cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. (C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'")'
	IndRegua(cAliasSC5,cIndex,cKey,,cFilter,STR0006)		//"Selecionando Registros..."
	#IFNDEF TOP
		DbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	SetRegua(RecCount())		// Total de Elementos da regua
	DbGoTop()
	#IFDEF TOP
	Endif
	#ENDIF	

While !((cAliasSC5)->(Eof())) .and. xFilial("SC5")==(cAliasSC5)->C5_FILIAL

	//��������������������������������������������������������������Ŀ
	//� Executa a validacao dos filtros do usuario           	     �
	//����������������������������������������������������������������
	dbSelectArea(cAliasSC5)
	lFiltro := IIf((!Empty(aReturn[7]).And.!&(aReturn[7])),.F.,.T.)

	If lFiltro

		cCliEnt   := IIf(!Empty((cAliasSC5)->(FieldGet(FieldPos("C5_CLIENT")))),(cAliasSC5)->C5_CLIENT,(cAliasSC5)->C5_CLIENTE)

		aCabPed := {}

		MaFisIni(cCliEnt,;							// 1-Codigo Cliente/Fornecedor
			(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
			If((cAliasSC5)->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			(cAliasSC5)->C5_TIPO,;				// 4-Tipo da NF
			(cAliasSC5)->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
			aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
			,;						   			// 7-Tipo de complemento
			,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")							// 10-Nome da rotina que esta utilizando a funcao
		//Na argentina o calculo de impostos depende da serie.
		If cPaisLoc == 'ARG'
			SA1->(DbSetOrder(1))
			SA1->(MsSeek(xFilial()+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI))
			MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
		Endif

		nFrete		:= (cAliasSC5)->C5_FRETE
		nSeguro		:= (cAliasSC5)->C5_SEGURO
		nFretAut	:= (cAliasSC5)->C5_FRETAUT
		nDespesa	:= (cAliasSC5)->C5_DESPESA
		nDescCab	:= (cAliasSC5)->C5_DESCONT
		nPDesCab	:= (cAliasSC5)->C5_PDESCAB

		aItemPed:= {}
		aCabPed := {	(cAliasSC5)->C5_TIPO,;
			(cAliasSC5)->C5_CLIENTE,;
			(cAliasSC5)->C5_LOJACLI,;
			(cAliasSC5)->C5_TRANSP,;
			(cAliasSC5)->C5_CONDPAG,;
			(cAliasSC5)->C5_EMISSAO,;
			(cAliasSC5)->C5_NUM,;
			(cAliasSC5)->C5_VEND1,;
			(cAliasSC5)->C5_VEND2,;
			(cAliasSC5)->C5_VEND3,;
			(cAliasSC5)->C5_VEND4,;
			(cAliasSC5)->C5_VEND5,;
			(cAliasSC5)->C5_COMIS1,;
			(cAliasSC5)->C5_COMIS2,;
			(cAliasSC5)->C5_COMIS3,;
			(cAliasSC5)->C5_COMIS4,;
			(cAliasSC5)->C5_COMIS5,;
			(cAliasSC5)->C5_FRETE,;
			(cAliasSC5)->C5_TPFRETE,;
			(cAliasSC5)->C5_SEGURO,;
			(cAliasSC5)->C5_TABELA,;
			(cAliasSC5)->C5_VOLUME1,;
			(cAliasSC5)->C5_ESPECI1,;
			(cAliasSC5)->C5_MOEDA,;
			(cAliasSC5)->C5_REAJUST,;
			(cAliasSC5)->C5_BANCO,;
			(cAliasSC5)->C5_ACRSFIN;
			}
		nTotQtd:=0
		nTotVal:=0
		nPesBru:=0
		nPesLiq:=0
		aPedCli:= {}
		If !lQuery
			dbSelectArea(cAliasSC6)
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+(cAliasSC5)->C5_NUM)
		EndIf
		cPedido    := (cAliasSC5)->C5_NUM
		aC5Rodape  := {}
		aadd(aC5Rodape,{(cAliasSC5)->C5_PBRUTO,(cAliasSC5)->C5_PESOL,(cAliasSC5)->C5_DESC1,(cAliasSC5)->C5_DESC2,;
			(cAliasSC5)->C5_DESC3,(cAliasSC5)->C5_DESC4,(cAliasSC5)->C5_MENNOTA, (cAliasSC5)->C5_NUM})

		aPedCli := Mtr730Cli(cPedido)


		dbSelectArea(cAliasSC5)
		For nY := 1 to Len(aFisGetSC5)
			If !Empty(&(aFisGetSC5[ny][2]))
				If aFisGetSC5[ny][1] == "NF_SUFRAMA"
					MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)		
				Else
					MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
				Endif	
			EndIf
		Next nY


		While !((cAliasSC6)->(Eof())) .And. xFilial("SC6")==(cAliasSC6)->C6_FILIAL .And.;
				(cAliasSC6)->C6_NUM == cPedido

			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0

			If !Empty((cAliasSC6)->C6_NFORI)
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+;
					(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI)
				cNfOri     := (cAliasSC6)->C6_NFORI
				cSeriOri   := (cAliasSC6)->C6_SERIORI
				nRecnoSD1  := SD1->(RECNO())
			EndIf

			dbSelectArea(cAliasSC6)

			If lEnd
				@ Prow()+1,001 PSAY STR0007 //"CANCELADO PELO OPERADOR"
				Exit
			EndIf

			//���������������������������������������������Ŀ
			//�Calcula o preco de lista                     �
			//�����������������������������������������������
			nValMerc  := (cAliasSC6)->C6_VALOR
			nPrcLista := (cAliasSC6)->C6_PRUNIT
			If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/(cAliasSC6)->C6_QTDVEN,TamSX3("C6_PRCVEN")[2])
			EndIf
			nAcresFin := A410Arred((cAliasSC6)->C6_PRCVEN*(cAliasSC5)->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred((cAliasSC6)->C6_QTDVEN*nAcresFin,"D2_TOTAL")		
			nDesconto := a410Arred(nPrcLista*(cAliasSC6)->C6_QTDVEN,"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,(cAliasSC6)->C6_VALDESC,nDesconto)
			nDesconto := Max(0,nDesconto)
			nPrcLista += nAcresFin
			If cPaisLoc=="BRA"
				nValMerc  += nDesconto
			EndIf			
						
			MaFisAdd((cAliasSC6)->C6_PRODUTO,; 	  // 1-Codigo do Produto ( Obrigatorio )
				(cAliasSC6)->C6_TES,;			  // 2-Codigo do TES ( Opcional )
				(cAliasSC6)->C6_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  // 4-Preco Unitario ( Obrigatorio )
				nDesconto,;       // 5-Valor do Desconto ( Opcional )
				cNfOri,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
				cSeriOri,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
				nRecnoSD1,;			          // 8-RecNo da NF Original no arq SD1/SD2
				0,;							  // 9-Valor do Frete do Item ( Opcional )
				0,;							  // 10-Valor da Despesa do item ( Opcional )
				0,;            				  // 11-Valor do Seguro do item ( Opcional )
				0,;							  // 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;// 13-Valor da Mercadoria ( Obrigatorio )
				0,;							  // 14-Valor da Embalagem ( Opiconal )
				0,;		     				  // 15-RecNo do SB1
				0) 							  // 16-RecNo do SF4

			aadd(aItemPed,	{	(cAliasSC6)->C6_ITEM,;
				(cAliasSC6)->C6_PRODUTO,;
				(cAliasSC6)->C6_DESCRI,;
				(cAliasSC6)->C6_TES,;
				(cAliasSC6)->C6_CF,;
				(cAliasSC6)->C6_UM,;
				(cAliasSC6)->C6_QTDVEN,;
				(cAliasSC6)->C6_PRCVEN,;
				(cAliasSC6)->C6_NOTA,;
				(cAliasSC6)->C6_SERIE,;
				(cAliasSC6)->C6_CLI,;
				(cAliasSC6)->C6_LOJA,;
				(cAliasSC6)->C6_VALOR,;
				(cAliasSC6)->C6_ENTREG,;	//(cAliasSC6)->C6_FSDTSUG,;
				(cAliasSC6)->C6_DESCONT,;
				(cAliasSC6)->C6_LOCAL,;
				(cAliasSC6)->C6_QTDEMP,;
				(cAliasSC6)->C6_QTDLIB,;
				(cAliasSC6)->C6_QTDENT,;
				                      ,;
				(cAliasSC6)->C6_PEDCLI,;	//aItemPed[21] - N� PEDIDO DO CLIENTE
				(cAliasSC6)->C6_FSMIX})		//aItemPed[22] - MIX
			//�����������������������������������������������������������������������Ŀ
			//�Forca os valores de impostos que foram informados no SC6.              �
			//�������������������������������������������������������������������������
			dbSelectArea(cAliasSC6)
			For nY := 1 to Len(aFisGet)
				If !Empty(&(aFisGet[ny][2]))
					MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
				EndIf
			Next nY

			//���������������������������������������������Ŀ
			//�Calculo do ISS                               �
			//�����������������������������������������������
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+(cAliasSC6)->C6_TES))
			If ( (cAliasSC5)->C5_INCISS == "N" .And. (cAliasSC5)->C5_TIPO == "N")
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
				EndIf
			EndIf	
			//���������������������������������������������Ŀ
			//�Altera peso para calcular frete              �
			//�����������������������������������������������
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO))			
			MaFisAlt("IT_PESO",(cAliasSC6)->C6_QTDVEN*SB1->B1_PESO,Len(aItemPed))
			MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
			MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
			
			If !lQuery
				dbSelectArea(cAliasSC6)
			EndIf

			(cAliasSC6)->(dbSkip())
		EndDo
		
		MaFisAlt("NF_FRETE"   ,nFrete)
		MaFisAlt("NF_SEGURO"  ,nSeguro)
		MaFisAlt("NF_AUTONOMO",nFretAut)
		MaFisAlt("NF_DESPESA" ,nDespesa)

		If nDescCab > 0
			MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nDescCab+MaFisRet(,"NF_DESCONTO")))
		EndIf
		If nPDesCab > 0
			MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*nPDesCab/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
		EndIf

		nItem := 0
		For nG := 1 To Len(aItemPed)
			nItem += 1
			IF li > 45
				IF lRodape
					ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,,cAliasSC6)
				Endif
				li := 0
				lRodape := ImpCabec(@li,aPedCli,cAliasSC5)
			Endif
			ImpItem(nItem,@nPesLiq,@li,@nTotQtd,@nTotVal,@nPesBru,cAliasSC6,cAliasSC5)
			li++
		Next

		IF lRodape
			ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape,cAliasSC5,.T.,cAliasSC6)
			lRodape:=.F.
		Endif

		MaFisEnd()

		If !lQuery
			IncRegua()
			dbSelectArea(cAliasSC5)
			dbSkip()
		Endif

	Else
		dbSelectArea(cAliasSC5)
		dbSkip()
	EndIf

EndDo

If lQuery
	dbSelectArea(cAliasSC5)
	dbCloseArea()
Endif	

Set Device To Screen
Set Printer To

RetIndex("SC5")
dbSelectArea("SC5")
dbClearFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
dbClearFilter()
dbSetOrder(1)
dbGotop()

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpItem  � Autor � Claudinei M. Benzi    � Data � 05.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao da Pr�-Nota                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpItem(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Matr730                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpItem(nItem,nPesLiq,li,nTotQtd,nTotVal,nPesBru,cAliasSC6,cAliasSC5)
/*
01 c6_item
02 c6_produto
03 c6_descri
04 c6_tes
05 c6_cf
06 c6_um
07 c6_qtdven
08 c6_prcven
09 c6_nota
10 c6_serie
11 c6_cli
12 c6_loja
13 c6_valor
14 c6_entreg
15 c6_descont
16 c6_local
17 c6_qtdemp
18 c6_qtdlib
19 c6_qtdent
*/
Local nUltLib  := 0
Local cChaveD2 := ""
Local nDecs	:=	MsDecimais(Max(1,aCabPed[24]))  //C5_MOEDA
Local nValImp	:=0
dbSelectArea("SB1")
dbSeek(xFilial("SB1")+aItemPed[nItem][2])  //C6_PRODUTO

@li,000 psay aItemPed[nItem][01]	//C6_ITEM
@li,003 psay AllTrim(aItemPed[nItem][02])	//C6_PRODUTO
@li,014 psay cValToChar(aItemPed[nItem][22])	//C6_FSMIX
@li,019 psay SUBS(IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03]),1,30)		//C6_DESCRI
@li,050 psay aItemPed[nItem][04]	//C6_TES
@li,054 psay aItemPed[nItem][05]	//C6_CF
@li,059 psay aItemPed[nItem][06]	//C6_UM
@li,061 psay aItemPed[nItem][07] Picture PesqPictQt("C6_QTDVEN")	//C6_QTDVEN
@li,076 psay aItemPed[nItem][08] Picture PesqPict("SC6","C6_PRCVEN",12)	//C6_PRCVEN
If cPaisLoc == "BRA"
	If aCabPed[1] == "P"
		nValImp := 0
	Else
		nValImp	:=	MaFisRet(nItem,"IT_VALIPI")
	Endif
	@li,089 psay MaFisRet(nItem,"IT_ALIQIPI") Picture "@e 99.99"
Else
	nValImp	:=	MaRetIncIV(nItem,"2")
	@li,089 psay  nValImp	Picture Tm(nValImp,10,nDecs)
Endif
         

If ( cPaisLoc=="BRA" )
	@li,095 psay MaFisRet(nItem,"IT_ALIQICM") Picture "@e 99.99" //Aliq de ICMS
	@li,101 psay MaFisRet(nItem,"IT_ALIQISS") Picture "@e 99.99" //Aliq de ISS	
EndIf
//c6_nota c6_serie c6_cli c6_loja c6_produto
cChaveD2 := xFilial("SD2")+aItemPed[nItem][09]+aItemPed[nItem][10]+aItemPed[nItem][11]+aItemPed[nItem][12]+aItemPed[nItem][02]
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(cChaveD2)
While !Eof() .and. cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
	nUltLib := D2_QUANT
	dbSkip()
EndDo

@li,106   psay aItemPed[nItem][13]+nValImp Picture PesqPict("SC6","C6_VALOR",16,nDecs)		//C6_VALOR
@li,123   psay aItemPed[nItem][14]		//C6_ENTREG
@li,133   psay aItemPed[nItem][15]    Picture "99.9"  //C6_DESCONT
@li,139   psay aItemPed[nItem][16]		//C6_LOCAL
@li,141   psay aItemPed[nItem][17] Picture PesqPictQt("C6_QTDLIB")		//C6_QTDEMP
//C6_QTDVEN C6_QTDEMP C6_QTDLIB C6_QTDENT
@li,155   psay aItemPed[nItem][07] - aItemPed[nItem][17] + aItemPed[nItem][18] - aItemPed[nItem][19] Picture PesqPictQt("C6_QTDLIB")
@li,169   psay nUltLib Picture PesqPictQt("D2_QUANT")

nTotQtd += aItemPed[nItem][07]						//C6_QTDVEN
nTotVal += aItemPed[nItem][13]+nValImp				//C6_VALOR
nPesLiq	+= SB1->B1_PESO * aItemPed[nItem][07]		//C6_QTDVEN
nPesBru += SB1->B1_PESBRU * aItemPed[nItem][07]	//C6_QTDVEN

//Incluido por Christian
c_DescProd := AllTrim(IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03]))
If Len(c_DescProd) > 30
	li++
	@li,019 psay SUBS(IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03]),31,30)		//C6_DESCRI
Endif

If Len(c_DescProd) > 60
	li++
	@li,019 psay SUBS(IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03]),61,30)		//C6_DESCRI
Endif

If Len(c_DescProd) > 90
	li++
	@li,019 psay SUBS(IIF(Empty(aItemPed[nItem][03]),SB1->B1_DESC, aItemPed[nItem][03]),91,30)		//C6_DESCRI
Endif

Return (Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpRodape� Autor � Claudinei M. Benzi    � Data � 05.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao da Pr�-Nota                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpRoadpe(void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Matr730                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpRodape(nPesLiq,nTotQtd,nTotVal,li,nPesBru,aC5Rodape,cAliasSC5,lFinal,cAliasSC6)
Local aCodImps	:=	{}
Local I     := 0

DEFAULT lFinal := .F.

@ li,000 psay Replicate("-",limite-37)
li++
@ li,000 psay STR0029	//" T O T A I S "
@ li,061 psay nTotQtd    Picture PesqPict("SC6","C6_QTDVEN",20)
@ li,105 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
If lFinal
	li++
	@ li,000 psay Replicate("-",limite-37)
	If cPaisLoc == 'BRA'
		li++
		@ li,000 psay STR0038
		@ li,026 PSay STR0039
		@ li,046 PSay STR0040
		@ li,067 PSay STR0041
		@ li,087 PSay STR0042
		@ li,107 PSay STR0043
		@ li,128 PSay STR0044
		@ li,149 PSay STR0045	
		li++
		@ li,022 PSay Transform(MaFisRet(,"NF_BASEICM"),PesqPict("SF2","F2_BASEICM"))
		@ li,042 PSay Transform(MaFisRet(,"NF_VALICM") ,PesqPict("SF2","F2_VALICM") )
		@ li,062 PSay Transform(MaFisRet(,"NF_BASEIPI"),PesqPict("SF2","F2_BASEIPI"))
		@ li,083 PSay Transform(MaFisRet(,"NF_VALIPI") ,PesqPict("SF2","F2_VALIPI") )
		@ li,105 PSay Transform(MaFisRet(,"NF_BASESOL"),PesqPict("SF2","F2_ICMSRET"))
		@ li,127 PSay Transform(MaFisRet(,"NF_VALSOL") ,PesqPict("SF2","F2_VALBRUT"))
		@ li,147 PSay Transform(MaFisRet(,"NF_TOTAL")  ,PesqPict("SF2","F2_VALBRUT"))
		li++                                                                            	
		@ li,026 psay STR0046
		@ li,046 PSay STR0047
		li++                                                                            		
		@ li,022 PSay Transform(MaFisRet(,"NF_BASEISS"),PesqPict("SF2","F2_BASEISS"))
		@ li,042 PSay Transform(MaFisRet(,"NF_VALISS") ,PesqPict("SF2","F2_VALISS") )
	Else

		aCodImps := MaFisRet(,"NF_IMPOSTOS") //Descricao / /Aliquota / Valor / Base
		li++
		@ li,000 psay STR0038
		@ li,025 PSay STR0049 //"Imposto                                 Base      Aliquota         Valor"
		li++         			
		@ li,025 PSay           "------------------------------ ------------- ------------- -------------"
		li++
		For I:=1 To Len(aCodImps)// Vetor com os impostos
			@ li,25 PSay aCodImps[I][2]
			@ li,57 PSay aCodImps[I][3] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			@ li,71 PSay aCodImps[I][4] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			@ li,85 PSay aCodImps[I][5] Picture TM(aCodImps[I][4],12,MsDecimais(1))
			li++
		Next

	Endif
Endif	

@ 51,005 psay STR0030+STR(If(aC5Rodape[1][1] > 0,aC5Rodape[1][1],nPesBru))	//"PESO BRUTO ------>"
@ 52,005 psay STR0031+STR(If(aC5Rodape[1][2] > 0,aC5Rodape[1][2] ,nPesLiq))	//"PESO LIQUIDO ---->"
@ 53,005 psay STR0032	//"VOLUMES --------->"
@ 54,005 psay STR0033	//"SEPARADO POR ---->"
@ 55,005 psay STR0034	//"CONFERIDO POR --->"
@ 56,005 psay STR0035	//"D A T A --------->"

@ 58,000 psay STR0036	//"DESCONTOS: "
@ 58,011 psay aC5Rodape[1][3] Picture "99.99"
@ 58,019 psay aC5Rodape[1][4] picture "99.99"
@ 58,027 psay aC5Rodape[1][5] picture "99.99"
@ 58,035 psay aC5Rodape[1][6] picture "99.99"

@ 60,000 psay STR0037+AllTrim(aC5Rodape[1][7])			//"MENSAGEM PARA NOTA FISCAL: "
@ 61,000 psay ""

c_Observ := ALLTRIM(UPPER(Posicione("SC5", 1, xFilial("SC5") + aC5Rodape[1][8], "C5_FSOBS")))

@ 62,000 psay "OBSERVA��O: " + MemoLine(c_Observ, limite-45, 1)	//"OBSERVA��O: "

li := 63
For j:=2 To MLCount(c_Observ, limite-45)
	If Empty(MemoLine(c_Observ, limite-45, j))
		Loop
	Endif

	@ li++,012 psay MemoLine(c_Observ, limite-45, j)
Next

li := 80

Return( NIL )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpCabec � Autor � Claudinei M. Benzi    � Data � 05.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao da Pr�-Nota                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpCabec(void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Matr730                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpCabec(li,aPedCli,cAliasSC5)

Local cHeader	:= ""
Local nPed		:= 0
Local i         := 0
Local cMoeda	:= ""
Local cPedCli   := ""
Local cPictCgc  := ""
If cPaisLoc == "BRA"
//	cHeader := STR0008	// It Codigo          Desc. do Material              TES CF   UM        Quant.  Valor Unit. IPI   ICMS   ISS     Vl.Tot.C/IPI Entrega   Desc Loc.    Qtd.a Fat         Saldo      Ult.Fat.
	cHeader := "It Codigo     Mix  Desc. do Material              TES CF   UM        Quant.  Valor Unit. IPI   ICMS   ISS     Vl.Tot.C/IPI Entrega   Desc Loc.    Qtd.a Fat         Saldo      Ult.Fat."
	//          		   0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
Else
//	cHeader := STR0048	//"It Codigo          Desc de Material               TES CF   UM        Quant.  Valor Unit.        Imp.Inc.       Valor Total Entrega   Desc Loc.      Ctd.Ent         Saldo     Ult.Entr."
	cHeader := "It Codigo     Mix  Desc de Material               TES CF   UM        Quant.  Valor Unit.        Imp.Inc.       Valor Total Entrega   Desc Loc.      Ctd.Ent         Saldo     Ult.Entr."
	//        			   0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
Endif

/* array acabped
01 C5_TIPO
02 C5_CLIENTE
03 C5_LOJACLI
04 C5_TRANSP
05 C5_CONDPAG
06 C5_EMISSAO
07 C5_NUM
08 C5_VEND1
09 C5_VEND2
10 C5_VEND3
11 C5_VEND4
12 C5_VEND5
13 C5_COMIS1
14 C5_COMIS2
15 C5_COMIS3
16 C5_COMIS4
17 C5_COMIS5
18 C5_FRETE
19 C5_TPFRETE
20 C5_SEGURO
21 C5_TABELA
22 C5_VOLUME1
23 C5_ESPECI1
24 C5_MOEDA
25 C5_REAJUST
26 C5_BANCO
27 C5_ACRSFIN
*/

//�������������������������������������������������������������Ŀ
//� Posiciona registro no cliente do pedido                     �
//���������������������������������������������������������������

IF !(aCabPed[1]$"DB")   //C5_TIPO
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+aCabped[2]+aCabped[3])  //C5_CLIENTE + C5_LOJACLI
	cPictCgc := PesqPict("SA1","A1_CGC")	
Else
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+aCabPed[2]+aCabPed[3])  //C5_CLIENTE + C5_LOJACLI
	cPictCgc := PesqPict("SA2","A2_CGC")	
Endif

dbSelectArea("SA4")
dbSetOrder(1)
dbSeek(xFilial("SA4")+aCabPed[4])		//C5_TRANSP
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+aCabPed[5])		//C5_CONDPAG

aSort(aPedCli)
@ 00,000 psay AvalImp(limite)
@ 01,000 psay Replicate("-",limite-37)
@ 02,000 psay SM0->M0_NOME
IF !(aCabPed[1]$"DB")		//C5_TIPO
	@ 02,041 psay "| "+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)
	@ 02,100 psay STR0009		//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay AllTrim(Upper(SM0->M0_ENDCOB))
	@ 03,041 psay "| " + SA1->A1_END
	@ 03,100 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "
	@ 04,043 psay SA1->A1_CEP
	@ 04,053 psay ALLTRIM(SA1->A1_MUN)
	@ 04,077 psay SA1->A1_EST
	@ 04,100 psay STR0011		//"| EMISSAO: "
	@ 04,111 psay aCabPed[6]	//C5_EMISSAO
	@ 05,000 psay Iif(cPaisLoc=="BRA",STR0012,Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
	@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,041 psay "|"
	@ 05,043 psay subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
	If cPaisLoc == "BRA"	
		@ 05,062 psay STR0013+SA1->A1_INSCR			//"IE: "
	Endif
	@ 05,100 psay STR0014+aCabPed[7]			//"| PEDIDO N. "			//C5_NUM
	@ 05,125 psay IIF(!Empty(aItemPed[1][21]), "N� PEDIDO CLIENTE: " + aItemPed[1][21], "")		//"| N� PEDIDO CLIENTE "	//C5_PEDCLI
	@ 06,000 psay "CIDADE: " + AllTrim(Upper(SM0->M0_CIDCOB))
	@ 06,041 psay "|                     LOCAL DE ENTREGA"
	@ 06,100 psay "|"
	@ 07,041 psay "| ENDERE�O: " + AllTrim(IIF(!Empty(SA1->A1_ENDREC), SA1->A1_ENDREC, SA1->A1_END))
	@ 07,100 psay "|"
	@ 08,041 psay "| BAIRRO: " + AllTrim(Upper(IIF(!Empty(SA1->A1_FSBAIRR), SA1->A1_FSBAIRR, SA1->A1_BAIRRO)))
	@ 08,077 psay "CEP: " + IIF(!Empty(SA1->A1_FSCEP), SA1->A1_FSCEP, SA1->A1_CEP)
	@ 08,100 psay "|"
	@ 09,041 psay "| CIDADE: " + AllTrim(IIF(!Empty(SA1->A1_FSMUN), SA1->A1_FSMUN, SA1->A1_MUN))
	@ 09,077 psay "ESTADO: " + IIF(!Empty(SA1->A1_FSEST), SA1->A1_FSEST,SA1->A1_EST)
	@ 09,100 psay "|"
Else
	@ 02,041 psay "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
	@ 02,100 psay STR0009	//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+ SA2->A2_END
	@ 03,100 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "+SA2->A2_CEP
	@ 04,053 psay SA2->A2_MUN
	@ 04,077 psay SA2->A2_EST
	@ 04,100 psay STR0011		//"| EMISSAO: "
	@ 04,111 psay aCabPed[6]	//C5_EMISSAO
	@ 05,000 psay Iif(cPaisLoc=="BRA",STR0012,Alltrim(Posicione('SX3',2,'A1_CGC','SX3->X3_TITULO'))+":")		//"CGC: "
	@ 05,006 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA2->A2_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	If cPaisLoc == "BRA"	
		@ 05,062 psay STR0013+SA2->A2_INSCR			//"IE: "
	Endif	
	@ 05,100 psay STR0014+aCabPed[7]			//"| PEDIDO N. "	//C5_NUM
	@ 05,125 psay IIF(!Empty(aItemPed[1][21]), "N� PEDIDO CLIENTE: " + aItemPed[1][21], "")		//"| N� PEDIDO CLIENTE "	//C5_PEDCLI
Endif
li:= 10
If Len(aPedCli) > 0
	@ li,000 psay Replicate("-",limite-37)
	li++
	@ li,000 psay "PEDIDO(S) DO CLIENTE:"
	cPedCli:=""
	For nPed := 1 To Len(aPedCli)
		cPedCli += aPedCli[nPed]+Space(02)
		If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
			@ li,23 psay cPedCli
			cPedCli:=""
			li++
		Endif
	Next
Endif
@ li,000 psay Replicate("-",limite-37)
li++
@ li,000 psay STR0016+aCabPed[4]+" - "+SA4->A4_NOME			//"TRANSP...: "		//C5_TRANSP
li++

For i := 8 to 12
	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3")+aCabPed[i])	//C5_VENDi
		If i == 8
			@ li,000 psay STR0017		//"VENDEDOR.: "
		EndIf
		@ li,013 psay aCabPed[i] + " - "+SA3->A3_NOME	//C5_VENDi
		If i == 8
			@ li,065 psay STR0018		//"COMISSAO: "
		EndIf
		@ li,075 psay aCabPed[i+5] Picture "99.99"		//C5_COMISi+5
		@ li,100 psay "GERENCIA: " + SA3->A3_GEREN + " - " + Posicione("SA3", 1, xFilial("SA3") + SA3->A3_GEREN, "A3_NOME") 	//"GERENCIA: "
		li++
	EndIf	
Next

@ li,000 psay STR0019+aCabPed[5]+" - "+SE4->E4_DESCRI			//"COND.PGTO: "		//C5_CONDPAG
@ li,065 psay STR0020		//"FRETE...: "
@ li,075 psay aCabPed[18] Picture "@EZ 999,999,999.99"		//C5_FRETE
@ li,090 psay TipoFrete(aCabPed[19])		//C5_TPFRETE
@ li,100 psay STR0021		//"SEGURO: "
@ li,108 psay aCabPed[20] Picture "@EZ 999,999,999.99"		//C5_SEGURO
li++
@ li,000 psay STR0022+aCabPed[21]		//"TABELA...: "		//C5_TABELA
@ li,065 psay STR0023		//"VOLUMES.: "
@ li,075 psay aCabPed[22]    Picture "@EZ 999,999"		//C5_VOLUME1s
@ li,100 psay STR0024+aCabPed[23]		//"ESPECIE: "	//C5_ESPECIE1
li++
cMoeda:=Strzero(aCabPed[24],1,0)		//C5_MOEDA
@ li,000 psay STR0025+aCabPed[25]+STR0026 +IIF(cMoeda < "2","1",cMoeda)		//"REAJUSTE.: "###"   Moeda : " 	//C5_REAJUST
@ li,065 psay STR0027 + aCabPed[26]					//"BANCO: "		//C5_BANCO
@ li,100 psay STR0028+Str(aCabPed[27],6,2)		//"ACRES.FIN.: "	//C5_ACRSFIN
li++
@ li,000 psay Replicate("-",limite-37)
li++
@ li,000 psay cHeader
li++
@ li,000 psay Replicate("-",limite-37)
li++

Return( .T. )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Mtr730Cli � Autor � Henry Fila            � Data � 26.08.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o que retorna os pedidos do cliente                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Mtr730Cli(cPedido)                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1: Numero do pedido                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Matr730                                                    ���
�������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Mtr730Cli(cPedido)

Local aPedidos := {}
Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())

SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+cPedido))

While !(SC6->(Eof())) .And. xFilial("SC6")==SC6->C6_FILIAL .And.;
		SC6->C6_NUM == cPedido

	If !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedidos,SC6->C6_PEDCLI) = 0
		Aadd(aPedidos, SC6->C6_PEDCLI )
	Endif		

	SC6->(dbSkip())
Enddo

RestArea(aAreaSC6)
RestArea(aArea)

Return(aPedidos)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FisGetInit� Autor �Eduardo Riera          � Data �17.11.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inicializa as variaveis utilizadas no Programa              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FisGetInit(aFisGet,aFisGetSC5)

Local cValid      := ""
Local cReferencia := ""
Local nPosIni     := 0
Local nLen        := 0

If aFisGet == Nil
	aFisGet	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6")
	While !Eof().And.X3_ARQUIVO=="SC6"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGet,,,{|x,y| x[3]<y[3]})
EndIf

If aFisGetSC5 == Nil
	aFisGetSC5	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC5")
	While !Eof().And.X3_ARQUIVO=="SC5"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
EndIf
MaFisEnd()
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �TipoFrete � Autor �Vendas e CRM           � Data �23/02/2012���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Texto do tipo de frete                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Texto do tipo de frete                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Sigla do frete                                              ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function TipoFrete(cTipofrete)
Local cReturn := ''

Do Case
	Case cTipofrete = 'C'
		cReturn := '(CIF)'
	Case cTipofrete = 'F'
		cReturn := '(FOB)'
	Case cTipofrete = 'T'
		cReturn := '(TER)'
	Case cTipofrete = 'S'
		cReturn := '(SEM)'		
End

Return cReturn