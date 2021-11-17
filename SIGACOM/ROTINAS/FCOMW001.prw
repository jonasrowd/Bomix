#DEFINE ENTER CHR(13) + CHR(10)

User Function FCOMW001( c_Empresa, c_Filial, c_Usuario, c_Senha, c_Docto, c_Tipo, n_Valor, c_Aprov, c_User, c_Grupo, l_TipoAcao, c_Rejeit )

	Local c_UserWS	:= ""
	Local c_PswWS	:= ""
	Local a_Docto 	:= {}
	Local d_DataRef	:= CTOD("  /  /  ")
	Local n_Oper 	:= 4
	Local c_Seek 	:= ""
	local l_Achou	:= .T.
	Local c_Fornece	:= ""
	Local c_Loja	:= ""
	Local c_Solic	:= ""
	Local a_Ret		:= {}
	Local a_To		:= {}
	Local a_Usu		:= {}
	Local c_To		:= ""
	Local c_Subj	:= ""
	Local c_Anexo	:= {}
	Local c_Msg		:= ""
	Local c_Msg2	:= ""

	Local a_SC7Area	:= {}
	Local a_SCRArea	:= {}
	Local a_SCSArea	:= {}
	Local a_SAKArea	:= {}
	Local a_SALArea	:= {}

	RpcSetType( 3 )
	RpcSetEnv( c_Empresa, c_Filial )
	
	c_To		:= SUPERGETMV("FS_MAILCOM",,"compras@bomix.com.br")+";"+SUPERGETMV("FS_MAILGER",,"robertosoares@bomix.com.br")

	a_SC7Area	:= SC7->(GetArea())
	a_SCRArea	:= SCR->(GetArea())
	a_SCSArea	:= SCS->(GetArea())
	a_SAKArea	:= SAK->(GetArea())
	a_SALArea	:= SAL->(GetArea())

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")
	c_PathLog	:= SUPERGETMV("FS_PATHLOG",,"\WS_LOG\")

	d_DataRef	:= Date()

	IF (c_Usuario <> c_UserWS ) .OR. ( c_Senha <> c_PswWS )

		a_Ret := { .F., "Tentativa de acesso ao WS nao permitida!" }

		RestArea( a_SC7Area )
		RestArea( a_SCRArea )
		RestArea( a_SCSArea )
		RestArea( a_SAKArea )
		RestArea( a_SALArea )

		Return( a_Ret )

	ENDIF

	/*
	a_Docto = Array com informacoes do documento
	[1] Numero do documento
	[2] Tipo de Documento
	[3] Valor do Documento
	[4] Codigo do Aprovador
	[5] Codigo do Usuario
	[6] Grupo do Aprovador
	[7] Aprovador Superior
	[8] Moeda do Documento
	[9] Taxa da Moeda
	[10] Data de Emissao do Documento
	[11] Grupo de Compras
	*/

	c_Docto := Padr( c_Docto, TamSX3("CR_NUM")[1] )

	a_Docto := { c_Docto, c_Tipo, n_Valor, c_Aprov, c_User, c_Grupo }

	// Posicionar no SCR pelo Tipo (PC) + Num Pedido + Aprovador + Status (02)
	DBSELECTAREA("SCR")
	DBORDERNICKNAME("FSALCADA")
	If !dbSeek( c_Filial + c_Tipo + c_Docto + c_Aprov + "02", .T. )

		l_Achou := dbSeek( c_Filial + c_Tipo + c_Docto + c_Aprov + "04" ,.T. )

	EndIf

	IF ( l_Achou )

		// Efetua a Liberação/Rejeição
		IF( l_TipoAcao )

			// Se MaAlcDoc Retornar .T. significa que todo o pedido foi liberado
			// portanto altera os resgistro do SC7, coluna C7_CONAPRO
			dbSelectArea( "SC7" )
			dbSetOrder( 1 )
			dbSeek( xFilial( "SC7" ) + Padr( c_Docto, TamSX3("C7_NUM")[1] ), .F. )

			If MaAlcDoc( a_Docto, d_DataRef, n_Oper )
			
			// Posicionar no SCR pelo Tipo (PC) + Num Pedido + Aprovador + Status (02)
			DBSELECTAREA("SCR")
			DBORDERNICKNAME("FSSTALC")
			If !dbSeek( c_Filial + c_Tipo + c_Docto + "02", .T. )
		
			Conout("PEDIDO APROVADO!!!")

				IF (c_Tipo == "IP") .OR. (c_Tipo == "PC")
				
					

					DBSELECTAREA("SC7")
					DBSETORDER(1)
					IF DBSEEK( XFILIAL("SC7") + Padr( c_Docto, TamSX3("C7_NUM")[1] ) ,.T. )
	
						c_Fornece	:= 	SC7->C7_FORNECE
						c_Loja		:= 	SC7->C7_LOJA
						c_Solic		:= 	SC7->C7_NUMSC
						l_RetLib	:=	.T.
						Begin Transaction 
							WHILE SC7->(!EOF()) .AND. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7") + Padr( c_Docto, TamSX3("C7_NUM")[1] )
		
								If SC7->C7_CONAPRO <> "L"
									If SC7->(RECLOCK("SC7",.F.))
										SC7->C7_CONAPRO  	:= "L"
										SC7->(MSUNLOCK())
									Else
										l_RetLib	:=	.F.
										c_Mens	:= "Pedido "+SC7->C7_NUM+" nao liberado, registros bloquedos por outra rotina."	
										Conout(c_Mens)
										DisarmTransaction()
										Exit
									Endif
								Endif
								
								c_Msg2 += '  <tr>'
								c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
								c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_PRODUTO+'</font></td>'
								c_Msg2 += '  	<td align="center" width="40%"><font face="Arial" size="2">'+SC7->C7_DESCRI+'</font></td>'
								c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+TRANSFORM(SC7->C7_QUANT,"@e 999,999,999.99")+'</font></td>'
								c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_CC+'</font></td>'
								c_Msg2 += '  </tr>'
								
								SC7->(DBSKIP())
		
							ENDDO
						End Transaction
						
						c_Subj	:= "Pedido de Compra "+c_Docto+" aprovado."
					
						c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
						c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
						c_Msg += '<head>'
						c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
						c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
						c_Msg += '</head>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Pedido de Compra aprovado</font></td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<br>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="left" width="100%">'
						c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
						c_Msg += '    		<p>Prezado Usuário seu pedido de Compra Nr. '+Alltrim(c_Docto)+' foi aprovado e já está sendo enviado para o fornecedor.</p>'
						c_Msg += '		</font>'
						c_Msg += ' 	</td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						//Itens
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="10%">Filial</td>'
						c_Msg += '  	<td align="center" width="10%">Produto</td>'
						c_Msg += '  	<td align="center" width="60%">Descrição</td>'
						c_Msg += '  	<td align="center" width="10%">Qtd</td>'
						c_Msg += '  	<td align="center" width="10%">CC</td>'
						c_Msg += '  </tr>'
					
						
						Conout("c_Docto 1 =>"+c_Docto)
						
						DBSELECTAREA("SC1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SC1")+ Padr( c_Solic, TamSX3("C1_NUM")[1] ))
						IF FOUND()
						
						Conout("Entrou 1 =>")
						
							a_To		:= {}
							a_Usu		:= {}
				
					    	PswOrder(1)
							PswSeek(SC1->C1_USER, .T.)
							a_Usu	:= PswRet(1)
				
							If Ascan(a_To,Alltrim(a_Usu[1][14]))==0
								AADD(a_To,Alltrim(a_Usu[1][14]))
							ENDIF
							
							Conout("c_Docto 1 =>"+SC1->C1_USER)
							
							If Empty(c_To)
								c_To := a_To[1] //EMAIL DO SOLICITANTE
							Else
								c_To += ";"+a_To[1] //EMAIL DO SOLICITANTE
							EndIf

						ENDIF
						
						c_Msg += c_Msg2
						
						
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<body>'
						c_Msg += '</body>'
						c_Msg += '</html>'
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Chama a função que envia email:                                 ³
						//³                                                                ³
						//³1º Parâmetro: Para                                              ³
						//³2º Parâmetro: Corpo do Email                                    ³
						//³3º Parâmetro: Assunto                                           ³
						//³4º Parâmetro: Se exibe a tela informando que o email foi enviado³
						//³5º Parâmetro: Anexo                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
						U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)
	/*					
						dbSelectArea("SA2")
						dbSetOrder(1)
						dbSeek(xFilial("SA2") + c_Fornece + c_Loja )
	
						c_Body	:= "Prezado " + Alltrim( Capital( SA2->A2_NREDUZ ) ) + ",<br/><br/>" + ENTER
						c_Body	+= "O pedido de compra " + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + " em anexo foi liberado e aguardamos o seu envio.<br/><br/>" + ENTER
						c_Body	+= "Grato, <br/>" + SM0->M0_NOMECOM
	
						DBSELECTAREA("SC7")
						DBSETORDER(1)
						n_RegSC7	:=	0
						c_C7USER	:=	""
						IF DBSEEK( XFILIAL("SC7") + Padr( c_Docto, TamSX3("C7_NUM")[1] ) ,.T. )
							n_RegSC7	:=	SC7->(Recno())
							c_C7USER	:=	SC7->C7_USER
							If SUPERGETMV("FS_ENVPC",,"2") == "1"
								U_PCOMR003()
							Endif
	
						endif
	
						If SUPERGETMV("FS_ENVPC",,"1") == "2"
							c_Anexo	:= "\system\pedido_" + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + ".html"
							U_TBSENDMAIL( SA2->A2_EMAIL, c_Body, "BOMIX :: Pedido de compra liberado - " + Padr( c_Docto, TamSX3("C7_NUM")[1] ), .F., c_Anexo )
							FERASE('\system\' + c_Anexo)
						EndIF
						
						c_EnviaPCC := Alltrim(SUPERGETMV("FS_ENVPCC",,"2")) 
						c_Log	:=	"FCOMW001_"+dTOS(DATE())+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)+".TXT"
						c_Mens	:= "Envia PC para comprador: "+c_EnviaPCC +ENTER+ "Recno SC7: "+Alltrim(Str(n_RegSC7))  	
						Conout(c_Mens)
						Memowrite(c_Log, c_Mens)
						
						If  c_EnviaPCC == "1" //Enviar E-mail para Comprador
							If n_RegSC7 > 0
								SC7->(dbGoto(n_RegSC7))
								SY1->(dbSetOrder(3))
								If SY1->(dbSeek(xFilial("SY1")+SC7->C7_USER))
									c_Mens	:=	Memoread(c_Log)
									If Valtype(c_Mens) <> "C"
										c_Mens := ""
									Endif
									c_Mens	+= ENTER+"codigo do Comprador: "+SC7->C7_USER + " / "+c_C7USER 	
									Conout(c_Mens)
									Memowrite(c_Log, c_Mens)
									
									If SY1->(!Empty(Y1_EMAIL))
										If l_RetLib
											c_Body	:= "Prezado " + Alltrim( Capital( SY1->Y1_NOME ) ) + ",<br/><br/>" + ENTER
											c_Body	+= "O pedido de compra " + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + " em anexo foi liberado.<br/><br/>" + ENTER
											c_Body	+= "Grato, <br/>" + SM0->M0_NOMECOM
											
											c_Anexo	:=	u_PCOMR005( "SC7", n_RegSC7, .F. )
										Else
											c_Body	:= "Prezado " + Alltrim( Capital( SY1->Y1_NOME ) ) + ",<br/><br/>" + ENTER
											c_Body	+= "O pedido de compra " + Alltrim( Padr( c_Docto, TamSX3("C7_NUM")[1] ) ) + " nao foi liberado.<br/><br/>" + ENTER
											c_Body	+= "O mesmo estava bloqueado por outro processo durante o processo de liberacao.<br/><br/>" + ENTER
											c_Body	+= "Grato, <br/>" + SM0->M0_NOMECOM
											
											c_Anexo := ""
											
										Endif
										
										U_TBSENDMAIL( SY1->Y1_EMAIL, c_Body, "BOMIX :: Pedido de compra "+Iif(l_RetLib,"liberado","Bloqueado")+" - " + Padr( c_Docto, TamSX3("C7_NUM")[1] ), .F., c_Anexo )
										
										If Valtype(c_Anexo) <> "C"
											c_Anexo := "Erro na geracao do anexo."
										Endif
										
										c_Mens	:=	Memoread(c_Log)
										If Valtype(c_Mens) <> "C"
											c_Mens := ""
										Endif
										c_Mens	+= ENTER+"Comprador: "+SY1->Y1_EMAIL+" :: BOMIX :: Pedido de compra liberado - " + Padr( c_Docto, TamSX3("C7_NUM")[1] ) + ":: "+c_Anexo 	
										Conout(c_Mens)
										Memowrite(c_Log, c_Mens)
										//FERASE(c_Anexo)
									
									Endif
								Endif
							Endif	
						Endif
						//....inserir envio de email para comprador. CAMPOS: Y1_COD, Y1_USER(gravar em C7_USER), Y1_EMAIL - USER INDICE 3 - Y1_FILIAL + Y1_USER
	*/
					ENDIF
					
				ELSE
					IF c_Tipo == "SC"
					
						c_Subj	:= "Solicitacao de Compra "+c_Docto+" aprovada."
					
						c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
						c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
						c_Msg += '<head>'
						c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
						c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
						c_Msg += '</head>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Solicitação de Compra aprovada</font></td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<br>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="left" width="100%">'
						c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
						c_Msg += '    		<p>Prezado Usuário sua Solicitação de Compra Nr. '+Alltrim(c_Docto)+' acabou de ser aprovada e encaminhada para o departamento de compras. Por favor aguardar o processo de compras ser finalizado e aprovado.</p>'
						c_Msg += '		</font>'
						c_Msg += ' 	</td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						//Itens
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="10%">Filial</td>'
						c_Msg += '  	<td align="center" width="10%">Produto</td>'
						c_Msg += '  	<td align="center" width="60%">Descrição</td>'
						c_Msg += '  	<td align="center" width="10%">Qtd</td>'
						c_Msg += '  	<td align="center" width="10%">CC</td>'
						c_Msg += '  </tr>'
					
						
						Conout("c_Docto 1 =>"+c_Docto)
						
						DBSELECTAREA("SC1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SC1")+ Padr( c_Docto, TamSX3("C1_NUM")[1] ))
						IF FOUND()
						
						Conout("Entrou 1 =>")
						
							a_To		:= {}
							a_Usu		:= {}
				
					    	PswOrder(1)
							PswSeek(SC1->C1_USER, .T.)
							a_Usu	:= PswRet(1)
				
							If Ascan(a_To,Alltrim(a_Usu[1][14]))==0
								AADD(a_To,Alltrim(a_Usu[1][14]))
							ENDIF
							
							Conout("c_Docto 1 =>"+SC1->C1_USER)
							
							If Empty(c_To)
								c_To := a_To[1] //EMAIL DO SOLICITANTE
							Else
								c_To += ";"+a_To[1] //EMAIL DO SOLICITANTE
							EndIf

						ENDIF
						
						WHILE SC1->(!EOF()).AND.SC1->C1_FILIAL+SC1->C1_NUM==XFILIAL("SC1")+Padr( c_Docto, TamSX3("C1_NUM")[1] )
						
						Conout("Entrou 2 =>")
						
							c_Msg += '  <tr>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC1->C1_PRODUTO+'</font></td>'
							c_Msg += '  	<td align="center" width="40%"><font face="Arial" size="2">'+SC1->C1_DESCRI+'</font></td>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+TRANSFORM(SC1->C1_QUANT,"@e 999,999,999.99")+'</font></td>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC1->C1_CC+'</font></td>'
							c_Msg += '  </tr>'
						
						
							SC1->(DBSKIP())
						ENDDO
						
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<body>'
						c_Msg += '</body>'
						c_Msg += '</html>'
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Chama a função que envia email:                                 ³
						//³                                                                ³
						//³1º Parâmetro: Para                                              ³
						//³2º Parâmetro: Corpo do Email                                    ³
						//³3º Parâmetro: Assunto                                           ³
						//³4º Parâmetro: Se exibe a tela informando que o email foi enviado³
						//³5º Parâmetro: Anexo                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
						U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)
						
					ENDIF
				
				ENDIF

				a_Ret := { .T., "PEDIDO LIBERADO!!!" }
				
				ELSE

					a_Ret := { .T., "PEDIDO LIBERADO PARA O PROXIMO NIVEL!!!" }
					Conout("PEDIDO LIBERADO PARA O PROXIMO NIVEL!!!")
				
				EndIf

			ELSE

				a_Ret := { .T., "PEDIDO LIBERADO PARA O PROXIMO NIVEL!!!" }
				Conout("PEDIDO LIBERADO PARA O PROXIMO NIVEL!!!")

			ENDIF

		ELSE

			n_Oper := 6

			MaAlcDoc( a_Docto, d_DataRef, n_Oper )
			
			IF (c_Tipo == "IP") .OR. (c_Tipo == "PC")
				DBSELECTAREA("SC7")
				DBSETORDER(1)
				IF DBSEEK( XFILIAL("SC7") + Padr( c_Docto, TamSX3("C7_NUM")[1] ) ,.T. )
				
				c_Solic		:= 	SC7->C7_NUMSC

					l_RetLib	:=	.T.
					Begin Transaction 
						WHILE SC7->(!EOF()) .AND. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7") + Padr( c_Docto, TamSX3("C7_NUM")[1] )
	
							If SC7->C7_CONAPRO <> "R"
								If SC7->(RECLOCK("SC7",.F.))
									SC7->C7_CONAPRO  	:= "R"
									SC7->(MSUNLOCK())
								Else
									l_RetLib	:=	.F.
									c_Mens	:= "Pedido "+SC7->C7_NUM+" nao liberado, registros bloquedos por outra rotina."	
									Conout(c_Mens)
									DisarmTransaction()
									Exit
								Endif
							Endif
							
							c_Msg2 += '  <tr>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_PRODUTO+'</font></td>'
							c_Msg2 += '  	<td align="center" width="40%"><font face="Arial" size="2">'+SC7->C7_DESCRI+'</font></td>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+TRANSFORM(SC7->C7_QUANT,"@e 999,999,999.99")+'</font></td>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_CC+'</font></td>'
							c_Msg2 += '  </tr>'
								
							SC7->(DBSKIP())
	
						ENDDO
					End Transaction
					
						c_Subj	:= "Pedido de Compra "+c_Docto+" rejeitado."
					
						c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
						c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
						c_Msg += '<head>'
						c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
						c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
						c_Msg += '</head>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Pedido de Compra rejeitado</font></td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<br>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="left" width="100%">'
						c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
						c_Msg += '    		<p>Prezado Usuário seu pedido de Compra Nr. '+Alltrim(c_Docto)+' foi rejeitado.</p>'
						c_Msg += '    		<p>Motivo: '+Alltrim(c_Rejeit)+' </p>'
						c_Msg += '		</font>'
						c_Msg += ' 	</td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						//Itens
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="10%">Filial</td>'
						c_Msg += '  	<td align="center" width="10%">Produto</td>'
						c_Msg += '  	<td align="center" width="60%">Descrição</td>'
						c_Msg += '  	<td align="center" width="10%">Qtd</td>'
						c_Msg += '  	<td align="center" width="10%">CC</td>'
						c_Msg += '  </tr>'
					
						
						Conout("c_Docto 1 =>"+c_Docto)
						
						DBSELECTAREA("SC1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SC1")+ Padr( c_Solic, TamSX3("C1_NUM")[1] ))
						IF FOUND()
						
						Conout("Entrou 1 =>")
						
							a_To		:= {}
							a_Usu		:= {}
				
					    	PswOrder(1)
							PswSeek(SC1->C1_USER, .T.)
							a_Usu	:= PswRet(1)
				
							If Ascan(a_To,Alltrim(a_Usu[1][14]))==0
								AADD(a_To,Alltrim(a_Usu[1][14]))
							ENDIF
							
							Conout("c_Docto 1 =>"+SC1->C1_USER)
							
							If Empty(c_To)
								c_To := a_To[1] //EMAIL DO SOLICITANTE
							Else
								c_To += ";"+a_To[1] //EMAIL DO SOLICITANTE
							EndIf

						ENDIF
						
						c_Msg += c_Msg2
						
						
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<body>'
						c_Msg += '</body>'
						c_Msg += '</html>'
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Chama a função que envia email:                                 ³
						//³                                                                ³
						//³1º Parâmetro: Para                                              ³
						//³2º Parâmetro: Corpo do Email                                    ³
						//³3º Parâmetro: Assunto                                           ³
						//³4º Parâmetro: Se exibe a tela informando que o email foi enviado³
						//³5º Parâmetro: Anexo                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
						U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)					
				ENDIF
			ELSE
				IF c_Tipo == "SC"
				
						c_Subj	:= "Solicitacao de Compra "+c_Docto+" rejeitada."
					
						c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
						c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
						c_Msg += '<head>'
						c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
						c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
						c_Msg += '</head>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Solicitação de Compra rejeitada</font></td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<br>'
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="left" width="100%">'
						c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
						c_Msg += '    		<p>Prezado Usuário sua Solicitação de Compra Nr. '+Alltrim(c_Docto)+' acabou de ser rejeitada.</p>'
						c_Msg += '    		<p>Motivo: '+Alltrim(c_Rejeit)+' </p>'
						c_Msg += '		</font>'
						c_Msg += ' 	</td>'
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						//Itens
						c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="10%">Filial</td>'
						c_Msg += '  	<td align="center" width="10%">Produto</td>'
						c_Msg += '  	<td align="center" width="60%">Descrição</td>'
						c_Msg += '  	<td align="center" width="10%">Qtd</td>'
						c_Msg += '  	<td align="center" width="10%">CC</td>'
						c_Msg += '  </tr>'
					
						
						Conout("c_Docto 1 =>"+c_Docto)
						
						DBSELECTAREA("SC1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SC1")+ Padr( c_Docto, TamSX3("C1_NUM")[1] ))
						IF FOUND()
						
						Conout("Entrou 1 =>")
						
							a_To		:= {}
							a_Usu		:= {}
				
					    	PswOrder(1)
							PswSeek(SC1->C1_USER, .T.)
							a_Usu	:= PswRet(1)
				
							If Ascan(a_To,Alltrim(a_Usu[1][14]))==0
								AADD(a_To,Alltrim(a_Usu[1][14]))
							ENDIF
							
							Conout("c_Docto 1 =>"+SC1->C1_USER)
							
							If Empty(c_To)
								c_To := a_To[1] //EMAIL DO SOLICITANTE
							Else
								c_To += ";"+a_To[1] //EMAIL DO SOLICITANTE
							EndIf

						ENDIF
						
						WHILE SC1->(!EOF()).AND.SC1->C1_FILIAL+SC1->C1_NUM==XFILIAL("SC1")+Padr( c_Docto, TamSX3("C1_NUM")[1] )
						
						Conout("Entrou 2 =>")
						
							c_Msg += '  <tr>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC1->C1_PRODUTO+'</font></td>'
							c_Msg += '  	<td align="center" width="40%"><font face="Arial" size="2">'+SC1->C1_DESCRI+'</font></td>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+TRANSFORM(SC1->C1_QUANT,"@e 999,999,999.99")+'</font></td>'
							c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC1->C1_CC+'</font></td>'
							c_Msg += '  </tr>'
						
						
							SC1->(DBSKIP())
						ENDDO
						
						c_Msg += '  </tr>'
						c_Msg += '</table>'
						c_Msg += '<body>'
						c_Msg += '</body>'
						c_Msg += '</html>'
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Chama a função que envia email:                                 ³
						//³                                                                ³
						//³1º Parâmetro: Para                                              ³
						//³2º Parâmetro: Corpo do Email                                    ³
						//³3º Parâmetro: Assunto                                           ³
						//³4º Parâmetro: Se exibe a tela informando que o email foi enviado³
						//³5º Parâmetro: Anexo                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
						U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)				
					
				ENDIF				
			ENDIF		

			a_Ret := { .T., "PEDIDO REJEITADO!!!" }

		ENDIF

	ELSE

		a_Ret := { .F., "PEDIDO LIBERADO ANTERIORMENTE!!!" }

	ENDIF

	RestArea( a_SC7Area )
	RestArea( a_SCRArea )
	RestArea( a_SCSArea )
	RestArea( a_SAKArea )
	RestArea( a_SALArea )

Return( a_Ret )
