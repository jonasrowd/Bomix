#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Ponto de entrada � MT120LOK	 �Autor  � 				    � Data � 	  ���
�������������������������������������������������������������������������͹��
���Desc.      � Altera��es de Itens do Pedido de Compra				 	  ���
�������������������������������������������������������������������������͹��
���Observa��o � Ponto de entrada desenvolvido para alertar o usu�rio da   ���
���           � necessidade de preencher o centro de custo do item do     ���
���           � pedido de compra.					                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function  MT120LOK
	Local l_Ret := .T.
	
	c_CC     := " "
	c_Rateio := " "
    C_CONTA  := " "    


   	If aCols[n][Len( aHeader )+1] == .F.
		c_CC      := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'C7_CC'})]
		c_Rateio  := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'C7_RATEIO'})]    
		c_conta   := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'C7_CONTA'})]  
					
			
		if Empty(c_CC).And. substr(c_conta,1,1) ="4"   
		   msgbox("O campo Centro Custo est� em branco") 
		   l_Ret := .F.
		   return l_Ret
		endif
		
		
		If Empty(c_CC) .And. substr(c_conta,1,1) $"23"
		//.And. c_Rateio == '2'
			If MsgYesNo("O campo Centro Custo est� em branco. Deseja continuar sem preencher o centro de custo?", SM0->M0_NOME) == .F.
				l_Ret := .F.
			Endif
		Endif
		
		// Altera��o realizada em 17/08/2020 por Elmer Farias, para atender ao chamado 3034 (GLPI)
		
		if Empty(c_CC) .And. c_Rateio == '1'  
		   If MsgYesNo("Os campos de Centro Custos e Conta Cont�bil est�o em branco. Deseja considerar os campos preenchidos no rateio?", SM0->M0_NOME) == .F.
					l_Ret := .F.
			Endif
		endif
		
		aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'C7_BXNREDU'})] := alltrim(posicione("SA2",1,xfilial("SA2") + cA120Forn + cA120Loj, "A2_NREDUZ"))
		
	Endif
Return l_Ret