/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบPrograma  ณA260GRV      บ Autor ณ AP6 IDE            บ Data ณ  28/09/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo da Transfer๊ncia	                                บฑฑ
ฑฑบ          ณ Apos confirmada a transferencia, antes de atualizar qualquer บฑฑ
ฑฑบ          ณ qualquer arquivo.Pode ser utilizado para validar o movimento บฑฑ
ฑฑบ          ณ ou atualizar o valor de alguma das variaveis disponiveis no  บฑฑ
ฑฑบ          ณ momento.  													บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function A260GRV

Local l_Ret    := .T.
Local c_Orig 			//Armazem de Origem
Local c_Dest   			//Armazem de Destino
Local c_Menu            //Nome do menu executado

If Upper(Funname()) <> "DLGV001" // inserido valida็ใo porque esse ponto de entrada gerava erro no coletor
	c_Orig   := cLocOrig								//Armazem de Origem
	c_Dest   := cLocDest  							//Armazem de Destino
	c_Menu   := Upper(NoAcento(AllTrim(FunDesc())))   //Nome do menu executado

 	If INCLUI .And. c_Menu == 'TRANSFERENCIAS'
		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7") + __CUSERID + c_Orig)
			If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Dest)
					If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
						l_Ret := .T.
					Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Dest + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Dest + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
				Endif
			Else
				ShowHelpDlg(SM0->M0_NOME,;
				{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Orig + "."},5,;
				{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME,;
			{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Orig + "."},5,;
			{"Contacte o administrador do sistema."},5)
			l_Ret := .F.
		Endif
	Endif
Endif
Return l_Ret