#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados da Produção PCP Mod2
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return variant, Logical
/*/
User Function MT680VAL()
	Local a_Area    := GetArea()
	Local l_Ret     := .T.
	Local n_Op		:= M->H6_OP
	Local d_DtValid := 	CTOD("  /  /    ")
	Local nCount	:= 0
	Local n_Quant	:= 0

	If l_Ret .And. l681
		DbSelectArea("SZ7") //Seleciona a área da tabela customizada que controla as movimentações de estoque para o wms
		DbSetOrder(1)
		DbSeek(xFilial("SZ7") + __CUSERID + M->H6_LOCAL)	//Busca a informação do usuário na tabela da rotina customizada
		If !("TOTVSMES" $ M->H6_OBSERVA)
			If !(Z7_TPMOV $ "E|A")	//Se NÃO vier do WebService MES ou o usuário não tenha permissão de entrada no estoque do wms. (E=Entrada, A=Ambos)
				lRet := .F.	//Não permite o apontamento e exibe o Help do bloqueio.
				Help(NIL, NIL, "MOV_ARM", NIL, "O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + M->H6_LOCAL + ".",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contacte o administrador do sistema."})
			ElseIf (M->H6_QTDPERD > 0 .And. lSavePerda == .F. .And. M->H6_PT == "T")
				//Identifica se é apontamento de perda pela quantidade apontada no campo H6_QTDPERD.
				//lSavePerda é variável privada da rotina de apontamento de perda que verifica se foi preenchida corretamente.
				//Verifica também que o apontamento de perda não pode ser Total, ou seja, não pode encerrar OP com Perda.
				//Caso não, bloqueia a gravação do apontamento de perda e exibe o Help do bloqueio.
				lRet := .F.
				M->H6_PT := "P"
				Help(NIL, NIL, "ERROR_PERD", NIL, "Apontamento de perda preenchido incorretamente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os dados do apontamento e lembre-se que não pode encerrar a Op com Perda."})
			EndIf
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + M->H6_PRODUTO))
			If M->H6_QTDPROD > SB1->B1_QB
				lRet := .F.
				Help(NIL, NIL, "ERROR_PROD", NIL, "Apontamento de produção preenchido incorretamente.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Não é possível apontar produção maior que a quantidade base."})
			EndIf
		EndIf

		DbSelectArea('SB1')
		DbSetOrder(1)
		dbSeek(xFilial('SB1') + M->H6_PRODUTO)
		If SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID)
			nCount := SB1->B1_PRVALID
		EndIf

		If Select("SH6TEMP") > 0 //Verifica se o Alias já possui registro
			SH6TEMP->(DbCloseArea()) //Fecha a tabela se já estiver aberta
		EndIf

		//SELECIONA OS REGISTROS DA OP
		BEGINSQL ALIAS "SH6TEMP"
			COLUMN H6_DTVALID AS DATE

			SELECT
				TOP 1
				H6.H6_DTVALID AS FSDTVLD
			FROM
				%TABLE:SH6% H6
			WHERE
				H6.H6_FILIAL = %xFilial:SH6% AND
				H6.H6_OP = %EXP:n_Op% AND
				H6.%NOTDEL%
			ORDER BY H6.H6_DTVALID DESC
		ENDSQL

		If !Empty(SH6TEMP->FSDTVLD) //Se não é o primeiro apontamento
			While SH6TEMP->(!EOF())//Enquanto não for o final do arquivo procura se já tem uma validade preenchida em qualquer item da Op
				d_DtValid := STOD(SH6TEMP->FSDTVLD) //Armazena a data de validade da Op
			DbSkip()
			End
		EndIf

		M->H6_DTVALID := d_DtValid

		SH6TEMP->(DbCloseArea())

		DbSelectArea('SC2')
		DbSetOrder(1)
		If DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3))
			If (Found())
				If Empty(M->H6_DTVALID)
					M->H6_DTVALID := date() + nCount
				EndIf
				If  Empty(SC2->C2_FSDTVLD)
					RecLock('SC2',.F.)
						SC2->C2_FSDTVLD := M->H6_DTVALID
						If Empty(SC2->C2_FSLOTOP)
							SC2->C2_FSLOTOP:= M->H6_LOTECTL
						EndIf
					SC2->(MsUnlock())
				Else
					M->H6_DTVALID := SC2->C2_FSDTVLD
				EndIf
			EndIf
		EndIf
		DbSelectArea("SG2") //Seleciona a área da SG2 para preencher o apontamento com informações da estrutura do produto
		DbSetOrder(3)
		If (DbSeek(xFilial("SG2")+ M->H6_PRODUTO + M->H6_OPERAC))
			M->H6_FERRAM  := SG2->G2_FERRAM //Preenche a ferramenta
			M->H6_FSCAVI  := SG2->G2_FSCAVI //Preenche a cavidade
			M->H6_FSSETOR := SG2->G2_DESCRI //Preenche a descrição do setor
			M->H6_CICLOPD := SG2->G2_FSCICLO //Preenche o ciclo padrão
		EndIf
	EndIf

	If !("TOTVSMES" $ M->H6_OBSERVA)
		If M->H6_PT == "T"
			If MsgYesNo('Confirma a Totalização da OP?', 'Totalização da OP')
				DbSelectArea("SC2")
				DbSetOrder(1)
				If dbSeek(xFilial("SC2") + SH6->H6_OP)
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
					
					If SB1->B1_QB == M->H6_QTDPROD

						If (Select("MIAUD4") > 0)
							DbSelectArea("MIAUD4")
							DBCloseArea()
						EndIf

						BEGINSQL ALIAS "MIAUD4"
							SELECT
								D4_COD AS PROD,
								D4_QUANT AS ORI,
								D4_OP AS OP,
								D4_FSTP AS TIPO
							FROM  %TABLE:SD4%
							WHERE D4_FILIAL = %xFilial:SD4%
								AND %NOTDEL%
								AND D4_OP = %EXP:M->H6_OP%
						ENDSQL

						While (!EOF())
							DbSelectArea("SD4")
							DbSetOrder(1)
							DbSeek(xFilial("SD4") + MIAUD4->PROD + MIAUD4->OP)
							If SD4->D4_QUANT < SD4->D4_FSQTDES
								RecLock("SD4", .F.)
									SD4->D4_QUANT := SD4->D4_FSQTDES
								MsUnlock()
							EndIf
							MIAUD4->(DbSkip())
						End
						SD4->(DBCloseArea())

					ElseIf SB1->B1_QB > M->H6_QTDPROD
						DbSelectArea("SB1")
						SB1->(DbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
						
						n_Perc := M->H6_QTDPROD/SB1->B1_QB

						DbSelectArea("SG1")
						SG1->(DbSetOrder(1))
						SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
						While SG1->(!EoF()) .And. SG1->G1_COD == SC2->C2_PRODUTO
							DbSelectArea("SD4")
							SD4->(DbSetOrder(2))
							SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP + SG1->G1_COMP))
							If Found()
								n_Quant   := SG1->G1_QUANT * n_Perc
								RecLock("SD4", .F.)
									SD4->D4_QUANT := n_Quant
								MsUnlock()
							EndIf
							SG1->(dbSkip())
						End
						SD4->(DBCloseArea())
					EndIf
				Endif
			Else
				M->H6_PT := "P"
			Endif
		EndIf

		If M->H6_PT == "P"
			If (Select("MIAUD4") > 0)
				DbSelectArea("MIAUD4")
				DBCloseArea()
			EndIf

			BEGINSQL ALIAS "MIAUD4"
				SELECT
					D4_COD AS PROD,
					D4_QUANT AS ORI,
					D4_OP AS OP,
					D4_FSTP AS TIPO
				FROM  %TABLE:SD4%
				WHERE D4_FILIAL = %xFilial:SD4%
					AND %NOTDEL%
					AND D4_OP = %EXP:M->H6_OP%
			ENDSQL

			While (!EOF())
				DbSelectArea("SD4")
				DbSetOrder(1)
				DbSeek(xFilial("SD4") + MIAUD4->PROD + MIAUD4->OP)
				If SD4->D4_QUANT < SD4->D4_FSQTDES
					RecLock("SD4", .F.)
						SD4->D4_QUANT := SD4->D4_FSQTDES
					MsUnlock()
				EndIf
				MIAUD4->(DbSkip())
			End
			SD4->(DBCloseArea())
		EndIf

		If cFilAnt == '020101'
			If M->H6_QTDPERD > 0
				If "BORRA" $ UPPER(APERDA[1][4])
					M->H6_QTDPERD := (APERDA[1][2] / M->H6_FSPESOI)
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(a_Area)

Return l_Ret
