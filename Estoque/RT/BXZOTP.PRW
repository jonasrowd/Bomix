#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � BXZOTP     �Autor �TBA001 -XXX     � Data �  02/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Plus Produtos - Bomix.						  ���
�������������������������������������������������������������������������͹��
���Uso       � BXZOTP			                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function BXZOTP

	Local cTitulo:="Tipos"
	Local MvPar
	Local MvParDef:=""
	
	Private aSit:={}
	
	l1Elem  := .F.
//	VAR_IXB := "************   "
	
	cAlias := Alias() 					 // Salva Alias Anterior

	MvPar   := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	MvRet   := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
  //	VAR_IXB := MvPar
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSEEK(xFilial("SX5")+"XT")
	CursorWait()
		While !Eof().AND. TRIM(SX5->X5_TABELA) == "XT"
				Aadd(aSit, TRIM(SX5->X5_CHAVE) + " - " + Alltrim(SX5->X5_DESCRI))
				MvParDef += TRIM(SX5->X5_CHAVE)
			dbSkip()
		EndDo
	CursorArrow()
		DBGOTOP()
	IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem,2)  // Chama funcao f_Opcoes
		VAR_IXB := MvPar
		//&MvRet := MvPar                                                                          // Devolve Resultado
	EndIF	

	dbSelectArea(cAlias) 								 // Retorna Alias
	
Return .T.
