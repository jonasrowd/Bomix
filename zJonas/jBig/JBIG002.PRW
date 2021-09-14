#Include "Totvs.ch"
/*/{Protheus.doc} JBIG002
	Executa o job de análise de crédito para cada filil da empresa 01
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 27/07/2021
/*/
User Function JBIG002()
	Local nX      := 0  // Contador do laço de filiais
	Local aBranch := {} // Filiais do sistema

	// Prepara o ambiente para apenas uma empresa para
	// capturar as filiais contidas neste grupos
	RPCSetType(3)
	RPCSetEnv("01")
		aBranch := FwAllFilial()
	RPCClearEnv()

	// Abre uma nova thread para preparação de ambiente
	// em cada filial do grupo de empresas
	For nX := 1 To Len(aBranch)
		StartJob("U_JOBZERAJBIG", GetEnvServer(), .T., aBranch[nX])
	Next nX
Return (NIL)
