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