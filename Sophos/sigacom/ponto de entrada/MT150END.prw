#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"  
#INCLUDE "PRTOPDEF.CH"

/*
�����������������������������������������������������������������������������
���Programa  �MT150OK  �Autor  �TIAGO PITA   	       � Data �AGOSTO/2011���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para inclus�o de observa��o no momento da  ���
���          �exclusao de um item da cota��o                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�����������������������������������������������������������������������������
*/

//User Function MT150END()

//Local nOpcx := Paramixb[1]
//Local lRet  := .T.

/*If nOpcx=3
	For i:=1 to Len(aCols)
		If aCols[i][Len(aHeader)+1] == .F. .AND. !Empty(aCols[i][1])
			If aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == "C8_PRECO"})]>0
				_qry := " UPDATE SC8010 SET C8_TBMOT =  '', C8_TBDATA='' WHERE C8_NUM = '" + SC8->C8_NUM+ "' AND D_E_L_E_T_ <> '*' AND C8_PRODUTO='"+SC8->C8_PRODUTO+"' "
				TCSQLExec(_qry)
			Endif
		Endif
	Next
Endif */

//Return lRet