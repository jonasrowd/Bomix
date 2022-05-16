#Include "Totvs.ch"

// Barra de separação de diretórios
#Define SLASH IIf(IsSrvUnix(), "/", "\")

/*/{Protheus.doc} EXPSG1
    Exporta a tabela Sg1 para csv
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 12/10/2021
/*/
User Function EXPSG1()
    
    Local cText     := ""  // Auxiliar da montagem da linha do log
    Local cPath     := ""  // Caminho de gravação do arquivo de logs
    Local oFile     := NIL // Arquivo de logs do job

    RPCSetEnv("01", "010101")

    cPath := SLASH + "DIRDOC" + SLASH
    oFile := FwFileWriter():New(cPath + cFilAnt + "_SG1_" + FwTimeStamp() + ".csv", .T.)
    oFile:Create()

    // Fecha a tabela de pedidos em aberto caso o alias esteja em uso
    If (Select("SG1TEMP") > 0)
        DBSelectArea("SG1TEMP")
        DBCloseArea()
    EndIf

    // Trás os pedidos que estão em aberto
    BEGINSQL ALIAS "SG1TEMP"
        SELECT 
            G1_FILIAL, 
            G1_COD, 
            G1_COMP, 
            G1_QUANT, 
            G1_PERDA, 
            G1_INI, 
            G1_FIM,
            G1_TRT
        FROM 
            SG1010 SG1 (NOLOCK)
        WHERE 
            SG1.D_E_L_E_T_ = '' AND 
            G1_FILIAL = '010101'
            ORDER BY G1_COD
    ENDSQL
    // Percorre os pedidos em aberto

    oFile:Write(EncodeUTF8("FILIAL;CODPAI;COMPONENTE;QUANTIDADE;PERDA;INICIO;FIM;TRT" + CRLF))

    While (!EOF())
        cText := AllTrim(CVALTOCHAR(SG1TEMP->G1_FILIAL)) + ";"
        cText += AllTrim(SG1TEMP->G1_COD    ) + ";"
        cText += AllTrim(SG1TEMP->G1_COMP   ) + ";"
        cText += AllTrim(CVALTOCHAR(SG1TEMP->G1_QUANT)) + ";"
        cText += AllTrim(CVALTOCHAR(SG1TEMP->G1_PERDA)) + ";"
        cText += AllTrim(SG1TEMP->G1_INI    ) + ";"
        cText += AllTrim(SG1TEMP->G1_FIM    ) + ";"
        cText += AllTrim(SG1TEMP->G1_TRT    )
        oFile:Write(EncodeUTF8(cText + CRLF))
        DbSkip()
    End

    // Fecha o arquivo após o uso
	oFile:Close()
	oFile := NIL
	FreeObj(oFile)
    RPCClearEnv() // Encerra as variáveis do ambiente

Return (Nil)
