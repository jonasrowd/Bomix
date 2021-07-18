#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA415LEG
Ponto de Entrada para inclusão de uma nova legenda na tela de orçamentos SIGAFAT
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MA415LEG()
/*/

user function MA415LEG ()

Local aLegenda := aclone(PARAMIXB)
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return aLegenda
		endif
aadd(aLegenda ,{'BR_PINK'    , 'Orcamento Bloqueado por Restrição Financeira'  })
aadd(aLegenda ,{'BR_AZUL_CLARO'    , 'Orcamento Baixado com Restrição Financeira'  })

	
return aLegenda
