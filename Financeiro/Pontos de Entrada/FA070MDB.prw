#include "rwmake.ch" 
#include "TbiConn.ch"
/*******************************************************************************************************/
/* Programa : FA070MDB (Baixa Receber motivo de Baixa)		                                           */
/* Data     : 30/11/2015                                                                               */
/* Descri��o: Bloquar o motivo de Baixa Da��o para alguns usu�rios e liberar para outros			   */
/* Autor    : TBA001 -XXX												                       */ 
/*O ponto de entrada FA070MDB sera executado na validacao do GET do motivo da baixa do contas a receber*/ 
/*na tela de baixa de titulos																	        */	
/*******************************************************************************************************/
User Function FA070MDB()

Local lRet 	  := .T.   
Local lGFin   := .F.
Local lAchou  := PSWSeek(__cUserId,.T.)
PswOrder(1)

If  Alltrim(UPPER(cMotBx)) = 'DACAO'

If lAchou
	aUserFl      := PswRet(1)
	IdUsuario    := aUserFl[1][1]      	// codigo do usuario
	NomeUsuario  := aUserFl[1][4]      	// nome do usuario
	EmailUsuario := aUserFl[1][14]     	// Email
    If len(aUserFl[1][10]) >= 1
    	GrupoUsuario := aUserFl[1][10][1]   // Grupo Que o usuario Pertence   
		If GrupoUsuario$"000001/000067/000000"
			lGFin := .T.
		EndIf
	Endif

EndIF 
	If   !lGFin
		MsgAlert("DA��O � uma baixa que n�o pode ser realizada por este usu�rio!")	
		lRet := .F.
	Endif
Endif

Return lRet