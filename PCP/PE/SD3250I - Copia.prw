//Bibliotecas
#Include "Protheus.ch"
#include 'parmtype.ch'
#include "rwmake.ch"
#include "TbiConn.ch"
#INCLUDE "APVT100.CH"
#Include "TopConn.ch"


/*------------------------------------------------------------------------------------------------------*
| P.E.:  SD3250I                                                                                       |
| Desc:  Função para gravar informações na SD3 após gerar a produção                                   |
| Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6087850                                  |
*------------------------------------------------------------------------------------------------------*/

User Function SD3250I()

	Local aArea1        := GetArea()
	Local aAreaB2        := SB2->(GetArea())
	Local aAreaB8        := SB8->(GetArea())
	Local aAreaH6    := SH6->(GetArea())
	//	Local aAreaD3    := SD3->(GetArea())
	//	Local aAreaC2    := SC2->(GetArea())

	Local l_Ret := .T.
	Local cQry        := ""
	Local m_data        := ""
	Local m_lote        := ""	
	Local m_produto     := ""
	//Local c_Local 		:= ""

	c_CRLF  := chr(13) + chr(10)

	dbSelectArea("SH6")
	If cFilAnt == "010101" 

		m_lote=SH6->H6_LOTECTL
		m_produto=SH6->H6_PRODUTO

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

		c_Qry := " BEGIN TRAN " + c_CRLF
		c_Qry += " UPDATE " + RetSqlName("SB8") + " SET B8_DTVALID = '" + m_data +"'"+ c_CRLF
		c_Qry += " WHERE B8_LOTECTL= '" +m_lote +"'" + c_CRLF
		c_Qry += " AND B8_PRODUTO= '" +m_produto +"'" + c_CRLF
		c_Qry += " 	AND B8_FILIAL = '" + xFilial("SB8") + "'" + c_CRLF	

		If TcSqlExec(c_Qry) < 0
			MsgStop("SQL Error: " + TcSqlError())
			TcSqlExec("ROLLBACK")
			l_Ret := .F.
		Else
			TcSqlExec("COMMIT")	
			l_Ret := .T.
		Endif
		//		RestArea(aArea1)
		//		RestArea(aAreaH6)		
		U_ATUAD3D5()
	Endif
	RestArea(aArea1)
	RestArea(aAreaB2)
	RestArea(aAreaB8)
	RestArea(aAreaH6)



Return l_Ret



User Function ATUAD3D5()
	//	Local aArea        := GetArea()
	//Local aAreaD3    := SD3->(GetArea())
	//Local aAreaC2    := SC2->(GetArea())
	Local c_Local := ""
	Local c_Produto := ""

	n_Quant2 :=0
	c_prodh6 := SH6->H6_PRODUTO


	//// VICTOR SOUSA 26/01/20
	dbSelectArea("SC2")
	SC2->C2_FSSALDO := SC2->C2_FSSALDO-SH6->H6_QTDPROD


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

						dbSelectArea("SD3")
						SD3->(dbSetOrder(14))
						SD3->(dbSeek(xFilial("SD3") + SG1->G1_COMP + c_ident))


						If Found()

							c_Produto := SD3->D3_COD
							c_Local   := SD3->D3_LOCAL
							/*
							c_Op      := SD3->D3_OP
							d_Data    := SD3->D3_EMISSAO
							*/
							If c_parctot="T"
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

								//MemoWrit("VALIDLOTE.SQL",cQry)

								TCQuery cQry New Alias "QRYQUANT"

								n_Quant2=QRYQUANT->QUANT

								QRYQUANT->(DbCloseArea())

								c_Qry := ""
							Else
								n_Quant2=0
							EndIf

							If Lperda="N"
								If (( SG1->G1_QUANT-INT(SG1->G1_QUANT)) <> 0 ) //SG1->G1_QUANT/n_quantbase<>1
									n_Quant   := (SG1->G1_QUANT/n_quantbase*n_qtdprod)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)
								Else
									n_Quant   := ROUND(SD3->D3_QUANT,0)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)
								Endif
							Else
								If SG1->G1_QUANT/n_quantbase<>1
									n_Quant   := (SG1->G1_QUANT/n_quantbase*(n_qtdprod+n_perda))  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
								Else
									n_Quant   := ROUND(SD3->D3_QUANT,0)  //SD3->D3_QTDEORI - n_qtdprod //+ (SG1->G1_QUANT * n_Perc)							
								Endif	
							Endif

							n_Quant=n_Quant+n_Quant2

							c_numseq  := SD3->D3_NUMSEQ

							RecLock("SD3", .F.)
							//SD3->D3_COD := c_Produto
							//SD3->D3_LOCAL := c_Local         
							//SD3->D3_OP    := c_Op  			
							//SD3->D3_EMISSAO:=   d_Data	    
							SD3->D3_QUANT :=   n_Quant       

							SD3->(MsUnlock())

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
								SD5->D5_QUANT :=   n_Quant       

								SD5->(MsUnlock())
							Endif

						Endif
					Endif
					U_SALDO(c_Local,c_Produto)
				EndIf
				SG1->(dbSkip())
			End
		End Transaction
	Endif
	//	RestArea(aArea)
Return


User Function Saldo(c_Local,c_Produto)

	//Local aArea1      := GetArea()
	Local cPerg :=""
	Local lMsErroAuto := .F.
	Local cDiretorio := ""
	Local cArquivo :=""
	//Identifica que será executado via JOB
	lJob := .F.

	//Atualiza as perguntas (baixar fonte em https://terminaldeinformacao.com/2017/02/28/funcao-altera-conteudo-de-perguntas-mv_par-em-advpl/ )
	cPerg := "MTA300"
	u_zAtuPerg(cPerg, "MV_PAR01", c_Local)     //Armazém De
	u_zAtuPerg(cPerg, "MV_PAR02", c_Local)     //Armazém Até
	u_zAtuPerg(cPerg, "MV_PAR03", c_Produto) //Produto De
	u_zAtuPerg(cPerg, "MV_PAR04", c_Produto) //Produto Até
	Pergunte(cPerg, .F.)

	//Executa a operação automática
	lMsErroAuto := .F.
	MSExecAuto({|x| MATA300(x)}, lJob)

	//Se houve erro, salva um arquivo dentro da protheus data
	If lMsErroAuto
		cDiretorio := "\x_erros\"
		cArquivo   := "log_mata300_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-')

		MostraErro(cDiretorio, cArquivo)
	EndIf
	//	RestArea(aArea1)	
Return


User Function zAtuPerg(cPergAux, cParAux, xConteud)
	//	Local aArea2      := GetArea()
	//Local nPosCont   := 8
	Local nPosPar    := 14
	Local nLinEncont := 0
	Local aPergAux   := {}
	Default xConteud := ""



	//Se não tiver pergunta, ou não tiver ordem
	If Empty(cPergAux) .Or. Empty(cParAux)
		Return
	EndIf

	//Chama a pergunta em memória
	//	Pergunte(cPergAux, .F., /*cTitle*/, /*lOnlyView*/, /*oDlg*/, /*lUseProf*/, @aPergAux)
	Pergunte(cPergAux, .F.,,,,, @aPergAux)	

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
		__SaveParam(cPergAux, aPergAux)
	EndIf

	//	RestArea(aArea2)
Return
