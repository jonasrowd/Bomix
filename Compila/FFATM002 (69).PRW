#INCLUDE "TOPCONN.CH"

User Function FFATM002   

//testa filial atual
a_Area := GetArea()
c_OP   := ""


private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return(c_OP)
endif

////////


c_Qry := "SELECT C6_NUMOP FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM = '" + SC5->C5_NUM + "' "
c_Qry += " AND C6_NUMOP <> '' AND D_E_L_E_T_ <> '*' "

TCQuery c_Qry New Alias QRY
dbSelectArea("QRY")
dbGoTop()
If QRY->(!Eof())
	c_OP := QRY->C6_NUMOP
Endif

QRY->(dbCloseArea())

RestArea(a_Area)

Return(c_OP)