/*
���          � alterar campos espec�ficos do Cadastro de Produtos		  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM - Compras										  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
VALIDAR ACESSO A ROTINA DE ELIMINACAO DE RESIDUO
*/             

User Function MTA500PROC
	Local a_Area  := GetArea()
	Local l_Ret   := .F.
	Local c_Users := Getmv("BM_ALTPROD")

	If INCLUI
		l_Ret := .T.
	Else
		If __CUSERID # c_Users
			l_Ret := .T.
		Else
	  		ShowHelpDlg(SM0->M0_NOME,;
		  		{"O seu usu�rio n�o possui permiss�o executar essa rotina."},5,;
			  	{"Contacte o administrador do sistema."},5)
		Endif
	Endif

	RestArea(a_Area)
Return l_Ret