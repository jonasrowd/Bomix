#Include "Totvs.ch"

/*/{Protheus.doc} WM330AEX
Este Ponto de Entrada permite personalizar as validações e atualizações de outras tabelas após o estorno da Ordem de Serviço.Localizado no final da Rotina WMSA330EST().
	@type function
	@version  12.1.25
	@author Jonas Machado
	@since 20/07/2021
	@return variant, null
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6783849
/*/
User Function WM330AEX
	Local a_Area  := GetArea()
	Local c_IDDCF := DCF->DCF_ID
	
	dbSelectArea("SZT")
	SZT->(dbSetOrder(2))
	SZT->(dbSeek(xFilial("SZT") + c_IDDCF))
	While SZT->(!EoF()) .And. SZT->ZT_FILIAL + SZT->ZT_IDDCF == xFilial("SZT") + c_IDDCF
		RecLock("SZT", .F.)
		dbDelete()
		MsUnlock()

		SZT->(dbSkip())
	End
	
	RestArea(a_Area)
Return
