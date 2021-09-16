//Bibliotecas
#Include "Protheus.ch"
#include 'parmtype.ch'
#include "rwmake.ch"
#include "TbiConn.ch"
#INCLUDE "APVT100.CH"
#Include "TopConn.ch"
#INCLUDE "TRYEXCEPTION.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD3250I   ºAutor  ³ VICTOR SOUSA       º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - OBJETIVO NA FINALIZAÇÃO DE CADA APONTAMENTO DE           º±±
±±º          ³ 	 PRODUÇÃO NÃO PERMITIR O CONSUMO INDEVIDO DE			  º±±
±±º          ³ 	 MATERIAIS COMO PALLET, RÓTULO, SACO, ETC				  º±±
±±º          ³ - CORRIGIR A DATA DE VALIDADE DO LOTE DO PRODUTO 		  º±±
±±º          ³ 	 EM TODOS OS ARMAZENS									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAPCP													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function SD3250I()

	Local aArea1       := GetArea()
	Local aAreaB2      := SB2->(GetArea())
	Local aAreaB8      := SB8->(GetArea())
	Local aAreaH6      := SH6->(GetArea())
	Local l_Ret        := .T.
	Local cQry         := ""
	Local m_data       := ""
	Local m_lote       := ""	
	Local m_produto    := ""

	c_CRLF             := chr(13) + chr(10)

	dbSelectArea("SH6")
	If cFilAnt == "010101" 

		m_lote=SH6->H6_LOTECTL
		m_produto=SH6->H6_PRODUTO

		// CONSULTA GERADA PARA VERIFICAR A VALIDADE DO LOTE
		// E CORREÇÃO DA DATA EM TODOS OS ARMAZENS COM A DATA CORRETA


		cQry:="SELECT MIN(H6_DTVALID) AS DATAVALID 			"+ c_CRLF
		cQry+="FROM "+RetSqlName("SH6")+ " SH6 WITH (NOLOCK)	"+ c_CRLF
		cQry+="WHERE H6_LOTECTL= '" +m_lote +"'             "+ c_CRLF
		cQry+="AND H6_PRODUTO= '" + m_produto         +"'   "+c_CRLF
		cQry+="AND H6_FILIAL='"+xFilial("SH6")+"'  			"+ c_CRLF
		cQry+="AND D_E_L_E_T_<>'*'              			"+c_CRLF

		MemoWrit("VALIDLOTE.SQL",cQry)

		TCQuery cQry New Alias "QRYPRO"

		m_data=ALLTRIM(QRYPRO->DATAVALID)

		QRYPRO->(DbCloseArea())

		c_Qry := ""

		// ATUALIZA A VALIDADE DO LOTE NA TABELA DE LOTE 

		//c_Qry := " BEGIN TRAN " + c_CRLF
		c_Qry := " UPDATE " + RetSqlName("SB8") + " SET B8_DTVALID = '" + m_data +"'"+ c_CRLF
		c_Qry += " WHERE B8_LOTECTL= '" +m_lote +"'" + c_CRLF
		c_Qry += " AND B8_PRODUTO= '" +m_produto +"'" + c_CRLF
		c_Qry += " 	AND B8_FILIAL = '" + xFilial("SB8") + "'" + c_CRLF	
		/*
		If TcSqlExec(c_Qry) < 0
		MsgStop("SQL Error: " + TcSqlError())
		TcSqlExec("ROLLBACK")
		l_Ret := .F.
		Else
		TcSqlExec("COMMIT")	
		l_Ret := .T.
		Endif
		*/
		// TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ACIMA DE GRAVAÇÃO  ESTAVA GERANDO ERRO NO DBACCESS ATUAL
		TRYEXCEPTION

		TcCommit(1,ProcName())    //Begin Transaction

		IF ( TcSqlExec( c_Qry ) < 0 )
			cTCSqlError := TCSQLError()
			ConOut( cMsgOut += ( "[ProcName: " + ProcName() + "]" ) )
			cMsgOut += cCRLF
			ConOut( cMsgOut += ( "[ProcLine:" + Str(ProcLine()) + "]" ) )
			cMsgOut += cCRLF
			ConOut( cMsgOut += ( "[TcSqlError:" + cTCSqlError + "]" ) )
			cMsgOut += cCRLF
			UserException( cMsgOut )
		EndIF

		TcCommit(2,ProcName())    //Commit
		TcCommit(4)                //End Transaction

		CATCHEXCEPTION   

		TcCommit(3) //RollBack
		TcCommit(4) //End Transaction

		ENDEXCEPTION

		// FIM TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ANTERIOR DE GTRAVAÇÃO ESTAVA GERANDO ERRO NO DBACCESS ATUAL

		If ALLTRIM(SC2->C2_FSLOTOP)=""
			dbSelectArea("SC2")
			RecLock("SC2", .F.)
			SC2->C2_FSLOTOP :=   SH6->H6_LOTECTL      
			SC2->(MsUnlock())
		eNDIF

		dbSelectArea("SC2")
		RecLock("SC2", .F.)
		SC2->C2_FSSALDO := SC2->C2_FSSALDO-SH6->H6_QTDPROD
		MsUnlock()

		// U_ATUAD3D5()
		
	Endif
	RestArea(aArea1)
	RestArea(aAreaB2)
	RestArea(aAreaB8)
	RestArea(aAreaH6)

