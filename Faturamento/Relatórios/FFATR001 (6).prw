#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณFFATR001  บAutor  ณ CHRISTIAN ROCHA      บ Data ณ DEZ/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo da Ordem de Saํda Bomix						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT - Faturamento                                      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function FFATR001

Private c_Titulo := "ORDEM DE SAอDA"
Private c_Data   := dtoc(DDATABASE)
Private c_Hora   := Time()
Private c_Qry    := ''

CriaPerg("FFATR001")

If !(Pergunte("FFATR001",.T.))
	Return
EndIf
	
RptStatus({|| ImpRel()},c_titulo)

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIMPREL    บAutor  ณCHRISTIAN ROCHA     บ Data ณ   DEZ/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que imprime o relatorio                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function ImpRel()     
	//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
	Private oFont01n	:= TFont():New( "Arial",,18,,.T.,,,,,.F.,.F.) 
	Private oFont02		:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.F.) 
	Private oFont02i	:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.T.)
	Private oFont03		:= TFont():New( "Arial",,14,,.F.,,,,,.F.,.F.)
	Private oFont03n	:= TFont():New( "Arial",,14,,.T.,,,,,.F.,.F.)
	Private oFont04		:= TFont():New( "Arial",,09,,.F.,,,,,.F.,.F.) 
	Private oFont04i	:= TFont():New( "Arial",,09,,.F.,,,,,.F.,.T.)
	Private c_BitMap 	:= "\system\lgrl01.bmp"
	Private n_Lin
	Private n_QuantP	:= 0
	Private n_Pag		:= 1
	Private L			:= 1
	Private n_TotPag	:= 1 //Total de Paginas
	Private l_Rodape    := .F.
	Private n_Vol       := 0
	Private n_Und       := 0

	f_Qry()    //Chama a fun็ใo para gerar a query
		
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If Eof()
		Alert("Nenhum registro encontrado.")
		QRY->(dbCloseArea())
		Return
	End If

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPara contar a quantidade de paginas, tive que imprimir os dados no relatorio, excluir o objetoณ
	//ณoPrn, recriแ-lo e imprimir tudo novamente.                                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For L := 1 TO 2
		oPrn := TMSPrinter():New("ORDEM DE SAอDA")
		oPrn:SetPortrait()  

	 	If L == 2
			oPrn:Setup()
	 	EndIf
	
		oPrn:StartPage()
		dbGoTop()

		While !Eof()
			c_NumPed := QRY->C5_NUM
			a_Lotes := {}
			ImpCabec() //Imprime o cabecalho	

			While !Eof() .And. QRY->C5_NUM == c_NumPed
				c_Lote := QRY->C9_LOTECTL

				If !Empty(c_Lote)
					Aadd(a_Lotes, c_Lote)
				Endif
				
				If Empty(QRY->A7_FSQTDPE)
					n_Vol := Int(QRY->C9_QTDLIB/QRY->B5_QE1)
					n_Und := Int((QRY->C9_QTDLIB/QRY->B5_QE1 - n_Vol) * QRY->B5_QE1)
				Else
					n_Vol := Int(QRY->C9_QTDLIB/QRY->A7_FSQTDPE)
					n_Und := Int((QRY->C9_QTDLIB/QRY->A7_FSQTDPE - n_Vol) * QRY->A7_FSQTDPE)
				Endif

				oPrn:Say(n_lin , 100, MemoLine(QRY->B1_DESC, 50, 1)  	,oFont02,100)
				oPrn:Say(n_lin ,1150, c_Lote ,oFont02,100)
//				oPrn:Say(n_lin ,1550, Dtoc(Stod(QRY->D2_DTVALID))			,oFont02,100)
				If !Empty(n_Vol) .Or. !Empty(n_Und)
					oPrn:Say(n_lin ,1550, cvaltochar(n_Vol) + "/" + cvaltochar(n_Und)			,oFont02,100)
				Endif
