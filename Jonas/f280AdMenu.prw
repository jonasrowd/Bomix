#include "protheus.ch"
#include "topconn.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: f280AdMenu()
//|Autor.....: Renan Avelar - avelarbrasil@gmail.com
//|Data......: 25 de abril de 2014, 21:00
//|Descricao.: Impressão Boleto Itau
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
//User Function f280AdMenu() Este ponto de entrada era para adiconar o botão no Faturas a receber, então como essa rotina foi descontinuada, eu desativei
  User Function FA740BRW() // Adiciona o Botão de impressão do boleto no FUNÇÔES do CONTAS A RECEBER
*-----------------------------------------------------------*

Local aBotao := {}

aAdd(aBotao, {'Imprimir Boleto',"U_F280ITAU()",   0 , 5    })

Return(aBotao)

//ponto de entrada F280AdMenu que eu tambem desativei a rotina e ativei o Ponto FA740BRW
/*
Local aMat := ParamIXB

aAdd( aMat, { "Boleto Itau","U_F280ITAU()", 0 , 5} )

Return(aMat)
*/
//+-----------------------------------------------------------------------------------//
//|Funcao....: F280ITAU()
//|Autor.....: Renan de Avelar - avelarbrasil@gmail.com
//|Data......: 25 de abril de 2014, 21:00
//|Descricao.: Impressão Boleto Itau
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function F280ITAU()
*-----------------------------------------------------------*

Local nMsgImp := 0
Local cMsgImp := ""

cMsgImp := "Esta rotina tem como objetivo imprimir Boletos do Itaú"
cMsgImp += Chr(13)+Chr(10)+Chr(13)+Chr(10)
cMsgImp += "Agora escolha o que deseja fazer:"
cMsgImp += Chr(13)+Chr(10)
cMsgImp += "1) Imprimir o boleto referente ao titulo que está selecionado/posicionado."
cMsgImp += Chr(13)+Chr(10)
cMsgImp += "2) Imprimir diversos boletos com base nos parametros que serão apresentados."
cMsgImp += Chr(13)+Chr(10)
cMsgImp += "3) Sair sem fazer nada"

nMsgImp := Aviso("Impressão Boleto Itaú",cMsgImp,{"Um Boleto","Div. Boletos","Sair"},3)

Do Case
	Case nMsgImp == 1
		fPrintUm()

	Case nMsgImp == 2
		fPrintDiv()

	Case nMsgImp == 3
		Return

EndCase

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fPrintDiv()
//|Autor.....: Renan Avelar - avelarbrasil@gmail.com
//|Data......: 25 de abril de 2014, 21:00
//|Descricao.: Impressão Boleto Itau
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fPrintDiv()
*-----------------------------------------------------------*

Local aPar     := {}
Local aRet     := {}
Local aTit     := {}

Local lLoop    := .T.
Local cNumTit  := ""

Local lOk      := .T.

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())

Private mv_par01 := Space(Len(SE1->E1_NUM))
Private mv_par02 := Space(Len(SE1->E1_NUM))
Private mv_par03 := Space(Len(SE1->E1_CLIENTE))
Private mv_par04 := Space(Len(SE1->E1_LOJA))
Private mv_par05 := Space(Len(SE1->E1_PREFIXO))

aAdd(aPar,{1,"Numero Titulo De"    ,mv_par01  ,"@!"      ,"NaoVazio()"                                         ,      , ,060 ,.T.})
aAdd(aPar,{1,"Numero Titulo Até"   ,mv_par02  ,"@!"      ,"mv_par02 >= mv_par01"                               ,      , ,060 ,.T.})
aAdd(aPar,{1,"Codigo Cliente"      ,mv_par03  ,"@!"      ,"ExistCpo('SA1',mv_par03)"                           ,"SA1" , ,060 ,.T.})
aAdd(aPar,{1,"Loja Cliente"        ,mv_par04  ,"@!"      ,"ExistCpo('SA1',mv_par03+mv_par04)"                  ,      , ,060 ,.T.})
aAdd(aPar,{1,"Prefixo Titulo"      ,mv_par05  ,"@!"      ,"NaoVazio()"                                         ,      , ,060 ,.T.})

