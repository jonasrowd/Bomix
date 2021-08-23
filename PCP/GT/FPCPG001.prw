#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPCPG001   ºAutor  ³ Victor Sousa       º      ³           º±±
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

User Function FPCPG001
	Local c_Lote   := ''                                                                                                       
	//	Local c_Mes    := StrZero(Month(M->H6_DATAFIN), 2)
	// Local c_Ano    := cValToChar(Year(M->H6_DATAFIN))
	// Local n_Semana := 0
	Local c_sigla    := ''
	// Local c_Qry    := ''
	// Local c_Qry2    := ''

	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+M->H6_PRODUTO)


	dbSelectArea("SC2")
	RecLock("SC2", .F.)
	//If SC2->C2_QUJE=SC2->C2_QUANT
	If SC2->C2_QUJE=0
		SC2->C2_FSSALDO := SC2->C2_QUANT       
	Endif
	MsUnLock() 
	//SC2->(MsUnlock())


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


			IF c_sigla<>''
				c_Lote := SUBSTR(M->H6_OP,1,6)+SUBSTR(M->H6_OP,8,1)+SUBSTR(M->H6_OP,11,1)+ALLTRIM(c_sigla)   // cria a estrutura do número do lote incluindo a SIGLA solicitada pelo Fornecedor -----   incluso por Victor em 30/10/19      
			else  
				c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)   // cria a estrutura do número do lote -----   incluso por Victor em 17/07/19 
			endif             


		Else   


			//dbSelectArea("SC2")
			// //dbSetOrder(_cOrd)  
			// //dbGoTo(_nReg)
			// c_Lote:=SC2->C2_FSLOTOP

			// IF ALLTRIM(c_Lote)=""
			// 	c_Qry := f_Qry()                    //Chama a função para selecionar o lote de maior sequencial da OP
			// 	TCQUERY c_Qry NEW ALIAS QRY
			// 	dbSelectArea("QRY")
			// 	dbGoTop()
			// 	If QRY->(!Eof())
			// 		n_Semana := QRY->SEMANA
			// 	Endif		
			// 	c_Qry2 := f_Qrylot()                    
			// 	TCQUERY c_Qry2 NEW ALIAS QRY2
			// 	dbSelectArea("QRY2")
			// 	dbGoTop()
			// 	If ALLTRIM(QRY2->A1_FSLT_OP)<>""
			 		c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)   // cria o número do lote baseado na OP -----   Alterado por Jonas em 23/08/21
			// 	Else
			// 		c_Lote := StrZero(n_Semana, 2, 0) + SB1->B1_GRUPO + c_Ano
			// 	Endif

			// 	// GRAVA LOTE NA SC2
			// 	//	RecLock("SC2", .F.)
			// 	//	SC2->C2_FSLOTOP :=   c_Lote       
			// 	//	SC2->(MsUnlock())
			// 	QRY->(dbCloseArea())
			// 	QRY2->(dbCloseArea())
			// Endif
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
	//MemoWrit("FPCPG001.sql",c_Qry)      

Return c_Qry     


Static Function f_Qrylot()

	Local c_CRLF := chr(13) + chr(10)

	c_Qry2 := " SELECT CLI.A1_FSLT_OP								"  + c_CRLF
	c_Qry2 += " FROM " + RetSqlName("SA1") + " CLI (NOLOCK)          "  + c_CRLF
	c_Qry2 += " INNER JOIN " + RetSqlName("SC6") + " PED (NOLOCK) ON "  + c_CRLF
	c_Qry2 += " CLI.A1_COD=PED.C6_CLI                                "  + c_CRLF
	c_Qry2 += " AND CLI.A1_FILIAL=LEFT(PED.C6_FILIAL,4)              "  + c_CRLF
	c_Qry2 += " AND CLI.A1_LOJA=PED.C6_LOJA                          "  + c_CRLF
	c_Qry2 += " INNER JOIN " + RetSqlName("SC2") + " C2 (NOLOCK) ON  "  + c_CRLF
	c_Qry2 += " C2.C2_FILIAL=PED.C6_FILIAL                           "  + c_CRLF
	c_Qry2 += " AND C2.C2_NUM=PED.C6_NUMOP                           "  + c_CRLF
	c_Qry2 += " AND C2.C2_PEDIDO<>''                                 "  + c_CRLF
	c_Qry2 += " AND C2.C2_ITEM=PED.C6_ITEMOP                         "  + c_CRLF
	c_Qry2 += " WHERE CLI.D_E_L_E_T_<>'*'                            "  + c_CRLF
	c_Qry2 += " AND C2.D_E_L_E_T_<>'*'                               "  + c_CRLF
	c_Qry2 += " AND PED.D_E_L_E_T_<>'*'                              "  + c_CRLF
	c_Qry2 += " AND PED.C6_FILIAL= " + xFilial("SC2")                   + c_CRLF
	c_Qry2 += " AND CLI.A1_FSLT_OP='1'							    "  + c_CRLF
	c_Qry2 += " AND C6_NUMOP= '"+LEFT(M->H6_OP,6)+"'"                  + c_CRLF
	c_Qry2 += " GROUP BY  CLI.A1_FSLT_OP                             "  + c_CRLF

	//MemoWrit("Qrylot.sql",c_Qry2) 

Return c_Qry2




//User Function Lotecli
//	c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)   // cria a estrutura do número do lote -----   incluso por Victor em 14/03/19
//Return





/*

IF SELECT("SM0") <> 0
SM0->(DbCloseArea())
ENDIF	


DbUseArea(.T.,"DBFCDX","\system\sigamat.emp","SM0", .T., .F.)  

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















