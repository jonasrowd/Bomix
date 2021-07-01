/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FESTV004  º Autor ³ Christian Rocha    º Data ³Novembro/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina do campo virtual C6_FSSTATU.						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Utilizado para exibir o Status da Arte na Ordem de Produçãoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A T U A L I Z A C O E S                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ºANALISTA           ºALTERACOES                              º±±
±±º          º                   º                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FFATV004
	Local c_Status := ''
	Local a_Area   := GetArea()  
	
	
	//testa filial atual
private c_Status := ''
private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return c_Status
endif

////////
	
	

	If INCLUI
 		c_Status := ''
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + SC6->C6_PRODUTO)
			If !Empty(SB1->B1_FSARTE)
				dbSelectArea("SZ2")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ2") + SB1->B1_FSARTE)
					If SZ2->Z2_BLOQ == '1'
				 		c_Status := 'ARTE NOVA'
					Elseif SZ2->Z2_BLOQ == '2'
				 		c_Status := 'BLOQUEADA'
					Elseif SZ2->Z2_BLOQ == '3'
				 		c_Status := 'FOTOLITO A DESENVOLVER'
					Else
				 		c_Status := 'PRONTA PARA IMPRESSÃO'
				 	Endif			 					 					 		
				Endif
			Endif
		Endif
	Endif

	RestArea(a_Area)
Return c_Status



User Function FFATV005
	Local c_Status := ''
	Local a_Area   := GetArea()

	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1") + M->C6_PRODUTO)
		If !Empty(SB1->B1_FSARTE)
			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2") + SB1->B1_FSARTE)
				If SZ2->Z2_BLOQ == '1'
			 		c_Status := 'ARTE NOVA'
				Elseif SZ2->Z2_BLOQ == '2'
			 		c_Status := 'BLOQUEADA'
				Elseif SZ2->Z2_BLOQ == '3'
			 		c_Status := 'FOTOLITO A DESENVOLVER'
				Else
			 		c_Status := 'PRONTA PARA IMPRESSÃO'
			 	Endif			 					 					 		
			Endif
		Endif
	Endif

	RestArea(a_Area)
Return c_Status