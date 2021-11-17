//Bibliotecas
#include "Ap5Mail.ch"
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
#Include 'FWMVCDef.ch'
#include "vkey.ch"
#include "TOTVS.CH"
#include "TbiConn.ch"
#include 'FONT.CH'
#include 'COLORS.CH'
#include 'apvt100.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFW120P   ºAutor  ³FRANCISCO REZENDE   º Data ³  16/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na inclusao/alteracao do pedido de compra º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º08/05/2009ºFrancisco Rezende ºCriado a funcao TGENEMAILAPRV(). Retorna º±±
±±º          º                  ºo e-mail dos aprovadores.                º±± 
±±º29/10/2009ºElilton Ferreira  ºAdicionado informação dos aprovadores    º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WFW120P()
Local a_SC7Area	:= SC7->(GetArea())
Local a_SC8Area	:= SC8->(GetArea())
Local a_SA2Area	:= SA2->(GetArea())
Local a_SCRArea	:= SCR->(GetArea())
Local a_SALArea	:= SAL->(GetArea())
Local a_SE4Area	:= SE4->(GetArea())
Local a_Area	:= GetArea()
Local c_Pedido	:= SC7->C7_NUM
Local c_Grupo	:= ""
Local c_Rotina	:= FunName()
Local l_Ret 	:= Findfunction("U_PCOMA032") //Diligenciamento
If l_Ret
	U_PCOMA032(c_Pedido, c_Rotina) // Usado para enviar e-mail para os aprovadores do primeiro nivel.
Endif

l_Ret 	:= Findfunction("U_FCOMA002") //integração fluig - inclusao pc
If l_Ret
	IF INCLUI
		
	/*	f_QrySCR( c_Pedido )

		While QRYSCR->(!EoF())
		
			c_Grupo	:= QRYSCR->CR_GRUPO
			
			//U_FCOMA002( .T., c_Grupo )
		
			QRYSCR->(DbSkip())		
				
		EndDo
		QRYSCR->(DBCLOSEAREA())*/
	ENDIF
Endif

RestArea( a_SC7Area )
RestArea( a_SC8Area )
RestArea( a_SA2Area )
RestArea( a_SE4Area )
RestArea( a_SCRArea )
RestArea( a_SALArea )
RestArea(a_Area)

Return


Static Function f_QrySCR( c_Pedido )

	Local c_Qry := ""

    c_Qry += " SELECT CR_GRUPO FROM "+RETSQLNAME("SCR")+ " WHERE CR_NUM = '" + c_Pedido + "'  AND CR_FILIAL = '"+xFilial("SCR")+"' AND D_E_L_E_T_ <> '*' GROUP BY CR_GRUPO"
    
	
	TCQUERY c_Qry NEW ALIAS "QRYSCR"

Return()
