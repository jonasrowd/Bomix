#include "rwmake.ch"
#include "topconn.ch
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A020EOK   �Autor  �TESTE               � Data �  26/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na altera��o do fornecedor para compati-   ���
���          �bilizar a classe valor                                      ���
�������������������������������������������������������������������������͹��
���Uso       �AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A020EOK()
Local aAreaSA2 := SA2->(GetArea())
Local aAreaCTH := CTH->(GetArea())
DbSelectArea("CTH")
CTH->(DbSetOrder(1))
If CTH->(DbSeek(xFilial("CTH")+"F"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)))
	RecLock("CTH",.F.)	
	CTH->(DbDelete())	
	CTH->(MsUnLock())	
EndIf
RestArea(aAreaSA2)
RestArea(aAreaCTH)
Return(.T.)