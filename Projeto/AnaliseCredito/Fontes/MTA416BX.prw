#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA416BX()
Local l_Ret:= .T.
Local nAtrasados := 0
Local cNome := ""
Local _CALIAS    :=GETAREA()

nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME

If nAtrasados <> 0  

	MsGInfo("Existem restrições financeiras para este Cliente. Por favor solicitar Liberação", "Atenção!")
	Return .T.	
EndIf

RESTAREA(_CALIAS)

return l_Ret

 /*/{Protheus.doc} pesqLib
	(long_description)
	@type  Function
	@author Rômulo Ferreira
	@since 13/07/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, , return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function estaLib(_cPed)
Default _cPed := ""

DbSelectArea("Z07")
DbSetOrder(1)

If dbSeek( SC5->C5_FILIAL + SC5->C5_NUM ) .AND. (!estaLib(SC5->C5_NUM))

	While Z07->(!Eof()) .AND.  SC5->C5_NUM  = Z07->Z07_PEDIDO 

		If 'Venda' $ Z07->Z07_JUSTIF
			Return .T.
		EndIf

		Z07->(dbSkip())
	EndDo

EndIf
	
Return .F.

