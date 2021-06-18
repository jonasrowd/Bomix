//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
  
/*/{Protheus.doc} zUltNum
Função que retorna o ultimo campo código
@type function
@author VICTOR SOUSA
@since 06/09/2019
@version 1.0
    @param cTab, Caracter, Tabela que será consultada
    @param cCampo, Caracter, Campo utilizado de código
    @param [lSoma1], Lógico, Define se além de trazer o último, já irá somar 1 no valor
    @example
    u_zUltNum("SC5", "C5_X_CAMPO", .T.)
/*/
  
User Function zUltNum(cTab, cCampo)   
    Local aArea       := GetArea()
    Local cCodFull    := ""
    Local cCodAux     := ""
    Local cQuery      := ""
    Local nTamCampo   := 0
      
    //Definindo o código atual
    nTamCampo := TamSX3(cCampo)[01]
    cCodAux   := StrTran(cCodAux, ' ', '0')
      
    //Consulta para pegar as informações
    cQuery := " SELECT "
    cQuery += "   ISNULL(MAX(CAST("+cCampo+" AS INT)), '0')+1 AS MAXIMO "
    cQuery += " FROM "
    cQuery += "   "+RetSQLName(cTab)+" TAB "
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "QRY_TAB"

	dbSelectArea("QRY_TAB")
	dbGoTop()

    //Se não tiver em branco
    If !Empty(QRY_TAB->MAXIMO)
        cCodAux :=      STRZERO(QRY_TAB->MAXIMO,nTamCampo)     //QRY_TAB->MAXIMO
    EndIf
      
    //Definindo o código de retorno
    cCodFull := cCodAux
      
    QRY_TAB->(DbCloseArea())
    RestArea(aArea)
Return cCodFull