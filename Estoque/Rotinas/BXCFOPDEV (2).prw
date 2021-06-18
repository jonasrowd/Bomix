#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � BXCFOPDEV  �Autor �TBA001 -XXX     � Data �  19/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gravar os CFOPs de devolu��o							      ���
�������������������������������������������������������������������������͹��
���Uso       � BXCFOPDEV	  	                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function BXCFOPDEV()

Local c_CFOP := space(250)

c_CFOP := GetMV("MV_DEVCFOP")+space(250-len(trim(GetMV("MV_DEVCFOP"))))

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Alterar/Adicionar CFOP's de Devolu��o") FROM 0,0 TO 250,700 PIXEL
	@ 010, 010 Say OemToAnsi(" Para NF Devolucao na versao 3.10, permitido informa. CFOP diferente do Anexo XI.01 da NT 2013.005.v1.03 ") PIXEL
	@ 020, 010 Say OemToAnsi(" para ser gerada tag finnfe igual a 1 (normal).   ") PIXEL
	@ 060, 010 Say OemToAnsi(" Devem ser informados separados por ';'      ") PIXEL
	@ 057, 130 MSGET c_CFOP SIZE 200,15 Picture "@!" OF oDlg PIXEL
	@ 100, 130 BUTTON "&Salvar" SIZE 40,15 PIXEL ACTION CFOP_Grava(c_CFOP)
	@ 100, 180 BUTTON "&Fechar" SIZE 40,15 PIXEL ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTERED

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CFOP_Grava( c_CFOP )

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(space(6) + "MV_DEVCFOP")
	RecLock("SX6",.F.)
		X6_CONTEUD := AllTrim(c_CFOP)
	MsUnlock()
	MsgBox("Conte�do modificado com sucesso." , "Aten��o", "INFO")
EndIf

Return