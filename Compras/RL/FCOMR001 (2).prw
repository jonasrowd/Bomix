#INCLUDE "FCOMR001.CH"
#INCLUDE "PROTHEUS.CH"             
    
  
  
/*/
����������������������������������������������������������������������������?
���Fun��o    ?FCOMR001 ?Autor ?Alexandre Inacio Lemes?Data ?6/09/2006��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Pedido de Compras e Autorizacao de Entrega                 ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?MATR110(void)                                              ��?
�������������������������������������������������������������������������Ĵ�?
��?Uso      ?Generico SIGACOM                                           ��?
����������������������������������������������������������������������������?
/*/

User Function FCOMR001( cAlias, nReg, nOpcx )

Local oReport
Local lTRepInUse := .T.

PRIVATE lAuto := (nReg!=Nil)

//����������������������������������������������������������������������������Ŀ
//�Para versoes localizadas em TReport R4 e usado o MATR110, a chamada e       ?
//�realizada atraves do MATR111 onde a funcao TRepInUse() e executada para     ?
//�selecionar o tipo de impressao R3 ou R4, este tratamento e para impedir que ?
//�a pergunta seja apresentada 2 vezes.                                        ?
//������������������������������������������������������������������������������
If FunName() == Alltrim("MATR111") .Or. (cPaisLoc <> "BRA" .And. FunName() == Alltrim("MATA121"))
	lTRepInUse := .T.
Else
	lTRepInUse := TRepInUse()
EndIf

//If FindFunction("TRepInUse") .And. lTRepInUse
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  ?
//��������������������������������������������������������������������������
oReport:= ReportDef(nReg, nOpcx)
oReport:PrintDialog()

Return

/*/
����������������������������������������������������������������������������?
���Programa  ?ReportDef�Autor  �Alexandre Inacio Lemes �Data  ?6/09/2006��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Pedido de Compras / Autorizacao de Entrega                 ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?nExp01: nReg = Registro posicionado do SC7 apartir Browse  ��?
��?         ?nExp02: nOpcx= 1 - PC / 2 - AE                             ��?
�������������������������������������������������������������������������Ĵ�?
���Retorno   ?oExpO1: Objeto do relatorio                                ��?
����������������������������������������������������������������������������?
/*/
Static Function ReportDef(nReg,nOpcx)

Local cTitle     := STR0003 // "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
Local nTamCdProd := TamSX3("C7_PRODUTO")[1]
Local nTamCdDesc := TamSX3("B1_DESC")[1]
Local nTamQtd    := TamSX3("C7_QUANT")[1]
Local oReport
Local oSection1
Local oSection2

