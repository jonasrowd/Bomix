#Include "protheus.ch"
#include "topconn.ch"
#include "FWPrintSetup.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: INCWFBOL()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function INCWFBOL()
*-----------------------------------------------------------*

RpcSetType(3)
RpcSetEnv("01","01")
SetUserDefault("000000")

//Cobranças / Pgto por Boletos
fCobBoleto()

//Cobranças / Pgto por Depositos
fCobDeposi()

//Cobranças / Titulos vencidos
fCobAtraso()


//Força Envio dos WF já gerados
WFSendMail({"01","01"})

// Finaliza a abertura dos dicionários
RpcClearEnv()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: INCWFCOB()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function INCWFCOB()
*-----------------------------------------------------------*

//Cobranças / Pgto por Boletos
MsAguarde( { || fCobBoleto() } ,"Cobranças", "Analisando titulos de boletos..." )

//Cobranças / Pgto por Depositos
MsAguarde( { || fCobDeposi() } ,"Cobranças", "Analisando titulos de depositos..." )

//Cobranças / Titulos vencidos
MsAguarde( { || fCobAtraso() } ,"Cobranças", "Analisando titulos vencidos..." )


//Força Envio dos WF já gerados
WFSendMail({"01","01"})

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fCobAtraso()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 29 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCobAtraso()
*-----------------------------------------------------------*

Local cQuery   := fMontaQuery("VNC")
Local cMsgMail := ""
Local cAnexoDanfe  := ""
Local cAnexoBoleto := ""
Local cEmails      := ""

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQuery New Alias "QRY"

//Percorre registros para envios das cobranças por e-mail
QRY->(DbGoTop())
While QRY->(!Eof())
	
	cAnexoDanfe  := ""
	cAnexoBoleto := ""
	cEmails := ""
	
	
	//Mensagem que irá aparecer no corpo do e-mail
	cMsgMail := "<br><b>Sr. Cliente "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")+"</b>"
	cMsgMail += "<br>"
	cMsgMail += "<br>Seu título está vencido desde: "+DtoC(StoD(QRY->E1_VENCREA))+""
	cMsgMail += "<br>"
	cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
	cMsgMail += "<br>"
	cMsgMail += "<br>Atenciosamente,"
	cMsgMail += "<br>"
	cMsgMail += "<br><b>Faturamento INC Group</b>"
	cMsgMail += "<br>Tel. (11) 2914-9195"
	cMsgMail += "<br>E-mail: contasareceber@incgroup.com.br"
	cMsgMail += "<br>&nbsp;"
	
	//Enviar Workflow com os anexos
	cEmails := fEnviaWF(QRY->E1_CLIENTE,QRY->E1_LOJA,cAnexoDanfe,cAnexoBoleto,"VNC",cMsgMail)
	
	//Atualiza FLAG do Título como WF Enviado
	fAtuFlagE1(QRY->E1_RECNO,QRY->F2_RECNO,"VNC",cEmails)
	
	QRY->(DbSkip())
End


//Fecha Alias
QRY->(dbCloseArea())

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCobBoleto()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCobBoleto()
*-----------------------------------------------------------*

Local cQuery   := fMontaQuery("BOL")
Local cMsgMail := ""
Local cAnexoDanfe  := ""
Local cAnexoBoleto := ""
Local cEmails      := ""
Local cTitAnterior := ""

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQuery New Alias "QRY"

