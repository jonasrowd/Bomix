
//#DEFINE PATH "\SPOOL\COMPRAS\"
#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_OVERWRITEPROMPT )
/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++ Programa  COM_RT03  autor  SANDRO SANTOS  JANEIRO/2013                +++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++ Desc.:    Programa para enviar email da cotacao aos seus fornecedores +++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function COM_RT03()

Local a_AreaSC8		:= SC8->(GETAREA())
Local a_AreASA2		:= SA2->(GETAREA())
Local a_AreASB1		:= SB1->(GETAREA())
Local c_Filial		:= SC8->C8_FILIAL
Local c_NumCot		:= SC8->C8_NUM
Local c_User		:= RetCodUsr()
Local c_NomComp		:= ""
Local c_TelComp		:= ""
Local c_TelFax		:= ""
Local c_EmailComp	:= ""
Local c_Email		:= ""
Local c_Fornece		:= ""
Local c_OBS         := ""
Local c_Corpo		:= ""
Local c_Para		:= ""
Local c_Assunto		:= "Cota��o BOMIX: "+c_NumCot
Local c_Ass1		:= "CONFIRMA��O DE ENVIO COTA��O: "+c_NumCot
Local l_ExibeTela	:= .F.
Local n_Item		:= 1
Local a_Enviado		:= {}
Local _cDescri		:= ""
Local _cDescUm		:= ""
Local cArqSaida
Private c_Ret 

