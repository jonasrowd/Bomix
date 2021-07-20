#Include "Totvs.ch"

/*/{Protheus.doc} DL150AEX
	Localizado ap�s todo o processo de execu��o ou estorno de uma ou mais Ordens de Servi�o do WMS,; 
	 apenas quando as mesmas s�o executadas manualmente pela rotina de Execu��o de Servi�os (WMSA150).
	@type function
	@version  12.1.25
	@author Jonas Machado
	@since 20/07/2021
	@return variant, Null
/*/
User Function DL150AEX
	Local a_Area  := GetArea()
	Local c_IDDCF := DCF->DCF_ID
	Local n_Opcao := PARAMIXB[1]

	If n_Opcao == 2 //-- Estorno de OS
		dbSelectArea("SZT")
		SZT->(dbSetOrder(2))
		SZT->(dbSeek(xFilial("SZT") + c_IDDCF))
		While SZT->(!EoF()) .And. SZT->ZT_FILIAL + SZT->ZT_IDDCF == xFilial("SZT") + c_IDDCF
			RecLock("SZT", .F.)
			dbDelete()
			MsUnlock()

			SZT->(dbSkip())
		End
	EndIf

	RestArea(a_Area)
Return
