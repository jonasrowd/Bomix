
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function MT103PN 
LOCAL lRet  := .T. 
LOCAL CHAVE := M->F1_CHVNFE

IF CHAVE = " "
   MsgBox("Tipo Nota Fiscal = SPED, sem a chave da Nota Fiscal, inclusao nao permitida !!!")     
   lRet  := .F.
EndIf                

Return lRet 