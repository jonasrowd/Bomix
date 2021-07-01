#include "rwmake.ch" 
#include "TbiConn.ch"
/*******************************************************************************************************/
/* Programa : BXFINCFO (Carregar CFO na Tela de Documento de Entrada)                                  */
/* Data     : 01/12/2015                                                                               */
/* Descrição: Carregar CFO na Tela de Documento de Entrada, apenas o CFO do primeiro ITEM, ou seja     */
/* caso a NF tenha mais de um CFO apenas o do primeiro ITEM será apresentada							   */
/* Autor    : TBA001 -XXX												                       */ 
/*******************************************************************************************************/
User Function BXFINCFO()

Local c_CFO := POSICIONE("SD1",1,XFILIAL("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),"D1_CF")

Return c_CFO