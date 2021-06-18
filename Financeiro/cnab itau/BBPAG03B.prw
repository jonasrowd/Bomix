#include "rwmake.ch"

/*
PROGRAMA  : BBPAG03B
DATA      : 04/12/09
DESCRIÇÃO : 
UTILIZAÇÃO: 
*/

User Function BBPAG03B()

SetPrvt("CALIAS,NORD,NREG,XVALOR,XVALORTL,XCONT")
  
cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

xCont    := StrZero((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,15)
xValor   := StrZero((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,18)
xValorTL := Val(xValor) + Val(StrZero(Val(GetMv("MV_BBPAG3")),18))

dbSelectArea("SX6")
dbSeek("      "+"MV_BBPAG3")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With str(xValorTL)
MsUnLock()
       
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

return(xCont)