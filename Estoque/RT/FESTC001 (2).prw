#INCLUDE 'TOPCONN.CH'

//Rotina ainda nใo estแ sendo utilizada, pois gera falha ao utilizแ-la na consulta padrใo customizada SB1FS
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FESTC001   บAutor  ณ Christian Rocha    บ      ณ           บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta padrใo customizada para selecionar apenas os   	  บฑฑ
ฑฑบ          ณ produtos com arte e que possuem OPs previstas.	 		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rotina de Libera็ใo de OPs Previstas					      บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ                                         บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FESTC001(c_Produto)
	Local c_Ret := ''

	c_Qry := " SELECT B1_COD " + CHR(13)
	c_Qry += " FROM " + RETSQLNAME("SC2") + " SC2 " + CHR(13)
	c_Qry += " JOIN " + RETSQLNAME("SB1") + " SB1 ON B1_FILIAL = '" + XFILIAL("SB1") + "' " + CHR(13)
	c_Qry += " 	AND C2_PRODUTO = B1_COD AND B1_FSARTE = '1' AND SB1.D_E_L_E_T_ <> '*' " + CHR(13)
	c_Qry += " WHERE   " + CHR(13)
	c_Qry += "	C2_FILIAL = '" + XFILIAL("SC2") + "' AND C2_PRODUTO = '" + c_Produto + "' AND  " + CHR(13)
	c_Qry += "	C2_TPOP = 'P' AND  C2_SEQPAI = '000' AND C2_PEDIDO <> '' AND " 	 + CHR(13)
	c_Qry += "	SC2.D_E_L_E_T_ <> '*' " + CHR(13)
	c_Qry += " GROUP BY B1_COD "

	MemoWrit("C:\FESTC001.sql",c_Qry)

	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!Eof())
		c_Ret := c_Produto
	Else
		c_Ret := ''
	Endif
	QRY->(dbCloseArea())
Return c_Ret