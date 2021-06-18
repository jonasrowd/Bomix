#INCLUDE "rwmake.ch"

/*      
PROGRAMA  : CNABCBB2
DATA      : 17/12/09
DESCRIÇÃO : Atualiza o parametro de controle dos numeros sequenciais de registro.
UTILIZAÇÃO: CNAB Banco Brasil - Cobrança
*/

USER FUNCTION CNABCBB2

cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

nSeq := GetMv("MV_CNABCR")

nProx := StrZero(Val(nSeq)+1,5)
dbSelectArea("SX6")
dbSeek(xFilial()+"MV_CNABCR")
RecLock("SX6",.f.)
   Replace X6_CONTEUD With nProx
MsUnLock() 

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(nProx)