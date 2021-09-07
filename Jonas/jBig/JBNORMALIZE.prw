// Bibliotecas necess�rias
#Include "TOTVS.ch"

// Fun��o apenas para exemplifica��o do resultado final
// Antes: ?????? (?.?(?_?)?.?) ? ? ? ? ? ? ? ? ? ? ? (?.?(?_?)?.?) ??????
// Depois:
User Function DumbInit()
	Local cOld := ":!@#$%�&*()_+��������/?����??�|\?;/.,~]�[=-�"
	Local cNew := U_JBNormalize(cOld)
Return (NIL)

/*/{Protheus.doc} JBNormalize
	Normaliza um conte�do texto removendo caracteres especiais
	@type Function
	@version 12.1.27
	@author Guilherme Bigois
	@since 03/09/2021
	@param cOld, Character, Conte�do a ser normalizado
	@return Character, Conte�do normalizado
/*/
User Function JBNormalize(cOld)
	Local nX    := 0                              // Contador de la�o de d�gitos
	Local nSize := Len(cOld)                      // Tamanho do texto para cria��o da m�scara
	Local cMask := "@R " + Replicate("X-", nSize) // M�scara com "X-" para cada caractere
	Local cAux  := Transform(cOld, cMask)         // Texto com a aplica��o da m�scara
	Local aChar := StrTokArr2(cAux, "-")          // Texto convertido em vetor
	Local cNew  := ""                             // Conte�do final

	// Percorre cada um dos caracteres
	For nX := 1 To Len(aChar)
		// Verifica se trata-se de um alfanum�rico
		If (IsAlpha(aChar[nX]) .Or. IsDigit(aChar[nX]))
			// Adiciona o caractere ao conjunto do novo conte�do
			cNew += aChar[nX]
		EndIf
	Next nX

	// Remove qualquer outro caractere especial que possa ter passado
	cNew := FwCutOff(cNew)
Return (cNew)
