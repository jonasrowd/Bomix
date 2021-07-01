#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA650TOK   �Autor  � Victor Sousa       � 16/03/2020       ���
�������������������������������������������������������������������������͹��
���Desc.     � Permite executar a valida��o do usu�rio ao confirmar a OP. ���
���          �                                         					  ���
���          � Rotina para preencher o numero do pedido e item do pedido, ���
���          � quando o usuario lan�a uma OP manual. Caso n�o existe um   ���
���          � pedido relacionado com o n�mero e item lan�ado, o usu�rio  ���
���          � ser� alertado da inexist�ncia do pedido podendo o mesmo    ���
���          � fazer a corre��o caso seja a situa��o.                     ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MA650TOK
	Local lRet := .T.

	//lRet=U_FPCPG005()
	M->C2_FSSALDO:=M->C2_QUANT

Return lRet	



user function FPCPG005()
	Local c_pedido
	Local c_itemped
	Local lRet:=.T.

	c_pedido:="0"+SUBST(M->C2_NUM,2,5)
	c_itemped:=M->C2_ITEM

	If cFilAnt == "010101"

		dbSelectArea("SC6")
		dbGoTop()
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+c_pedido+c_itemped+M->C2_PRODUTO)
		If !EOF()
			M->C2_PEDIDO:=SC6->C6_NUM
			M->C2_ITEMPV:=SC6->C6_ITEM
			M->C2_QUANT:=SC6->C6_QTDVEN
			RecLock("SC6", .F.)
			SC6->C6_NUMOP :=   M->C2_NUM+M->C2_ITEM+M->C2_SEQUEN     
			SC6->C6_ITEMOP := M->C2_ITEM
			MsUnlock()
		Else

			If MsgBox("N�o existe um pedido de venda que relacione com esta OP. Confirma?", "Pedido Inexistente", "YESNO")
				M->C2_PEDIDO:=""
				M->C2_ITEMPV:=""
				lRet:= .T.
			Else

				M->C2_NUM:="      	"
				//	M->C2_ITEM:=""	
				M->C2_PEDIDO:=""
				M->C2_ITEMPV:=""
				//M->C2_PRODUTO:=""
				M->C2_QUANT:=0
				lRet:= .F.		

			Endif		
		Endif
	Endif
return lRet

