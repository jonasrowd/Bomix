/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � FPCPV001   篈utor  � Christian Rocha    �      �           罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Rotina para validar o tipo de ordem de produ玢o selecionada罕�
北�          � na rotina MRP.									 		  罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�          �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function FPCPV001(n_TipoOP)

If n_TipoOP == 1
	ShowHelpDlg(SM0->M0_NOME,;
				{"Ordens de produ玢o firmes est鉶 bloqueadas nessa rotina."},5,;
				{"Contacte o administrador do sistema."},5)
	MV_PAR10 := 2
	l_Ret    := .F.
Else
	l_Ret := .T.
Endif

Return l_Ret