//				oPrn:Say(n_lin ,2050, cvaltochar(QRY->C6_QTDVEN - QRY->C6_QTDENT)		,oFont02,100)
				oPrn:Say(n_lin ,2050, cvaltochar(QRY->C9_QTDLIB)		,oFont02,100)
		
                If MLCount(AllTrim(QRY->B1_DESC), 50) > 1
                	For i:=2 To MLCount(AllTrim(QRY->B1_DESC), 50)
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Say(n_lin , 100, MemoLine(QRY->B1_DESC, 50, i)  	,oFont02,100)
					Next i
				Endif

				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
		
				n_Lin += 25
			
				PulaPag(n_Lin)
				dbSkip()
			End
		
			oPrn:Say(n_Lin ,100 , "Lotes Utilizados:",oFont03n,100)
			oPrn:Say(n_Lin ,1050, "Resumo:"			 ,oFont03n,100)
			
           	c_LoteUtil := ''
			For i := 1 To Len(a_Lotes)
				c_LoteUtil += a_Lotes[i]
				If i < Len(a_Lotes)
					c_LoteUtil += ", "
				Endif
			Next

			For i := 1 To MLCount(c_LoteUtil, 35)
				n_lin += 50
				PulaPag(n_Lin)
				oPrn:Say(n_Lin ,100 , MemoLine(c_LoteUtil, 35, i) ,oFont02,100)
			Next

			n_lin += 50
			PulaPag(n_Lin)
			oPrn:Line( n_Lin,100,n_Lin,2350 )
	
			ImpRodap()

			If !Eof()
				PulaPag(3300)
			Endif
		End
		
		If L == 2
			oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)
		EndIf
		
//		oPrn:EndPage()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAqui eu reincio as variaveis e guardo a quantidade de paginas.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If L == 1                                                              
			n_TotPag	:= n_Pag
			n_Pag		:= 1
			oPrn:ResetPrinter()  //Exclui o objeto e reinicia suas propriedades.
			oPrn:End()
		Else
			oPrn:Preview()
		EndIf
	Next
	
	QRY->(dbCloseArea())
	
Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIMPCABEC  บAutor  ณ CHRISTIAN ROCHA    บ Data   ณ DEZ/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabecalho da Ordem de Saํda                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function ImpCabec()     

oPrn:SayBitmap( 100,100,c_BitMap,540,150)

oPrn:Say(125,1050, "ORDEM DE SAอDA"			,oFont01n,100)
oPrn:Say(100,1930, "Pแgina",oFont02,100)
oPrn:Say(150,1930, "Data:   " + c_Data + "   " + c_Hora,oFont02,100) 

oPrn:Say(275,1720, "Responsแvel: " + UsrRetName(__CUSERID)	,oFont02,100)

oPrn:Line( 325,100,325,2350 )

oPrn:Say(350 ,100, "Dados do Cliente"	,oFont03n,100)  
oPrn:Say(350,1720, "Nบ Pedido: " + QRY->C5_NUM	,oFont03n,100)  
oPrn:Say(425 ,100, "Cliente:"  			,oFont02i,100)
oPrn:Say(475 ,100, "Endere็o:"			,oFont02i,100)
oPrn:Say(525 ,100, "Bairro:"			,oFont02i,100)
oPrn:Say(525,0950, "Cidade:"	   		,oFont02i,100)
oPrn:Say(525,1720, "Estado:"			,oFont02i,100) 
oPrn:Say(525,2000, "CEP:"				,oFont02i,100) 
oPrn:Say(575 ,100, "Contato:"			,oFont02i,100)  
oPrn:Say(575,0950, "Telefone:"			,oFont02i,100) 

oPrn:Say(425 ,0310, QRY->A1_NOME	   ,oFont02,100)
oPrn:Say(475 ,0310, QRY->A1_END     ,oFont02,100)
oPrn:Say(525 ,0310, Upper(QRY->A1_BAIRRO)  ,oFont02,100)
oPrn:Say(525 ,1130, QRY->A1_MUN ,oFont02,100)
oPrn:Say(525 ,1870, QRY->A1_EST								,oFont02,100)
oPrn:Say(525 ,2110, QRY->A1_CEP		,oFont02,100)
oPrn:Say(575 ,0310, QRY->A1_CONTATO							,oFont02,100)
oPrn:Say(575 ,1130, QRY->A1_TEL,oFont02,100)

oPrn:Line( 650,100,650,2350 )

