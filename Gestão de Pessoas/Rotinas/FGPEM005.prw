#include "totvs.ch"  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGPEM005�Autor  �PABLO VB CARVALHO   � Data �    22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo MATR�CULA.	                  		  ���
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

User Function FGPEM005()

	Local a_area	:= GetArea()
	Local l_ret 	:= .F.
	Local c_fil		:= oMSNGD:acols[oMSNGD:nAt, n_posfil]
	Local c_mat 	:= alltrim(M->RAMAT)	
	Local c_nome	:= posicione("SRA", 1, c_fil + c_mat, "alltrim(RA_NOMECMP)")
	
	if empty(c_fil)
		alert("Para validar a matr�cula, a filial n�o pode ficar em branco.")
	else
		if empty(c_mat)
			alert("Matr�cula n�o pode ficar em branco.")
		else
			if empty(c_nome)
				alert("Matr�cula n�o encontrada na filial informada.")
			else
				oMSNGD:acols[oMSNGD:nAt, n_posnome] := c_nome
				l_ret := .T.
			endif
		endif
	endif

	RestArea(a_area)

Return(l_ret)