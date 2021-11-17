#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

                         
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSCOM100 บ Autor ณFabrica TOTVS Bahia บ Data ณ  27/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para atualizacao das "Datas de Entrega Revisadas"	  บฑฑ
ฑฑบ          ณ dos Pedidos de Compras.									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACOM											  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ										  บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FSCOM100()
           
Local bOk		:= {|| IIF(f_TudoOk(),Eval({|| nOpca := 1,oDlg1:End()}),oDlg1:Refresh()) }
Local bCancel	:= {|| oDlg1:End()}
Local lAchou
Local lNaoAchou
Local cQry

SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oGet1","oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9")

Private c_Filial	:= SC7->C7_FILIAL
Private c_Pedido	:= SC7->C7_NUM
Private aButtons	:= {}
Private nOpca		:= 2

Private cGet1 := c_Filial+' - '+SM0->M0_FILIAL
Private cGet2 := c_Pedido
Private cGet3 := Space(TamSX3('C7_ITEM')[1])
Private cGet4 := Space(TamSX3('C7_ITEM')[1])
Private cGet5 := Space(TamSX3('C7_PRODUTO')[1])
Private cGet6 := Space(TamSX3('B1_DESC')[1])
Private cGet7 := CTOD('')
Private cGet8 := Space(TamSX3('C7_PRODUTO')[1])
Private cGet9 := Space(TamSX3('B1_DESC')[1])

      
cQry := "SELECT COUNT(*) REGS "
cQry += "FROM "+RetSQLName("SC7")+" "
cQry += "WHERE D_E_L_E_T_<>'*' AND C7_FILIAL = '"+c_Filial+"' "
cQry += "AND C7_NUM = '"+c_Pedido+"' AND C7_CONAPRO = 'B' "

TCQUERY cQry NEW ALIAS 'QSC7'
DbSelectArea('QSC7')
QSC7->(DbGoTop())
lAchou := QSC7->REGS <> 0
QSC7->(DbCloseArea())

IF lAchou
	ShowHelpDlg('CT_PEDBLOQ',{'Nใo ้ permitido a revisใo de datas de ','entrega de pedidos bloqueados.'},5,{'Aguarde a libera็ใo do pedido para ','realizar esta opera็ใo.'},5)
	Return
ENDIF


oMainWnd:ReadClientCoors()
nTop	:= 0
nLeft	:= 0
nBottom	:= oMainWnd:nBottom-27
nRight	:= oMainWnd:nRight-9


//Aadd(aButtons,{"CLIPS",{|| U_BuscaAnex() },"Anexo" })

oFont1 := TFont():New("Arial",,24,,.T.,,,,.F.,.F.)

oDlg1      := MSDialog():New( nTop,nLeft,nBottom,nRight,"Revisใo da Data de Entrega",,,.F.,,,,,,.T.,,,.T. )

oDlg1:bInit := {|| EnchoiceBar(oDlg1,bOk,bCancel,.F.,aButtons)}

