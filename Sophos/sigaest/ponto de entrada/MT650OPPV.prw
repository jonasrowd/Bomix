#INCLUDE "TOPCONN.CH"

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

/* VERS�O EM PRODU��O ANTES DA ALTERA��O DA ROTINA DE ARTE
User Function MT650OPPV()
	Local a_OPsPV  := PARAMIXB[2]			//Array com as ordens de produ��o, itens e sequencia geradas
	Local c_C6Arte := ''					//Situa��o da arte do produto no pedido de venda

	For i:=1 To Len(a_OPsPV)
		dbSelectArea("SC2")
		dbGoTop()
		dbSetOrder(1)
		If dbSeek(xFilial("SC2") + a_OPsPV[i][1] + a_OPsPV[i][2])
			c_Pedido := SC2->C2_PEDIDO
		    If !Empty(c_Pedido)				//Se OP estiver associada a um pedido de venda
			    c_Produto := SC2->C2_PRODUTO
		    	c_Cliente := Posicione("SC5", 1, xFilial("SC5") + c_Pedido, "C5_CLIENTE")
		    	c_Loja    := Posicione("SC5", 1, xFilial("SC5") + c_Pedido, "C5_LOJACLI")
	
		     	dbSelectArea("SA7")			
			    dbGoTop()
			    dbSetOrder(2)
			    If dbSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja)			//Verifica se existe amarra��o Produto x Cliente
			    	If SA7->A7_FSQTDPE > 0  		//Se for maior que zero o valor do campo de Qtd p/ Emb.
			       		RecLock("SC2", .F.)
			       		SC2->C2_FSQTDPE := SA7->A7_FSQTDPE     						//Altera o valor do campo Qtd p/ Emb. da OP
			       		MsUnlock()
			     	Else
   				    	dbSelectArea("SB5")				//Se n�o existe amarra��o Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
				      	dbGoTop()
				      	dbSetOrder(1)
				      	If dbSeek(xFilial("SB5") + c_Produto)
				       		If SB5->B5_QE1 > 0                        //Se for maior que zero o valor do campo Qtd Embalag1
			    	    		RecLock("SC2", .F.)
			        			SC2->C2_FSQTDPE := SB5->B5_QE1        //Altera o valor do campo Qtd p/ Emb. da OP
			        			MsUnlock()
				       		Endif
				      	Endif
			      	Endif
			    Else
			    	dbSelectArea("SB5")				//Se n�o existe amarra��o Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
			      	dbGoTop()
			      	dbSetOrder(1)
			      	If dbSeek(xFilial("SB5") + c_Produto)
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
				If !Empty(c_Arte)							//Se no cadastro do produto o campo B1_FSARTE for diferente de 99999 e diferente de vazio
					c_C6Arte := f_SitArte() 				//Chama a fun��o para trazer a situa��o da arte no item do pedido de venda

					If c_C6Arte == '1' .Or. c_C6Arte == '2'		//Se situa��o da arte no item do pedido de venda for Nova ou Alterada
						//Trecho que altera o tipo da ordem de produ��o do PA e dos PIs para prevista e define que a OP � de arte
						While SC2->(!Eof()) .And. SC2->C2_NUM == c_OP .And. SC2->C2_ITEM == c_Item
							RecLock("SC2", .F.)
							SC2->C2_TPOP   := 'P'
							SC2->C2_FSARTE := '1'
							MsUnlock()
							SC2->(dbSkip())
						End
					Else
						SC2->(dbSkip())
					Endif
				Else
					SC2->(dbSkip())
				Endif
			End
		Endif
	Next i

Return Nil

Static Function f_SitArte
	Local c_SitArte := ''

	c_Qry := "SELECT C6_FSTPITE FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + SC2->C2_PEDIDO + "' "
	c_Qry += " AND C6_ITEM = '" + SC2->C2_ITEMPV + "' AND C6_PRODUTO = '" + SC2->C2_PRODUTO + "' AND D_E_L_E_T_ <> '*' "

	MemoWrit("C:\MT650OPPV.sql",c_Qry)

	TCQuery c_Qry New Alias QRY
	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!Eof())
		c_SitArte := QRY->C6_FSTPITE
	Endif

	QRY->(dbCloseArea())
Return c_SitArte
*/

User Function MT650OPPV()
	Local a_OPsPV  := PARAMIXB[2]			//Array com as ordens de produ��o, itens e sequencia geradas
	Local c_C6Arte := ''					//Situa��o da arte do produto no pedido de venda
	Local a_Area   := GetArea()

	For i:=1 To Len(a_OPsPV)
		dbSelectArea("SC2")
		dbGoTop()
		dbSetOrder(1)
		If dbSeek(xFilial("SC2") + a_OPsPV[i][1] + a_OPsPV[i][2])
			c_Pedido := SC2->C2_PEDIDO
		    If !Empty(c_Pedido)				//Se OP estiver associada a um pedido de venda
			    c_Produto := SC2->C2_PRODUTO
		    	c_Cliente := Posicione("SC5", 1, xFilial("SC5") + c_Pedido, "C5_CLIENTE")
		    	c_Loja    := Posicione("SC5", 1, xFilial("SC5") + c_Pedido, "C5_LOJACLI")
	
		     	dbSelectArea("SA7")			
			    dbGoTop()
			    dbSetOrder(2)
			    If dbSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja)			//Verifica se existe amarra��o Produto x Cliente
			    	If SA7->A7_FSQTDPE > 0  		//Se for maior que zero o valor do campo de Qtd p/ Emb.
			       		RecLock("SC2", .F.)
			       		SC2->C2_FSQTDPE := SA7->A7_FSQTDPE     						//Altera o valor do campo Qtd p/ Emb. da OP
			       		MsUnlock()
			     	Else
   				    	dbSelectArea("SB5")				//Se n�o existe amarra��o Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
				      	dbGoTop()
				      	dbSetOrder(1)
				      	If dbSeek(xFilial("SB5") + c_Produto)
				       		If SB5->B5_QE1 > 0                        //Se for maior que zero o valor do campo Qtd Embalag1
			    	    		RecLock("SC2", .F.)
			        			SC2->C2_FSQTDPE := SB5->B5_QE1        //Altera o valor do campo Qtd p/ Emb. da OP
			        			MsUnlock()
				       		Endif
				      	Endif
			      	Endif
			    Else
			    	dbSelectArea("SB5")				//Se n�o existe amarra��o Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
			      	dbGoTop()
			      	dbSetOrder(1)
			      	If dbSeek(xFilial("SB5") + c_Produto)
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
		Endif
	Next i
	
	RestArea(a_Area)

Return Nil

Static Function f_SitArte
	Local c_SitArte := ''

	c_Qry := "SELECT C6_FSTPITE FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + SC2->C2_PEDIDO + "' "
	c_Qry += " AND C6_ITEM = '" + SC2->C2_ITEMPV + "' AND C6_PRODUTO = '" + SC2->C2_PRODUTO + "' AND D_E_L_E_T_ <> '*' "

	MemoWrit("C:\MT650OPPV.sql",c_Qry)

	TCQuery c_Qry New Alias QRY
	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!Eof())
		c_SitArte := QRY->C6_FSTPITE
	Endif

	QRY->(dbCloseArea())
Return c_SitArte