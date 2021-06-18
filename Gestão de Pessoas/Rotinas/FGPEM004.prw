#include "totvs.ch"         


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGPEM004�Autor  �PABLO VB CARVALHO   � Data �    22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo FILIAL.		                  		  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FGPEM004()

	Local a_area	:= GetArea()
	Local l_ret 	:= .F.
	Local c_fil 	:= alltrim(M->RAFILIAL)
	Local c_mat 	:= alltrim(oMSNGD:acols[oMSNGD:nAt, n_posmat])
	Local c_nome	:= posicione("SRA", 1, c_fil + c_mat, "alltrim(RA_NOMECMP)")
	
	if empty(c_fil)
		alert("Filial n�o pode ficar em branco.")
	else
		if !FWFilExist(cempant, c_fil)
			alert("Filial inexistente.")
		else
			if !empty(c_mat)
				if empty(c_nome)
					alert("Matr�cula n�o encontrada na filial informada.")
				else
					l_ret := .T.
				endif
			else
				l_ret := .T.
			endif
		endif
	endif

	RestArea(a_area)

Return(l_ret)