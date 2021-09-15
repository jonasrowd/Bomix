#Include 'Totvs.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} BXRTDP
	Cadastro de Item/Molde 
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@Return Logical, Retorna se segue ou não.
/*/
User Function BXRTDP()

	Local aSavARot := If(Type('aRotina')	!='U'	,aRotina	,{})
	Local cSavcCad := If(Type('cCadastro')	!='U' 	,cCadastro	,'')
	Private aBotao 		:= {}
	Private aHdMolde 	:= {}  											//ACOLS MOLDES
	Private aItMolde 	:= {}  											//ACOLS MOLDES
	Private l415Auto  	:= .F.
	Private nTipo     	:= 1
	Private nUsado		:= 0
	Private nPosVaria	:= 0
	Private nPosMinimo	:= 0
	Private nPosMaximo	:= 0
	Private nPosEspecIf := 0
	Private cCadastro 	:= OemToAnsi('Item/Molde - Produto Bomix')

	AADD(aBotao ,{'POSCLI',{||U_F_ITENS()},'Importar Itens'})

	Private aRotina := {;
	{ OemToAnsi('Pesquisar')	,'AxPesqui',0,1},; 		//'Pesquisar'
	{ OemToAnsi('Visualizar')	,'U_BRTDPVISUA',0,2},;	//'Visualisar'
	{ OemToAnsi('Incluir')		,'U_BRTDPINCLU',0,3},;	//'Incluir'
	{ OemToAnsi('Alterar')		,'U_BRTDPVISUA',0,4},;	//'Alterar'
	{ OemToAnsi('Exclusao')		,'U_BRTDPVISUA',0,5}};	//'Exclusao'

	MBROWSE( 6, 1,22,75,"SZT",,,,,,) //MBROWSER DA TELA INICIAL

	aRotina   := aSavARot	//Restaura os dados de entrada
	cCadastro := cSavcCad	//Restaura os dados de entrada

Return(.T.)

/*/{Protheus.doc} BRTDPINCLU
	Função de incluir
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@param cAlias, character, Documentar depois
	@param nReg, numeric, Documentar depois
	@param nOpcx, numeric, Documentar depois
	@Return variant, Documentar depois
