/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++ Programa  MT150ROT  Autor  ANILSON lIMA    Data  JULHO/2011           +++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++ Desc.     Ponto de Entrada para criacao de nova rotina no browse de   +++
+++           Atualiza Cotacoes                                           +++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/   

User Function MT150ROT()

Local a_Area	:= GetArea()
Local a_Rotina	:= ParamIxb

AADD(a_Rotina,{"Envia Email",'U_COM_RT03()',0,5,0,.F.})
AADD(a_Rotina,{"Cancela Produto",'U_TCOMA002()',0,6,0,.F.})
RestArea(a_Area)

Return(a_Rotina)