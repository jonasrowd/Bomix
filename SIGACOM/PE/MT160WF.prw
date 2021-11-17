#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT160WF   �Autor  �FRANCISCO REZENDE   � Data �  16/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na analise da cotacao.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT160WF()

Local a_SC1Area	:= SC1->(GetArea())
Local a_SC7Area	:= SC7->(GetArea())
Local a_SC8Area	:= SC8->(GetArea())
Local c_NumCot	:= SC8->C8_NUM
Local c_Pedido	:= SC8->C8_NUMPED
Local l_Ret 	:= Findfunction("U_PCOMA009") .And. Findfunction("U_PCOMA031")

If l_Ret .And. !Empty(c_NumCot)
	//Diligenciamento
	U_PCOMA009(c_NumCot, c_Pedido) //CHAMA A FUNCAO PARA ENVIAR O EMAIL PARA O SOLICITANTE
	U_PCOMA031(c_Pedido) //CHAMA A FUNCAO PARA ENVIAR O EMAIL PARA OS APROVADORES DO PRIMEIRO NIVEL
Endif

l_Ret 	:= Findfunction("U_FCOMA004")
If l_Ret .And. !Empty(c_NumCot)
	//Integra��o Fluig
	//U_FCOMA004( c_NumCot )
Endif

RestArea(a_SC1Area)
RestArea(a_SC7Area)
RestArea(a_SC8Area)

Return()