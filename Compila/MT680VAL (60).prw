#INCLUDE 'TOPCONN.CH'
                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT680VAL   ºAutor  ³ Matheus Lima       º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que valida se já foi impressa a etiqueta   ±±
±±º          ³ na inclusão do apontamento de produção. 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT680VAL 

	Local c_Qry := ""
	Local b_retorno := .T.
	Local d_Data    := Stod('20130113')

	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()
    
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial("SC2") + SubStr(M->H6_OP, 1, 11))
	If SC2->C2_EMISSAO 	>= d_Data

		dbSelectArea("SB1")
		dbGoTop()
		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + M->H6_PRODUTO)
			If SB1->B1_RASTRO == 'L'
				c_Qry += "SELECT "+CHR(13)+CHR(10)
				c_Qry += "	0 "+CHR(13)+CHR(10)
				c_Qry += "FROM "+CHR(13)+CHR(10)
				c_Qry += "	"+RetSqlName("SZ3")+" SZ3 "+CHR(13)+CHR(10)
				c_Qry += "WHERE "+CHR(13)+CHR(10)
				c_Qry += "	SZ3.D_E_L_E_T_ <> '*' "+CHR(13)+CHR(10)
				c_Qry += "	AND SZ3.Z3_APONT = 'T' "+CHR(13)+CHR(10)
				c_Qry += "	AND SZ3.Z3_SEQ = '"+SubString(M->H6_LOTECTL,7,3)+"'"+CHR(13)+CHR(10)
				c_Qry += "	AND SZ3.Z3_NUMOP = '" + SubStr(M->H6_OP, 1, 11) + "'"+CHR(13)+CHR(10)
	
				TCQUERY c_Qry NEW ALIAS QRY
				dbSelectArea("QRY")
				dbGoTop()
	
				b_retorno := QRY->(!EoF())
	
				QRY->(dbCloseArea())
	
				If !b_retorno
					Alert("Deve ser feita a impressão de etiquetas antes do apontamento da ordem de produção.")	
				EndIf
			Endif
		Endif
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return b_retorno