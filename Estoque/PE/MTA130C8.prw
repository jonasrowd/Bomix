#INCLUDE "PROTHEUS.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矼TA130C8  篈utor  砏elington Junior   � Data 砄utubro/2012  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯贡�
北篋esc.     砅onto de entrada utilizado para preencher o nome fantasia do罕�
北�          砫o fornecedor na SC8 - Campo customizado C8_NREDUZ          罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Compras                                                    罕�
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北�                     A L T E R A C O E S                               罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�          �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function MTA130C8()

Local cFantasia
Local a_Area := GetArea()

DbSelectArea("SA2")
DbSetOrder(1)
If DbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA)
	cFantasia := SA2->A2_NREDUZ
	
	DbSelectArea("SC8")
	RecLock("SC8",.F.)
		SC8->C8_NREDUZ := cFantasia
	MsUnLock()
Endif

RestArea(a_Area)

Return Nil