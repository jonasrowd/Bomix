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


User Function MT416FIM
	
    Local nAtrasados := u_FFATVATR(M->C5_CLIENTE, M->C5_LOJACLI) 
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return 
		endif
	If nAtrasados != 0
		M->C5_BXSTATU := 'B'
		M->C5_BLQ := 'B'
        M->C5_LIBEROK = 'S'
        MsGInfo("Existem restri��es financeiras para este Cliente. Por favor solicitar Libera��o", "Aten��o!")
	Else
        SC5->C5_BXSTATU := 'L'
        SC5->C5_BLQ := ''
        SC5->C5_LIBEROK = 'L'
	EndIf

Return

