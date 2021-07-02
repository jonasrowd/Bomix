#INCLUDE "TOPCONN.CH"

User Function FCTBA001
	n_QtdItem := 0
	c_Qry 	  := " SELECT B1_COD ITEM, '2' CLASSE, '1' NORMAL, ('PRODUTO ' + B1_COD) DESCRI FROM " + RETSQLNAME("SB1") + " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND D_E_L_E_T_ <> '*' "
	c_Qry 	  += " ORDER BY 1 "

	TCQuery c_Qry New Alias QRY
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	Count To n_QtdItem
	ProcRegua(n_QtdItem)
	QRY->(dbGoTop())
	While QRY->(!Eof())
		dbSelectArea("CTD")
		CTD->(dbSetOrder(1))
		If CTD->(dbSeek(xFilial("CTD") + SubStr(QRY->ITEM, 1, TamSX3("CTD_ITEM")[1]))) == .F.
			If f_CTBA040(QRY->ITEM, QRY->CLASSE, QRY->NORMAL, QRY->DESCRI)
/*
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + QRY->ITEM))
					RecLock("SB1", .F.)
					SB1->B1_ITEMCC := QRY->ITEM
					MsUnlock()
				Endif
*/
			Endif
		Endif

		IncProc()
		QRY->(dbSkip())
	End

	QRY->(dbCloseArea())
Return



Static Function f_CTBA040(c_Item, c_Classe, c_Normal, c_Desc)
	Local a_ItemCtb     := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
	Local l_Ret         := .F.

	Private lMsHelpAuto := .F.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .F.	// Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

	a_ItemCtb := {	{'CTD_ITEM'   , c_Item								, Nil},;	// Especifica qual o Código do item contabil
					{'CTD_CLASSE' , c_Classe							, Nil},;	// Especifica a classe do Centro de Custo, que  poderá ser: - Sintética: Centros de Custo totalizadores dos Centros de Custo Analíticos - Analítica: Centros de Custo que recebem os valores dos lançamentos contábeis
					{'CTD_NORMAL' , c_Normal							, Nil},;	// Indica a classificação do centro de custo. 1-Receita ; 2-Despesa
					{'CTD_DESC01' , "ITEM CONTABIL DO " + c_Desc 		, Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
					{'CTD_BLOQ'   , "2"									, Nil},;	// Indica se o Centro de Custo está ou não bloqueado para os lançamentos contábeis.
					{'CTD_DTEXIS' , DDATABASE							, Nil}}		// Especifica qual a Data de Início de Existência para este Centro de Custo

	MSExecAuto({|x, y| CTBA040(x, y)},a_ItemCtb, 3)

	If lMsErroAuto	
		MostraErro()
	Else
		l_Ret := .T.
	EndIf
Return l_Ret