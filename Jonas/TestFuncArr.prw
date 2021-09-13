#Include 'Totvs.ch'


User Function TestaGetFuncArray()
  Local aRet
  Local nCount
  // Para retornar a origem da fun��o: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
  Local aType
  // Para retornar o nome do arquivo onde foi declarada a fun��o
  Local aFile
  // Para retornar o n�mero da linha no arquivo onde foi declarada a fun��o
  Local aLine
  // Para retornar a data da �ltima modifica��o do c�digo fonte compilado
  Local aDate
  // Para retornar a hora da �ltima modifica��o do c�digo fonte compilado
  Local aTime
   
  // Buscar informa��es de todas as fun��es contidas no APO
  // tal que tenham a substring 'test' em algum lugar de seu nome
  aRet := GetFuncArray('U_TEST*', aType, aFile, aLine, aDate,aTime)
  for nCount := 1 To Len(aRet)
    conout("Funcao " + cValtoChar(nCount) + "= " + aRet[nCount])
    conout("Arquivo " + cValtoChar(nCount) + "= " + aFile[nCount])
    conout("Linha " + cValtoChar(nCount) + "= " + aLine[nCount])
    conout("Tipo " + cValtoChar(nCount) + "= " + aType[nCount])
    conout("Data " + cValtoChar(nCount) + "= " + DtoC(aDate[nCount]))
    conout("Hora " + cValtoChar(nCount) + "= " + aTime[nCount])
  Next
Return
