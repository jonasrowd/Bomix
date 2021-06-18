/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA010E    �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para executado no final da exclus�o do    ���
���          � produto. Deve ser utilizado para grava��o de campos do 	  ���
���          � usu�rio.						                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACTB - Contabilidade Gerencial                          ���
���          � Este ponto de entrada est� sendo utilizado para excluir o  ���
���          � item cont�bil quando o produto for exclu�do do cadastro de ���
���          � produto.  		 						  				  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User Function MTA010E
	Local a_Area := GetArea()
/*
    dbSelectArea("CTD")
    CTD->(dbSetOrder(1))
    If dbSeek(xFilial("CTD") + SB1->B1_ITEMCC) .And. !Empty(SB1->B1_ITEMCC)
		f_CTBA040(SB1->B1_ITEMCC, '2', '1')
	Endif
*/
	RestArea(a_Area)
Return Nil



Static Function f_CTBA040(c_Item, c_Classe, c_Normal)
	Local a_ItemCtb     := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica

	Private lMsHelpAuto := .F.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .F.	// Determina se houve alguma inconsistencia na execucao da rotina

	a_ItemCtb := {	{'CTD_ITEM'   , c_Item									, Nil},;	// Especifica qual o C�digo do item contabil
					{'CTD_CLASSE' , c_Classe								, Nil},;	// Especifica a classe do Centro de Custo, que  poder� ser: - Sint�tica: Centros de Custo totalizadores dos Centros de Custo Anal�ticos - Anal�tica: Centros de Custo que recebem os valores dos lan�amentos cont�beis
					{'CTD_NORMAL' , c_Normal								, Nil},;	// Indica a classifica��o do centro de custo. 1-Receita ; 2-Despesa
					{'CTD_DESC01' , "ITEM CONTABIL DO PRODUTO " + c_Item 	, Nil}}		// Indica a Nomenclatura do item contabil na Moeda 1

	MSExecAuto({|x, y| CTBA040(x, y)},a_ItemCtb, 5)

	If lMsErroAuto
		MostraErro()
	EndIf
Return