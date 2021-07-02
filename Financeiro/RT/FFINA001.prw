#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณ FFINA001   บAutor  ณ Christian Rocha    บ      ณ           บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para permitir a sele็ใo de arquivo no parโmetro	  บฑฑ
ฑฑบ          ณ Arquivo de Entrada ? do grupo de perguntas FIN650(Rel	  บฑฑ
ฑฑบ          ณ Retorno Cnab). Para utilizar essa rotina ้ necessแrio criarบฑฑ
ฑฑบ          ณ uma consulta especํfica FSARQ1 com o campo Expressใo = .T. บฑฑ
ฑฑบ          ณ e Retorno = U_FFINA001() e substitua o campo X1_F3 do grupoบฑฑ
ฑฑบ          ณ de perguntas FIN650 do parโmetro Arquivo de Entrada? com o บฑฑ
ฑฑบ          ณ nome da consulta especํfica FSARQ1.						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_OVERWRITEPROMPT )

User Function FFINA001()

Local c_TipoArq := "*.*"
Local c_Local   := "C:\"
Local c_Ret     := ""

c_Ret := cGetFile(c_TipoArq, OemToAnsi("Abrir Arquivo..."), 0, c_Local, .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

Return c_Ret