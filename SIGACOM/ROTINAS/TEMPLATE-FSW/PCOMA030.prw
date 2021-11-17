#include "protheus.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOMA030      �Autor  �DIEGO ARGOLO      � Data �29/07/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa chamado na geracao da solicita��o de compra       ���
���          � usado para enviar um e-mail para os compradores.           ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
c_Msg += '<title>Liberação de SC</title>'
c_Msg += '</head>'
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Gera��o de Solicita��o de Compra</font></td>'
c_Msg += '  </tr>'
c_Msg += '</table>'
c_Msg += '<br>'
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="left" width="100%">'
c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
c_Msg += '    		<p>Prezado Usu�rio sua Solicita��o de Compra Nr. '+Alltrim(c_NumSC)+' j� foi enviada ao seu gestor, por favor aguardar aprova��o.</p>'
c_Msg += '		</font>'
c_Msg += ' 	</td>'
c_Msg += '  </tr>'
c_Msg += '</table>'
//Itens
c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
c_Msg += '  <tr>'
c_Msg += '  	<td align="center" width="10%">Filial</td>'
c_Msg += '  	<td align="center" width="10%">Produto</td>'
c_Msg += '  	<td align="center" width="60%">Descri��o</td>'
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
		Conout("N�o foi encontrado e-mail informado no cadastro de compradores, favor verificar o cadastro.")
	Else
		Alert("N�o foi encontrado e-mail informado no cadastro de compradores, favor verificar o cadastro.")
	Endif
	Return
Endif

//����������������������������������������������������������������Ŀ
//�Chama a fun��o que envia email:                                 �
//�                                                                �
//�1� Par�metro: Para                                              �
//�2� Par�metro: Corpo do Email                                    �
//�3� Par�metro: Assunto                                           �
//�4� Par�metro: Se exibe a tela informando que o email foi enviado�
//�5� Par�metro: Anexo                                             �
//������������������������������������������������������������������

U_TBSENDMAIL(c_To, c_Msg, c_Subj, .T., c_Anexo)

Return()