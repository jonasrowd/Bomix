#include 'Totvs.ch'
/*
**Ponto de entrada para criação de campo
**no cabeçalho do pedido de compras
**Autor: Ronaldo Cassiano Lopes Alves
*/
User Function MT120TEL()

	Local oNewDialog  := PARAMIXB[1]
	Local aPosGet 	  := PARAMIXB[2]
	Local aObj 		  := PARAMIXB[3]
	Local nOpcx 	  := PARAMIXB[4]
	Public cTransp	  := ""
	Public cEntrega	  := ""
	Public cProposta  := ""
	Public cProjeto	  := ""
	
	If nOpcx = 3
	
		cTransp 	:= Space(3)
		cEntrega 	:= Space(199)
		cProposta	:= Space(15)
		cProjeto	:= Space(30)
	Else
	
		cTransp   := SC7->C7_TRANSP
		cEntrega  := SC7->C7_ENTREGA
		cProposta := SC7->C7_PROPOS
		cProjeto  := SC7->C7_PROJETO 
		
	EndIf
	@ 045,020 SAY "Transportadora" OF oNewDialog PIXEL SIZE 060,006
	@ 045,85 MSGET cTransp PICTURE PesqPict("SC7","C7_TRANSP") F3 CpoRetF3('C7_TRANSP','SA4') OF oNewDialog PIXEL SIZE 040,006
	@ 046,134 SAY "L. entrega" OF oNewDialog PIXEL SIZE 050, 008
	@ 045,167 MSGET cEntrega PICTURE PesqPict("SC7", "C7_ENTREGA") OF oNewDialog PIXEL SIZE 199, 006
	@ 046,370 SAY "Proposta" OF oNewDialog PIXEL SIZE 050, 008
	@ 045,400 MSGET cProposta PICTURE PesqPict("SC7", "C7_PROPOS") OF oNewDialog PIXEL SIZE 055, 006
	@ 046,470 SAY "Projeto" OF oNewDialog PIXEL SIZE 050, 008
	@ 045,490 MSGET cProjeto PICTURE PesqPict("SC7", "C7_PROJETO") OF oNewDialog PIXEL SIZE 075, 006
	
Return(.T.)

