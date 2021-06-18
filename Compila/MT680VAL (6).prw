#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT680VAL   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar os dados da Produ��o PCP Mod2���
���          �    														  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAPCP													  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT680VAL
	Local a_Area    := GetArea()
	Local a_AreaSB1 := SB1->(GetArea())
	Local a_AreaSB2 := SB2->(GetArea())
	Local a_AreaSC2 := SC2->(GetArea())
	Local a_AreaSD4 := SD4->(GetArea())
	Local a_AreaSG1 := SG1->(GetArea())
	Local l_Ret     := .T.


	If l_Ret .And. l681
		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7") + __CUSERID + M->H6_LOCAL)
			If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
				l_Ret := .T.
			Else
				ShowHelpDlg(SM0->M0_NOME,;
				{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + M->H6_LOCAL + "."},5,;
				{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME,;
			{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + M->H6_LOCAL + "."},5,;
			{"Contacte o administrador do sistema."},5)
			l_Ret := .F.
		Endif

		If (M->H6_QTDPERDA > 0) .And. lSavePerda == .F.
			ShowHelpDlg(SM0->M0_NOME,;
			{"N�o foi realizada a Classifica��o da Perda da Produ��o PCP Mod2"},5,;
			{"Efetue a Classifica��o da Perda antes de prosseguir"},5)
			l_Ret := .F.
		Endif
	Endif      

	RestArea(a_AreaSB1)
	RestArea(a_AreaSB2)
	RestArea(a_AreaSC2)
	RestArea(a_AreaSD4)
	RestArea(a_AreaSG1)
	RestArea(a_Area)
Return l_Ret