//��������������������������������������������������������������Ŀ
//?Variaveis utilizadas para parametros                         ?
//?mv_par01               Do Pedido                             ?
//?mv_par02               Ate o Pedido                          ?
//?mv_par03               A partir da data de emissao           ?
//?mv_par04               Ate a data de emissao                 ?
//?mv_par05               Somente os Novos                      ?
//?mv_par06               Campo Descricao do Produto    	     ?
//?mv_par07               Unidade de Medida:Primaria ou Secund. ?
//?mv_par08               Imprime ? Pedido Compra ou Aut. Entreg?
//?mv_par09               Numero de vias                        ?
//?mv_par10               Pedidos ? Liberados Bloqueados Ambos  ?
//?mv_par11               Impr. SC's Firmes, Previstas ou Ambas ?
//?mv_par12               Qual a Moeda ?                        ?
//?mv_par13               Endereco de Entrega                   ?
//?mv_par14               todas ou em aberto ou atendidos       ?
//����������������������������������������������������������������
AjustaSX1()
Pergunte("MTR110",.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      ?
//?                                                                       ?
//�TReport():New                                                           ?
//�ExpC1 : Nome do relatorio                                               ?
//�ExpC2 : Titulo                                                          ?
//�ExpC3 : Pergunte                                                        ?
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ?
//�ExpC5 : Descricao                                                       ?
//��������������������������������������������������������������������������
oReport:= TReport():New("FCOMR001",cTitle,If(lAuto,Nil,"MTR110"), {|oReport| ReportPrint(oReport,nReg,nOpcx)},STR0001+" "+STR0002)
oReport:SetPortrait()
oReport:HideParamPage()
oReport:HideHeader()
oReport:HideFooter()
oReport:SetTotalInLine(.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               ?
//?                                                                       ?
//�TRSection():New                                                         ?
//�ExpO1 : Objeto TReport que a secao pertence                             ?
//�ExpC2 : Descricao da se�ao                                              ?
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ?
//?       sera considerada como principal para a se��o.                   ?
//�ExpA4 : Array com as Ordens do relat�rio                                ?
//�ExpL5 : Carrega campos do SX3 como celulas                              ?
//?       Default : False                                                 ?
//�ExpL6 : Carrega ordens do Sindex                                        ?
//?       Default : False                                                 ?
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                ?
//?                                                                       ?
//�TRCell():New                                                            ?
//�ExpO1 : Objeto TSection que a secao pertence                            ?
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser?consultado              ?
//�ExpC3 : Nome da tabela de referencia da celula                          ?
//�ExpC4 : Titulo da celula                                                ?
//?       Default : X3Titulo()                                            ?
//�ExpC5 : Picture                                                         ?
//?       Default : X3_PICTURE                                            ?
//�ExpC6 : Tamanho                                                         ?
//?       Default : X3_TAMANHO                                            ?
//�ExpL7 : Informe se o tamanho esta em pixel                              ?
//?       Default : False                                                 ?
//�ExpB8 : Bloco de c�digo para impressao.                                 ?
//?       Default : ExpC2                                                 ?
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0102,{"SC7","SM0","SA2"},/*aOrdem*/) //"| P E D I D O  D E  C O M P R A S"
oSection1:SetLineStyle()
oSection1:SetReadOnly()

TRCell():New(oSection1,"M0_NOMECOM","SM0",STR0087      ,/*Picture*/,49,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NOME"   ,"SA2",/*Titulo*/   ,/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_COD"    ,"SA2",/*Titulo*/   ,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_LOJA"   ,"SA2",/*Titulo*/   ,/*Picture*/,04,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_ENDENT" ,"SM0",STR0088      ,/*Picture*/,48,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_END"    ,"SA2",/*Titulo*/   ,/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_BAIRRO" ,"SA2",/*Titulo*/   ,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_CEPENT" ,"SM0",STR0089      ,/*Picture*/,10,/*lPixel*/,{|| Trans(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP")) })
TRCell():New(oSection1,"M0_CIDENT" ,"SM0",STR0090      ,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_ESTENT" ,"SM0",STR0091      ,/*Picture*/,11,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_MUN"    ,"SA2",/*Titulo*/   ,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_EST"    ,"SA2",/*Titulo*/   ,/*Picture*/,02,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_CEP"    ,"SA2",/*Titulo*/   ,/*Picture*/,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_CGC"    ,"SA2",/*Titulo*/   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_TEL"    ,"SM0",STR0092      ,/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_FAX"    ,"SM0",STR0093      ,/*Picture*/,34,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"FONE"      ,"   ",STR0094      ,/*Picture*/,25,/*lPixel*/,{|| "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15)})
TRCell():New(oSection1,"FAX"       ,"   ",STR0093      ,/*Picture*/,25,/*lPixel*/,{|| "("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)})
TRCell():New(oSection1,"INSCR"     ,"   ",If( cPaisLoc$"ARG|POR|EUA",space(11) , STR0095 ),/*Picture*/,18,/*lPixel*/,{|| If( cPaisLoc$"ARG|POR|EUA",space(18), SA2->A2_INSCR ) })
TRCell():New(oSection1,"M0_CGC"    ,"SM0",STR0092      ,/*Picture*/,14,/*lPixel*/,{|| Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")) })
TRCell():New(oSection1,"ATENCAO: HORARIO DE ENTREGA DAS 08:00H AS 12:00H, DAS 13:30H AS 16:00H","SM0",STR0124      ,/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/)


If cPaisLoc == "BRA"
	TRCell():New(oSection1,"M0IE"  ,"   ",STR0041      ,/*Picture*/,18,/*lPixel*/,{|| InscrEst()})
EndIf

oSection1:Cell("A2_BAIRRO"):SetCellBreak()
oSection1:Cell("A2_CGC"   ):SetCellBreak()
oSection1:Cell("INSCR"    ):SetCellBreak()

//Tamanho Descri��o //
If nTamCdDesc<30
	nTamCdDesc:=nTamCdDesc+(30-nTamCdDesc)
Else
	If nTamCdDesc>30
		nTamCdDesc:=30
	EndIf
EndIf  


oSection2:= TRSection():New(oSection1,STR0103,{"SC7","SB1"},/*aOrdem*/)

oSection2:SetCellBorder("ALL",,,.T.)
oSection2:SetCellBorder("RIGHT")
oSection2:SetCellBorder("LEFT")

TRCell():New(oSection2,"C7_ITEM"    ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"C7_PRODUTO" ,"SC7",/*Titulo*/,/*Picture*/,IIf(nTamCdProd<30,nTamCdProd+(30-nTamCdProd),30),/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"DESCPROD"   ,"   ",STR0097   ,/*Picture*/,nTamCdDesc,/*lPixel*/, {|| cDescPro},,,,,,.F.)
TRCell():New(oSection2,"C7_FSMARCA"	,"SC7","Marca",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"C7_UM"      ,"SC7",STR0115   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"C7_SEGUM"   ,"SC7",STR0118,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"C7_QUANT"   ,"SC7",/*Titulo*/,PesqPictQt("C7_QUANT",13),IIf(nTamQtd<12,nTamQtd+(12-nTamQtd),12),/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"C7_QTSEGUM" ,"SC7",/*Titulo*/,PesqPictQt("C7_QUANT",13),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"PRECO"      ,"   ",STR0098,/*Picture*/,16/*Tamanho*/,/*lPixel*/,{|| nVlUnitSC7 },"RIGHT",,"RIGHT")
TRCell():New(oSection2,"C7_IPI"     ,"SC7",/*Titulo*/,/*Picture*/,13,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"TOTAL"      ,"   ",STR0099,/*Picture*/,17.5,/*lPixel*/,{|| nValTotSC7 },"RIGHT",,"RIGHT",,,.F.)
TRCell():New(oSection2,"C7_DATPRF"  ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
//TRCell():New(oSection2,"C7_CC"      ,"SC7",STR0066,PesqPict("SC7","C7_CC",20),9,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"DESCCC"     ,"   ",STR0066,"@!",30,/*lPixel*/,{|| cDescCC },,,,,,.F.)
//TRCell():New(oSection2,"C7_NUMSC"   ,"SC7",STR0123,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
//TRCell():New(oSection2,"OPCC"       ,"   ",STR0100   ,/*Picture*/,30.5,/*lPixel*/,{|| cOPCC },,,,,,.F.)
TRCell():New(oSection2,"C7_OBS"     ,"SC7","OBS",/*Picture*/,30.5,/*lPixel*/,{|| cOBS  },,,,,,.F.)
                      
oSection2:Cell("C7_FSMARCA"):SetLineBreak()
oSection2:Cell("C7_PRODUTO"):SetLineBreak()
oSection2:Cell("DESCPROD"):SetLineBreak()
//oSection2:Cell("C7_CC"):SetLineBreak()
oSection2:Cell("DESCCC"):SetLineBreak()
//oSection2:Cell("OPCC"):SetLineBreak()  
oSection2:Cell("C7_OBS"):SetLineBreak()     


//oSection2:Cell("C7_NUMSC"):Disable()
//oSection2:Cell("C7_CC"   ):Disable()

n_Width := oSection2:GetWidth()

If nTamCdProd > 15
	oSection2:Cell("C7_IPI"):SetTitle(STR0119)
EndIf

Return(oReport)

/*/
����������������������������������������������������������������������������?
���Programa  �ReportPrin?Autor �Alexandre Inacio Lemes �Data  ?6/09/2006��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Emissao do Pedido de Compras / Autorizacao de Entrega      ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?ReportPrint(ExpO1,ExpN1,ExpN2)                             ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpO1 = Objeto oReport                      	              ��?
��?         ?ExpN1 = Numero do Recno posicionado do SC7 impressao Menu  ��?
��?         ?ExpN2 = Numero da opcao para impressao via menu do PC      ��?
�������������������������������������������������������������������������Ĵ�?
���Retorno   �Nenhum                                                      ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros�ExpO1: Objeto Report do Relat�rio                           ��?
����������������������������������������������������������������������������?
/*/

Static Function ReportPrint(oReport,nReg,nOpcX)

Local oSection1   := oReport:Section(1)
Local oSection2   := oReport:Section(1):Section(1)

Local aRecnoSave  := {}
Local aPedido     := {}
Local aPedMail    := {}
Local aValIVA     := {}

Local cNumSC7     := Len(SC7->C7_NUM)
Local cCondicao   := ""
Local cFiltro     := ""
Local cComprador  := ""
LOcal cAlter	  := ""
Local cAprov	  := ""
Local cTipoSC7    := ""
Local cCondBus    := ""
Local cMensagem   := ""
Local cVar        := ""
Local cPictVUnit  := PesqPict("SC7","C7_PRECO",16)
Local cPictVTot   := PesqPict("SC7","C7_TOTAL",, mv_par12)
Local lNewAlc	  := .F.
Local lLiber      := .F.

Local nRecnoSC7   := 0
Local nRecnoSM0   := 0
Local nX          := 0
Local nY          := 0
Local nVias       := 0
Local nTxMoeda    := 0
Local nTpImp	  := IIF(ValType(oReport:nDevice)!=Nil,oReport:nDevice,0) // Tipo de Impressao
Local nPageWidth  := IIF(nTpImp==1.Or.nTpImp==6,2314,2290) // oReport:PageWidth()
Local nPrinted    := 0
Local nValIVA     := 0
Local nTotIpi	  := 0
Local nTotIcms	  := 0
Local nTotDesp	  := 0
Local nTotFrete	  := 0
Local nTotalNF	  := 0
Local nTotSeguro  := 0
Local nLinPC	  := 0
Local nLinObs     := 0
Local nDescProd   := 0
Local nTotal      := 0
Local nTotMerc    := 0
Local nPagina     := 0
Local nOrder      := 1
Local cUserId     := RetCodUsr()
Local cCont       := Nil
Local lImpri      := .F.
Local cCident	  := ""
Local cCidcob	  := ""
Local nLinPC2	  := 0
Local nLinPC3	  := 0

Private cDescPro  := ""
Private cDescCC   := ""
Private cOPCC     := ""
Private cOBS      := ""
Private	nVlUnitSC7:= 0
Private nValTotSC7:= 0

Private cObs01    := ""
Private cObs02    := ""
Private cObs03    := ""
Private cObs04    := ""
Private cObs05    := ""
Private cObs06    := ""
Private cObs07    := ""
Private cObs08    := ""
Private cObs09    := ""
Private cObs10    := ""
Private cObs11    := ""
Private cObs12    := ""
Private cObs13    := ""
Private cObs14    := ""
Private cObs15    := ""
Private cObs16    := ""
Private l_Parcela := .F.

If Type("lPedido") != "L"
	lPedido := .F.
Endif

If nTpImp==1 .Or. nTpImp==6
	oSection2:ACELL[2]:NSIZE:=20
	oSection2:ACELL[3]:NSIZE:=20
	//	oSection2:ACELL[14]:NSIZE:=25	//Marca
//	oSection2:ACELL[15]:NSIZE:=25  sc
EndIf

dbSelectArea("SC7")

If lAuto
	dbSelectArea("SC7")
	dbGoto(nReg)
	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
	mv_par03 := SC7->C7_EMISSAO
	mv_par04 := SC7->C7_EMISSAO
	mv_par05 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","05"),If(cCont == Nil,2,cCont) })
	mv_par08 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","08"),If(cCont == Nil,C7_TIPO,cCont) })
	mv_par09 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","09"),If(cCont == Nil,1,cCont) })
	mv_par10 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","10"),If(cCont == Nil,3,cCont) })
	mv_par11 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","11"),If(cCont == Nil,3,cCont) })
	mv_par14 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","14"),If(cCont == Nil,1,cCont) })
Else
	MakeAdvplExpr(oReport:uParam)
	
	cCondicao := 'C7_FILIAL=="'       + xFilial("SC7") + '".And.'
	cCondicao += 'C7_NUM>="'          + mv_par01       + '".And.C7_NUM<="'          + mv_par02 + '".And.'
	cCondicao += 'Dtos(C7_EMISSAO)>="'+ Dtos(mv_par03) +'".And.Dtos(C7_EMISSAO)<="' + Dtos(mv_par04) + '"'
	
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
EndIf

If lPedido
	mv_par12 := MAX(SC7->C7_MOEDA,1)
Endif

If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
	If ( cPaisLoc$"ARG|POR|EUA" )
		cCondBus := "1"+StrZero(Val(mv_par01),6)
		nOrder	 := 10
	Else
		cCondBus := mv_par01
		nOrder	 := 1
	EndIf
Else
	cCondBus := "2"+StrZero(Val(mv_par01),6)
	nOrder	 := 10
EndIf

If mv_par14 == 2
	cFiltro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
Elseif mv_par14 == 3
	cFiltro := "SC7->C7_QUANT > SC7->C7_QUJE"
EndIf

oSection2:Cell("PRECO"):SetPicture(cPictVUnit)
oSection2:Cell("TOTAL"):SetPicture(cPictVTot)

TRPosition():New(oSection2,"SB1",1,{ || xFilial("SB1") + SC7->C7_PRODUTO })
TRPosition():New(oSection2,"SB5",1,{ || xFilial("SB5") + SC7->C7_PRODUTO })

//������������������������������������������������������������������������������������������?
//?Executa o CodeBlock com o PrintLine da Sessao 1 toda vez que rodar o oSection1:Init()   ?
//������������������������������������������������������������������������������������������?
oReport:onPageBreak( { || nPagina++ , nPrinted := 0 , CabecPCxAE(oReport,oSection1,nVias,nPagina) })

oReport:SetMeter(SC7->(LastRec()))
dbSelectArea("SC7")
dbSetOrder(nOrder)
dbSeek(xFilial("SC7")+cCondBus,.T.)

oSection2:Init()

cNumSC7 := SC7->C7_NUM

While !oReport:Cancel() .And. !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02
	
	If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
		(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
		((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
		((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
		(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
		(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
		((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )
		
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	If oReport:Cancel()
		Exit
	EndIf
	
	MaFisEnd()
//	MaFisIniPC(SC7->C7_NUM,,,cFiltro)
	R110FIniPC(SC7->C7_NUM,,,cFiltro)
	
	cObs01    := " "
	cObs02    := " "
	cObs03    := " "
	cObs04    := " "
	cObs05    := " "
	cObs06    := " "
	cObs07    := " "
	cObs08    := " "
	cObs09    := " "
	cObs10    := " "
	cObs11    := " "
	cObs12    := " "
	cObs13    := " "
	cObs14    := " "
	cObs15    := " "
	cObs16    := " "
	
	//������������������������������������������������������������������Ŀ
	//?Roda a impressao conforme o numero de vias informado no mv_par09 ?
	//��������������������������������������������������������������������
	For nVias := 1 to mv_par09
		
		//��������������������������������������������������������������Ŀ
		//?Dispara a cabec especifica do relatorio.                     ?
		//����������������������������������������������������������������
		oReport:EndPage()
		
		nPagina  := 0
		nPrinted := 0
		nTotal   := 0
		nTotMerc := 0
		nDescProd:= 0
		nLinObs  := 0
		nRecnoSC7:= SC7->(Recno())
		cNumSC7  := SC7->C7_NUM
		aPedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}
		
		While !oReport:Cancel() .And. !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cNumSC7
			
			If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
				(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
				(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
				((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
				((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
				(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
				(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
				((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )
				dbSelectArea("SC7")
				dbSkip()
				Loop
			Endif
			
			If oReport:Cancel()
				Exit
			EndIf
			
			oReport:IncMeter()
			
			If oReport:Row() > oReport:LineHeight() * 100
				oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, nPageWidth )
				oReport:SkipLine()
				oReport:PrintText(STR0101,, 050 ) // Continua na Proxima pagina ....
				oReport:EndPage()
			EndIf
			
			//��������������������������������������������������������������Ŀ
			//?Salva os Recnos do SC7 no aRecnoSave para marcar reimpressao.?
			//����������������������������������������������������������������
			If Ascan(aRecnoSave,SC7->(Recno())) == 0
				AADD(aRecnoSave,SC7->(Recno()))
			Endif
			
			//������������������������������������������������������������Ŀ
			//?Inicializa o descricao do Produto conf. parametro digitado.?
			//��������������������������������������������������������������
			cDescPro :=  ""
			If Empty(mv_par06)
				mv_par06 := "B1_DESC"
			EndIf
			
			If AllTrim(mv_par06) == "B1_DESC"
				SB1->(dbSetOrder(1))
				SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))
				cDescPro := SB1->B1_DESC
			ElseIf AllTrim(mv_par06) == "B5_CEME"
				SB5->(dbSetOrder(1))
				If SB5->(dbSeek( xFilial("SB5") + SC7->C7_PRODUTO ))
					cDescPro := SB5->B5_CEME
				EndIf
			ElseIf AllTrim(mv_par06) == "C7_DESCRI"
				cDescPro := SC7->C7_DESCRI
			EndIf
			
			    
			
			If Empty(cDescPro)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))
				cDescPro := SB1->B1_DESC
			EndIf
			
			SA5->(dbSetOrder(1))
			If SA5->(dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)) .And. !Empty(SA5->A5_CODPRF)
				cDescPro := cDescPro + " ("+Alltrim(SA5->A5_CODPRF)+")"
			EndIf
			
			If SC7->C7_DESC1 != 0 .Or. SC7->C7_DESC2 != 0 .Or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif

			a_Area  := GetArea()			
			cDescCC := AllTrim(SC7->C7_CC) + "-" + Posicione("CTT", 1, xFilial("CTT") + SC7->C7_CC, "CTT_DESC01")
			cOBS    := AllTrim(SC7->C7_OBS)
			RestArea(a_Area)
			
			//��������������������������������������������������������������Ŀ
			//?Inicializacao da Observacao do Pedido.                       ?
			//����������������������������������������������������������������
			If !Empty(SC7->C7_OBS) .And. nLinObs < 17
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			
			nTxMoeda   := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
			nValTotSC7 := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			
			nTotal     := nTotal + SC7->C7_TOTAL
			nTotMerc   := MaFisRet(,"NF_TOTAL")
			
			If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM) .And. !Empty(SC7->C7_SEGUM)
				oSection2:Cell("C7_DATPRF"):SetSize(9)
				oSection2:Cell("C7_SEGUM"  ):Enable()
				oSection2:Cell("C7_QTSEGUM"):Enable()
				oSection2:Cell("C7_UM"     ):Disable()
				oSection2:Cell("C7_QUANT"  ):Disable()
				nVlUnitSC7 := xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			Else
				oSection2:Cell("C7_DATPRF"):SetSize(11)
				oSection2:Cell("C7_SEGUM"  ):Disable()
				oSection2:Cell("C7_QTSEGUM"):Disable()
				oSection2:Cell("C7_UM"     ):Enable()
				oSection2:Cell("C7_QUANT"  ):Enable()
				nVlUnitSC7 := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			EndIf
			
			If cPaisLoc <> "BRA" .Or. mv_par08 == 2
				oSection2:Cell("C7_IPI" ):Disable()
			EndIf
			
			If mv_par08 == 1 .OR. mv_par08 == 3
		//		oSection2:Cell("OPCC"):Disable()
			Else
				oSection2:Cell("C7_DATPRF"):SetSize(9)
//				oSection2:Cell("C7_CC"):Disable()
				oSection2:Cell("C7_NUMSC"):Disable()
				If !Empty(SC7->C7_OP)
		//			cOPCC := STR0065 + " " + SC7->C7_OP
				ElseIf !Empty(SC7->C7_CC)
//					cOPCC := STR0066 + " " + SC7->C7_CC
				EndIf
			EndIf
			
			oSection2:PrintLine()

			nTotDesp  += SC7->C7_DESPESA
//			nTotFrete += SC7->C7_VALFRE

			nPrinted ++
			lImpri  := .T.
			dbSelectArea("SC7")
			dbSkip()
			
		EndDo
		
		SC7->(dbGoto(nRecnoSC7))
		
		If oReport:Row() > oReport:LineHeight() * 68
			
			oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, nPageWidth )
			oReport:SkipLine()
			oReport:PrintText(STR0101,, 050 ) // Continua na Proxima pagina ....
			
			//��������������������������������������������������������������Ŀ
			//?Dispara a cabec especifica do relatorio.                     ?
			//����������������������������������������������������������������
			oReport:EndPage()
			oReport:PrintText(" ",1992 , 010 ) // Necessario para posicionar Row() para a impressao do Rodape
			
			oReport:Box( 280,010,oReport:Row() + oReport:LineHeight() * ( 90 - nPrinted ) , nPageWidth )
			
		Else
			oReport:Box( oReport:Row(),oReport:Col(),oReport:Row() + oReport:LineHeight() * ( 90 - nPrinted ) , nPageWidth )
		EndIf
		
		oReport:Box( 1990 ,010,oReport:Row() + oReport:LineHeight() * ( 96 - nPrinted ) , nPageWidth )
		oReport:Box( 2080 ,010,oReport:Row() + oReport:LineHeight() * ( 96 - nPrinted ) , nPageWidth )
		oReport:Box( 2200 ,010,oReport:Row() + oReport:LineHeight() * ( 96 - nPrinted ) , nPageWidth )
		oReport:Box( 2320 ,010,oReport:Row() + oReport:LineHeight() * ( 96 - nPrinted ) , nPageWidth )
		
		oReport:Box( 2200 , 830 , 2320 , 1080 ) // Box da Data de Emissao
		oReport:Box( 2200 , 1080 , 2320 , 1400 ) // Box da Data de Emissao
		oReport:Box( 2320 ,  010 , 2406 , 1220 ) // Box do Reajuste
		oReport:Box( 2320 , 1220 , 2460 , 1750 ) // Box do IPI e do Frete
		oReport:Box( 2320 , 1750 , 2460 , nPageWidth ) // Box do ICMS Despesas e Seguro
		oReport:Box( 2406 ,  010 , 2700 , 1220 ) // Box das Observacoes
		
		cMensagem:= Formula(C7_MSG)
		If !Empty(cMensagem)
			oReport:SkipLine()
			oReport:PrintText(PadR(cMensagem,129), , oSection2:Cell("DESCPROD"):ColPos() )
		Endif
		
		oReport:PrintText( STR0007 /*"D E S C O N T O S -->"*/ + " " + ;
		TransForm(SC7->C7_DESC1,"999.99" ) + " %    " + ;
		TransForm(SC7->C7_DESC2,"999.99" ) + " %    " + ;
		TransForm(SC7->C7_DESC3,"999.99" ) + " %    " + ;
		TransForm(xMoeda(nDescProd,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , PesqPict("SC7","C7_VLDESC",14, MV_PAR12) ),;
		2022 , 050 )
		
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		
		//��������������������������������������������������������������Ŀ
		//?Posiciona o Arquivo de Empresa SM0.                          ?
		//?Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "?
		//?e o Local de Cobranca :                                      ?
		//����������������������������������������������������������������
		SM0->(dbSetOrder(1))
		nRecnoSM0 := SM0->(Recno())
		SM0->(dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))
		
		cCident := IIF(len(SM0->M0_CIDENT)>20,Substr(SM0->M0_CIDENT,1,15),SM0->M0_CIDENT)
		cCidcob := IIF(len(SM0->M0_CIDCOB)>20,Substr(SM0->M0_CIDCOB,1,15),SM0->M0_CIDCOB)
		
		If Empty(MV_PAR13) //"Local de Entrega  : "
			oReport:PrintText(STR0008 + SM0->M0_ENDENT+"  "+Rtrim(SM0->M0_CIDENT)+"  - "+SM0->M0_ESTENT+" - "+STR0009+" "+Trans(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP")),, 050 )
		Else
			oReport:PrintText(STR0008 + mv_par13,, 050 ) //"Local de Entrega  : " imprime o endereco digitado na pergunte
		Endif
		SM0->(dbGoto(nRecnoSM0))
		oReport:PrintText(STR0010 + SM0->M0_ENDCOB+"  "+Rtrim(SM0->M0_CIDCOB)+"  - "+SM0->M0_ESTCOB+" - "+STR0009+" "+Trans(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP")),, 050 )
		
		oReport:SkipLine()
		oReport:SkipLine()
		
		SE4->(dbSetOrder(1))
		SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
		
		nLinPC := oReport:Row()
		oReport:PrintText( STR0011+SubStr(SE4->E4_COND,1,40),nLinPC,050 )
		oReport:PrintText( "Data de Previs�o",nLinPC,500 )
		oReport:PrintText( "Prazo de Entrega",nLinPC,850 ) //"Prazo de Entrega"
		oReport:PrintText( "Data de Emiss�o",nLinPC,1120 ) //"Data de Emissao"
		oReport:PrintText( STR0013 +" "+ Transform(xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotal,14,MsDecimais(MV_PAR12)) ),nLinPC,1612 ) //"Total das Mercadorias : "
		oReport:SkipLine()
		nLinPC := oReport:Row()
		
		If cPaisLoc<>"BRA"
			aValIVA := MaFisRet(,"NF_VALIMP")
			nValIVA :=0
			If !Empty(aValIVA)
				For nY:=1 to Len(aValIVA)
					nValIVA+=aValIVA[nY]
				Next nY
			EndIf
			oReport:PrintText(SubStr(SE4->E4_DESCRI,1,34),nLinPC, 050 )
			oReport:PrintText( dtoc(SC7->C7_EMISSAO),nLinPC,850 )
			oReport:PrintText( dtoc(SC7->C7_EMISSAO),nLinPC,1120 )
			oReport:PrintText( STR0063+ "   " + ; //"Total dos Impostos:    "
			Transform(xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nValIVA,14,MsDecimais(MV_PAR12)) ),nLinPC,1612 )
		Else
			oReport:PrintText( SubStr(SE4->E4_DESCRI,1,34),nLinPC, 050 )
			oReport:PrintText( Dtoc(SC7->C7_FSDTPRE),nLinPC,500 )
			oReport:PrintText( AllTrim(STR(DATEDIFFDAY(SC7->C7_DATPRF,SC7->C7_EMISSAO))) + " dia(s)",nLinPC,850 )	//Prazo de Entrega
			oReport:PrintText( dtoc(SC7->C7_EMISSAO),nLinPC,1120 )
			oReport:PrintText( STR0064+ "  " + ; //"Total com Impostos:    "
			Transform(xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotMerc,14,MsDecimais(MV_PAR12)) ),nLinPC,1612 )
		Endif
		oReport:SkipLine()
		
		nTotIpi	  := MaFisRet(,'NF_VALIPI')
		nTotIcms  := MaFisRet(,'NF_VALICM')
//		nTotDesp  := MaFisRet(,'NF_DESPESA')
		nTotFrete := MaFisRet(,'NF_FRETE')
		nTotSeguro:= MaFisRet(,'NF_SEGURO')
		nTotalNF  := MaFisRet(,'NF_TOTAL')

		oReport:SkipLine()
		oReport:SkipLine()
		nLinPC := oReport:Row()
		
		SM4->(dbSetOrder(1))
		If SM4->(dbSeek(xFilial("SM4")+SC7->C7_REAJUST))
			oReport:PrintText(  STR0014 + " " + SC7->C7_REAJUST + " " + SM4->M4_DESCR ,nLinPC, 050 )  //"Reajuste :"
		EndIf

		oReport:PrintText( "Respons�vel : " + Capital(FWLeUserlg("C7_USERLGI", 1)) ,nLinPC,050 )
		
		If cPaisLoc == "BRA"
			oReport:PrintText( STR0071 + Transform(xMoeda(nTotIPI ,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIpi ,14,MsDecimais(MV_PAR12))) ,nLinPC,1320 ) //"IPI      :"
			oReport:PrintText( STR0072 + Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIcms,14,MsDecimais(MV_PAR12))) ,nLinPC,1815 ) //"ICMS     :"
		EndIf
		oReport:SkipLine()
		
		nLinPC := oReport:Row()
		oReport:PrintText( STR0073 + Transform(xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotFrete,14,MsDecimais(MV_PAR12))) ,nLinPC,1320 ) //"Frete    :"
		oReport:PrintText( STR0074 + Transform(xMoeda(nTotDesp ,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotDesp ,14,MsDecimais(MV_PAR12))) ,nLinPC,1815 ) //"Despesas :"
		oReport:SkipLine()
		
		//��������������������������������������������������������������Ŀ
		//?Inicializar campos de Observacoes.                           ?
		//����������������������������������������������������������������
		If Empty(cObs02)
			If Len(cObs01) > 30
				cObs := cObs01
				cObs01 := Substr(cObs,1,30)
				For nX := 2 To 16
					cVar  := "cObs"+StrZero(nX,2)
					&cVar := Substr(cObs,(30*(nX-1))+1,30)
				Next nX
			EndIf
		Else
			cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<30,Len(cObs01),30))
			cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<30,Len(cObs01),30))
			cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<30,Len(cObs01),30))
			cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<30,Len(cObs01),30))
			cObs05:= Substr(cObs05,1,IIf(Len(cObs05)<30,Len(cObs01),30))
			cObs06:= Substr(cObs06,1,IIf(Len(cObs06)<30,Len(cObs01),30))
			cObs07:= Substr(cObs07,1,IIf(Len(cObs07)<30,Len(cObs01),30))
			cObs08:= Substr(cObs08,1,IIf(Len(cObs08)<30,Len(cObs01),30))
			cObs09:= Substr(cObs09,1,IIf(Len(cObs09)<30,Len(cObs01),30))
			cObs10:= Substr(cObs10,1,IIf(Len(cObs10)<30,Len(cObs01),30))
			cObs11:= Substr(cObs11,1,IIf(Len(cObs11)<30,Len(cObs01),30))
			cObs12:= Substr(cObs12,1,IIf(Len(cObs12)<30,Len(cObs01),30))
			cObs13:= Substr(cObs13,1,IIf(Len(cObs13)<30,Len(cObs01),30))
			cObs14:= Substr(cObs14,1,IIf(Len(cObs14)<30,Len(cObs01),30))
			cObs15:= Substr(cObs15,1,IIf(Len(cObs15)<30,Len(cObs01),30))
			cObs16:= Substr(cObs16,1,IIf(Len(cObs16)<30,Len(cObs01),30))
		EndIf
		
		/*
       		Condicao
			Esta fun��o permite avaliar uma condi��o de pagamento, retornando um array
  			multidimensional com informa��es referentes ao valor e vencimento de cada
   			parcela, de acordo com a condi��o de pagamento.
  
   			Sintaxe
   			Condicao(nValTot,cCond,nVIPI,dData,nVSol)
 
   			Parametros
   			nValTot ?Valor total a ser parcelado
   			cCond ?C�digo da condi��o de pagamento
   			nVIPI ?Valor do IPI, destacado para condi��o que obrigue o pagamento
   			do IPI na 1?parcela
   			dData ?Data inicial para considerar
  
   			Retorna
   			aRet ?Array de retorno ( { {dVencto, nValor} , ... } )
       	*/
       	If !l_Parcela
	   		a_Parcelas := Condicao(nTotalNF, SC7->C7_COND, 0, SC7->C7_FSDTPRE)
	   		j := 0
	   		
	   		If Empty(cObs01)
	   			j := 1
	   		Elseif Empty(cObs02)
	   			j := 2   			
	   		Elseif Empty(cObs03)
	   			j := 3   			   			
	   		Elseif Empty(cObs04)
	   			j := 4
	   		Elseif Empty(cObs05)
	   			j := 5   			
	   		Elseif Empty(cObs06)
	   			j := 6   			
	   		Elseif Empty(cObs07)
	   			j := 7   			
	   		Elseif Empty(cObs08)
	   			j := 8   			   			
	   		Elseif Empty(cObs09)
	   			j := 9
	   		Elseif Empty(cObs10)
	   			j := 10   			
	   		Elseif Empty(cObs11)
	   			j := 11   				   			
	   		Elseif Empty(cObs12)
	   			j := 12   			
	   		Elseif Empty(cObs13)
	   			j := 13   			   			
	   		Elseif Empty(cObs14)
	   			j := 14
	   		Elseif Empty(cObs15)
	   			j := 15
	   		Elseif Empty(cObs16)
	   			j := 16
	   		Endif

			If j > 0
		   		For i:=1 To Len(a_Parcelas)
		           	&("cObs" + StrZero(j++, 2)) := StrZero(i, 2) + " - " + Dtoc(DataValida(a_Parcelas[i][1], .T.)) + Transform(a_Parcelas[i][2], "@E 999,999,999.99")
		       	Next		
		    Endif

	       	l_Parcela := .T.
		Endif
	
		cComprador:= ""
		cAlter	  := ""
		cAprov	  := ""
		lNewAlc	  := .F.
		lLiber 	  := .F.
		
		dbSelectArea("SC7")
		If !Empty(SC7->C7_APROV)
			
			cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
			lNewAlc := .T.
			cComprador := UsrFullName(SC7->C7_USER)
			If SC7->C7_CONAPRO != "B"
				lLiber := .T.
			EndIf
			dbSelectArea("SCR")
			dbSetOrder(1)
			dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
			While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == cTipoSC7
				cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
				Do Case
					Case SCR->CR_STATUS=="03" //Liberado
						cAprov += "Ok"
					Case SCR->CR_STATUS=="04" //Bloqueado
						cAprov += "BLQ"
					Case SCR->CR_STATUS=="05" //Nivel Liberado
						cAprov += "##"
					OtherWise                 //Aguar.Lib
						cAprov += "??"
				EndCase
				cAprov += "] - "
				dbSelectArea("SCR")
				dbSkip()
			Enddo
			If !Empty(SC7->C7_GRUPCOM)
				dbSelectArea("SAJ")
				dbSetOrder(1)
				dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
				While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
					If SAJ->AJ_USER != SC7->C7_USER
						cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
					EndIf
					dbSelectArea("SAJ")
					dbSkip()
				EndDo
			EndIf
		EndIf
		
		If SC7->C7_TPFRETE == "C"					//CIF
			c_TpFrete := "CIF"
		Elseif SC7->C7_TPFRETE == "F"               //FOB
			c_TpFrete := "FOB"
		Elseif SC7->C7_TPFRETE == "T"               //POR CONTA TERCEIROS
			c_TpFrete := "POR CONTA TERCEIROS"
		Else						               //SEM FRETE
			c_TpFrete := "SEM FRETE"
		Endif
		
		nLinPC := oReport:Row()
		oReport:PrintText("Observa��es" ,nLinPC, 050 ) // "Observacoes "    
		oReport:PrintText("Seguro   :" + Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotSeguro,14,MsDecimais(MV_PAR12))) ,nLinPC, 1815 )

		oReport:SkipLine()
		nLinPC := oReport:Row()

		oReport:SkipLine()
		
		nLinPC2 := oReport:Row()
		oReport:PrintText(cObs01,,050 )
		oReport:PrintText(cObs02,,050 )
		
		nLinPC := oReport:Row()
		oReport:PrintText(cObs03,nLinPC,050 )
		
		If !lNewAlc
			oReport:PrintText( STR0078 + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))) ,nLinPC,1774 ) //"Total Geral :"
		Else
			If lLiber
				oReport:PrintText( STR0078 + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))) ,nLinPC,1774 )
			Else
				oReport:PrintText( STR0078 + If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),STR0051,STR0086) ,nLinPC,1390 )
			EndIf
		EndIf
		oReport:SkipLine()
		
		oReport:PrintText(cObs04,,050 )
		oReport:PrintText(cObs05,,050 )
		oReport:PrintText(cObs06,,050 )
		nLinPC3 := oReport:Row()
		oReport:PrintText(cObs07,,050 )
		oReport:PrintText(cObs08,,050 )
		oReport:PrintText(cObs09,nLinPC2,650 )
		oReport:SkipLine()
		oReport:PrintText(cObs10,,650 )
		oReport:PrintText(cObs11,,650 )
		oReport:PrintText(cObs12,,650 )
		oReport:PrintText(cObs13,,650 )
		oReport:PrintText(cObs14,,650 )
		oReport:PrintText(cObs15,,650 )
		oReport:PrintText(cObs16,,650 )