Return l_Ret

/*--------------------------------------------------------------------------
FUNÇÃO ABAIXO CORRIGE AS TABELAS:
SD3 - MOVIMENTOS INTERNOS
SD5 - MOVIMENTOS POR LOTE
SB2 - SALDO PRODUTO
SB8 - SALDO POR LOTE
--------------------------------------------------------------------------*/

User Function ATUAD3D5()
	Local aAreaX        := GetArea()
	Local c_Local := ""
	Local c_Produto := ""
	Local mv_p01 := mv_par01
	Local mv_p02 := mv_par02
	Local mv_p03 := mv_par03	
	Local mv_p04 := mv_par04	

	Local n_Quant2 :=0
	Local n_qtdd4  :=0
	Local n_Quantd5:=0
	Local n_qtdori :=0
	Local n_QD3	   :=0
	//Local cLote    := ""
	c_prodh6 := SH6->H6_PRODUTO

	//	dbSelectArea("SC2")
	//	RecLock("SC2", .F.)
	//	SC2->C2_FSSALDO := SC2->C2_FSSALDO-SH6->H6_QTDPROD
	//	MsUnlock()

	dbSelectArea("SH6")
	//SH6->(dbSetOrder(2))
	n_qtdprod := SH6->H6_QTDPROD
	n_perda := SH6->H6_QTDPERD
	c_ident := SH6->H6_IDENT
	c_parctot := SH6->H6_PT

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))

	IF FOUND()
		n_quantbase := SB1->B1_QB
		Begin Transaction
			dbSelectArea("SG1")
			SG1->(dbSetOrder(1))
			SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
			While SG1->(!EoF()) .And. SG1->G1_COD == c_prodh6 //SC2->C2_PRODUTO
				/*
				dbSelectArea("SH6")
				SH6->(dbSetOrder(2))
				n_qtdprod := SH6->H6_QTDPROD
				n_perda := SH6->H6_QTDPERD
				c_ident := SH6->H6_IDENT
				c_parctot := SH6->H6_PT
				*/

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1") + SG1->G1_COMP))
				dbSelectArea("Z05")
				Z05->(dbSetOrder(1))
				Z05->(dbSeek(xFilial("SB1") + SB1->B1_CODINSU))
				Lperda:=Z05->Z05_PERDA

				IF found() //.and. RTRIM(Z05->Z05_PERDA)="N"				

					dbSelectArea("SD4")
					SD4->(dbSetOrder(2))
					SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP + SG1->G1_COMP))
					IF FOUND()
						n_qtdori := SD4-> D4_QTDEORI
						dbSelectArea("SD3")
						SD3->(dbSetOrder(14))
						SD3->(dbSeek(xFilial("SD3") + SG1->G1_COMP + c_ident))


						If Found()

							c_Produto := SD3->D3_COD
							c_Local   := SD3->D3_LOCAL
							c_Op      := SD3->D3_OP
							d_Data    := SD3->D3_EMISSAO

							// NO ÚLTIMO APONTAMENTO (Condição apontamento="T")É EXECUTADA A QUERY ABAIXO VERIFICANDO O SALDO DOS INSUMOS PENDENTES - SD4 EM 
							// RELAÇÃO À TABELA SD3 - MOVIMENTAÇÃO INTERNA

							If c_parctot="T"
								/*
								cQry:="SELECT SD4.D4_QTDEORI-SUM(SD5.D5_QUANT) AS QUANT, SUM(SD5.D5_QUANT) AS QUANTD5       "+ c_CRLF
								cQry+="FROM "+RetSqlName("SD5")+ " SD5 WITH (NOLOCK)          "+ c_CRLF
								cQry+="INNER JOIN "+RetSqlName("SD4")+ " SD4 WITH (NOLOCK) ON "+ c_CRLF
								cQry+="SD4.D4_FILIAL=SD5.D5_FILIAL                            "+ c_CRLF
								cQry+="AND SD4.D4_COD=D5_COD                                  "+ c_CRLF
								cQry+="AND SD4.D4_OP=D5_OP                                    "+ c_CRLF
								cQry+="WHERE SD3.D5_OP= '" + c_Op              +"'   		  "+ c_CRLF
								cQry+="AND SD3.D5_COD= '" + c_Produto         +"'   		  "+ c_CRLF
								cQry+="AND SD3.D5_ESTORNO<>'S'                                "+ c_CRLF
								cQry+="AND SD5.D_E_L_E_T_<>'*'                                "+ c_CRLF
								cQry+="AND SD4.D_E_L_E_T_<>'*'                                "+ c_CRLF
								cQry+="AND D5_FILIAL='"+xFilial("SD5")+"'  		              "+ c_CRLF
								cQry+="GROUP BY SD4.D4_QTDEORI                                "+ c_CRLF

								MemoWrit("C:\BOMIX\SALDO_RESTD5.SQL",cQry)

								TCQuery cQry New Alias "QRYQTD5"
								*/
								cQry:="SELECT SD4.D4_QTDEORI-SUM(SD3.D3_QUANT) AS QUANT, SUM(SD3.D3_QUANT) AS QUANTD3       "+ c_CRLF
								cQry+="FROM "+RetSqlName("SD3")+ " SD3 WITH (NOLOCK)          "+ c_CRLF
								cQry+="INNER JOIN "+RetSqlName("SD4")+ " SD4 WITH (NOLOCK) ON "+ c_CRLF
								cQry+="SD4.D4_FILIAL=SD3.D3_FILIAL                            "+ c_CRLF
								cQry+="AND SD4.D4_COD=D3_COD                                  "+ c_CRLF
								cQry+="AND SD4.D4_OP=D3_OP                                    "+ c_CRLF
								cQry+="WHERE SD3.D3_OP= '" + c_Op              +"'   		  "+ c_CRLF
								cQry+="AND SD3.D3_COD= '" + c_Produto         +"'   		  "+ c_CRLF
								cQry+="AND SD3.D3_ESTORNO<>'S'                                "+ c_CRLF
								cQry+="AND SD3.D_E_L_E_T_<>'*'                                "+ c_CRLF
								cQry+="AND SD4.D_E_L_E_T_<>'*'                                "+ c_CRLF
								cQry+="AND D3_FILIAL='"+xFilial("SD3")+"'  		              "+ c_CRLF
								cQry+="GROUP BY SD4.D4_QTDEORI                                "+ c_CRLF

								MemoWrit("C:\BOMIX\SALDO_REST.SQL",cQry)

								TCQuery cQry New Alias "QRYQUANT"

								//	If c_parctot="T"
								n_Quant2=QRYQUANT->QUANT
								n_QD3=QRYQUANT->QUANTD3

								QRYQUANT->(DbCloseArea())

								c_Qry := ""
							Else
								n_Quant2:=0
								n_QD3 :=0
								//	n_qtdd4:=n_qtdori-QRYQUANT->QUANT
								//EndIf c_parctot="T"
								//	n_qtdd4:=n_qtdori-QRYQUANT->QUANT
								/*--------------------------------------------------------------------------------------------

								VERIFICA SE OCORRERAM PERDAS NO APONTAMENTO E EVITA PRODUTOS INTEIROS FICAREM FRACIONADOS

								---------------------------------------------------------------------------------------------*/

								If Lperda="N"
									If (( SG1->G1_QUANT-INT(SG1->G1_QUANT)) <> 0 ) //SG1->G1_QUANT/n_quantbase<>1
										n_Quant   := (SG1->G1_QUANT/n_quantbase*n_qtdprod)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)
									Else
										n_Quant   := ROUND((SG1->G1_QUANT/n_quantbase*(n_qtdprod)),0)	// n_Quant   := ROUND(SD3->D3_QUANT,0)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)
									Endif

								Else
									If SG1->G1_QUANT/n_quantbase<>1
										n_Quant   := (SG1->G1_QUANT/n_quantbase*(n_qtdprod+n_perda))  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
									Else
										n_Quant   := ROUND((SG1->G1_QUANT/n_quantbase*(n_qtdprod+n_perda)),0) //ROUND(SD3->D3_QUANT,0)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
									Endif	
									n_Quant=n_Quant+n_Quant2 //-n_QD3
								Endif

								//n_Quant=n_Quant+n_Quant2

								c_numseq  := SD3->D3_NUMSEQ

								if n_QD3<>n_qtdori .OR. Lperda="S"

									RecLock("SD3", .F.)
									//SD3->D3_COD := c_Produto
									//SD3->D3_LOCAL := c_Local         
									//SD3->D3_OP    := c_Op  			
									//SD3->D3_EMISSAO:=   d_Data	    

									// CORRIGE A QUANTIDADE DO INSUMO NA TABELA SD3 - MOVIMENTOS INTERNOS

									SD3->D3_QUANT :=   n_Quant       

									SD3->(MsUnlock())

									//DBSetIndex("T1INDEX1")
									//	Endif
									//// VERIFICAR
									dbSelectArea("SD5")
									SD5->(dbSetOrder(3))
									SD5->(dbSeek(xFilial("SD5") + c_numseq + c_Produto+c_Local ))
									If Found()
										/*							
										c_Produto := SD5->D5_PRODUTO
										c_Local   := SD5->D5_LOCAL
										c_Op      := SD5->D5_OP
										d_Data    := SD5->D5_DATA
										*/

										RecLock("SD5", .F.)
										//SD5->D5_PRODUTO := c_Produto
										//SD5->D5_LOCAL := c_Local         
										//SD5->D5_OP    := c_Op  			
										//SD5->D5_DATA	:=   d_Data	    

										// CORRIGE A QUANTIDADE DO INSUMO NA TABELA SD5 - MOVIMENTOS INTERNOS POR LOTE
										//						SD5->D5_QUANT :=   n_Quant       
										/////////////////////////////////////////////

										//n_quantd5:=0
										If Lperda="N"
											If (( SG1->G1_QUANT-INT(SG1->G1_QUANT)) <> 0 )
												n_Quantd5   := (SG1->G1_QUANT/n_quantbase*n_perda)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
											Else
												n_Quantd5   := ROUND((SG1->G1_QUANT/n_quantbase*n_perda),0) //ROUND(SD3->D3_QUANT,0)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
											Endif	

											While SD5->(!EoF()) .And. SD5->D5_PRODUTO==c_Produto .And. SD5->D5_NUMSEQ=c_numseq //LOCAL = c_Local .And. SD5->D5_OP    := c_Op

												IF n_quantd5<=SD5->D5_QUANT
													SD5->D5_QUANT :=   SD5->D5_QUANT-n_quantd5 
													n_quantd5:=0
												Else
													n_quantd5:=n_quantd5-SD5->D5_QUANT
													SD5->D5_QUANT :=   0 //SD5->D5_QUANT-n_Quant 
												Endif

												SD5->(dbSkip())
											End

											/*
											Else
											If (( SG1->G1_QUANT-INT(SG1->G1_QUANT)) <> 0 )
											n_Quantd5   := (SG1->G1_QUANT/n_quantbase*n_perda)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
											Else
											n_Quantd5   := ROUND((SG1->G1_QUANT/n_quantbase*n_perda),0) //ROUND(SD3->D3_QUANT,0)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
											Endif	
											//Endif
											cQry:="SELECT                                                    "+ c_CRLF           
											cQry+="	SB8.B8_PRODUTO                                           "+ c_CRLF
											cQry+="  , SB8.B8_SALDO                                          "+ c_CRLF
											cQry+="  , SB8.B8_LOTECTL                                        "+ c_CRLF
											cQry+="  , B8_DTVALID                                            "+ c_CRLF
											cQry+="  , SD5.D5_NUMSEQ                                         "+ c_CRLF
											cQry+="FROM "+RetSqlName("SB8")+ " SB8   (NOLOCK)                "+ c_CRLF
											cQry+="	INNER JOIN "+RetSqlName("SD4")+ "   (NOLOCK) SD4         "+ c_CRLF
											cQry+="		ON                                                   "+ c_CRLF
											cQry+="			SD4.D4_FILIAL   =B8_FILIAL                       "+ c_CRLF
											cQry+="			AND SD4.D4_COD  =SB8.B8_PRODUTO                  "+ c_CRLF
											cQry+="			AND SD4.D4_LOCAL=SB8.B8_LOCAL                    "+ c_CRLF
											cQry+="	INNER JOIN " +RetSqlName("SD5")+ "   (NOLOCK) SD5        "+ c_CRLF
											cQry+="		ON                                                   "+ c_CRLF
											cQry+="			SD5.D5_FILIAL     =SB8.B8_FILIAL                 "+ c_CRLF
											cQry+="			AND SD5.D5_PRODUTO=SB8.B8_PRODUTO                "+ c_CRLF
											cQry+="			AND SD5.D5_LOTECTL=SB8.B8_LOTECTL                "+ c_CRLF
											cQry+="			AND SD5.D5_LOCAL  =SB8.B8_LOCAL                  "+ c_CRLF
											cQry+="			AND SD5.D5_OP     =SD4.D4_OP                     "+ c_CRLF
											cQry+="WHERE                                                     "+ c_CRLF
											cQry+="	SD4.D4_OP          ='" + c_Op              +"'           "+ c_CRLF
											cQry+="	AND SB8.B8_LOCAL   ='" + c_Local              +"'        "+ c_CRLF
											cQry+="	AND SB8.B8_SALDO  <>'0'                                  "+ c_CRLF
											cQry+="	AND SB8.D_E_L_E_T_<>'*'                                  "+ c_CRLF
											cQry+="	AND SD4.D_E_L_E_T_<>'*'                                  "+ c_CRLF
											cQry+="	AND SD5.D_E_L_E_T_<>'*'                                  "+ c_CRLF
											cQry+="	AND B8_FILIAL      ='"+xFilial("SB8")+"'                 "+ c_CRLF
											cQry+="	AND SB8.B8_PRODUTO ='" + c_Produto              +"'      "+ c_CRLF
											cQry+="	AND SD5.D5_NUMSEQ  ='" + c_numseq              +"'       "+ c_CRLF
											cQry+="ORDER BY                                                  "+ c_CRLF
											cQry+="	B8_PRODUTO                                               "+ c_CRLF
											cQry+="  , B8_DTVALID                                            "+ c_CRLF

											MemoWrit("C:\BOMIX\SALDO_LOTE.SQL",cQry)
											TCQuery cQry New Alias "QRYLOTE"										
											dbSelectArea("QRYLOTE")

											WHILE QRYLOTE->B8_SALDO>=n_Quantd5 .And. QRYLOTE->B8_PRODUTO=c_Produto .And. n_quantd5<>0

											cLote=QRYLOTE->B8_LOTECTL

											dbSelectArea("SD5")
											SD5->(dbSetOrder(3))
											SD5->(dbSeek(xFilial("SD5") + c_numseq + c_Produto+c_Local ))
											//cLote=SD5->D5_LOTECTL
											While SD5->(!EoF()) .And. SD5->D5_PRODUTO==c_Produto .And. SD5->D5_NUMSEQ=c_numseq .And. SD5->D5_LOTECTL=cLote .And. n_quantd5<>0 //LOCAL = c_Local .And. SD5->D5_OP    := c_Op

											//	IF n_quantd5<=SD5->D5_QUANT

											SD5->D5_QUANT :=   SD5->D5_QUANT+n_quantd5 
											n_quantd5:=0
											//		Else
											//	n_quantd5:=n_quantd5-SD5->D5_QUANT
											//	SD5->D5_QUANT :=   0 //SD5->D5_QUANT-n_Quant 
											//		Endif

											SD5->(dbSkip())
											End
											QRYLOTE->(dbSkip())
											End
											QRYLOTE->(DbCloseArea())
											*/											

										Endif
										//Endif
										SD5->(MsUnlock())
									Endif
									///// verificar
								Endif
							Endif
						Endif
						//						If Lperda="N"
						cQry:=""

						cQry:="SELECT SD4.D4_QTDEORI-SUM(SD3.D3_QUANT) AS QUANT       "+ c_CRLF
						cQry+="FROM "+RetSqlName("SD3")+ " SD3 WITH (NOLOCK)          "+ c_CRLF
						cQry+="INNER JOIN "+RetSqlName("SD4")+ " SD4 WITH (NOLOCK) ON "+ c_CRLF
						cQry+="SD4.D4_FILIAL=SD3.D3_FILIAL                            "+ c_CRLF
						cQry+="AND SD4.D4_COD=D3_COD                                  "+ c_CRLF
						cQry+="AND SD4.D4_OP=D3_OP                                    "+ c_CRLF
						cQry+="WHERE SD3.D3_OP= '" + c_Op              +"'   		  "+ c_CRLF
						cQry+="AND SD3.D3_COD= '" + c_Produto         +"'   		  "+ c_CRLF
						cQry+="AND SD3.D3_ESTORNO<>'S'                                "+ c_CRLF
						cQry+="AND SD3.D_E_L_E_T_<>'*'                                "+ c_CRLF
						cQry+="AND SD4.D_E_L_E_T_<>'*'                                "+ c_CRLF
						cQry+="AND D3_FILIAL='"+xFilial("SD3")+"'  		              "+ c_CRLF
						cQry+="GROUP BY SD4.D4_QTDEORI                                "+ c_CRLF

						MemoWrit("C:\BOMIX\SALDO_REST2.SQL",cQry)

						TCQuery cQry New Alias "QRYQT2"
						n_qtdd4:=QRYQT2->QUANT
						dbSelectArea("SD4")
						RecLock("SD4", .F.)
						SD4->D4_QUANT :=   n_qtdd4
						SD4->(MsUnlock())
						QRYQT2->(DbCloseArea())
						//						Endif
					Endif

					// RODA A ROTINA DE SALDO ATUAL

					U_SALDO(c_Local,c_Produto)

					mv_par01 := mv_p01 
					mv_par02 := mv_p02 
					mv_par03 := mv_p03 	
					mv_par04 := mv_p04 						
				EndIf
				SG1->(dbSkip())
			End
		End Transaction
	Endif
	RestArea(aAreaX)
