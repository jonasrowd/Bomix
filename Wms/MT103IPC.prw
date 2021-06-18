#Include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³MT103IPC ºAutor ³Elisangela Souza 		º Data ³ 18/10/13  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ PE para gravar informações do PC na nota de entrada.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ SIGACOM														  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MT103IPC()

Local a_Area	:= GetArea()
Local _cProduto := aScan(aHeader,{|x| Alltrim(x[2])=="D1_COD"})
Local _cTes 	:= aScan(aHeader,{|x| Alltrim(x[2])=="D1_TES"})
Local _cServ    := aScan(aHeader,{|x| Alltrim(x[2])=="D1_SERVIC"})
Local _cRWms    := aScan(aHeader,{|x| Alltrim(x[2])=="D1_REGWMS"}) 
Local _nCols 	:= Len(aCols)
Local c_Local   := aCols[_nCols][aScan(aHeader,{|x| Alltrim(x[2])=="D1_LOCAL"})]
Local c_LocalCD := Getmv("BM_LOCALCD")

DbSelectArea("SB1")
SB1->( DbSetorder(1) )
If SB1->( DbSeek(xFilial("SB1")+aCols[_nCols][_cProduto] ))
	If SB1->B1_LOCALIZ = "S"  // Produto tem controle de endereço
		DbSelectArea("SF4")
		SF4->( DbSetorder(1) )
		If SF4->( DbSeek(xFilial("SF4")+aCols[_nCols][_cTES] ))
			If SF4->F4_ESTOQUE = "S" // Tes tem controle de estoque
				DbSelectArea("SB5")
				SB5->( DbSetorder(1) )
				If SB5->( DbSeek(xFilial("SB5")+aCols[_nCols][_cProduto] )) // Verifica se existe o produto na tabela de complemento
					If c_Local $ c_LocalCD
						aCols[_nCols][_cServ] := SB5->B5_FSSVECD
						aCols[_nCols][_cRWms] := "3"					
					Else
						aCols[_nCols][_cServ] := SB5->B5_SERVENT 
						aCols[_nCols][_cRWms] := "3"					
					Endif
				Endif	
		    Endif
		Endif
    Endif
Endif

RestArea(a_Area)

Return(.T.)