//Percorre registros para envios das cobranças por e-mail
QRY->(DbGoTop())
While QRY->(!Eof())
    
	cAnexoDanfe  := ""
	cAnexoBoleto := ""
	cEmails := ""

	//Gerar Boleto em PDF e Salvar para envio como anexo no e-mail
    cAnexoBoleto := fBoletoPDF(QRY->E1_RECNO,QRY->C5_NUM)
	
	//Só gera danfe e envia e-mail se tem boleto
	If !Empty(cAnexoBoleto)
        
		//Gerar Danfe em PDF e Salvar para envio como anexo no e-mail
	    cAnexoDanfe := fDanfePDF(QRY->F2_RECNO)
	    
		//Só envia WF se conseguiu gerar Danfe
		If !Empty(cAnexoDanfe)


		   	//Mensagem que irá aparecer no corpo do e-mail
			cMsgMail := "<br><b>Sr. Cliente "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")+"</b>"
			cMsgMail += "<br>"
			If cAnexoDanfe == "NOT_SPED"
				cMsgMail += "<br>Segue o Boleto para pagamento de sua compra."
			Else
				cMsgMail += "<br>Segue Nota Fiscal e Boleto para pagamento de sua compra."
			EndIf
			cMsgMail += "<br>"
			cMsgMail += "<br><b>NF/Serie: </b>"+QRY->F2_DOC+" / "+QRY->F2_SERIE
			cMsgMail += "<br>"
			cMsgMail += "<br>Atenciosamente,"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Faturamento INC Group</b>"
			cMsgMail += "<br>Tel. (11) 2914-9195"
			cMsgMail += "<br>E-mail: contasareceber@incgroup.com.br"
			cMsgMail += "<br>&nbsp;"

		   	//Mensagem que irá aparecer no corpo do e-mail
			//cMsgMail := "<br><b>Cliente: </b>"+QRY->E1_CLIENTE+" / "+QRY->E1_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Vencimento: </b>"+DtoC(StoD(QRY->E1_VENCREA))
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Esta mensagem foi gerada automaticamente, para maiores detalhes entrar em contato com Financeiro INCGROUP</b>"
			//cMsgMail += "<br>&nbsp;"

			//Enviar Workflow com os anexos
			//Esse IF é para evitar que titulos com varias parcelas seja emviados varias vezes
			If cTitAnterior != QRY->E1_FILIAL + QRY->E1_PREFIXO + QRY->E1_NUM + QRY->E1_TIPO + QRY->E1_CLIENTE + QRY->E1_LOJA
				cEmails := fEnviaWF(QRY->E1_CLIENTE,QRY->E1_LOJA,cAnexoDanfe,cAnexoBoleto,"BOL",cMsgMail)
			EndIf

			//Atualiza FLAG do Título como WF Enviado
			fAtuFlagE1(QRY->E1_RECNO,QRY->F2_RECNO,"BOL",cEmails)
		Else

			cMsgMail := "<br><b>SISTEMA NÃO CONSEGUIU GERAR DANFE, ANALISAR MOTIVO.</b>"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Sr. Cliente "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")+"</b>"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Vencimento: </b>"+DtoC(StoD(QRY->E1_VENCREA))
			cMsgMail += "<br>"
			cMsgMail += "<br>Segue o Boleto gerado."
			cMsgMail += "<br>"
			cMsgMail += "<br>Atenciosamente,"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Faturamento INC Group</b>"
			cMsgMail += "<br>Tel. (11) 2914-9195"
			cMsgMail += "<br>E-mail: contasareceber@incgroup.com.br"
			cMsgMail += "<br>&nbsp;"
			cMsgMail += "<br>&nbsp;"

		   	//Mensagem que irá aparecer no corpo do e-mail
			//cMsgMail := "<br><b>Cliente: </b>"+QRY->E1_CLIENTE+" / "+QRY->E1_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Vencimento: </b>"+DtoC(StoD(QRY->E1_VENCREA))
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>SISTEMA NÃO CONSEGUIU GERAR DANFE, ANALISAR MOTIVO.</b>"
			//cMsgMail += "<br>&nbsp;"

			//Enviar Workflow com os anexos
			cEmails := fEnviaWF(QRY->E1_CLIENTE,QRY->E1_LOJA,cAnexoDanfe,cAnexoBoleto,"ERRO",cMsgMail)

			//Atualiza FLAG do Título como WF Enviado
			fAtuFlagE1(QRY->E1_RECNO,QRY->F2_RECNO,"ERRO",cEmails)

		EndIf
	
	EndIf
	
	cTitAnterior := QRY->E1_FILIAL + QRY->E1_PREFIXO + QRY->E1_NUM + QRY->E1_TIPO + QRY->E1_CLIENTE + QRY->E1_LOJA
		
	QRY->(DbSkip())
