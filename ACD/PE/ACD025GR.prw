User Function ACD025GR  
	cOp       := PARAMIXB[1]
	cOperacao := PARAMIXB[2]
	cRecurso  := PARAMIXB[3]
	cOperador := PARAMIXB[4]
	nQtd      := PARAMIXB[5]
	cTransac  := PARAMIXB[6]               
	a_Area    := GetArea()
	a_AreaSC2 := SC2->(GetArea())
	a_AreaSH6 := SH6->(GetArea())

	dbSelectArea("SH6")
	SH6->(dbSetOrder(1))
	If SH6->(dbSeek(xFilial("SH6") + cOp))
		If SH6->H6_PT == "T" .And. SH6->H6_FSPT == "P"
			RecLock("SH6", .F.)
			SH6->H6_PT := "P"
			MsUnlock()

			dbSelectArea("SC2")
			SC2->(dbSetOrder(1))
			If SC2->(dbSeek(xFilial("SC2") + cOp))
				RecLock("SC2", .F.)
				SC2->C2_DATRF := Ctod("  /  /  ")
				MsUnlock()
			Endif			
		Elseif SH6->H6_PT == "T"  .And. SH6->H6_FSPT <> "P"
			dbSelectArea("SC2")
			SC2->(dbSetOrder(1))
			If SC2->(dbSeek(xFilial("SC2") + cOp))
				RecLock("SC2", .F.)
				SC2->C2_DATRF := DDATABASE
				MsUnlock()
			Endif		
		Endif
	Endif

	RestArea(a_AreaSH6)	
	RestArea(a_AreaSC2)
	RestArea(a_Area)
Return