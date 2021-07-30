#Include "Totvs.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} FFATVATR
Retorna se há títulos vencidos do cliente
@type function
@version 12.1.25
@author jonas.machado
@since 28/07/2021
@param pCliente, variant, Código do cliente
@param pLoja, variant, Número da Loja
@return variant, Soma dos títulos em aberto
/*/
user function FFATVATR(pCliente, pLoja)
	Local nRet 	:= 0 
	Local aArea	:= GetArea()
	Local c_Qry	:=""

	If (FwCodFil() != "030101")
		c_Qry := " SELECT isnull(sum(SE1.E1_SALDO),0) as SALDO FROM " + RetSqlName("SE1") + " SE1 " + chr(13) + chr(10)
		c_Qry += " WHERE SE1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
		c_Qry += " AND SE1.E1_CLIENTE = '" + pCliente + "' " + chr(13) + chr(10)
		c_Qry += " AND SE1.E1_LOJA = '" + pLoja + "' " + chr(13) + chr(10)
		c_Qry += " AND E1_VENCREA < '"+dtos(dDataBase)+"' " + chr(13) + chr(10)
		c_Qry += " AND 0 < SE1.E1_SALDO AND E1_TIPO = 'NF' AND E1_VENCREA >= '20200101'" + chr(13) + chr(10)
		TCQUERY c_Qry NEW ALIAS "QRY"

		DBSelectArea("QRY")
		DBGoTop()
		If (!EOF())
			nRet := SALDO
		EndIf
		DBCloseArea()

	EndIf
	RestArea(aArea)
	FwFreeArray(aArea)
Return (nRet)
