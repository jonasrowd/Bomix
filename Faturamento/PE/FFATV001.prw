#Include "totvs.ch"

/*/{Protheus.doc} FFATV001
	Valida a arte e a amarra��o do produto x cliente
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 25/06/2021
	@param cProduto, Character, C�digo do produto do campo atualmente posicionado
	@return Logical, Retorno l�gico para valida��o do item
/*/
User Function FFATV001(cProduto)
	Local lOK   := .T.       // Controle de valida��o
	Local aArea := GetArea() // Tabela e seu estado para posterior restaura��o

	// Valida o bloqueio da arte do produto
	lOK := ValidaArte(cProduto) 
	
	// Se a arte estiver desbloqueada, valida a amarra��o do produto x cliente
	If (lOK)
		ValidaSA7(cProduto)
	EndIf

	If (lOk)
		jFSESPEC(cProduto)
	Endif

	// Restaura a �rea e seu estado anterior
	RestArea(aArea)
Return (lOK)

/*/{Protheus.doc} ValidaArte
	Valida��es espec�ficas da arte do produto
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 25/06/2021
	@param cProduto, Character, C�digo do produto do campo atualmente posicionado
	@return Logical, Retorno l�gico para valida��o do item
/*/
Static Function ValidaArte(cProduto)
	Local lOK := .T. // Controle de valida��o da arte

	// Executa as valida��es apenas na rotina de or�amentos ou pedido de venda
	If (FwIsInCallStack("MATA415") .Or. FwIsInCallStack("MATA410") .Or. FwIsInCallStack("MATA416")) 
		// Pesquisa pelo produto na tabela SB1
		DBSelectArea("SB1")
		DBGoTop()
		DBSetOrder(1)
		DBSeek(FwXFilial("SB1") + cProduto)

		// Caso encontrado, verifica se o produto possui arte, se a mesma est� desbloqueada e se � diferente de 99999
		If (Found() .And. !Empty(SB1->B1_FSARTE) .And. SB1->B1_FSARTE <> "99999")
			// Pesquisa pelo produto na tabela SZ2
			DBSelectArea("SZ2")
			DBGoTop()
			DBSetOrder(1)
			DBSeek(FwXFilial("SZ2") + SB1->B1_FSARTE)

			// Verifica se a arte do produto � nova, bloqueada ou em desenvolvimento
			If (Found() .And. SZ2->Z2_BLOQ $ "1|2|3")
				// Se for um or�amento, libera para grava��o
				// Se for um pedido de venda, n�o permite a grava��o
				lOK := IIf(FwIsInCallStack("MATA415"), .T., .F.)

				Help(NIL, NIL, "ART_BLOCKED", NIL, "A arte produto " + AllTrim(cProduto) + " n�o est� dispon�vel para utiliza��o.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o setor de Computa��o Gr�fica."})
			EndIf
		EndIf
	EndIf
Return (lOK)

/*/{Protheus.doc} ValidaArte
	Valida a amarra��o do produto x cliente
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 25/06/2021
	@param cProduto, Character, C�digo do produto do campo atualmente posicionado
	@return Logical, Retorno l�gico para valida��o do item
/*/
Static Function ValidaSA7(cProduto)
	Local lOK      := .T. // Controle da amarra��o cliente x produto
	Local cCliente := ""  // C�digo do cliente
	Local cLoja    := ""  // C�digo da loja

	// Verifica se est� executando em qualquer outra filial que n�o seja a 030101
	If (FwCodFil() != "030101")
		// Captura o c�digo do cliente e loja
		If (FwIsInCallStack("MATA410")) 
			cCliente := M->C5_CLIENTE
			cLoja    := M->C5_LOJACLI
		ElseIf (FwIsInCallStack("MATA415"))
			cCliente := M->CJ_CLIENTE
			cLoja    := M->CJ_LOJA
		ElseIf (FwIsInCallStack("MATA416"))
			cCliente := M->CJ_CLIENTE
			cLoja    := M->CJ_LOJA
		EndIf

		// VerIfica se existe amarra��o Produto x Cliente
		DBSelectArea("SA7")
		DBGoTop()
		DBSetOrder(2)
		DBSeek(FwXFilial("SA7") + cProduto + cCliente + cLoja)

		// Caso n�o exista, retorna falso para a valida��o e exibe uma mensagem de erro
		If (!Found())
			// Se for um or�amento, libera para grava��o
			// Se for um pedido de venda, n�o permite a grava��o
			lOK := .F. // IIf(FwIsInCallStack("MATA415"), .T., .F.)
			Help(NIL, NIL, "ERROR: PRODUTO X CLIENTE", NIL, "Amarra��o Produto x Cliente inv�lida.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"O produto " + AllTrim(cProduto) + " n�o possui amarra��o Produto x Cliente v�lida."})
		EndIf
	EndIf
Return (lOK)

/*/{Protheus.doc} jFSESPEC
	Fun��o para validar se o campo C5_FSESPEC est� preenchido.
	@type Function
	@version  12.1.25
	@author Jonas Machado
	@since 15/07/2021
	@param cProduto, character, Produto passado por par�metro para fun��o.
/*/
Static Function jFSESPEC(cProduto)
 	Local l0K    := .T.
	Local cCliente := ""  // C�digo do cliente
	Local cLoja    := ""  // C�digo da loja
	Local a_Area   := GetArea()

	DBSelectArea("SC5")
	DBGoTop()
	DBSetOrder(1)
	DBSeek(FwXFilial("SC5") + cProduto + cCliente + cLoja)

	If (FwIsInCallStack("MATA410")) 
			M->C5_FSESPEC  = '' .AND. xFilial("SC5")<>'030101' .AND. cProduto
				Help(NIL, NIL, "ERROR: C5_FSESPEC", NIL, "O campo (Especifidade) deve ser preenchido.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha corretamente."})
			l0K := .F.
		Return Nil
	EndIf

	RestArea(a_Area)
Return l0K
