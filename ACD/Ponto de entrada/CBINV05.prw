#include "apvt100.ch"
#INCLUDE "PROTHEUS.CH" 

User Function CBINV05
	Local cProduto  := PARAMIXB[1]
	Local cArmazem  := PARAMIXB[2]
	Local cEndereco := PARAMIXB[3]
	Local cDoc      := PARAMIXB[4]
	Local dData     := PARAMIXB[5]
	Local cLote     := PARAMIXB[6]
	Local cSubLote  := PARAMIXB[7]
	Local cNumSer   := PARAMIXB[8]
	Local l_Ret     := .F.
	
	While l_Ret == .F.	
	   l_Ret := U_FACDA004(cProduto, cArmazem, cEndereco, cDoc, dData, cLote, cSubLote, cNumSer, SB7->B7_QUANT)
	End		
Return  Nil
