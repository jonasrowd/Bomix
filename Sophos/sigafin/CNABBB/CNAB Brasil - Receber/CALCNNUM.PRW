#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
	DEFINE PSAY SAY
#ENDIF

//-------------------------------------------------------------------------
// Descricao - Execblock chamado no campo nosso número do layout remessa BB
// Programa  - CALCNNUM
//-------------------------------------------------------------------------

User Function CALCNNUM()

cNosso := ""

If Empty(SE1->E1_NUMBCO)
	
	NNUM      := STRZERO(Val(SEE->EE_FAXATU),10)
	cNosso    := Strzero(Val(SEE->EE_CODEMP),7)+NNUM
	cDigNosso := U_CALC_di9(cNosso)
	
	DbSelectArea("SEE")
	RecLock("SEE",.F.)
	SEE->EE_FAXATU:= StrZero(Val(NNUM)+1,10)
	MsUnlock()
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO,.T.)
	RecLock("SE1",.F.)
	SE1->E1_NUMBCO:=cNosso+cDigNosso
	cNosso:=cNosso+cDigNosso
	MsUnlock()
	
else
	cNosso := Substr(SE1->E1_NUMBCO,1,Len(Alltrim(SE1->E1_NUMBCO))-1)
endif

Return(cNosso)