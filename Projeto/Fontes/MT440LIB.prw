#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MT440LIB
Ponto de Entrada para valida��o das retri��es financeiras dos clientes na libera��o do pedido de venda
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MT440LIB()
/*/

user function MT440LIB()
Local n_QtdVen := SC6->C6_QTDVEN
Local n_Ret := n_QtdVen
Local _CALIAS    :=GETAREA()

nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME
If nAtrasados <> 0 .AND. (!estaLib(SC5->C5_NUM))
	ShowHelpDlg(SM0->M0_NOME,;
	{"O Cliente " + AllTrim(cNome)  + "Pedido "+SC6->C6_NUM+", possue restri��es financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
	{"Caso queira concluir a libera��o deste pedido, solicite a libera��o dos respons�veis."},5) 
	
	n_Ret := 0
EndIf

RESTAREA(_CALIAS)
	
return n_Ret


 /*/{Protheus.doc} pesqLib
	(long_description)
	@type  Function
	@author R�mulo Ferreira
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

If dbSeek( SC5->C5_FILIAL + SC5->C5_NUM )

	While Z07->(!Eof()) .AND.  SC5->C5_NUM  = Z07->Z07_PEDIDO 

		If 'Venda' $ Z07->Z07_JUSTIF
			Return .T.
		EndIf

		Z07->(dbSkip())
	EndDo

EndIf
	
Return .F.

