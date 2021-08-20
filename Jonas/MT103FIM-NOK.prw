#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------
/*{Protheus.doc}
Description MT103FIM
O ponto de entrada MT103FIM encontra-se no final da função A103NFISCAL.
Após o destravamento de todas as tabelas envolvidas na gravação do
documento de entrada, depois de fechar a operação realizada neste.
É utilizado para realizar alguma operação após a gravação da NFE.

@param xParam Parameter Description
@return xRet Return Description

*/
//--------------------------------------------------------------
User Function MT103FIM
Local aArea		:= GetArea()
Local aAreaD1	:= SD1->(GetArea())
Local aParam	:= PARAMIXB
Local aCabec	:= {}
Local aLine		:= {}
Local aItem		:= {}

	If(cFilAnt == "0102")	//SULMINAS TAUBATE
		Return(Nil)
	EndIf

	If !(aParam[1] == 3 .AND. aParam[2] == 1)
		Return(Nil)
	EndIf

	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SD1->(dbGoTop())
	SD1->(dbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
	While !SD1->(EOF()) .AND. SD1->D1_FILIAL  == SF1->F1_FILIAL  .AND.;
	                          SD1->D1_DOC     == SF1->F1_DOC     .AND.;
							  SD1->D1_SERIE   == SF1->F1_SERIE   .AND.;
							  SD1->D1_FORNECE == SF1->F1_FORNECE .AND.;
							  SD1->D1_LOJA    == SF1->F1_LOJA


		If(ALLTRIM(SD1->D1_LOCAL) <> "98")
			SD1->(dbSkip())
			Loop
		ElseIf(!Localiza(SD1->D1_COD, .T.))
			SD1->(dbSkip())
			Loop
		EndIf

		CriaSB2(SD1->D1_COD, "98")

		aCabec	:= {}
		aLine	:= {}
		aItem	:= {}

		aAdd(aCabec, {"DA_PRODUTO",		SD1->D1_COD,		Nil})
		aAdd(aCabec, {"DA_NUMSEQ",		SD1->D1_NUMSEQ,		Nil})

		aLine := {}
		aAdd(aLine, {"DB_ITEM",			"0001",				Nil})
		aAdd(aLine, {"DB_ESTORNO",		" ",				Nil})
		aAdd(aLine, {"DB_LOCALIZ",		"QUALIDADE      ",	Nil})
		aAdd(aLine, {"DB_DATA",			dDataBase,			Nil})
		aAdd(aLine, {"DB_QUANT",		SD1->D1_QUANT,		Nil})
		aAdd(aItem, aLine)

		MATA265(aCabec, aItem, 3)


		SD1->(dbSkip())
	EndDo

	RestArea(aAreaD1)
	RestArea(aArea)

Return(Nil)