//Chama tela de perguntas
If ParamBox(aPar,"Impressão Boleto Itaú",@aRet)
	mv_par01 := aRet[1]
	mv_par02 := aRet[2]
	mv_par03 := aRet[3]
	mv_par04 := aRet[4]
	mv_par05 := aRet[5]
	
	lLoop   := .T.
	cNumTit := mv_par01

	SE1->(DbSetOrder(2))
	While lLoop
		//Se encontrar titulo, guarda recno
		If SE1->(DbSeek( xFilial("SE1")+mv_par03+mv_par04+mv_par05+cNumTit ))
			While SE1->(!Eof()) .And. xFilial("SE1") + mv_par03        + mv_par04     + mv_par05        + cNumTit == ;
			                          SE1->E1_FILIAL + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM
				aAdd(aTit, SE1->(Recno()) )
				SE1->(DbSkip())
			End
		EndIf
		
		//Proximo registro que será verificado
		cNumTit := Soma1(cNumTit)

		//Se proximo maior que ultimo definido, sair
		If cNumTit > mv_par02
			lLoop := .F.
		EndIf
		
		//Se quantidade de impressão maior que 20, parar impressão por segurança
		If lLoop .And. Len(aTit) > 20
			lLoop := .F.
			lOk   := .F.
			Alert("Por segurança só é permitido imprimir 20 boletos por vez!")
		EndIf
	End
	RestArea(aAreaSE1)
	
	If lOk
		For x:=1 To Len(aTit)
			SE1->(DbGoTo(aTit[x]))
			fPrintUm()
		Next x
	EndIf
	
EndIf

If Len(aTit) > 0
	MsgInfo(StrZero(Len(aTit),2)+" boletos foram impresso!")
EndIf

RestArea(aArea)
RestArea(aAreaSE1)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fPrintUm()
//|Autor.....: Renan Avelar - avelarbrasil@gmail.com
//|Data......: 25 de abril de 2014, 21:00
//|Descricao.: Impressão Boleto Itau
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fPrintUm()
*-----------------------------------------------------------*

Local cNumPV := ""
Local aArea  := GetArea()

If Empty(SE1->E1_PEDIDO)
	If SimNao("Este titulo não tem PV relacionado, deseja fazer isso agora?") == "S"
		cNumPV := fBuscaPV()
	EndIf
Else
	cNumPV := SE1->E1_PEDIDO
EndIf

If Empty(cNumPV)
	Alert("Nenhum pedido foi selecionado!")
Else
	//Grava PV no Titulo
	If Empty(SE1->E1_PEDIDO)
		RecLock("SE1",.F.)
		SE1->E1_PEDIDO := cNumPV
		SE1->(MsUnLock())
	EndIf
	
	//Chama rotina de impressão do boleto
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+cNumPV))
		U_INCB341()
	Else
		Alert("Pedido de Vendas '"+cNumPV+"' não localizado!")
	EndIf
EndIf

RestArea(aArea)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fBuscaPV()
//|Autor.....: Renan Avelar - avelarbrasil@gmail.com
//|Data......: 25 de abril de 2014, 08:00
//|Descricao.: Totaliza Valores da Compra
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fBuscaPV()
*-----------------------------------------------------------*
Local aArea  := GetArea()
Local cQuery := ""
Local cKebra := Chr(13)+Chr(10)

// Vetor com os campos que poderao ser alterados
Local aAlter       	:= {}               // {"Z3_VUNIT","Z3_VTOT","Z3_ENT","Z3_IT"}
Local nSuperior    	:= 000              // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= 000              // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= 300              // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= 400              // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local nOpc         	:= GD_UPDATE        //GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinOk       	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.
// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
// segundo campo>+..."
Local nFreeze      	:= 000              // Campos estaticos na GetDados.
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99
Local cFieldOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Local cSuperDel     := ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk        := "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols
// Objeto no qual a MsNewGetDados sera criada
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols

Local cRet         	:= ""
Local nPosCpo       :=  0

Private oBrw        := Nil
Private lPesqOk     := .F.

//----------------------------------------------------------------------------------

Aadd(aHead,{ "  "             ,"XX_OK"     ,"@BMP"  , 2,0,"","","C","","","",""})
Aadd(aHead,{ "Titulo C.R."    ,"XX_TITULO" ,"@!"    , 6,0,"","","C","","","",""})
Aadd(aHead,{ "Pedido Venda"   ,"XX_PEDIDO" ,"@!"    , 6,0,"","","C","","","",""})
Aadd(aHead,{ "Codigo"         ,"XX_CODIGO" ,"@!"    , 6,2,"","","C","","","",""})
Aadd(aHead,{ "Loja"           ,"XX_LOJA"   ,"@!"    , 2,2,"","","C","","","",""})
Aadd(aHead,{ "Nome Reduzido"  ,"XX_NREDUZ" ,"@!"    ,30,0,"","","C","","","",""})

