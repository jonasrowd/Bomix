/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410PVNF   � Autor � Christian Rocha    � Data �			  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para validar a gera��o do documento de    ���
���          � sa�da													  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT													  ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410PVNF     


	Local c_Prefixo := IIF(cFilAnt == "010101", "ABT", "ABST")
	Local a_Area    := GetArea()
	Local l_Ret     := .T.


//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   Return(l_Ret)
endif

////////






	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6") + SC5->C5_NUM)
	While SC6->(!EoF()) .And. SC6->(C6_FILIAL + C6_NUM) == xFilial("SC6") + SC5->C5_NUM
		If Substr(SC6->C6_PRODUTO, 1, 1) $ c_Prefixo
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1") + SC6->C6_PRODUTO)
				If SB1->B1_PESO == 0
					If SB1->B1_TIPO == "SU" .And. cFilAnt == "020101"
						l_Ret := .T.
                    Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"Cadastro do Produto " + AllTrim(SC6->C6_PRODUTO)  + " foi efetuado sem o preenchimento da informa��o de Peso L�quido."},5,;
						{"Contacte o respons�vel pelo cadastro de produtos e solicite o preenchimento do campo Peso L�quido."},5)
						l_Ret := .F.
						Exit
					Endif
				Endif
			Endif
        Endif

        SC6->(dbSkip())
	End

	RestArea(a_Area)
Return l_Ret