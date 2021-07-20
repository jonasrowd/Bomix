#Include "Totvs.ch"
#Include "Apvt100.ch"

/*/{Protheus.doc} DV080QTD
    Localizado logo ap�s a valida��o padr�o de quantidade informada pelo usu�rio, na rotina de endere�amento via coletor de dados RF.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 20/07/2021
    @return logical, .T.
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=614950804
/*/
User Function DV080QTD()

    Local l_Ret			:= .T.
    Local c_Local		:= ParamIxb[1]	//Armaz�m destino
    Local c_EstFis		:= ParamIxb[2]	//Estrutura f�sica destino
    Local c_Endereco	:= ParamIxb[3]	//Endere�o destino
    Local c_Produto		:= ParamIxb[4]	//C�digo do produto
    Local c_Lote		:= ParamIxb[5]	//Lote do produto
    Local c_SubLote		:= ParamIxb[6]	//Sublote do produto
    Local n_QtdNorma	:= ParamIxb[7]	//Quantidade de produtos definido na norma de unitiza��o
    Local n_Quant		:= ParamIxb[8]	//Quantidade do produto (solicitada pelo sistema)
    Local n_QtdInf		:= ParamIxb[9]	//Quantidade do produto (informada pelo usu�rio)

    l_Ret	:= U_FACDA007( c_Local, c_EstFis, c_Endereco, c_Produto, c_Lote, c_SubLote, n_QtdNorma, n_Quant, n_QtdInf )

Return( l_Ret )
