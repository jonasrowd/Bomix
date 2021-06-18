/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A261TOK      � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o da Transfer�ncia Mod 2                           ���
���          � O ponto sera disparado no inicio da chamada da funcao de   ���
���          � validacao geral dos itens digitados. Serve para validar se ���
���          � o movimento pode ser efetuado ou nao.					  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A261TOK( )
	Local l_Ret    := .T.
	Local c_Orig   := ''									//Armazem de Origem
	Local c_Dest   := ''    								//Armazem de Destino
	Local c_Menu   := Upper(NoAcento(AllTrim(FunDesc())))   //Nome do menu executado

    If INCLUI .And. c_Menu == 'TRANSF. (MOD.2)'
		For i:=1 To Len(aCols)
		   	If aCols[i][Len( aHeader )+1] == .F.
				c_Orig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'ARMAZEM ORIG.' .And. Alltrim(x[2]) == 'D3_LOCAL'})]
				c_Dest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'ARMAZEM DESTINO' .And. Alltrim(x[2]) == 'D3_LOCAL'})]
		
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
								Exit
							Endif
						Else
							ShowHelpDlg(SM0->M0_NOME,;
							{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Dest + "."},5,;
							{"Contacte o administrador do sistema."},5)
							l_Ret := .F.
							Exit
						Endif
					Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Orig + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
						Exit
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Orig + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
					Exit
				Endif
			Endif
		Next
	Endif
Return l_Ret