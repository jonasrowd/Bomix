#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA440COR
Ponto de Entrada para inclusão de uma nova legenda na tela de Liberação de Pedidos SIGAFAT
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MA440COR()
/*/

user function MA440COR ()
	
Local aCor := aclone(PARAMIXB)


aCor[1][1] := "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. SC5->C5_BXSTATU<>'B'" 

AADD(aCor,{"SC5->C5_BXSTATU=='B'" , "BR_PINK"   })
	
return aCor