#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'

/*
�����������������������������������������������������������������������������
���Programa  � FFINA001   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para permitir a sele��o de arquivo no par�metro	  ���
���          � Arquivo de Entrada ? do grupo de perguntas FIN650(Rel	  ���
���          � Retorno Cnab). Para utilizar essa rotina � necess�rio criar���
���          � uma consulta espec�fica FSARQ1 com o campo Express�o = .T. ���
���          � e Retorno = U_FFINA001() e substitua o campo X1_F3 do grupo���
���          � de perguntas FIN650 do par�metro Arquivo de Entrada? com o ���
���          � nome da consulta espec�fica FSARQ1.						  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�����������������������������������������������������������������������������
*/

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_OVERWRITEPROMPT )

User Function FFINA001()

Local c_TipoArq := "*.*"
Local c_Local   := "C:\"
Local c_Ret     := ""

c_Ret := cGetFile(c_TipoArq, OemToAnsi("Abrir Arquivo..."), 0, c_Local, .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

Return c_Ret