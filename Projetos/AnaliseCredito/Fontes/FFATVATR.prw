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
User Function FFATVATR(pCliente, pLoja)
	Local nRet		:= 0 
	Local aArea		:= GetArea()
	Local c_Qry		:= ""
	Local xtabela	:= "63"
	Local cFeriado	:= 'N'
	
	DbSelectArea("SX5")
	DbSetOrder(1)
	DbSeek(FWXFILIAL("SX5") + xtabela)
	DbGoTop()

	//Se encontrar um feriado na tabela genérica exatamente igual ao dia não bloqueia o faturamento.
	While !(EOF()) .And. SX5->X5_TABELA == '63'
		If MESDIA(CTOD(SUBSTR(X5_DESCRI,1,5) + "/" + Year2Str(YEAR(DATE())))) == MESDIA(DATE())
			cFeriado := 'S'
		EndIf
		DbSkip()
	End
	//LEMBRAR DE RETIRAR O CASE WHEN ANTES DE LEVAR PRA PRODUÇÃO.
	If (FwCodFil() != "030101" .AND. cValToChar(DOW(DATE())) $ ('2|3|4|5|6') .AND. cFeriado == 'N')
		c_Qry := " SELECT CASE WHEN isnull(sum(SE1.E1_SALDO),0) > 0 THEN 0 END AS SALDO FROM " + RetSqlName("SE1") + " SE1 " + chr(13) + chr(10)
		c_Qry += " WHERE SE1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
		c_Qry += " AND SE1.E1_CLIENTE = '" + pCliente + "' " + chr(13) + chr(10)
		c_Qry += " AND SE1.E1_LOJA = '" + pLoja + "' " + chr(13) + chr(10)
		c_Qry += " AND E1_VENCREA < '"+dtos(dDataBase)+"' " + chr(13) + chr(10)
		c_Qry += " AND SE1.E1_SALDO > 0 AND E1_TIPO = 'NF' AND E1_VENCREA >= '20200101'" + chr(13) + chr(10)
		c_Qry += " AND SE1.E1_SALDO <> SE1.E1_JUROS"
		
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
