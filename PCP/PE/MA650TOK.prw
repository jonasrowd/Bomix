#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA650TOK   ºAutor  ³ Victor Sousa       º 16/03/2020       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite executar a validação do usuário ao confirmar a OP. º±±
±±º          ³                                         					  º±±
±±º          ³ Rotina para preencher o numero do pedido e item do pedido, º±±
±±º          ³ quando o usuario lança uma OP manual. Caso não existe um   º±±
±±º          ³ pedido relacionado com o número e item lançado, o usuário  º±±
±±º          ³ será alertado da inexistência do pedido podendo o mesmo    º±±
±±º          ³ fazer a correção caso seja a situação.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

			If MsgBox("Não existe um pedido de venda que relacione com esta OP. Confirma?", "Pedido Inexistente", "YESNO")
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

