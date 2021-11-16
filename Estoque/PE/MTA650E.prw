#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} MTA650E
Este ponto de entrada está sendo utilizado para remover o campo de OP e Item OP no pedido de Vendas.
@type Function
@version 12.1.25
@author Jonas Machado
@since 10/11/2021
@return logical, l_Ret
/*/
User Function MTA650E()
	a_Area := GetArea()
	l_Ret  := .T.

	// ver update para atualizar a tabela SC6 - VICTOR - 24/07/2020
	If !Empty(SC2->C2_PEDIDO)
		a_AreaSC6 := SC6->(GetArea())
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6") + SC2->C2_PEDIDO + SC2->C2_ITEMPV)
			RecLock("SC6", .F.)
				SC6->C6_OP     :="02"
				SC6->C6_NUMOP  := ""
				SC6->C6_ITEMOP := ""
			MsUnlock()
		Endif
		RestArea(a_AreaSC6)
	Endif

	RestArea(a_Area)
Return l_Ret
