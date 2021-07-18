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
	Local nAtrasados := 0
	private cfil :="      "
	cFil := FWCodFil()
	if cFil = "030101"
		return
	endif

	If PARAMIXB[1] == 1 .OR. PARAMIXB[1] == 2

		nAtrasados := u_FFATVATR(SCJ->CJ_CLIENTE, SCJ->CJ_LOJA)

		RecLock("SCJ",.F.)
		If nAtrasados != 0
			SCJ->CJ_BXSTATU := 'B'
		Else
			SCJ->CJ_BXSTATU := 'L'
		EndIf

		SCJ->(MsUnlock())

	EndIF

	If SCJ->CJ_BXSTATU = 'B'
		MsgStop("Tratar as pend�ncias financeiras deste cliente.", "Aten��o!")
	EndIf
Return
