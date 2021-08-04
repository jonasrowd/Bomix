#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "Msobject.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ BXRTDP  	  ºAutor ³PABLO G. REGIS     º Data ³  03/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Produtos Bomix								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BXRTDP		  	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
LC_NUMDIA C Numero de Dias para aviso de vencimento           
*/

User Function BXRTDP    ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aSavARot := If(Type("aRotina")	!="U"	,aRotina	,{})
Local cSavcCad := If(Type("cCadastro")	!="U" 	,cCadastro	,"")

Private cCadastro 	:= OemToAnsi("Item/Molde - Produto Bomix")
Private l415Auto  	:= .F.

Private nTipo     	:= 1
Private nUsado		:= 0

/*ACOLS MOLDES*/
Private aHdMolde 	:= {}
Private aItMolde 	:= {}

Private aBotao := {}

AADD(aBotao ,{"POSCLI",{||U_F_ITENS()},"Importar Itens"})  

Private aRotina := {;
{ OemToAnsi("Pesquisar")    	 ,"AxPesqui"	,0,1},; //"Pesquisar"
{ OemToAnsi("Visualizar")    	 ,"U_BRTDPVISUA",0,2},; //"Visualisar"
{ OemToAnsi("Incluir")       	 ,"U_BRTDPINCLU",0,3},; //"Incluir"
{ OemToAnsi("Alterar")       	 ,"U_BRTDPVISUA",0,4},; //"Alterar"
{ OemToAnsi("Exclusao")      	 ,"U_BRTDPVISUA",0,5}}; //"Exclusao"

// MBROWSER DA TELA INICIAL

MBROWSE( 6, 1,22,75,"SZT",,,,,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura os dados de entrada                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aRotina   := aSavARot
cCadastro := cSavcCad

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFUNCAO DE INCLUIR                           							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRTDPINCLU(cAlias,nReg,nOpcx)

Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := {}

Local cOldFilter := ""

Local aArea      := GetArea()
Local aTitles    := {}
Local cCadastro  := OemToAnsi("Cadastro de Item/Molde")
Local nCntFor    := 0
Local nOpcA      := 0
Local oDlg

//Variaveis Comuns
Private xNUsrDad 	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
Private dLibDad		:= dDataBase
Private xNUsrLay 	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
Private dLibLay		:= dDataBase
Private xNUsrOrct	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
Private dLibOrct	:= dDataBase
Private xNUsrOrc 	:= Substr(cUsuario,7,15) //aUsr[1][1][2]
Private dLibOrc		:= dDataBase
//
Private aFLDF	 	:= {}
Private oFolder
Private oBMP
Private aCpoMolde  	:= {}
Private oMGDMolde

Private aTELA[0][0] // Variáveis que serão atualizadas pela Enchoice()
Private aGETS[0] 	// e utilizadas pela função OBRIGATORIO()
Private aItLimpo 	:= {}

nUsado:=0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa algum filtro do SZN                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOldFilter := SZN->( DbFilter() )
SZN->( DbClearFilter() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da Variaveis de Memoria                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SZT")
DbSetOrder(1)

For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
Next nCntFor

DbSelectArea("SZT")
DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a dos combo                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aSize    := MsAdvSize()

aObjects := {}
AAdd( aObjects, {  60, 100, .T., .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )

nFimCad := aSize[ 4 ] - 110
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], nFimCad, 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

nFolder := 0

aAdd( aTitles,OemToAnsi("Itens/Moldes"))


DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	EnChoice( cAlias ,nReg, nOpcx, , , , , aPosObj[1], , 1 )
	
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
	aItLimpo 	:= aClone(aItMolde)   
	oMGDMolde	:= MsNewGetDados():New(0,0,aPosObj[2,3]-300,aPosObj[2,4]-5,GD_INSERT+GD_DELETE+GD_UPDATE,,,"+ZN_SEQ+ZN_ORDEM",aCpoMolde,,999,,,,aFldF[1],aHdMolde,aItMolde)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca :=1,IIF(U_BRTDPVALIDI(aGets,aTela),oDlg:End(),.F.)},{||nOpca :=2,oDlg:End()},,aBotao)

If ( nOpcA == 1 )
		RollBackSX8()
		U_GRV_BRTDPCA(1)
		U_GRV_ITENS(1)
		U_INCGRPPROD()