End

//Fecha Alias
QRY->(dbCloseArea())

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fAtuFlagE1()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 16 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fAtuFlagE1(nRecSE1,nRecSF2,cTipo,cEmails)
*-----------------------------------------------------------*

//Atualiz FLAG no Título pra não enviar novamente
SE1->(DbGoTo(nRecSE1))
If nRecSE1 == SE1->(Recno())
	If RecLock("SE1",.F.)
		If cTipo == "VNC"
			SE1->E1_XXWFVNC := Date()
			SE1->E1_XXWFEND := "2"
		Else
			SE1->E1_XXWFCOB := "2" // 2=Sim
		EndIf
		
		SE1->(MsUnLock())
	EndIf
EndIf

//Posiciona nos registros pra pegar as informações corretas
SE1->(DbGoTo(nRecSE1))
SF2->(DbGoTo(nRecSF2))

//Alimenta tabela de LOG
RecLock("ZZ6",.T.)
	ZZ6->ZZ6_FILIAL := SE1->E1_FILIAL
	ZZ6->ZZ6_LOGDT  := Date()
	ZZ6->ZZ6_LOGHR  := Time()
	ZZ6->ZZ6_LOGUSR := __cUserId +" - "+ AllTrim(UsrFullName(__cUserId))
	ZZ6->ZZ6_PREFIX := SE1->E1_PREFIXO
	ZZ6->ZZ6_NUM    := SE1->E1_NUM
	ZZ6->ZZ6_PARCEL := SE1->E1_PARCELA
	ZZ6->ZZ6_TIPO   := SE1->E1_TIPO
	ZZ6->ZZ6_CLIENT := SE1->E1_CLIENTE
	ZZ6->ZZ6_LOJA   := SE1->E1_LOJA
	ZZ6->ZZ6_DOCNFE := SF2->F2_DOC
	ZZ6->ZZ6_DOCSER := SF2->F2_SERIE
	ZZ6->ZZ6_NUMPV  := SE1->E1_PEDIDO
	If cTipo == "ERRO"
		ZZ6->ZZ6_OBSERV := "SISTEMA NÃO CONSEGUIU GERAR DANFE, ANALISAR MOTIVO"
	EndIf
	If cTipo == "BOL"
		ZZ6->ZZ6_OBSERV := "Este WF de Cobrança enviou a DANFE e o boleto em anexo."
	EndIf
	If cTipo == "DEP"
		ZZ6->ZZ6_OBSERV := "Este WF de Cobrança enviou a DANFE em anexo e os dados bancários p/ depósito."
	EndIf
	If cTipo == "VNC"
		ZZ6->ZZ6_OBSERV := "Este WF de Cobrança enviou um e-mail de aviso dizendo que o titulo está vencido."
	EndIf

	ZZ6->ZZ6_EMAILS := cEmails
ZZ6->(MsUnLock())

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCobDeposi()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCobDeposi()
*-----------------------------------------------------------*

Local cQuery   := fMontaQuery("DEP")
Local cMsgMail := ""
Local cAnexoDanfe  := ""
Local cAnexoCarta  := ""
Local cEmails      := ""

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQuery New Alias "QRY"

