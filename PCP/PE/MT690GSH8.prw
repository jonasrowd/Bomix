/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT690GSH8  �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para gravar os dados da Carga M�quina nos ���
���          � campos customizados da Ordem de Produ��o					  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAPCP													  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������          

*/

User Function MT690GSH8
	Local a_Area    := GetArea()
	Local a_AreaSC2 := SC2->(GetArea())

	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	If SC2->(dbSeek(xFilial("SC2") + TRB->(OPNUM + ITEM + SEQUEN + ITEMGRD)))
		RecLock("SC2")
		SC2->C2_FSDTAJI := SH8->H8_DTINI
		SC2->C2_FSHRAJI := SH8->H8_HRINI
		SC2->C2_FSDTAJF := SH8->H8_DTFIM
		SC2->C2_FSHRAJF := SH8->H8_HRFIM
		MsUnlock()
	EndIf

	RestArea(a_AreaSC2)
	RestArea(a_Area)
Return Nil
