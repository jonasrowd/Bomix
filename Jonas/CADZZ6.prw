#Include "protheus.ch"
#include "topconn.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: CADZZ6()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 26 de JULHO de 2016, 09:00
//|Descricao.: LOG de envios de WF de Cobrança
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function CADZZ6()
*-----------------------------------------------------------*

Private aRotina := {{ OemToAnsi("Pesquisar")   ,"AxPesqui"      ,  0 , 1},;
					{ OemToAnsi("Visualizar")  ,"AxVisual"      ,  0 , 2},;
					{ OemToAnsi("Enviar Tudo") ,"U_INCWFCOB"    ,  0 , 3} }

Private cStrCad   := "ZZ6"
Private cTitCad   := "LOG de envios de WF de Cobrança"
Private cCadastro := cTitCad+" ["+cStrCad+"]"

dbSelectArea(cStrCad)
dbSetOrder(1)
mBrowse(06,01,22,75,cStrCad)
dbSelectArea(cStrCad)

Return