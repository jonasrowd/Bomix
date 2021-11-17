User Function MT150END()

	Local n_Opcx	:= ParamIxb[1]
	Local c_NumCot	:= SC8->C8_NUM
	Local c_NumProp	:= SC8->C8_NUMPRO
	Local c_Query	:= ""
	Local l_Ret 	:= Findfunction("U_FCOMA004")
	
	//--------------------------------------------------------//
	//Executa o envio da cotacao para o fornecedor quando for //
	//Uma nova proposta ou um novo participante.              //
	//--------------------------------------------------------//
	If ( n_Opcx == 4 .And. l150Propost ) .Or. ( n_Opcx == 2 .And. l150Inclui )

		//Integração Fluig
		If l_Ret
			U_FCOMA004( c_NumCot, c_NumProp )
	
			c_Query := " UPDATE " + RETSQLNAME("SC8") + " SET C8_FSSTAT = '' "
			c_Query += " WHERE C8_NUM = '" + c_NumCot + "' AND C8_NUMPRO = '" + c_NumProp + "' AND D_E_L_E_T_ = '' "
			TcSqlExec( c_Query )

		Endif

	EndIf

Return()