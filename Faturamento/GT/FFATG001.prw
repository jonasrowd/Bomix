/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FFATG001   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para trazer nome reduzido do cliente ou fornecedor ���
���          � do pedido de venda no campo C5_FSNREDU.					  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FFATG001
	c_NomeRedu := ''
	_cAlias    := Alias()
	_cOrd      := IndexOrd()
	_nReg      := Recno()          
	
	
	//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return(c_NomeRedu)
endif

////////
	
	
	

//	If INCLUI  .And. 

    If Type('M->C5_TIPO') <> 'U'
  
				If M->C5_TIPO $ 'NCIP'
			c_NomeRedu := Posicione("SA1", 1, xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI), "A1_NREDUZ")
		Else
			c_NomeRedu := Posicione("SA2", 1, xFilial("SA2")+M->(C5_CLIENTE+C5_LOJACLI), "A2_NREDUZ")
		Endif	
	Else
		If SC5->C5_TIPO $ 'NCIP'
			c_NomeRedu := Posicione("SA1", 1, xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI), "A1_NREDUZ")
		Else
			c_NomeRedu := Posicione("SA2", 1, xFilial("SA2")+SC5->(C5_CLIENTE+C5_LOJACLI), "A2_NREDUZ")
		Endif
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)
Return c_NomeRedu