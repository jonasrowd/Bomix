#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

User Function PCOMR003(l_AdicCamp,c_TempFile)

	Local c_Numero	:= SC7->C7_NUM
	Local c_Fornec	:= SC7->C7_FORNECE
	Local c_Loja	:= SC7->C7_LOJA
	Local c_TxtPed	:= ""
	Local cDescPro	:= ""
	Local cObsItem	:= ""
	Local c_TxtC1	:= ""
	Local cObsC1	:= ""
	Local n_Total	:= 0
	Local n_TotIPI	:= 0
	Local n_TotIcms	:= 0
	Local n_VlDesc	:= 0
	Local n_TotFret	:= 0
	
	Default l_AdicCamp	:=	.T.
	Default c_TempFile	:=	""

	dbSelectArea("SA2")
	dbSetorder(1)
	dbSeek(xFilial("SA2") + c_Fornec + c_Loja, .T.)

	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7") + c_Numero )

	c_TxtPed	:= "<style>"
	c_TxtPed	+= ".Label {"
	c_TxtPed	+= "    text-align: left;"
	c_TxtPed	+= "    color: black;"
	c_TxtPed	+= "	font-family: Verdana;"
	c_TxtPed	+= "	font-size: 12px;"
	c_TxtPed	+= "}"
	c_TxtPed	+= "</style>"
	c_TxtPed	+= "<table border=1 cellpadding=1 cellspacing=1 width=1350>"
	c_TxtPed	+= "	<tr>"
	c_TxtPed	+= "		<td>"
	c_TxtPed	+= "			<table border=0 cellpadding=1 cellspacing=1 width=100%>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>PEDIDO DE COMPRA</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Empresa: </b>" + SM0->M0_NOMECOM
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Comprador: </b>" + SC7->C7_USER
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>No.: </b>" + c_Numero
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>CNPJ:</b> " + SM0->M0_CGC
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Telefone:</b> " + SM0->M0_TEL
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>DATA DE EMISSAO</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Endereço: </b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>E-mail: </b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>" + DTOC( SC7->C7_EMISSAO ) + "</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "					<b>Cidade:</b> " + SM0->M0_CIDCOB + " <b>UF: </b>" + SM0->M0_ESTCOB
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						&nbsp;"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "			</table>"
	c_TxtPed	+= "			<table border=1 cellpadding=1 cellspacing=1 width=100%></table>"
	c_TxtPed	+= "			<table border=0 cellpadding=1 cellspacing=1 width=100%>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Fonecedor: </b>" + SA2->A2_NREDUZ
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Telefone: </b>" + SA2->A2_TEL
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>CNPJ: </b>" + SA2->A2_CGC
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Vendedor: </b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Endereço: </b>" + SA2->A2_END
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Condição de Pagamento: </b>" + POSICIONE("SE4",1,XFILIAL("SE4") + SC7->C7_COND,"E4_DESCRI")
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						<b>Cidade:</b> " + SA2->A2_MUN + " <b>UF: </b>" + SA2->A2_EST
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td>"
	c_TxtPed	+= "						&nbsp;"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "				</tr>"
	c_TxtPed	+= "			</table>"
	c_TxtPed	+= "			<table border=1 cellpadding=1 cellspacing=1 width=100%></table>"
	c_TxtPed	+= "			<table border=0 cellpadding=1 cellspacing=1 width=100%>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>ITEM</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>PRODUTO</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='left'>"
	c_TxtPed	+= "						<b>DESCRIÇÃO</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>UM</b>"
	c_TxtPed	+= "					</td>"
	If SC7->(FieldPos("C7_FSMARCA")) > 0
		c_TxtPed+= "					<td align='right'>"
		c_TxtPed+= "						<b>MARCA</b>"
		c_TxtPed+= "					</td>"
	Endif
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>QUANTIDADE</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>PREÇO (R$)</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>VALOR TOTAL (R$)</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='center'>"
	c_TxtPed	+= "						<b>DATA DE ENTREGA</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>FRETE (R$)</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>IPI (R$)</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>ICMS (R$)</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='right'>"
	c_TxtPed	+= "						<b>DESCONTOS (R$)</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='left'>"
	c_TxtPed	+= "						<b>NUMERO SC</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='left'>"
	c_TxtPed	+= "						<b>ITEM SC</b>"
	c_TxtPed	+= "					</td>"
	c_TxtPed	+= "					<td align='left'>"
	c_TxtPed	+= "						<b>CENTRO DE CUSTO</b>"
	c_TxtPed	+= "					</td>"
	If l_AdicCamp //Adiciona campos de data e ultimo preço de compra
		c_TxtPed	+= "				<td align='left'>"
		c_TxtPed	+= "					<b>DT.ULT.PRECO</b>"
		c_TxtPed	+= "				</td>"	
		c_TxtPed	+= "				<td align='left'>"
		c_TxtPed	+= "					<b>ULTIMO PRECO (R$)</b>"
		c_TxtPed	+= "				</td>"
	Endif
	c_TxtPed	+= "				</tr>"

	While SC7->(!EOF()) .And. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + c_Numero

		dbSelectArea("SC1")
		dbSetOrder(1)
		dbSeek( xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC )
		
		If !Empty(SC1->C1_FSJUS)

			cObsC1 := " Item - " + SC7->C7_ITEM + ": " + SC1->C1_FSJUS

			c_TxtC1	+= "				<tr class=Label>"
			c_TxtC1	+= "					<td colspan=6 align='left'>" + cObsC1 + "</td>"
			c_TxtC1	+= "				</tr>"
		endif

		cDescPro := SC7->C7_DESCRI
		//If SC1->(FieldPos("C1_FSMARC")) > 0
		//	If !Empty(SC1->C1_FSMARC)
		//		cDescPro := cDescPro + "(" + Alltrim( SC1->C1_FSMARC ) + ")"
		//	endif
		//Endif
		
		SB1->(dbSetOrder(1))
		c_UData	:=	DTOC(CTOD("  /  /  "))
		c_UPrc	:=	Transform( 0, "@E 999,999,999.99" )
		If SB1->(dbSeek(xFilial("SB1")+SC7->C7_PRODUTO,.T.))
			c_UData	:=	SB1->(DTOC(B1_UCOM))
			
			n_UltPrec:= SB1->B1_UPRC + (SB1->B1_UPRC*SB1->B1_IPI/100)
			c_UPrc	:=	Transform( n_UltPrec, "@E 9,999,999.999999" )
		Endif
		
		c_TxtPed	+= "				<tr class=Label>"
		c_TxtPed	+= "					<td align='left'>" + SC7->C7_ITEM + "</td>"
		c_TxtPed	+= "					<td align='left'>" + SC7->C7_PRODUTO + "</td>"
		c_TxtPed	+= "					<td align='left'>" + cDescPro + "</td>"
		c_TxtPed	+= "					<td align='left'>" + SC7->C7_UM + "</td>"
		If SC7->(FieldPos("C7_FSMARCA")) > 0
			c_TxtPed+= "					<td align='left'>" + SC7->C7_FSMARCA + "</td>"
		Endif
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_QUANT, "@E 999,999,999.99" ) + "</td>"
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_PRECO, "@E 9,999,999.999999" ) + "</td>"
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_TOTAL, "@E 999,999,999.99" ) + "</td>"
		c_TxtPed	+= "					<td align='center'>" + DTOC( SC7->C7_DATPRF ) + "</td>"
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_VALFRE, "@E 999,999,999.99" ) + "</td>"
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_VALIPI, "@E 999,999,999.99" ) + "</td>"
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_VALICM, "@E 999,999,999.99" ) + "</td>"
		c_TxtPed	+= "					<td align='right'>" + Transform( SC7->C7_VLDESC, "@E 999,999,999.99" ) + "</td>"
		c_TxtPed	+= "					<td align='left'>" + SC7->C7_NUMSC + "</td>"
		c_TxtPed	+= "					<td align='left'>" + SC7->C7_ITEMSC + "</td>"
		c_TxtPed	+= "					<td align='left'>" + ALLTRIM( SC7->C7_CC )+ " - " + POSICIONE( "CTT", 1, XFILIAL("CTT") + SC7->C7_CC, "CTT_DESC01" ) + "</td>"
		If l_AdicCamp //Adiciona campos de data e ultimo preço de compra
			c_TxtPed	+= "					<td align='center'>" 	+ c_UData 	+ "</td>"
			c_TxtPed	+= "					<td align='right'>" 	+ c_UPrc 	+ "</td>"
		Endif
		c_TxtPed	+= "				</tr>"

		n_Total		+= SC7->C7_TOTAL + SC7->C7_VALFRE + SC7->C7_VALIPI
		n_TotIPI	+= SC7->C7_VALIPI
		n_TotIcms	+= SC7->C7_VALICM
		n_VlDesc	+= SC7->C7_VLDESC
		n_TotFret	+= SC7->C7_VALFRE

		SC7->(dbSkip())

	EndDo

	c_TxtPed	+= "				<tr><td>&nbsp;</td></tr>"
	c_TxtPed	+= "				<tr class=Label>"
	c_TxtPed	+= "					<td colspan=7>TOTAL ( Frete + IPI )</td>"
	c_TxtPed	+= "					<td align='right'>" + Transform( n_Total, "@E 9,999,999.999999" ) + "</td>"
	c_TxtPed	+= "					<td align='right'>&nbsp;</td>"
	c_TxtPed	+= "					<td align='right'>" + Transform( n_TotFret, "@E 999,999,999.99" ) + "</td>"
	c_TxtPed	+= "					<td align='right'>" + Transform( n_TotIPI, "@E 999,999,999.99" ) + "</td>"
	c_TxtPed	+= "					<td align='right'>" + Transform( n_TotIcms, "@E 999,999,999.99" ) + "</td>"
	c_TxtPed	+= "					<td align='right'>" + Transform( n_VlDesc, "@E 999,999,999.99" ) + "</td>"
	c_TxtPed	+= "				</tr>"
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7") + c_Numero )

	c_TxtPed	+= "				<tr><td>&nbsp;</td></tr>"
	c_TxtPed	+= "				<tr><td><b>Observação Pedido: </b></td></tr>"

	While SC7->(!EOF()) .And. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + c_Numero

		If !Empty(SC7->C7_OBS)

			cObsItem := " Item - " + SC7->C7_ITEM + ": " + SC7->C7_OBS

			c_TxtPed	+= "				<tr class=Label>"
			c_TxtPed	+= "					<td colspan=6 align='left'>" + cObsItem + "</td>"
			c_TxtPed	+= "				</tr>"
		endif

		SC7->(dbSkip())

	EndDo
	
	If !Empty(c_TxtC1)
		c_TxtPed	+= "				<tr><td>&nbsp;</td></tr>"
		c_TxtPed	+= "				<tr><td><b>Observação Solicitação: </b></td></tr>"
		c_TxtPed	+= c_TxtC1
	endif

	c_TxtPed	+= f_Aprovadores(c_Numero)
	c_TxtPed	+= "			</table>"
	c_TxtPed	+= "		</td>"
	c_TxtPed	+= "	</tr>"
	c_TxtPed	+= "</table>"

	MemoWrite( c_TempFile + "pedido_" + c_Numero + ".html", c_TxtPed )

