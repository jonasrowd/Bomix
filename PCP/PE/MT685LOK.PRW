#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT685LOk
    PONTO DE ENTRADA PARA IMPEDIR ADICIONAR MAIS DE 2 LINHAS NO APONTAMENTO DE PERDA
    @type function
    @version 12.1.25
    @author JONAS MACHADO
    @since 26/10/2021
    @return logical, NÃO PERMITE ADICIONAR MAIS DE 2 LINHAS
/*/
USER FUNCTION MT685LOk()

    LOCAL lret  := .T.

    IF  n > 2
        lret := .F.
    ENDIF

RETURN lret
