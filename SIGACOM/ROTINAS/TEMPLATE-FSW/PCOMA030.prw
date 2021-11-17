#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณPCOMA030      บAutor  ณDIEGO ARGOLO      บ Data ณ29/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa chamado na geracao da solicita็ใo de compra       บฑฑ
ฑฑบ          ณ usado para enviar um e-mail para os compradores.           บฑฑ
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
User Function PCOMA030(c_NumSC)
Local c_To		:= ""
Local c_Subj	:= "Geracao de Solicitacao de Compra "+c_NumSC
Local c_Msg		:= ""
Local c_Qry		:= ""
Local a_To		:= {}
Local a_Ret		:= {}
Local c_Anexo	:= {}

c_Qry += "SELECT * "
c_Qry += "FROM "+RETSQLNAME("SC1")+" "
c_Qry += "WHERE D_E_L_E_T_ <> '*' "
c_Qry += "AND C1_NUM = '"+c_NumSC+"' "
c_Qry += "AND C1_FILIAL = '"+XFILIAL("SC1")+"' "

TCQUERY c_Qry NEW ALIAS "QRY"

c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
c_Msg += '<head>'
c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
c_Msg += '<title>Liberaรงรฃo de SC</title>'
c_Msg += '</head>'
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Gera็ใo de Solicita็ใo de Compra</font></td>'
c_Msg += '  </tr>'
c_Msg += '</table>'
c_Msg += '<br>'
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="left" width="100%">'
c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
c_Msg += '    		<p>Prezado Usuแrio sua Solicita็ใo de Compra Nr. '+Alltrim(c_NumSC)+' jแ foi enviada ao seu gestor, por favor aguardar aprova็ใo.</p>'
c_Msg += '		</font>'
c_Msg += ' 	</td>'
c_Msg += '  </tr>'
c_Msg += '</table>'
//Itens
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="center" width="10%">Filial</td>'
c_Msg += '  	<td align="center" width="10%">Produto</td>'
c_Msg += '  	<td align="center" width="60%">Descri็ใo</td>'
c_Msg += '  	<td align="center" width="10%">Qtd</td>'
c_Msg += '  	<td align="center" width="10%">CC</td>'
c_Msg += '  </tr>'

DBSELECTAREA("QRY")
QRY->(DBGOTOP())
WHILE QRY->(!EOF())

	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C1_PRODUTO+'</font></td>'
	c_Msg += '  	<td align="center" width="40%"><font face="Arial" size="2">'+QRY->C1_DESCRI+'</font></td>'
	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+TRANSFORM(QRY->C1_QUANT,"@e 999,999,999.99")+'</font></td>'
	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C1_CC+'</font></td>'
	c_Msg += '  </tr>'
	
	a_To		:= {}
	a_Ret		:= {}

	PswOrder(1)
	PswSeek(QRY->C1_USER, .T.)
	a_Ret	:= PswRet(1)

	If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
		AADD(a_To,Alltrim(a_Ret[1][14]))
	ENDIF

	If !(a_To[1] $ c_To) 
		c_To := a_To[1] //EMAIL DO SOLICITANTE
	ENDIF
	
	QRY->(DBSKIP())
ENDDO
QRY->(DBCLOSEAREA())

c_Msg += '</table>'
c_Msg += '<body>'
c_Msg += '</body>'
c_Msg += '</html>'

c_Qry		:= ""

c_Qry += "SELECT * "
c_Qry += "FROM "+RETSQLNAME("SY1")+" "
c_Qry += "WHERE D_E_L_E_T_ <> '*' "
//c_Qry += "AND Y1_FILIAL = '"+XFILIAL("SY1")+"' " 

TCQUERY c_Qry NEW ALIAS "QR1"

DBSELECTAREA("QR1")
QR1->(DBGOTOP())
WHILE QR1->(!EOF())
	If !(Alltrim(QR1->Y1_EMAIL) $ c_To) .And. !empty(Alltrim(QR1->Y1_EMAIL))
		If Empty(c_To)
			c_To := Alltrim(QR1->Y1_EMAIL)
		Else
			c_To += ";"+Alltrim(QR1->Y1_EMAIL)
		EndIf
	Endif
	QR1->(DBSKIP())
ENDDO
QR1->(DBCLOSEAREA())

If Empty(c_To)
	If lIsBlind()
		Conout("Nใo foi encontrado e-mail informado no cadastro de compradores, favor verificar o cadastro.")
	Else
		Alert("Nใo foi encontrado e-mail informado no cadastro de compradores, favor verificar o cadastro.")
	Endif
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChama a fun็ใo que envia email:                                 ณ
//ณ                                                                ณ
//ณ1บ Parโmetro: Para                                              ณ
//ณ2บ Parโmetro: Corpo do Email                                    ณ
//ณ3บ Parโmetro: Assunto                                           ณ
//ณ4บ Parโmetro: Se exibe a tela informando que o email foi enviadoณ
//ณ5บ Parโmetro: Anexo                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

U_TBSENDMAIL(c_To, c_Msg, c_Subj, .T., c_Anexo)

Return()