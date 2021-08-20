#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEMP650       บ Autor ณ AP6 IDE            บ Data ณ  28/09/12บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera็ใo do Armaz้m de Empenho                            บฑฑ
ฑฑบ          ณ Este ponto de entrada ้ executado na rotina de inclusใo de บฑฑ
ฑฑบ          ณ OP, antes da apresenta็ใo da tela de empenhos. 			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EMP650
	/*
	Nใo recebe parโmetros, por้m neste momento o array aCols que ้ apresentado na altera็ใo de empenhos quando se abre uma Ordem de Produ็ใo estแ
	disponํvel para altera็๕es.	O aCols apresenta neste momento as linhas e colunas preenchidas, de acordo com o empenho padrใo a ser efetuado no 
	Sistema. Basta alterar ou incluir o conte๚do deste array para alterar as informa็๕es dos empenhos. A estrutura bแsica do array aCols ้ 
	apresentada da seguinte forma na versใo 2.07/5.08:
	 
	aCols[n,x] - Onde o n e o  n๚mero da linha  e x pode ser:
	[1]  C๓digo do Produto a ser empenhado
	[2]  Quantidade do empenho
	[3]  Almoxarifado do empenho
	[4]  Sequ๊ncia do componente na estrutura (Campo G1_TRT)
	[5]  Sub-Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade do tipo "S")
	[6]  Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade)
	[7]  Data de validade do Lote (Somente deve ser preenchido se o  produto utilizar rastreabilidade)
	[8]  Localiza็ใo utilizada no empenho (Somente deve ser preenchido se o produto utilizar controle de localiza็ใo fํsica) 
	[9]  N๚mero de S้rie (Somente deve ser preenchido se o produto utilizar controle de localiza็ใo fํsica)
	[10] 1a. Unidade de Medida do Produto
	[11] Quantidade do Empenho na 2a. Unidade de Medida
	[12] 2a. Unidade de Medida do Produto
	[13] Coluna com valor l๓gico que indica se a linha estแ deletada (.T.) ou nใo (.F.)
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA650LEMP     บ Autor ณ AP6 IDE            บ Data ณ  28/09/12บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera็ใo do Armaz้m de Empenho                            บฑฑ
ฑฑบ          ณ O ponto de entrada A650LEMP permite alterar o conte๚do do  บฑฑ
ฑฑบ          ณ armaz้m gravado na linha do aCols do produto que gerarแ 	  บฑฑ
ฑฑบ          ณ empenho/scดs que faz parte da estrutura do produto pai. 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
