User Function CondPag
	Local d_Data  := stod('20130325')
	Local n_Total := 1000

	a_Cond     := {3,42,7,14,21,28}
	n_Parcelas := a_Cond[1]
	n_Interval := a_Cond[2]

	d_DatVenc  := DaySum(d_Data, n_Interval)
	alert(dtos(d_datvenc))
/*
	If d_DatVenc > 
	Else

	For i:=1 To (n_Parcelas)
		d_DatVenc := DaySum(DaySum(d_DatVenc, n_Interval),  + (n_Interv * i))
		If (d_DatVenc >= MV_PAR05) .And. (d_DatVenc <= MV_PAR06)
			alert()
		Endif
	Next
*/
Return