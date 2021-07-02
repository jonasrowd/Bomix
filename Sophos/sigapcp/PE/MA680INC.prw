/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA680INC   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada Executado ap�s inclus�o de um apontamento ���
���          � de produ��o PCP Mod. I.									  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAPCP - Planej. Contr. Prod.							  ���
���          � Este ponto de entrada est� sendo utilizado para imprimir a ���
���          � etiqueta de encerramento de ordem de produ��o ao efetuar o ���
���          � apontamento de produ��o.									  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA680INC
	Local n_Opca := PARAMIXB[1]

	If n_Opca == 1 		//Usu�rio confirmou a grava��o    
		U_FPCPM001()    //Chama a fun��o para imprimir a etiqueta de encerramento de ordem de produ��o
	Endif
Return Nil