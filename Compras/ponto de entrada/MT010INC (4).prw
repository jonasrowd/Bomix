/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT010INC   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para executado no final da grava��o do    ���
���          � produto. Deve ser utilizado para grava��o de campos do 	  ���
���          � usu�rio.						                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACTB - Contabilidade Gerencial                          ���
���          � Este ponto de entrada est� sendo utilizado para gravar um  ���
���          � novo item cont�bil sempre que um novo produto for inclu�do ���
���          � no cadastro de produto.  		 						  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	a_ItemCtb := {	{'CTD_ITEM'   , c_Item									, Nil},;	// Especifica qual o C�digo do item contabil
					{'CTD_CLASSE' , c_Classe								, Nil},;	// Especifica a classe do Centro de Custo, que  poder� ser: - Sint�tica: Centros de Custo totalizadores dos Centros de Custo Anal�ticos - Anal�tica: Centros de Custo que recebem os valores dos lan�amentos cont�beis
					{'CTD_NORMAL' , c_Normal								, Nil},;	// Indica a classifica��o do centro de custo. 1-Receita ; 2-Despesa
					{'CTD_DESC01' , "ITEM CONTABIL DO PRODUTO " + c_Item 	, Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
					{'CTD_BLOQ'   , "2"										, Nil},;	// Indica se o Centro de Custo est� ou n�o bloqueado para os lan�amentos cont�beis.
					{'CTD_DTEXIS' , DDATABASE								, Nil}}		// Especifica qual a Data de In�cio de Exist�ncia para este Centro de Custo

	MSExecAuto({|x, y| CTBA040(x, y)},a_ItemCtb, 3)

	If lMsErroAuto	
		MostraErro()
	Else
		l_Ret := .T.
	EndIf
Return l_Ret