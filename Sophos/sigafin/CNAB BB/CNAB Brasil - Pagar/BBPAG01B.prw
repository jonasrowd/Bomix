#include "rwmake.ch"

/*
PROGRAMA  : BBPAG01B
DATA      : 04/12/09
DESCRIÇÃO : Zeca parametro sequencial do registro no lote e incrementa o total de lotes.
UTILIZAÇÃO: CNAB Brasil a Pagar - Registros Header Lote - Posições 017-017
*/

User Function BBPAG01B()

SetPrvt("CALIAS,NORD,NREG,XCONT2,XPROX2,XCONT5,XPROX5")
  
cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()                   

xCont2 := GetMv("MV_BBPAG2")
xProx2 := StrZero((Val(xCont2)+1),6)
dbSelectArea("SX6")
dbSeek(xFilial()+"MV_BBPAG2")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With xProx2
MsUnLock()
          
xCont5 := GetMv("MV_BBPAG5")
xProx5 := StrZero((Val(xCont5)+1),4)
dbSelectArea("SX6")
dbSeek(xFilial()+"MV_BBPAG5")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With xProx5
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

return(xProx5)