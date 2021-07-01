/*
�����������������������������������������������������������������������������
���Programa  � MT160GRPC  �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada disponibilizado para grava��o de valores  ���
���          � e campos espec�ficos na SC7. Executado durante a gera��o   ���
���          � do pedido de compra na an�lise da cota��o.                 ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM - Compras									      ���
���          � Este ponto de entrada est� sendo utilizado para copiar a   ���
���          � marca do produto da cota��o para o pedido de compra.       ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�����������������������������������������������������������������������������
*/

User Function MT160GRPC
	SC7->C7_FSMARCA := SC8->C8_FSMARCA
Return Nil