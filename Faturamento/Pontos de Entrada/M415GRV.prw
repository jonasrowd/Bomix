#Include "TOTVS.ch"

/*/{Protheus.doc} M415GRV
	Ponto de entrada acionado após a gravação das informações do
	orçamento em todas as opções (inclusão, alteraçãoo e exclusão).
	O PARAMIXB estará com o número da opçõao (1, 2 ou 3).
	@type Function
	@author Christian Rocha
	@since 10/11/2012
	@obs Bloqueia a arte caso o orçamento defina o bloqueio da arte
/*/
User Function M415GRV()
	Local a_Area     := GetArea()
	Local c_Produto := ""
	Local c_SitArte := ""

	Private cFil := FwCodFil()



	If (cFil == "030101")
		Return(NIL)
	EndIf

	If (PARAMIXB[1] == 1) .OR. (PARAMIXB[1] == 2)
		DBSelectARea("TMP1")
		DBGoTop()

		While (TMP1->(!EOF()))
			If (!TMP1->CK_FLAG)
				c_Produto := TMP1->CK_PRODUTO
				c_SitArte := TMP1->CK_FSTPITE

				If (c_SitArte == "1")
					DBSelectArea("SB1")
					DBGoTop()
					DBSetOrder(1)
					DBSeek(FwXFilial("SB1") + c_Produto)

					If (Found())
						//Verifica se o flag de arte do produto está marcado com SIM
						If (SB1->B1_FSFARTE == "1")
							DBSelectArea("SZ2")
							DBGoTop()
							DBSetOrder(1)
							DBSeek(FwXFilial("SZ2") + SB1->B1_FSARTE)

							If (Found())
								If (SZ2->Z2_BLOQ != "2")
									// Bloqueia a arte do produto
									RecLock("SZ2", .F.)
										SZ2->Z2_BLOQ   := "2"
										SZ2->Z2_DATA   := dDatabase
										SZ2->Z2_RESP   := Upper(UsrRetName(__cUserID))
										SZ2->Z2_OBSERV := IIf(!Empty(SZ2->Z2_OBSERV), SZ2->Z2_OBSERV + CRLF + CRLF, "") + ;
														"Orçaamento: " + AllTrim(SCJ->CJ_NUM) + ", Data: " +Dtoc(DDATABASE) + ", Hora: " + Time() + ;
														", Responsável: " + Upper(UsrRetName(__cUserID))
									MsUnlock()

									U_FALTSZ2()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			TMP1->(dbSkip())
		End
	EndIf

	RestArea(a_Area)
Return (NIL)