oSay1      := TSay():New( 036,010,{||"Filial:"},		  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay2      := TSay():New( 064,010,{||"Pedido:"},		  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay3      := TSay():New( 092,010,{||"Item De:"},		  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay4      := TSay():New( 092,370,{||"Item At้:"},		  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay5      := TSay():New( 120,010,{||"Produto:"},		  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay6      := TSay():New( 148,010,{||"Descri็ใo:"},	  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay7      := TSay():New( 176,010,{||"Dt. Entrega Rev:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay8      := TSay():New( 120,370,{||"Produto:"},		  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)
oSay9      := TSay():New( 148,370,{||"Descri็ใo:"},	  oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,90,15)

oGet1      := TGet():New( 032,094,{|u| IF(Pcount()>0,cGet1:= u,cGet1)},oDlg1,130,014,'',,CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet2      := TGet():New( 060,094,{|u| IF(Pcount()>0,cGet2:= u,cGet2)},oDlg1,025,014,'',,CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet3      := TGet():New( 088,094,{|u| IF(Pcount()>0,cGet3:= u,cGet3)},oDlg1,010,014,'',{|| f_VldGet(1)},CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,{|| f_Change(1)},.F.,.F.,"","",,)
oGet4      := TGet():New( 088,434,{|u| IF(Pcount()>0,cGet4:= u,cGet4)},oDlg1,010,014,'',{|| f_VldGet(2)},CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,{|| f_Change(2)},.F.,.F.,"","",,)
oGet5      := TGet():New( 116,094,{|u| IF(Pcount()>0,cGet5:= u,cGet5)},oDlg1,080,014,'',,CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet6      := TGet():New( 144,094,{|u| IF(Pcount()>0,cGet6:= u,cGet6)},oDlg1,248,014,'',,CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet7      := TGet():New( 172,094,{|u| IF(Pcount()>0,cGet7:= u,cGet7)},oDlg1,030,014,'',{|| f_VldGet(3)},CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet8      := TGet():New( 116,434,{|u| IF(Pcount()>0,cGet8:= u,cGet8)},oDlg1,080,014,'',,CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet9      := TGet():New( 144,434,{|u| IF(Pcount()>0,cGet9:= u,cGet9)},oDlg1,248,014,'',,CLR_BLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oGet1:Disable()
oGet2:Disable()
oGet5:Disable()
oGet6:Disable()
oGet8:Disable()
oGet9:Disable()

oDlg1:Activate(,,,.T.,{|| nOpca == 1})


IF nOpca == 1
	Begin Transaction
		f_GravaInf()
	End Transaction		
ENDIF

Return

    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscaAnex บ Autor ณFabrica TOTVS Bahia บ Data ณ  28/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para inclusao do Conhecimento.					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGCT/SIGACOM											  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ										  บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BuscaAnex()

IF Empty(cGet3) .OR. Empty(cGet4) .OR. Empty(cGet7)
	
	f_TudoOk()
	Return

ENDIF

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(c_Filial+c_Pedido+StrZero(1,TamSX3('C7_ITEM')[1]))

MsDocument("SC7",SC7->(Recno()),3,,1) 

Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_GravaInfบ Autor ณFabrica TOTVS Bahia บ Data ณ  28/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para validacao do item informado na Revisao de Data บฑฑ
ฑฑบ          ณ de entrega dos Pedidos de Compras.						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGCT/SIGACOM											  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ										  บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_GravaInf()

Local c_Qry

c_Qry := "UPDATE "+RetSQLName("SC7")+" "
c_Qry += "SET C7_DATPRF = '"+DTOS(cGet7)+"' "
c_Qry += "WHERE D_E_L_E_T_<>'*' AND C7_FILIAL = '"+c_Filial+"' "
c_Qry += "AND C7_NUM = '"+c_Pedido+"' AND C7_ITEM BETWEEN '"+cGet3+"' AND '"+cGet4+"' "

TCSQLEXEC(c_Qry)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_ValidIt บ Autor ณFabrica TOTVS Bahia บ Data ณ  28/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para validacao do item informado na Revisao de Data บฑฑ
ฑฑบ          ณ de entrega dos Pedidos de Compras.						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGCT/SIGACOM											  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ										  บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_VldGet(xVar)
                  
Local l_Achou	:= .F.
Local l_Ret		:= .T.
Local c_Item
Local c_Qry
Local nX

      
IF ( IIF(xVar = 1,Empty(cGet3),IIF(xVar = 2,Empty(cGet4),IIF(xVar = 3,Empty(cGet7),))) )
	
	f_TudoOk()
	Return .F.

ENDIF
	
IF cValToChar(xVar) $ '1,2'

	c_Item := IIF(xVar = 1,cGet3,IIF(xVar = 2,cGet4,)) 

	c_Qry := "SELECT C7_ITEM "
	c_Qry += "FROM "+RetSQLName("SC7")+" C7 INNER JOIN "
	c_Qry += RetSQLName("SB1")+" B1 ON C7_PRODUTO = B1_COD "
	c_Qry += "WHERE C7.D_E_L_E_T_<>'*' AND B1.D_E_L_E_T_<>'*' "
	c_Qry += "AND C7_FILIAL = '"+c_Filial+"' AND C7_NUM = '"+c_Pedido+"' "
	c_Qry += "ORDER BY C7_ITEM "
	
	TCQUERY c_Qry NEW ALIAS 'QRY1'
	DbSelectArea('QRY1')
	QRY1->(DbGoTop())
	WHILE QRY1->(!EOF())
	
		IF QRY1->C7_ITEM == c_Item

			l_Achou := .T.
	     	EXIT

		ENDIF

		QRY1->(!DbSkip())		

	ENDDO

	IF !l_Achou .AND. !Empty(c_Item)
		ShowHelpDlg('CT_ITNOEXIST',{'O item informado nใo corresponde ao pedido de compras em questใo.'},5,{''},5)
		l_Ret := .F.
	ENDIF

	QRY1->(DbCloseArea())

	IF l_Ret .AND. xVar == 2 .AND. !Empty(cGet4) .AND. cGet4 < cGet3
		ShowHelpDlg('CT_ITMENOR',{'O item final nใo deve ser menor que o inicial.'},5,{''},5)
		l_Ret := .F.
	ENDIF

ELSEIF xVar == 3
	
ENDIF

Return(l_Ret)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ f_Change บ Autor ณFabrica TOTVS Bahia บ Data ณ  28/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao executada quando o controle modifica o valor da 	  บฑฑ
ฑฑบ          ณ variavel associada.										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGCT/SIGACOM											  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ										  บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_Change(xVar)
             
Local c_Produto

IF xVar == 1

	c_Produto := Posicione("SC7",1,c_Filial+c_Pedido+cGet3,"C7_PRODUTO")
	
	cGet4 := Space(TamSX3('C7_ITEM')[1])
	cGet5 := c_Produto
	cGet6 := Posicione("SB1",1,xFilial("SB1")+c_Produto,"B1_DESC")
	cGet8 := Space(TamSX3('C7_PRODUTO')[1])
	cGet9 := Space(TamSX3('B1_DESC')[1])
	               
	oGet4:Refresh()	      
	oGet5:Refresh()
	oGet6:Refresh()
	oGet8:Refresh()
	oGet9:Refresh()	
	
ELSEIF xVar == 2
                           
	c_Produto := Posicione("SC7",1,c_Filial+c_Pedido+cGet4,"C7_PRODUTO")

	cGet8 := c_Produto
	cGet9 := Posicione("SB1",1,xFilial("SB1")+c_Produto,"B1_DESC")
	      
	oGet8:Refresh()
	oGet9:Refresh()
	
ENDIF

oDlg1:Refresh()

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ f_TudoOk บ Autor ณFabrica TOTVS Bahia บ Data ณ  28/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao de validacao ao clicar no botao "Ok".			 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGCT/SIGACOM											  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ										  บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_TudoOk()

Local l_Ret := .T.
Local c_Qry

IF Empty(cGet3) .OR. Empty(cGet4) .OR. Empty(cGet7)
     
	ShowHelpDlg('CT_CPOVAZIO',{'Todos os campos devem estar preenchidos para prosseguir.'},5,{''},5)
	l_Ret := .F.

ENDIF

Return(l_Ret)