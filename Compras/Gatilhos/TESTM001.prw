#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESTM001     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para gerar o c�digo do produto                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TESTM001
	a_Area   := GetArea()
	c_Grupo  := M->B1_GRUPO
	c_Codigo := M->B1_COD
	
	If INCLUI
		c_Qry := " SELECT MAX(SUBSTRING(B1_COD, 5, 5)) MAXSEQ FROM " + RetSqlName("SB1") + " SB1 " + chr(13) + chr(10)
		c_Qry += " WHERE SB1.D_E_L_E_T_ <> '*' AND B1_GRUPO = '" + M->B1_GRUPO + "' " + chr(13) + chr(10)	
		c_Qry += " AND B1_FILIAL = '" + XFILIAL("SB1") + "' "
		
		TCQUERY c_Qry NEW ALIAS "QRY"
	
		dbSelectArea("QRY")
		QRY->(dbGoTop())
		If QRY->(EoF())
			c_Seq := "00001"
		Else
			c_Seq := StrZero(Val(QRY->MAXSEQ) + 1, 5)
		Endif
		
		QRY->(dbCloseArea())		
		
		c_Codigo := c_Grupo + c_Seq
	Endif

	RestArea(a_Area)
Return c_Codigo