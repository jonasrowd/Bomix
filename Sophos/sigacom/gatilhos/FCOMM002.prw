/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FCOMM002   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para trazer o cliente ou fornecedor do documento de ���
���          � entrada no campo F1_FSNOME.								  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGACOM - Compras				  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FCOMM002
	c_Nome	:= ''
	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	If SF1->F1_TIPO $ 'DB'
		c_Nome := Posicione("SA1", 1, xFilial("SA1")+SF1->(F1_FORNECE+F1_LOJA), "A1_NOME")
	Else
		c_Nome := Posicione("SA2", 1, xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA), "A2_NOME")
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)
Return c_Nome