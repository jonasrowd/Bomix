/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � A710PAR    篈utor  � Christian Rocha    �      �           罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � O ponto de entrada A710PAR permite alterar a parametriza玢o罕�
北�          � inicial do MRP.									 		  罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   罕�
北�          � Este ponto de entrada est� sendo utilizado para impedir a  贡�
北�          � utiliza玢o de OPs Firmes na rotina MRP.                    罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�          �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function A710PAR()

Local _nTipPer  := Paramixb[1]
Local _nQuantPer:= Paramixb[2]
Local _a711Tipo := Paramixb[3]
Local _a711Grupo:= Paramixb[4]
Local _lPedido  := Paramixb[5]
Local aRet      := {}

aadd(aRet,{_nTipPer ,_nQuantPer,_a711Tipo,_a711Grupo,_lPedido})

DbSelectArea("SX1")
DbGoTop()
DbSeek("MTA712    ")
While !Eof() .And. X1_GRUPO == "MTA712    "
	If X1_ORDEM == "10"
		RecLock("SX1", .F.)
	 		X1_VALID  := "EXECBLOCK(U_FPCPV001(MV_PAR10))"
	 		X1_PRESEL := 2
		MsUnLock()
		Exit
	Endif
	
	DbSkip()
Enddo

Return aRet