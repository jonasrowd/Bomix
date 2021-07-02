/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �A260GRV      � Autor � AP6 IDE            � Data �  28/09/12  ���
���������������������������������������������������������������������������͹��
���Descricao � Valida��o da Transfer�ncia	                                ���
���          � Apos confirmada a transferencia, antes de atualizar qualquer ���
���          � qualquer arquivo.Pode ser utilizado para validar o movimento ���
���          � ou atualizar o valor de alguma das variaveis disponiveis no  ���
���          � momento.  													���
���������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                      ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function A260GRV

Local l_Ret    := .T.
Local c_Orig 			//Armazem de Origem
Local c_Dest   			//Armazem de Destino
Local c_Menu            //Nome do menu executado

If Upper(Funname()) <> "DLGV001" // inserido valida��o porque esse ponto de entrada gerava erro no coletor
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
						{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Dest + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Dest + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
				Endif
			Else
				ShowHelpDlg(SM0->M0_NOME,;
				{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Orig + "."},5,;
				{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME,;
			{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Orig + "."},5,;
			{"Contacte o administrador do sistema."},5)
			l_Ret := .F.
		Endif
	Endif
Endif
Return l_Ret