#Include "Totvs.ch"

/*/{Protheus.doc} M460FIM
Ponto de entrada utilizado para atualizar o status do pedido após o faturamento.
@type function
@version 12.1.25
@author jonas.machado
@since 26/07/2021
@return variant, Null
/*/
User Function  M460FIM()

    Local aArea := GetArea() // Armazena a área atual

	// Processa apenas se não for a filial 030101
	If (FwCodFil() != "030101")
        
        RecLock("SC5", .F.) //Atualiza os campos de Status para o BI
        If  SC6->C6_QTDVEN      == SC6->C6_QTDENT .And. !Empty(SC5->C5_NOTA)
            SC5->C5_FSSTBI      := "ENCERRADO"
            SC5->C5_BXSTATU     := ""
			SC5->C5_BLQ         := ""
			SC5->C5_LIBEROK     := "S"
        EndIf
         
         
        If SC6->C6_QTDVEN > SC6->C6_QTDENT .And. !Empty(SC5->C5_NOTA)
                SC5->C5_FSSTBI      := "PARCIAL"
                SC5->C5_BXSTATU     := ""
                SC5->C5_BLQ         := ""
                SC5->C5_LIBEROK     := "S"

        EndIf 

        MsUnlock()
               
    EndIf

	// Restaura a área de trabalho anterior
	RestArea(aArea)

Return 
