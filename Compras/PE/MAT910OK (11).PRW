#include "rwmake.ch"
/*
/*******************************************************************************************************/
/*** Descricao : Ponto Entrada na confirmação do doc. de entrada									 ***/
/*** Programa  : MAT910OK           		                          								 ***/
/*** Criado em : 23/07/2018       								      								 ***/
/*** Autor     : wellington carvalho			      													 ***/
/*** Alteracoes:****************************************************************************************/
/*** Data	   :                					      							 				 ***/
/*** Autor     :         												   							 ***/
/*******************************************************************************************************/
                 
#Include "Protheus.ch"
#Include "TopConn.ch" 
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function MAT910OK() 
Local cTipo 	:= ParamixB[2] 
public lRet          := .T. 
 //Data de emissao da Nota FiscalLocal cTipo 	:= ParamixB[2] //Tipo da Nota Fiscal    Local cNFiscal 	:= ParamixB[3] //Numero da Nota FiscalLocal cEspecie 	:= ParamixB[4] //Especie da Nota FiscalLocal cA100For	:= ParamixB[5] //Fornecedor da Nota FiscalLocal cLoja		:= ParamixB[6] //Loja da Nota FiscalLocal lRet		:= .F.Local aArea		:=  GetArea()	If Alltrim(cEspecie) == "NF"		   lRet :=	.T.	Else	   Alert("Especie invalida " +cEspecie+". A epecie digitada deve ser NF")       	EndIfAlert("Ponto de Entrada MAT910OK")              RestArea (aArea)Return lRet 
IF cTipo = "SPED" .AND. M->F1_CHVNFE = " "
   MsgBox("Tipo Nota Fiscal = SPED, sem a chave da Nota Fiscal, inclusao nao permitida !!!")     
   lRet          := .F.
ENDIF                  

     
 

   



