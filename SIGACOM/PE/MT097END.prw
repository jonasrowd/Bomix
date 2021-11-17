#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097END  �Autor  �FRANCISCO REZENDE   � Data �  16/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na liberacao da alcada do pedido de compra���
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
User Function MT097END()

Local a_Area	:= GetArea()
Local c_Pedido	:= PARAMIXB[1] //
Local n_Opcao   := PARAMIXB[3] //Opcao clicada na tela de Liberacao: L = BOTAO LIBERACAO
Local l_Ret 	:= Findfunction("U_PCOMA010")

If l_Ret
	U_PCOMA010(c_Pedido, n_Opcao) //CHAMA A ROTINA QUE ENVIA O EMAIL PARA O SOLICITANTE E O FORNECEDOR QUANDO O PEDIDO FOR LIBERADO  
Endif

//OBS: ESTE FONTE S� ENVIAR� O EMAIL QUANDO O PEDIDO ESTIVER LIBERADO C7_CONAPRO = L
 
RestArea(a_Area)

Return()       