/*/
User Function BRTDPINCLU(cAlias,nReg,nOpcx)

	Local oDlg
	Local nCntFor    := 0
	Local nOpcA      := 0
	Local cOldFilter := ""
	Local aObjects   := {}
	Local aSize      := {}
	Local aTitles    := {}
	Local aPosObj    := {}
	Local aArea      := GetArea()
	Local cCadastro  := OemToAnsi("Cadastro de Item/Molde")
	Private oBMP
	Private oFolder
	Private oMGDMolde
	Private aGETS[0] 												// e utilizadas pela função OBRIGATORIO()
	Private aTELA[0][0] 											// Variáveis que serão atualizadas pela Enchoice()
	Private aFLDF	 	:= {}
	Private aCpoMolde  	:= {}
	Private aItLimpo 	:= {}
	Private dLibDad		:= dDataBase
	Private dLibLay		:= dDataBase
	Private dLibOrct	:= dDataBase
	Private dLibOrc		:= dDataBase
	Private xNUsrDad 	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
	Private xNUsrLay 	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
	Private xNUsrOrct	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
	Private xNUsrOrc 	:= Substr(cUsuario,7,15) //aUsr[1][1][2]

	nUsado:=0
	cOldFilter := SZN->(DbFilter())
	SZN->(DbClearFilter())			//Limpa algum filtro do SZN

	DbSelectArea("SZT")
	DbSetOrder(1)

	For nCntFor := 1 To FCount()								//Montagem da Variaveis de Memoria
		M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
	Next nCntFor

	DbSelectArea("SZT")
	DbSetOrder(1)

	aSize    := MsAdvSize() //Faz a tela dos combo
	aObjects := {}
	AAdd( aObjects, {  60, 100, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )

	nFolder := 0
	nFimCad := aSize[ 4 ] - 110
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], nFimCad, 3, 3 }
	aPosObj := MsObjSize(aInfo,aObjects)

	aAdd( aTitles,OemToAnsi('Itens/Moldes'))

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
		EnChoice(cAlias,nReg,nOpcx,,,,,aPosObj[1],,1)
		
		oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,{''},oDlg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1]+110)
		aFldF   := oFolder:aDialogs
		
		aEval(aFldF,{|x| x:SetFont(oDlg:oFont)})
		
		oScr		:= TScrollBox():New(aFldF[1],0,0,aPosObj[2,3]+10,aPosObj[2,4]-5,.T.,.T.,.T.) // cria controles dentro do scrollbox
		aCpoMolde	:={'ZN_ORDEM','ZN_CODMED','ZN_ESPECIF','ZN_VARIA','ZN_MINIMO','ZN_MAXIMO'} //aqui são os campos que você poderá alterar, logo deve adicioná-los aqui
		
		CCISZN()
		
		aItLimpo 	:= aClone(aItMolde)
		oMGDMolde	:= MsNewGetDados():New(0,0,aPosObj[2,3]-100,aPosObj[2,4]-5,GD_INSERT+GD_DELETE+GD_UPDATE,,,"+ZN_SEQ+ZN_ORDEM",; //Pasta de Itens/Moldes
		aCpoMolde,,999,,,,aFldF[1],aHdMolde,aItMolde)	

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca :=1,IIF(U_BRTDPVALIDI(aGets,aTela),oDlg:End(),.F.)},{||nOpca :=2,oDlg:End()},,aBotao)

	If ( nOpcA == 1 )
		RollBackSX8()
		U_GRV_BRTDPCA(1)
		U_GRV_ITENS(1)
		U_INCGRPPROD()
	ElseIf ( nOpcA == 2 )
		RollBackSX8()
	EndIf

	U_LpLicVar() //Limpa as variaveis

	MsUnLockAll()

	If !Empty( cOldFilter )			//Retorna o filtro original
		DbSelectArea( cAlias )
		Set Filter To &cOldFilter
	EndIf

	RestArea(aArea)

Return(.T.)

/*/{Protheus.doc} BRTDPVISUA
	Função para visualizar, alterar e excluir itens.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@param cAlias, character, Descrever quando descobrir
	@param nReg, numeric, Descrever quando descobrir
	@param nOpcx, numeric, Descrever quando descobrir
	@Return variant, Descrever quando descobrir
