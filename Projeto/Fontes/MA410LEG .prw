#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA410LEG
Ponto de Entrada para inclusão de uma nova legenda na tela de Liberação de Pedidos SIGAFAT
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MA410LEG()
/*/

user function MA410LEG ()
	
Local aLegenda := aclone(PARAMIXB)

aadd(aLegenda ,{'BR_PINK' , 'Pedido Bloqueado por Restrição Financeira'  })
aadd(aLegenda ,{'BR_MARROM' , 'Pedido Liberado para Expedição'  })
aadd(aLegenda ,{'BR_PRETO' , 'Pedido Bloqueado por Restrição Financeira - Produção Liberada'  })
	
return aLegenda
