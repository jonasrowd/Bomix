#INCLUDE "TOPCONN.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"                                                       


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT650OPPV  �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada gera��o de Ordens de Produ��o a partir de ���
���          � pedidos selecionados, logo ap�s o t�rmino da gera��o de OPs���
���          � por Venda (fora da transa��o).                             ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
���          � Este ponto de entrada est� sendo utilizado para alterar o  ���
���          � tipo das Ordens de Produ��o geradas associadas a um Pedido ���
���          � de Venda quando o produto possui arte e a situa��o da arte ���
���          � no item do PV � nova ou alterada. 						  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT650OPPV()
	Local a_OPsPV   := PARAMIXB[2]			//Array com as ordens de produ��o, itens e sequencia geradas
	Local c_C6Arte  := ''					//Situa��o da arte do produto no pedido de venda
	Local a_Area    := GetArea()
	Local a_AreaSC2 := SC2->(GetArea())
	Local i

	For i:=1 To Len(a_OPsPV)
		dbSelectArea("SC2")
		//SC2->(dbGoTop())
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial("SC2") + a_OPsPV[i][1] + a_OPsPV[i][2]))
			c_Pedido := SC2->C2_PEDIDO
			If !Empty(c_Pedido)				//Se OP estiver associada a um pedido de venda
				c_Produto := SC2->C2_PRODUTO
				c_Cliente := Posicione("SC5", 1, xFilial("SC5") + c_Pedido, "C5_CLIENTE")
				c_Loja    := Posicione("SC5", 1, xFilial("SC5") + c_Pedido, "C5_LOJACLI")

				dbSelectArea("SA7")			
				//SA7->(dbGoTop())
				SA7->(dbSetOrder(2))
				If SA7->(dbSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja))			//Verifica se existe amarra��o Produto x Cliente
					If SA7->A7_FSQTDPE > 0  		//Se for maior que zero o valor do campo de Qtd p/ Emb.
						RecLock("SC2", .F.)
						SC2->C2_FSQTDPE := SA7->A7_FSQTDPE     						//Altera o valor do campo Qtd p/ Emb. da OP
						MsUnlock()
					Else
						dbSelectArea("SB5")				//Se n�o existe amarra��o Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
						//SB5->(dbGoTop())
						SB5->(dbSetOrder(1))
						If SB5->(dbSeek(xFilial("SB5") + c_Produto))
							If SB5->B5_QE1 > 0                        //Se for maior que zero o valor do campo Qtd Embalag1
								RecLock("SC2", .F.)
								SC2->C2_FSQTDPE := SB5->B5_QE1        //Altera o valor do campo Qtd p/ Emb. da OP
								MsUnlock()
							Endif
						Endif
					Endif
				Else
					dbSelectArea("SB5")				//Se n�o existe amarra��o Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
					//SB5->(dbGoTop())
					SB5->(dbSetOrder(1))
					If SB5->(dbSeek(xFilial("SB5") + c_Produto))
						If SB5->B5_QE1 > 0                        //Se for maior que zero o valor do campo Qtd Embalag1
							RecLock("SC2", .F.)
							SC2->C2_FSQTDPE := SB5->B5_QE1        //Altera o valor do campo Qtd p/ Emb. da OP
							MsUnlock()
						Endif
					Endif
				Endif
			Endif

			While SC2->(!Eof()) .And. SC2->C2_NUM == a_OPsPV[i][1] .And. SC2->C2_ITEM == a_OPsPV[i][2]
				c_OP   := SC2->C2_NUM
				c_Item := SC2->C2_ITEM
				c_Arte := Posicione("SB1", 1, xFilial("SB1") + SC2->C2_PRODUTO, "B1_FSARTE")

				If !Empty(c_Arte)							//Se no cadastro do produto o campo B1_FSARTE for diferente de vazio
					c_C6Arte := f_SitArte() 				//Chama a fun��o para trazer a situa��o da arte no item do pedido de venda

					If c_C6Arte == '1'						//Se situa��o da arte no item do pedido de venda for bloqueada
						//Trecho que altera o tipo da ordem de produ��o do PA e dos PIs para prevista e define que a OP � de arte
						While SC2->(!Eof()) .And. SC2->C2_NUM == c_OP .And. SC2->C2_ITEM == c_Item
							RecLock("SC2", .F.)
							SC2->C2_TPOP   := 'P'
							SC2->C2_FSARTE := '1'
							MsUnlock()
							SC2->(dbSkip())
						End
					Else
						//Trecho que altera o tipo da ordem de produ��o do PA para prevista e dos PIs para firme e define que a OP � de arte
						c_BlqArte := Posicione("SZ2", 1, xFilial("SZ2") + c_Arte, "Z2_BLOQ")

						If (c_BlqArte == '1') .Or. (c_BlqArte == '2') //Arte Nova ou Bloqueada
							//Trecho que altera o tipo da ordem de produ��o do PA e dos PIs para prevista e define que a OP � de arte
							While SC2->(!Eof()) .And. SC2->C2_NUM == c_OP .And. SC2->C2_ITEM == c_Item
								RecLock("SC2", .F.)
								SC2->C2_TPOP   := 'P'
								SC2->C2_FSARTE := '1'
								MsUnlock()
								SC2->(dbSkip())
							End
						Elseif (c_BlqArte == '3')	//Fotolito em desenvolvimento
							While SC2->(!Eof()) .And. SC2->C2_NUM == c_OP .And. SC2->C2_ITEM == c_Item
								RecLock("SC2", .F.)
								If SC2->C2_SEQUEN == '001'
									SC2->C2_TPOP   := 'P'
								Endif
								SC2->C2_FSARTE := '1'
								MsUnlock()

								SC2->(dbSkip())
							End
						Else
							SC2->(dbSkip())						
						Endif
					Endif
				Else
					SC2->(dbSkip())
				Endif
			End       


			// VALIDADO, MAS AINDA SER� AVALIADO SE SER� POSTO EM PRODU��O


			//IDENTIFICA��O DO ERRO GERADO - INICIO

			If !Empty(c_Pedido)
				c_CRLF  := chr(13) + chr(10)
				c_NumOp := "P" + SubStr(c_Pedido, 2, 5)

				dbSelectArea("SC2")
				SC2->(dbSetOrder(1))
				If SC2->(dbSeek(xFilial("SC2") + c_NumOp)) == .F.
					//					c_Qry   := " BEGIN TRANSACTION " + c_CRLF

					// Atualiza as Ordens de Produ��o
					c_Qry := " UPDATE " + RetSqlName("SC2") + " SET C2_NUM = '" + c_NumOp + "' " + c_CRLF
					c_Qry += " WHERE D_E_L_E_T_<>'*' AND C2_STATUS<>'U' AND C2_QUJE = 0 AND C2_FILIAL = '" + xFilial("SC2") + "' AND C2_NUM = '" + a_OPsPV[i][1] + "' AND C2_EMISSAO = '" + Dtos(DDATABASE) + "' " + c_CRLF

					// Atualiza os Empenhos da Ordem de Produ��o
					c_Qry += " UPDATE " + RetSqlName("SD4") + " SET D4_OP = '" + c_NumOp + "' + SUBSTRING(D4_OP, 7, 13), D4_OPORIG = CASE WHEN D4_OPORIG <> '' THEN 'P' + SUBSTRING(D4_OPORIG, 2, 13) ELSE D4_OPORIG END " + c_CRLF
					c_Qry += " WHERE D_E_L_E_T_<>'*' AND D4_OP LIKE '" + a_OPsPV[i][1] + "%' AND D4_FILIAL = '" + xFilial("SD4") + "' AND D4_QUANT = D4_QTDEORI " + c_CRLF

					// Atualiza as Solicita��es de Compra
					c_Qry += " UPDATE " + RetSqlName("SC1") + " SET C1_OP = '" + c_NumOp + "' + SUBSTRING(C1_OP, 7, 13) " + c_CRLF
					c_Qry += " WHERE D_E_L_E_T_<>'*' AND C1_FILIAL = '" + xFilial("SC1") + "' AND C1_OP LIKE '" + a_OPsPV[i][1] + "%' AND C1_ORIGEM = 'MATA650' AND C1_QUJE = 0 AND C1_EMISSAO = '" + Dtos(DDATABASE) + "' " + c_CRLF

					// Atualiza o Item do Pedido de Venda
					c_Qry += " UPDATE " + RetSqlName("SC6") + " SET C6_NUMOP = '" + c_NumOp + "' " + c_CRLF
					c_Qry += " WHERE D_E_L_E_T_<>'*' AND C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUMOP = '" + a_OPsPV[i][1] + "' " + c_CRLF

					// Atualiza Pedido de Venda x OP
					c_Qry += " UPDATE " + RetSqlName("SGJ") + " SET GJ_NUMOP = '" + c_NumOp + "' " + c_CRLF
					c_Qry += " WHERE D_E_L_E_T_<>'*' AND GJ_FILIAL = '" + xFilial("SGJ") + "' AND GJ_NUMOP = '" + a_OPsPV[i][1] + "' " + c_CRLF



					MemoWrit("C:\BOMIX\MT650OPPV_1.sql",c_Qry)
					/*				
					If TcSqlExec(c_Qry) < 0
					MsgStop("SQL Error: " + TcSqlError())
					TcSqlExec("ROLLBACK")
					Else
					TcSqlExec("COMMIT")	
					Endif
					*/
					// TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ACIMA DE GRAVA��O  ESTAVA GERANDO ERRO NO DBACCESS ATUAL
					TRYEXCEPTION

					TcCommit(1,ProcName())    //Begin Transaction

					IF ( TcSqlExec( c_Qry ) < 0 )
						cTCSqlError := TCSQLError()
						ConOut( cMsgOut += ( "[ProcName: " + ProcName() + "]" ) )
						cMsgOut += cCRLF
						ConOut( cMsgOut += ( "[ProcLine:" + Str(ProcLine()) + "]" ) )
						cMsgOut += cCRLF
						ConOut( cMsgOut += ( "[TcSqlError:" + cTCSqlError + "]" ) )
						cMsgOut += cCRLF
						UserException( cMsgOut )
					EndIF

					TcCommit(2,ProcName())    //Commit
					TcCommit(4)                //End Transaction

					CATCHEXCEPTION   

					TcCommit(3) //RollBack
					TcCommit(4) //End Transaction

					ENDEXCEPTION

					// FIM TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ANTERIOR DE GTRAVA��O ESTAVA GERANDO ERRO NO DBACCESS ATUAL

					/*
					1 Begin Transaction
					2 End Transaction
					3 RollBack
					4 Commit
					5 Especifico para AS/400?

					Read more: http://www.blacktdn.com.br/2012/03/blacktdn-funcao-nao-documentada.html#ixzz6QVFqdfpB
					*/









				Endif

				//				f_Mata410(c_Pedido)
			Endif
			//IDENTIFICA��O DO ERRO GERADO - FIM

		Endif
	Next i

	RestArea(a_AreaSC2)
	RestArea(a_Area)
