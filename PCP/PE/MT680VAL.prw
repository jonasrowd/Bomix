#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados da Produção PCP Mod2
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return Logical, Bloqueia/libera a inclusão do apontamento de produção
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6089410
/*/
User Function MT680VAL
	Local a_Area := GetArea() // 
	Local l_Ret  := .T.       // 

	If l_Ret .And. l681
		DBSelectArea('SZ7')
		DBSetOrder(1)
		DBSeek(FwXFilial('SZ7') + __cUserId + M->H6_LOCAL)

		If !(Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A')
			l_Ret := .F.
			Help(NIL, NIL, 'MOV_ARM', NIL, 'O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém ' + M->H6_LOCAL + '.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Contacte o administrador do sistema.'})
		EndIf

		If (M->H6_QTDPERDA > 0) .And. !lSavePerda
			l_Ret := .F.
			Help(NIL, NIL, 'ERROR_CLAS', NIL, 'Não foi realizada a Classificação da Perda da Produção PCP Mod2.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Efetue a Classificação da Perda antes de prosseguir.'})
		EndIf

		If M->H6_QTDPERDA > 0 .And. M->H6_PT == 'T'
			l_Ret 	 := .F.
			M->H6_PT := 'P'
			Help(NIL, NIL, 'ENC_OP', NIL, 'Não é possível encerrar OP com apontamento de perda.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Primeiro deve-se apontar a perda, depois a produção para finalizar.'})
		EndIf
	EndIf

	RestArea(a_Area)
Return l_Ret
