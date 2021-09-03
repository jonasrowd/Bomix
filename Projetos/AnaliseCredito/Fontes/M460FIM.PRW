// Bibliotecas necessárias
#Include 'TOTVS.ch'

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
    If (FwCodFil() != '030101')
        // Atualiza a SC5
        SC5->(RecLock("SC5", .F.))
            // Posiciona no itens do pedido com base no cabeçalho
            DBSelectArea("SC6")
            DBSetOrder(1)
            DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)

            // Percorre os itens (SC6) com base no pedido (SC5)
            While (!EOF() .And. C6_NUM == SC5->C5_NUM .And. Empty(C6_NOTA))
                If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .AND. SC5->C5_BXSTATU $ 'L|A|E'
                    SC5->C5_FSSTBI := 'ENCERRADO'
                    SC5->C5_BLQ     := ''
                    SC5->C5_BXSTATU := ''
                    SC5->C5_LIBEROK := 'E'
                ElseIf (SC6->C6_QTDVEN > SC6->C6_QTDENT) .AND. SC5->C5_BXSTATU $ 'L|A|E'
                    SC5->C5_FSSTBI := 'PARCIAL'
                    SC5->C5_BLQ     := ''
                    SC5->C5_BXSTATU := 'A'
                    SC5->C5_LIBEROK := ''
                    EXIT
                EndIf

                DBSkip()
            End
    SC5->(MsUnlock())
    EndIf
	// Restaura a área de trabalho anterior
	RestArea(aArea)
Return (NIL)