Return


/*--------------------------------------------------------------------------------------------

FUNÇÃO ABAIXO ATUALIZA OS CAMPOS DE PERGUNTAS DO SALDO ATUAL

---------------------------------------------------------------------------------------------*/


User Function Saldo(c_Local,c_Produto)

	//Local aArea1      := GetArea()
	Local cPerg :="MTA300"
	Local lMsErroAuto := .F.
	Local cDiretorio := ""
	Local cArquivo :=""
	//Identifica que será executado via JOB
	//lJob := .T.
	Local PARAMIXB := .F.

	//Atualiza as perguntas 

	u_zAtuPerg(cPerg, "MV_PAR01", c_Local)     //Armazém De
	u_zAtuPerg(cPerg, "MV_PAR02", c_Local)     //Armazém Até
	u_zAtuPerg(cPerg, "MV_PAR03", c_Produto) //Produto De
	u_zAtuPerg(cPerg, "MV_PAR04", c_Produto) //Produto Até
	Pergunte(cPerg, .F.)

	//Executa a operação automática de Saldo Atual
	lMsErroAuto := .F.
	MSExecAuto({|x| MATA300(x)}, PARAMIXB)

	//Se houve erro, salva um arquivo dentro de C:\BOMIX\
	If lMsErroAuto
		cDiretorio := "C:\BOMIX\"
		cArquivo   := "log_mata300_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-')

		MostraErro(cDiretorio, cArquivo)
	EndIf
	//	RestArea(aArea1)	
