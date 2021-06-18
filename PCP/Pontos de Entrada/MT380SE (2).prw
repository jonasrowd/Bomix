#include 'protheus.ch'
#include 'parmtype.ch'


/* O ponto de entrada permite executar ou n�o a verifica��o 
de altera��o de quantidade no ajuste de empenho. Essa verifica��o 
n�o permite que a diferen�a existente entre os campos D4_QTDEORI e 
D4_QUANT seja diferente da quantidade j� requisitada.
*/
User Function MT380SE()
	Local aArea1       := GetArea()
	
	Local lMT380SE := .F. //Customiza��es do usu�rio

	RestArea(aArea1)
Return(lMT380SE) 