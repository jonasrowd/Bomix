#include "protheus.ch"

User Function FFATA002()
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return
		endif
	
AxCadastro("Z07","Histórico de Liberações")
	
Return