/*		
		oReport:Box( 2700 , 0010 , 3220 , 0400 )
		oReport:Box( 2700 , 0400 , 3220 , 0800 )
		oReport:Box( 2700 , 0800 , 3220 , 1220 )
		oReport:Box( 2600 , 1220 , 3220 , 1770 )
		oReport:Box( 2600 , 1770 , 3220 , nPageWidth )
*/		
		oReport:Box( 2700 , 0010 , 2905 , 0400 )
		oReport:Box( 2700 , 0400 , 2905 , 0800 )
		oReport:Box( 2700 , 0800 , 2905 , 1220 )
		oReport:Box( 2600 , 1220 , 2905 , 1770 )
		oReport:Box( 2600 , 1770 , 2905 , nPageWidth )
		
		oReport:Line(2970 , 0010 , 2970 , nPageWidth )

		oReport:SkipLine()
//		oReport:SkipLine()
//		oReport:SkipLine()
		
		nLinPC := oReport:Row()
		oReport:PrintText( If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"Libera��o do Pedido",STR0084),nLinPC,1310) //"Liberacao do Pedido"##"Liber. Autorizacao "
		oReport:PrintText( STR0080 + IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " )) ,nLinPC,1820 )
		oReport:SkipLine()
		
//		oReport:SkipLine()
//		oReport:SkipLine()
		
		nLinPC := oReport:Row()
		//			oReport:PrintText( STR0021 ,nLinPC, 050 ) //"Comprador"
		//			oReport:PrintText( STR0022 ,nLinPC, 430 ) //"Gerencia"
		//			oReport:PrintText( STR0023 ,nLinPC, 850 ) //"Diretoria"
		oReport:PrintText( 'Aprova��o' ,nLinPC, 050 ) //"Comprador" substitu�do por Aprova��o
		oReport:PrintText( 'Fornecedor' ,nLinPC, 430 ) //"Gerencia" substitu�do por Fornecedor
		oReport:PrintText( 'C. Pagar' ,nLinPC, 850 ) //"Diretoria" substitu�do por C. Pagar
		oReport:SkipLine()
		
		oReport:SkipLine()
		oReport:SkipLine()
//		oReport:SkipLine()
		
		nLinPC := oReport:Row()
		oReport:PrintText( Replic("_",23) ,nLinPC,  050 )
		oReport:PrintText( Replic("_",23) ,nLinPC,  430 )
		oReport:PrintText( Replic("_",23) ,nLinPC,  850 )
		oReport:PrintText( Replic("_",31) ,nLinPC, 1310 )
		oReport:SkipLine()
		
		oReport:SkipLine()
//		oReport:SkipLine()
//		oReport:SkipLine()
//		oReport:SkipLine()
//		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText( "Verificado conforme lista de inspe��o para material controlado anexo 7.8 IT-ALMO" ,nLinPC, 050 )
		oReport:PrintText( '[ ] - APROVADO' ,nLinPC,1310)
		oReport:PrintText( '[ ] - REPROVADO',nLinPC,1560)
		
		//Inicio Bomix  (Sandro Santos 30/01/13)

		oReport:SkipLine()
		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText( "O Fornecedor declara que suas atividades e propriedades est�o em conformidade com a legisla��o ambiental brasileira e a legisla��o trabalhista relativa" ,nLinPC, 050)
		
		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText( "a sa�de e seguran�a ocupacional, inclusive quanto a aus�ncia de trabalho an�logo ao escravo e infantil bem como a legisla��o ambiental brasileira.",nLinPC, 050)
		
		oReport:SkipLine()
		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText( "NOTA" ,nLinPC, 050 )
		
		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText( "I  - S?aceitaremos a mercadoria se na sua Nota Fiscal constar o n�mero do nosso Pedido de Compras." ,nLinPC, 050 )
		//Fim Bomix  (Sandro Santos 30/01/13)
		
		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText("II - O pagamento da nota fiscal correspondente a esta autoriza��o de fornecimento somente ser?efetuado ap�s nossa confirma��o do recebimento do arquivo XML" ,nLinPC, 050 )

		oReport:SkipLine()
		nLinPC := oReport:Row()
		oReport:PrintText("     no e-mail nfe@bomix.com.br, disponibilizado compulsoriamente pelo emitente da NF-e, conforme base legal do Ajuste SINIEF 22/13. " ,nLinPC, 050 )
		//			If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
		//oReport:PrintText(STR0081,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
		//			Else
		//				oReport:PrintText(STR0083,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
		//			EndIf
		/*
		Else
		
		oReport:Box( 2570 , 1220 , 2700 , 1850 )
		oReport:Box( 2570 , 1850 , 2700 , nPageWidth )
		oReport:Box( 2700 , 0010 , 3020 , nPageWidth )
		oReport:Box( 2970 , 0010 , 3020 , 1340 )
		
		nLinPC := nLinPC3
		
		oReport:PrintText( If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3), If( lLiber , STR0050 , STR0051 ) , If( lLiber , STR0085 , STR0086 ) ),nLinPC,1290 ) //"     P E D I D O   L I B E R A D O"#"|     P E D I D O   B L O Q U E A D O !!!"
		oReport:PrintText( STR0080 + If( SC7->C7_TPFRETE $ "F","FOB",If(SC7->C7_TPFRETE $ "C","CIF"," " )),nLinPC,1920 ) //"Obs. do Frete: "
		oReport:SkipLine()
		
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:PrintText(STR0052+" "+Substr(cComprador,1,60),,050 ) 	//"Comprador Responsavel :" //"BLQ:Bloqueado"
		oReport:SkipLine()
		oReport:PrintText(STR0053+" "+If( Len(cAlter) > 0 , Substr(cAlter,001,130) , " " ),,050 ) //"Compradores Alternativos :"
		oReport:PrintText(            If( Len(cAlter) > 0 , Substr(cAlter,131,130) , " " ),,440 ) //"Compradores Alternativos :"
		oReport:SkipLine()
		oReport:PrintText(STR0054+" "+If( Len(cAprov) > 0 , Substr(cAprov,001,140) , " " ),,050 ) //"Aprovador(es) :"
		oReport:PrintText(            If( Len(cAprov) > 0 , Substr(cAprov,141,140) , " " ),,310 ) //"Aprovador(es) :"
		oReport:SkipLine()
		
		nLinPC := oReport:Row()
		oReport:PrintText( STR0082+" "+STR0060 ,nLinPC, 050 ) 	//"Legendas da Aprovacao : //"BLQ:Bloqueado"
		oReport:PrintText(       "|  "+STR0061 ,nLinPC, 610 ) 	//"Ok:Liberado"
		oReport:PrintText(       "|  "+STR0062 ,nLinPC, 830 ) 	//"??:Aguar.Lib"
		oReport:PrintText(       "|  "+STR0067 ,nLinPC,1070 )	//"##:Nivel Lib"
		oReport:SkipLine()
		
		oReport:SkipLine()
		If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
		oReport:PrintText(STR0081,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
		Else
		oReport:PrintText(STR0083,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
		EndIf
		EndIf
		*/
		
	Next nVias
	
	MaFisEnd()
	
	//��������������������������������������������������������������Ŀ
	//?Grava no SC7 as Reemissoes e atualiza o Flag de impressao.   ?
	//����������������������������������������������������������������
	dbSelectArea("SC7")
	If Len(aRecnoSave) > 0
		For nX :=1 to Len(aRecnoSave)
			dbGoto(aRecnoSave[nX])
			RecLock("SC7",.F.)
			SC7->C7_QTDREEM := (SC7->C7_QTDREEM + 1)
			SC7->C7_EMITIDO := "S"
			MsUnLock()
		Next nX
		//��������������������������������������������������������������Ŀ
		//?Reposiciona o SC7 com base no ultimo elemento do aRecnoSave. ?
		//����������������������������������������������������������������
		dbGoto(aRecnoSave[Len(aRecnoSave)])
	Endif
	
	Aadd(aPedMail,aPedido)
	
	aRecnoSave := {}
	
	dbSelectArea("SC7")
	dbSkip()
	
EndDo

oSection2:Finish()

//��������������������������������������������������������������Ŀ
//?Executa o ponto de entrada M110MAIL quando a impressao for   ?
//?enviada por email, fornecendo um Array para o usuario conten ?
//?do os pedidos enviados para possivel manipulacao.            ?
//����������������������������������������������������������������
If ExistBlock("M110MAIL")
	lEnvMail := HasEmail(,,,,.F.)
	If lEnvMail
		Execblock("M110MAIL",.F.,.F.,{aPedMail})
	EndIf
EndIf

If lAuto .And. !lImpri
	Aviso(STR0104,STR0105,{"OK"})
Endif

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

Return

/*/
����������������������������������������������������������������������������?
���Programa  �CabecPCxAE?Autor �Alexandre Inacio Lemes �Data  ?6/09/2006��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Emissao do Pedido de Compras / Autorizacao de Entrega      ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?CabecPCxAE(ExpO1,ExpO2,ExpN1,ExpN2)                        ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpO1 = Objeto oReport                      	              ��?
��?         ?ExpO2 = Objeto da sessao1 com o cabec                      ��?
��?         ?ExpN1 = Numero de Vias                                     ��?
��?         ?ExpN2 = Numero de Pagina                                   ��?
�������������������������������������������������������������������������Ĵ�?
���Retorno   �Nenhum                                                      ��?
����������������������������������������������������������������������������?
/*/
Static Function CabecPCxAE(oReport,oSection1,nVias,nPagina)

Local cMoeda	:= IIf( mv_par12 < 10 , Str(mv_par12,1) , StADMINr(mv_par12,2) )
Local nLinPC	:= 0
Local nTpImp	  := IIF(ValType(oReport:nDevice)!=Nil,oReport:nDevice,0) // Tipo de Impressao
Local nPageWidth  := IIF(nTpImp==1.Or.nTpImp==6,2314,2290)
Local cCident	:= IIF(len(SM0->M0_CIDENT)>20,Substr(SM0->M0_CIDENT,1,15),SM0->M0_CIDENT)
TRPosition():New(oSection1,"SA2",1,{ || xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA })

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

oSection1:Init()

oReport:Box( 010 , 010 ,  260 , 1000 )
oReport:Box( 010 , 1010,  260 , nPageWidth-2 ) // 2288

oReport:PrintText( If(nPagina > 1,(STR0033)," "),,oSection1:Cell("M0_NOMECOM"):ColPos())

nLinPC := oReport:Row()
oReport:PrintText( If( mv_par08 == 1 , (STR0068), (STR0069) ) + " - " + GetMV("MV_MOEDA"+cMoeda) ,nLinPC,1030 )
oReport:PrintText( If( mv_par08 == 1 , SC7->C7_NUM, SC7->C7_NUMSC + "/" + SC7->C7_NUM ) + " /" + Ltrim(Str(nPagina,2)) ,nLinPC,1910 )
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText( If( SC7->C7_QTDREEM > 0, Str(SC7->C7_QTDREEM+1,2) , "1" ) + STR0034 + Str(nVias,2) + STR0035 ,nLinPC,1910 )

oReport:SkipLine()
nLinPC := oReport:Row()
oReport:PrintText(STR0087 + SM0->M0_NOMECOM,nLinPC,15)  // "Empresa:"
oReport:PrintText(STR0106 + SA2->A2_NOME+" "+STR0107+SA2->A2_COD+" "+STR0108+SA2->A2_LOJA,nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0088 + SM0->M0_ENDENT,nLinPC,15)
oReport:PrintText(STR0088 + SA2->A2_END+" "+STR0109+SA2->A2_BAIRRO,nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0089 + Trans(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP"))+Space(2)+STR0090 + "  " + RTRIM(SM0->M0_CIDENT) + " " + STR0091 + SM0->M0_ESTENT ,nLinPC,15)
oReport:PrintText(STR0110+PADR(SA2->A2_MUN, 30)+" "+STR0111+SA2->A2_EST+" "+STR0112+SA2->A2_CEP+" "+STR0124+Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")),nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0092 + SM0->M0_TEL + Space(2) + STR0093 + SM0->M0_FAX ,nLinPC,15)
oReport:PrintText(STR0094 + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) + " "+STR0114+"("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)+" "+If( cPaisLoc$"ARG|POR|EUA",space(11) , STR0095 )+If( cPaisLoc$"ARG|POR|EUA",space(18), SA2->A2_INSCR ),nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0124 + Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")) ,nLinPC,15)

If cPaisLoc == "BRA"
	oReport:PrintText(Space(2) + STR0041 + InscrEst() ,nLinPC,415)
Endif

oReport:SkipLine()
oReport:SkipLine()

oSection1:Finish()

Return

/*/
����������������������������������������������������������������������������?
���Fun��o    �R110Center?Autor ?Jose Lucas            ?Data ?         ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Centralizar o Nome do Liberador do Pedido.                 ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?ExpC1 := R110CenteR(ExpC2)                                 ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpC1 := Nome do Liberador                                 ��?
���Parametros?ExpC2 := Nome do Liberador Centralizado                    ��?
�������������������������������������������������������������������������Ĵ�?
��?Uso      ?MatR110                                                    ��?
����������������������������������������������������������������������������?
/*/

Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )
 

/*
����������������������������������������������������������������������������?
���Programa  �AjustaSX1 �Autor  �Alexandre Lemes     ?Data ?17/12/2002  ��?
�������������������������������������������������������������������������͹�?
���Desc.     ?                                                           ��?
�������������������������������������������������������������������������͹�?
���Uso       ?MATR110                                                    ��?
����������������������������������������������������������������������������?
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Filtra os itens do PC a serem impressos " )
Aadd( aHelpPor, "Todos,somente os abertos ou Atendidos.  " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1("MTR110","14","Lista quais ?       ","Cuales Lista ?      ","List which ?        ","mv_che","N",1,0,1,"C","","","","","mv_par14",;
"Todos ","Todos ","All ","","Em Aberto ","En abierto ","Open ","Atendidos ","Atendidos ","Serviced ","","","","","","","","","","")
PutSX1Help("P.MTR11014.",aHelpPor,aHelpEng,aHelpSpa)

Return

/*/
����������������������������������������������������������������������������?
���Fun��o    �ChkPergUs ?Autor ?Nereu Humberto Junior ?Data ?1/09/07  ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Funcao para buscar as perguntas que o usuario nao pode     ��?
��?         ?alterar para impressao de relatorios direto do browse      ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?ChkPergUs(ExpC1,ExpC2,ExpC3)                               ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpC1 := Id do usuario                                     ��?
��?         ?ExpC2 := Grupo de perguntas                                ��?
��?         ?ExpC2 := Numero da sequencia da pergunta                   ��?
�������������������������������������������������������������������������Ĵ�?
��?Uso      ?MatR110                                                    ��?
����������������������������������������������������������������������������?
/*/

Static Function ChkPergUs(cUserId,cGrupo,cSeq)

Local aArea  := GetArea()
Local cRet   := Nil
Local cParam := "MV_PAR"+cSeq

dbSelectArea("SXK")
dbSetOrder(2)
If dbSeek("U"+cUserId+cGrupo+cSeq)
	If ValType(&cParam) == "C"
		cRet := AllTrim(SXK->XK_CONTEUD)
	ElseIf 	ValType(&cParam) == "N"
		cRet := Val(AllTrim(SXK->XK_CONTEUD))
	ElseIf 	ValType(&cParam) == "D"
		cRet := CTOD((AllTrim(SXK->XK_CONTEUD)))
	Endif
Endif

RestArea(aArea)

Return(cRet)

/*
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Funcao    �R110FIniPC?Autor ?Edson Maricate        ?Data ?0/05/2000��?
�������������������������������������������������������������������������Ĵ�?
���Descricao ?Inicializa as funcoes Fiscais com o Pedido de Compras      ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   ?R110FIniPC(ExpC1,ExpC2)                                    ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpC1 := Numero do Pedido                                  ��?
��?         ?ExpC2 := Item do Pedido                                    ��?
�������������������������������������������������������������������������Ĵ�?
��?Uso      ?MATR110,MATR120,Fluxo de Caixa                             ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
*/
Static Function R110FIniPC(cPedido,cItem,cSequen,cFiltro)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local cValid		:= ""
Local nPosRef		:= 0
Local nItem		:= 0
Local cItemDe		:= IIf(cItem==Nil,'',cItem)
Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
Local cRefCols	:= ''
DEFAULT cSequen	:= ""
DEFAULT cFiltro	:= ""

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
	MaFisEnd()
	MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
	While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
			SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

		// Nao processar os Impostos se o item possuir residuo eliminado  
		If &cFiltro
			dbSelectArea('SC7')
			dbSkip()
			Loop
		EndIf
            
		// Inicia a Carga do item nas funcoes MATXFIS  
		nItem++
		MaFisIniLoad(nItem)
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek('SC7')
		While !EOF() .AND. (X3_ARQUIVO == 'SC7')
			cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
			cValid	:= StrTran(cValid,"'",'"')
			If "MAFISREF" $ cValid
				nPosRef  := AT('MAFISREF("',cValid) + 10
				cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
				// Carrega os valores direto do SC7.           
				IF(SX3->X3_CAMPO <> "C7_OPER")
					MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
				EndIf
			EndIf
			dbSkip()
		End
		MaFisEndLoad(nItem,2)
		dbSelectArea('SC7')
		dbSkip()
	End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.