Return


Static Function f_Aprovadores(c_Pedido) //Compradores / Aprovadores
Local	c_Comprador	:= 	""
Local	c_Alter	  	:= 	""
Local	c_Aprov	  	:= 	""
Local	l_NewAlc	:= 	.F.
Local	l_Liber 	:= 	.F.
Local 	c_TipoSC7	:=	""
Local 	c_TxtPedAp	:=	""

SC7->(dbSetOrder(1))
If SC7->(dbSeek(xFilial("SC7")+c_Pedido,.T.))
	
	//Incluida validação para os pedidos de compras por item do pedido  (IP/alçada)
	c_TipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
	
	If c_TipoSC7 == "PC"
	
		SCR->(dbSetOrder(1))
		If SCR->(!dbSeek(xFilial("SCR")+c_TipoSC7+SC7->C7_NUM))
			SCR->(dbSeek(xFilial("SCR")+"IP"+SC7->C7_NUM))
		EndIf
	
	Else
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("SCR")+c_TipoSC7+SC7->C7_NUM))
	EndIf
	
	If !Empty(SCR->CR_APROV) .Or. (Empty(SCR->CR_APROV) .And. SCR->CR_TIPO == "IP")
	
		l_NewAlc := .T.
		c_Comprador := UsrFullName(SC7->C7_USER)
		If SC7->C7_CONAPRO != "B"
			l_Liber := .T.
		EndIf
	
		While SCR->(!Eof()) .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO $ "PC|AE|IP"
			c_Aprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
			Do Case
				Case SCR->CR_STATUS=="02" //Pendente
					c_Aprov += "BLQ"
				Case SCR->CR_STATUS=="03" //Liberado
					c_Aprov += "Ok"
				Case SCR->CR_STATUS=="04" //Bloqueado
					c_Aprov += "BLQ"
				Case SCR->CR_STATUS=="05" //Nivel Liberado
					c_Aprov += "##"
				OtherWise                 //Aguar.Lib
					c_Aprov += "??"
			EndCase
			c_Aprov += "] - "
			SCR->(dbSkip())
		Enddo
		If !Empty(SC7->C7_GRUPCOM)
			SAJ->(dbSetOrder(1))
			SAJ-(dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM))
			While SAJ->(!Eof()) .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
				If SAJ->AJ_USER != SC7->C7_USER
					If SAJ->(FieldPos("AJ_MSBLQL") > 0)
						If SAJ->AJ_MSBLQL == "1"
							SAJ->(dbSkip())
							LOOP
						EndIf
					EndIf
					c_Alter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
				EndIf
				SAJ->(dbSkip())
			EndDo
		EndIf
	EndIf
	
	//Status do pedido
	c_Status	:=	""
	If !l_NewAlc
		c_Status := "P E D I D O   L I B E R A D O"
	Else
		If l_Liber
			c_Status := "P E D I D O   L I B E R A D O"
		Else
			c_Status := "P E D I D O   B L O Q U E A D O"
		EndIf
	Endif
	c_TxtPedAp	+=	"<tr>"
	c_TxtPedAp	+=	"	<td>&nbsp;</td>"
	c_TxtPedAp	+=	"</tr>"	
	/*c_TxtPedAp	+=	"<tr>"
	c_TxtPedAp	+=	"	<td colspan=200 align='left'>"
	c_TxtPedAp	+=	"		<b>Situação: </b>"+c_Status+"</td>"
	c_TxtPedAp	+=	"	</td>"			
	c_TxtPedAp	+=	"</tr>"	*/
	c_TxtPedAp	+=	"<tr>"
	c_TxtPedAp	+=	"	<td>&nbsp;</td>"
	c_TxtPedAp	+=	"</tr>"	
	c_TxtPedAp	+=	"<tr>"
	c_TxtPedAp	+=	"	<td colspan=200 align='left'>"
	c_TxtPedAp	+=	"		<b>Aprovadores: </b>"+c_Aprov+"</td>"
	c_TxtPedAp	+=	"	</td>"	
	c_TxtPedAp	+=	"</tr>"	
	c_TxtPedAp	+=	"<tr>"
	c_TxtPedAp	+=	"	<td>&nbsp;</td>"
	c_TxtPedAp	+=	"</tr>"	
	c_TxtPedAp	+=	"</tr>"	
	c_TxtPedAp	+=	"	<td colspan=200 align='left'>"
	c_TxtPedAp	+=	"		<b>Legendas de Aprovacao: </b>BLQ: Bloqueado |  OK: Liberado  |  ??: Aguardando Liberacao  |  ##: Nivel Liberado</td>"
	c_TxtPedAp	+=	"	</td>"	
	c_TxtPedAp	+=	"</tr>"	
	c_TxtPedAp	+=	"<tr>"
	c_TxtPedAp	+=	"	<td colspan=200 align='left'>"
	c_TxtPedAp	+=	"		<b>NOTA: </b>So aceitaremos sua mercadoria se na sua nota fiscal constar nosso pedido de compras.</td>"
	c_TxtPedAp	+=	"	</td>"
	c_TxtPedAp	+=	"</tr>"		
Endif

return(c_TxtPedAp)