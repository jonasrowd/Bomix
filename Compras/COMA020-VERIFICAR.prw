#INCLUDE "PROTHEUS.CH"
#INCLUDE "COMA020.CH"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  � COMA020  � Autor � Aline Correa do Vale  � Data � 10.11.2003 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de Tolerancia no Recebimento de Materiais           ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Function COMA020()

	PRIVATE aRotina		:= MenuDef()

	//��������������������������������������������������������������Ŀ
	//� Define o cabecalho da tela de atualizacoes                   �
	//����������������������������������������������������������������
	PRIVATE cCadastro := OemtoAnsi(STR0001)	//"Tolerancia de Recebimento de Materiais"

	//��������������������������������������������������������������Ŀ
	//� Endereca a funcao de BROWSE                                  �
	//����������������������������������������������������������������
	mBrowse( 6, 1,22,75,"AIC")
Return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CM020Inclui� Autor � Aline Correa do Vale � Data �10.11.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Inclusao de Tes Inteligente                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � COMA020()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CM020Inclui(cAlias,nReg,nOpc)

	Local nOpca := 0
	INCLUI := .T.
	ALTERA := .F.

	//��������������������������������������������Ŀ
	//� Envia para processamento dos Gets          �
	//����������������������������������������������
	nOpcA:=0

	Begin Transaction
		nOpcA:=AxInclui( cAlias, nReg, nOpc,,,,"CM020TudOk(nOpc)")
	End Transaction

	dbSelectArea(cAlias)
Return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CM020Altera� Autor � Aline Correa do Vale � Data �10.11.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Inclusao de Tes Inteligente                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � COMA020()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CM020Altera(cAlias,nReg,nOpc)

	Local nOpca := 0
	INCLUI := .F.
	ALTERA := .T.

	//��������������������������������������������Ŀ
	//� Envia para processamento dos Gets          �
	//����������������������������������������������
	nOpcA:=0

	Begin Transaction
		nOpcA:=AxAltera( cAlias, nReg, nOpc,,,,,"CM020TudOk(nOpc)")
	End Transaction

	dbSelectArea(cAlias)
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CM020Exclui� Autor � Turibio Miranda		� Data �17.03.2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Exclusao de Tolerancia	                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � COMA020()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CM020Exclui(cAlias,nReg,nOpc)

	Local nOpca := 0
	INCLUI := .F.
	ALTERA := .F.
	lRet   := CM020TudOk(nOpc)
	//��������������������������������������������Ŀ
	//� Envia para processamento dos Gets          �
	//����������������������������������������������
	nOpcA:=0
	If lRet
		Begin Transaction
			nOpcA:=AxDeleta( cAlias, nReg, nOpc )
		End Transaction
	EndIf	  
	dbSelectArea(cAlias)
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CM020TudOk � Autor � Aline Correa do Vale � Data �10.11.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se o registro esta com chave duplicada             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CM020TudOk()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �COMA020                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CM020TudOk(nOpc)
	Local lRet      := .T.
	Local lRetPE    := .T.

	dbSetOrder(2)
	If INCLUI .And. dbSeek(xFilial("AIC")+M->AIC_FORNEC+M->AIC_LOJA+M->AIC_PRODUT+M->AIC_GRUPO)
		Help(" ",1,"JAGRAVADO")
		lRet := .F.
	Endif
	dbSetOrder(1)

	If lRet .And. ExistBlock("CM020VLD")
		lRetPE:= ExecBlock("CM020VLD",.F.,.F.,{nOpc})
		If ValType(lRetPE) == "L"
			lRet:= lRetPE
		EndIf
	EndIf

Return lRet


