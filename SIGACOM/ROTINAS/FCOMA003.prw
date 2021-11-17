/*/{Protheus.doc} FCOMA003
//CHAMADO DO PE: MTALCDOC.PRW - aciona cancelamento de pedido de compras no fluig
@author carlo
@since 27/10/2019
@version 1.0
@return ${return}, ${return_description}


@type function
/*/

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

User Function FCOMA003()

	Local oServico						:= WSECMWorkflowEngineServiceService():New()
	Local cUsername						:= SuperGetMV("FS_FLGUSER",.F.,"bomix")
	Local cPassword						:= SuperGetMV("FS_FLGPASS",.F.,"bomix@2019")
	Local nCompanyId					:= 1
	Local cProcessId					:= Iif(SC7->(FieldPos("C7_FSFLUIG"))>0, SC7->C7_FSFLUIG, 0)
	Local nCancelText					:= "Processo cancelado automaticamente através da alteração do pedido de compra."
	Local cUserId						:= ""
	
	f_QryFluig(SC7->C7_NUM)
	
	
	While QRYFLG->(!EoF())
	
		cProcessId := QRYFLG->C7_FSFLUIG
	
		cUserId	:= f_UsuFluig(cValToChar(cProcessId))
		
		if(QRYFLG->C7_FSFLUIG <> 0)
			if oServico:cancelInstance(cUsername,cPassword,nCompanyId,cProcessId,cUserId,nCancelText)
				if oServico:cresult <> "OK"
					alert("Falha no Fluig ->"+ oServico:cresult)
				endif
				
				f_GravaInf(cValToChar(QRYFLG->C7_FSFLUIG))	
			else
				alert("Erro de Execução ->"+GetWSCError())
			endif
		endif
		
		QRYFLG->(DbSkip())
	enddo
	QRYFLG->(DBCLOSEAREA())

Return()

Static Function f_QryFluig( c_Num )

	Local c_Qry := ""

	c_Qry += " SELECT DISTINCT C7_FSFLUIG FROM "+RETSQLNAME("SC7")+ " SC7 WHERE C7_NUM = '" + c_Num + "'   AND C7_FILIAL = '"+xFilial("SC7")+"' ""
	
	TCQUERY c_Qry NEW ALIAS "QRYFLG"

Return()

Static Function f_GravaInf(c_Num)

Local c_Qry

c_Qry := "UPDATE "+RetSQLName("SC7")+" "
c_Qry += "SET C7_FSFLUIG = 0 "
c_Qry += "WHERE D_E_L_E_T_<>'*' AND C7_FILIAL = '"+xFilial("SC7")+"' "
c_Qry += "AND C7_FSFLUIG = '"+c_Num+"'  "

TCSQLEXEC(c_Qry)

Return


Static Function f_UsuFluig( c_Chave )

	Local c_UsrFluig	:=	SuperGetMV("FS_FLGID",.F.,"bomix")
	Local c_Qry			:=	""
	Local c_AliasFl		:=	GetNextAlias()

	Default c_Chave		:=	""
	
	c_Qry	:=	"SELECT TOP 1 CD_MATRICULA FROM fluigdb.dbo.TAR_PROCES WHERE NUM_PROCES = "+c_Chave+" AND NUM_SEQ_MOVTO =	1 "
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_AliasFl, .T., .T.)
	(c_AliasFl)->(dbGoTop())
	If (c_AliasFl)->(!Eof())
		c_UsrFluig := (c_AliasFl)->CD_MATRICULA 
	Endif
	(c_AliasFl)->(dbCloseArea())

Return(c_UsrFluig)