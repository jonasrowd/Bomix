#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPonto de entrada ³ MT100LOK	 ºAutor  ³ Christian Rocha    º Data ³ 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³ Alterações de Itens da NF de Despesas de Importação 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservação ³ Ponto de entrada desenvolvido para impedir o cadastro de  º±±
±±º           ³ doc. de entrada sem o lote do fornecedor quando o produto º±±
±±º           ³ possuir controle de rastreabilidade.                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/        


User Function MT100LOK()
	Local c_Produto := ''
	Local c_LoteFor := ''
	Local c_Rastro  := ''
	Local c_CC      := ''
	Local c_Rateio  := ''
	Local l_Ret     := .T.     
	
	
	
	
	If cTipo == 'N'
	   	If aCols[n][Len( aHeader )+1] == .F.
			c_Produto := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_COD'})]
			c_Rastro  := Posicione("SB1", 1, xFilial("SB1")+c_Produto, "B1_RASTRO")
			c_CC      := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_CC'})]
			c_Rateio  := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_RATEIO'})]

			If Empty(c_CC) .And. c_Rateio == '2'
				If MsgYesNo("O campo Centro Custo está em branco. Deseja continuar sem preencher o centro de custo?", SM0->M0_NOME) == .F.
					l_Ret := .F.
				Endif
			Endif

			If c_Rastro == 'L'
				c_LoteFor := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_LOTEFOR'})]
	
				If Empty(c_LoteFor)
					ShowHelpDlg(SM0->M0_NOME, {"O campo Lote Fornec. é obrigatório quando o produto possui controle de rastreabilidade."},5,;
	                                 			  {"Preencha o campo Lote Fornec. deste item."},5)
					l_Ret := .F.
				Endif
			Endif
		Endif
	Endif

Return l_Ret