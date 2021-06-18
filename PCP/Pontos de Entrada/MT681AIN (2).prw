#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPonto de entrada ³ MT681AIN	 ºAutor  ³ 				    º Data ³ 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³ Inclusão de Produção PCP Mod2				 	  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservação ³ Ponto de entrada desenvolvido para alterar os empenhos da º±±
±±º           ³ ordem de produção em caso de produção a maior ou produção º±±
±±º           ³ com perda durante o processo. Altera apenas D4_QUANT      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß        

*/        


User Function MT681AIN
	// ALTERADO POR VICTOR SOUSA 24/05/20 

	Local a_Area := GetArea()
	Local a_Area2


	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
		//		If (SH6->H6_QTDPROD + SH6->H6_QTDPERD) > (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)

		If SH6->H6_QTDPERD>0 //SH6->H6_QTGANHO > 0 ALTERADO POR VICTOR SOUSA 12/02/20

			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
			//			n_Perc := ((SH6->H6_QTDPROD + SH6->H6_QTDPERD) - (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))/SB1->B1_QB
			//			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB // ALTERADO POR VICTOR SOUSA
			n_Perc := SH6->H6_QTDPERD/SH6->H6_QTDPROD
			n_perda:= SH6->H6_QTDPERD
			n_total :=SH6->H6_QTDPROD+SH6->H6_QTDPERD
			n_base:=SB1->B1_QB
			/*
			dbSelectArea("Z05")
			Z05->(dbSetOrder(1))
			Z05->(dbSeek(xFilial("Z05") +SB1->B1_CODINSU))
			cPerda:=Z05->Z05_PERDA

			If cPerda='S'
			*/		
			IF SH6->H6_PT = "T"
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
							//	a_Area2 := GetArea()
							dbSelectArea("SB1")
							nRec := SB1->(RECNO()) 
							SB1->(dbSetOrder(1))
							SB1->(dbSeek(xFilial("SB1") + SD4->D4_COD))
							If Found()
								dbSelectArea("Z05")
								Z05->(dbSetOrder(1))
								Z05->(dbSeek(xFilial("Z05") +SB1->B1_CODINSU))
								cPerda:=Z05->Z05_PERDA
								If cPerda='S'						
									c_Produto := SD4->D4_COD
									c_Local   := SD4->D4_LOCAL
									c_Op      := SD4->D4_OP
									d_Data    := SD4->D4_DATA
									n_SaldEmp := SD4->D4_SLDEMP
									n_QtdOri  := SD4->D4_QTDEORI  //+ (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20 
									//n_Quant   := SD4->D4_QUANT  + (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT  //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20 
									n_Quant   := SG1->G1_QUANT / n_base * n_total       //SD4->D4_QUANT  + (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT  //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20
									c_Trt     := SD4->D4_TRT

									a_Vetor:={  {"D4_COD"     ,c_Produto		,Nil},; //COM O TAMANHO EXATO DO CAMPO
									{"D4_LOCAL"   ,c_Local          ,Nil},;
									{"D4_OP"      ,c_Op  			,Nil},;
									{"D4_DATA"    ,d_Data	        ,Nil},;
									{"D4_QTDEORI" ,n_QtdOri         ,Nil},;
									{"D4_QUANT"   ,n_Quant          ,Nil},;
									{"D4_TRT"     ,c_Trt            ,Nil}}

									f_Mata380(a_Vetor)
									//	RestArea(a_Area2)

									/*								
									Else

									If SH6->H6_QTDPROD=0 .And. SH6->H6_QTDPERD >0
									//n_perda<>0 and  n_qtdprod>0

									c_Produto := SD4->D4_COD
									c_Local   := SD4->D4_LOCAL
									c_Op      := SD4->D4_OP
									d_Data    := SD4->D4_DATA
									n_QtdOri  := SD4->D4_QTDEORI  //+ (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20 
									//n_Quant   := SD4->D4_QUANT  + (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT  //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20 
									n_Quant   := 0 //SG1->G1_QUANT / n_base * n_total       //SD4->D4_QUANT  + (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT  //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20
									c_Trt     := SD4->D4_TRT
									n_SaldEmp := SG1->G1_QUANT / n_base * n_total 

									a_Vetor:={  {"D4_COD"     ,c_Produto		,Nil},; //COM O TAMANHO EXATO DO CAMPO
									{"D4_LOCAL"   ,c_Local          ,Nil},;
									{"D4_OP"      ,c_Op  			,Nil},;
									{"D4_DATA"    ,d_Data	        ,Nil},;
									{"D4_QTDEORI" ,n_QtdOri         ,Nil},;
									{"D4_QUANT"   ,n_Quant          ,Nil},;
									{"D4_TRT"     ,c_Trt            ,Nil},;
									{"D4_SLDEMP"  ,n_SaldEmp        ,Nil}}

									f_Mata380(a_Vetor)


									Endif
									*/	






								Endif
							Endif
							dbSelectArea("SB1")
							dbGoto(nRec)
						Endif

						SG1->(dbSkip())
					End
				End Transaction
				//Endif
			Endif
		Endif
	Endif
	RestArea(a_Area)
	*/ 












	///////////////////////////////////////////////////////////////////////////////////////////////////
	/* 
	Local a_Area := GetArea()



	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
	//		If (SH6->H6_QTDPROD + SH6->H6_QTDPERD) > (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)

	If M->H6_QTDPERD>0 //SH6->H6_QTGANHO > 0 ALTERADO POR VICTOR SOUSA 12/02/20
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
	//			n_Perc := ((SH6->H6_QTDPROD + SH6->H6_QTDPERD) - (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))/SB1->B1_QB
	//			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB // ALTERADO POR VICTOR SOUSA
	n_Perc := SH6->H6_QTDPERD/SH6->H6_QTDPROD
	n_perda:= SH6->H6_QTDPERD

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
	n_QtdOri  := SD4->D4_QTDEORI  + (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20 
	n_Quant   := SD4->D4_QUANT  + (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT  //(SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20 
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
	*/ 
	//ALTERADO POR VICTOR SOUSA 24/05/20 
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPonto de entrada ³ MT680GREST ºAutor  ³ 				    º Data ³ 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³ Estorno de Produção							 	  		  º±±
±±º				É executado após o estorno do movimento da produção, e	  º±± 
±±º				permite executar qualquer ação definida pelo operador.	  º±±
±±º				Obs: Para a compilação do PE é necessário que o nome do	  º±± 
±±º				fisico do aquivo fonte não seja o mesmo nome que 	  	  º±±
±±º				MT680GREST.	  											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservação ³ Ponto de entrada desenvolvido para alterar os empenhos da º±±
±±º           ³ ordem de produção em caso de estorno de produção a maior  º±±
±±º           ³ ou com perda durante o processo.		                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT680GREST
	Local a_Area  := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
		//		If (SH6->H6_QTDPROD + SH6->H6_QTDPERD) > (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)
		IF FOUND()

			RecLock("SC2",.F.)
			SC2->C2_FSSALDO:=SC2->C2_FSSALDO+SH6->H6_QTDPROD
			SC2->(MsUnlock())		

		ENDIF
		//ALTERADO POR VICTOR SOUSA 24/05/20 
		/*
		If M->H6_QTDPERD>0 //SH6->H6_QTGANHO > 0 ALTERADO POR VICTOR SOUSA 12/02/20
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
		//			n_Perc := ((SH6->H6_QTDPROD + SH6->H6_QTDPERD) - (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA))/SB1->B1_QB
		//			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB // ALTERADO POR VICTOR SOUSA
		n_Perc := SH6->H6_QTDPERD/SH6->H6_QTDPROD
		n_perda:= SH6->H6_QTDPERD

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
		n_QtdOri  := SD4->D4_QTDEORI - (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT // (SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20
		n_Quant   := SD4->D4_QUANT - (n_perda/SG1->G1_QUANT)*SG1->G1_QUANT // (SG1->G1_QUANT * n_Perc) ALTERADO POR VICTOR SOUSA 12/02/20
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
		*/
		//ALTERADO POR VICTOR SOUSA 24/05/20
	Endif

	RestArea(a_Area)
Return Nil



Static Function f_Mata380(aVetor)
	Local aEmpen := {}
	Local nOpc   := 4 //Alteração

	lMsErroAuto := .F.

	MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen)

	If lMsErroAuto
		MostraErro()
	EndIf
Return