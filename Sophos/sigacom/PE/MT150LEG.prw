
/*
�����������������������������������������������������������������������������
���Programa  �MT150LEG  �Autor  �TIAGO PITA   	       � Data �AGOSTO/2011���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para inclus�o de observa��o no momento da  ���
���          �exclusao de um item da cota��o                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�����������������������������������������������������������������������������
*/

User Function MT150LEG

Local nNum := PARAMIXB[1]
Local aRet := {}

/*If nNum == 1
	aAdd(aRet,{ 'ALLTRIM(C8_TBMOT) <>""' , 'BR_PRETO' })
ElseIf nNum == 2
	aAdd(aRet,{'BR_PRETO' , 'Cancelado' })
EndIf*/

Return aRet