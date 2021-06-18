#Include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma 矼T103IPC 篈utor 矱lisangela Souza 		� Data � 18/10/13  	  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc. � PE para gravar informa珲es do PC na nota de entrada.           罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so � SIGACOM														  罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
	If SB1->B1_LOCALIZ = "S"  // Produto tem controle de endere鏾
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