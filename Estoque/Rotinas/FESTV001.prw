/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FESTV001  � Autor � Christian Rocha    � Data �Novembro/2012���
�������������������������������������������������������������������������͹��
���Descricao � Rotina do Inicializador de Browse do campo C2_FSSTATU.	  ���
�������������������������������������������������������������������������͹��
���Uso       � Utilizado para exibir o Status da Arte na Ordem de Produ��o���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FESTV001
	Local c_Status := ''
	Local a_Area   := GetArea()

	If INCLUI .And. Type("M->C2_PRODUTO") <> "U"
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + M->C2_PRODUTO)
			If !Empty(SB1->B1_FSARTE)
				dbSelectArea("SZ2")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ2") + SB1->B1_FSARTE)
					If SZ2->Z2_BLOQ == '1'
				 		c_Status := 'ARTE NOVA'
					Elseif SZ2->Z2_BLOQ == '2'
				 		c_Status := 'BLOQUEADA'
					Elseif SZ2->Z2_BLOQ == '3'
				 		c_Status := 'FOTOLITO A DESENVOLVER'
					Else
				 		c_Status := 'PRONTA PARA IMPRESS�O'
				 	Endif			 					 					 		
				Endif
			Endif
		Endif
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + SC2->C2_PRODUTO)
			If !Empty(SB1->B1_FSARTE)
				dbSelectArea("SZ2")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ2") + SB1->B1_FSARTE)
					If SZ2->Z2_BLOQ == '1'
				 		c_Status := 'ARTE NOVA'
					Elseif SZ2->Z2_BLOQ == '2'
				 		c_Status := 'BLOQUEADA'
					Elseif SZ2->Z2_BLOQ == '3'
				 		c_Status := 'FOTOLITO A DESENVOLVER'
					Else
				 		c_Status := 'PRONTA PARA IMPRESS�O'
				 	Endif			 					 					 		
				Endif
			Endif
		Endif
	Endif

	RestArea(a_Area)
Return c_Status