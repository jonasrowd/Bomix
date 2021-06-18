#include 'protheus.ch'
#include 'parmtype.ch'

user function MT410TOK()

	Local l_Ret    := .T.
	Local a_Area   := GetArea()
	IF M->C5_FSESPEC  = '' .AND. xFilial("SC5")<>'030101'
		ShowHelpDlg(SM0->M0_NOME, {"O campo (Especifidade) deve ser preenchido."},5,;
		{"Preencha corretamente."},5)
		l_Ret    := .F.
		Return Nil
	EndIf
	RestArea(a_Area)
Return l_Ret     	
