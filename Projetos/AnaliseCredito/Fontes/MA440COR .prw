#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA440COR
Ponto de Entrada para inclus�o de uma nova legenda na tela de Libera��o de Pedidos SIGAFAT
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MA440COR()
/*/

user function MA440COR ()
	
Local aCor := aclone(PARAMIXB)
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return aCor
		endif

aCor[1][1] := "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. SC5->C5_BXSTATU<>'B'" 

AADD(aCor,{"SC5->C5_BXSTATU=='B'" , "BR_PINK"   })
AADD(aCor,{"SC5->C5_BXSTATU=='P'" , "BR_PRETO"   })
AADD(aCor,{"SC5->C5_BXSTATU=='E'" , "BR_MARROM"   })
	
return aCor