oPrn:Say(675 ,100 , "Dados do Transporte"				,oFont03n,100)
oPrn:Say(750 ,100 , "Transportadora: "	+ QRY->A4_NREDUZ,oFont02i,100)
oPrn:Say(750 ,1050, "Placa: "							,oFont02i,100)
oPrn:Say(750 ,1720, "Via Transporte: "	+ QRY->A4_VIA	,oFont02i,100)
oPrn:Say(825 ,100 , "Laudo de Vistoria do Caminhใo"		,oFont03n,100)
oPrn:Say(825 ,1050, "Chegada do Caminhใo: ____:____"	,oFont03n,100)

oPrn:Say(900 ,100 , "- LIMPEZA"						,oFont04i,100)
oPrn:Say(950 ,100 , "- CANO DA DESCARGA"			,oFont04i,100)
oPrn:Say(1000,100 , "- PNEUS"						,oFont04i,100)
oPrn:Say(1050,100 , "- CARROCERIA"					,oFont04i,100)
oPrn:Say(1100,100 , "- ASSOALHO"					,oFont04i,100)


oPrn:Say(1150,100 , "- VERIFICACAO DE PRESENวA DE ALERGสNICOS"					,oFont04i,100) 
oPrn:Say(1200,100 , "- VERIFICAวรO DE MATERIAL INAPROPRIADO NO BAฺ DO VEICULO."	,oFont04i,100)
oPrn:Say(1250,100 , "- VERIFICAวรO DE PRESENวA DE ODORES."  					,oFont04i,100)
oPrn:Say(1300,100 , "- VERIFICAวAO DE PRESENวA DE PRAGAS."  					,oFont04i,100)


oPrn:Say(900 ,600 , "[   ] LIMPO"														,oFont04,100)
oPrn:Say(900 ,1100, "[   ] LIBERADO COM RESTRIวีES      [   ] SUJO"						,oFont04,100)

oPrn:Say(950 ,600 , "[   ] INTACTO"														,oFont04,100)
oPrn:Say(950 ,1100, "[   ] LIBERADO COM RESTRIวีES      [   ] FURADO COM VAZAMENTOS"	,oFont04,100)

oPrn:Say(1000,600 , "[   ] EM CONDIวีES DE USO"												,oFont04,100)
oPrn:Say(1000,1100, "[   ] LIBERADO COM RESTRIวีES      [   ] CARECA SEM CONDIวีES DE USO"	,oFont04,100)

oPrn:Say(1050,600 , "[   ] INTACTO"														,oFont04,100)
oPrn:Say(1050,1100, "[   ] LIBERADO COM RESTRIวีES      [   ] SEM CONDIวีES DE USO"		,oFont04,100)

oPrn:Say(1100,600 , "[   ] INTACTO"														,oFont04,100)
oPrn:Say(1100,1100, "[   ] LIBERADO COM RESTRIวีES      [   ] SEM CONDIวีES DE USO"		,oFont04,100)

         




oPrn:Say(1150,1220, "[   ] SIM-BLOQUEAR CARREGAMENTO    [   ] NรO"						,oFont04,100)
oPrn:Say(1200,1220, "[   ] SIM-BLOQUEAR CARREGAMENTO    [   ] NรO"						,oFont04,100)
oPrn:Say(1250,1220, "[   ] SIM-BLOQUEAR CARREGAMENTO    [   ] NรO"						,oFont04,100)
oPrn:Say(1300,1220, "[   ] SIM-BLOQUEAR CARREGAMENTO    [   ] NรO"						,oFont04,100)



oPrn:Say(1375,100 , "Justificativas para libera็๕es com restri็๕es:"					,oFont02i,100)

oPrn:Line( 1475,100,1475,2350 )
oPrn:Line( 1550,100,1550,2350 )
oPrn:Line( 1625,100,1625,2350 )

oPrn:Say(1475,100 , "Previsใo Saํda: "		,oFont03n,100)
oPrn:Say(1475,1050, "Previsใo Entrega: "	,oFont03n,100)

oPrn:Line( 1535,100,1535,2350 )

oPrn:Say(1575,100 , "Produto"				,oFont03n,100)
oPrn:Say(1575,1150, "Lote"   				,oFont03n,100)
//oPrn:Say(1575,1550, "Validade" 				,oFont03n,100)
oPrn:Say(1575,1550, "Vol/Und" 				,oFont03n,100)
oPrn:Say(1575,2050, "Quantidade"			,oFont03n,100)

