
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DV080QTD  �Autor  �Francisco Rezende   � Data �  01/16/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada DV080QTD na validacao da quantidade digita ���
���          �da no cross docking                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

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