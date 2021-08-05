#include 'protheus.ch'
User Function FonteRPO()
    Local nCount    := 0
    Local aFuncao     := {}     // Para retornar a origem da função: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
    Local aType        := {}     // Para retornar o nome do arquivo onde foi declarada a função
    Local aFile        := {}     // Para retornar o número da linha no arquivo onde foi declarada a função
    Local aDate        := {}     // Para retornar a data da última modificação do código fonte compilado
    Local aTime        := {}     // Para retornar a hora da última modificação do código fonte compilado
    Local cMascara    := "U_*"  // Neste caso, será exibido todos os fontes de usuário, seja fontes feitas por você ou Totvs.
    Local cFile        := ""
    Local cFuncao    := ""
    Local cTipoFonte:= ""
    Local aArquivos := {}
    aFuncao := GetFuncArray(cMascara, aType, aFile, aLine, aDate, aTime)
    For nCount := 1 To Len(aFuncao)
        cFile           := aFile[nCount]
        cTipoFonte     := Alltrim(aType[nCount])
        cFuncao        := aFuncao[nCount]
        aadd(aArquivos,{cFuncao, cFile, aType[nCount], DtoC(aDate[nCount]), aTime[nCount]})
    Next
    
Return
