#INCLUDE "Totvs.ch" 
#INCLUDE "Apvt100.ch"


/*/{Protheus.doc} CBINVVAL
	É executado dentro da validação da etiqueta de produtos, retornando um valor lógico .T. ; 
	para continuar a validação padrão ou .F. para abortar a validaçãoPonto
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 20/07/2021
	@return variant, l_Ret
/*/
User Function CBINVVAL()    

	Local l_Ret     := .F.
	
	While l_Ret == .F.	
	   l_Ret := U_FACDA004( cProduto, cArmazem, cEndereco,,, cLote,,, nQtdEtiq )
	End		

Return( l_Ret )
