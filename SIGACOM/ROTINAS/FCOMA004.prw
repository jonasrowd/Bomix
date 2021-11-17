#Include 'TOTVS.CH'
#Include 'FONT.CH'
#Include 'COLORS.CH'

#Define ENTER CHR(13) + CHR(10)

User Function FCOMA004( c_NumCot, c_Proposta )

	Local c_UrlFluig	:= SuperGetMV( "FS_URLCOT", .F., "http://192.168.254.65:8081/portal/1/cotacao?a=" )
	Local c_Fornec		:= Space(TamSX3("A2_COD")[1])
	Local c_Loja		:= Space(TamSX3("A2_LOJA")[1])
	Local c_Nome		:= Space(TamSX3("A2_NOME")[1])
	Local c_Email		:= Space(TamSX3("A2_EMAIL")[1])
	Local n_Opca		:= 0
	Local c_Body		:= ""
	Local c_Subj		:= "Bomix :: Você possui uma cotação para atualizar"
	Local l_ExibeTela	:= .F.
	Local c_Anexo		:= {}
	Local c_Hash		:= ""
	Local c_Qry			:= ""
	Local c_Filial		:= ""
	Local n_NumFluig	:= 0

	
	Local oServico						:= WSECMWorkflowEngineServiceService():New()
	Local cUsername						:= SuperGetMV("FS_FLGUSER",.F.,"bomix")
	Local cPassword						:= SuperGetMV("FS_FLGPASS",.F.,"bomix@2019")
	Local nCompanyId					:= 1
	Local nChoosedState					:= 11
	Local cComments     				:= "Movimentado automaticamente através do Protheus"
	Local cCuserId 						:= SuperGetMV("FS_FLGID",.F.,"bomix")
	Local lCompleteTask 				:= .T.
	Local processAttachmentDto  		:= ECMWorkflowEngineServiceService_processAttachmentDto():New()
	Local attach						:= ECMWorkflowEngineServiceService_attachment():New()
	Local oWSstartProcesscardData		:= ECMWorkflowEngineServiceService_STRINGARRAYARRAY():New()
	Local oWSstartProcessappointment	:= ECMWorkflowEngineServiceService_processTaskAppointmentDtoArray():New()
	Local LManagerMode					:= .F.
	Local nthreadSequence				:= 0

	Default c_Proposta	:= "01"

	SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oSay2","oGet1","oGet2","oGet3","oGet4","oSBtn1","oSBtn2","oSBtn3")

	BeginSql Alias "QRY"

		SELECT C8_FILIAL, C8_NUM, C8_FORNECE, C8_LOJA, A2_NOME, A2_EMAIL, C8_VALIDA, C8_NUMPRO
		FROM %TABLE:SC8% SC8
		INNER JOIN %TABLE:SA2% SA2 ON SC8.C8_FORNECE = SA2.A2_COD AND SC8.C8_LOJA = SA2.A2_LOJA AND SA2.%NOTDEL%
		AND SA2.A2_FILIAL = %XFILIAL:SA2%
		WHERE SC8.C8_FILIAL = %XFILIAL:SC8%
		AND SC8.%NOTDEL%
		AND SC8.C8_NUM = %EXP:c_NumCot%
		AND SC8.C8_NUMPRO = %EXP:c_Proposta%
		GROUP BY C8_FILIAL, C8_NUM, C8_FORNECE, C8_LOJA, A2_NOME, A2_EMAIL, C8_VALIDA, C8_NUMPRO

	EndSql
	dbSelectArea("QRY")
	While QRY->(!EOF())

		c_Fornec	:= QRY->C8_FORNECE
		c_Loja		:= QRY->C8_LOJA
		c_Nome		:= QRY->A2_NOME
		c_Email		:= QRY->A2_EMAIL//"carlos.eduardo.arcieri@gmail.com"
		c_Filial	:= QRY->C8_FILIAL

		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Definicao do Dialog e todos os seus componentes.                        ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		oFont1     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
		oDlg1      := MSDialog():New( 092,240,230,905,"Atualização de e-mail - Cotação Número: " + c_NumCot,,,.F.,,,,,,.T.,,oFont1,.T. )

		oGrp1      := TGroup():New( 004,004,052,332,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay1      := TSay():New( 016,008,{||"Fornecedor:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oGet1      := TGet():New( 016,052,{|u|if(PCount()>0,c_Fornec:=u,c_Fornec)},oGrp1,032,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)
		oGet2      := TGet():New( 016,088,{|u|if(PCount()>0,c_Loja:=u,c_Loja)}    ,oGrp1,016,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
		oGet3      := TGet():New( 016,108,{|u|if(PCount()>0,c_Nome:=u,c_Nome)}    ,oGrp1,216,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay2      := TSay():New( 036,008,{||"E-mail:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet4      := TGet():New( 032,052,{|u|if(PCount()>0,c_Email:=u,c_Email)},oGrp1,184,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSBtn1     := SButton():New( 055,306,1,{|| n_Opca:=1, oDlg1:End() },oDlg1,,"", )
		oSBtn2     := SButton():New( 055,280,2,{|| n_Opca:=2, oDlg1:End() },oDlg1,,"", )

		oDlg1:Activate(,,,.T.)

		if n_Opca == 1

			dbSelectArea("SA2")
			dbSetOrder(1)
			if dbSeek(XFILIAL("SA2") + c_Fornec + c_Loja )

				RecLock("SA2",.F.)
				SA2->A2_EMAIL	:= c_Email
				MsUnlock()

			endif

			c_Hash	:= MD5( c_Filial + c_Fornec + c_NumCot + c_Proposta + c_Loja, 2 )

			c_Qry := "UPDATE " + RETSQLNAME("SC8") + " "
			c_Qry += "SET C8_FSHASH = '" + c_Hash + "' "
			c_Qry += "WHERE C8_FILIAL = '" + xFilial("SC8") + "' "
			c_Qry += "AND C8_NUM = '" + c_NumCot + "' "
			c_Qry += "AND C8_NUMPRO = '" + c_Proposta + "' "
			c_Qry += "AND C8_FORNECE = '" + c_Fornec + "' "
			c_Qry += "AND C8_LOJA = '" + c_Loja + "' "
			if TCSqlExec( c_Qry ) < 0
				Alert("TCSQLError() " + TCSQLError())
			endif

			c_Body	:= "Prezado Fornecedor: " + Alltrim( Capital( c_Nome ) ) + ",<br/><br/>" + ENTER
			c_Body	+= "Existe uma cotação a ser realizada por vocês para empresa Bomix. Qualquer dúvida entrar em contato com o departamento de compras.<br/>" + ENTER
			c_Body	+= "Importante: Por favor adicionar no campo de observações detalhes complementares ou que afetem a especificação técnica ou comercial" + ENTER
			c_Body	+= "da cotação. Exemplo: Marca do item, condição de pagamento, forma de pagamento, alteração no tipo do material ou cor etc....<br/>" + ENTER
			c_Body	+= "Aguardamos seu interesse!<br/>" + ENTER
			c_Body	+= "<b>Você tem até o dia: " + DTOC( STOD( QRY->C8_VALIDA ) ) + " para responder essa cotação, caso não tenha interesse ou não tenha os produtos solicitados por favor" + ENTER
			c_Body	+= "formalizar para o e-mail: compras@bomix.com.br</b><br/>" + ENTER
			c_Body	+= "<a href=" + c_UrlFluig + c_Hash + ">Clique</a> para acessar sua cotação.<br/>" + ENTER + ENTER
			c_Body	+= "Grato," + SM0->M0_NOMECOM + ENTER
			c_Body	+= "BOMIX INDUSTRIA DE EMBALAGENS LTDA" + ENTER
			c_Body	+= "E-mail: compras@bomix.com.br" + ENTER
			c_Body	+= "Telefone: (71) 3215-8600<br/><br/>" + ENTER
			c_Body	+= "<b>Utilizar preferencialmente o navegador Google Chrome</b>"

			//MemoWrite(c_Fornec + c_NumCot + c_Loja + ".txt",c_Body)

			If !Empty( c_Email )
				c_Email += ";"+SUPERGETMV("FS_MAILCOM",,"compras@bomix.com.br")
				U_TBSENDMAIL( c_Email, c_Body, c_Subj, l_ExibeTela, c_Anexo )
			EndIf

		EndIf

		QRY->(dbSkip())

	EndDo
	QRY->(dbCloseArea())
	
	BeginSql Alias "QRYC1"

		SELECT C1_FSFLUIG
		FROM %TABLE:SC8% SC8
		INNER JOIN %TABLE:SC1% SC1 ON SC8.C8_FILIAL =SC1.C1_FILIAL and SC8.C8_NUMSC = SC1.C1_NUM AND SC1.%NOTDEL%
		WHERE SC8.C8_FILIAL = %XFILIAL:SC8%
		AND SC8.%NOTDEL%
		AND SC8.C8_NUM = %EXP:c_NumCot%
		AND SC8.C8_NUMPRO = %EXP:c_Proposta%
		GROUP BY C1_FSFLUIG

	EndSql


	dbSelectArea("QRYC1")
	While QRYC1->(!EOF())
	
		n_NumFluig := QRYC1->C1_FSFLUIG	
		
		if oServico:saveAndSendTask(cUsername,cPassword,nCompanyId,n_NumFluig,nChoosedState,oServico:oWSstartProcesscolleagueIds,cComments,cCuserId,lCompleteTask,oServico:oWSstartProcessattachments,oServico:oWSstartProcesscardData,oWSstartProcessappointment,LManagerMode,nthreadSequence)
			if oServico:oWSsaveAndSendTaskresult:OWSITEM[1]:citem[1] == "ERROR"

				alert("Erro de Execução ->"+GetWSCError())
			endif
		endif			
	
		QRYC1->(dbSkip())

	EndDo
	QRYC1->(dbCloseArea())

Return()