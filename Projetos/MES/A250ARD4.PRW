#include "topconn.ch"

user function A250ARD4()
Local nx := 0 
aSd4 := PARAMIXB
If SH6->H6_QTDPERD > 0
for nx := 1 to len(aSd4[1])
    dbSelectArea("SB1")
    dbSetOrder(1)
    If dbSeek(Substr(cFilAnt,1,4)+'  '+aSd4[1][nx][3])    
        If !gravaPerda(aSd4[1][nx][3])
            aSd4[1][nx][2] := 0  
        EndIf
    EndIf
next
EndIF

Return aSD4

/*/{Protheus.doc} gravaPerda
    (long_description)
    @type  Static Function
    @author Rùmulo Ferreira
    @since 28/05/2021
    @version version
    @param _cCod, c, Codigo do Produto
    @return lPerda, L, verdadeiro ou falso se grava a perda
    @example
    (examples)
    @see (links_or_references)
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

Return .T. // Se nùo achou configuraùùo de Perda, grava perda normalmente