//Percorre registros para envios das cobranças por e-mail
QRY->(DbGoTop())
While QRY->(!Eof())

	cAnexoDanfe  := ""
	cAnexoCarta  := ""
	cEmails      := ""

	//Gerar Boleto em PDF e Salvar para envio como anexo no e-mail
    cAnexoCarta := fCartaPDF()
    
	//Só gera danfe e envia e-mail se tem boleto
	If !Empty(cAnexoCarta)

		//Gerar Carta com Dados Bancarios em PDF e Salvar para envio como anexo no e-mail
	    cAnexoDanfe := fDanfePDF(QRY->F2_RECNO)

		//Só envia WF se conseguiu gerar Danfe
		If !Empty(cAnexoDanfe)
			cAnexoCarta := "" //Limpa conteudo da variavel pra não enviar carta

			cMsgMail := "<br><b>Sr. Cliente "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")+"</b>"
			cMsgMail += "<br>"
			If cAnexoDanfe == "NOT_SPED"
				cMsgMail += "<br>Segue os dados para deposito de sua compra, com vencimento programado para:"+DtoC(StoD(QRY->E1_VENCREA))
			Else
				cMsgMail += "<br>Segue Nota Fiscal e os dados para deposito de sua compra, com vencimento programado para:"+DtoC(StoD(QRY->E1_VENCREA))
			EndIf
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Dados Bancario</b>"
			cMsgMail += "<br><b>Banco:</b> 341 - Itau S.A"
			cMsgMail += "<br><b>Ag:</b> 0285"
			cMsgMail += "<br><b>C/C:</b> 56470-4"
			cMsgMail += "<br><b>CNPJ:</b> 03.115.735.0001-59"
			cMsgMail += "<br><b>Razão:</b> Incospray Comercio de Equipamentos e Serviço LTDA"
			cMsgMail += "<br>"
			cMsgMail += "<br>Atenciosamente,"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Faturamento INC Group</b>"
			cMsgMail += "<br>Tel. (11) 2914-9195"
			cMsgMail += "<br>Email: contasareceber@incgroup.com.br"
			cMsgMail += "<br>&nbsp;"


			//Mensagem que irá aparecer no corpo do e-mail
			//cMsgMail := "<br><b>Cliente: </b>"+QRY->E1_CLIENTE+" / "+QRY->E1_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Vencimento: </b>"+DtoC(StoD(QRY->E1_VENCREA))
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Esta mensagem foi gerada automaticamente, para maiores detalhes entrar em contato com Financeiro INCGROUP</b>"
			//cMsgMail += "<br>&nbsp;"

			//Enviar Workflow com os anexos
			cEmails := fEnviaWF(QRY->E1_CLIENTE,QRY->E1_LOJA,cAnexoDanfe,cAnexoCarta,"DEP",cMsgMail)

			//Atualiza FLAG do Título como WF Enviado
			fAtuFlagE1(QRY->E1_RECNO,QRY->F2_RECNO,"DEP",cEmails)
		Else
			cAnexoCarta := "" //Limpa conteudo da variavel pra não enviar carta

			cMsgMail := "<br><b>SISTEMA NÃO CONSEGUIU GERAR DANFE, ANALISAR MOTIVO.</b>"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Sr. Cliente "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")+"</b>"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
			cMsgMail += "<br>"
			cMsgMail += "<br>Segue os dados para deposito de sua compra, com vencimento programado para:"+DtoC(StoD(QRY->E1_VENCREA))
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Dados Bancario</b>"
			cMsgMail += "<br><b>Banco:</b> 341 - Itau S.A"
			cMsgMail += "<br><b>Ag:</b> 0285"
			cMsgMail += "<br><b>C/C:</b> 56470-4"
			cMsgMail += "<br><b>CNPJ:</b> 03.115.735.0001-59"
			cMsgMail += "<br><b>Razão:</b> Incospray Comercio e Serviço de Pintura e Lubrificação LTDA"
			cMsgMail += "<br>"
			cMsgMail += "<br>Atenciosamente,"
			cMsgMail += "<br>"
			cMsgMail += "<br><b>Faturamento INC Group</b>"
			cMsgMail += "<br>Tel. (11) 2914-9195"
			cMsgMail += "<br>Email: contasareceber@incgroup.com.br"
			cMsgMail += "<br>&nbsp;"
			cMsgMail += "<br>&nbsp;"

		   	//Mensagem que irá aparecer no corpo do e-mail
			//cMsgMail := "<br><b>Cliente: </b>"+QRY->E1_CLIENTE+" / "+QRY->E1_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA, "A1_NOME")
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Prefx./Título/Tipo: </b>"+QRY->E1_PREFIXO+" - "+QRY->E1_NUM+" - "+QRY->E1_TIPO
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>Vencimento: </b>"+DtoC(StoD(QRY->E1_VENCREA))
			//cMsgMail += "<br>"
			//cMsgMail += "<br><b>SISTEMA NÃO CONSEGUIU GERAR DANFE, ANALISAR MOTIVO.</b>"
			//cMsgMail += "<br>&nbsp;"

			//Enviar Workflow com os anexos
			cEmails := fEnviaWF(QRY->E1_CLIENTE,QRY->E1_LOJA,cAnexoDanfe,cAnexoCarta,"ERRO",cMsgMail)

			//Atualiza FLAG do Título como WF Enviado
			fAtuFlagE1(QRY->E1_RECNO,QRY->F2_RECNO,"ERRO",cEmails)

		EndIf

	EndIf

	QRY->(DbSkip())
