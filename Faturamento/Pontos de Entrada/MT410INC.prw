/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410INC  � Autor � Christian Rocha    � Data �Novembro/2012���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada acionado ap�s a grava��o das informa��es  ���
���          � do pedido de venda.                                        ���
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

User Function MT410INC  

	//testa filial atual

	private cfil :="      "
	cFil := FWCodFil()
	if cFil = "030101"
		Return Nil
	endif

	////////

	
	If INCLUI
		For i:=1 To Len(aCols)
			If aCols[i][Len(aHeader) + 1] == .F.
				c_Produto := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
				c_SitArte := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]

				If c_SitArte == '1'  					//Se a arte for bloqueada
					dbSelectArea("SB1")
					dbGoTop()
					dbSetOrder(1)
					If dbSeek(xFilial("SB1")+c_Produto)
						If SB1->B1_FSFARTE == '1'		//Verifica se o flag de arte do produto est� marcado com sim
							dbSelectArea("SZ2")
							dbGoTop()
							dbSetOrder(1)
							If dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
								If SZ2->Z2_BLOQ != '2'
									RecLock("SZ2", .F.)
									SZ2->Z2_BLOQ := '2'		//Bloqueia a arte do produto
									SZ2->Z2_DATA   := DDATABASE
									SZ2->Z2_RESP   := Upper(UsrRetName(__CUSERID))
									SZ2->Z2_OBSERV := IIF(!Empty(SZ2->Z2_OBSERV), SZ2->Z2_OBSERV + chr(13) + chr(10) + chr(13) + chr(10),'') + ;
									"Pedido de Venda: " + AllTrim(SC5->C5_NUM) + ", Data: " +Dtoc(DDATABASE) + ", Hora: " + Time() + ;
									", Respons�vel: " + Upper(UsrRetName(__CUSERID))
									MsUnlock()

									U_FALTSZ2()
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
		Next i
	Endif
Return Nil




