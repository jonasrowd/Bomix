// BIBLIOTECAS NECESSÁRIAS
#Include "TOTVS.ch"
#Include "REPORT.ch"

// FUNÇÃO PRINCIPAL
User Function OPXVND()
    Local oReport := NIL // OBJETO TREPORT
    Local oPs     := NIL // SEÇÃO SGJ
    Local oBreak  := NIL // QUEBRA DE PÁGINA

    RPCSetEnv("01", "010101")
        // INSTANCIAÇÃO DE VARIÁVEL OREPORT
        DEFINE REPORT oReport NAME "REPORT1" TITLE "AMARRAÇÃO OP X PEDIDO" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}

        // DEFINIÇÃO DA SEÇÃO oPs
        DEFINE SECTION oPs OF oReport TITLE "PEDIDO X CLIENTE" TABLES "SGJ"
            DEFINE CELL NAME "GJ_FILIAL" OF oPs ALIAS "SGJ"
            DEFINE CELL NAME "GJ_NUMOP" OF oPs ALIAS "SGJ"            
            DEFINE CELL NAME "GJ_NUMPV" OF oPs ALIAS "SGJ"
            DEFINE CELL NAME "GJ_ITEMOP" OF oPs ALIAS "SGJ"            
            DEFINE CELL NAME "GJ_PRODUTO" OF oPs ALIAS "SGJ"
            DEFINE CELL NAME "GJ_ITEMPV" OF oPs ALIAS "SGJ"            
            DEFINE CELL NAME "GJ_QUANT" OF oPs ALIAS "SGJ"
        DEFINE BREAK oBreak OF oPs WHEN oPs:Cell("GJ_NUMOP")

        DEFINE FUNCTION FROM oPs:Cell("GJ_NUMOP") FUNCTION COUNT BREAK oBreak

        oReport:nRemoteType   := NO_REMOTE
        oReport:lExcelByEmail := .T.
        oReport:cEmail        := "jonas.machado@bomix.com.br"
        oReport:cFile         := "RELATORIO"

        oReport:SetDevice(IMP_EXCEL)
        oReport:SetPreview(.F.)
        oReport:Print(.F.)
    RPCClearEnv() // ENCERRRA AMBIENTE (COMENTAR SE VIA GUI)
Return (NIL)

// DADOS DE EXIBIÇÃO
Static Function PrintReport(oReport)
    Local cAlias := Space(0) // ALIAS TEMPORÁRIO

    // SE AMBIENTE IGUAL A TOPCONNECT
    #IFDEF TOP
        cAlias := GetNextAlias() // RECUPERA O PRÓXIMO ALIAS TEMPORÁRIO DO SISTEMA
        MakeSQLExp("REPORT")

        // INICIA QUERY PARA RETORNO DE DADOS
        BEGIN REPORT QUERY oReport:Section(1)
            BEGINSQL ALIAS cAlias
            select C6_PVCOMOP,
            C6_OP,
            C6_TES,
            C6_NUMOP,
            C5_EMISSAO,
            GJ_FILIAL,
            GJ_NUMOP,
            GJ_NUMPV, 
            GJ_ITEMOP,
            GJ_PRODUTO,
            GJ_ITEMPV, 
            B1_DESC,GJ_QUANT,C6.D_E_L_E_T_ AS 'ITEM_DEL?',B1.D_E_L_E_T_ AS 'PROD DEL?',GJ.D_E_L_E_T_ AS 'GJ_DEL?' 
            FROM SGJ010 GJ
            INNER JOIN SB1010 B1 ON GJ_PRODUTO=B1_COD AND GJ_FILIAL = RTRIM(B1_FILIAL) + '01'
            LEFT JOIN SC5010 C5 ON C5_NUM=GJ_NUMPV AND GJ_FILIAL=C5_FILIAL
            LEFT JOIN SC6010 C6 ON C6_NUM=GJ_NUMPV AND C6_PRODUTO=GJ_PRODUTO AND C6_ITEM=GJ_ITEMPV AND C6_FILIAL=GJ_FILIAL
            WHERE C5_EMISSAO>=DATEADD(d, -2, CONVERT(DATE, GETDATE(), 103)) AND
            C6.D_E_L_E_T_='' AND
            B1.D_E_L_E_T_='' AND
            GJ.D_E_L_E_T_='' AND 
            C6_TES IN ('501','502')
            ORDER BY GJ.R_E_C_N_O_ DESC
            ENDSQL
        END REPORT QUERY oReport:Section(1)

        oReport:Section(1):Print(.F.)
    #ENDIF
Return (NIL)