Return Nil

Static Function f_SitArte
	Local c_SitArte := ''

	c_Qry := "SELECT C6_FSTPITE FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + SC2->C2_PEDIDO + "' "
	c_Qry += " AND C6_ITEM = '" + SC2->C2_ITEMPV + "' AND C6_PRODUTO = '" + SC2->C2_PRODUTO + "' AND D_E_L_E_T_ <> '*' "

	MemoWrit("C:\BOMIX\MT650OPPV.sql",c_Qry)

	TCQuery c_Qry New Alias QRY
	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!Eof())
		c_SitArte := QRY->C6_FSTPITE
	Endif

	QRY->(dbCloseArea())
Return c_SitArte


/*
Static Function f_Mata410(c_Pedido)
Local a_Cabec   := {}	
Local a_Itens   := {}
Local a_Linha   := {}
Local a_AreaSC5 := SC5->(GetArea())
Local a_Area    := GetArea()

Private lMsErroAuto := .F.

a_Cabec := {}	
a_Itens := {}

dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial("SC5") + c_Pedido)
aadd(a_Cabec,{"C5_NUM",		SC5->C5_NUM,		Nil})
aadd(a_Cabec,{"C5_TIPO",	SC5->C5_TIPO,		Nil})
aadd(a_Cabec,{"C5_CLIENTE",	SC5->C5_CLIENTE,	Nil})	
aadd(a_Cabec,{"C5_LOJACLI",	SC5->C5_LOJACLI,	Nil})	
aadd(a_Cabec,{"C5_LOJAENT",	SC5->C5_LOJAENT,	Nil})	
aadd(a_Cabec,{"C5_CONDPAG",	SC5->C5_CONDPAG,	Nil})

c_Qry := " SELECT * FROM " + RetSqlName("SC6") + " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + c_Pedido + "' "
c_Qry += " AND D_E_L_E_T_ <> '*' ORDER BY C6_FILIAL, C6_NUM, C6_ITEM "

TCQuery c_Qry New Alias QRY

dbSelectArea("QRY")
dbGoTop()
While QRY->(!EoF())
a_Linha := {}

aadd(a_Linha,{"LINPOS",		"C6_ITEM",			QRY->C6_ITEM})
aadd(a_Linha,{"AUTDELETA",	"N",				Nil})
aadd(a_Linha,{"C6_PRODUTO",	QRY->C6_PRODUTO,	Nil})		
aadd(a_Linha,{"C6_QTDVEN",	QRY->C6_QTDVEN,		Nil})		
aadd(a_Linha,{"C6_PRCVEN",	QRY->C6_PRCVEN,		Nil})		
aadd(a_Linha,{"C6_PRUNIT",	QRY->C6_PRUNIT,		Nil})		
aadd(a_Linha,{"C6_VALOR",	QRY->C6_VALOR,		Nil})		
aadd(a_Linha,{"C6_TES",		QRY->C6_TES,		Nil})

If QRY->C6_OP $ "01/05"
aadd(a_Linha,{"C6_QTDLIB",	QRY->C6_QTDVEN,	Nil})
//				aadd(a_Linha,{"C6_RESERVA",	,	Nil})
Endif

aadd(a_Itens,a_Linha)	

QRY->(dbSkip())
End

QRY->(dbCloseArea())

MATA410(a_Cabec, a_Itens, 4)

If lMsErroAuto
MostraErro()
EndIf
Endif

RestArea(a_AreaSC5)
RestArea(a_Area)
Return
*/