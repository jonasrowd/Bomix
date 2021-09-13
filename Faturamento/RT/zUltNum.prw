//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
  
/*/{Protheus.doc} zUltNum
Fun��o que retorna o ultimo campo c�digo
@type function
@author VICTOR SOUSA
@since 06/09/2019
@version 1.0
    @param cTab, Caracter, Tabela que ser� consultada
    @param cCampo, Caracter, Campo utilizado de c�digo
    @param [lSoma1], L�gico, Define se al�m de trazer o �ltimo, j� ir� somar 1 no valor
    @example
    u_zUltNum("SC5", "C5_X_CAMPO", .T.)
/*/
  
User Function zUltNum(cTab, cCampo)   
    Local aArea       := GetArea()
    Local cCodFull    := ""
    Local cCodAux     := ""
    Local cQuery      := ""
    Local nTamCampo   := 0
      
    //Definindo o c�digo atual
    nTamCampo := TamSX3(cCampo)[01]
    cCodAux   := StrTran(cCodAux, ' ', '0')
      
    //Consulta para pegar as informa��es
    cQuery := " SELECT "
    cQuery += "   ISNULL(MAX("+cCampo+"), '0')+1 AS MAXIMO "
    cQuery += " FROM "
    cQuery += "   "+RetSQLName(cTab)+" TAB "
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "QRY_TAB"
      
    //Se n�o tiver em branco
    If !Empty(QRY_TAB->MAXIMO)
        cCodAux := QRY_TAB->MAXIMO
    EndIf
      
    //Definindo o c�digo de retorno
    cCodFull := cCodAux
      
    QRY_TAB->(DbCloseArea())
    RestArea(aArea)
Return cCodFull