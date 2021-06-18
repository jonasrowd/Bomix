/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FCOMM002   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para trazer o cliente ou fornecedor do documento de ���
���          � entrada ou sa�da.										  ���
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

	If _cAlias == "SF1"
		If SF1->F1_TIPO $ 'DB'
			c_Nome := Posicione("SA1", 1, xFilial("SA1")+SF1->(F1_FORNECE+F1_LOJA), "A1_NOME")
		Else
			c_Nome := Posicione("SA2", 1, xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA), "A2_NOME")
		Endif
	Else
		If SF2->F2_TIPO $ 'DB'
			c_Nome := Posicione("SA2", 1, xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA), "A2_NOME")
		Else
			c_Nome := Posicione("SA1", 1, xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_NOME")
		Endif
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)
Return c_Nome