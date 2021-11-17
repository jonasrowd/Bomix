#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณPCOMA012  บAutor  ณAdriano Alves      บ Data ณ Outubro/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa chamado na inclusao da nota de entrada, usado     บฑฑ
ฑฑบ          ณ para enviar um e-mail para o solicitante.                  บฑฑ
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
User Function PCOMA012(c_Doc, c_Serie, c_Fornece, c_Loja)

Local a_SA2Area	:= SA2->(GetArea())
Local a_SD1Area	:= SD1->(GetArea())
Local a_SDEArea	:= SDE->(GetArea())
Local a_SE2Area	:= SE2->(GetArea())
Local a_SE1Area	:= SE1->(GetArea())
Local a_SF1Area	:= SF1->(GetArea())

Local c_Subj	:= "Entrada de Nota fiscal "+ALLTRIM(c_Doc)
Local c_To		:= ""
Local c_Msg		:= ""
Local c_Qry		:= ""
Local a_To		:= {}
Local a_Ret		:= {}
Local c_Anexo	:= {}
Local c_Pedido	:= ""
Local c_NumSC	:= ""
Local c_Desc	:= ""

//BUSCA O PEDIDO
DBSELECTAREA("SD1")
DBSETORDER(1)
DBSEEK(XFILIAL("SD1")+c_Doc+c_Serie+c_Fornece+c_Loja)
IF FOUND()

	c_Pedido:= ALLTRIM(SD1->D1_PEDIDO)

	//BUSCA A SC
	DBSELECTAREA("SC7")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC7")+c_Pedido)
	IF FOUND()

		c_NumSC:= ALLTRIM(SC7->C7_NUMSC)

		PswOrder(1)
        PswSeek(SC7->C7_USER, .T.)
        a_Ret    := PswRet(1)

	    If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
          	AADD(a_To,Alltrim(a_Ret[1][14]))
        ENDIF

     	c_To := a_To[1]  //EMAIL DO COMPRADOR

		//BUSCA O CODIGO DO USUARIO PARA PEGAR O EMAIL
		DBSELECTAREA("SC1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC1")+c_NumSC)
		IF FOUND()

		   	a_To		:= {}
			a_Ret		:= {}

	    	PswOrder(1)
			PswSeek(SC1->C1_USER, .T.)
			a_Ret	:= PswRet(1)

			If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
				AADD(a_To,Alltrim(a_Ret[1][14]))
			ENDIF

			c_To += ";"+a_To[1] //EMAIL DO SOLICITANTE

	   		c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
			c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
			c_Msg += '<head>'
			c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
			c_Msg += '<title>Liberaรงรฃo de SC</title>'
			c_Msg += '</head>'
			c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
			c_Msg += '  <tr>'
			c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Entrada de Nota Fiscal</font></td>'
			c_Msg += '  </tr>'
			c_Msg += '</table>'
			c_Msg += '<br>'
			c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
			c_Msg += '  <tr>'
			c_Msg += '  	<td align="center" width="100%">'
			c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
			//c_Msg += '    		<p>Foi dado entrada na Nota fiscal '+ALLTRIM(c_Doc)+' referente ao pedido '+c_Pedido+" e a SC "+c_NumSC+"' </p>'
			c_Msg += '    		<p>Prezado Usuแrio seu pedido Nr. '+c_Pedido+'  jแ foi recebido pelo almoxarifado, por favor prepare sua SA e retire o material. </p>'
		 	c_Msg += '		</font>'
			c_Msg += ' 	</td>'
			c_Msg += '  </tr>'
			c_Msg += '</table>'
			//Itens
			c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
			c_Msg += '  <tr>'
			c_Msg += '  	<td align="center" width="07%">Filial</td>'
			c_Msg += '  	<td align="center" width="10%">Produto</td>'
			c_Msg += '  	<td align="center" width="40%">Descricao</td>'
			c_Msg += '  	<td align="center" width="10%">Quant</td>'
			c_Msg += '  	<td align="center" width="30%">Vlr.Unit</td>'
			c_Msg += '  	<td align="center" width="30%">Total</td>'
			c_Msg += '  </tr>'

			DBSELECTAREA("SD1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SD1")+c_Doc+c_Serie+c_Fornece+c_Loja)
			WHILE(SD1->(!EOF())) .AND. (XFILIAL("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == XFILIAL("SD1")+c_Doc+c_Serie+c_Fornece+c_Loja)

				DBSELECTAREA("SB1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SB1")+SD1->D1_COD)
				c_Desc:= SB1->B1_DESC

				c_Msg += '  <tr>'
				c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
				c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+ALLTRIM(SD1->D1_COD)+'</font></td>'
				c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+ALLTRIM(c_Desc)+'</font></td>'
			   	c_Msg += '  	<td align="center" width="40%"><font face="Arial" size="2">'+cValToChar(SD1->D1_QUANT)+'</font></td>'
				c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(+SD1->D1_VUNIT,"@e 999,999,999.99")+'</font></td>'
				c_Msg += '  	<td align="center" width="10%"><font face="Arial" size="2">'+Transform(+SD1->D1_TOTAL,"@e 999,999,999.99")+'</font></td>'
				c_Msg += '  </tr>'

				SD1->(DBSKIP())

			ENDDO

			c_Msg += '  </tr>'
			c_Msg += '</table>'
			c_Msg += '<body>'
			c_Msg += '</body>'
			c_Msg += '</html>'

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

ENDIF

RestArea(a_SE1Area)
RestArea(a_SE2Area)
RestArea(a_SF1Area)
RestArea(a_SDEArea)
RestArea(a_SD1Area)
RestArea(a_SA2Area)

Return()