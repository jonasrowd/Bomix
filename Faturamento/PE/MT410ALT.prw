#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"                                                       

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410ALT  � Autor � Christian Rocha    � Data �Novembro/2012���
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

User Function MT410ALT  

		For i:=1 To Len(aCols)
			If aCols[i][Len(aHeader) + 1] == .F.
				c_Produto := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
				c_Item := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_ITEM' })]
				c_OP := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_NUMOP' })]
				c_SitArte := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]
				dbSelectArea("SC2")
				dbGoTop()
				dbSetOrder(9)
				If dbSeek(xFilial("SC2")+c_OP+c_Item+c_Produto) 
					IF(SC2->C2_QUJE = 0 .OR. SC2->C2_QUJE < SC2->C2_QUANT) .AND. EMPTY(SC2->C2_DATRF) .AND. (!EMPTY(SC2->C2_DATAPCP) .OR. SC2->C2_PRIOR<"500")
					EndIf
				Endif
			Endif
		Next i
	
Return Nil


