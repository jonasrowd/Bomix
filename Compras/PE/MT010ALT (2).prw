/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT010ALT   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para executado no final da altera��o do   ���
���          � produto. Deve ser utilizado para grava��o de campos do 	  ���
���          � usu�rio.						                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACTB - Contabilidade Gerencial                          ���
���          � Este ponto de entrada est� sendo utilizado para bloquear o ���
���          � item cont�bil quando o produto for bloqueado no cadastro   ���
���          � de produto. 		 						  				  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User Function MT010ALT
	Local a_Area := GetArea()

    dbSelectArea("CTD")
    CTD->(dbSetOrder(1))
    If dbSeek(xFilial("CTD") + SB1->B1_ITEMCC) .And. !Empty(SB1->B1_ITEMCC)
		If CTD->CTD_BLOQ == '2' .And. SB1->B1_MSBLQL == '1'
			RecLock("CTD", .F.)
			CTD->CTD_BLOQ := '1'
			MsUnlock()
		Elseif CTD->CTD_BLOQ == '1' .And. SB1->B1_MSBLQL == '2'
			RecLock("CTD", .F.)
			CTD->CTD_BLOQ := '2'
			MsUnlock()
		Endif
	Endif

	RestArea(a_Area)
Return Nil