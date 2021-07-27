#Include "TOTVS.ch"

/*/{Protheus.doc} JBIG001
	Cria tabela que exista Sx sem precisar acessar a rotina.
	@type function
	@version  12.1.25
	@author jonas.machado
	@since 22/07/2021
	@return variant, Null
/*/
User Function JBIG001()
	RPCSetEnv("01", "0101")
    DbSelectArea("Z07")
	RPCClearEnv()
Return (NIL)
