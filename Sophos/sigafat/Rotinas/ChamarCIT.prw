#INCLUDE 'TOTVS.CH'

/*
�����������������������������������������������������������������������������
���Programa  �CALLCIT  �Autor  � BRITO			       � Data � DEZ/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa o programa externo da CIT.						  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT - Faturamento                                      ���
�����������������������������������������������������������������������������
*/
            
User Function CALLCIT	
   winexec("\\servidor01\Bomix_Sql\Bomix\Cit.exe")
Return