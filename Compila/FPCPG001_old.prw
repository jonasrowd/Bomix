#INCLUDE 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FPCPG001   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para gerar o lote sequencial da ordem de produ��o, ���
���          � caso o produto tenha rastreabilidade.					  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FPCPG001
	Local c_Lote := ''
	Local n_Seq  := 1

	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'				//Verifica se o produto possui rastreabilidade
		c_Qry := f_Qry()                    //Chama a fun��o para selecionar o lote de maior sequencial da OP

		TCQUERY c_Qry NEW ALIAS QRY
		dbSelectArea("QRY")
		dbGoTop()
		If QRY->(!Eof())                    //Se existir o maior lote, incrementa o sequencial com a vari�vel n_Seq
			n_Seq += Val(SubStr(QRY->H6_LOTECTL,7,3))
		Endif
		c_Lote := SubStr(M->H6_OP,1,6) + StrZero(n_Seq, 3, 0)	//O lote retornado ser� o n�mero da OP mais o sequencial

		dbCloseArea("QRY")
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)

Static Function f_Qry
	c_Qry := " SELECT MAX(H6_LOTECTL) H6_LOTECTL FROM " + RETSQLNAME("SH6") + " WHERE H6_LOTECTL LIKE '" + SubStr(M->H6_OP, 1, 6) + "%' AND " + CHR(13)
	c_Qry += " H6_FILIAL = '" + XFILIAL("SH6") + "' AND D_E_L_E_T_ <> '*' " + CHR(13)

	MemoWrit("C:\FPCPG001.sql",c_Qry)
Return c_Qry