End

//Fecha Alias
QRY->(dbCloseArea())

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCartaPDF()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 16 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCartaPDF()
*-----------------------------------------------------------*

Local cRet := ""

cRet := "\workflow\modelos\modelo_carta_cob.pdf"

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fMontaQuery()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Schedule / Job para enviar cobranças por e-mails
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fMontaQuery(cParam)
*-----------------------------------------------------------*

Local cQry   := ""
Local cQbra  := Chr(13)+Chr(10)

cQry := cQbra + " SELECT 
cQry += cQbra + " E1_FILIAL, 
cQry += cQbra + " E1_PREFIXO, 
cQry += cQbra + " E1_NUM, 
cQry += cQbra + " E1_PARCELA, 
cQry += cQbra + " E1_TIPO, 
cQry += cQbra + " E1_CLIENTE, 
cQry += cQbra + " E1_LOJA, 
cQry += cQbra + " E1_NUMBCO, " //--SE ESTE CAMPO ESTÁ PREENCHIDO, É QUE BOLETO JÁ FOI GERADO PRA ESTE TITULO
cQry += cQbra + " E1_PORTADO,
cQry += cQbra + " E1_AGEDEP,
cQry += cQbra + " E1_CONTA,
cQry += cQbra + " E1_NUMBOR,
cQry += cQbra + " E1_SITUACA,
cQry += cQbra + " E1_SALDO,
cQry += cQbra + " E1_VENCREA,
cQry += cQbra + " SE1.R_E_C_N_O_ E1_RECNO,
cQry += cQbra + " C5_XFORMAP,
cQry += cQbra + " C5_CONDPAG,
cQry += cQbra + " C5_VEND1,
cQry += cQbra + " C5_NUM,
cQry += cQbra + " D2_PEDIDO,
cQry += cQbra + " F2_DOC,
cQry += cQbra + " F2_SERIE,
cQry += cQbra + " SF2.R_E_C_N_O_ F2_RECNO

