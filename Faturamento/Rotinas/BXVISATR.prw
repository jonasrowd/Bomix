#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"

/*{Protheus.doc} BXVISATR
Rotina para consulta SQL no banco, dos clientes que possuem retrições financeiras, para a análise de crédito do cliente customizada
@author Elmer Farias
@since 22/01/21
@version 1.0
	@example
	u_BXVISATR()
/*/

user function BXVISATR(pCliente,pLoja)
	
Local aCabec
Local aItens
Local oDlg_2
Local n_cont 	:= 0
Local c_Qry		:=""	
Local c_Cliente :=  pCliente
Local c_Loja 	:=  pLoja
Local lRet


aCabec := { "Número do Título", "Parcela","Data Emissão","Data de Vencimento","Data da Baixa","Data Vencimento Real","Valor","Saldo"}
aItens := {}


	
c_Qry := " SELECT E1_NUM AS NUMERO , E1_PARCELA AS PARCELA, E1_EMISSAO AS DATA_EMISSAO, E1_VENCTO AS DATA_VENC, E1_BAIXA AS DATA_BAIXA, " + chr(13) + chr(10)
c_Qry += "	E1_VENCREA AS DATA_VEC_REAL, E1_VALOR AS VALOR, E1_SALDO AS SALDO, R_E_C_N_O_ AS REC " + chr(13) + chr(10)
c_Qry += " FROM " + RetSqlName("SE1") + " SE1 " + chr(13) + chr(10)
c_Qry += " WHERE SE1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
c_Qry += " AND SE1.E1_CLIENTE = '" + c_Cliente + "' " + chr(13) + chr(10)
c_Qry += " AND SE1.E1_LOJA = '" + c_Loja + "' " + chr(13) + chr(10)
c_Qry += " AND convert(char,DATEADD(DAY,1,SE1.E1_VENCREA) ,112) < '"+dtos(date())+"' " + chr(13) + chr(10)
c_Qry += " AND rTrim(SE1.E1_BAIXA) = '' AND  SE1.E1_STATUS = 'A' AND SE1.E1_VALOR >= SE1.E1_SALDO " + chr(13) + chr(10)

		
TCQUERY c_Qry NEW ALIAS "QRY"

Do While !QRY->(EoF()) 

	AAdd( aItens, {QRY->NUMERO ,QRY->PARCELA ,dtoc(SToD(QRY->DATA_EMISSAO)) ,dtoc(SToD(QRY->DATA_VENC)) ,dtoc(SToD(QRY->DATA_BAIXA)) , dtoc(SToD(QRY->DATA_VEC_REAL)) , alltrim(Transform(QRY->VALOR , "@E 99,999,999,999.99")), alltrim(Transform(QRY->SALDO, "@E 99,999,999,999.99")) , REC } )

	n_cont ++
	QRY->(dbskip())
EndDo

If n_cont == 0	
	aviso(alltrim(SM0->M0_NOMECOM) + " - FINANCEIRO - Aviso",;
	"Não existem títulos em aberto para esse cliente ",{"OK"},1,"Aviso")	
Else
	
	DEFINE MSDIALOG oDlg_2 TITLE 'CONSULTAR TÍTULOS - EM ABERTO' FROM 000, 000 TO 250, 600 PIXEL
	oBrw := TWBrowse():New( NIL,NIL,NIL,NIL,, aCabec,,oDlg_2,,,,,,,,,,,,.T. )
	oBrw:Align := CONTROL_ALIGN_ALLCLIENT
	oBrw:SetArray( aItens )
	oBrw:bLine := { || aItens[ oBrw:nAT ] }
	//oBrw:bLDblClick := { || RetVAR_IXB(aItens, oBrw:nAt), oDlg_2:End() }
	ACTIVATE MSDIALOG oDlg_2 CENTERED
EndIf

QRY->(dbCloseArea())

Return(lRet)