#INCLUDE "TOTVS.ch"

/*/{Protheus.doc} MT100LOK
	Ponto de entrada desenvolvido para impedir o cadastro de doc. de entrada 
	sem o lote do fornecedor quando o produto possuir controle de rastreabilidade.
	Bloqueia gravação de Doc. de Entrada sem CC, caso Rateio seja Não.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 02/08/2021
	@return variant, Logical
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
/*/
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
		If l_Ret
			c_Produto := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_COD'})]
			c_Rastro  := Posicione("SB1", 1, xFilial("SB1")+c_Produto, "B1_RASTRO")
			c_CC      := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_CC'})]
			c_Rateio  := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_RATEIO'})]	
			c_Conta   := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_CONTA'})]

			If Empty(c_CC) .And. c_Rateio == '2'
				Help(NIL, NIL, "CC_BLOCKED", NIL, "O Campo centro de custo é obrigatório.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o campo corretamente."})
					l_Ret := .F.
				If c_Rastro == 'L'
					c_LoteFor := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_LOTEFOR'})]
					If Empty(c_LoteFor)
						Help(NIL, NIL, "LOT_BLOCKED", NIL, "O campo Lote Fornec. é obrigatório quando o produto possui controle de rastreabilidade.",;
							1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o campo Lote Fornec. deste item."})
						l_Ret := .F.
					Endif
				Endif
				
				If Empty(c_Conta) .And. c_Rateio  == '1'  
					If MsgYesNo("O campo conta contábil está em branco. Deseja proseguir com a conta contábil cadastrada no rateio por centro de custo ?", SM0->M0_NOME) == .F.
						l_Ret := .F.
					Endif      
				ElseIf  Empty(c_Conta) .And. c_Rateio  == '2' 
					Alert ("Favor preencher a conta contábil")
					l_Ret := .F.
				Endif
			
				IF  _cAlias <> ""
					dbSelectArea(_cAlias)
					dbSetOrder(_cOrd)
					dbGoTo(nReg)
				EndIf
			ElseIf c_Rateio == '1'
					l_Ret := .T.
			Endif	
		Endif
	Endif

Return l_Ret
