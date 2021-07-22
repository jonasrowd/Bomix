// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} MT416FIM
	Ponto de entrada acionado após o termino da efetivação do Orçamento de Venda
	@type Function
	@version 12.1.25 
	@author Jonas Machado
	@since 21/07/2021
	@see https://tdn.totvs.com/display/public/PROT/MT416FIM
/*/
User Function MT416FIM
	Local aArea      := GetArea()                                // Armazena a área atual
	Local nAtrasados := U_FFATVATR(M->C5_CLIENTE, M->C5_LOJACLI) // Retorna o valor de títulos em aberto
	
	// Processa apenas se não for a filial 030101
	If (FwCodFil() != "030101")

		// Realiza a gravação complementar 
		// no cabeçalho do pedido de venda
		DBSelectArea("SC5")
		RecLock("SC5", .F.)
			// Se houver saldo em atraso, bloqueia o pedido
			If (nAtrasados != 0)
				C5_BXSTATU := "B"
				C5_BLQ     := "B"
				C5_LIBEROK := "S"
				Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "Existem restrições financeiras para este cliente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor solicitar liberação ao departamento comercial."})
			Else
				C5_BXSTATU := "L"
				C5_BLQ     := " "
				C5_LIBEROK := "L"
			EndIf
		MsUnlock()
	EndIf
	
	// Restaura a área de trabalho anterior
	RestArea(aArea)
Return (NIL)
