#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M020INC   �Autor  �		             � Data �  02/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na inclus�o do fornecedor para compati-    ���
���          �bilizar a classe valor                                      ���
�������������������������������������������������������������������������͹��
���Uso       �AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M020INC

Local aArea := GetArea()

If INCLUI
	If SA2->A2_EST == "EX"
		RecLock("SA2", .F.)
		SA2->A2_CGC  := ""
		SA2->A2_TIPO := "X"
		MsUnlock()
	Endif

	DbSelectArea("CTH")
	CTH->(DbSetOrder(1))
	If !(CTH->(DbSeek(xFilial("CTH")+"F"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA))))
		RecLock("CTH",.T.)
		CTH->CTH_FILIAL	:= xFilial("CTH")
		CTH->CTH_CLVL	:= "F"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)
		CTH->CTH_CLASSE	:= "2"
		CTH->CTH_DESC01	:= SA2->A2_NOME
		CTH->CTH_BLOQ	:= SA2->A2_MSBLQL
		CTH->CTH_NORMAL := "1"
		CTH->CTH_DTEXIS := CTOD("01/01/80")
		CTH->CTH_CLVLLP := "F"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)
		CTH->CTH_YCGC   := SA2->A2_CGC   // - CASO O CLIENTE QUEIRA COLOCAR UM FILTRO NA CLASSE DE VALOR POR CNPJ
		CTH->CTH_YCLIFO := "F"           // - PARA TRATAR CONSULTA PADR�O NO CT2 (CLASSE D�BITO)
		CTH->(MsUnLock())
	Else
		RecLock("CTH",.F.)
		CTH->CTH_FILIAL	:= xFilial("CTH")
		CTH->CTH_CLVL	:= "F"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)
		CTH->CTH_CLASSE	:= "2"
		CTH->CTH_DESC01	:= SA2->A2_NOME
		CTH->CTH_BLOQ	:= SA2->A2_MSBLQL
		CTH->CTH_NORMAL := "1"
		CTH->CTH_DTEXIS := CTOD("01/01/80")
		CTH->CTH_CLVLLP := "F"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA)
		CTH->CTH_YCGC   := SA2->A2_CGC   //- CASO O CLIENTE QUEIRA COLOCAR UM FILTRO NA CLASSE DE VALOR POR CNPJ
		CTH->CTH_YCLIFO := "F"          //- PARA TRATAR CONSULTA PADR�O NO CT2 (CLASSE D�BITO)
		CTH->(MsUnLock())
	EndIF
EndIf
RestArea(aArea)

Return(.T.)   
