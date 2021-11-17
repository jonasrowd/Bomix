/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOMA032      �Autor  �DIEGO ARGOLO     � Data �  29/07/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa chamado na geracao do PC, usado para enviar  	  ���
���          � e-mail para os aprovadores do primeiro nivel.              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PCOMA032(c_Pedido,c_Rotina)

Local c_NumPed	:= c_Pedido
Local a_Ret     := {}
Local c_To		:= ""
Local c_Msg		:= ""
Local c_Subj	:= "Liberacao de Pedido de Compra: "+c_NumPed
Local c_ForLoj	:= ""
Local l_TipoDoc	:= SuperGetMV("MV_APRPCEC",.F.,.F.)
Local c_TpDoc	:= Iif(l_TipoDoc, "IP","PC")

Private o_aprov := clsAlcadas():New()

IF ( c_Rotina == "CNTA120" )
	
	Return()

Else
	//				 U_TGENEMAILAPRV(c_NumPed,.T.,"PC","1")
	c_To 	+= o_aprov:mtdEmailAprov(c_NumPed,.T.,c_TpDoc,"1") //aprovadores pendentes de libera��o
	
	//������������������������Ŀ
	//�Retira o ponto e virgula�
	//��������������������������
	c_To := Substr(c_To,1,Len(c_To)-2)
	
	c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
	c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
	c_Msg += '<head>'
	c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
	//c_Msg += '<title>Liberação de SC</title>'
	c_Msg += '<title>Libera��o de SC (Purchase Authorization Request)</title>'
	c_Msg += '</head>'
	c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Libera��o de Pedido de Compra (Authorization of Purchase Order)</font></td>'
	c_Msg += '  </tr>'
	c_Msg += '</table>'
	c_Msg += '<br>'
	c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="100%">'
	c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
	c_Msg += '    		<p>O PC '+c_NumPed+' est� aguardando a sua libera��o (The purchase order '+c_NumPed+' is awaiting your approval).</p>'
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
	c_Msg += '  	<td align="center" width="10%">CC</td>'
	c_Msg += '  	<td align="center" width="10%">CR</td>'
	c_Msg += '  </tr>'
	
	DBSELECTAREA("SC7")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC7")+c_NumPed)
	WHILE SC7->(!EOF()).AND.SC7->C7_FILIAL+SC7->C7_NUM==XFILIAL("SC7")+c_NumPed
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
	
	// Inserida informa��o dos aprovadores
	
	c_Msg += '</table>'
	c_Msg += '<br>'
	c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
	c_Msg += '  <tr>'
	c_Msg += '  	<td align="center" width="10%">Aprovador</td>'
	c_Msg += '  	<td align="center" width="10%">Data Libera��o</td>'
	c_Msg += '  </tr>'
	
	DBSELECTAREA("SCR")
	DBSETORDER(1)
	MsSeek(xFilial('SCR')+"PC"+c_NumPed,.T.)  		
	While SCR->(!Eof()).and. Alltrim(CR_NUM)==Alltrim(c_NumPed)
		_cData:= Substring(Dtos(SCR->CR_DATALIB),7,2)+"/"+Substring(Dtos(SCR->CR_DATALIB),5,2)+"/"+Substring(Dtos(SCR->CR_DATALIB),1,4)	
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+USRRETNAME(SCR->CR_USER)+'</font></td>'
		c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+_cData+'</font></td>'
		c_Msg += '  </tr>'
		SCR->(DBSKIP())
	ENDDO
	
	U_TBSENDMAIL(c_To, c_Msg, c_Subj,.T.)

EndIf

Return