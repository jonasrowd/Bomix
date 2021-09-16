User Function MT680GD3
	Local cProduto    := PARAMIXB[1] // H6_PRODUTO
	Local cOp         := PARAMIXB[2] // H6_OP
	Local cIdentOpPai := PARAMIXB[3] // H6_IDENT
	Local lRet        := PARAMIXB[4] // Retorno
	a_Area   := GetArea()
	If !lRet .And. (cProduto=='MP'+Space(13))       
		lRet := .T.
	EndIf
	RestArea(a_Area)
Return lRet            




