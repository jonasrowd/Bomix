#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณPCOMA008  บAutor  ณAdriano Alves      บ Data ณ Outubro/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa chamado na geracao da cotacao, usado para enviar  บฑฑ
ฑฑบ          ณ um e-mail para o solicitante.                              บฑฑ
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
User Function PCOMA008(c_NumCot, c_NumSC)
Local c_To		:= ""
Local c_Subj	:= "Geracao de Cotacao "+c_NumCot
Local c_Msg		:= ""
Local c_Qry		:= ""
Local a_To		:= {}
Local a_Ret		:= {}
Local c_Anexo	:= {}

c_Qry += "SELECT * "
c_Qry += "FROM "+RETSQLNAME("SC1")+" "
c_Qry += "WHERE D_E_L_E_T_ <> '*' "
c_Qry += "AND C1_NUM = '"+c_NumSC+"' "
c_Qry += "AND C1_COTACAO= '"+c_NumCot+"' "
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
c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Gera็ใo de Cota็ใo</font></td>'
c_Msg += '  </tr>'
c_Msg += '</table>'
c_Msg += '<br>'
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="center" width="100%">'
c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
c_Msg += '    		<p>A SC '+Alltrim(c_NumSC)+' teve sua cota็ใo gerada atrav้s do n๚mero '+c_NumCot+'</p>'
c_Msg += '		</font>'
c_Msg += ' 	</td>'
c_Msg += '  </tr>'
c_Msg += '</table>'
//Itens
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="center" width="10%">Filial</td>'
c_Msg += '  	<td align="center" width="10%">Produto</td>'
c_Msg += '  	<td align="center" width="40%">Descri็ใo</td>'
c_Msg += '  	<td align="center" width="10%">Qtd</td>'
c_Msg += '  	<td align="center" width="10%">C.Custo</td>'
c_Msg += '  	<td align="center" width="30%">Item Cta.</td>'
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
	c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+QRY->C1_ITEMCTA+'</font></td>'
	c_Msg += '  </tr>'
	
	PswOrder(1)
	PswSeek(QRY->C1_USER, .T.)
	a_Ret	:= PswRet(1)
	
	If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
		AADD(a_To,Alltrim(a_Ret[1][14]))
	ENDIF
	
	QRY->(DBSKIP())
ENDDO
QRY->(DBCLOSEAREA())

c_Msg += '</table>'
c_Msg += '<body>'
c_Msg += '</body>'
c_Msg += '</html>'

c_To := a_To[1] //EMAIL DO SOLICITANTE

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

Return()