/*/
User Function BRTDPVISUA(cAlias,nReg,nOpcx)

	Local oDlg
	Local nOpcA      := 0
	Local nCntFor    := 0
	Local cOldFilter := ""
	Local aPosObj    := {}
	Local aObjects   := {}
	Local aSize      := {}
	Local aTitles    := {}
	Local aArea      := GetArea()
	Local cCadastro  := OemToAnsi("Cadastro de Item/Molde")
	Private _nOpcx
	Private oFolder
	Private xOpcoes
	Private oMGDMolde
	Private aFLDF		:= {}
	Private aItLimpo	:= {}
	Private aCpoMolde	:= {}
	Private aGETS[0] 	// e utilizadas pela função OBRIGATORIO()
	Private aTELA[0][0] // Variáveis que serão atualizadas pela Enchoice()

	If (nOpcx == 4 )
		xOpcoes:= GD_INSERT+GD_DELETE+GD_UPDATE //NÃO ENTENDI PQ RECEBEU 7
		_nOpcx := nOpcx
		nOpcx := 4
	Else
		xOpcoes:= 0
	EndIf

	cOldFilter := SZN->( DbFilter() )
	SZN->( DbClearFilter() )			//Limpa algum filtro do SZN

	DbSelectArea("SZT")
	DbSetOrder(1)

	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
	Next nCntFor

	U_LicAtuVar(nOpcx)

	If  nOpcx = 5
		MsgBox(OemtoAnsi("Item/Molde não pode ser excluída!"))
	Else
		
		aSize	 := MsAdvSize()
		aObjects := {}
		
		AAdd( aObjects, {  60, 100, .T., .T. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		nFimCad := aSize[ 4 ] - 110
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], nFimCad, 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )

		nFolder := 0

		aAdd( aTitles,OemtoAnsi("Itens/Moldes"))

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

			EnChoice( cAlias ,nReg, nOpcx, , , , , aPosObj[1], , 3 )
			oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,{""},oDlg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1]+110)

			aFldF   := oFolder:aDialogs
			aEval(aFldF,{|x| x:SetFont(oDlg:oFont)})
			/*
			ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
			±±ºPasta de Itens/Moldes												  º±±
			±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
			ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			*/
			oScr    := TScrollBox():New(aFldF[1],0,0,aPosObj[2,3]+10,aPosObj[2,4]-5,.T.,.T.,.T.) // cria controles dentro do scrollbox

			aCpoMolde :={"ZN_ORDEM","ZN_CODMED","ZN_ESPECIF","ZN_VARIA","ZN_MINIMO","ZN_MAXIMO"}

			CCISZN()

			aItLimpo := aClone(aItMolde)

			CIMSZN()

			oMGDMOLDE  	:= MsNewGetDados():New(0,0,aPosObj[2,3]-100,aPosObj[2,4]-5,xOpcoes,,,"+ZN_SEQ+ZN_ORDEM",;	//Pasta de Itens/Moldes
			aCpoMolde,,999,,,,aFldF[1],aHdMolde,aItMolde)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca :=1,IIF(U_BRTDPVALIDI(aGets,aTela),oDlg:End(),.F.)},{||nOpca :=2,oDlg:End()},,aBotao)

		If ( nOpca == 1 )
			Begin Transaction
			Do Case
				Case nOpcx = 5			// Exclusão

					xChave := M->ZT_GROUPOMS

					DbSelectArea("SZT")
					RecLock("SZT",.F.)
						SZT->(DbDelete())
					MsUnLock()

					DbSelectArea("SZN")
					SZN->(DbSetOrder(2))
					If SZN->(DbSeek(xFilial("SZN")+xChave))
						RecLock("SZN",.F.)
							ZZ4->(DbDelete())
						MsUnLock()
					EndIf

				Case nOpcx = 4			//ALTERACAO
					U_GRV_BRTDPCA(2)
					U_GRV_ITENS(2)
			EndCase

			EvalTrigger()
			End Transaction
		Else
			RollBackSX8()
		EndIf

		U_LpLicVar() // Limpa as variaveis

		MsUnLockAll()

	EndIf

	If !Empty( cOldFilter )		//Retorna o filtro original
		DbSelectArea( cAlias )
		Set Filter To &cOldFilter
	EndIf

	RestArea(aArea)

Return(.T.)

