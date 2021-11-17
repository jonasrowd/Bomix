#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "msobjects.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "PCOMA013.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOMA013  ºAutor  ³ Rafael Santiago   º Data ³ novembro/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envio de Pedido de compra em formato html                   º±±
±±º          ³                                                            º±±
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
User Function PCOMA013(c_FilPed, c_NumPed)

	local c_Forn
	local c_Corpo 		:= ""
	local c_Cabec 		:= ""
	local c_TpFrete 	:= "Indefinido"
	local c_obsc 		:= ""
	Local c_Numsa 		:= ""
	Local a_Ret			:= {}
	Local a_To			:= {}
	local c_NomeAprov 	:= ""
	local c_NomeSolic 	:= ""

	private n_Total 	:= 0
	private n_TotFrete 	:= 0
	private c_Pais 		:= ""
	private c_Estado 	:= ""

	Default c_FilPed 	:= "01"
	Default c_NumPed 	:= "000007"

	dbSelectArea("SC7")
	dbSetOrder(1)
	if dbSeek(c_FilPed + c_NumPed,.t.)

		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA)

		_cMailFornec := alltrim(SA2->A2_EMAIL)
		c_Pais := SA2->A2_PAIS
		c_Estado := SA2->A2_EST

		if (alltrim(SC7->C7_CONTATO) <> "")
			_cNomeFornec := ALLTRIM(SC7->C7_CONTATO)
		else
			_cNomeFornec := ALLTRIM(SA2->A2_NOME)
		endif

		c_NomeAprov	:= RetNomeAprov(SC7->C7_FILIAL,SC7->C7_NUM)

		PswOrder(1)
//		PswSeek(SC7->C7_TBSOLIC, .T.)
		_aRet    := PswRet(1)
		c_NomeSolic := _aRet[1][4]

		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+SC7->C7_COND)

		if (SC7->C7_TPFRETE = "C")
			c_TpFrete := "CIF"
		elseif (SC7->C7_TPFRETE = "F")
			c_TpFrete := "FOB"
		endif

			c_Cabec +=	'  <b>'+STR0001+'</b>&nbsp;' + SC7->C7_NUM  //"Pedido:"
			c_Cabec +=	'  &nbsp;&nbsp;&nbsp;<b>'+STR0002+'</b>&nbsp;' + dtoc(SC7->C7_EMISSAO)  //"Emissao:"
			c_Cabec +=	'  &nbsp;&nbsp;&nbsp;<b>'+STR0003+'</b>&nbsp;' + SE4->E4_COND + " - " + SE4->E4_DESCRI  //"Cond. Pgto:"
			c_Cabec +=	IIF(c_TpFrete <> 'Indefinido','  &nbsp;&nbsp;&nbsp;<b>'+STR0004+'</b>&nbsp;' + c_TpFrete,'') //"Tipo Frete:"
			c_Cabec +=	iif(ALLTRIM(SC7->C7_CONTRA) <> "",'&nbsp;&nbsp;&nbsp;<b>'+STR0005+'</b>&nbsp;' + SC7->C7_CONTRA,'') //"Contrato:"
			c_Cabec +=	'  &nbsp;&nbsp;&nbsp;<b>'+STR0006+'</b>&nbsp;' +  c_NomeSolic  //"Solicitante:"
			c_Cabec +=	iif(c_NomeAprov <> "Indefinido",'<br/><b>'+STR0007+'</b>&nbsp;' + c_NomeAprov,'') //"Aprovado por:"
			// c_Cabec +='  <td align="left">' + MSMM(SB1->B1_VM_PROC,,,,3,,,"SB1",B1_PROC) + '</td> ' 

		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(c_FilPed + c_NumPed)
		c_obsc :=  SC7->C7_OBS

		DBSELECTAREA("SCP")
		dbSetOrder(1)
		dbseek(c_FilPed+SC7->C7_NUMSC)

		c_Numsa := SCP->CP_NUM

		EnviarEmail(_cMailFornec,_cNomeFornec,c_Cabec,c_Corpo, c_FilPed, c_NumPed,c_obsc,c_Numsa)

		alert(STR0008 + _cNomeFornec + STR0009 + c_NumPed + ".","ALERT","ALERT")  //"Email enviado com sucesso para " ... " avisando-o sobre a aprovação do pedido "
	else
		alert("Não foi possível enviar email de aviso ao fornecedor do pedido.") //STR0010
	endif

	Return()

