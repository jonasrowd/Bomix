User Function MT680GD3
Local cProduto    := PARAMIXB[1] // H6_PRODUTO
Local cOp         := PARAMIXB[2] // H6_OP
Local cIdentOpPai := PARAMIXB[3] // H6_IDENT
Local lRet        := PARAMIXB[4] // Retorno
	  If !lRet .And. (cProduto=='MP'+Space(13))       
	      lRet := .T.
	  EndIf
Return lRet            
