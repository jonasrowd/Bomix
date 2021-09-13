#include "rwmake.ch"

/*
PROGRAMA  : BBPAG02B
DATA      : 04/12/09
DESCRIÇÃO : 
UTILIZAÇÃO: 
*/

User Function BBPAG02B()

SetPrvt("CALIAS,NORD,NREG,XCONT")
  
cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()
       
xCont := StrZero(Val(GetMv("MV_BBPAG2")),6)

dbSelectArea("SX6")
dbSeek(xFilial()+"MV_BBPAG2")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With "000000"
MsUnLock()                            

dbSelectArea("SX6")
dbSeek(xFilial()+"MV_BBPAG1")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With "00000"
MsUnLock()

dbSelectArea("SX6")          
dbSeek(xFilial()+"MV_BBPAG3")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With Replicate("0",18)
MsUnLock()

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

return(xCont)