//---------------------------------------------------------------------------------------------------------------------------------------
cQry += cQbra + "  FROM "+RetSqlName("SE1")+" SE1
//---------------------------------------------------------------------------------------------------------------------------------------
cQry += cQbra + "  INNER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.D_E_L_E_T_ = '' 
cQry += cQbra + "                                      AND SF2.F2_DUPL    = SE1.E1_NUM 
cQry += cQbra + "                                      AND SF2.F2_CLIENTE = SE1.E1_CLIENTE 
cQry += cQbra + "                                      AND SF2.F2_LOJA    = SE1.E1_LOJA
//---------------------------------------------------------------------------------------------------------------------------------------
cQry += cQbra + "   LEFT JOIN (
cQry += cQbra + "             SELECT TMP.D2_FILIAL, TMP.D2_DOC, TMP.D2_SERIE, TMP.D2_CLIENTE, TMP.D2_LOJA, TMP.D2_PEDIDO 
cQry += cQbra + "               FROM "+RetSqlName("SD2")+" TMP 
cQry += cQbra + "              WHERE TMP.D_E_L_E_T_ = ''
cQry += cQbra + "              GROUP BY TMP.D2_FILIAL, TMP.D2_DOC, TMP.D2_SERIE, TMP.D2_CLIENTE, TMP.D2_LOJA, TMP.D2_PEDIDO
cQry += cQbra + "             )                     SD2 ON SD2.D2_FILIAL  = SF2.F2_FILIAL
cQry += cQbra + "                                      AND SD2.D2_DOC     = SF2.F2_DOC
cQry += cQbra + "                                      AND SD2.D2_SERIE   = SF2.F2_SERIE
cQry += cQbra + "                                      AND SD2.D2_CLIENTE = SF2.F2_CLIENTE
cQry += cQbra + "                                      AND SD2.D2_LOJA    = SF2.F2_LOJA
//---------------------------------------------------------------------------------------------------------------------------------------
cQry += cQbra + "   LEFT JOIN "+RetSqlName("SC5")+" SC5 ON SC5.D_E_L_E_T_ = '' 
cQry += cQbra + "                                      AND SC5.C5_NUM     = SE1.E1_PEDIDO 
cQry += cQbra + "                                      AND SC5.C5_CLIENTE = SE1.E1_CLIENTE 
cQry += cQbra + "                                      AND SC5.C5_LOJACLI = SE1.E1_LOJA
//---------------------------------------------------------------------------------------------------------------------------------------
cQry += cQbra + "  WHERE SE1.D_E_L_E_T_ = '' "
cQry += cQbra + "    AND E1_SALDO    >  0 "
cQry += cQbra + "    AND ( ( F2_ESPECIE = 'SPED' AND F2_CHVNFE != '' AND F2_DAUTNFE  != '' AND F2_HAUTNFE  != '' ) OR ( F2_ESPECIE != 'SPED' ) )"
//cQry += cQbra + "    AND SUBSTRING(E1_VENCREA,1,6) <= '"+SubStr(DtoS(Date()),1,6)+"' " // Comentei em 29/07/2016 pois agora está valendo, marquei todos os titulos: E1_XXWFCOB=2
//---------------------------------------------------------------------------------------------------------------------------------------
If cParam == "BOL"
cQry += cQbra + "    AND E1_XXWFCOB != '2'
cQry += cQbra + "    AND ( (E1_PORTADO = '341') OR (E1_PORTADO = '' AND E1_NUMBCO = '') )
cQry += cQbra + " "//-- NÃO IMPRIMIR BOLETO NA SITUAÇÃO ABAIXO
cQry += cQbra + "    AND NOT (C5_XFORMAP = '2' AND (E1_PARCELA = 'A' OR 
cQry += cQbra + "                                   E1_PARCELA = '1' OR
cQry += cQbra + "                                   E1_PARCELA = ' ' ))
cQry += cQbra + " "//-- NÃO IMPRIMIR BOLETO NA SITUAÇÃO ABAIXO
cQry += cQbra + "    AND C5_XFORMAP != '3' 
cQry += cQbra + " "//-- NÃO ENVIAR WF SE CONDIÇAO DE PAGAMENTO ANTECIPADO
cQry += cQbra + "    AND C5_CONDPAG != '601' 

EndIf
//---------------------------------------------------------------------------------------------------------------------------------------
If cParam == "DEP"
cQry += cQbra + " "//-- ESSES SÃO OS CASOS DE DEPOSITO
cQry += cQbra + "    AND E1_XXWFCOB != '2'
cQry += cQbra + "    AND C5_XFORMAP  = '3'
EndIf
//---------------------------------------------------------------------------------------------------------------------------------------
If cParam == "VNC"
cDtAtraso := DtoS(Date()-3)//RENAN - ALTEREI PARA 5 DIAS, ANTES ESTAVA COM O NUMERO 3
cQry += cQbra + " "//-- ESSES SÃO OS CASOS TITULOS VENCIDOS
cQry += cQbra + "    AND E1_XXWFEND != '2'
cQry += cQbra + "    AND E1_VENCREA <= '"+cDtAtraso+"' " //Somente titulos com vencimento maior que 3 dias
cQry += cQbra + "    AND E1_XXWFVNC != '"+DtoS(Date())+"' " //Se ja foi enviado hoje, não enviar novamente
EndIf