/*/{Protheus.doc} CCISZN
	Tabela de Moldes - Itens (HEADER)
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@Return Logical, Documentar direito
/*/
Static Function CCISZN()

	Local nUsado:=	0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZN")
	While !Eof() .And. (x3_arquivo == "SZN")	//Monta o aHeader
		If AllTrim(X3_CAMPO) $ "ZN_SEQ/ZN_ORDEM/ZN_CODMED/ZN_MEDIDA/ZN_UNIDADE/ZN_ESPECIF/ZN_VARIA/ZN_MINIMO/ZN_MAXIMO"
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel
				nUsado ++
				AADD(aHdMolde,{TRIM(x3_titulo),AllTrim(X3_CAMPO),;
				x3_picture,x3_tamanho, x3_decimal,,x3_usado, x3_tipo,,x3_context})
		EndIf
		EndIf
		dbSkip()
	EndDo

	AADD(aHdMolde,{"Recno","RECNO","@E 9999999999",10,0    ,"€€€€€€€€€€€€€€ ",  ,"N",,'R'})
	nUsado ++

	nPosEspecIf	:= aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ESPECIF"})
	nPosVaria	:= aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_VARIA"})
	nPosMinimo	:= aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MINIMO"})
	nPosMaximo	:= aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MAXIMO"})

	aHdMolde[nPosVaria][6]		:= "EXECBLOCK('f_1BXGTVMM')"
	aHdMolde[nPosEspecIf][6]	:= "EXECBLOCK('f_2BXGTVMM')"

	aItMolde := Array(1,nUsado + 1)

	n_cont := 1

	While n_cont <= Len(aHdMolde)
		Do Case
			Case aHdMolde[n_cont, 8] == "C"
				aItMolde[1][n_cont] := SPACE(aHdMolde[n_cont, 4])
			Case aHdMolde[n_cont, 8] == "N"
				aItMolde[1][n_cont] := 0
			Case aHdMolde[n_cont, 8] == "D"
				aItMolde[1][n_cont] := dDataBase
			Case aHdMolde[n_cont, 8] == "M"
				aItMolde[1][n_cont] := ""
			Otherwise
				aItMolde[1][n_cont] := .F.
		EndCase
		n_cont ++
	EndDo

	aItMolde[1][aScan(aHdMolde,{|x| AllTrim(x[2]) == "RECNO"})]		:=  0
	aItMolde[1][aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"})]  	:= "001"
	aItMolde[1][aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ORDEM"})] 	:= "01"
	aItMolde[1][Len(aItMolde[1])] := .F.

Return()

/*/{Protheus.doc} CIMSZN
	Tabela de Moldes (Itens)
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@return Logical, Documentar direito
/*/
Static Function CIMSZN()

	Local n_cont    := 1
	Local nUsado    := Len(aHdMolde)
	Local c_Chave   := AllTrim(M->ZT_GRUPOMS)

	DbSelectArea("SZN")
	DbSetOrder(2)
	DbSeek(xFilial("SZN")+c_Chave)

	While !SZN->(EOF()) .AND. c_Chave == AllTrim(SZN->ZN_GRUPO)

		If n_cont > 1
			aadd(aItMolde, Array(nUsado + 1))
		EndIf

		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"		})]	:= SZN->ZN_SEQ
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ORDEM"		})]	:= SZN->ZN_ORDEM
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"	})]	:= SZN->ZN_CODMED
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MEDIDA"	})]	:= SZN->ZN_MEDIDA
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_UNIDADE"	})]	:= SZN->ZN_UNIDADE
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ESPECIF"	})]	:= SZN->ZN_ESPECIF
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_VARIA"		})]	:= SZN->ZN_VARIA
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MINIMO"	})]	:= SZN->ZN_MINIMO
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MAXIMO"	})]	:= SZN->ZN_MAXIMO
		aItMolde[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "RECNO"		})]	:= SZN->(RECNO())

		If n_cont > 1
			aItMolde[Len(aItMolde), nUsado + 1] := .F.
		EndIf
		n_cont ++

		SZN->( dbSkip() )
	EndDo

Return()

