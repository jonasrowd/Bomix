
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'

User Function MOVINT()

Local a_Area  := GetArea()
Local l_Ret   := M->D3_TM
Local c_Users := Getmv("MV_MOVINT")

                         
msgbox(c_Users)
msgbox(__CUSERID)

If __CUSERID $ c_Users
	//		l_Ret := "  "
Else
	ShowHelpDlg(SM0->M0_NOME,;
	{"O seu usuário não possui permissão para acesso a esta rotina."},5,;
  	{"Contacte o administrador do sistema."},5)     
	l_Ret := "   "  	
Endif
RestArea(a_Area)
Return l_Ret
                



