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

	private cfil :="      "
	cFil := FWCodFil()
	if cFil = "030101"
		return
	endif

	If PARAMIXB[1] == 1 .OR. PARAMIXB[1] == 2

		If Select("E1TEMP") > 0
			E1TEMP->(dbCloseArea())
		Endif

		BeginSql alias 'E1TEMP'
        column E1_EMISSAO as Date
        column E1_VENCREA  as Date

        SELECT 

        sum(E1_VALOR) VALOR

        FROM %table:SE1% SE1

        WHERE 
        E1_SALDO > 0 AND 
        E1_CLIENTE = %exp:SCJ->CJ_CLIENTE% AND
        E1_LOJA = %exp:SCJ->CJ_LOJA% AND
        SE1.%notDel% AND
        E1_TIPO = 'NF' AND 
        E1_VENCREA < %exp:DtoS(dDataBase)% AND 
        E1_BAIXA = ''
        
		EndSql

		RecLock("SCJ",.F.)
		If E1TEMP->(VALOR) != 0
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
