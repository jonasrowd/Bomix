#include "rwmake.ch"
/*
/*******************************************************************************************************/
/*** Descricao : Ponto Entrada na confirmação do pedido de compra 									 ***/
/*** Programa  : MT120OK            		                          								 ***/
/*** Criado em : 08/01/2015        								      								 ***/
/*** Autor     : TBA001 - XXX: TBA001 -XXX			      													 ***/
/*** Alteracoes:****************************************************************************************/
/*** Data	   :                					      							 				 ***/
/*** Autor     :         												   							 ***/
/*******************************************************************************************************/

User Function MT120GOK

Local cFornece := ""
Local cLoja    := ""

cFornece := SC7->C7_FORNECE
cLoja 	 := SC7->C7_LOJA
cNomeFor := alltrim(posicione("SA2",1,xfilial("SA2") + cFornece + cLoja, "A2_NREDUZ"))

If PARAMIXB[2]
	_cAlias := ALIAS()
	_cOrd   := INDEXORD()
	nReg    := RECNO()
	cNum    := SC7->C7_NUM
		
	grv_nmfor() //grava nome do fornecedor
	
	DbSelectArea( _cAlias )
	DbSetOrder( _cOrd )
	DbGoTo( nReg )
endif     

Return(.T.)

//grava nome do fornecedor
Static Function grv_nmfor()

DbSelectArea("SC7")
DbSetOrder(1)
If DbSeek(xFilial("SC7") + cNum)
	While SC7->(!eof()) .and. cNum == alltrim(SC7->C7_NUM)
		Reclock("SC7",.F.)
			C7_BXNREDU := cNomeFor
		MsUnLock()
		SC7->(dbskip())
	enddo
endif

Return
