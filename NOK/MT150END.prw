#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"  
#INCLUDE "PRTOPDEF.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矼T150OK  篈utor  砊IAGO PITA   	       � Data 矨GOSTO/2011罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     砅onto de Entrada para inclus鉶 de observa玢o no momento da  罕�
北�          砮xclusao de um item da cota玢o                              罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGACOM                                                    罕�
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北�                     A T U A L I Z A C O E S                           罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯退屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ATA      篈NALISTA           篈LTERACOES                              罕�
北�          �                   �                                        罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

//User Function MT150END()

//Local nOpcx := Paramixb[1]
//Local lRet  := .T.

/*If nOpcx=3
	For i:=1 to Len(aCols)
		If aCols[i][Len(aHeader)+1] == .F. .AND. !Empty(aCols[i][1])
			If aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == "C8_PRECO"})]>0
				_qry := " UPDATE SC8010 SET C8_TBMOT =  '', C8_TBDATA='' WHERE C8_NUM = '" + SC8->C8_NUM+ "' AND D_E_L_E_T_ <> '*' AND C8_PRODUTO='"+SC8->C8_PRODUTO+"' "
				TCSQLExec(_qry)
			Endif
		Endif
	Next
Endif */

//Return lRet