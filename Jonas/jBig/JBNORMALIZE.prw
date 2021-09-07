// Bibliotecas necessárias
#Include "TOTVS.ch"

// Função apenas para exemplificação do resultado final
// Antes: ?????? (?.?(?_?)?.?) ? ? ? ? ? ? ? ? ? ? ? (?.?(?_?)?.?) ??????
// Depois:
User Function DumbInit()
	Local cOld := ":!@#$%¨&*()_+§¬¢££³²¹/?°ªº°??°|\?;/.,~]´[=-ø"
	Local cNew := U_JBNormalize(cOld)
Return (NIL)

/*/{Protheus.doc} JBNormalize
	Normaliza um conteúdo texto removendo caracteres especiais
	@type Function
	@version 12.1.27
	@author Guilherme Bigois
	@since 03/09/2021
	@param cOld, Character, Conteúdo a ser normalizado
	@return Character, Conteúdo normalizado
/*/
User Function JBNormalize(cOld)
	Local nX    := 0                              // Contador de laço de dígitos
	Local nSize := Len(cOld)                      // Tamanho do texto para criação da máscara
	Local cMask := "@R " + Replicate("X-", nSize) // Máscara com "X-" para cada caractere
	Local cAux  := Transform(cOld, cMask)         // Texto com a aplicação da máscara
	Local aChar := StrTokArr2(cAux, "-")          // Texto convertido em vetor
	Local cNew  := ""                             // Conteúdo final

	// Percorre cada um dos caracteres
	For nX := 1 To Len(aChar)
		// Verifica se trata-se de um alfanumérico
		If (IsAlpha(aChar[nX]) .Or. IsDigit(aChar[nX]))
			// Adiciona o caractere ao conjunto do novo conteúdo
			cNew += aChar[nX]
		EndIf
	Next nX

	// Remove qualquer outro caractere especial que possa ter passado
	cNew := FwCutOff(cNew)
Return (cNew)
