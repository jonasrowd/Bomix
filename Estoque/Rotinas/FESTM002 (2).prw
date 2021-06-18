User Function FESTM002
	a_Area  := GetArea()
	c_Alias := Alias()
	c_Lote  := (c_Alias)->D3_LOTECTL

	If Empty(c_Lote)
		a_AreaSD5 := SD5->(GetArea())
	
		dbSelectArea("SD5")
		dbSetOrder(3)
		If dbSeek(xFilial("SD5") + (c_Alias)->(D3_NUMSEQ + D3_COD + D3_LOCAL))
			c_Lote := SD5->D5_LOTECTL
		Endif
	
		RestArea(a_AreaSD5)
	Endif

	RestArea(a_Area)
Return c_Lote