#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPCPG001   ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para gerar o lote sequencial da ordem de produção, º±±
±±º          ³ caso o produto tenha rastreabilidade.					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function FPCPG001
	Local c_Lote   := ''
	Local n_Seq    := 1

	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'				//Verifica se o produto possui rastreabilidade
		c_Qry := f_Qry()                    //Chama a função para selecionar o lote de maior sequencial da OP

		TCQUERY c_Qry NEW ALIAS QRY
		dbSelectArea("QRY")
		dbGoTop()
		If QRY->(!Eof()) .And. !Empty(QRY->H6_LOTECTL)		               //Se existir o maior lote, incrementa o sequencial com a variável n_Seq
			n_Seq += Val(SubStr(QRY->H6_LOTECTL,9,2))
		Endif
		c_Lote := SubStr(M->H6_OP,1,8) + StrZero(n_Seq, 2, 0)	//O lote retornado será o número da OP mais o sequencial

		dbCloseArea("QRY")
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f_Qry     ºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Query para selecionar o maior lote apontado da ordem de    º±±
±±º          ³ produção atual.			                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
Static Function f_Qry
	c_Qry := " SELECT MAX(H6_LOTECTL) H6_LOTECTL FROM " + RETSQLNAME("SH6") + " WHERE H6_LOTECTL LIKE '" + SubStr(M->H6_OP, 1, 8) + "%' AND " + CHR(13)
	c_Qry += " H6_FILIAL = '" + XFILIAL("SH6") + "' AND D_E_L_E_T_ <> '*' " + CHR(13)

	MemoWrit("C:\FPCPG001.sql",c_Qry)
Return c_Qry
*/
//#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPCPG001   ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para gerar o lote sequencial da ordem de produção, º±±
±±º          ³ caso o produto tenha rastreabilidade.					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
User Function FPCPG001
	Local c_Lote := ''
	Local c_Seq  := ""

	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'				//Verifica se o produto possui rastreabilidade
		c_Qry := f_Qry()                    //Chama a função para selecionar o lote de maior sequencial da OP

		TCQUERY c_Qry NEW ALIAS QRY
		dbSelectArea("QRY")
		dbGoTop()
		If QRY->(!Eof())                    //Se existir o maior lote, incrementa o sequencial com a variável c_Seq
			c_Seq += QRY->Z3_SEQ
		Endif
		c_Lote := SubStr(M->H6_OP,1,6) + c_Seq	//O lote retornado será o número da OP mais o sequencial

		dbCloseArea("QRY")
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)

Static Function f_Qry
	c_Qry := " SELECT MAX(Z3_SEQ) Z3_SEQ FROM " + RETSQLNAME("SZ3") + " WHERE Z3_NUMOP = '" + SubStr(M->H6_OP,1,11) + "' AND " + CHR(13)
	c_Qry += " Z3_FILIAL = '" + XFILIAL("SZ3") + "' AND D_E_L_E_T_ <> '*' " + CHR(13)

	MemoWrit("C:\FPCPG001.sql",c_Qry)
Return c_Qry
*/

//	Criado por Christian Rocha 21/02/2013 - Novo gatilho para o número de lote
User Function FPCPG001
	Local c_Lote   := ''                                                                                                       
//	Local c_Mes    := StrZero(Month(M->H6_DATAFIN), 2)
	Local c_Ano    := cValToChar(Year(M->H6_DATAFIN))
	Local n_Semana := 0
    Local c_sigla    := ''
	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()





	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'				//Verifica se o produto possui rastreabilidade
		If cFilAnt == "020101"    // Verifica se a empresa é SOPRO   -----   incluso por Victor em 17/07/19 

			dbSelectArea("SA7")
			dbGoTop()
			dbSetOrder(2)
			dbSeek(xFilial("SA7")+M->H6_PRODUTO)  
			DO WHILE !EOF()
				IF ALLTRIM(SA7->A7_FSSIGLA)<>'' .AND. ALLTRIM(M->H6_PRODUTO)=ALLTRIM(SA7->A7_PRODUTO) .AND. ALLTRIM(SUBSTR(cFilAnt,1,4))=ALLTRIM(SA7->A7_FILIAL) 
				c_sigla=ALLTRIM(SA7->A7_FSSIGLA)
			  	EXIT
				ENDIF
				SKIP
			ENDDO     
			