ElseIf ( nOpcA == 2 )
		RollBackSX8()
Endif

// Limpa as variaveis
U_LPLICVAR()

MsUnLockAll()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna o filtro original                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty( cOldFilter )
	DbSelectArea( cAlias )
	Set Filter To &cOldFilter
EndIf

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFUNCAO DE VISUALIZAR/ALTERAR/EXCLUIR       							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BRTDPVISUA(cAlias,nReg,nOpcx)

Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := {}

Local cOldFilter := ""
Local aArea      := GetArea()
Local aTitles    := {}
Local cCadastro  := OemToAnsi("Cadastro de Item/Molde")
Local nCntFor    := 0
Local nOpcA      := 0
Local oDlg      

Private oFolder
Private aFLDF	 := {}
Private aCpoMolde 	:= {}
//Private oMGDMOLDE
Private xOpcoes
Private _nOpcx
Private aTELA[0][0] // Variáveis que serão atualizadas pela Enchoice()
Private aGETS[0] // e utilizadas pela função OBRIGATORIO()
Private aItLimpo 	:= {}

IF (nOpcx == 4 )
	xOpcoes:= GD_INSERT+GD_DELETE+GD_UPDATE
	_nOpcx := nOpcx
	nOpcx := 4
Else
	xOpcoes:= 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa algum filtro do SZN                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cOldFilter := SZN->( DbFilter() )
SZN->( DbClearFilter() )

DbSelectArea("SZT")
DbSetOrder(1)

For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
Next nCntFor

U_LICATUVAR(nOpcx)

If  nOpcx = 5
	MsgBox(OemtoAnsi("Item/Molde não pode ser excluída!"))
Else
	aSize    := MsAdvSize()
	
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
		oMGDMOLDDE  	:= MsNewGetDados():New(0,0,aPosObj[2,3]-120,aPosObj[2,4]-5,xOpcoes,,,"+ZN_SEQ+ZN_ORDEM",aCpoMolde,,999,,,,aFldF[1],aHdMolde,aItMolde)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca :=1,IIF(U_BRTDPVALIDI(aGets,aTela),oDlg:End(),.F.)},{||nOpca :=2,oDlg:End()},,)
	
	If ( nOpca == 1 )
		Begin Transaction
		DO CASE
			CASE nOpcx = 5 // Exclusão
				
				xChave     := M->ZT_GROUPOMS
				
				DbSelectArea("SZT")
				RecLock("SZT",.F.)
					SZT->( DbDelete() )
				MsUnLock()
				
				DbSelectArea("SZN")
				SZN->( DbSetOrder(2) )
				If SZN->( DbSeek(xFilial("SZN")+xChave) )
					RecLock("SZN",.F.)
						ZZ4->( DbDelete() )
					MsUnLock()
				Endif
												
			CASE nOpcx = 4    //ALTERACAO
				U_GRV_BRTDPCA(2)
				U_GRV_ITENS(2)
		ENDCASE
		
		EvalTrigger()
		End Transaction
	Else
		RollBackSX8()
	EndIf
	
	U_LPLICVAR() // Limpa as variaveis
		
	MsUnLockAll()
	
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna o filtro original                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty( cOldFilter )
	DbSelectArea( cAlias )
	Set Filter To &cOldFilter
EndIf

RestArea(aArea)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºTabela de Moldes - Itens (HEADER)									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CCISZN()
Local nUsado:=	0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZN")
While !Eof() .And. (x3_arquivo == "SZN")
	if alltrim(X3_CAMPO) $ "ZN_SEQ/ZN_ORDEM/ZN_CODMED/ZN_MEDIDA/ZN_UNIDADE/ZN_ESPECIF/ZN_VARIA/ZN_MINIMO/ZN_MAXIMO"
	   if X3USO(x3_usado) .AND. cNivel >= x3_nivel
			nUsado ++
			AADD(aHdMolde,{TRIM(x3_titulo),alltrim(X3_CAMPO),;
			x3_picture,x3_tamanho, x3_decimal,,x3_usado, x3_tipo,,x3_context})
	  Endif
	endif
	dbSkip()
EndDo 
   
AADD(aHdMolde,{"Recno","RECNO","@E 9999999999",10,0    ,"€€€€€€€€€€€€€€ ",  ,"N",,'R'})
nUsado ++ 

