#include "rwmake.ch" 
#include "TbiConn.ch"
/*******************************************************************************************************/
/* Programa : F090MTBX (Baixa Pagar motivo de Baixa)		                                           */
/* Data     : 30/11/2015                                                                               */
/* Descrição: Bloquar o motivo de Baixa Dação para alguns usuários e liberar para outros			   */
/* Autor    : TBA001 -XXX												                       */ 
/*O ponto de entrada F080MTBX sera executado na validacao do GET do motivo da baixa do contas a receber*/
/*,na tela de baixa de titulos.																		   */	
/*******************************************************************************************************/
User Function F080MTBX()   

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
		If GrupoUsuario$"000030/000031/000063/000000/000032"
			lGFin := .T.
		EndIf
	Endif
    

EndIF 
	If   !lGFin
		MsgAlert("DAÇÃO é uma baixa que não pode ser realizada por este usuário!")	
		lRet := .F.
	Endif
Endif

Return lRet
