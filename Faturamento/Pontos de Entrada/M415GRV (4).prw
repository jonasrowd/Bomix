/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M415GRV   � Autor � Christian Rocha    � Data �Novembro/2012���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada acionado ap�s a grava��o das informa��es  ���
���          � do Or�amento em todas as op��es (inclus�o, altera��o e 	  ���
���          � exclus�o). O PARAMIXB estar� com o n�mero da op��o (1, 2   ���
���          � ou 3).													  ���	
�������������������������������������������������������������������������͹��
���Uso       � Bloqueia a arte caso o Or�amento defina o bloqueio da arte.���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M415GRV  



	private a_Area := GetArea()


//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return
endif

////////





	If PARAMIXB[1] == 1
		dbSelectARea("TMP1")
		dbGoTop()
		While TMP1->(!Eof())
			If TMP1->CK_FLAG == .F.
				c_Produto := TMP1->CK_PRODUTO
			    c_SitArte := TMP1->CK_FSTPITE
			    
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
									SZ2->Z2_BLOQ   := '2'		//Bloqueia a arte do produto
									SZ2->Z2_DATA   := DDATABASE
									SZ2->Z2_RESP   := Upper(UsrRetName(__CUSERID))
									SZ2->Z2_OBSERV := IIF(!Empty(SZ2->Z2_OBSERV), SZ2->Z2_OBSERV + chr(13) + chr(10) + chr(13) + chr(10),'') + ;
													  "Or�amento: " + AllTrim(SCJ->CJ_NUM) + ", Data: " +Dtoc(DDATABASE) + ", Hora: " + Time() + ;
													  ", Respons�vel: " + Upper(UsrRetName(__CUSERID))
									MsUnlock()
									
									U_FALTSZ2()
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
			
			TMP1->(dbSkip())
		End
	Endif
	
	RestArea(a_Area)
Return
