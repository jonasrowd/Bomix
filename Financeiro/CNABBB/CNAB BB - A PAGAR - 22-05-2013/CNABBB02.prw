#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

User Function CNABBB02()        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NORD,NREG,XCONT,NPROX,")

// Execblock ITAFIN10.PRW usado no CNAB para efetuar a
// contagem dos segmentos, de acordo com exigencias BB.
// Paula Nolasco


cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()


If FUNNAME() == "FINA150" .or. FUNNAME() == "FINA740"
  xCont := GetMv("MV_CNABCR")
else
   If FUNNAME() == "FINA420" .or. FUNNAME() == "FINA750"
      xCont := GetMv("MV_CNABCP")
   else
      If FUNNAME() == "GPEM410"
         xCont := GetMv("MV_CNABFOL")
      Endif
   Endif
Endif
nProx := Val(xCont)+1
dbSelectArea("SX6")


If FUNNAME() == "FINA150"
  dbSeek(xFilial()+"MV_CNABCR")
else
   If FUNNAME() == "FINA420"  .or. FUNNAME() == "FINA750"
      dbSeek(xFilial()+"MV_CNABCP")
   else
      If FUNNAME() == "GPEM410"
         dbSeek(xFilial()+"MV_CNABFOL")
      Endif
   Endif
Endif

RecLock("SX6",.f.)
   Replace X6_CONTEUD With StrZero(nProx,5)
MsUnLock()

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(nProx)