aItMolde := Array(1,nUsado + 1) 

n_cont := 1

while n_cont <= len(aHdMolde)
	do case
		case aHdMolde[n_cont, 8] == "C"
			aItMolde[1][n_cont] := SPACE(aHdMolde[n_cont, 4])
		case aHdMolde[n_cont, 8] == "N"
			aItMolde[1][n_cont] := 0
		case aHdMolde[n_cont, 8] == "D"
			aItMolde[1][n_cont] := dDataBase
		case aHdMolde[n_cont, 8] == "M"
			aItMolde[1][n_cont] := ""
		otherwise
			aItMolde[1][n_cont] := .F.
	endcase
	n_cont ++
enddo

aItMolde[1][aScan(aHdMolde,{|x| alltrim(x[2]) == "RECNO"})]		:=  0
aItMolde[1][aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"})]  	:= "001"
aItMolde[1][aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"})] 	:= "01"
aItMolde[1][len(aItMolde[1])] := .F.


RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºTabela de Moldes (Itens)							   			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CIMSZN()
Local n_cont    := 1
Local c_Chave   := trim(M->ZT_GRUPOMS)
Local nUsado    :=	len(aHdMolde)

DbSelectArea("SZN")
DbSetOrder(2)
DbSeek(xFilial("SZN")+c_Chave)

while !SZN->(EOF()) .AND. c_Chave == trim(SZN->ZN_GRUPO)
	
	if n_cont > 1
		aadd(aItMolde, Array(nUsado + 1))
	endif

	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"		})]	    := SZN->ZN_SEQ     
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"		})]		:= SZN->ZN_ORDEM  
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"	})]		:= SZN->ZN_CODMED  
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MEDIDA"	})] 	:= SZN->ZN_MEDIDA  
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_UNIDADE"	})] 	:= SZN->ZN_UNIDADE
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ESPECIF"	})] 	:= SZN->ZN_ESPECIF 
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_VARIA"		})]   	:= SZN->ZN_VARIA   
	aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MINIMO"	})] 	:= SZN->ZN_MINIMO  
    aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MAXIMO"	})] 	:= SZN->ZN_MAXIMO 
    aItMolde[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "RECNO"})]				:= SZN->(RECNO())
	
	if n_cont > 1
		aItMolde[len(aItMolde), nUsado + 1] := .F.
	endif
	n_cont ++
	
	SZN->( dbSkip() )
enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºGRAVAR ITENS			                    							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRV_ITENS(xTipo)
Local nX	  	:= 0
Local c_Cod 	:= ""
Local l_Deletar	:= .F.


