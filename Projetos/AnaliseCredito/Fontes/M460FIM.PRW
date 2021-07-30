// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} M460FIM
    Ponto de entrada utilizado para atualizar o status do pedido após o faturamento
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 26/07/2021
/*/
User Function M460FIM()
    Local aArea := GetArea() // Armazena a área atual

	// Processa apenas se não for a filial 030101
    If (FwCodFil() != "030101")
        // Atualiza os campos de status para o BI
        DBSelectArea("SC5")
        RecLock("SC5", .F.)
            // Caso o pedido tenha sido faturado
            If (!Empty(C5_NOTA))
                // Se a quantidade de venda foi completamente atendida,
                // marca o pedido como encerrado, caso não, marca como parcial
                If (SC6->C6_QTDVEN == SC6->C6_QTDENT)
                    C5_FSSTBI := "ENCERRADO"
                ElseIf (SC6->C6_QTDVEN > SC6->C6_QTDENT)
                    C5_FSSTBI := "PARCIAL"
                EndIf
                // Altera o pedido para status final
                C5_BLQ     := ""
                C5_BXSTATU := ""
                C5_LIBEROK := "S"
            EndIf 
        MsUnlock()
    EndIf
	// Restaura a área de trabalho anterior
	RestArea(aArea)
Return (NIL)