static function RetNomeAprov(_cFilial,_cPedido)
	local _cResult := "Indefinido"

	local _cQry := ;
		"select " +;
		"  AK_NOME " +;
		"from " +;
		"  " + retsqlname("SCR") + " SCR " +;
		"  JOIN " + retsqlname("SAK") + " SAK " +;
		"    ON(SAK.AK_USER = SCR.CR_USER AND SAK.D_E_L_E_T_ <> '*') " +;
		"WHERE " +;
		"  SCR.D_E_L_E_T_ <> '*' AND SCR.CR_TIPO = 'PC' AND (SCR.CR_NIVEL = '01') AND (SCR.CR_STATUS = '05' OR SCR.CR_STATUS = '03') AND SCR.CR_FILIAL = '" + _cFilial + "' AND SCR.CR_LIBAPRO <> '      '  AND SCR.CR_NUM = '" + _cPedido + "' "


	TCQUERY _cQry NEW ALIAS APROV

	dbSelectArea("APROV")
	if !EOF()
		_cResult := ALLTRIM(APROV->AK_NOME)
	endif

	dbSelectArea("APROV")
	dbCloseArea()
	return _cResult

static function EnviarEmail(c_to, _cNome, c_Cabec, c_Corpo, c_FilPed, c_NumPed, c_obsc, c_Numsa)

	Local c_Linha 	:= ""
	local _oEmail
	Local c_Subj1	:= STR0011 + c_NumPed //"Liberação do Pedido: "
	Local c_TXT		:= ft_fuse("CondicoesComerciais.txt")
	
	c_Corpo +=	'<p>'+STR0012+alltrim(_cNome)+ ',</p>' //"Prezado(a) "
	c_Corpo +=	'<p>'+STR0013+SM0->M0_NOMECOM+","+STR0014+"</p>"  //"Solicitamos de imediato a confirmação do recebimento dessa mensagem. O pedido de compra foi aprovado pela " ... " observe as condições comerciais"
	c_Corpo +=	'<table>' 
	c_Corpo +=	'<tr>'
	c_Corpo +=	'  <td align="left" style="background-color: #EEEEEE; padding: 10px;">' 
	c_Corpo +=  c_Cabec 
	c_Corpo +=	'  </td>' 
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'<td align="left" style="padding-top: 10px; padding-bottom: 10px;">' 
	c_Corpo +=	'<table cellspacing="0" border="1" cellpadding="4">' 
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0015+'</th> ' //"Entrega"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0016+'</th> ' //"Item"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0017+'</th> ' //"Cod. Produto"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="left">'+STR0018+'</th> '  //"Descrição"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="left">'+STR0019+'</th> '  //"Descrição Detalhada"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0020+'</th> '  //"S.C."
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0021+'</th> '  //"UM"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0022+'</th> '  //"Quant"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0023+'</th> '  //"IPI"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0024+'</th> '  //"VL.Unitario"
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0025+'</th> '   //"Valor"
	c_Corpo +=	'</tr>' 
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	if dbSeek(c_FilPed + c_NumPed,.t.)
	    
		PswOrder(1)
        PswSeek(SC7->C7_USER, .T.)
        a_Ret    := PswRet(1)
               
	    If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
          	AADD(a_To,Alltrim(a_Ret[1][14]))
        ENDIF
               
     	c_To += ";"+a_To[1]  //EMAIL DO COMPRADOR
	
		DBSELECTAREA("SC1")
		DBSETORDER(1)
		IF (DBSEEK(XFILIAL("SC1")+SC7->C7_NUMSC))
		
			a_To		:= {}
			a_Ret		:= {}    
		
			PswOrder(1)
			PswSeek(SC1->C1_USER, .T.)
			a_Ret	:= PswRet(1)
			
			If Ascan(a_To,Alltrim(a_Ret[1][14]))==0
				AADD(a_To,Alltrim(a_Ret[1][14]))
			ENDIF
			
		   	c_To += ";"+a_To[1]  //EMAIL DO SOLICITANTE
		EndIf
	EndIf
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	if dbSeek(c_FilPed + c_NumPed,.t.)
		
		while !EOF() .AND. SC7->C7_FILIAL = c_FilPed .AND. SC7->C7_NUM = c_NumPed
			dbselectarea("SC1")
			DBSETORDER(1)
			dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)
       	
			dbselectarea("SB1")
			DBSETORDER(1)
			dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
       	
			c_Corpo +=	'<tr>' 
			c_Corpo += 	'  <td align="center">' + DTOC(SC7->C7_DATPRF) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(SC7->C7_ITEM) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(SC7->C7_PRODUTO) + '</td> ' 
			c_Corpo += 	'  <td align="left">' 	+ alltrim(SC7->C7_DESCRI) + '</td> ' 
		 	c_Corpo += 	'  <td align="left">' 	+ alltrim(SB1->B1_FSDESC) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(SC7->C7_NUMSC) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(SC7->C7_UM) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(str(SC7->C7_QUANT)) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(Trans(SC7->C7_VALIPI,"@E@R 999,999,999.	99")) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(Trans(SC7->C7_PRECO,"@E@R 999,999,999.99")) + '</td> ' 
			c_Corpo += 	'  <td align="center">' + alltrim(Trans(SC7->C7_TOTAL,"@E@R 999,999,999.99")) + '</td> ' 
			c_Corpo += 	'</tr>'

	 		n_Total += SC7->C7_TOTAL + SC7->C7_VALIPI - SC7->C7_VLDESC
			n_TotFrete += SC7->C7_VALFRE

	   		dbSelectArea("SC7")
			dbSkip()

		enddo
	endif
		   
	c_Corpo += 	'<tr>' 
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0026+'</th> '   //"Total do Frete"
	c_Corpo +=	'  <td align="center" colspan=9">&nbsp;</th> ' 
	c_Corpo +=	'  <td align="center">' + alltrim(Trans(n_TotFrete,"@E@R 999,999,999.99")) + '</td> ' 
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0027+'</th> '   //"Total do Pedido"
	c_Corpo +=	'  <td align="center" colspan=9">&nbsp;</th> ' 
	c_Corpo +=	'  <td align="center">' + alltrim(Trans(n_Total,"@E@R 999,999,999.99")) + '</td> ' 
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'</table>' 
	c_Corpo +=	'</td>' 
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0028+'</th> '   //"Observações Gerais"
	c_Corpo +=	'  <td align="center" colspan=9">&nbsp;</th> ' 
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'<td align="center">' + c_obsc + "  " + c_Numsa +'</td> ' 
	c_Corpo +=	'</tr>'
	c_Corpo +=	'<tr>'
   	c_Corpo +=	'  <th style="color: white; background-color: black;" align="center">'+STR0029+'</th> '  //"Observação do Pedido"
	c_Corpo +=	'  <td align="center" colspan=9">&nbsp;</th> ' 
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'  <td align="left" style="background-color: #EEEEEE; padding: 10px;">'
	c_Corpo +=	'  <b>'+STR0030+'</b><br/>&nbsp;&nbsp;&nbsp;' + SM0->M0_ENDCOB + ", " + SM0->M0_CIDCOB +  ", " + SM0->M0_ESTCOB + " - CEP: " + SM0->M0_CEPCOB +  ", CNPJ: "+ SM0->M0_CGC + "<br/>"   //"Endereço de Faturamento:"
	c_Corpo +=	'  &nbsp;&nbsp;&nbsp;'+STR0031+ SM0->M0_TEL  //"Contato para Atendimento – "
	c_Corpo +=	'  </td>'
	c_Corpo +=	'<tr>' 
	c_Corpo +=	'  <td align="left" style="background-color: #EEEEEE; padding: 10px;">'
	c_Corpo +=	'  <b>'+STR0032+'</b><br/>&nbsp;&nbsp;&nbsp;' + SM0->M0_ENDENT + ", " + SM0->M0_CIDENT +  ", " + SM0->M0_ESTENT + " - CEP: " + SM0->M0_CEPENT +  ", CNPJ: "+ SM0->M0_CGC + "<br/>"  //"Endereço de Entrega:"
	c_Corpo +=	'  &nbsp;&nbsp;&nbsp;'+STR0031+ SM0->M0_TEL   //"Contato para Atendimento – "
	c_Corpo +=	'  </td>'
	c_Corpo +=	'</tr>' 
	c_Corpo +=	'</table>' 
	c_Corpo +=	'<br/><br/>' 

	IF (c_TXT <> -1)				
		FT_FGoTop()
			While !FT_FEOF()
				c_Linha += FT_FReadLn()
				FT_FSKIP()
			EndDo
	ENDIF				
			
	c_Corpo += c_Linha

	memowrit("mt097end.html",c_Corpo)

	U_TBSENDMAIL(c_To, c_Corpo, c_Subj1, .F.)

	return
