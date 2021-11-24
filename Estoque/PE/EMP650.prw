#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMP650       � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Altera��o do Armaz�m de Empenho                            ���
���          � Este ponto de entrada � executado na rotina de inclus�o de ���
���          � OP, antes da apresenta��o da tela de empenhos. 			  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function EMP650
	/*
	N�o recebe par�metros, por�m neste momento o array aCols que � apresentado na altera��o de empenhos quando se abre uma Ordem de Produ��o est�
	dispon�vel para altera��es.	O aCols apresenta neste momento as linhas e colunas preenchidas, de acordo com o empenho padr�o a ser efetuado no 
	Sistema. Basta alterar ou incluir o conte�do deste array para alterar as informa��es dos empenhos. A estrutura b�sica do array aCols � 
	apresentada da seguinte forma na vers�o 2.07/5.08:
	 
	aCols[n,x] - Onde o n e o  n�mero da linha  e x pode ser:
	[1]  C�digo do Produto a ser empenhado
	[2]  Quantidade do empenho
	[3]  Almoxarifado do empenho
	[4]  Sequ�ncia do componente na estrutura (Campo G1_TRT)
	[5]  Sub-Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade do tipo "S")
	[6]  Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade)
	[7]  Data de validade do Lote (Somente deve ser preenchido se o  produto utilizar rastreabilidade)
	[8]  Localiza��o utilizada no empenho (Somente deve ser preenchido se o produto utilizar controle de localiza��o f�sica) 
	[9]  N�mero de S�rie (Somente deve ser preenchido se o produto utilizar controle de localiza��o f�sica)
	[10] 1a. Unidade de Medida do Produto
	[11] Quantidade do Empenho na 2a. Unidade de Medida
	[12] 2a. Unidade de Medida do Produto
	[13] Coluna com valor l�gico que indica se a linha est� deletada (.T.) ou n�o (.F.)
	*/
	
	Local c_Local  := ''
	Local n_RecTot := 0
	Local a_Area   := GetArea()

	c_Qry := " SELECT H1_FSLOCAL FROM " + RetSqlName("SC2") + " SC2 " + chr(13) + chr(10)
	c_Qry += " INNER JOIN " + RetSqlName("SG2") + " SG2 " + chr(13) + chr(10)
	c_Qry += " 		ON  G2_FILIAL = '" + xFilial("SG2") + "' " + chr(13) + chr(10)	
	c_Qry += "		AND G2_PRODUTO = C2_PRODUTO " + chr(13) + chr(10)              
	c_Qry += "      AND G2_CODIGO = C2_ROTEIRO " + chr(13) + chr(10)               
	c_Qry += " 		AND SG2.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)		
	c_Qry += " INNER JOIN " + RetSqlName("SH1") + " SH1 " + chr(13) + chr(10)
	c_Qry += " 		ON  H1_FILIAL = '" + xFilial("SH1") + "' " + chr(13) + chr(10)	
	c_Qry += " 		AND H1_CODIGO = G2_RECURSO " + chr(13) + chr(10)	
	c_Qry += " 		AND SH1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)	
	c_Qry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_NUM = '" + SC2->C2_NUM + "' " + chr(13) + chr(10)	
	c_Qry += " 		AND C2_FILIAL = '" + xFilial("SC2") + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_PRODUTO = '" + SC2->C2_PRODUTO + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_ITEM = '" + SC2->C2_ITEM + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_SEQUEN = '" + SC2->C2_SEQUEN + "' "
	
	TCQUERY c_Qry NEW ALIAS "QRY"

	dbSelectArea("QRY")
	Count To n_RecTot
	QRY->(dbGoTop())
	
	If n_RecTot > 0
		c_Local := QRY->H1_FSLOCAL
	Endif

	QRY->(dbCloseArea())   

	If !Empty(c_Local)
		For i:=1 To Len(aCols)
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2") + aCols[i][1] + c_Local)
				aCols[i][3] := c_Local
			Else
            	RecLock("SB2", .T.)
            	SB2->B2_FILIAL := XFILIAL("SB2")
            	SB2->B2_COD    := aCols[i][1]
            	SB2->B2_LOCAL  := c_Local
            	MsUnlock()

				aCols[i][3] := c_Local            	
			Endif
		Next
	Endif
	
	RestArea(a_Area)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A650LEMP     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Altera��o do Armaz�m de Empenho                            ���
���          � O ponto de entrada A650LEMP permite alterar o conte�do do  ���
���          � armaz�m gravado na linha do aCols do produto que gerar� 	  ���
���          � empenho/sc�s que faz parte da estrutura do produto pai. 	  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*
User Function A650LEMP
	Local a_Empenho := aClone(PARAMIXB)
	Local c_Local   := a_Empenho[3]
	Local n_RecTot  := 0

	c_Qry := " SELECT H1_FSLOCAL FROM " + RetSqlName("SC2") + " SC2 " + chr(13) + chr(10)
	c_Qry += " INNER JOIN " + RetSqlName("SG2") + " SG2 " + chr(13) + chr(10)
	c_Qry += " 		ON  G2_FILIAL = '" + xFilial("SG2") + "' " + chr(13) + chr(10)	
	c_Qry += "		AND G2_PRODUTO = C2_PRODUTO " + chr(13) + chr(10)              
	c_Qry += "      AND G2_CODIGO = C2_ROTEIRO " + chr(13) + chr(10)               
	c_Qry += " 		AND SG2.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)		
	c_Qry += " INNER JOIN " + RetSqlName("SH1") + " SH1 " + chr(13) + chr(10)
	c_Qry += " 		ON  H1_FILIAL = '" + xFilial("SH1") + "' " + chr(13) + chr(10)	
	c_Qry += " 		AND H1_CODIGO = G2_RECURSO " + chr(13) + chr(10)	
	c_Qry += " 		AND SH1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)	
	c_Qry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_NUM = '" + SC2->C2_NUM + "' " + chr(13) + chr(10)	
	c_Qry += " 		AND C2_PRODUTO = '" + SC2->C2_PRODUTO + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_ITEM = '" + SC2->C2_ITEM + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_SEQUEN = '" + SC2->C2_SEQUEN + "' "
	
	TCQUERY c_Qry NEW ALIAS "QRY"

	dbSelectArea("QRY")
	Count To n_RecTot
	QRY->(dbGoTop())
	
	If n_RecTot > 0
		If !Empty(QRY->H1_FSLOCAL)
			c_Local := QRY->H1_FSLOCAL
		Endif
	Endif

	QRY->(dbCloseArea())   

Return c_Local
*/