/*/{Protheus.doc} GRV_ITENS
	GRAVAR ITENS
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@param xTipo, variant, Documentar corretamente
	@return variant, Documentar corretamente
/*/
User Function GRV_ITENS(xTipo)

	Local c_Cod 	:= ""
	Local nX	  	:= 0
	Local l_Deletar	:= .F.

	For nX:=1 to Len(oMGDMOLDE:aCols)
		c_Cod    := M->ZT_GRUPOMS
		l_Deletar:= oMGDMOLDE:aCols[nX,Len(oMGDMOLDE:aCols[nX])]
		c_CodMed := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})]

		DbSelectArea("SZN")
		DbSetOrder(3)
		DBGoTop()
		DbSeek(xFilial("SZN")+c_Cod+space(6)+c_CodMed)
		If SZN->(EOF())
			If!(Empty(AllTrim(c_CodMed)))  .and. !l_Deletar
				Begin Transaction
					DbSelectArea("SZN")
					Reclock("SZN",.T.)
						SZN->ZN_FILIAL  := xFilial("SZN")
						SZN->ZN_GRUPO   := M->ZT_GRUPOMS
						SZN->ZN_ITEM    := M->ZT_DESCMS
						SZN->ZN_GRUPOFK := 1
						SZN->ZN_GRUPOBX := M->ZT_GRUPOBX
						SZN->ZN_SEQ     := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"})]
						SZN->ZN_ORDEM   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ORDEM"})]
						SZN->ZN_CODMED  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})]
						SZN->ZN_MEDIDA  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MEDIDA"})]
						SZN->ZN_TIPO    := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})],"ZO_TIPO")
						SZN->ZN_UNIDADE := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE") //oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_UNIDADE"})]
						SZN->ZN_ESPECIF := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ESPECIF"})]
						SZN->ZN_VARIA   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_VARIA"})]
						SZN->ZN_MINIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MINIMO"})]
						SZN->ZN_MAXIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MAXIMO"})]
					MsUnLock()
				End Transaction
				Loop
			Else
				Loop
			EndIf
		Else
			If l_Deletar
				RecLock("SZN",.F.)
					SZN->(DbDelete())
				MsUnLock()
				Loop
			Else
				If !(Empty(AllTrim(c_CodMed)))
					l_Email  := .F.

					Begin Transaction
					Reclock("SZN",.F.)
						SZN->ZN_FILIAL  := xFilial("SZN")
						SZN->ZN_GRUPO   := M->ZT_GRUPOMS
						SZN->ZN_ITEM    := M->ZT_DESCMS
						SZN->ZN_GRUPOFK := 1
						SZN->ZN_GRUPOBX := M->ZT_GRUPOBX
						SZN->ZN_SEQ     := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"})]
						SZN->ZN_ORDEM   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ORDEM"})]
						SZN->ZN_CODMED  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})]
						SZN->ZN_MEDIDA  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MEDIDA"})]
						SZN->ZN_TIPO    := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})],"ZO_TIPO")
						SZN->ZN_UNIDADE := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE")

						If SZN->ZN_ESPECIF <> oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ESPECIF"})]
							a_Area   := GetArea()
							c_Email  := ""
							c_Titulo := ""
							c_Corpo  := ""

							DBSELECTAREA("SZO")
							SZO->(DBSETORDER(1))
							SZO->(DBSEEK(XFILIAL("SZO") + SZN->ZN_CODMED))
							If SZO->ZO_NOTIfIC == "S"
								c_Email  := AllTrim(SZO->ZO_EMAIL)
								l_Email  := .T.
								c_Titulo := "Notificação de alteração do grupo de produto " + AllTrim(SZN->ZN_GRUPO) + " - " + AllTrim(SZN->ZN_ITEM)
								c_Corpo  := c_Titulo + chr(13) + chr(10) + AllTrim(SZO->ZO_DESC) + " alterado(a) de " + AllTrim(SZN->ZN_ESPECIF) + " para " + ;
											AllTrim(oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ESPECIF"})]) + " pelo usuário(a) " + UsrRetName(__CUSERID)
							EndIf
							RestArea(a_Area)
						EndIf
						SZN->ZN_ESPECIF := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ESPECIF"})]
						SZN->ZN_VARIA   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_VARIA"})]
						SZN->ZN_MINIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MINIMO"})]
						SZN->ZN_MAXIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MAXIMO"})]
				MsUnLock()
				End Transaction

				If l_Email
					U_TBSEndMAIL(c_Email, c_Corpo, c_Titulo, .T.)
				EndIf
			EndIf
				Loop
			EndIf
		EndIf
	Next

	SZN->(DBCloseArea())

Return()

/*/{Protheus.doc} LpLicVar
	Limpar variáveis
	@type Function
	@version 12.1.25
	@author jonas.machado
	@since 04/08/2021
	@return variant, Documentar direito
/*/
User Function LpLicVar()

	cStatus 	:= ''
	nTipo     	:= 1
	nUsado		:= 0
	nPosVaria	:= 0
	nPosMinimo	:= 0
	nPosMaximo	:= 0
	nPosEspecIf := 0
	aHdMolde 	:= {}
	aItMolde 	:= {}

Return()

/*/{Protheus.doc} LicAtuVar
	Carrega Moldes
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@param nOpcx, numeric, Documentar corretamente depois
	@return variant, Documentar corretamente depois
/*/
User Function LicAtuVar(nOpcx)

	Begin Transaction
		DbSelectArea("SZT")
		SZT->( DbSetOrder(1) )

		DbSelectArea("SZN")
		SZN->( DbSetOrder(1) )
		M->ZT_FILIAL  := SZT->ZT_FILIAL
		M->ZT_GRUPOBX := SZT->ZT_GRUPOBX
		M->ZT_DESCBX  := SZT->ZT_DESCBX
		M->ZT_GRUPOMS := SZT->ZT_GRUPOMS
		M->ZT_DESCMS  := SZT->ZT_DESCMS

	End Transaction

Return()

/*/{Protheus.doc} BRTDPVALIDI
	Verificar o qe isso faz
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@return variant, Documentar corretamente
/*/
User Function BRTDPVALIDI()
	
	Local lRet := .F.

	If Obrigatorio(aGets,aTela)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

Return lRet

/*/{Protheus.doc} GRV_BRTDPCA
	GRAVAR CÓDIGO DO PRODUTO BOMIX VRS GRUPO PROTHEUS
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@param xTipo, variant, Documentar corretamente
	@return variant, Documentar corretamente
/*/	
User Function GRV_BRTDPCA(xTipo)

	Begin Transaction

	If xTipo == 1				// Grava
		DbSelectArea("SZT")
		Reclock("SZT",.T.)
			SZT->ZT_FILIAL  := xFilial("SZT")
			SZT->ZT_GRUPOMS := M->ZT_GRUPOMS
			SZT->ZT_DESCMS  := M->ZT_DESCMS
		confirmsx8("SZT")
	Else						// Atualiza
		DbSelectArea("SZT")
		Reclock("SZT",.F.)
	EndIf
		SZT->ZT_GRUPOBX := M->ZT_GRUPOBX
		SZT->ZT_DESCBX  := M->ZT_DESCBX
		MsUnLock()
	End Transaction

Return()

/*/{Protheus.doc} f_Itens
	CARREGAR OS DADOS DAS MEDIDAS(SZO) PARA TELA DE ESPECIfICAÇÕES
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@return variant, Documentar corretamente
/*/						
User Function f_Itens()

	Local c_Formato     := ""
	Local cQry 		    := ""
	Local _ArqSZO 	    := ""
	Local c_TipoProduto := ""
	Local c_Tamanho     := ""
	Local n_Seq 		:= 0
	Local n_Ordem		:= 0
	Local k				:= 1
	Local c_Ret			:= M->ZT_GRUPOBX
	Local n_cont 	    := IIF(Len(oMGDMOLDE:aCols)>1,Len(oMGDMOLDE:aCols)+1,1)

	If !MSGYESNO("Deseja realmente carregar os Itens/EspecIficações do Grupo Produto (Bomix) "+AllTrim(M->ZT_GRUPOBX) + " - " + AllTrim(M->ZT_DESCBX) + " ?")
		c_Ret := M->ZT_GRUPOBX
	EndIf

	If n_cont > 1
	EndIf

	_ArqSZO := RetSqlName("SZO")
	DbselectArea("SZL")
	DbSetOrder(4)

	If DbSeek(xFilial("SZL")+M->ZT_GRUPOBX)

		c_TipoProduto := trim(SZL->ZL_TIPO)
		c_Tamanho     := trim(SZL->ZL_TAMANHO)
		c_Formato     := trim(SZL->ZL_FORMATO)

		cQry := " SELECT ZO_COD, ZO_DESC "
		cQry += " FROM "+_ArqSZO+" "
		cQry += " WHERE  "
		cQry += " ZO_FILIAL ='"+xFilial("SZO")+"' "
		cQry += " AND D_E_L_E_T_ <> '*' "
		cQry += " AND ZO_TPPROD LIKE ('%"+c_TipoProduto+"%') "
		cQry += " AND ZO_TAMANHO LIKE ('%"+c_Tamanho+"%')"
		cQry += " AND ZO_FORMATO LIKE ('%"+c_Formato+"%') "
		cQry += " ORDER BY ZO_TIPO, ZO_DESC "

		TCQUERY cQry New Alias 'QRY'

		DBSelectArea('QRY')
		DBGoTop()

		If QRY->(!EOF())
			While !EOF() .and. !Empty(trim(QRY->ZO_COD))
				n_Seq ++
				n_Ordem ++
				l_ExistCod := .F.

				For k:=1 To Len(oMGDMOLDE:aCols)
					If (oMGDMOLDE:aCols[k, Len(aHdMolde) + 1] == .F.) .AND. (oMGDMOLDE:aCols[k, aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})] == QRY->ZO_COD)
						l_ExistCod := .T.
						EXIT
					EndIf
				Next

				If l_ExistCod == .F.
					If n_cont > 1
						n_Seq   := Val(oMGDMOLDE:aCols[n_cont-1,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"})]) + 1
						n_Ordem := n_Seq

						If (oMGDMOLDE:AddLine (.F.))
							oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"})]      := STRZERO(n_Seq,3)
							oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ORDEM"})]    := STRZERO(n_Ordem,2)
							oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})]   := QRY->ZO_COD
							oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MEDIDA"})]   := QRY->ZO_DESC
							oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_UNIDADE"})]  := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE")
							oMGDMOLDE:aCols[n_cont,Len(oMGDMOLDE:aCols[n_cont])]  	:= .F.
							oMGDMOLDE:Refresh()
						EndIf
					Else
						oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_SEQ"})]      := STRZERO(n_Seq,3)
						oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_ORDEM"})]    := STRZERO(n_Ordem,2)
						oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})]   := QRY->ZO_COD
						oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_MEDIDA"})]   := QRY->ZO_DESC
						oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_UNIDADE"})]  := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| AllTrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE")
						oMGDMOLDE:aCols[n_cont,Len(oMGDMOLDE:aCols[n_cont])]  	:= .F.
						oMGDMOLDE:Refresh()
					EndIf
					n_cont ++
				EndIf
				QRY->(dbSkip())
			EndDo
		Else
			MsgBox(OemtoAnsi("Nenhum item encontrado!!!"))
		EndIf

	EndIf

	If n_Cont > 1
		If (oMGDMOLDE:AddLine (.F.))
			oMGDMOLDE:Refresh()
		EndIf
	EndIf

	QRY->(DBCloseArea())
	oFolder:SetOption(1)
