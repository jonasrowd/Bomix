User Function F200VAR
	Local a_Valores := PARAMIXB[1]
	Local a_AreaSE1 := SE1->(GetArea())
	Local a_AreaSX1 := SX1->(GetArea())
	Local a_Area    := GetArea()

	Private c_Perg  := "F200VAR"

	CriaPerg()

	//a_Valores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })

	dbSelectArea("SE1")
	dbSetOrder(16)
	If dbSeek(xFilial("SE1") + a_Valores[1])
		If (dBaixa > SE1->E1_VENCREA) .And. (SE1->E1_VALJUR > 0) .And. (nJuros == 0)
//			n_ValJur := DateDiffDay(dBaixa, SE1->E1_VENCREA) * SE1->E1_VALJUR

			If MsgYesNo("O pagamento do título "  + ALLTRIM(SE1->E1_NUM) + " foi efetuado com " + cValToChar(DateDiffDay(dBaixa, SE1->E1_VENCREA))+ " dia(s) de atraso e o título possui uma taxa de permanência diária de " + StrTran(cValToChar(SE1->E1_VALJUR), ".", ",") + " reais, porém o arquivo de retorno do banco está com o valor do juros zerado. Deseja realizar o ajuste do valor do juros?", SM0->M0_NOME)
				If Pergunte(c_Perg, .T.)
//					nJuros := n_ValJur
					nJuros := MV_PAR01
				Endif
			Endif
		Elseif (dBaixa > SE1->E1_VENCREA) .And. (SE1->E1_PORCJUR > 0) .And. (nJuros == 0)
//			n_ValJur := DateDiffDay(dBaixa, SE1->E1_VENCREA) * (SE1->E1_VALOR * (SE1->E1_PORCJUR/100))

			If MsgYesNo("O pagamento do título "  + ALLTRIM(SE1->E1_NUM) + " foi efetuado com " + cValToChar(DateDiffDay(dBaixa, SE1->E1_VENCREA))+ " dia(s) de atraso e o título possui um porcentual de juros por dia de atraso de " + StrTran(cValToChar(SE1->E1_PORCJUR/100), ".", ",") + " %, porém o arquivo de retorno do banco está com o valor do juros zerado. Deseja realizar o ajuste do valor do juros?", SM0->M0_NOME)
				If Pergunte(c_Perg, .T.)
//					nJuros := n_ValJur
					nJuros := MV_PAR01
				Endif
			Endif
		Endif
	Endif

	RestArea(a_AreaSE1)
	RestArea(a_AreaSX1)
	RestArea(a_Area)
Return



Static Function CriaPerg
	Local a_PAR01 := {}

	Aadd(a_PAR01, "Informe o valor do juros do título")
	Aadd(a_PAR01, "a receber.")

	dbSelectArea("SX1")
	SX1->(dbGoTop())
	If SX1->(dbSeek(c_Perg))
		RecLock("SX1", .F.)
		SX1->X1_CNT01 := "0.00"
		MsUnlock()
	Else
		//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	 	PutSx1(c_Perg,"01","Valor do Juros ?"  	    ,"","","mv_ch1","N",TamSX3("E1_VALJUR")[1],TamSX3("E1_VALJUR")[2],0,"G","Positivo()","","","","mv_par01","","","","","","","","","","","","","","","","",a_PAR01)
	Endif
Return Nil