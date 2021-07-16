#include 'protheus.ch'
#include 'parmtype.ch'

user function BXMENATR(xPar, pCliente, pLoja)
	
Local oBtnOK
Local oBtnCancel
Local lRet := .F.
Local xLinha := 10
Local nTotal := 0
Local cJust := ""
Local nAtrasados := 0
Public oDlg
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return .T.
		endif
If !( RetCodUsr()$ Supergetmv("BM_USERLIB",.F.,"000000;000915" ) )
	MsgInfo("Usuário sem permissão para liberar. (BM_USERLIB)","Atenção!")
	return .F.
Endif

If SC5->C5_BXSTATU = 'L' .AND. SC5->C5_LIBEROK <> 'S'
	MsgInfo("Pedido de venda já liberado anteriormente","Atenção!")
	return .F.
EndIf

dbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

dbSelectArea("SC6")
DbSetOrder(1)
DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)

	while SC6->(!Eof()) .AND. SC5->C5_NUM = SC6->C6_NUM
        nTotal += SC6->C6_VALOR
        SC6->(dbSkip())
	end

    pMensagem := "Deseja Liberar este pedido: "+ SC5->C5_NUM 
    pMensagem += chr(10) + chr(13) +"Cliente: "+SA1->A1_NOME + chr(10) + chr(13) 
    pMensagem += "Valor R$"+alltrim(Transform(nTotal,PesqPict("SC6","C6_VALOR"))) + chr(10) + chr(13) 

	nAtrasados := u_FFATVATR(SC5->C5_CLIENTE, SC5->C5_LOJACLI)
	
	If  nAtrasados != 0
		pMensagem += " Este Cliente possui pendências financeiras com valor total somado: "+ Transform(E1TEMP->VALOR,PesqPict("SC6","C6_VALOR"))
	EndIf
	MsUnlock()
	cBx := 'B'

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Atenção") FROM 000,000 TO 180,650 PIXEL
	@ 010, 010 Say OemToAnsi(substr(pMensagem,1,at('#',pMensagem)-1)) PIXEL
	@ 020, 010 Say OemToAnsi(substr(pMensagem,at('#',pMensagem)+1,len(pMensagem))) PIXEL
	oBtnOK 		 := TButton():New(060,010+xLinha,"Visualizar",oDlg,{||u_FFATG004(pCliente,pLoja)},50,20,,,,.T.,,"",,,,.F.)
	oBtnCancel   := TButton():New(060,070+xLinha,"Liberar Expedição",oDlg,{||lRet:= .T., cBx := libExped(cBx),oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
	oBtnLiberar  := TButton():New(060,130+xLinha,"Liberar Venda",oDlg,{||lRet := .T., cBx := libVend(cBx),oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
	oBtnLiberar  := TButton():New(060,190+xLinha,"Liberar Prod",oDlg,{||lRet := .T.,cBx := libProd(cBx), oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
	oBtnCancel   := TButton():New(060,250+xLinha,"Não Liberar",oDlg,{||lRet:= .F., cJust := GetJust(),oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
	ACTIVATE MSDIALOG oDlg CENTERED

	If lRet
		RecLock("SC5",.F.)
			SC5->C5_BXSTATU := cBx
		If cBx = 'L' .OR. cBx = 'E'
			SC5->C5_LIBEROK := 'L'	
			SC5->C5_BLQ := ''	
			atuSC9(SC5->C5_NUM)
		EndIf
		SC5->(MsUnlock())

		dbSelectArea("Z07")
		RecLock("Z07",.T.)
			Z07->Z07_FILIAL := SC5->C5_FILIAL
			Z07->Z07_PEDIDO := SC5->C5_NUM
			Z07->Z07_JUSTIF := 'Liberada '+IIF(cBx = 'P','Produção','Venda')+' Usuário: '+RetCodUsr()
			Z07->Z07_DATA := dDataBase
			Z07->Z07_HORA := SUBSTRING(TIME(),1,5)
		MsUnlock()
	Else 
		RecLock("Z07",.T.)
			Z07->Z07_FILIAL := SC5->C5_FILIAL
			Z07->Z07_PEDIDO := SC5->C5_NUM
			Z07->Z07_JUSTIF := 'Não Liberado: '+ alltrim(cJust) +' Usuário: '+RetCodUsr()
			Z07->Z07_DATA := dDataBase
			Z07->Z07_HORA := SUBSTRING(TIME(),1,5)
		MsUnlock()
	EndIf

Return  lRet

Static Function libProd(_cBx)

	If MsgYesNo("Deseja Liberar a produção deste Pedido: "+SC5->C5_NUM, 'Atenção')
		_cBx := 'P'
	Endif

Return _cBx

Static Function libVend(_cBx)

	If MsgYesNo("Deseja Liberar a venda deste Pedido: "+SC5->C5_NUM+"?", 'Atenção')
		_cBx := 'L'
	Endif

Return _cBx

Static Function libExped(_cBx)

	If MsgYesNo("Deseja Liberar a Expedição deste Pedido: "+SC5->C5_NUM +"?", 'Atenção')
		_cBx := 'E'
	Endif

Return _cBx

Static Function GetJust()

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
Return ""

Static Function atuSC9(_cPed)

	TcSqlExec(" UPDATE SC9010 SET C9_BLCRED = '' WHERE C9_PEDIDO = '"+_cPed+"' AND D_E_L_E_T_ <> '*'" )

Return 
