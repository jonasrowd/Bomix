/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LIOK     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o do Item do Pedido de Venda                       ���
���          � Este ponto de entrada � executado na mudan�a de linha do   ���
���          � pedido de venda. Ele pode ser utilizado para valida��o.    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410LIOK
	Local c_Local := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_LOCAL' })]
	Local l_Ret   := .T.
                    
	If INCLUI .Or. ALTERA
	   	If aCols[n][Len( aHeader )+1] == .F.
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
	Endif

	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME,;
		{"O seu usu�rio n�o possui permiss�o para efetuar sa�das no armaz�m " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif	
Return l_Ret