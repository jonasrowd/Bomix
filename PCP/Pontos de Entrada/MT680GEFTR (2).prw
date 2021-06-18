#include 'parmtype.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Ponto de entrada � MT680GEFTR �Autor  �VICTOR SOUSA	  Data 29/02/20	  ���
�������������������������������������������������������������������������͹��
���Desc.      � Estorno de Produ��o							 	  		  ���
���				� executado ap�s o estorno do movimento da produ��o, e	  ��� 
���				permite executar qualquer a��o definida pelo operador.	  ���
���				                                                          ��� 
���				                                                    	  ���
���				              											  ���
�������������������������������������������������������������������������͹��
���Observa��o � Ponto de entrada desenvolvido para                        ���
���           �                                                           ���
���           �                                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function MT680GEFTR()
	Local a_Area  := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
			RecLock("SC2",.F.)
			SC2->C2_FSSALDO:=SC2->C2_FSSALDO+SH6->H6_QTDPROD
			SC2->(MsUnlock())		
	Endif
	RestArea(a_Area)
Return Nil

