//Bibliotecas
#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
#include "vkey.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} FCFGR001
//Relatório de usuários 
@author carlo
@since 06/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

user function FCFGR001()

//Private c_Perg  := 	"FCFGR001"
Private oReport          
//Private oFont1	:= 	TFont():New( "Arial",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
//Private c_Titulo:=	"Relatório de posição de estoque fisico x Numero de serie"

//f_CriaPerg(c_Perg)

//If !Pergunte(c_Perg, .T.)
//	Return
//EndIf     

oReport := ReportDef()
oReport:PrintDialog()		

Return                  

/*/{Protheus.doc} ReportDef
//CRIAÇÃO DO OBJETO DE IMPRESSÃO DO RELATÓRIO
@author carlo
@since 06/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function ReportDef()
	Local oReport
	Local o_Secao	:=	Nil
	//Local o_Break
	Private c_Titulo:=	"Lista usuarios protheus"	
	//oReport := TReport():New("FCFGR001",c_Titulo,c_Perg,{|oReport| PrintReport(oReport)},"Lista usuarios protheus")
	oReport := TReport():New("FCFGR001",c_Titulo,,{|oReport| PrintReport(oReport)},"Lista usuarios protheus")
	oReport:SetLandscape() //paisagem                                                  
    oReport:DisableOrientation() //não permite mudar a orientação de pagina
    //oReport:lHeaderVisible := .F.
    //oReport:lFooterVisible := .F.
	//oReport:SetPageFooter(3,{|| },.F.) 

	o_Secao := TRSection():New(oReport,"USUARIOS")
	o_Secao:lEdit := .T.			                                                              
	TRCell():New(o_Secao, 	"c_Idtabela"		,, "Id Tabela"		,	,10				)
	TRCell():New(o_Secao, 	"c_Idusuario"		,, "id Usuario"		,	,10				)
	TRCell():New(o_Secao, 	"c_Login"			,, "Login"			,	,30				)
	TRCell():New(o_Secao, 	"c_Nome"			,, "Nome"			,	,100			)
	TRCell():New(o_Secao, 	"c_Email"			,, "E-mail"			,	,60				)
	TRCell():New(o_Secao, 	"c_Depart"			,, "Departameto"	,	,60				)
	TRCell():New(o_Secao, 	"c_Cargo"			,, "Cargo"			,	,60				)
Return oReport      

/*/{Protheus.doc} PrintReport
//Impressão do relatório
@author carlo
@since 06/05/2018
@version 1.0
@return ${return}, ${return_description}
@param oReport, object, descricao
@type function
/*/
Static Function PrintReport(oReport) 
Local nx		:=	1
Local o_Secao	:= 	oReport:Section(1)
Local aAllusers := FWSFALLUSERS()

oReport:nRow := 140

o_Secao:Init()

For nx := 1 To Len(aAllusers)
	o_Secao:Cell("c_Idtabela"):SetValue( 	aAllusers[nx][1] 		)
	o_Secao:Cell("c_Idusuario"):SetValue( 	aAllusers[nx][2] 		)
	o_Secao:Cell("c_Login"):SetValue( 		aAllusers[nx][3] 		)
	o_Secao:Cell("c_Nome"):SetValue( 		aAllusers[nx][4] 		)
	o_Secao:Cell("c_Email"):SetValue( 		aAllusers[nx][5] 		)
	o_Secao:Cell("c_Depart"):SetValue( 		aAllusers[nx][6] 		)
	o_Secao:Cell("c_Cargo"):SetValue( 		aAllusers[nx][7] 		)

	o_Secao:PrintLine()

//    conout(aAllusers[nx][4] + " -" + aAllusers[nx][5])

Next

o_Secao:Finish()		

oReport:EndPage() ///salta pagina

return  

/*/{Protheus.doc} f_CriaPerg
Funcao responsavel pela criacao das perguntas no dicionario

@author francisco.ssa
@since 14/08/2015
@version 1.0

@param c_Perg, character, Grupo de Perguntas

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
Parametros[1] = Comprador
Parametros[2] = Grupos que participarão da relação de SC a serem usadas para gerar cotação
Parametros[3] = Grupos que não participarão da relação de SC a serem usadas para gerar cotação


Static Function f_CriaPerg(c_Perg)

	Local a_PAR01	:= {}
	Local a_PAR02	:= {}
	Local a_PAR03	:= {}
	Private o_perg   :=	clsComponentes():new()

	c_Perg := PADR(c_Perg,10)

	Aadd(a_PAR01, "")
	Aadd(a_PAR02, "")
	Aadd(a_PAR03, "")

//mtdPutSX1( 	 X1_GRUPO	, X1_ORDEM	, X1_PERGUNT			, X1_PERSPA	, X1_PERENG	, X1_VARIAVL, X1_TIPO	, X1_TAMANHO		, X1_DECIMAL, X1_PRESEL, X1_GSC	, X1_VALID	, X1_VAR01	, X1_DEF01			, X1_DEFSPA1		, X1_DEFENG1		, X1_CNT01	, X1_VAR02			, X1_DEF02			, X1_DEFSPA2		, X1_DEFENG2, X1_CNT02			, X1_VAR03			, X1_DEF03			, X1_DEFSPA3, X1_DEFENG3		, X1_CNT03			, X1_VAR04		, X1_DEF04	, X1_DEFSPA4, X1_DEFENG4, X1_CNT04	, X1_VAR05	, X1_DEF05	, X1_DEFSPA5, X1_DEFENG5, X1_CNT05	, X1_F3	, X1_PYME	, X1_GRPSXG	, X1_HELP	, X1_PICTURE	, X1_IDFIL )
//				 X1_GRUPO	, X1_ORDEM	, X1_PERGUNT			, X1_PERSPA	, X1_PERENG	, X1_VARIAVL, X1_TIPO	, X1_TAMANHO		, X1_DECIMAL, X1_PRESEL, X1_GSC	, X1_VALID	, X1_VAR01	, X1_DEF01			, X1_DEFSPA1		, X1_DEFENG1		, X1_CNT01	, X1_VAR02			, X1_DEF02			, X1_DEFSPA2		, X1_DEFENG2, X1_CNT02			, X1_VAR03			, X1_DEF03			, X1_DEFSPA3, X1_DEFENG3		, X1_CNT03			, X1_VAR04		, X1_DEF04	, X1_DEFSPA4, X1_DEFENG4, X1_CNT04	, X1_VAR05	, X1_DEF05	, X1_DEFSPA5, X1_DEFENG5, X1_CNT05	, X1_F3	, X1_PYME	, X1_GRPSXG	, X1_HELP	, X1_PICTURE	, X1_IDFIL
o_perg:mtdPutSX1(c_Perg		,"01"		,"Nivel		"			,""			,""			,"mv_ch1"	,"N"		,1					,0			,0			,"C"	,""			,"mv_par01"	,"Sintetico"		,""					,""					,""			,""					,"Analitico"		,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		,""			,""			,""			,""				,""			)
o_perg:mtdPutSX1(c_Perg		,"02"		,"Produto De"			,""			,""			,"mv_ch2"	,"C"		,TamSx3("B1_COD")[1],0			,0			,"G"	,""			,"mv_par02"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"SB1"	,""			,""			,""			,""				,""			)
o_perg:mtdPutSX1(c_Perg		,"03"		,"Produto Ate"			,""			,""			,"mv_ch3"	,"C"		,TamSx3("B1_COD")[1],0			,0			,"G"	,""			,"mv_par03"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"SB1"	,""			,""			,""			,""				,""			)

Return
/*/