cQry += cQbra + " ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_PARCELA "

Return(cQry)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fEnviaWF()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Função pra enviar mensagem via workflow
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fEnviaWF(cCliCod,cCliLoj,cAnexoA,cAnexoB,cTipo,xMsg)
*-----------------------------------------------------------*

Local oProcess := Nil
Local oHtml    := Nil
Local cContato := ""
Local cContCOB := AllTrim(Lower(GetMV("IN_WFCOB")))
Local cContFAT := AllTrim(Lower(GetMV("IN_WFFAT")))
Local cAssunto := "[INCGROUP] WF FINANCEIRO"
Local cSubAsst := ""
Default xMsg   := ""


If cTipo == "BOL"
	cSubAsst := "FATURA BOL"
	cContato := cContFAT
EndIf

If cTipo == "DEP"
	cSubAsst := "FATURA DEP"
	cContato := cContFAT
EndIf

If cTipo == "VNC"
	cSubAsst := "COBRANÇA VENC."
	cContato := cContCOB
EndIf

If cTipo == "ERRO"
	cSubAsst := "ERRO"
	cContato := "renan@incgroup.com.br"
EndIf

If cTipo != "ERRO"
	//Se OK, então enviar workflow para o cliente
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliCod+cCliLoj))
		If !Empty(SA1->A1_EMAIL)
			cContato += IIf(Empty(cContato),"",";")+AllTrim(Lower(SA1->A1_EMAIL))
		EndIf
		If !Empty(SA1->A1_XEMAIL2)
			cContato += IIf(Empty(cContato),"",";")+AllTrim(Lower(SA1->A1_XEMAIL2))
		EndIf
		If !Empty(SA1->A1_EMAILCO)
			cContato += IIf(Empty(cContato),"",";")+AllTrim(Lower(SA1->A1_EMAILCO))
		EndIf
	EndIf
EndIf

If cTipo != "ERRO" .And. cTipo != "VNC"
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+QRY->C5_VEND1))
		If !Empty(SA3->A3_EMAIL)
			cContato += IIf(Empty(cContato),"",";")+AllTrim(Lower(SA3->A3_EMAIL))
		EndIf
	EndIf
EndIf

cAssunto += " - " + cSubAsst

//Monta workflow e dispara envio
oProcess:=TWFProcess():New("000002",OemToAnsi(cAssunto))
oProcess:NewTask("000002","\workflow\modelos\WF_MSG.htm")
oHtml   := oProcess:oHtml

oProcess:ClientName(cUserName)
oProcess:UserSiga := "000000"
oProcess:cSubject := cAssunto
oProcess:cTo      := cContato
oProcess:cBcc     := "felipeamelo@gmail.com"

oProcess:cFromName:= "WF Protheus [INC]"
oProcess:cFromAddr:= "workflow@incospray.com.br"

//Anexo Danfe
If !Empty(cAnexoA)
	cAnexoA := Lower(AllTrim(cAnexoA))
	oProcess:AttachFile(cAnexoA)
EndIf

//Anexo Boleto ou Carta
If !Empty(cAnexoB)
	cAnexoB := Lower(AllTrim(cAnexoB))
	oProcess:AttachFile(cAnexoB)
EndIf

oProcess:oHtml:ValByName( "cData"   , DtoC(Date()) )
oProcess:oHtml:ValByName( "cHora"   , Time()       )
oProcess:oHtml:ValByName( "cMsg"    , xMsg         )

//Envia e-mail
oProcess:Start()
oProcess:Finish()
WFSendMail({"01","01"})

Return(cContato)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fDanfePDF()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Função pra enviar mensagem via workflow
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fDanfePDF(nRecnoSF2)
*-----------------------------------------------------------*