For nX:=1 to len(oMGDMOLDE:aCols)
	
	c_Cod    := M->ZT_GRUPOMS
	l_Deletar:= oMGDMOLDE:aCols[nX,len(oMGDMOLDE:aCols[nX])]
	c_CodMed := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})]
	
	DbSelectArea("SZN")
	DbSetOrder(3)
	DbSeek(xFilial("SZN")+c_Cod+c_CodMed)
	IF SZN->(EOF())
		IF!(empty(alltrim(c_CodMed)))
			Begin Transaction
				DbSelectArea("SZN")
				Reclock("SZN",.T.)
					
					SZN->ZN_FILIAL  := xFilial("SZN")
					SZN->ZN_GRUPO   := M->ZT_GRUPOMS
					SZN->ZN_ITEM    := M->ZT_DESCMS
					SZN->ZN_GRUPOFK := 1
					SZN->ZN_GRUPOBX := M->ZT_GRUPOBX
					
					SZN->ZN_SEQ     := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"})]
					SZN->ZN_ORDEM   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"})]                    												
					SZN->ZN_CODMED  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})]
					SZN->ZN_MEDIDA  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MEDIDA"})]
					SZN->ZN_UNIDADE := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE") //oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_UNIDADE"})]
					SZN->ZN_ESPECIF := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ESPECIF"})]
					SZN->ZN_VARIA   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_VARIA"})]
					SZN->ZN_MINIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MINIMO"})]
					SZN->ZN_MAXIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MAXIMO"})]	
				MsUnLock()
			END Transaction
			loop
		ELSE
			loop
		ENDIF
		
	ELSE
		
		IF l_Deletar
			RecLock("SZN",.F.)
				SZN->( DbDelete() )
			MsUnLock()
			loop
		ELSE
			Begin Transaction
			Reclock("SZN",.F.)
				SZN->ZN_FILIAL  := xFilial("SZN")		
				SZN->ZN_GRUPO   := M->ZT_GRUPOMS
				SZN->ZN_ITEM    := M->ZT_DESCMS	 
				SZN->ZN_GRUPOFK := 1
				SZN->ZN_GRUPOBX := M->ZT_GRUPOBX
								
				SZN->ZN_SEQ     := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"})]
				SZN->ZN_ORDEM   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"})]				
				SZN->ZN_CODMED  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})]
				SZN->ZN_MEDIDA  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MEDIDA"})]
				SZN->ZN_UNIDADE := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE") //oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_UNIDADE"})]								
				SZN->ZN_ESPECIF := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ESPECIF"})]
				SZN->ZN_VARIA   := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_VARIA"})]
				SZN->ZN_MINIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MINIMO"})]
				SZN->ZN_MAXIMO  := oMGDMOLDE:aCols[nX,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MAXIMO"})]
				
			MsUnLock()
			END Transaction
			loop
		ENDIF
	ENDIF
next
SZN->(DBCLOSEAREA())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLIMPAR VARIAVEIS 													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LPLICVAR

nTipo     	:= 1
nUsado		:= 0
/*Moldes POSICOES*/
aHdMolde 	:= {}
aItMolde 	:= {}

cStatus 	:= ""

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºCARREGA MOLDES	                          							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LICATUVAR(nOpcx)

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

Return


User Function BRTDPVALIDI()
Local lRet := .F.

if Obrigatorio(aGets,aTela)
	lRet := .T. 
else
	lRet := .F.
endif

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºGRAVAR CÓDIGO DO PRODUTO BOMIX VRS GRUPO PROTHEUS					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRV_BRTDPCA(xTipo)

Begin Transaction

If xTipo = 1 // Grava
	DbSelectArea("SZT")
	Reclock("SZT",.T.)
		SZT->ZT_FILIAL  := xFilial("SZT")
		SZT->ZT_GRUPOMS := M->ZT_GRUPOMS 
		SZT->ZT_DESCMS  := M->ZT_DESCMS 
	confirmsx8("SZT")
Else 	 // Atualiza
	DbSelectArea("SZT")
	Reclock("SZT",.F.)
Endif
	SZT->ZT_GRUPOBX := M->ZT_GRUPOBX 
	SZT->ZT_DESCBX  := M->ZT_DESCBX  
	MsUnLock()
End Transaction
Return         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºCARREGAR OS DADOS DAS MEDIDAS(SZO) PARA TELA DE ESPECIFICAÇÕES		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function f_Itens()

Local c_Ret			:= M->ZT_GRUPOBX
Local cQry 		    := ""
Local n_cont 	    := IIF(len(oMGDMOLDE:aCols)>1,len(oMGDMOLDE:aCols)+1 ,1)
Local _ArqSZO 	    := ""
Local c_TipoProduto := ""
Local c_Tamanho     := ""
Local c_Formato     := ""  
Local n_Seq 		:= 0
Local n_Ordem		:= 0


If !MSGYESNO("Deseja realmente carregar os Itens/Especificações  do Grupo Produto (Bomix) "+trim(M->ZT_GRUPOBX)+" - "+trim(M->ZT_DESCBX)+" ?")
	Return c_Ret
Endif           

If n_cont > 1 
	/*If MSGYESNO("Você já carregou dados, deseja realmente carregar novos Itens/Especificações do Grupo Produto (Molde) "+trim(M->ZT_GRUPOBX)+" - "+trim(M->ZT_DESCBX)+" ? Seus dados anteriores serão apagados")
		aItMolde := aClone(aItLimpo)
		oMGDMOLDE:SetArray(aItMolde,.T.)
		oMGDMOLDE:ForceRefresh ( )
	Else		
		Return c_Ret
	Endif  */
	
	MsgBox(OemtoAnsi("Você já realizou essa operação, não é permitido realizar mais de um vez! Feche a tela e abra novamente"))	
	Return M->ZT_GRUPOBX
	
EndIf

_ArqSZO := RetSqlName("SZO")             

DbselectArea("SZL")
DbSetOrder(4)

If DbSeek(xFilial("SZL")+M->ZT_GRUPOBX)  

	c_TipoProduto := SZL->ZL_TIPO
	c_Tamanho     := SZL->ZL_TAMANHO
	c_Formato     := SZL->ZL_FORMATO

	cQry := "  SELECT ZO_COD, ZO_DESC "
	cQry += " FROM "+_ArqSZO+" "
	cQry += " WHERE  "
	cQry += " ZO_FILIAL ='"+xFilial("SZO")+"' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	cQry += " AND ZO_TPPROD LIKE ('%"+c_TipoProduto+"%') "
	cQry += " AND ZO_TAMANHO LIKE ('%"+c_Tamanho+"%')"
	cQry += " AND ZO_FORMATO LIKE ('%"+c_Formato+"%') "
	cQry += " ORDER BY ZO_TIPO "
	
	TCQUERY cQry New Alias "QRY"
	
	DBSelectArea("QRY")
	Dbgotop()
	
	While !EOF() .and. !empty(trim(QRY->ZO_COD))
		
		n_Seq ++
		n_Ordem ++
		
		IF n_cont > 1
			IF (oMGDMOLDE:AddLine (.F.))                                                                    
				oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"})]      := STRZERO(n_Seq,3)
				oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"})]    := STRZERO(n_Ordem,2)
				
				oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})]   := QRY->ZO_COD
				oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MEDIDA"})]   := QRY->ZO_DESC  
				oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_UNIDADE"})]  := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE") 
				oMGDMOLDE:aCols[n_cont,LEN(oMGDMOLDE:aCols[n_cont])]  	:= .F.
				oMGDMOLDE:Refresh()			
			ENDIF
		ELSE     
			oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"})]      := STRZERO(n_Seq,3)
			oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"})]    := STRZERO(n_Ordem,2)
		
			oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})]   := QRY->ZO_COD
			oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MEDIDA"})]   := QRY->ZO_DESC
			oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_UNIDADE"})]  := POSICIONE("SZO",1,XFILIAL("SZO")+oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})],"ZO_UNIDADE") 
			oMGDMOLDE:aCols[n_cont,LEN(oMGDMOLDE:aCols[n_cont])]  	:= .F.
			oMGDMOLDE:Refresh()
		ENDIF
		
		n_cont ++
		
		QRY->(dbSkip())
		
	EndDo
	
