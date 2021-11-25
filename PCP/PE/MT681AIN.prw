#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Ponto de entrada � MT681AIN	 �Autor  � 				    � Data � 	  ���
�������������������������������������������������������������������������͹��
���Desc.      � Inclus�o de Produ��o PCP Mod2				 	  		  ���
�������������������������������������������������������������������������͹��
���Observa��o � Ponto de entrada desenvolvido para alterar os empenhos da ���
���           � ordem de produ��o em caso de produ��o a maior ou produ��o ���
���           � com perda durante o processo.		                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������        

*/        


User Function MT681AIN
	Local a_Area := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
//		If (SH6->H6_QTDPROD + SH6->H6_QTDPERD) > (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)
		If SH6->H6_QTGANHO > 0
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
//			n_Perc := ((SH6->H6_QTDPROD + SH6->H6_QTDPERD) - (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))/SB1->B1_QB
			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB

			Begin Transaction
				dbSelectArea("SG1")
				SG1->(dbSetOrder(1))
				SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
				While SG1->(!EoF()) .And. SG1->G1_COD == SC2->C2_PRODUTO
					a_Vetor := {}

					dbSelectArea("SD4")
					SD4->(dbSetOrder(2))
					SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP + SG1->G1_COMP))
					If Found()
						c_Produto := SD4->D4_COD
						c_Local   := SD4->D4_LOCAL
						c_Op      := SD4->D4_OP
						d_Data    := SD4->D4_DATA
						n_QtdOri  := SD4->D4_QTDEORI + (SG1->G1_QUANT * n_Perc)
						n_Quant   := SD4->D4_QUANT + (SG1->G1_QUANT * n_Perc)
						c_Trt     := SD4->D4_TRT

						a_Vetor:={  {"D4_COD"     ,c_Produto		,Nil},; //COM O TAMANHO EXATO DO CAMPO
						            {"D4_LOCAL"   ,c_Local          ,Nil},;
						            {"D4_OP"      ,c_Op  			,Nil},;
						            {"D4_DATA"    ,d_Data	        ,Nil},;
						            {"D4_QTDEORI" ,n_QtdOri         ,Nil},;
						            {"D4_QUANT"   ,n_Quant          ,Nil},;
						            {"D4_TRT"     ,c_Trt            ,Nil}}

						f_Mata380(a_Vetor)
					Endif

					SG1->(dbSkip())
				End
			End Transaction
		Endif
	Endif

	RestArea(a_Area)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Ponto de entrada � MT680GREST �Autor  � 				    � Data � 	  ���
�������������������������������������������������������������������������͹��
���Desc.      � Estorno de Produ��o							 	  		  ���
���				� executado ap�s o estorno do movimento da produ��o, e	  ��� 
���				permite executar qualquer a��o definida pelo operador.	  ���
���				Obs: Para a compila��o do PE � necess�rio que o nome do	  ��� 
���				fisico do aquivo fonte n�o seja o mesmo nome que 	  	  ���
���				MT680GREST.	  											  ���
�������������������������������������������������������������������������͹��
���Observa��o � Ponto de entrada desenvolvido para alterar os empenhos da ���
���           � ordem de produ��o em caso de estorno de produ��o a maior  ���
���           � ou com perda durante o processo.		                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT680GREST
	Local a_Area  := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
//		If (SH6->H6_QTDPROD + SH6->H6_QTDPERD) > (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)
		If SH6->H6_QTGANHO > 0
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
//			n_Perc := ((SH6->H6_QTDPROD + SH6->H6_QTDPERD) - (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))/SB1->B1_QB
			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB

			Begin Transaction
				dbSelectArea("SG1")
				SG1->(dbSetOrder(1))
				SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
				While SG1->(!EoF()) .And. SG1->G1_COD == SC2->C2_PRODUTO
					a_Vetor := {}

					dbSelectArea("SD4")
					SD4->(dbSetOrder(2))
					SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP + SG1->G1_COMP))
					If Found()
						c_Produto := SD4->D4_COD
						c_Local   := SD4->D4_LOCAL
						c_Op      := SD4->D4_OP
						d_Data    := SD4->D4_DATA
						n_QtdOri  := SD4->D4_QTDEORI - (SG1->G1_QUANT * n_Perc)
						n_Quant   := SD4->D4_QUANT - (SG1->G1_QUANT * n_Perc)
						c_Trt     := SD4->D4_TRT

						a_Vetor:={  {"D4_COD"     ,c_Produto		,Nil},; //COM O TAMANHO EXATO DO CAMPO
						            {"D4_LOCAL"   ,c_Local          ,Nil},;
						            {"D4_OP"      ,c_Op  			,Nil},;
						            {"D4_QUANT"   ,n_Quant          ,Nil},;
						            {"D4_QTDEORI" ,n_QtdOri         ,Nil}}

						f_Mata380(a_Vetor)
					Endif

					SG1->(dbSkip())
				End
			End Transaction
		Endif
	Endif

	RestArea(a_Area)
Return Nil



Static Function f_Mata380(aVetor)
	Local aEmpen := {}
	Local nOpc   := 4 //Altera��o
	
	lMsErroAuto := .F.
	
	MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen)
	
	If lMsErroAuto
	    MostraErro()
	EndIf
Return
