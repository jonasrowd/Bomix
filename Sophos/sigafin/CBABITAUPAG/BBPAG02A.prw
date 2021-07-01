#include "rwmake.ch"

/*
PROGRAMA  : BBPAG02A
DATA      : 04/12/09
DESCRIÇÃO : 
UTILIZAÇÃO: 
*/

User Function BBPAG02A()

SetPrvt("CALIAS,NORD,NREG,XTOTALDTL,XTOTALTRL,XTOTALREG")
  
cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()
                                                 
xTotalDtl := StrZero(Val(GetMv("MV_BBPAG4")),6)
xTotalTRL := StrZero(Val(GetMv("MV_BBPAG2"))*2,6)
xTotalReg := StrZero(Val(xTotalDtl)+Val(xTotalTRL)+000002,6)

dbSelectArea("SX6")
dbSeek("      "+"MV_BBPAG1")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With "00000"
MsUnLock()

dbSelectArea("SX6")
dbSeek("      "+"MV_BBPAG2")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With "000000"
MsUnLock()                            

dbSelectArea("SX6")          
dbSeek("      "+"MV_BBPAG3")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With Replicate("0",18)
MsUnLock()

dbSelectArea("SX6")
dbSeek("      "+"MV_BBPAG4")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With "000000"
MsUnLock()
          
dbSelectArea("SX6")
dbSeek("      "+"MV_BBPAG5")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With "0000"
MsUnLock()

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

return(xTotalReg)