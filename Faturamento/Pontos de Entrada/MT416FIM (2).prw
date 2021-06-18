#Include "protheus.ch"
#Include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT416FIM  � Autor � Christian Rocha    � Data �Novembro/2012���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada acionado ap�s o termino da efetiva��o do  ���
���          � Or�amento de Venda.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Bloqueia a arte caso o PV defina a situa��o da arte como   ���
���          � nova ou alterada.                                          ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/* VERS�O EM PRODU��O ANTES DA ALTERA��O DA ROTINA DE ARTE
User Function MT416FIM

	For i:=1 To Len(aCols)
		c_Produto := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
	    c_SitArte := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]

	    If c_SitArte == '1' .Or. c_SitArte == '2'  //Se situa��o da arte for nova ou alterada
			dbSelectArea("SB1")
			dbGoTop()
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+c_Produto)
				If SB1->B1_FSFARTE == '1'		//Verifica se o flag de arte do produto est� marcado com sim
					dbSelectArea("SZ2")
					dbGoTop()
					dbSetOrder(1)
					If dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
						RecLock("SZ2", .F.)
						SZ2->Z2_BLOQ := '1'		//Bloqueia a arte do produto
						MsUnlock()
					Endif
				Endif
			Endif
		Endif
	Next i
Return
*/

User Function MT416FIM
/*
	For i:=1 To Len(aCols)
		If aCols[i][Len(aHeader) + 1] == .F.
			c_Produto := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
		    c_SitArte := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]
	
		    If c_SitArte == '1'  //Se a arte for bloqueada
				dbSelectArea("SB1")
				dbGoTop()
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+c_Produto)
					If SB1->B1_FSFARTE == '1'		//Verifica se o flag de arte do produto est� marcado com sim
						dbSelectArea("SZ2")
						dbGoTop()
						dbSetOrder(1)
						If dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
							RecLock("SZ2", .F.)
							SZ2->Z2_BLOQ := '2'		//Bloqueia a arte do produto
							SZ2->Z2_DATA := DDATABASE
							SZ2->Z2_RESP := UsrRetName(__CUSERID)
							MsUnlock()
							
							U_FALTSZ2()
						Endif
					Endif
				Endif
			Endif
		Endif
	Next i
*/
Return