#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOMA010  ºAutor  ³Adriano Alves      º Data ³ Outubro/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa chamado na libercao do pedido, usado para enviar  º±±
±±º          ³ um e-mail para o solicitante e o fornecedor.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PCOMA010(c_Pedido, n_Opcao)

	Local c_NumCot	:= ""
	Local c_ForLoj	:= ""
	Local c_Compr	:= ""
	Local c_To		:= ""
	Local c_Msg		:= ""
	Local c_Subj	:= "Pedido de Compra liberado :: "+c_Pedido
	Local a_To		:= {}
	Local a_Ret		:= {}
	Local c_NumSC	:= ""
	Local c_Bloq    := ""
	Local c_Qry		:= ""
	Local c_Anexo	:= {}
	Local c_EmailFor:= ""
	Local c_Filial	:= ""

	IF (n_Opcao = 2) //LIBEROU

		DBSELECTAREA("SC7")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SC7")+Alltrim(c_Pedido),.T.)

			IF (ALLTRIM(SC7->C7_CONAPRO) = "L")
			
				c_Filial	:= SC7->C7_FILIAL
				c_NumSC		:= SC7->C7_NUMSC
				c_Pedido	:= SC7->C7_NUM
				c_NumCot	:= SC7->C7_NUMCOT
				c_ForLoj	:= SC7->C7_FORNECE+SC7->C7_LOJA
				c_Bloq		:= SC7->C7_CONAPRO

				DBSELECTAREA("SA2")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SA2")+c_ForLoj)
				c_EmailFor:= SA2->A2_EMAIL

				IF !(EMPTY(c_NumSC))

					DBSELECTAREA("SC1")
					DBSETORDER(1)
					DBSEEK(XFILIAL("SC1")+c_NumSC)
					WHILE (SC1->(!EOF())) .AND. (SC1->C1_FILIAL+SC1->C1_NUM==XFILIAL("SC1")+c_NumSC)

						PswOrder(1)
						PswSeek(SC1->C1_USER, .T.)
						a_Ret	:= PswRet(1)

						If Ascan(a_To,Alltrim(a_Ret[1][14])) == 0
							AADD(a_To,Alltrim(a_Ret[1][14]))
						ENDIF

						SC1->(DBSKIP())

					ENDDO

					c_To := a_To[1] //EMAIL DO SOLICITANTE E DO FORNECEDOR
					
					a_To		:= {}
					a_Ret		:= {}
					
					PswOrder(1)
                	PswSeek(__CUSERID, .T.)
                	a_Ret    := PswRet(1)
               
	                If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
                 		AADD(a_To,Alltrim(a_Ret[1][14]))
                	ENDIF
               
                	c_To += ";"+a_To[1]  //EMAIL DO COMPRADOR

					c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
					c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
					c_Msg += '<head>'
					c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
					c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
					c_Msg += '</head>'
					c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
					c_Msg += '  <tr>'
					c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Pedido Liberado</font></td>'
					c_Msg += '  </tr>'
					c_Msg += '</table>'
					c_Msg += '<br>'
					c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
					c_Msg += '  <tr>'
					c_Msg += '  	<td align="center" width="100%">'
					c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
					c_Msg += '    		<p>O Pedido de Compras '+c_Pedido+' foi liberado.</p>'
					c_Msg += '		</font>'
					c_Msg += ' 	</td>'
					c_Msg += '  </tr>'
					c_Msg += '</table>'
//Itens
					c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
					c_Msg += '  <tr>'
					c_Msg += '  	<td align="center" width="10%">Filial</td>'
					c_Msg += '  	<td align="center" width="10%">Produto</td>'
					c_Msg += '  	<td align="center" width="40%">Descrição</td>'
					c_Msg += '  	<td align="center" width="10%">Qtd</td>'
					c_Msg += '  	<td align="center" width="10%">Vlr. Ref.</td>'
					c_Msg += '  	<td align="center" width="10%">Total Ref.</td>'
//c_Msg += '  	<td align="center" width="10%">CC</td>'
//c_Msg += '  	<td align="center" width="10%">CR</td>'
					c_Msg += '  </tr>'

					c_Qry += "SELECT * "
					c_Qry += "FROM "+RETSQLNAME("SC7")+" "
					c_Qry += "WHERE D_E_L_E_T_ <> '*' "
					c_Qry += "AND C7_FILIAL = '"+XFILIAL("SC7")+"' "
					c_Qry += "AND C7_NUM = '"+c_Pedido+"' "

					TCQUERY c_Qry NEW ALIAS "QRY"

					DBSELECTAREA("SC7")
					QRY->(DBGOTOP())
					WHILE QRY->(!EOF())
						c_Msg += '  <tr>'
						c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
						c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C7_PRODUTO+'</font></td>'
						c_Msg += '  	<td align="center" width="40%"><font face="Arial" size="2">'+QRY->C7_DESCRI+'</font></td>'
						c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(QRY->C7_QUANT,"@e 999,999,999.99")+'</font></td>'
						c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(QRY->C7_PRECO,"@e 999,999,999.99")+'</font></td>'
						c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(QRY->C7_TOTAL,"@e 999,999,999.99")+'</font></td>'
//	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C7_CC+'</font></td>'
//	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C7_ITEMCTA+'</font></td>'
						c_Msg += '  </tr>'
						QRY->(DBSKIP())
					ENDDO

					QRY->(DBCLOSEAREA())

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

				U_PCOMA013(c_Filial,c_Pedido)
				
			ENDIF

		ELSE
			If lIsBlind()
				Conout(SM0->M0_NOMECOM+": O pedido teve problemas na liberação. Verifique situação do documento com o administrador do sistema")
			Else
				Aviso(SM0->M0_NOMECOM,"O pedido teve problemas na liberação. Verifique situação do documento com o administrador do sistema",{"Ok"},2,"Atenção!")
			Endif
			RestArea(a_Area)
			Return()

		ENDIF

	ENDIF

	Return()
