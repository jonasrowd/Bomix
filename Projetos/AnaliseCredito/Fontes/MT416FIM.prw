#Include "Totvs.ch"

/*/{Protheus.doc} MT416FIM
	Ponto de entrada acionado após o termino da efetivação do Orçamento de Venda.
	@type Function
	@version 12.1.25 
	@author Jonas Machado
	@since 21/07/2021
	@return variant, Null
/*/

User Function MT416FIM
	
    Local nAtrasados := u_FFATVATR(M->C5_CLIENTE, M->C5_LOJACLI) 
	private cfil :="      "
	
	cFil := FWCodFil()
		if cFil = "030101"
			return 
		endif

	If nAtrasados != 0
		M->C5_BXSTATU 	:= 'B'
		M->C5_BLQ 		:= 'B'
        M->C5_LIBEROK 	:= 'S'
        MsGInfo("Existem restrições financeiras para este Cliente. Por favor solicitar Liberação", "Atenção!")
	Else
        M->C5_BXSTATU 	:= 'L'
        M->C5_BLQ 		:= ''
        M->C5_LIBEROK 	:= 'L'
	EndIf

Return


