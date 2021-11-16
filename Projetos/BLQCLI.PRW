#INCLUDE "TOTVS.CH"

#Define SLASH IIf(IsSrvUnix(), "/", "\")
#Define CRLF Chr(10) + (Chr(13))

/*/{Protheus.doc} BLQCLI
    Função para bloqueio automático de clientes que não efetuam pedidos há mais de um ano.
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 10/11/2021
/*/
USER FUNCTION BLQCLI()

    Local dOld := MonthSub(date(),12)
	Local cText     := ""  // Auxiliar da montagem da linha do log
	Local cPath     := ""  // Caminho de gravação do arquivo de logs
	Local oFile     := NIL // Arquivo de logs do job

    RPCSetEnv("01", "010101")
		cPath := SLASH + "DIRDOC" + SLASH
		oFile := FwFileWriter():New(cPath + cFilAnt + "_" + FwTimeStamp() + ".txt", .T.)
		oFile:Create()

        If Select("BLQCLI") > 0
            DbSelectArea("BLQCLI")
            QRYSC9->(DbCloseArea())
        EndIf

        BEGINSQL ALIAS "BLQCLI"

        SELECT A1_COD,A1_FILIAL,A1_ULTCOM,A1_NOME
        FROM
            SA1010 A1
        WHERE
            A1_ULTCOM <= %EXP:DTOS(dOld)% //Doze meses"
            AND A1_FILIAL = %XFILIAL:SA1%
            AND A1_PESSOA <> 'F'
            AND %NOTDEL%
            AND A1_ULTCOM <> ''
            AND A1_MSBLQL <> '1'
        ENDSQL

        While !(EOF())
            DbSelectArea("SA1")
            DbSetOrder(1)
            If DbSeek(FwXFilial("SA1") + BLQCLI->A1_COD)
                cText := "[" + FwTimeStamp(2)       + "]"
                cText += "[" + "CLIENTE: "  + AllTrim(BLQCLI->A1_COD)   + "]"
                cText += "[" + "ANTES: "  + AllTrim(SA1->A1_MSBLQL)   + "]"
                RecLock("SA1", .F.)
                    A1_MSBLQL := "1"
                MsUnlock()
                cText += "[" + "DEPOIS: "  + AllTrim(SA1->A1_MSBLQL)   + "]"
            EndIf
            oFile:Write(EncodeUTF8(cText + CRLF))
            SA1->(DbCloseArea())
            DbSelectArea("BLQCLI")
            DbSkip()
        End

	// Fecha o arquivo após o uso
	oFile:Close()
	oFile := NIL
	FreeObj(oFile)

    RPCCLEARENV()

RETURN
