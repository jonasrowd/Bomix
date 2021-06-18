#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

User Function TMRT011()        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NORD,NREG,XCONT,NPROX,")

// Execblock usado no CNAB a pagar para efetuar a sequencia diaria
// ,de acordo com exigencias BB.

cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

If SEE->EE_DTGERA <> DDATABASE
   xSeq:="01"
   RecLock("SEE",.f.)
      Replace EE_DTGERA With DDATABASE
      Replace EE_SEQDIA With xSeq
   MsUnLock()
else
   xSeq:=StrZero(Val(SEE->EE_SEQDIA)+1,2)
   RecLock("SEE",.f.)
      Replace EE_SEQDIA With xSeq
   MsUnLock()
Endif

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(xSeq)