Local oDanfe
Local oSetup
Local cIdEnt        := RetIdEnti()
Local cSession      := GetPrinterSession()
Local cPtchPDF      := "\spool\wf_danfes\"
//Local cPtchPDF      := "C:\relatorios\"
Local cFilePrint    := ""
Local lDisableSetup := .T.
Local lViewPDF      := .F.
Local cNota         := ""
Local cSerie        := ""
Local cRet          := ""

dbSelectArea("SF2")
RetIndex("SF2")
dbClearFilter()

SF2->(DbSetOrder(1))
SF2->(DbGoTo(nRecnoSF2))
cNota  := SF2->F2_DOC
cSerie := SF2->F2_SERIE

//Se não é NFe, então não gera DANFE
If SF2->F2_ESPECIE != 'SPED'
	Return("NOT_SPED")
EndIf

cFilePrint := "DANFE_"+AllTrim(cNota)+"_"+AllTrim(cSerie)+"_"+DtoS(MsDate())+"_"+StrTran(Time(),":","")

//Preparando ambiente de impressão
lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
oDanfe := FWMSPrinter():New(cFilePrint, 6, lAdjustToLegacy,cPtchPDF,lDisableSetup,,,,,,,lViewPDF)
oDanfe:cPathPDF := cPtchPDF

// ----------------------------------------------
// Cria e exibe tela de Setup Customizavel
// OBS: Utilizar include "FWPrintSetup.ch"
// ----------------------------------------------
nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
oSetup := FWPrintSetup():New(nFlags, "DANFE")
// ----------------------------------------------
// Define saida
// ----------------------------------------------
oSetup:SetPropert(PD_PRINTTYPE   , 6) //PDF
oSetup:SetPropert(PD_ORIENTATION , 1) //Retrato
oSetup:SetPropert(PD_DESTINATION , 1) //Server
oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
oSetup:SetPropert(PD_PAPERSIZE   , 2)
oSetup:AOPTIONS[6] := cPtchPDF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva os Parametros no Profile             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

// Configura o objeto de impressão com o que foi configurado na interface.
oDanfe:setCopies( 1 )

//Posiciona no registro que será impresso
SF2->(DbGoTo(nRecnoSF2))

//Declara Variaveis
aBkpPerg := {}

//Chama pergunta ocultamente para alimentar variáveis
Pergunte("NFSIGW",.F.,,,,,@aBkpPerg)

//Altera conteúdo de alguma pergunta
mv_par01 := cNota
mv_par02 := cNota
mv_par03 := cSerie
mv_par04 := 2
mv_par05 := 2

//Carrega variável principal para que os parâmetros
//definido acima sejam salvos na próxima chamada
SaveMVVars(.T.)

__SaveParam("NFSIGW    ", aBkpPerg)

Pergunte("NFSIGW",.F.)

u_PrtNfeSef(cIdEnt,,,oDanfe, oSetup, cFilePrint)

oDanfe := Nil
oSetup := Nil

//Verifica se arquivo foi gerado com sucesso e retorno link caso OK
If File(cPtchPDF+cFilePrint+".pdf")
	cRet := cPtchPDF+cFilePrint+".pdf"
EndIf

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fBoletoPDF()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 08 de julho de 2016, 09:00
//|Descricao.: Função pra enviar mensagem via workflow
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fBoletoPDF(nRecnoSE1,cNumPV)
*-----------------------------------------------------------*

Local cRet        := ""
Local lJobWF      := .T.
Default nRecnoSE1 :=  0
Default cNumPV    := ""

If !Empty(cNumPV)
    
	//Posiciona no titulo
	SE1->(DbSetOrder(1))
	SE1->(DbGoTo(nRecnoSE1))
	
	//Grava PV no Titulo
	If Empty(SE1->E1_PEDIDO)
		RecLock("SE1",.F.)
		SE1->E1_PEDIDO := cNumPV
		SE1->(MsUnLock())
	EndIf
	
	//Chama rotina de impressão do boleto
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+cNumPV))
		cRet := U_INCB341(lJobWF)
	EndIf
EndIf

Return(cRet)