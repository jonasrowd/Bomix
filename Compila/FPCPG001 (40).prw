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
/*
User Function FPCPG001
	Local c_Lote   := ''
	Local n_Seq    := 1

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
		If QRY->(!Eof()) .And. !Empty(QRY->H6_LOTECTL)		               //Se existir o maior lote, incrementa o sequencial com a vari�vel n_Seq
			n_Seq += Val(SubStr(QRY->H6_LOTECTL,9,2))
		Endif
		c_Lote := SubStr(M->H6_OP,1,8) + StrZero(n_Seq, 2, 0)	//O lote retornado ser� o n�mero da OP mais o sequencial

		dbCloseArea("QRY")
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)
*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_Qry     �Autor  �Microsiga           � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Query para selecionar o maior lote apontado da ordem de    ���
���          � produ��o atual.			                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*
Static Function f_Qry
	c_Qry := " SELECT MAX(H6_LOTECTL) H6_LOTECTL FROM " + RETSQLNAME("SH6") + " WHERE H6_LOTECTL LIKE '" + SubStr(M->H6_OP, 1, 8) + "%' AND " + CHR(13)
	c_Qry += " H6_FILIAL = '" + XFILIAL("SH6") + "' AND D_E_L_E_T_ <> '*' " + CHR(13)

	MemoWrit("C:\FPCPG001.sql",c_Qry)
Return c_Qry
*/
//#INCLUDE 'TOPCONN.CH'

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

/*
User Function FPCPG001
	Local c_Lote := ''
	Local c_Seq  := ""

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
		If QRY->(!Eof())                    //Se existir o maior lote, incrementa o sequencial com a vari�vel c_Seq
			c_Seq += QRY->Z3_SEQ
		Endif
		c_Lote := SubStr(M->H6_OP,1,6) + c_Seq	//O lote retornado ser� o n�mero da OP mais o sequencial

		dbCloseArea("QRY")
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)

Static Function f_Qry
	c_Qry := " SELECT MAX(Z3_SEQ) Z3_SEQ FROM " + RETSQLNAME("SZ3") + " WHERE Z3_NUMOP = '" + SubStr(M->H6_OP,1,11) + "' AND " + CHR(13)
	c_Qry += " Z3_FILIAL = '" + XFILIAL("SZ3") + "' AND D_E_L_E_T_ <> '*' " + CHR(13)

	MemoWrit("C:\FPCPG001.sql",c_Qry)
Return c_Qry
*/

//	Criado por Christian Rocha 21/02/2013 - Novo gatilho para o n�mero de lote
User Function FPCPG001
	Local c_Lote   := ''                                                                                                       
	Local c_Ano    := cValToChar(Year(M->H6_DATAFIN))
	Local n_Semana := 0

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
		If QRY->(!Eof())
			n_Semana := QRY->SEMANA
		Endif

		c_Lote := StrZero(n_Semana, 2, 0) + SB1->B1_GRUPO + c_Ano
		
		QRY->(dbCloseArea())
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrd)  
	dbGoTo(_nReg)

Return(c_Lote)

Static Function f_Qry
	c_Qry := " SELECT DATEPART(WEEK, '" + DTOS(M->H6_DATAFIN) + "') AS SEMANA "

	MemoWrit("C:\FPCPG001.sql",c_Qry)
Return c_Qry