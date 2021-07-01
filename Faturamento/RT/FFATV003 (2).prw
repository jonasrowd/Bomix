#INCLUDE 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FFATV003   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o para edi��o do campo Sit. Arte no item do Or�am. ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT - Faturamento									  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/* VERS�O EM PRODU��O ANTES DA ALTERA��O DA ROTINA DE ARTE
User Function FFATV003
	Local c_Alias   := Alias()
	Local c_Ord     := IndexOrd()
	Local n_Reg     := Recno()
	Local c_Produto := (c_Alias)->CK_PRODUTO
	Local l_Ret 	:= .T.

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Produto)
	If !Empty(SB1->B1_FSARTE) 				//Verifica se o produto possui arte
		If SB1->B1_FSARTE <> '99999'	    //Verifica se a arte do produto � diferente de 99999
			dbSelectArea("SZ2")
			dbGoTop()
			dbSetOrder(1)
			dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
			If SZ2->Z2_BLOQ == '1'          //Verifica se a arte do produto est� bloqueada
				l_Ret := .F.                //Desabilita a edi��o do campo de situa��o da arte
			Endif
		Endif
	Endif

	dbSelectArea(c_Alias)
	dbSetOrder(c_Ord)  
	dbGoTo(n_Reg)

Return(l_Ret)
*/

User Function FFATV003
	Local c_Alias   := Alias()
	Local c_Ord     := IndexOrd()
	Local n_Reg     := Recno()
	Local c_Produto := (c_Alias)->CK_PRODUTO
	Local l_Ret 	:= .T.
                                                       
//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return(l_Ret)
endif

////////


	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Produto)
	If !Empty(SB1->B1_FSARTE) 				//Verifica se o produto possui arte
		dbSelectArea("SZ2")
		dbGoTop()
		dbSetOrder(1)
		dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
		If SZ2->Z2_BLOQ == '1' .Or. SZ2->Z2_BLOQ == '2'         //Verifica se a arte do produto � nova ou est� bloqueada
			l_Ret := .F.                						//Desabilita a edi��o do campo de situa��o da arte
		Endif
	Endif

	dbSelectArea(c_Alias)
	dbSetOrder(c_Ord)  
	dbGoTo(n_Reg)

Return(l_Ret)