EndIf         

If n_Cont > 1
	IF (oMGDMOLDE:AddLine (.F.))                                                                    
		/*oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_SEQ"})]    := STRZERO(n_Seq+1,3)
		oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_ORDEM"})]    := STRZERO(n_Ordem+1,2)		                                                                                  
		oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_CODMED"})]   := " "
		oMGDMOLDE:aCols[n_cont,aScan(aHdMolde,{|x| alltrim(x[2]) == "ZN_MEDIDA"})]   := " "
		oMGDMOLDE:aCols[n_cont,LEN(oMGDMOLDE:aCols[n_cont])]  	:= .F.*/
		oMGDMOLDE:Refresh()			
	 ENDIF

Endif

DbCloseArea()
oFolder:SetOption(1)
Return (c_Ret)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºGRAVAR GRUPO DE PRODUTO PROTHEUS VIA MSEXECAUTO	035					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IncGrpProd()

Local aGrpProd := {}
Local nOpc := 3 // inclusao
Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
Private lMsErroAuto := .f. //necessario a criacao, pois sera //atualizado quando houver
//alguma incosistencia nos parametros
Begin Transaction
	aGrpProd:= {{'BM_FILIAL' 	 ,xFilial("SBM"),Nil},;
				{'BM_GRUPO'   	 ,M->ZT_GRUPOMS ,Nil},;
				{'BM_DESC'  	 ,M->ZT_DESCMS  ,Nil},;
				{'BM_GRUPOBX'  	 ,M->ZT_GRUPOBX ,Nil}}
	
	MSExecAuto({|x,y| mata035(x,y)},aGrpProd,nOpc)       
	
	If lMsErroAuto
		DisarmTransaction()
		break
	EndIf        
	
End Transaction

If lMsErroAuto
	/*
	Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros
	passados,mostrar na tela o log informando qual coluna teve a incosistencia.
	*/
	Mostraerro()
	Return .f.
EndIf

Return .t.

