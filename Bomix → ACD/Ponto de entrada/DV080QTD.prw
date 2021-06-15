
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDV080QTD  บAutor  ณFrancisco Rezende   บ Data ณ  01/16/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada DV080QTD na validacao da quantidade digita บฑฑ
ฑฑบ          ณda no cross docking                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DV080QTD()

Local l_Ret			:= .T.
Local c_Local		:= ParamIxb[1]	//Armaz้m destino
Local c_EstFis		:= ParamIxb[2]	//Estrutura fํsica destino
Local c_Endereco	:= ParamIxb[3]	//Endere็o destino
Local c_Produto		:= ParamIxb[4]	//C๓digo do produto
Local c_Lote		:= ParamIxb[5]	//Lote do produto
Local c_SubLote		:= ParamIxb[6]	//Sublote do produto
Local n_QtdNorma	:= ParamIxb[7]	//Quantidade de produtos definido na norma de unitiza็ใo
Local n_Quant		:= ParamIxb[8]	//Quantidade do produto (solicitada pelo sistema)
Local n_QtdInf		:= ParamIxb[9]	//Quantidade do produto (informada pelo usuแrio)

l_Ret	:= U_FACDA007( c_Local, c_EstFis, c_Endereco, c_Produto, c_Lote, c_SubLote, n_QtdNorma, n_Quant, n_QtdInf )

Return( l_Ret )