#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � FFINA001   篈utor  � Christian Rocha    �      �           罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Rotina para permitir a sele玢o de arquivo no par鈓etro	  罕�
北�          � Arquivo de Entrada ? do grupo de perguntas FIN650(Rel	  罕�
北�          � Retorno Cnab). Para utilizar essa rotina � necess醨io criar罕�
北�          � uma consulta espec韋ica FSARQ1 com o campo Express鉶 = .T. 罕�
北�          � e Retorno = U_FFINA001() e substitua o campo X1_F3 do grupo罕�
北�          � de perguntas FIN650 do par鈓etro Arquivo de Entrada? com o 罕�
北�          � nome da consulta espec韋ica FSARQ1.						  罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�          �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_OVERWRITEPROMPT )

User Function FFINA001()

Local c_TipoArq := "*.*"
Local c_Local   := "C:\"
Local c_Ret     := ""

c_Ret := cGetFile(c_TipoArq, OemToAnsi("Abrir Arquivo..."), 0, c_Local, .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

Return c_Ret