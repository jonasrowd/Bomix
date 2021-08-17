/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT010INC   ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para executado no final da gravação do    º±±
±±º          ³ produto. Deve ser utilizado para gravação de campos do 	  º±±
±±º          ³ usuário.						                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB - Contabilidade Gerencial                          º±±
±±Ì          ³ Este ponto de entrada está sendo utilizado para gravar um  ¹±±
±±º          ³ novo item contábil sempre que um novo produto for incluído º±±
±±º          ³ no cadastro de produto.  		 						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function MT010INC
	Local a_Area := GetArea()
/*
	If Len(AllTrim(SB1->B1_COD)) <= TamSX3("CTD_ITEM")[1]
		If f_CTBA040(SB1->B1_COD, '2', '1')
			RecLock("SB1", .F.)
			SB1->B1_ITEMCC := SB1->B1_COD
			MsUnlock()
		Endif
    Endif
*/
	RestArea(a_Area)
Return Nil



Static Function f_CTBA040(c_Item, c_Classe, c_Normal)
	Local a_ItemCtb     := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
	Local l_Ret         := .F.

	Private lMsHelpAuto := .F.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .F.	// Determina se houve alguma inconsistencia na execucao da rotina

	a_ItemCtb := {	{'CTD_ITEM'   , c_Item									, Nil},;	// Especifica qual o Código do item contabil
					{'CTD_CLASSE' , c_Classe								, Nil},;	// Especifica a classe do Centro de Custo, que  poderá ser: - Sintética: Centros de Custo totalizadores dos Centros de Custo Analíticos - Analítica: Centros de Custo que recebem os valores dos lançamentos contábeis
					{'CTD_NORMAL' , c_Normal								, Nil},;	// Indica a classificação do centro de custo. 1-Receita ; 2-Despesa
					{'CTD_DESC01' , "ITEM CONTABIL DO PRODUTO " + c_Item 	, Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
					{'CTD_BLOQ'   , "2"										, Nil},;	// Indica se o Centro de Custo está ou não bloqueado para os lançamentos contábeis.
					{'CTD_DTEXIS' , DDATABASE								, Nil}}		// Especifica qual a Data de Início de Existência para este Centro de Custo

	MSExecAuto({|x, y| CTBA040(x, y)},a_ItemCtb, 3)

	If lMsErroAuto	
		MostraErro()
	Else
		l_Ret := .T.
	EndIf
Return l_Ret