Return(c_Ret)

/*/{Protheus.doc} IncGrpProd
	GRAVAR GRUPO DE PRODUTO PROTHEUS VIA MSEXECAUTO	035
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 04/08/2021
	@return variant, Documentar corretamente
/*/
User Function IncGrpProd()

	Local nOpc			:= 3	//Inclusao
	Local aGrpProd		:= {}
	Local lOK			:= .T.
	Private lMsHelpAuto := .T.	//Se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F.	//Necessário a criação, pois será atualizado quando houver

	Begin Transaction
		aGrpProd:= {{'BM_FILIAL'	,xFilial("SBM"),Nil},;
					{'BM_GRUPO'		,M->ZT_GRUPOMS ,Nil},;
					{'BM_DESC'		,M->ZT_DESCMS  ,Nil},;
					{'BM_GRUPOBX'	,M->ZT_GRUPOBX ,Nil}}

		MSExecAuto({|x,y| mata035(x,y)},aGrpProd,nOpc)

		If lMsErroAuto
			DisarmTransaction()
			Break
		EndIf
	End Transaction

	If lMsErroAuto //Se estiver em uma aplicação normal e ocorrer alguma incosistência nos parâmetros passados, mostrar na tela o log informando qual coluna teve a incosistência.
		Mostraerro()
		lOK := .F.
	EndIf

