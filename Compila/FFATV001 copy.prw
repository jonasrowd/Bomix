#INCLUDE 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FFATV001   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o para o produto selecionado no item do pedido de  ���
���          � venda.											  		  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT - Faturamento									  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/* VERS�O EM PRODU��O ANTES DA ALTERA��O DA ROTINA DE ARTE
User Function FFATV001(c_Produto)
	Local _cAlias := Alias()
	Local l_Ret   := .T.
	Local c_Var   := ReadVar()
	Local a_Area  := GetArea()

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Produto)
	If !Empty(SB1->B1_FSARTE) 				//Verifica se o produto possui arte
		If SB1->B1_FSARTE <> '99999'	    //Verifica se a arte do produto � diferente de 99999
			dbSelectArea("SZ2")
			dbGoTop()
			dbSetOrder(1)
			dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
			If SZ2->Z2_BLOQ == '1'          //Verifica se a arte do produto est� bloqueada
				ShowHelpDlg(SM0->M0_NOME, {"A arte deste produto est� bloqueada."},5,;
		                                  {"Contacte o administrador do sistema."},5)
//-------------------------------------------------------------------------------------------------------------------------

				If 'C6' $ c_Var           //Verifica se � pedido de venda ou or�amento
					aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })] := '2'         //Altera a situa��o da arte para alterada
				Else
					(_cAlias)->CK_FSTPITE := '2'
				Endif
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME, {"1) Produto bloqueado", "2) Arte em desenvolvimento"},5,;
	                                  {"Contacte o administrador do sistema."},5)    
			l_Ret := .F.
		Endif
	Endif
	
	If l_Ret
		If 'C6' $ c_Var           //Verifica se � pedido de venda ou or�amento
			c_Cliente := M->C5_CLIENTE
			c_Loja    := M->C5_LOJACLI
		Else
			c_Cliente := M->CJ_CLIENTE
			c_Loja    := M->CJ_LOJA
		Endif

     	dbSelectArea("SA7")			
	    dbGoTop()
	    dbSetOrder(2)
	    If !MsSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja)			//Verifica se existe amarra��o Produto x Cliente
   			ShowHelpDlg(SM0->M0_NOME, {"1) Amarra��o Produto X Cliente inv�lida"},5,;
		                              {"Digite um produto com Amarra��o Produto X Cliente v�lida."},5)    
	    	l_Ret := .F.
	    Endif
	Endif

	RestArea(a_Area)	

Return(l_Ret)
*/


User Function FFATV001(c_Produto)
	//Local _cAlias := Alias()
	Local l_Ret   := .T.
	Local c_Var   := ReadVar()
	Local a_Area  := GetArea()   
	
	
	//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return(l_Ret)
endif

////////
	
/*	

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Produto)
	If !Empty(SB1->B1_FSARTE) 				//Verifica se o produto possui arte
		dbSelectArea("SZ2")
		dbGoTop()
		dbSetOrder(1)
		dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
		If SZ2->Z2_BLOQ == '1' .Or. SZ2->Z2_BLOQ == '2'         //Verifica se a arte do produto � nova ou est� bloqueada
			ShowHelpDlg(SM0->M0_NOME, {"A arte deste produto � nova ou est� bloqueada."},5,;
	                                  {"Contacte o administrador do sistema."},5)
			If 'C6' $ c_Var           //Verifica se � pedido de venda ou or�amento
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })] := '1'         //Altera o bloqueio da arte para Sim
			Else
//				(_cAlias)->CK_FSTPITE := '1'
				TMP1->CK_FSTPITE := '1'
			Endif
			l_Ret := .F.
		Else
			If 'C6' $ c_Var           //Verifica se � pedido de venda ou or�amento
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })] := '2'         //Altera o bloqueio da arte para Nao
			Else
				TMP1->CK_FSTPITE := '2'
			Endif
		Endif
	Else
		If 'C6' $ c_Var           //Verifica se � pedido de venda ou or�amento
			aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })] := '2'         //Altera o bloqueio da arte para Nao
		Else
			TMP1->CK_FSTPITE := '2'
		Endif
	Endif
	
*/
	
	If 'C6' $ c_Var           //Verifica se � pedido de venda ou or�amento
		c_Cliente := M->C5_CLIENTE
		c_Loja    := M->C5_LOJACLI
	Else
		c_Cliente := M->CJ_CLIENTE
		c_Loja    := M->CJ_LOJA
	Endif
    
    IF M->C5_TIPO <> "B"

   	   dbSelectArea("SA7")			
       dbGoTop()
       dbSetOrder(2)
       If !MsSeek(xFilial("SA7") + c_Produto + c_Cliente + c_Loja)			//Verifica se existe amarra��o Produto x Cliente
	     	ShowHelpDlg(SM0->M0_NOME, {"1) Amarra��o Produto X Cliente inv�lida"},5,;
	                              {"Digite um produto com Amarra��o Produto X Cliente v�lida."},5)    
    	   l_Ret := .F.
       Endif
       
    ENDIF
	RestArea(a_Area)	

Return(l_Ret)