//			c_sigla=ALLTRIM(SA7->A7_FSSIGLA)     
			IF c_sigla<>''
					c_Lote := SUBSTR(M->H6_OP,1,6)+SUBSTR(M->H6_OP,8,1)+SUBSTR(M->H6_OP,11,1)+ALLTRIM(c_sigla)   // cria a estrutura do número do lote incluindo a SIGLA solicitada pelo Fornecedor -----   incluso por Victor em 30/10/19      
			else  
					c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)   // cria a estrutura do número do lote -----   incluso por Victor em 17/07/19 
			endif             
				
//			c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)   // cria a estrutura do número do lote -----   incluso por Victor em 17/07/19 
//					c_Lote := SUBSTR(M->H6_OP,1,6)+SUBSTR(M->H6_OP,7,1)+SUBSTR(M->H6_OP,9,1)+ALLTRIM(SA7->A7_SIGLA)   // cria a estrutura do número do lote incluindo a SIGLA solicitada pelo Fornecedor -----   incluso por Victor em 30/10/19 

		Else   
		
			c_Qry := f_Qry()                    //Chama a função para selecionar o lote de maior sequencial da OP
	
			TCQUERY c_Qry NEW ALIAS QRY
			dbSelectArea("QRY")
			dbGoTop()
			If QRY->(!Eof())
				n_Semana := QRY->SEMANA
			Endif
	
			c_Lote := StrZero(n_Semana, 2, 0) + SB1->B1_GRUPO + c_Ano  
			 
		
			
			QRY->(dbCloseArea())
		Endif
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)




Static Function f_Qry

//	c_Qry := " SELECT DATEPART(WEEK, '" + DTOS(M->H6_DATAFIN) + "') AS SEMANA "
c_Qry := "Select Case when Datepart(WEEKDAY,'" + DTOS(M->H6_DATAFIN) + "') = 1 then Datepart(WEEK,'"+ DTOS(M->H6_DATAFIN) + "') - 1 else Datepart(WEEK,'"+ DTOS(M->H6_DATAFIN) + "') end AS SEMANA " 

// CONSULTA ACIMA CONSIDERA O DOMINGO COMO A SEMANA ANTERIOR - ALTERADO POR VICTOR SOUSA
	MemoWrit("C:\FPCPG001.sql",c_Qry)      
	
Return c_Qry     




IF SELECT("SM0") <> 0
	SM0->(DbCloseArea())
ENDIF	

// DbUseArea(.T.,"DBFCDX","\sigaadv\sigamat.emp","SM0", .T., .F.)  


DbUseArea(.T.,"DBFCDX","\system\sigamat.emp","SM0", .T., .F.)  


/*

DbSelectArea("SM0")
SM0->(DbGoTop())
WHILE SM0->(!EOF())

	IF cEmpAnt == SM0->M0_CODIGO
	
		DbSelectArea("ZB0")
		DbSetOrder(1)
		DbSeek(SM0->M0_CODFIL)
		IF ZB0->(Found())
		
			RecLock("ZB0",.F.)
			
		ELSE	
                              
			RecLock("ZB0",.T.)
			
		ENDIF
		                                 
		ZB0->ZB0_FILIAL	:= Space(TamSX3("ZB0_FILIAL")[1])
		ZB0->ZB0_CODFIL	:= SM0->M0_CODFIL
		ZB0->ZB0_NMFIL	:= SM0->M0_FILIAL
		
		ZB0->(MsUnlock())
		
	ENDIF
	
	SM0->(DbSkip())
	
ENDDO

*/













