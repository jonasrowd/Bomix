/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MTA650OK      � Autor � AP6 IDE            � Data �  23/10/19���
�������������������������������������������������������������������������͹��
���Descricao �                                                            ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA650OK( )
	Local l_Ret    := .T.
	Local a_Area   := GetArea()

	IF SC2->C2_SEQUEN # ("001","002")
		RECLOCK("SC2",.F.)
		dbSelectArea("SC2")
		SC2->C2_FSSALDO:=SC2->C2_QUANT
		MSUNLOCK()
	ENDIF

	RestArea(a_Area)
Return l_Ret