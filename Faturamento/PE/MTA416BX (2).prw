#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA416BX()
Local l_Ret:= .T.
Local nAtrasados := 0
Local cNome := ""
//Local c_Alias:= PARAMIXB[1]
Local _CALIAS    :=GETAREA()
//Local cMensagem := ""
Local c_UserLib := GETMV("BM_USERLIB")

nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME

If nAtrasados <> 0  

	If !__CUSERID$(c_UserLib)
		RecLock("SC5", .F.)
			SC5->C5_BXSTATU := 'B'		//Bloqueado Financeiro
		MsUnlock()
		MsGInfo("Existem restrições financeiras para este Cliente. Por favor solicitar Liberação", "Atenção!")
		Return .T.
	EndIf
	
EndIf

RESTAREA(_CALIAS)

return l_Ret