oPrn:Line( 1625,100,1625,2350 )

n_Lin:= 1675

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณImpRodap  บAutor  ณCHRISTIAN ROCHA       บ Data ณ Abril/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabecalho do Orcamento.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function ImpRodap()
	l_Rodape := .T.
	PulaPag(n_Lin + 825)

	oPrn:Say(n_Lin ,100 , "Outros Lotes:",oFont03n,100)
	oPrn:Say(n_Lin ,1700, "CARREGAMENTO:",oFont03n,100)

	n_lin += 50
	oPrn:Say(n_Lin ,1700, "INอCIO:"					,oFont03n,100)
	oPrn:Say(n_Lin ,1830, "___/___/_____   ___:___" ,oFont03n,100)
		
	n_lin += 50  
	oPrn:Say(n_Lin ,1700, "FIM:"					,oFont03n,100)
	oPrn:Say(n_Lin ,1830, "___/___/_____   ___:___" ,oFont03n,100)

	n_lin += 75
	oPrn:Line( n_Lin,100,n_Lin,2350 )   
	           
	n_lin += 50	
	oPrn:Say(n_Lin,100,"VISTORIA FINAL DA CARGA: RESPONSAVEL (LIDER DE EXPEDIวรO) ASS.____________________________________________",oFont04,100) 
		
	n_lin += 250
	oPrn:Line( n_Lin,100,n_Lin,2350 )
	oPrn:Line( n_Lin,100,n_Lin + 400,100 )		//Linha vertical 1
//	oPrn:Line( n_Lin,1220,n_Lin + 400,1220 )	//Linha vertical 2
	oPrn:Line( n_Lin,2350,n_Lin + 400,2350 )	//Linha vertical 3
	
	n_lin += 50
	oPrn:Say(n_Lin ,300 , "Almoxarifado Recebido Ordem Saํda",oFont02i,100)
	oPrn:Say(n_Lin ,1500, "Almoxarifado Conferido e Despachado",oFont02i,100)
	
	n_lin += 75
	oPrn:Say(n_Lin ,120, "Data: ___/___/______as___:___Ass:_______________        Data: ___/___/______as___:___Ass:_______________",oFont02,100)

	n_lin += 75  
	oPrn:Line( n_Lin,100,n_Lin,2350 )
	
	n_lin += 50
	oPrn:Say(n_Lin ,300 , "Transportadora Recebido e Conferido",oFont02i,100)
	oPrn:Say(n_Lin ,1500, "Motorista Conferido e Recebido",oFont02i,100)
	
	n_lin += 75
	oPrn:Say(n_Lin ,120, "Data: ___/___/______as___:___Ass:_______________        Data: ___/___/______as___:___Ass:_______________",oFont02,100)
	
	n_lin += 75  
	oPrn:Line( n_Lin,100,n_Lin,2350 )

Return
 
/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณPULAPAG   บAutor  ณCHRISTIAN ROCHA     บ Data ณ Abril/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel por gerar nova pagina e imprimir as      บฑฑ
ฑฑบ          ณinformacoes restantes.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function PulaPag(Linha)

	If (Linha > 3275)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSo deve imprimir o total de paginas quando for a 2 vezณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If L == 2
			oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)  
		EndIf

		oPrn:EndPage()
		n_Pag++

		oPrn:StartPage()
		oPrn:SayBitmap( 100,100,c_BitMap,540,150)
					
		oPrn:Say(125,1050, "ORDEM DE SAอDA"			,oFont01n,100)
		oPrn:Say(275,1720, "Responsแvel: " + UsrRetName(__CUSERID)	,oFont02,100)	
		
		oPrn:Say(100,1930, "Pแgina",oFont02,100)
		oPrn:Say(150,1930, "Data:   " + c_Data + "   " + c_Hora,oFont02,100) 

		oPrn:Line( 325,100,325,2350 )	
		n_Lin:= 350
		
		If !l_Rodape
			oPrn:Say(n_Lin,100 , "Produto"				,oFont03n,100)
			oPrn:Say(n_Lin,1150, "Lote"   				,oFont03n,100)
