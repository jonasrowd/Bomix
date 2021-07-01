/*
�����������������������������������������������������������������������������
���Programa  � MT110ENDC  �Autor  � VICTOR SOUSA       �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada disponibilizado para grava��o de valores  ���
���          � e campos espec�ficos na SC1. Executado durante a aprovacao ���
���          � bloqueio ou rejei��o da Solicita��o de Compras.            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM - Compras									      ���
���          � Este ponto de entrada est� sendo utilizado para incluir    ���
���          � a data de aprova��o caso seja aprovado ou remover a data   ���
���          � caso seja rejeitado o bloqueado.                           ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���25/07/19  �                  �                                         ���
�����������������������������������������������������������������������������    

*/                                          

                                    

User Function MT110END()

Local nNumSC := PARAMIXB[1]       // Numero da Solicita��o de compras 
Local nOpca := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear
dbSelectArea("SC1")     
	RECLOCK("SC1",.F.)     
	IF nOpca == 1         
		SC1->C1_DATAAP := DDATABASE   
	ELSE
		SC1->C1_DATAAP := CTOD("  /  /  ")
	ENDIF
	 MSUNLOCK()

Return() 