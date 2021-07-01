
#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA410COR
Ponto de Entrada para inclusão de uma nova legenda na tela de pedidos
@author Romulo Ferreira
@since 04/01/21
@version 1.0
	@example
	u_MA410COR()
/*/

user function MA410COR ()
	
Local aCor := aclone(PARAMIXB)


aCor[1][1] := "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. SC5->C5_BXSTATU<>'B'" 

AADD(aCor,{"SC5->C5_BXSTATU=='E'" , "BR_MARROM"   })
AADD(aCor,{"SC5->C5_BXSTATU=='B'" , "BR_PINK"   })
AADD(aCor,{"SC5->C5_BXSTATU=='P'" , "BR_PRETO"   })
	
return aCor
