/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A415LIOK     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o do Item do Or�amento                             ���
���          � Este ponto de entrada � executado na mudan�a de linha do   ���
���          � or�amento de venda. Ele pode ser utilizado para valida��o. ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A415LIOK   



	Local c_Alias   := Alias()
	Local c_Ord     := IndexOrd()
	Local n_Reg     := Recno()
	Local c_Local   := TMP1->CK_LOCAL
	Local l_Ret 	:= .T.

//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   Return l_Ret
endif

////////





   	If TMP1->CK_FLAG == .F.
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

   
   // ALTERA��O FEITA PARA ATENDER O WMS 06/03/2019 -WELLINGTON
    
    l_Ret := .T.           


	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME,;
		{"O seu usu�rio n�o possui permiss�o para efetuar sa�das no armaz�m " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif

	dbSelectArea(c_Alias)
	dbSetOrder(c_Ord)  
	dbGoTo(n_Reg)

Return l_Ret