/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  � COMA020  � Autor � Aline Correa do Vale  � Data � 10.11.2003 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe: MaValToler(ExpC1,ExpC2,ExpC3,ExpN1,ExpN2,ExpN3,ExpN4,ExpL1,ExpL2)��
���������������������������������������������������������������������������Ĵ��
���Descri��o � ExpC1 = Codigo do Fornecedor                                 ���
���          � ExpC2 = Loja do Fornecedor                                   ���
���          � ExpC3 = Codigo do Produto                                    ���
���          � ExpN1 = Quantidade a entregar                                ���
���          � ExpN2 = Quantidade Original do Pedido                        ���
���          � ExpN3 = Preco a receber                                      ���
���          � ExpN4 = Preco Original do Pedido                             ���
���          � ExpL1 = Exibir Help                                          ���
���          � ExpL2 = Indica se verifica Quantidade                        ���
���          � ExpL3 = Indica se verifica Pre�o                             ���
���          � ExpL4 = Indica se verifica Data                              ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Function MaAvalToler(cFornece,cLoja,cProduto, nQtde, nQtdeOri, nPreco, nPrecoOri, lHelp, lQtde, lPreco, lData, lPedido )

	Local aArea		:= GetArea()
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSAK	:= {}
	Local aAreaSAL	:= {}
	Local dDatPrf	:= SC7->C7_DATPRF
	Local cAliasAIC := "AIC"         
	Local cGrupo	:= ""
	Local cGrupoPE	:= ""
	Local lAchou    := .F.
	Local lBloqueio := .F.
	Local lBLQTolNeg:= .F. 				
	Local nPQtde    := 0
	Local nPPreco   := 0
	Local nDiaTol	:= 0
	Local cTolent	:= GetMV("MV_TOLENT" , .F.,"") 
	Local lTolerNeg := GetMV("MV_TOLENEG",.F.,.F.)
	Local lCMA20Blq := .F.

	DEFAULT cFornece := ""
	DEFAULT cLoja    := ""
	DEFAULT cProduto := ""
	DEFAULT nQtde    := 0
	DEFAULT nQtdeOri := 0
	DEFAULT nPreco   := 0
	DEFAULT nPrecoOri:= 0
	DEFAULT lHelp		:= .F.
	DEFAULT lQtde		:= .T.
	DEFAULT lPreco	:= .T.
	DEFAULT lData 	:= .T.
	DEFAULT lPedido	:= .T.

	If cPaisLoc $ "ARG|BOL|COS"
		If lPedido
			If SC7->C7_MOEDA==1 .And. nMoedaNF<>1
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA1  
			ElseIf SC7->C7_MOEDA==2 .And. nMoedaNF<>2
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA2  
			ElseIf SC7->C7_MOEDA==3 .And. nMoedaNF<>3
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA3  
			ElseIf SC7->C7_MOEDA==4 .And. nMoedaNF<>4
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA4  
			ElseIf SC7->C7_MOEDA==5 .And. nMoedaNF<>5
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA5  
			EndIf
		Else
			If SF1->F1_MOEDA==1 .And. nMoedaNF<>1
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA1  
			ElseIf SF1->F1_MOEDA==2 .And. nMoedaNF<>2
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA2 
			ElseIf SF1->F1_MOEDA==3 .And. nMoedaNF<>3
				nPrecoOri:= nPrecoOri*SM2->M2_MOEDA3
			EndIf
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Verifica o grupo de tributacao do cliente/fornecedor         �
	//����������������������������������������������������������������
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+cFornece+cLoja)
	//��������������������������������������������������������������Ŀ
	//� Verifica o grupo do produto                                  �
	//����������������������������������������������������������������
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+cProduto)
	cGrpPrd := SB1->B1_GRUPO
	//��������������������������������������������������������������Ŀ
	//� Pesquisa por todas as regras validas para este caso          �
	//����������������������������������������������������������������
	dbSelectArea("AIC")
	dbSetOrder(2)
	lAchou := .F.
	If !Empty(cFornece+cLoja)
		If !Empty(cProduto)
			If !MsSeek(xFilial("AIC")+cFornece+cLoja+cProduto)
				lAchou := MsSeek(xFilial("AIC")+cFornece+Space(Len(cLoja))+cProduto)
			Else
				lAchou := .T.
			EndIf
		ElseIf !Empty(cGrpPrd)
			If !MsSeek(xFilial("AIC")+cFornece+cLoja+Space(Len(cProduto))+cGrpPrd)
				lAchou := MsSeek(xFilial("AIC")+cFornece+Space(Len(cLoja+cProduto))+cGrpPrd)
			Else
				lAchou := .T.
			EndIf
		Else
			If !MsSeek(xFilial("AIC")+cFornece+cLoja)
				lAchou := MsSeek(xFilial("AIC")+cFornece)
			Else
				lAchou := .T.
			EndIf
		EndIf
	EndIf
	If !lAchou .And. !Empty(cProduto)
		lAchou := MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja))+cProduto)
	EndIf
	If !lAchou .and. !Empty(cGrpPrd)
		If !MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja+cProduto))+cGrpPrd)
			If !MsSeek(xFilial("AIC")+cFornece+Space(Len(cLoja+cProduto))+cGrpPrd)
				If !MsSeek(xFilial("AIC")+cFornece+cLoja+Space(Len(cProduto))+cGrpPrd)
					If !MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja+cProduto))+cGrpPrd)
						lAchou := MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja+cProduto+cGrpPrd)))
					Else
						lAchou := .T.
					EndIf
				Else
					lAchou := .T.
				EndIf
			Else
				lAchou := .T.
			EndIf                        
		Else
			lAchou := .T.
		EndIf
	Endif
	If !lAchou
		lAchou := MsSeek(xFilial("AIC")+cFornece+cLoja+Space(Len(cProduto))+Space(Len(cGrpPrd)))
	EndIf

	If !lAchou 
		lAchou := MsSeek(xFilial("AIC")+Space(Len(cFornece+cLoja))+Space(Len(cProduto))+Space(Len(cGrpPrd)))
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Pesquisa por todas as regras validas para este caso          �
	//����������������������������������������������������������������
	If !(cAliasAIC)->(Eof()) .And. lAchou
		nPPreco := (cAliasAIC)->AIC_PPRECO
		nPQtde  := (cAliasAIC)->AIC_PQTDE
	EndIf
	//������������������������������������������������������������������Ŀ
	//� Se o parametro MV_TOLENEG estiver .T. o percentual de tolerancia �
	//� do preco e da quantidade passam a validar tambem os valores da   |
	//� NFE que estiverem a menor que o PC aplicando o bloqueio quando os�
	//� valores ultrapassarem o percentual estabelecido da qtd e do Preco|
	//��������������������������������������������������������������������
	If lAchou
		If (nQtde+nQtdeOri) > 0 .Or. (nPreco+nPrecoOri) > 0		
			If lTolerNeg
				If lQtde 
					If ABS(((nQtde / nQtdeOri) -1) * 100) > nPQtde
						lBLQTolNeg := .T. 				
					EndIf
				Endif
				If lPreco
					If ABS(((nPreco / nPrecoOri) -1)*100) > nPPreco
						lBLQTolNeg := .T. 				
					EndIf				
				Endif
			EndIf		
		EndIf
	EndIf

	If lQtde
		If lAchou .And. (nQtde+nQtdeOri) > 0
			If (((nQtde / nQtdeOri) -1)*100) > nPQtde .Or. lBLQTolNeg
				If lHelp
					Help(" ",1,"QTDLIBMAI")
				EndIf
				lBloqueio := .T.
			EndIf
		EndIf
	EndIf                 

	If !lBloqueio .and. lPreco
		If lAchou .And. (nPreco+nPrecoOri) > 0
			If (((nPreco / nPrecoOri) -1)*100) > nPPreco .Or. lBLQTolNeg
				If lHelp
					Help(" ",1,"PRCLIBMAI")
				EndIf
				lBloqueio := .T.
			EndIf
		EndIf
	Endif   

 	If !lBloqueio .And. lData
		nDiaTol := (cAliasAIC)->AIC_TOLENT
		If lAchou .And. nDiaTol > 0//Quando nDiaTol == 0 n�o avalia regra de prazo - Conceito da rotina at� que o PO decida o contr�rio    
			Do Case
				Case cTolent == "1" .and. (dDatPrf + nDiaTol) < dDataBase
				lBloqueio := .T.
				Case cTolent == "2" .and. (dDatPrf - nDiaTol) > dDataBase
				lBloqueio := .T.
				Case cTolent == "3" .and. ((dDatPrf + nDiaTol) < dDataBase .or. (dDatPrf - nDiaTol) > dDataBase)
				lBloqueio := .T.
			EndCase
		Endif         
		If lHelp .and. lBloqueio
			Help(" ",1,"DATLIBMAI")
		Endif
	Endif

	//����������������������������������������������������������Ŀ
	//� Ponto de entrada para regra de Bloqueio do Usuario       �
	//������������������������������������������������������������
	If lAchou .And. ExistBlock("CMA20BLQ")
		lCMA20Blq := ExecBlock("CMA20BLQ",.F.,.F.,{lBloqueio})
		If Valtype( lCMA20Blq ) == "L"
			lBloqueio := lCMA20Blq
		EndIf
	EndIf

	If lBloqueio
		cGrupo := SuperGetMv("MV_NFAPROV")
		If IsInCallStack('MATA140')
			If ExistBlock("MT140APV")
				cGrupoPE := ExecBlock("MT140APV",.F.,.F.,{cGrupo})
			EndIf
		ElseIf IsInCallStack('MATA103')
			If ExistBlock("MT103APV")
				cGrupoPE := ExecBlock("MT103APV",.F.,.F.)
			EndIf
		EndIf	

		If ValType(cGrupoPE) == "C" .And. !Empty(cGrupoPE)
			cGrupo := cGrupoPE
		EndIf

		cGrupo:= If(Empty(SF1->F1_APROV),cGrupo,SF1->F1_APROV)

		//Valida��o do cadastro do grupo de aprova��o
		aAreaSAK:=SAK->(GetArea())
		aAreaSAL:=SAL->(GetArea())

		SAL->(dbSetOrder(1))
		SAK->(dbSetOrder(1))

		If !Empty(cGrupo)
			lBloqueio := SAL->(dbSeek(xFilial("SAL")+cGrupo)) .And. ;
			SAK->(dbSeek(xFilial("SAK")+SAL->AL_APROV)) 
		EndIf
		RestArea(aAreaSAK)
		RestArea(aAreaSAL)
	EndIf

	RestArea(aAreaSA2)
	RestArea(aAreaSB1)
	RestArea(aArea)
Return({lBloqueio,nPQtde, nPPreco})


/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ricardo Berti         � Data �31/01/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �	  1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

	PRIVATE aRotina	:= {}

	aAdd(aRotina,{STR0002,"AxPesqui"	, 0, 1, 0, .F.}) //"Pesquisar"
	aAdd(aRotina,{STR0003,"AxVisual"	, 0, 2, 0, nil}) //"Visualizar"
	aAdd(aRotina,{STR0004,"CM020Inclui"	, 0, 3, 0, nil}) //"Incluir"
	aAdd(aRotina,{STR0005,"CM020Altera"	, 0, 4, 0, nil}) //"Alterar"
	aAdd(aRotina,{STR0006,"CM020Exclui"	, 0, 5, 0, nil}) //"Excluir"

	//������������������������������������������������������������������������Ŀ
	//� Ponto de entrada utilizado para inserir novas opcoes no array aRotina  �
	//��������������������������������������������������������������������������
	If ExistBlock("CMA020MNU")
		ExecBlock("CMA020MNU",.F.,.F.)
	EndIf
Return(aRotina)
