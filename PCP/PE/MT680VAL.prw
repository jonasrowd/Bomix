#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados da Produ��o PCP Mod2
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
			Help(NIL, NIL, "MOV_ARM", NIL, "O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + M->H6_LOCAL + ".",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Contacte o administrador do sistema."})
			l_Ret := .F.
		Endif

		If (M->H6_QTDPERDA > 0) .And. lSavePerda == .F.
			Help(NIL, NIL, "ERROR_CLAS", NIL, "N�o foi realizada a Classifica��o da Perda da Produ��o PCP Mod2.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Efetue a Classifica��o da Perda antes de prosseguir."})
			l_Ret := .F.
		Endif

		If M->H6_QTDPERDA > 0 .And. M->H6_PT = "T"
			M->H6_PT := "P"
			l_Ret 	 := .F.
			Help(NIL, NIL, "ENC_OP", NIL, "N�o � poss�vel encerrar OP com apontamento de perda.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Primeiro deve-se apontar a perda, depois a produ��o para finalizar."})
		Else
			l_Ret :=.T.
		EndIf
	EndIf

	RestArea(a_Area)

Return l_Ret
