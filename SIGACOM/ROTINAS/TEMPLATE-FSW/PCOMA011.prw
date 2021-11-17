#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณPCOMA011  บAutor  ณAdriano Alves      บ Data ณ Outubro/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa chamado na liberacao do pedido, usado para enviar บฑฑ
ฑฑบ          ณ um e-mail para o aprovador do proximo nivel.               บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ                                         บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PCOMA011(a_Dados, c_Rotina) 

Local a_Docto		:= a_Dados[1]		//Numero do documento
Local n_Oper		:= a_Dados[3]		//Numero da operacao
Local c_AtuaNivel	:= ""				//Nivel atual do registro
Local c_ProxNivel	:= ""				//Proximo nivel
Local l_Flag		:= .T.				//Flag do nivel
Local c_To			:= ""				//Email
Local c_Nivel		:= ""				//Nivel
Local c_Msg			:= ""				//Mensagem do e-mail
Local c_Qry			:= ""				//Query de consulta
Local c_Subj		:= "Aprovacao de Pedido de Compras"				//Assunto (subject)
Local c_Anexo		:= {}
Local c_For			:= ""
Local c_Loj			:= ""
Local c_NumDoc		:= a_Docto[1]		//Numero do Documento
Local c_TpDoc		:= a_Docto[2] 		//Tipo de Documento
Local c_CodAprv		:= a_Docto[4] 		//Codigo do Aprovador
Local c_CodUsr		:= a_Docto[5] 		//Codigo do Usuario
Local c_GrpAprv		:= a_Docto[6] 		//Grupo do Aprovador

IF ( c_Rotina == "MATA097" ) //LIBERACAO DE DOCUMENTOS

	IF n_Oper <> 4 	//DIFERENTE DE APROVACAO

		Return()
	
	ENDIF
	
	DBSELECTAREA("SAL")
	DBSETORDER(3)
	DBSEEK(XFILIAL("SAL")+c_GrpAprv+c_CodAprv,.T.)
	c_Nivel := SAL->AL_NIVEL
	
	//BUSCA O NIVEL ATUAL
	DBSELECTAREA("SAL")
	DBSETORDER(2)
	DBSEEK(XFILIAL("SAL")+c_GrpAprv+c_Nivel)
	c_AtuaNivel := SAL->AL_NIVEL
	
	WHILE SAL->(!EOF()).AND.SAL->AL_FILIAL+SAL->AL_COD==XFILIAL("SAL")+c_GrpAprv
		
		IF SAL->AL_NIVEL == c_AtuaNivel
			SAL->(DBSKIP())
			LOOP
		ENDIF
		
		//BUSCA O PROXIMO NIVEL
		IF l_Flag
			c_ProxNivel	:= SAL->AL_NIVEL
			l_Flag 		:= .F.
		ENDIF
		
		IF SAL->AL_NIVEL <= c_ProxNivel
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifico se o proximo nivel foi utilizado no arquivo de alcada.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			c_NumDoc := c_NumDoc+(Space((TamSX3("CR_NUM")[1]-LEN(c_NumDoc))))
			DBSELECTAREA("SCR")
			DBSETORDER(2)
			DBSEEK(XFILIAL("SCR")+c_TpDoc+c_NumDoc+SAL->AL_USER,.T.)
			IF FOUND()
				PswOrder(1)
				PswSeek(SAL->AL_USER,.T.)
				aRet      := PswRet(1)
				cUsrEmail := aRet[1][14]
				c_To   += ALLTRIM(cUsrEmail)+"; "
			ENDIF
			
		ENDIF
		SAL->(DBSKIP())
	ENDDO
	
	IF LEN(c_To) > 2
		
		c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
		c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
		c_Msg += '<head>'
		c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
		c_Msg += '<title>Libera็ใo de SC (Purchase Authorization Request)</title>'
		c_Msg += '</head>'
		c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Libera็ใo de Pedido de Compra</font></td>'
		c_Msg += '  </tr>'
		c_Msg += '</table>'
		c_Msg += '<br>'
		c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="100%">'
		c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
		c_Msg += '    		<p>O pedido de compra ('+c_NumDoc+') estแ bloqueado no sistema e aguardando sua analise.</p>'
		c_Msg += '		</font>'
		c_Msg += ' 	</td>'
		c_Msg += '  </tr>'
		c_Msg += '</table>'
		
		c_Qry += "SELECT * "
		c_Qry += "FROM "+RETSQLNAME("SC7")+" "
		c_Qry += "WHERE D_E_L_E_T_ <> '*' "
		c_Qry += "AND C7_FILIAL = '"+XFILIAL("SC7")+"' "
		c_Qry += "AND C7_NUM = '"+c_NumDoc+"' "
		
		TCQUERY c_Qry NEW ALIAS "QRY"			          
			
		DBSELECTAREA("SC7")
		QRY->(DBGOTOP())
		
		c_For	:= QRY->C7_FORNECE
		c_Loj	:= QRY->C7_LOJA
		
		c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="100%">Fornecedor: '+QRY->C7_FORNECE+'/'+QRY->C7_LOJA+' '+Posicione("SA2",1,XFILIAL("SA2")+QRY->C7_FORNECE+QRY->C7_LOJA,"A2_NOME")+'</td>'
		c_Msg += '  </tr>'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="100%">Emissใo: '+DTOC(STOD(QRY->C7_EMISSAO))+'</td>'
		c_Msg += '  </tr>'
		c_Msg += '</table>'
		
		c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="10%">Produto</td>'
		c_Msg += '  	<td align="center" width="40%">Descri็ใo</td>'
		c_Msg += '  	<td align="center" width="10%">Qtd</td>'
		c_Msg += '  	<td align="center" width="10%">Vlr. Ref.</td>'
		c_Msg += '  	<td align="center" width="10%">Total Ref.</td>'
		c_Msg += '  	<td align="center" width="10%">CC</td>' 
		c_Msg += '  </tr>'
		
		WHILE QRY->(!EOF())
			c_Msg += '  <tr>'
			c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C7_PRODUTO+'</font></td>'
			c_Msg += '  	<td align="center" width="50%"><font face="Arial" size="2">'+QRY->C7_DESCRI+'</font></td>'
			c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(QRY->C7_QUANT,"@e 999,999,999.99")+'</font></td>'
			c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(QRY->C7_PRECO,"@e 999,999,999.99")+'</font></td>'
			c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(QRY->C7_TOTAL,"@e 999,999,999.99")+'</font></td>'
			c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C7_CC+'</font></td>'
			c_Msg += '  </tr>'
			QRY->(DBSKIP())
		ENDDO
		QRY->(DBCLOSEAREA())
		
		c_Msg += '</table>'
		c_Msg += '<br>'
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChama a fun็ใo que envia email:                                 ณ
		//ณ                                                                ณ
		//ณ1บ Parโmetro: Para                                              ณ
		//ณ2บ Parโmetro: Corpo do Email                                    ณ
		//ณ3บ Parโmetro: Assunto                                           ณ
		//ณ4บ Parโmetro: Se exibe a tela informando que o email foi enviadoณ
		//ณ5บ Parโmetro: Anexo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)
					
	ENDIF

ENDIF 

Return()