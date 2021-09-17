#Include 'Totvs.ch'

/*/{Protheus.doc} FPCPG001
	Gatilho para gerar o lote da OP.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 26/08/2021
	@return Variant, retorna o n�mero do lote
/*/
User Function FPCPG001()
	Local cLote	 := ''   // cria o n�mero do lote baseado na OP
	Local cSigla := ''
	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	DbSelectArea('SB1')
	DbSetOrder(1)
	DbSeek(FwXFilial('SB1') + M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'	//VerIfica se o produto possui rastreabilidade
		If cFilAnt == "020101"	// VerIfica se a empresa � SOPRO
			DbSelectArea("SA7")
			DbGoTop()
			DbSetOrder(2)
			DbSeek(xFilial("SA7") + M->H6_PRODUTO)
			While !EOF()
				If AllTrim(SA7->A7_FSSIGLA) <>'' .And. AllTrim(M->H6_PRODUTO) == AllTrim(SA7->A7_PRODUTO) .And. AllTrim(SubStr(cFilAnt,1,4)) == AllTrim(SA7->A7_FILIAL)
					cSigla=AllTrim(SA7->A7_FSSIGLA)
				EndIf
				DbSkip()
			End
			If cSigla <> ''
				cLote := SubStr(M->H6_OP,1,6) + SubStr(M->H6_OP,8,1) + SubStr(M->H6_OP,11,1) + AllTrim(cSigla)   // cria a estrutura do n�mero do lote incluindo a SIGLA solicitada pelo Fornecedor
			Else
				cLote := SubStr(M->H6_OP,1,8)
			EndIf
		Else
			cLote := SubStr(M->H6_OP,1,8)+SubStr(M->H6_OP,10,2)
		EndIf
	EndIf
	
	DbSelectArea(_cAlias)
	DbSetOrder(_cOrd)
	DbGoTo(_nReg)

Return(cLote)
