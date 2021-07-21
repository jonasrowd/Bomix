#Include "Totvs.ch"

/*/{Protheus.doc} MT416FIM
	Ponto de entrada acionado ap�s o termino da efetiva��o do Or�amento de Venda.
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
        MsGInfo("Existem restri��es financeiras para este Cliente. Por favor solicitar Libera��o", "Aten��o!")
	Else
        M->C5_BXSTATU 	:= 'L'
        M->C5_BLQ 		:= ''
        M->C5_LIBEROK 	:= 'L'
	EndIf

Return


