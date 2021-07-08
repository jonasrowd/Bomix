/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FCOMV001   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para validar os usu�rios que possuem permiss�o para ���
���          � alterar campos espec�ficos do Cadastro de Produtos		  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM - Compras										  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
VALIDA��O ALTERACAO DA NCM DO PRODUTO.
*/

User Function FCOMV001
	Local a_Area  := GetArea()
	Local l_Ret   := .F.
	Local c_Users := Getmv("BM_ALTPROD")

	If INCLUI
		l_Ret := .T.
	Else
		If __CUSERID $ c_Users
			l_Ret := .T.
		Else
	  		ShowHelpDlg(SM0->M0_NOME,;
		  		{"O seu usu�rio n�o possui permiss�o para alterar este campo."},5,;
			  	{"Contacte o administrador do sistema. Par�metro: BM_ALTPROD"},5)
		Endif
	Endif

	RestArea(a_Area)
Return l_Ret