#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function PONCALD
	
	Local c_qry := ""
		
	c_qry := "SELECT PB_PD, COUNT(*) AS N_QTD"
	c_qry += " FROM SPB010"
	c_qry += " WHERE PB_FILIAL	= '" + SRA->RA_FILIAL + "'"
	c_qry += " AND PB_MAT 		= '" + SRA->RA_MAT + "'"
	c_qry += " AND PB_DATA		= '" + dtos(ddatabase) + "'"
	c_qry += " AND D_E_L_E_T_ 	<> '*'"
	c_qry += " GROUP BY PB_PD"
	
	TCQUERY c_qry NEW ALIAS "QRY"
	
	dbselectarea("QRY")
	while QRY->(!eof())
		if QRY->N_QTD > 1
			c_qry := "UPDATE SPB010"
			c_qry += " SET D_E_L_E_T_ = '*'" 
			c_qry += " WHERE PB_FILIAL	= '" + SRA->RA_FILIAL + "'"
			c_qry += " AND PB_MAT 		= '" + SRA->RA_MAT + "'"
			c_qry += " AND PB_DATA		= '" + dtos(ddatabase) + "'"
			c_qry += " AND PB_PD		= '" + QRY->PB_PD + "'"
			c_qry += " AND R_E_C_N_O_	= (SELECT MIN(R_E_C_N_O_) FROM SPB010 WHERE PB_FILIAL = '" + SRA->RA_FILIAL + "' AND PB_MAT = '" + SRA->RA_MAT + "' AND PB_DATA	= '" + dtos(ddatabase) + "' AND PB_PD = '" + QRY->PB_PD + "' AND D_E_L_E_T_ <> '*')"

			TCSQLEXEC(c_qry)
		endif
		QRY->(dbskip())
	enddo
	dbselectarea("QRY")
	dbclosearea()

Return