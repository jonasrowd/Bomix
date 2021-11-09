//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} FESTG001
	Gatilho para preencher a quantidade destino do produto destino no Apontamento de Perda/ClassIfica��o da Perda
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 22/09/2021
	@return numeric, Retorna a quantidade de destino.
/*/
User Function FESTG001
	Local a_Area    := GetArea()
	Local n_QtdDest := 0

	If cFilAnt == '010101'
		If aCols[n][Len(aHeader) + 1] == .F.
			c_Prod   := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRODUTO'})]
			n_QtdPer := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]
			c_Dest   := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_CODDEST'})]
			c_Um     := ""
			n_Peso   := 0
			c_Grupo  := ""
			c_UmDest := ""
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1") + c_Prod))
				c_Um    := SB1->B1_UM
				c_Grupo := SB1->B1_GRUPO
			EndIf

			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1") + c_Dest))
				c_UmDest := SB1->B1_UM
			EndIf

			// VERIfICA��O DA CONDI��O DE UN/PC FRACIONADO INSERIDO POR VICTOR SOUSA 02/12/19
			If RTRIM(c_Um) $ "UN/PC" .AND.  n_QtdPer%1 <> 0
				MsgInfo("Quantidade fracionada n�o permitida para este produto. Vou corrigir pra voc�.", "Nao � assim!") 	
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]:= M->H6_QTDPERD
			EndIf

			If c_Um == c_UmDest
				n_QtdDest := n_QtdPer
			ElseIf c_Um $ "UN/PC" .And. c_UmDest $ "UN/PC"
				n_QtdDest := n_QtdPer
			ElseIf c_Um $ "UN/PC" .And. AllTrim(c_UmDest) == "KG"
				// dbSelectArea("SBM")
				// SBM->(dbSetOrder(1))
				n_QtdDest := n_QtdPer * n_Peso
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDES2'})] := 0
			EndIf
		EndIf

	ElseIf cFilAnt == '020101'
	
		If aCols[n][Len(aHeader) + 1] == .F.
			c_Prod	:= aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRODUTO'})]
			If "BORRA" $ aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRDEST'})]
				// n_QtdPer := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]
				// aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTSEGUM'})] := n_QtdPer
				// n_QtdDest := n_QtdPer
				// aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDES2'})] := n_QtdPer
				// aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDEST'})] := n_QtdDest1

				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTSEGUM'})] := M->H6_QTDPERD
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]	  := M->H6_QTDPERD
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDES2'})] := M->H6_QTDPERD
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDEST'})] := M->H6_QTDPERD
				n_QtdDest := M->H6_QTDPERD
			ElseIf "MATERIAL" $ aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRDEST'})]
				c_Dest	:= aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_CODDEST'})]
				n_QtdPer := M->H6_QTDPERD
				If aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})] <> M->H6_QTDPERD
					// MsgInfo("N�O PODE APONTAR .", "N�O PODE!!!!!")
				EndIf

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + c_Prod))
					c_Um    := SB1->B1_UM
					n_Peso	:= SB1->B1_PESO
					c_Grupo := SB1->B1_GRUPO
				EndIf

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + c_Dest))
					c_UmDest := SB1->B1_UM
				EndIf

				If RTRIM(c_Um) $ "UN/PC" .AND.  n_QtdPer % 1 <> 0
					MsgInfo("Quantidade fracionada n�o permitida para este produto. Vou corrigir pra voc�.", "Nao � assim!") 	
					aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]:= M->H6_QTDPERD
				EndIf

				If AllTrim(c_Um) == AllTrim(c_UmDest)
					AllTrim(n_QtdDest) := AllTrim(n_QtdPer)
				ElseIf AllTrim(c_Um) $ "UN|PC" .And. AllTrim(c_UmDest) $ "UN|PC"
					AllTrim(n_QtdDest) := AllTrim(n_QtdPer)
				ElseIf AllTrim(c_Um) $ "UN|PC" .And. AllTrim(c_UmDest) == "KG"
					n_QtdDest := n_QtdPer * n_Peso
				EndIf

				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTSEGUM'})] := n_QtdDest
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]	  := M->H6_QTDPERD
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDES2'})] := n_QtdDest
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDEST'})] := M->H6_QTDPERD
				n_QtdDest := M->H6_QTDPERD

			EndIf
		EndIf
	EndIf

	RestArea(a_Area)
Return n_QtdDest
