#include "rwmake.ch"

/*
PROGRAMA  : BBPAG01A
DATA      : 04/12/09
DESCRIÇÃO : Incrementa sequencial do registro no lote.
UTILIZAÇÃO: CNAB Brasil a Pagar - Registros Detalhe - Posições 009-013
*/

User Function BBPAG01A()

SetPrvt("CALIAS,NORD,NREG,XCONT,XPROX,XTOTALREG")
  
cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

xCont := GetMv("MV_BBPAG1")
xProx := StrZero((Val(xCont)+1),5)

dbSelectArea("SX6")
dbSeek(xFilial()+"MV_BBPAG1")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With xProx
MsUnLock()
                     
xTotalReg := StrZero((Val(GetMv("MV_BBPAG4"))+1),6)

dbSelectArea("SX6")
dbSeek(xFilial()+"MV_BBPAG4")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With xTotalReg
MsUnLock()

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

return(xProx)