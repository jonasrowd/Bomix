//#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
//#INCLUDE "TOPCONN.CH"    
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK      º Autor ³ VICTOR SOUSA       º Data ³  11/11/19  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação da Transferência	                                º±±
±±º          ³ Apos confirmada a alteração do produto no campo de bloqueio  º±±
±±º          ³ o sistema verificará se existe alguma OP em aberto. Caso     º±±
±±º          ³ exista, o sistema não permitirá bloquear o produto           º±±
±±º          ³           													º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function A010TOK()

// Validações do usuário para inclusão ou alteração do produto
	Local l_Ret := .T.
	Local a_Area := GetArea()
	Local cQry        := ""
	Local m_quant        := ""

	
	cQry:="SELECT COUNT(*) AS TOTAL    "+ chr(13)
	cQry+="FROM "+RetSqlName("SC2")+" SC2 WITH (NOLOCK) "+ chr(13)
	cQry+="WHERE SC2.C2_FILIAL='"+xFilial("SC2")+"'  "+ chr(13)
	cQry+="AND C2_PRODUTO='"+M->B1_COD+"'"+ chr(13)
	cQry+="AND D_E_L_E_T_<>'*'         "+ chr(13)
	cQry+="AND (C2_DATAPCP='' OR C2_PRIOR<500) "+ chr(13)
	cQry+="AND C2_QUJE < C2_QUANT      "

	MemoWrit("QUANT_OP.SQL",cQry)
	
    TCQuery cQry New Alias "QRYPRO"
	
	m_quant=ALLTRIM(STR(QRYPRO->TOTAL))

	If M->B1_MSBLQL="1" .and. VAL(m_quant)>0
		ShowHelpDlg(SM0->M0_NOME, { "Produto com ( " +m_quant+ " ) OPs em aberto."}, 5, {"É necessário encerrar a OP para bloquear este produto. Solicite ao Setor do PCP"},5)
		l_Ret := .F.
	Endif
	
	QRYPRO->(DbCloseArea())
    RestArea(a_Area)			
Return l_Ret