Return Nil

//User Function zAtuPerg(cPergAux, cParAux, xConteud)
User Function zAtuPerg(cPerg, cParAux, xConteud)
	//	Local aArea2      := GetArea()
	//Local nPosCont   := 8
	Local nPosPar    := 14
	Local nLinEncont := 0
	Local aPergAux   := {}
	Default xConteud := ""

	//Se não tiver pergunta, ou não tiver ordem

	If Empty(cPerg) .Or. Empty(cParAux)
		Return
	EndIf

	//Chama a pergunta em memória
	//	Pergunte(cPergAux, .F., /*cTitle*/, /*lOnlyView*/, /*oDlg*/, /*lUseProf*/, @aPergAux)
	Pergunte(cPerg, .F.,,,,, @aPergAux)	

	//Procura a posição do MV_PAR
	nLinEncont := aScan(aPergAux, {|x| Upper(Alltrim(x[nPosPar])) == Upper(cParAux) })

	//Se encontrou o parâmetro
	If nLinEncont > 0
		//Caracter
		If ValType(xConteud) == 'C'
			&(cParAux+" := '"+xConteud+"'")

			//Data
		ElseIf ValType(xConteud) == 'D'
			&(cParAux+" := sToD('"+dToS(xConteud)+")'")

			//Numérico ou Lógico
		ElseIf ValType(xConteud) == 'N' .Or. ValType(xConteud) == 'L'
			&(cParAux+" := "+cValToChar(xConteud)+"")

		EndIf

		//Chama a rotina para salvar os parâmetros
		__SaveParam(cPerg, aPergAux)
	EndIf

	//	RestArea(aArea2)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPonto de entrada ³ ALTD4  	 ºAutor  ³VICTOR SOUSA	    º Data ³ 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³ Inclusão de Produção PCP Mod2				 	  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservação ³ Ponto de entrada desenvolvido para alterar os empenhos da º±±
±±º           ³ ordem de produção em caso de produção a maior ou produção º±±
±±º           ³ com perda durante o processo.		                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß        
*/        


/*
User Function ALTD4
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

*/
