#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"

/*{Protheus.doc} FFATVATR
Rotina para consulta SQL no banco, dos clientes que possuem retrições financeiras
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_FFATVATR()
/*/

user function FFATVATR(pCliente, pLoja)
Local nRet := 0 
Local aArea    := GetArea()
Local c_Qry:=""	
	
	c_Qry := " SELECT isnull(sum(SE1.E1_SALDO),0) as SALDO FROM " + RetSqlName("SE1") + " SE1 " + chr(13) + chr(10)
	c_Qry += " WHERE SE1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
	c_Qry += " AND SE1.E1_CLIENTE = '" + pCliente + "' " + chr(13) + chr(10)
	c_Qry += " AND SE1.E1_LOJA = '" + pLoja + "' " + chr(13) + chr(10)
	c_Qry += " AND convert(char,DATEADD(DAY,1,SE1.E1_VENCREA) ,112) < '"+dtos(date())+"' " + chr(13) + chr(10)
    c_Qry += " AND 0 < SE1.E1_SALDO AND E1_TIPO = 'NF' " + chr(13) + chr(10)

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
