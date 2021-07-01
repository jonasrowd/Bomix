#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT650OPPV  ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada geração de Ordens de Produção a partir de º±±
±±º          ³ pedidos selecionados, logo após o término da geração de OPsº±±
±±º          ³ por Venda (fora da transação).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   º±±
±±Ì          ³ Este ponto de entrada está sendo utilizado para alterar o  ¹±±
±±º          ³ tipo das Ordens de Produção geradas associadas a um Pedido º±±
±±º          ³ de Venda quando o produto possui arte e a situação da arte º±±
±±º          ³ no item do PV é nova ou alterada. 						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/* VERSÃO EM PRODUÇÃO ANTES DA ALTERAÇÃO DA ROTINA DE ARTE
User Function MT650OPPV()
	Local a_OPsPV  := PARAMIXB[2]			//Array com as ordens de produção, itens e sequencia geradas
	Local c_C6Arte := ''					//Situação da arte do produto no pedido de venda

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
			    If dbSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja)			//Verifica se existe amarração Produto x Cliente
			    	If SA7->A7_FSQTDPE > 0  		//Se for maior que zero o valor do campo de Qtd p/ Emb.
			       		RecLock("SC2", .F.)
			       		SC2->C2_FSQTDPE := SA7->A7_FSQTDPE     						//Altera o valor do campo Qtd p/ Emb. da OP
			       		MsUnlock()
			     	Else
   				    	dbSelectArea("SB5")				//Se não existe amarração Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
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
			    	dbSelectArea("SB5")				//Se não existe amarração Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
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
					c_C6Arte := f_SitArte() 				//Chama a função para trazer a situação da arte no item do pedido de venda

					If c_C6Arte == '1' .Or. c_C6Arte == '2'		//Se situação da arte no item do pedido de venda for Nova ou Alterada
						//Trecho que altera o tipo da ordem de produção do PA e dos PIs para prevista e define que a OP é de arte
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
	Local a_OPsPV  := PARAMIXB[2]			//Array com as ordens de produção, itens e sequencia geradas
	Local c_C6Arte := ''					//Situação da arte do produto no pedido de venda
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
			    If dbSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja)			//Verifica se existe amarração Produto x Cliente
			    	If SA7->A7_FSQTDPE > 0  		//Se for maior que zero o valor do campo de Qtd p/ Emb.
			       		RecLock("SC2", .F.)
			       		SC2->C2_FSQTDPE := SA7->A7_FSQTDPE     						//Altera o valor do campo Qtd p/ Emb. da OP
			       		MsUnlock()
			     	Else
   				    	dbSelectArea("SB5")				//Se não existe amarração Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
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
			    	dbSelectArea("SB5")				//Se não existe amarração Produto x Cliente, verifica o valor do Qtd Embalag1 da SB5
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
					c_C6Arte := f_SitArte() 				//Chama a função para trazer a situação da arte no item do pedido de venda

					If c_C6Arte == '1'						//Se situação da arte no item do pedido de venda for bloqueada
						//Trecho que altera o tipo da ordem de produção do PA e dos PIs para prevista e define que a OP é de arte
						While SC2->(!Eof()) .And. SC2->C2_NUM == c_OP .And. SC2->C2_ITEM == c_Item
							RecLock("SC2", .F.)
							SC2->C2_TPOP   := 'P'
							SC2->C2_FSARTE := '1'
							MsUnlock()
							SC2->(dbSkip())
						End
					Else
						//Trecho que altera o tipo da ordem de produção do PA para prevista e dos PIs para firme e define que a OP é de arte
						c_BlqArte := Posicione("SZ2", 1, xFilial("SZ2") + c_Arte, "Z2_BLOQ")
						
						If (c_BlqArte == '1') .Or. (c_BlqArte == '2') //Arte Nova ou Bloqueada
							//Trecho que altera o tipo da ordem de produção do PA e dos PIs para prevista e define que a OP é de arte
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