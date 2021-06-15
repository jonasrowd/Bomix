#INCLUDE "APVT100.CH"
#INCLUDE "PROTHEUS.CH" 

User Function CB025AUT()
	a_PEAux    :=PARAMIXB[1]
	c_OP	   :=PARAMIXB[2]	
	c_Operacao :=PARAMIXB[3]         
	c_Transac  :=PARAMIXB[4]
	c_Produto  :=PARAMIXB[5]
	c_Recurso  :=PARAMIXB[6]
	c_Operador :=PARAMIXB[7] 
	c_TipAtu   :=PARAMIXB[8]
	n_Qtd      :=PARAMIXB[9]
	d_DtIni    :=PARAMIXB[10]
	c_HrIni    :=PARAMIXB[11]
	d_DtFim    :=PARAMIXB[12]
	c_HrFim    :=PARAMIXB[13]
	c_Lote     :=PARAMIXB[14]
	d_Valid    :=PARAMIXB[15]
	
	If VTYesNo("Deseja continuar a realizar apontamentos da ordem de produ��o " + AllTrim(c_Op) + "?", "Aten��o ", .T.)
	 	aadd(a_PEAux, {"H6_FSPT", "P", Nil})
	Endif
Return a_PEAux