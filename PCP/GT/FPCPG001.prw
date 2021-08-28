#Include 'Totvs.ch'

/*/{Protheus.doc} FPCPG001
	Gatilho para gerar o lote da OP.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 26/08/2021
	@return Variant, retorna o número do lote
/*/
User Function FPCPG001()
	Local c_Lote	:= ''
	Local c_sigla	:= ''
	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	//Posiciona na Ordem de Produção
	DBSelectArea("SC2")
	DBSetOrder(1)
	DbSeek(xFilial("SC2") + Substring(M->H6_OP,1,6))
		If (Found()) 
			RecLock("SC2", .F.)
				If SC2->C2_QUJE==0
					SC2->C2_FSSALDO := SC2->C2_QUANT
				EndIf
			SC2->(MsUnLock())
		EndIf

	If SB1->B1_RASTRO == 'L'	//Verifica se o produto possui rastreabilidade
		If cFilAnt == "020101"	// Verifica se a empresa é SOPRO
			dbSelectArea("SA7")
			dbGoTop()
			dbSetOrder(2)
			dbSeek(xFilial("SA7")+M->H6_PRODUTO)
			DO WHILE !EOF()
				IF ALLTRIM(SA7->A7_FSSIGLA)<>'' .AND. ALLTRIM(M->H6_PRODUTO)=ALLTRIM(SA7->A7_PRODUTO) .AND. ALLTRIM(SUBSTR(cFilAnt,1,4))=ALLTRIM(SA7->A7_FILIAL)
					c_sigla=ALLTRIM(SA7->A7_FSSIGLA)
					EXIT
				ENDIF
				SKIP
			ENDDO
			IF c_sigla <> ''
				c_Lote := SUBSTR(M->H6_OP,1,6)+SUBSTR(M->H6_OP,8,1)+SUBSTR(M->H6_OP,11,1)+ALLTRIM(c_sigla)   // cria a estrutura do número do lote incluindo a SIGLA solicitada pelo Fornecedor
			else
				c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)
			endif
		Else
			c_Lote := SUBSTR(M->H6_OP,1,8)+SUBSTR(M->H6_OP,10,2)   // cria o número do lote baseado na OP
		Endif
	EndIf
	
	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)
	dbGoTo(_nReg)

Return(c_Lote)
