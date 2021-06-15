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