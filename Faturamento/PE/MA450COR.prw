#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA450COR
Ponto de Entrada para inclusão de uma nova legenda na tela de Analise de Crédito dos Pedidos SIGAFAT
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MA450COR()©
/*/


user function MA450COR()

Local aLegenda := aclone(PARAMIXB)

aadd(aLegenda ,{'BR_PINK' , 'Pedido Bloqueado por Restrição Financeira'  })
	
return aLegenda


