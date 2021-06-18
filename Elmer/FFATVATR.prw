#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"

user function FFATVATR(pCliente, pLoja)
Local nRet := 0 
Local aArea    := GetArea()
Local c_Qry:=""	
	
	c_Qry := " SELECT isnull(sum(SE1.E1_SALDO),0) as SALDO FROM " + RetSqlName("SE1") + " SE1 " + chr(13) + chr(10)
	c_Qry += " WHERE SE1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
	c_Qry += " AND SE1.E1_CLIENTE = '" + pCliente + "' " + chr(13) + chr(10)
	c_Qry += " AND SE1.E1_LOJA = '" + pLoja + "' " + chr(13) + chr(10)
	c_Qry += " AND convert(char,DATEADD(DAY,1,SE1.E1_VENCREA) ,112) < '"+dtos(date())+"' " + chr(13) + chr(10)
    c_Qry += " AND rTrim(SE1.E1_BAIXA) = '' AND  SE1.E1_STATUS = 'A' AND SE1.E1_VALOR >= SE1.E1_SALDO " + chr(13) + chr(10)

		
	TCQUERY c_Qry NEW ALIAS "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())
	If !QRY->(EoF())
		nRet := QRY->SALDO
	Else
		nRet := 0
	Endif
	
	QRY->(dbCloseArea())		
	
RestArea(aArea)		
return nRet