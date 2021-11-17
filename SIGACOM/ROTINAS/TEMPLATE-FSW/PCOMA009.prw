#include "protheus.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOMA009  �Autor  �Adriano Alves      � Data � Outubro/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa chamado na analise da cotacao, usado para enviar  ���
���          � um e-mail para o solicitante.                              ���
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
User Function PCOMA009(c_NumCot, c_Pedido)
Local c_To		:= ""
Local c_Subj	:= "Geracao de Cotacao "+c_NumCot
Local c_Msg		:= ""
Local a_To		:= {}
Local a_Ret		:= {}
Local c_Anexo	:= {}

DBSELECTAREA("SC1")
DBSETORDER(5)
IF (DBSEEK(XFILIAL("SC1")+c_NumCot))
	
	PswOrder(1)
	PswSeek(SC1->C1_USER, .T.)
	a_Ret	:= PswRet(1)
	
	If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
		AADD(a_To,Alltrim(a_Ret[1][14]))
	ENDIF
	
	c_To := a_To[1]  //EMAIL DO SOLICITANTE 
	
	a_To		:= {}
	a_Ret		:= {}
					
	PswOrder(1)
    PswSeek(__CUSERID, .T.)
    a_Ret    := PswRet(1)
               
	If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
    	AADD(a_To,Alltrim(a_Ret[1][14]))
    ENDIF
               
    c_To += ";"+a_To[1]  //EMAIL DO COMPRADOR
	
	//���������������������������������������������������������������������������������Ŀ
	//�Envia e-mail para o gerente de suprimentos informando que a cotacao foi analisada�
	//�����������������������������������������������������������������������������������
	c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
	c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
	c_Msg += '<head>'
	c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
	c_Msg += '<title>Liberação de SC</title>'
	c_Msg += '</head>'
	c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">An�lise de Cota��o</font></td>'
	c_Msg += '  </tr>'
	c_Msg += '</table>'
	c_Msg += '<br>'
	c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="100%">'
	c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
	c_Msg += '    		<p>A cota��o '+c_NumCot+' foi analisada e foi gerada o pedido: '+c_Pedido+'</p>'
	c_Msg += '		</font>'
	c_Msg += ' 	</td>'
	c_Msg += '  </tr>'
	c_Msg += '</table>'
	//Itens
	c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="10%">Filial</td>'
	c_Msg += '  	<td align="center" width="10%">Produto</td>'
	c_Msg += '  	<td align="center" width="40%">Descri��o</td>'
	c_Msg += '  	<td align="center" width="10%">Qtd</td>'
	c_Msg += '  	<td align="center" width="10%">Vlr. Ref.</td>'
	c_Msg += '  	<td align="center" width="10%">Total Ref.</td>'
	c_Msg += '  	<td align="center" width="10%">C.Custo</td>'   
	c_Msg += '  	<td align="center" width="30%">Item Cta.</td>'   
	c_Msg += '  </tr>'
	
	DBSELECTAREA("SC7")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC7")+c_Pedido)
	WHILE SC7->(!EOF()).AND.SC7->C7_FILIAL+SC7->C7_NUM==XFILIAL("SC7")+c_Pedido
 
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_PRODUTO+'</font></td>'
		c_Msg += '  	<td align="center" width="40%"><font face="Arial" size="2">'+SC7->C7_DESCRI+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(SC7->C7_QUANT,"@e 999,999,999.99")+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(SC7->C7_PRECO,"@e 999,999,999.99")+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(SC7->C7_TOTAL,"@e 999,999,999.99")+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_CC+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_ITEMCTA+'</font></td>'
		c_Msg += '  </tr>'
		SC7->(DBSKIP())
		
	ENDDO
	
	c_Msg += '</table>'
	c_Msg += '<body>'
	c_Msg += '</body>'
	c_Msg += '</html>'
	
	c_Subj	:= "An�lise da Cota��o :: "+c_NumCot

	//����������������������������������������������������������������Ŀ
	//�Chama a fun��o que envia email:                                 �
	//�                                                                �
	//�1� Par�metro: Para                                              �
	//�2� Par�metro: Corpo do Email                                    �
	//�3� Par�metro: Assunto                                           �
	//�4� Par�metro: Se exibe a tela informando que o email foi enviado�
	//�5� Par�metro: Anexo                                             �
	//������������������������������������������������������������������
	
	U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)
	
ENDIF

Return()