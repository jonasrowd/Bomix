#Include 'Protheus.ch'

User Function A010BPE()
	Local cCampo := ParamIXB[1]
	Local cConteudo:= ParamIXB[2]
	Local lRet := .F.

	If cCampo = 'M->B1_DESC'
		lRet:= .F.
	EndiF

Return lRet