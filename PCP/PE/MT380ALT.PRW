#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT380ALT
    Responsável pela alteração de requisições empenhadas (Emp. Simples.)
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 28/10/2021
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6087774
/*/
USER FUNCTION MT380ALT()

    Local c_Op      := SD4->D4_OP  //Op posicionada
    Local nPerc     := 0           //Percentual do produto calculado
    Local n_Total   := 0           //Total Master + Resina

    IF (ALTERA .OR. INCLUI)//Se for alteração ou inclusão, realiza o cálculo

        //Fecha a área da tabela se estiver aberta
        If (Select("EMPSIMP") > 0)
			DBSelectArea("EMPSIMP")
			DBCloseArea()
		EndIf

        BEGINSQL ALIAS "EMPSIMP"
            SELECT SUM(D4_QTDEORI) AS TOTEMP
            FROM  %TABLE:SD4%
            WHERE D4_FILIAL = %XFILIAL:SD4%
                AND %NOTDEL%
                AND D4_OP = %EXP:c_Op%
                AND (D4_FSTP LIKE "%MASTER%" OR D4_FSTP LIKE "%RESINA%")
        ENDSQL

        n_Total  := EMPSIMP->TOTEMP //ARMAZENA O TOTAL PROVISORIAMENTE

        EMPSIMP->(DBCloseArea())

        If (Select("RECALC") > 0)
			DBSelectArea("RECALC")
			DBCloseArea()
		EndIf

        BEGINSQL ALIAS "RECALC"
            SELECT 
                D4_COD AS PROD, 
                D4_QTDEORI AS ORI,
                D4_OP AS OP,
                D4_FSTP AS TIPO
            FROM  %TABLE:SD4%
            WHERE D4_FILIAL = %XFILIAL:SD4%
                AND %NOTDEL%
                AND D4_OP = %EXP:c_Op%
        ENDSQL

        While (!EOF())
            IF RECALC->TIPO $ 'MASTER|RESINA'
                nPerc := ((RECALC->ORI) / n_Total) * 100 //Calcula o percentual de cada Master / resina
                DbSelectArea("SD4")
                DbSetOrder(1)
                DbSeek(FwXFilial("SD4") + RECALC->PROD + RECALC->OP)
                RecLock("SD4", .F.)
                    SD4->D4_FSPM_R := Round(nPerc,2) //Grava no campo específico a proporção de cada item
                MsUnlock()
            ENDIF
            RECALC->(DbSkip())
        End

    ENDIF

RETURN NIL
