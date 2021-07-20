#INCLUDE "Totvs.ch" 
#INCLUDE "Apvt100.ch"


/*/{Protheus.doc} CBINVVAL
	� executado dentro da valida��o da etiqueta de produtos, retornando um valor l�gico .T. ; 
	para continuar a valida��o padr�o ou .F. para abortar a valida��oPonto
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
