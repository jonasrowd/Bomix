#INCLUDE "APVT100.CH"
#INCLUDE "PROTHEUS.CH" 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBINVVAL  �Autor  �Francisco Rezende   � Data �  01/16/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �� executado dentro da valida��o da etiqueta de produtos,    ���
���          �retornando um valor l�gico .T. para continuar a valida��o   ���
���          �padr�o ou .F. para abortar a valida��oPonto                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CBINVVAL()    

	Local l_Ret     := .F.
	
	While l_Ret == .F.	
	   l_Ret := U_FACDA004( cProduto, cArmazem, cEndereco,,, cLote,,, nQtdEtiq )
	End		

Return( l_Ret )