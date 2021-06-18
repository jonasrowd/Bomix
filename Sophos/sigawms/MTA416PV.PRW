#Include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³MTA416PV ºAutor ³Elisangela Souza 		º Data ³ 18/10/13  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ PE para gravar informações do PC na nota de entrada.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ SIGACOM														  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MTA416PV()

Local a_Area	:= GetArea()  
Local nAux      := PARAMIXB 
Local _nProduto := aScan(_aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"})
Local _nTes 	:= aScan(_aHeader,{|x| Alltrim(x[2])=="C6_TES"})
Local _nServ    := aScan(_aHeader,{|x| Alltrim(x[2])=="C6_SERVIC"})
Local _nRWms    := aScan(_aHeader,{|x| Alltrim(x[2])=="C6_REGWMS"}) 
                        
DbSelectArea("SB1")
SB1->( DbSetorder(1) )
If SB1->( DbSeek(xFilial("SB1")+_aCols[nAux,_nProduto]))
	If SB1->B1_LOCALIZ = "S"  // Produto tem controle de endereço
		DbSelectArea("SF4")
		SF4->( DbSetorder(1) )
		If SF4->( DbSeek(xFilial("SF4")+_aCols[nAux,_nTes] ))
			If SF4->F4_ESTOQUE = "S" // Tes tem controle de estoque
				DbSelectArea("SB5")
				SB5->( DbSetorder(1) )
				If SB5->( DbSeek(xFilial("SB5")+_aCols[nAux,_nProduto] )) // Verifica se existe o produto na tabela de complemento
					_aCols[nAux,_nServ] :=  SB5->B5_SERVSAI
					_aCols[nAux,_nRWms] := "3"
				Else
					_aCols[nAux,_nRWms] := ""
				Endif	
			Else
				_aCols[nAux,_nRWms] := ""
		    Endif
		Endif
	Else
		_aCols[nAux,_nRWms] := ""
    Endif
Endif

RestArea(a_Area)

Return Nil