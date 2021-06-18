#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Ponto de entrada � MT100LOK	 �Autor  � Christian Rocha    � Data � 	  ���
�������������������������������������������������������������������������͹��
���Desc.      � Altera��es de Itens da NF de Despesas de Importa��o 	  ���
�������������������������������������������������������������������������͹��
���Observa��o � Ponto de entrada desenvolvido para impedir o cadastro de  ���
���           � doc. de entrada sem o lote do fornecedor quando o produto ���
���           � possuir controle de rastreabilidade.                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/        


User Function MT100LOK()
	Local c_Produto := ''
	Local c_LoteFor := ''
	Local c_Rastro  := ''
	Local c_CC      := ''
	Local c_Rateio  := ''
	Local l_Ret     := .T. 
	Local c_Conta   := ''   

	_cAlias := ALIAS()
	_cOrd	:= INDEXORD()
	nReg    := RECNO()

	If cTipo == 'N'
		If aCols[n][Len( aHeader )+1] == .F.
			c_Produto := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_COD'})]
			c_Rastro  := Posicione("SB1", 1, xFilial("SB1")+c_Produto, "B1_RASTRO")
			c_CC      := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_CC'})]
			c_Rateio  := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_RATEIO'})]	
			c_Conta   := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_CONTA'})]

			If Empty(c_CC) .And. c_Rateio == '2'
				If MsgYesNo("O campo Centro Custo est� em branco. Deseja continuar sem preencher o centro de custo?", SM0->M0_NOME) == .F.
					l_Ret := .F.
				Endif
			Endif

			If c_Rastro == 'L'
				c_LoteFor := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_LOTEFOR'})]

				If Empty(c_LoteFor)
					ShowHelpDlg(SM0->M0_NOME, {"O campo Lote Fornec. � obrigat�rio quando o produto possui controle de rastreabilidade."},5,;
					{"Preencha o campo Lote Fornec. deste item."},5)
					l_Ret := .F.
				Endif
			Endif

			//Alterado por Elmer Farias em 10/08/2020

			If Empty(c_Conta) .And. c_Rateio  == '1'  

				If MsgYesNo("O campo conta cont�bil est� em branco. Deseja proseguir com a conta cont�bil cadastrada no rateio por centro de custo ?", SM0->M0_NOME) == .F.
					l_Ret := .F.
				Endif      
				/*aCols[n, nPosCONTA] := " "*/                  
			Elseif  Empty(c_Conta) .And. c_Rateio  == '2' 
				Alert ("Favor preencher a conta cont�bil")
				l_Ret := .F.
			Endif

			IF  _cAlias <> ""
				dbSelectArea(_cAlias)
				dbSetOrder(_cOrd)
				dbGoTo(nReg)
			EndIf	

		Endif
	Endif




Return l_Ret