If Aviso(SM0->M0_NOMECOM,"Deseja realmente enviar a cota��o "+c_NumCot+" para todos os seus fornecedores que ainda n�o foram enviados?",{"Sim","N�o"},2,"Aten��o") == 1
	If Aviso(SM0->M0_NOMECOM,"Deseja anexar algum documento?",{"Sim","N�o"},2,"Aten��o") == 1
		cArqSaida := REICON01()
		Alert(cArqSaida)
	Else
		cArqSaida := '1'
	Endif

	BeginSql ALIAS "COTEMAIL"
		SELECT C8_FILIAL, C8_PRODUTO, B1_DESC, C8_FORNECE, C8_LOJA, A2_EMAIL, A2_CONTATO, C8_UM,C8_OBS, SUM(C8_QUANT) AS QTD_COTEMAIL
		FROM %TABLE:SC8% C8
		INNER JOIN %TABLE:SA2% A2 ON (C8_FORNECE = A2_COD AND C8_LOJA = A2_LOJA AND A2.%NOTDEL%)
		INNER JOIN %TABLE:SB1% B1 ON (C8_PRODUTO = B1_COD AND B1.%NOTDEL%)
		WHERE C8.%NOTDEL%
		AND C8_NUM = %EXP:c_NumCot%
		AND C8_FILIAL = %EXP:c_Filial%
		AND C8_FLAGEN <> %EXP:'1'%
		GROUP BY C8_FILIAL, C8_PRODUTO, B1_DESC, C8_FORNECE, C8_LOJA, A2_EMAIL, A2_CONTATO, C8_UM,C8_OBS
		ORDER BY C8_FORNECE, C8_LOJA
	EndSql
	
	DbSelectArea("COTEMAIL")
	COTEMAIL->(DbGoTop())
	While COTEMAIL->( !Eof() )
		
		c_Fornece 	:= COTEMAIL->C8_FORNECE+COTEMAIL->C8_LOJA
		c_Para		:= COTEMAIL->A2_EMAIL
		
		c_Corpo := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
		c_Corpo += '<html xmlns="http://www.w3.org/1999/xhtml" >'
		c_Corpo += '	<head>'
		c_Corpo += '		<title>BOMIX</title>'
		c_Corpo += '	</head>'
		c_Corpo += '	<body>'
		c_Corpo += '    	<table cellpadding = "0" cellspacing = "0" border = "0" width = "1500">'
		c_Corpo += '        	<tr>'
		c_Corpo += '            	<td width = "100%"><font face = "Arial" size = "2">COTA��O : <b>'+c_NumCot+'</b>,</font>'
		c_Corpo += '            	<p><font face="arial" size="2">Prezado(a) '+ALLTRIM(COTEMAIL->A2_CONTATO)+',</font></p>'
		c_Corpo += '            	<p><font face="arial" size="2">Favor cotar os itens abaixo:</font></p>'
		c_Corpo += '            	</td>'
		c_Corpo += '  	      	</tr>'
		c_Corpo += '   	 	</table>'
		c_Corpo += '    	<table cellpadding = "0" cellspacing = "0" border = "1" width = "1050">'
		c_Corpo += '        	<tr>'
		c_Corpo += '            <p align="center">	<td width = "05%"><font face = "Arial" size = "2">ITEM</font></td></center>'
		c_Corpo += '            <p align="center">	<td width = "10%"><font face = "Arial" size = "2">PRODUTO</font></td></center>''
		c_Corpo += '            <p align="center">	<td width = "45%"><font face = "Arial" size = "2">DESCRI��O</font></td></center>''
		c_Corpo += '            <p align="center">	<td width = "10%"><font face = "Arial" size = "2">UM</font></td></center>''
		c_Corpo += '            <p align="center">	<td width = "10%"><font face = "Arial" size = "2">QUANTIDADE</font></td></center>''
		c_Corpo += '            <p align="center">	<td width = "10%"><font face = "Arial" size = "2">PRECO</font></td></center>''
		c_Corpo += '            <p align="center">	<td width = "10%"><font face = "Arial" size = "2">TOTAL</font></td></center>''
		c_Corpo += '        	</tr>'
		
		n_Item := 1
		
		While COTEMAIL->( !Eof() ) .And. COTEMAIL->C8_FORNECE+COTEMAIL->C8_LOJA == c_Fornece
			_cDescri := " "
			_cDescUm := ""
			
			If Empty(_cDescri)
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek( xFilial("SB1")+COTEMAIL->C8_PRODUTO )
				_cDescri := Alltrim(SB1->B1_DESC)
			Endif
						
			If !Empty(_cDescri)
				nTab      := 1
				TamLn1    := 200
				cString   := _cDescri
				QtLN      := MLCOUNT(alltrim(cSTRING),TamLn1,nTAB,.T.) //quant.de linhas do campo memo
				nLINHA    := 1
				
				If !Empty(SB1->B1_DESC)
					_cDescri:=" "
					For X:=1 to MLCOUNT(SB1->B1_DESC, TamLn1 + 5 , 4, .t.)
						_cDescri+= MEMOLINE(SB1->B1_DESC,TamLn1 + 5,X,)     //79
					Next
				Endif
			Endif

			DbSelectArea("SAH")
			DbGoTop()
			DbSetOrder(1)
			If DbSeek(xFilial("SAH")+COTEMAIL->C8_UM)
				_cDescUm := Alltrim(SAH->AH_DESCPO)
			ElsE
				_cDescUm := COTEMAIL->C8_UM
			Endif

			_Var:="."
			
			c_Corpo += '		<tr>'
			c_Corpo += '    	<br>'
			c_Corpo += '        	<td width = "05%"><font face = "Arial" size = "2">'+STRZERO(n_Item,4)+'</font></td>'
			c_Corpo += '        	<td width = "10%"><font face = "Arial" size = "2">'+COTEMAIL->C8_PRODUTO+'</font></td>'
			c_Corpo += '        	<td width = "45%"><font face = "Arial" size = "2">'+_cDescri+'<br><br> <b> OBS : </b>'+COTEMAIL->C8_OBS+'</font></td>'
			c_Corpo += '        	<td width = "10%"><font face = "Arial" size = "2">'+_cDescUm+'</font></td>'
			c_Corpo += '        	<td width = "10%"><font face = "Arial" size = "2">'+TRANSFORM(COTEMAIL->QTD_COTEMAIL,"@E 999,999.99")+'</font></td>'
			c_Corpo += '        	<td width = "10%"><font face = "Arial" size = "2">'+_Var+'  </font></td>'
			c_Corpo += '    		<td width = "10%"><font face = "Arial" size = "2">'+_Var+' </font></td>'
			c_Corpo += '		</tr>'
			n_Item++
			
			COTEMAIL->( DbSkip() )
		Enddo
		
		DbSelectArea("SY1")
		DbSetOrder(3)
		If DbSeek(xFilial("SY1")+c_User,.T.)
			c_TelComp	:= SY1->Y1_TEL
			c_TelFax	:= SY1->Y1_FAX
			c_NomComp	:= SY1->Y1_NOME
			c_EmailComp	:= SY1->Y1_EMAIL
		Endif
				
		c_Corpo += '    	<br>'
		c_Corpo += '    	<br>'
		c_Corpo += '    	</table>'
		c_Corpo += '    	<br>'
		c_Corpo += '    	<table cellpadding = "0" cellspacing = "0" border = "0" width = "1500">'
		c_Corpo += '        	<tr>'
		c_Corpo += '    		<br>'
		c_Corpo += '            <p><font face = "Arial" size = "2">Informe a condi��o de pagamento: ______________</font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '            <p><font face = "Arial" size = "2">Informe prazo de entrega       : ______________</font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '            <p><font face = "Arial" size = "2">Informe a Validade da proposta : ______________</font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '  	      	</tr>'
		c_Corpo += '   	 	</table>'
		c_Corpo += '    	<br>'			
		c_Corpo += '    	</table>'
		c_Corpo += '    	<table cellpadding = "0" cellspacing = "0" border = "0" width = "1500">'
		c_Corpo += '        	<tr>'
		c_Corpo += '            	<td width = "100%"><font face = "Arial" size = "2"></font>'
		c_Corpo += '            		<p><font face="arial" size="2">OBS. 1: Nas aquisi��es de materiais de consumo e ativo imobilizado,quando realizadas fora do Estado da Bahia, o fornecedor ser� o </font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">respons�vel pelo recolhimento do imposto decorrente da diferen�a entre a aliquota interna do Estado da Bahia em rela��o � aliquota do	 </font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">Estado de Origem, anexando c�pia do DAE pago � Nota Fiscal de Fornecimento. </font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '            		<p><font face="arial" size="2">OBS. 2: Os dados constantes da nota fiscal dever�o ser transmitidos atrav�s de programa disponibilizado pela secretariada fazenda,no	 </font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">endere�o eletronico www.sefaz.ba.gov.br, cujo comprovante de transmiss�o dever� ser anexado ao documento fiscal(compra legal)</font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">e conforme artigo 228B do ICMS/BA, Decreto 6284 de 14/03/1997</font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '            		<p><font face="arial" size="2">OBS. 3: � obrigat�rio informar a classifica��o fiscal NCM( Nomenclatura Comum do Mercosul ) do produto na Nota Fiscal.	 </font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '            		<p><font face="arial" size="2">OBS. 4: Condi��o de pagamento at� 08 dias ut�is.							 </font></p>'
		c_Corpo += '    		<br>'
		c_Corpo += '           			<p><font face = "Arial" size = "2">Em caso de d�vidas entrar em contato com nosso Se��o de Compras.</font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">Comprador: <b>'+c_NomComp+'</b></font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">Telefone / Fax: '+c_TelComp+' / '+c_TelFax+'</font></p>'
		c_Corpo += '            		<p><font face="arial" size="2">e-mail: '+c_EmailComp+'</font></p>'
		c_Corpo += '            		<p><font face="arial" size="2"><b>Favor confimar o recebimento deste e-mail para '+c_EmailComp+'</b></font></p>'		
		c_Corpo += '            	</td>'
		c_Corpo += '  	      	</tr>'
		c_Corpo += '   	 	</table>'
		c_Corpo += '	</body>'
		c_Corpo += '</html>'
				
		If !Empty(c_Para)
			U_COM_RT02(c_Para,c_Corpo,c_Assunto,l_ExibeTela,,cArqSaida )
			aAdd(a_Enviado,{c_Fornece})			
		Endif
	Enddo
	
	COTEMAIL->( DbCloseArea() )
	
	For nX:=1 to Len(a_Enviado)
		DbSelectArea("SC8")
		DbSetOrder(1)
		DbSeek(c_Filial+c_NumCot+a_Enviado[nX][1])
		While SC8->(!Eof()) .And. SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA == c_Filial+c_NumCot+a_Enviado[nX][1]
			RecLock("SC8",.F.)
				SC8->C8_TBDTENV := DDATABASE
			MsUnLock()			                     
			SC8->( DbSkip() )
		Enddo
	Next
Endif

RestArea(a_AreaSC8)
RestArea(a_AreASA2)
RestArea(a_AreASB1)

Return()

************************
Static Function REICON01()
************************
Local cTipoArq := "*.PDF"
Local c_Local      := "\SPOOL\COMPRAS\"

c_Ret    := cGetFile(cTipoArq, OemToAnsi("Abrir Arquivo..."), 0, c_Local, .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

Return( Upper(c_Ret) )