//			oPrn:Say(n_Lin,1550, "Validade" 			,oFont03n,100)
			oPrn:Say(n_Lin,1550, "Vol/Und" 				,oFont03n,100)
			oPrn:Say(n_Lin,2050, "Quantidade"			,oFont03n,100)

			n_Lin += 50

			oPrn:Line( n_Lin,100,n_Lin,2350 )
		Endif
	EndIf

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIMPOBS    บAutor  ณCHRISTIAN ROCHA     บ Data ณ Abril/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel imprimir a observacao do orcamento conforบฑฑ
ฑฑบ          ณme a largura da pagina.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function CriaPerg(c_Perg)

a_MV_PAR01 := {}
a_MV_PAR02 := {}

//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Pedido de Venda de ?"   ,"","","mv_ch1","C",06,0,0,"G","","SC5","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"02","Pedido de Venda at้ ?"  ,"","","mv_ch2","C",06,0,0,"G","","SC5","","","mv_par02","","","","","","","","","","","","","","","","")

Return()

Static Function f_Qry()

c_Qry := " SELECT " + chr(13)
//c_Qry += " C5_NUM, B1_DESC, C6_QTDVEN, C6_QTDENT, C6_LOTECTL, D2_LOTECTL, A1_NOME, A1_END," + chr(13)
c_Qry += " C5_NUM, (Rtrim(B1_COD) + ' - ' + Rtrim(B1_DESC)) as B1_DESC, SUM(C9_QTDLIB) C9_QTDLIB, C9_LOTECTL, C6_LOTECTL, A1_NOME, A1_END," + chr(13)
c_Qry += " A1_BAIRRO, A1_TEL, A1_CEP, A1_MUN, A1_EST, A1_CONTATO, A4_NREDUZ, A4_VIA, A7_FSQTDPE, B5_QE1 " + chr(13)
c_Qry += " FROM " + RetSqlName("SC5") + " SC5 " + chr(13)
c_Qry += " JOIN " + RetSqlName("SC6") + " SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + XFILIAL("SA1") + "' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " LEFT JOIN " + RetSqlName("SA7") + " SA7 ON A7_FILIAL = '" + XFILIAL("SA7") + "' AND A7_PRODUTO = B1_COD AND A7_CLIENTE = C5_CLIENTE AND A7_LOJA = C5_LOJACLI AND SA7.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " LEFT JOIN " + RetSqlName("SB5") + " SB5 ON B5_FILIAL = '" + XFILIAL("SB5") + "' AND B5_COD = B1_COD AND SB5.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " LEFT JOIN " + RetSqlName("SA4") + " SA4 ON A4_COD = C5_TRANSP AND A4_FILIAL = '" + XFILIAL("SA4") + "' AND SA4.D_E_L_E_T_<>'*' " + chr(13)
//c_Qry += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_FILIAL = '" + XFILIAL("SD2") + "' AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM  AND SD2.D_E_L_E_T_<>'*'  " + chr(13)
c_Qry += " LEFT JOIN " + RetSqlName("SC9") + " SC9 ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9_CLIENTE = C6_CLI AND C9_LOJA = C6_LOJA AND SC9.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " AND C9_BLCRED IN ('', '10') AND C9_BLEST IN ('', '10') AND C9_BLWMS IN ('', '05', '06', '07') " + chr(13)
c_Qry += " WHERE C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND SC5.D_E_L_E_T_<>'*' AND C5_FILIAL = '" + XFILIAL("SC5") + "' " + chr(13)
//c_Qry += " GROUP BY C5_NUM, B1_DESC, C6_QTDVEN, C6_QTDENT, C6_LOTECTL, D2_LOTECTL, A1_NOME, A1_END, A1_BAIRRO, " + chr(13)
c_Qry += " GROUP BY C5_NUM, (Rtrim(B1_COD) + ' - ' + Rtrim(B1_DESC)), C9_QTDLIB, C9_LOTECTL, C6_LOTECTL, A1_NOME, A1_END, A1_BAIRRO, " + chr(13)
c_Qry += " A1_TEL, A1_CEP, A1_MUN, A1_EST, A1_CONTATO, A4_NREDUZ, A4_VIA, A7_FSQTDPE, B5_QE1 " + chr(13)
c_Qry += " ORDER BY C5_NUM "

MemoWrit("C:\TEMP\FFATR001.SQL",c_Qry)

Return c_Qry