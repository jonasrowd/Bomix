#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M110STTS     �Autor  �DIEGO ARGOLO     � Data �  22/07/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no momento da gravacao da Solicitacao de  ���
���          �Compras                                                     ���
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

User Function M110STTS()
	
Local a_SC1Area	:= SC1->(GetArea())
LOcal c_NumSC	:= ParamIxb[1] 
Local l_Ret 	:= Findfunction("U_PCOMA030")
If (INCLUI) .OR. (ALTERA) // SE FOR INCLUSAO OU ALTERACAO
	If l_Ret 
		U_PCOMA030(c_NumSC) //CHAMA O FONTE PARA ENVIAR O EMAIL PARA OS COMPRADORES.
	Endif
EndIf

RestArea(a_SC1Area)
	
Return()