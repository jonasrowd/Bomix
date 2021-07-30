#Include 'Totvs.ch'

/*/{Protheus.doc} BXMENATR
	Função responsável por trazer os títulos em aberto na tela de orçamento.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 21/07/2021
	@param xPar, variant, inclusão
	@param pCliente, variant, Código do cliente
	@param pLoja, variant, Loja do cliente
	@return variant, Logical
/*/
User Function BXMENATR(pCliente, pLoja)
		
	Local oBtnOK
	Local oBtnCancel
	Local cBx			:= 'B'
	Local lRet 			:= .F.
	Local xLinha 		:= 10
	Local nTotal 		:= 0
	Local cJust 		:= ""
	Public oDlg
		
	If FWCodFil() != "030101"
		If !( RetCodUsr() $ Supergetmv("BM_USERLIB",.F.,RetCodUsr(),) )
			Help(NIL, NIL, "USR_PERM", NIL, "Usuário " + PswChave(RetCodUsr()) + " sem permissão de liberação.", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o setor comercial."})
			Return .F.
		ElseIf SC5->C5_BXSTATU = 'L' .AND. SC5->C5_LIBEROK <> 'S'
			Help(NIL, NIL, "PED_LIB", NIL, "Pedido de venda já liberado anteriormente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o setor comercial."})
			Return .F.
		EndIf

		DBSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(FWxFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)

		While SC6->(!Eof()) .AND. SC5->C5_NUM == SC6->C6_NUM
			nTotal += SC6->C6_VALOR
			SC6->(DBSkip())
		End

		cMensagem := "Deseja Liberar o pedido: "+ SC5->C5_NUM + CRLF
		cMensagem += "Cliente: " + SA1->A1_NOME + CRLF
		cMensagem += "Valor R$" + Transform(nTotal,PesqPict("SC6","C6_VALOR")) + CRLF
		
		If ( U_FFATVATR(SC5->C5_CLIENTE,SC5->C5_LOJACLI) != 0 )
			cMensagem += " Este Cliente possui pendências financeiras com valor total somado: "+ Transform(nTotal,PesqPict("SC6","C6_VALOR"))
		EndIf

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Atenção") FROM 000,000 TO 180,650 PIXEL
		@ 010, 010 Say OemToAnsi(substr(cMensagem,1,at('#',cMensagem)-1)) PIXEL
		@ 020, 010 Say OemToAnsi(substr(cMensagem,at('#',cMensagem)+1,len(cMensagem))) PIXEL
		oBtnOK		:= TButton():New(060,010+xLinha,"Visualizar"		,oDlg,{||u_FFATG004(pCliente,pLoja)},50,20,,,,.T.,,"",,,,.F.)
		oBtnCancel	:= TButton():New(060,070+xLinha,"Liberar Expedição"	,oDlg,{||lRet	:=	.T.,cBx	  := libExped(cBx)	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
		oBtnLiberar	:= TButton():New(060,130+xLinha,"Liberar Venda"		,oDlg,{||lRet	:=	.T.,cBx	  := libVend(cBx)	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
		oBtnLiberar	:= TButton():New(060,190+xLinha,"Liberar Producao"	,oDlg,{||lRet	:=	.T.,cBx	  := libProd(cBx)	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
		oBtnCancel	:= TButton():New(060,250+xLinha,"Não Liberar"		,oDlg,{||lRet	:=	.F.,cJust := justLibC()		,oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
		ACTIVATE MSDIALOG oDlg CENTERED

		If lRet
			RecLock("SC5",.F.)
				SC5->C5_BXSTATU := cBx
				DbSelectArea("SC9")
				DBSEEK(SC5->C5_FILIAL+SC5->C5_NUM)
					RecLock("SC9",.F.)
						C9_BLCRED :=''
						If cBx = 'E'
							SC5->C5_BLQ 	:= ''
							SC5->C5_LIBEROK := 'L'
							SC5->C5_FSSTBI 	:= "EXPEDICAO"
						ElseIf cBx = 'L'
							SC5->C5_BLQ 	:= ''
							SC5->C5_LIBEROK := 'L'
							SC5->C5_FSSTBI 	:= "LIBERADO"
						ElseIf cBx = 'P'
							SC5->C5_BLQ 	:= 'B'
							SC5->C5_LIBEROK := 'B'
							SC5->C5_FSSTBI 	:= "PRODUCAO"
						EndIf
					MsUnlock()
				DBCloseArea()
			MsUnlock()

			DBSelectArea("Z07")
			RecLock("Z07",.T.)
				Z07->Z07_FILIAL := SC5->C5_FILIAL
				Z07->Z07_PEDIDO := SC5->C5_NUM
				If cBx = 'P'
					Z07->Z07_JUSTIF := "Liberado Produção Usuário: " + PswChave(RetCodUsr())
					Z07_USUAR		:= RetCodUsr()
				ElseIf cBx = 'E'
					Z07->Z07_JUSTIF := "Liberado Expedição Usuário: " + PswChave(RetCodUsr())
					Z07_USUAR		:= RetCodUsr()
				ElseIf cBx = 'L'
					Z07->Z07_JUSTIF := "Liberado Venda Usuário: " + PswChave(RetCodUsr())
					Z07_USUAR		:= RetCodUsr()
				EndIf
				Z07->Z07_DATA := dDataBase
				Z07->Z07_HORA := SUBSTRING(TIME(),1,5)
			MsUnlock()
		Else 
			RecLock("Z07",.T.)
				Z07->Z07_FILIAL := SC5->C5_FILIAL
				Z07->Z07_PEDIDO := SC5->C5_NUM
				Z07->Z07_JUSTIF := "Não Liberado Usuário: " + PswChave(RetCodUsr())
				Z07->Z07_DATA 	:= dDataBase
				Z07->Z07_HORA 	:= SUBSTRING(TIME(),1,5)
				Z07_USUAR		:= RetCodUsr()
			MsUnlock()
		EndIf
	EndIf
Return  lRet

/*/{Protheus.doc} libExped
	Libera pedido para expedição.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 21/07/2021
	@param _cBx, variant, Parâmetro vindo da liberação
	@return variant, Valor do status 
/*/
Static Function libExped(_cBx)

	If MsgYesNo("Deseja Liberar a Expedição deste Pedido: "+SC5->C5_NUM +"?", 'Atenção')
		_cBx := 'E'
	Endif

Return _cBx

/*/{Protheus.doc} libProd
	Atribui o status P para liberação de Produção.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 28/07/2021
	@param _cBx, variant, Parâmetro vindo da liberação
	@return variant, Valor do status 
/*/
Static Function libProd(_cBx)

	If MsgYesNo("Deseja Liberar a produção deste Pedido: "+SC5->C5_NUM, 'Atenção')
		_cBx := 'P'
	Endif

Return _cBx

/*/{Protheus.doc} libVend
	Liberação da venda
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 28/07/2021
	@param _cBx, variant, Parâmetro vindo da liberação
	@return variant, Valor do status 
/*/
Static Function libVend(_cBx)

	If MsgYesNo("Deseja Liberar a venda deste Pedido: "+SC5->C5_NUM+"?", 'Atenção')
		_cBx := 'L'
	Endif

Return _cBx

/*/{Protheus.doc} justLibC
	Tela de justificativa  da liberação de crédito
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 21/07/2021
	@return variant, Nil
/*/
Static Function justLibC()

	Local oGet1
	Local cGet1 := Space(254)
	Local oPanel1
	Local oSay1
	Local oSButton1
	Local oSButton2
	Local cAct := ""
	Static oDlgJust

	DEFINE MSDIALOG oDlgJust TITLE "Informe o motivo." FROM 000, 000  TO 180, 680 COLORS 0, 16777215 PIXEL

		@ 003, 004 MSPANEL oPanel1 SIZE 327, 078 OF oDlgJust COLORS 0, 16777215 RAISED
		@ 016, 010 SAY oSay1 PROMPT "Justificativa:" SIZE 063, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
		@ 033, 012 MSGET oGet1 VAR cGet1 SIZE 311, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
		DEFINE SBUTTON oSButton1 FROM 057, 295 TYPE 01 OF oPanel1 ENABLE ACTION {|| cAct := "1", oDlgJust:end() } 
		DEFINE SBUTTON oSButton2 FROM 057, 264 TYPE 02 OF oPanel1 ENABLE ACTION {|| oDlgJust:end() } 

	ACTIVATE MSDIALOG oDlgJust CENTERED

		If !Empty(cGet1)
			Return cGet1
		EndIf

Return Nil
