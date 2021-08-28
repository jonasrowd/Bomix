#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados da Produção PCP Mod2
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return variant, Logical
/*/
User Function MT680VAL
	Local a_Area    := GetArea()
	Local l_Ret     := .T.

	If l_Ret .And. l681
		dbSelectArea("SZ7")
		dbSetOrder(1)
		dbSeek(xFilial("SZ7") + __CUSERID + M->H6_LOCAL)

		If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
			l_Ret := .T.
		Else
			Help(NIL, NIL, "MOV_ARM", NIL, "O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + M->H6_LOCAL + ".",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Contacte o administrador do sistema."})
			l_Ret := .F.
		Endif

		If (M->H6_QTDPERDA > 0) .And. lSavePerda == .F.
			Help(NIL, NIL, "ERROR_CLAS", NIL, "Não foi realizada a Classificação da Perda da Produção PCP Mod2.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Efetue a Classificação da Perda antes de prosseguir."})
			l_Ret := .F.
		Endif

		If M->H6_QTDPERDA > 0 .And. M->H6_PT == "T"
			M->H6_PT := "P"
			l_Ret 	 := .F.
			Help(NIL, NIL, "ENC_OP", NIL, "Não é possível encerrar OP com apontamento de perda.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Primeiro deve-se apontar a perda, depois a produção para finalizar."})
		Else
			l_Ret :=.T.
		EndIf

		DBSELECTAREA('SB1')
		DBSETORDER(1)
		DBSEEK(XFILIAL('SB1') + M->H6_PRODUTO)
		ConOut('---->>>Achou produto')
			If SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID)
				nCount := SB1->B1_PRVALID
				Conout('------>Reservado a data de validade!')
			EndIf

		DBSelectArea('SC2')
		DbSetOrder(1)
		If DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3))
			If (Found()) .AND. Empty(M->H6_DTVALID) .AND. Empty(SC2->C2_FSDTVLD)
				M->H6_DTVALID := date() + nCount
				Conout('------>Primeiro Apontamento')
				RecLock('SC2',.F.)
					SC2->C2_FSDTVLD := date() + nCount
				SC2->(MsUnlock())
			Else
				M->H6_DTVALID := SC2->C2_FSDTVLD
			EndIf
		EndIf

		If M->H6_OPERAC =''
			Conout('------>OPERACAO CHEGOU VAZIO AQUI')
		EndIf
	EndIf

	RestArea(a_Area)

Return l_Ret
