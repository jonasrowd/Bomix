#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

User Function CNABBB03()        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NORD,NREG,CRET,")

// Execblock ITAFIN11.PRW usado no CNAB para efetuar a contagem
// dos segmentos, de acordo com exigencias do BB.
// Paula Nolasco


  
cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()
dbSelectArea("SX6")

If FUNNAME() == "FINA150"
  dbSeek(xFilial()+"MV_CNABCR")
else
   If FUNNAME() == "FINA420"
      dbSeek(xFilial()+"MV_CNABCP")
   else
     If FUNNAME() == "GPEM410"
        dbSeek(xFilial()+"MV_CNABFOL")
      Endif
   Endif
Endif

RecLock("SX6",.f.)
   Replace X6_CONTEUD With "00000"
MsUnLock()
cRet := Space(9)
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(cRet)
