	
  
DBSelectArea('SB2')   
DBGOTOP()
	
While !Eof()	
   IF SB2->B2_VFIM1 > 0 .AND. SB2->B2_VFIM1 > 0 .OR. SB2->B2_VFIM1 > 0  	
	
	
	
	
	Local c_CRLF := chr(13) + chr(10)
	c_Qry := " BEGIN TRAN " + c_CRLF
	c_Qry += " SELECT (D2_FILIAL, D2_COD, D2_PRCVEN, D2_VALIPI, D2_VALICM, D2_EMISSAO) FROM SD2010 SD2 " + c_CRLF
	c_Qry += " 	WHERE SD2.D_E_L_E_T_<>'*'  AND D2_FILIAL = '" + xFilial("SD2") AND (D2_EMISSAO >= '20170101' AND D2_EMISSAO <= '20170131' ) + "')" + c_CRLF 
	c_Qry += " ORDER BY D2_EMISSAO "      
	
	
	TCQUERY c_Qry NEW ALIAS bQRY
	dbSelectArea("bQRY")
	dbGoTop()   
	Local mpreco = 0.00
   //	If bQRY->(!Eof())
	While bQRY->(!Eof())
	      mpreco := bQRY->D2_PRCVEN
		  bQRY->(dbSkip())
	End
	        
	
	Local c_CRLF := chr(13) + chr(10)
	c_Qry := " BEGIN TRAN " + c_CRLF
	c_Qry += " SELECT (D1_FILIAL, D1_COD, D1_VUNIT, D1_VALIPI, D1_VALICM, D1_EMISSAO) FROM SD1010 SD1 " + c_CRLF
	c_Qry += " 	WHERE SD1.D_E_L_E_T_<>'*'  AND D1_FILIAL = '" + xFilial("SD1") AND (D1_EMISSAO >= '20170101' AND D1_EMISSAO <= '20170131' ) + "')" + c_CRLF 
	c_Qry += " ORDER BY D1_EMISSAO "      
	
	
	TCQUERY c_Qry NEW ALIAS bQRY
	dbSelectArea("bQRY")
	dbGoTop()   
	Local mpreco2 = 0.00
   //	If bQRY->(!Eof())
	While bQRY->(!Eof())
	      mpreco2 := bQRY->D1_VUNIT
		  bQRY->(dbSkip())
	End
	
	
Enddo	
	
	