#Include 'Totvs.ch'
User function Exemplott()
  Local aRetType, aRetFile, aRetLine, aRetDate, aRetBType
  aRet := GetFuncArray("u_exemplo", aRetType, aRetFile, aRetLine, aRetDate, aRetBType)
  conout("Funcao U_Exemplo:")
  conout("aRetType  - " + aRetType[1])
  conout("aRetFile  - " + aRetFile[1])
  conout("aRetLine  - " + aRetLine[1])
  conout("aRetDate  - " + cvaltochar(aRetDate[1]))
  conout("aRetBType - " + aRetBType[1])
Return
