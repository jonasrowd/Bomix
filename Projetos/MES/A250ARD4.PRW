#include "topconn.ch"

/*/{Protheus.doc} A250ARD4
    Não grava perda de itens específicos com base na tabela Z05 campo Z05_NOME = B1_BRTPPR
    @type function
    @version 12.1.25
    @author jonas.machado
    @since 19/07/2021
    @return variant, Retorna os produtos que possuem perda.
/*/
User Function A250ARD4()
    Local nX := 0
    aSd4 := PARAMIXB
    If SH6->H6_QTDPERD > 0
        For nX := 1 to len(aSd4[1])
            dbSelectArea("SB1")
            dbSetOrder(1)
            If dbSeek(Substr(cFilAnt,1,4)+'  '+aSd4[1][nX][3])
                If !gravaPerda(aSd4[1][nX][3])
                    aSd4[1][nX][2] := 0
                EndIf
            EndIf
        Next
    EndIf

Return aSD4

/*/{Protheus.doc} gravaPerda
    Realiza a gravação da perda dos itens que possuem.
    @type  Function
    @author Rômulo Ferreira
    @since 28/05/2021
    @version 12.1.25
    @param _cCod, character, Codigo do Produto
/*/
Static Function gravaPerda(_cCod)

    If Select("TRB") > 1
        TRB->(dbCloseArea())
    EndIf

    cQry := " SELECT
    cQry += " Z05_PERDA PERDA
    cQry += " FROM
    cQry += " P12OFICIAL.dbo.SB1010 B1 (nolock)
    cQry += " Inner Join P12OFICIAL.dbo.Z05010 Z05 ON Z05_FILIAL = B1_FILIAL
    cQry += "                                     AND Z05.D_E_L_E_T_ <> '*'
    cQry += "                                     AND Z05_NOME = B1_BRTPPR
    cQry += " WHERE
    cQry += " B1_FILIAL = '"+xFilial("SB1")+"'
    cQry += " AND B1.D_E_L_E_T_ <> '*'
    cQry += " AND B1_BRTPPR <> ''
    cQry += " AND B1_COD = '"+_cCod+"'

    TCQUERY cQry NEW ALIAS "TRB"

    If TRB->(!EoF())
        Return TRB->PERDA = 'S'
    EndIf

Return .T. // Se não achou configuração de Perda, grava perda normalmente