cQuery := cKebra+" SELECT TOP 200 "
cQuery += cKebra+" C5_FILIAL, "
cQuery += cKebra+" C5_CLIENTE, "
cQuery += cKebra+" C5_LOJACLI, "
cQuery += cKebra+" A1_NREDUZ, "
cQuery += cKebra+" C5_NUM "
cQuery += cKebra+" FROM "+RetSqlName("SC5")+" SC5 "
cQuery += cKebra+" LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_ = '' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
cQuery += cKebra+" WHERE SC5.D_E_L_E_T_ = '' "
cQuery += cKebra+" AND C5_FILIAL  = '"+xFilial("SC5")+"' "
cQuery += cKebra+" AND C5_CLIENTE = '"+SE1->E1_CLIENTE+"' "
cQuery += cKebra+" AND C5_LOJACLI = '"+SE1->E1_LOJA+"' "
cQuery += cKebra+" ORDER BY C5_NUM DESC "

//Fechar Alias TEMP
If Select("TEMP") > 0 ; TEMP->(Dbclosearea()) ; Endif
TcQuery cQuery New Alias "TEMP" 

//Alimenta array com resultado da query
TEMP->(DbGoTop())
While TEMP->(!Eof())
	aAdd(aCol,Array(Len(aHead)+1))

	aCol[Len(aCol)][01] := "LBNO"
	aCol[Len(aCol)][02] := SE1->E1_NUM
	aCol[Len(aCol)][03] := TEMP->C5_NUM
	aCol[Len(aCol)][04] := TEMP->C5_CLIENTE
	aCol[Len(aCol)][05] := TEMP->C5_LOJACLI
	aCol[Len(aCol)][06] := TEMP->A1_NREDUZ
	aCol[Len(aCol)][07] := .F.

	TEMP->(DbSkip())
End

//Fechar Alias TEMP
If Select("TEMP") > 0 ; TEMP->(Dbclosearea()) ; Endif

//Caso query fazia, alimenta um registro em branco
If Len(aCol) == 0
	aCol[Len(aCol)][01] := "LBNO"
	aCol[Len(aCol)][02] := ""
	aCol[Len(aCol)][03] := ""
	aCol[Len(aCol)][04] := ""
	aCol[Len(aCol)][05] := ""
	aCol[Len(aCol)][06] := ""
	aCol[Len(aCol)][07] := .F.
EndIf

Define MsDialog oDialgForn Title "Seleção de PC" From nSuperior,nEsquerda To nInferior,nDireita Of oMainWnd Pixel

oBrw:=MsNewGetDados():New(nSuperior+5,nEsquerda+5,(nInferior/2)-15,(nDireita/2)-3,nOpc,cLinOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDialgForn,aHead,aCol)
oBrw:oBrowse:bLDblClick := {|| fClickPV() }

//Botões
@ (nInferior/2)-12,102 Button "Confirmar" Size 045,010 Pixel Of oDialgForn Action (lPesqOk:=.T.,oDialgForn:End())
@ (nInferior/2)-12,152 Button "Fechar"    Size 045,010 Pixel Of oDialgForn Action (lPesqOk:=.F.,oDialgForn:End())

Activate MsDialog oDialgForn Centered

If lPesqOk
	For x:=1 To Len(oBrw:aCols)
		nPosCpo := aScan(oBrw:aHeader,{|x|AllTrim(x[2])=="XX_OK"})
		If oBrw:aCols[x][nPosCpo] == "LBTIK"
			nPosCpo := aScan(oBrw:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO" })
			cRet := oBrw:aCols[x][nPosCpo]
			 x := Len(oBrw:aCols)
		EndIf
	Next x
EndIf

RestArea(aArea)

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fClickPV()
//|Autor.....: Renan Avelar - avelarbrasil@gmail.com
//|Data......: 25 de abril de 2014, 08:00
//|Descricao.: Totaliza Valores da Compra
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fClickPV()
*-----------------------------------------------------------*
Local x         := 1
Local nLinhaOK  := oBrw:oBrowse:nAt
Local nPosFlag  := aScan(oBrw:aHeader,{|x|AllTrim(x[2])=="XX_OK"})

//Desmarca Todos Itens
For x:=1 To Len(oBrw:aCols)
	oBrw:aCols[x][nPosFlag] := "LBNO"
Next x

//Marca Item clicado
oBrw:aCols[nLinhaOK][nPosFlag] := "LBTIK"

//Atualiza Objeto
oBrw:oBrowse:Refresh()

Return