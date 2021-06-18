#INCLUDE "PROTHEUS.CH"

USER FUNCTION MT120FIL

Local cRet 		:=""   
Local lCheck    := .T.
Local c_Filial 	:= ""

Public cCombo	:= " "
Public c_Filtro := " "
Public oDlg
 
cRet  :=" "
cCombo:=" "

aItems:={"Pedido Pendente e Pedido Parcialmente Atendido","Pedido Pendente","Pedido Parcialmente Atendido","Pedido Atendido","Pedido Bloqueado",;
         "Elim. Residuo","Utilizado em Pre Documento de Entrada","Autoriza��o de Entrega",;
		 "Integra��o Modulo Gest�o de Contratos","Aguardando Confirma��o do MarketPlace"} 

	cTexto := "FILTRAR LEGENDA"
	DEFINE MSDIALOG oDlg TITLE cTexto FROM 000,000 TO 250,250 PIXEL
	oSay   		:= TSay():New(010,010,{||"SELECIONE O FILTRO"},oDlg,,,,,,.T.,,,90,10)
	oCombo 		:= tComboBox():New(020,010,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItems,100,20,oDlg,,,,,,.T.,,,,,,,,,"cCombo")
	oCBox1      := TCheckBox():New( 040,010,"Filtrar Filial?",{|u|if(PCount()>0,lCheck:=u,lCheck)},oDlg,060,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oBtnOK 		:= TButton():New(100,010,"FILTRAR (F4)",oDlg,{||FILTRAR()},50,20,,,,.T.,,"",,,,.F.)
	oBtnCancel  := TButton():New(100,070,"N�O FILTRA (F5)",oDlg,{||NAO_FILTRA()},50,20,,,,.T.,,"",,,,.F.)
	ACTIVATE MSDIALOG oDlg CENTERED

If lCheck
	c_Filial:= '.AND. C7_FILIAL ="'+xFILIAL("SC7")+'" '
Endif


Do Case 
 case  c_Filtro == "Pedido Pendente e Pedido Parcialmente Atendido"
	 cRet := "((C7_QUJE==0 .And. C7_QTDACLA==0) .OR. (C7_QUJE<>0.And.C7_QUJE<C7_QUANT))" +c_Filial

 case  c_Filtro == "Pedido Pendente"
	 cRet := "C7_QUJE==0 .And. C7_QTDACLA==0" +c_Filial

 case  c_Filtro == "Pedido Parcialmente Atendido"
	 cRet := "C7_QUJE<>0.And.C7_QUJE<C7_QUANT "+c_Filial

 case  c_Filtro == "Pedido Atendido"
	 cRet := "C7_QUJE>=C7_QUANT "+c_Filial
 case  c_Filtro == "Pedido Bloqueado"
	 cRet := 'C7_ACCPROC<>"1" .And.  C7_CONAPRO=="B".And.C7_QUJE < C7_QUANT'+c_Filial

 case  c_Filtro == "Elim. Residuo"
	 cRet := "!Empty(C7_RESIDUO) "+c_Filial

 case  c_Filtro == "Utilizado em Pre Documento de Entrada"
	 cRet := "C7_QTDACLA >0 "+c_Filial

 case  c_Filtro == "Autoriza��o de Entrega"
	 cRet := "C7_TIPO!=nTipoPed"+c_Filial

 case  c_Filtro == "Integra��o Modulo Gest�o de Contratos"
	 cRet := "!Empty(C7_CONTRA).And.Empty(C7_RESIDUO)"+c_Filial

 case  c_Filtro == "Aguardando Confirma��o do MarketPlace'	
	 cRet := ""+c_Filial
 OtherWise
	 cRet := ""
EndCase	 

Return cRet 

Static Function FILTRAR()  
	c_Filtro := cCombo
	oDlg:End()
Return   

Static Function NAO_FILTRAR()
	c_Filtro := ""
	oDlg:End()
Return