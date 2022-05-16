#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT380INC
	Validação de Ajuste de Empenho Ponto de Entrada, localizado na validação de Ajuste Empenho, 
	utilizado para confirmar ou não a gravação.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 28/10/2021
	@return logical, l_Ret
/*/
User Function MT380INC()
	Local c_Local := ''
	Local l_Ret   := .T.
	Local c_Menu  := Upper(NoAcento(AllTrim(FunDesc())))  //Nome do menu executado

	If (INCLUI .Or. ALTERA) .And. c_Menu == 'AJUSTE DE EMPENHOS'
		c_Local := M->D4_LOCAL

		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
			If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
				l_Ret := .T.
			Else
				l_Ret := .F.
			Endif
		Else
			l_Ret := .F.
		Endif
	Endif

	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME,;
		{"O seu usuário não possui permissão para efetuar saídas no armazém " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif

	D4_FSDSC := SB1->B1_DESC
	D4_FSTP  := SB1->B1_BRTPPR

Return l_Ret