Return(lOK)

/*/{Protheus.doc} f_1BXGTVMM
	GATILHO - VARIA DE VALOR MINIMO E MÁXIMO
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@return variant, Documentar corretamente
/*/
User Function f_1BXGTVMM()

	Local	l_Ret 	:= .T.
	Local   c_Varia := ""

	c_Varia := M->ZN_VARIA

	If !Empty(c_Varia) .AND. val(trim(c_Varia)) > 0
		oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosMinimo] := cValToChar(VAL(oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosEspecIf]) - VAL(c_Varia))
		oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosMaximo] := cValToChar(VAL(oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosEspecIf]) + VAL(c_Varia))
	EndIf

Return(l_Ret)

/*/{Protheus.doc} f_2BXGTVMM
	GATILHO DE VALOR MINIMO E MÁXIMO
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/08/2021
	@return variant, Documentar corretamente
/*/
User Function f_2BXGTVMM()

	Local	l_Ret := .T.
	Local   c_Varia := " "

	c_Varia:=  oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosVaria]

	If !Empty(c_Varia) .AND. val(trim(c_Varia)) > 0
		oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosMinimo] := cValToChar(VAL(M->ZN_ESPECIF) - VAL(c_Varia))
		oMGDMOLDE:acols[oMGDMOLDE:nAt,nPosMaximo] := cValToChar(VAL(M->ZN_ESPECIF) + VAL(c_Varia))
	EndIf

Return(l_Ret)
