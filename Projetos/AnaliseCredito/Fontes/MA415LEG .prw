#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA415LEG
Ponto de Entrada para inclus�o de uma nova legenda na tela de or�amentos SIGAFAT
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
aadd(aLegenda ,{'BR_PINK'    , 'Orcamento Bloqueado por Restri��o Financeira'  })
aadd(aLegenda ,{'BR_AZUL_CLARO'    , 'Orcamento Baixado com Restri��o Financeira'  })

	
Return aLegenda


/*
{ 'ENABLE'    , STR0052 },; //'Orcamento em Aberto'
					{ 'DISABLE'   , STR0053 },; //'Orcamento Baixado'
					{ 'BR_PRETO'  , STR0054 },; //'Orcamento Cancelado'
					{ 'BR_AMARELO', STR0055 },; //'Orcamento nao Orcado'
					{ 'BR_MARROM' , STR0078 }}  //'Orcamento bloqueado'
*/