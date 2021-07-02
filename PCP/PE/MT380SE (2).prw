#include 'protheus.ch'
#include 'parmtype.ch'


/* O ponto de entrada permite executar ou não a verificação 
de alteração de quantidade no ajuste de empenho. Essa verificação 
não permite que a diferença existente entre os campos D4_QTDEORI e 
D4_QUANT seja diferente da quantidade já requisitada.
*/
User Function MT380SE()
	Local aArea1       := GetArea()
	
	Local lMT380SE := .F. //Customizações do usuário

	RestArea(aArea1)
Return(lMT380SE) 