#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FESTR004  �Autor  �                    � Data �FEVEREIRO/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Apontado x Transferido					      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���                    A T U A L I Z A C O E S                            ���
�������������������������������������������������������������������������͹��
���DATA      |PROGRAMADOR       |ALTERACOES                               ���
���          |                  |                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FESTR004()
 	Local oReport

 	oReport := ReportDef()
	oReport:PrintDialog()
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �                    � Data �FEVEREIRO/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por montagem da estrutura do relatorio   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���                    A T U A L I Z A C O E S                            ���
�������������������������������������������������������������������������͹��
���DATA      |PROGRAMADOR       |ALTERACOES                               ���
���          |                  |                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef(nRegImp)
	Local cTitulo   := OemToAnsi("Apontado x Transferido")
	Local cDesc1    := "Apontado x Transferido"
	Local cDesc2    := ""
	Local oSection1
	Local aOrdem    := {"Por OP", "Por Sequencial"}
	Local c_Perg    := "FESTR004"
	Local a_Tables  := {"SD3", "SZW"}

	CriaPerg(c_Perg)

	Pergunte(c_Perg,.F.)

	oReport := TReport():New("FESTR004",cTitulo,c_Perg, {|oReport| f_GeraCarga(oReport, aOrdem)},cDesc1+" "+cDesc2)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oSection1 := TRSection():New(oReport,"Apontado x Transferido",a_Tables,aOrdem)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetHeaderPage()

	TRCell():New(oSection1,"D3_OP" 			,"TRB",,,TamSX3("D3_OP")[1] + 1,.F.,{|| TRB->D3_OP})
	TRCell():New(oSection1,"D3_NUMSEQ" 		,"TRB",,,,.F.,{|| TRB->D3_NUMSEQ})	
	TRCell():New(oSection1,"D3_COD"	  		,"TRB",,,,.F.,{|| TRB->D3_COD})	
	TRCell():New(oSection1,"B1_DESC"  		,"TRB",,,100,.F.,{|| TRB->B1_DESC})
	TRCell():New(oSection1,"D3_LOCAL"	  	,"TRB",,,,.F.,{|| TRB->D3_LOCAL})
	TRCell():New(oSection1,"D3_LOTECTL"  	,"TRB",,,,.F.,{|| TRB->D3_LOTECTL})
	TRCell():New(oSection1,"D3_QUANT"  		,"TRB",,,,.F.,{|| TRB->D3_QUANT})
	TRCell():New(oSection1,"D3_EMISSAO"		,"TRB",,,,.F.,{|| TRB->D3_EMISSAO})
	TRCell():New(oSection1,"ZW_DOC"  		,"TRB",,,,.F.,{|| TRB->ZW_DOC})
	TRCell():New(oSection1,"ZW_EMISSAO"  	,"TRB",,,,.F.,{|| TRB->ZW_EMISSAO})
	TRCell():New(oSection1,"ZW_HORA"  		,"TRB",,,,.F.,{|| TRB->ZW_HORA})
	TRCell():New(oSection1,"ZW_LOCDEST"  	,"TRB",,,,.F.,{|| TRB->ZW_LOCDEST})	
	TRCell():New(oSection1,"ZW_QUANT"  		,"TRB",,,,.F.,{|| TRB->ZW_QUANT})
//	TRCell():New(oSection1,"ZW_USUARIO"  	,"TRB",,,TamSX3("ZW_USUARIO")[1] + 3,.F.,{|| TRB->ZW_USUARIO})
Return(oReport)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_GeraCarg�Autor  �                    � Data �FEVEREIRO/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por gerar carga no arquivo de trabalho   ���
���          �que sera impresso posteriormente                            ���
�������������������������������������������������������������������������͹��
���                    A T U A L I Z A C O E S                            ���
�������������������������������������������������������������������������͹��
���DATA      |PROGRAMADOR       |ALTERACOES                               ���
���          |                  |                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_GeraCarga(oReport, aOrdem)
	Local oSection1 := oReport:Section(1)
	Local nOrdem    := oSection1:GetOrder()

	oReport:SetTitle(oReport:Title() + " - ("+AllTrim(aOrdem[nOrdem])+")")

	f_SelectDados(oReport, nOrdem)

	dbSelectArea("TRB")
	TRB->(DBGOTOP())
	oSection1:Init()
	While TRB->(!EOF()) .AND. !oReport:Cancel()
		oSection1:PrintLine()
		oReport:IncMeter()
	  	TRB->(DBSKIP())

		If oReport:Cancel()
			Exit
		EndIf
	ENDDO

	oSection1:Finish()
	TRB->(DBCLOSEAREA())
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_SelectDa�Autor  �                    � Data �FEVEREIRO/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por selecionar os dados a serem impresso ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���                    A T U A L I Z A C O E S                            ���
�������������������������������������������������������������������������͹��
���DATA      |PROGRAMADOR       |ALTERACOES                               ���
���          |                  |                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_SelectDados(oReport, nOrdem)
	Local c_OrderBy := "%"

	If nOrdem == 1
		c_OrderBy += "D3_OP, D3_NUMSEQ, D3_COD"
	Else
		c_OrderBy += "D3_NUMSEQ, D3_COD, D3_OP"
	Endif
	
	c_OrderBy += "%"

	MakeSqlExpr(oReport:uParam)
	oReport:Section(1):BeginQuery()

	BeginSql Alias "TRB"
		SELECT * FROM %TABLE:SD3% SD3 
		INNER JOIN %TABLE:SB1% SB1 ON 
			(B1_FILIAL = %EXP:XFILIAL("SB1")% AND D3_COD = B1_COD AND SB1.%NOTDEL%)
		LEFT JOIN %TABLE:SZW% SZW ON 
			D3_FILIAL=ZW_FILIAL AND D3_OP=ZW_OP AND D3_COD=ZW_PRODUTO AND D3_LOCAL=ZW_LOCORIG 
			AND D3_LOTECTL=ZW_LOTECTL AND D3_NUMSEQ=ZW_SEQORIG AND SZW.D_E_L_E_T_<>'*'
		WHERE 
			SD3.D_E_L_E_T_<>'*' AND D3_ESTORNO<>'S' AND D3_CF='PR0'
			AND D3_FILIAL = %EXP:XFILIAL("SD3")%
		  	AND (D3_OP BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%)
		  	AND (D3_COD BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%)
		  	AND (D3_LOTECTL BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%)
		  	AND (D3_EMISSAO BETWEEN %EXP:DTOS(MV_PAR07)% AND %EXP:DTOS(MV_PAR08)%)
		  	AND (D3_LOCAL BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR10%)
//		  	AND (D3_DOC BETWEEN %EXP:MV_PAR11% AND %EXP:MV_PAR12%)
		ORDER BY %Exp:c_OrderBy%
	EndSql
	
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
Return()

Static Function CriaPerg(c_Perg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 	fPutSx1(c_Perg,"01","OP de?"  	    ,"","","mv_ch1","C",TamSX3("D3_OP")[1],0,0,"G","","SC2","","","mv_par01","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"02","OP at�?" 		,"","","mv_ch2","C",TamSX3("D3_OP")[1],0,0,"G","","SC2","","","mv_par02","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"03","Produto de?"    ,"","","mv_ch3","C",TamSX3("B1_COD")[1],0,0,"G","","SB1"   ,"","","mv_par03","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"04","Produto at�?"   ,"","","mv_ch4","C",TamSX3("B1_COD")[1],0,0,"G","","SB1"   ,"","","mv_par04","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"05","Lote de?"    	,"","","mv_ch5","C",TamSX3("D3_LOTECTL")[1],0,0,"G","",""  ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"06","Lote at�?"   	,"","","mv_ch6","C",TamSX3("D3_LOTECTL")[1],0,0,"G","",""  ,"","","mv_par06","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"07","Emiss�o de?"    ,"","","mv_ch7","D",8,0,0,"G","",""   	  ,"","","mv_par07","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"08","Emiss�o at�?"   ,"","","mv_ch8","D",8,0,0,"G","",""   	  ,"","","mv_par08","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"09","Local de?"    	,"","","mv_ch9","C",TamSX3("D3_LOCAL")[1],0,0,"G","","NNR"   	  ,"","","mv_par09","","","","","","","","","","","","","","","","")
 	fPutSx1(c_Perg,"10","Local at�?"   	,"","","mv_cha","C",TamSX3("D3_LOCAL")[1],0,0,"G","","NNR"   	  ,"","","mv_par10","","","","","","","","","","","","","","","","")
// 	PutSx1(c_Perg,"11","Documento de?" 	,"","","mv_chb","C",TamSX3("D3_DOC")[1],0,0,"G","",""   	  ,"","","mv_par11","","","","","","","","","","","","","","","","")
// 	PutSx1(c_Perg,"12","Documento at�?"	,"","","mv_chc","C",TamSX3("D3_DOC")[1],0,0,"G","",""   	  ,"","","mv_par12","","","","","","","","","","","","","","","","")
Return Nil

Static Function fPutSX1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	Local aArea       := GetArea()
	Local cChaveHelp  := ""

	Default cGrupo    := Space(10)
	Default cOrdem    := Space(02)
	Default cPergunt  := Space(30)
	Default cPerSpa   := Space(30)
	Default cPerEng   := Space(30)
	Default cVar 	  := Space(6)
	Default cTipo     := Space(1)
	Default nTamanho  := 0
	Default nDecimal  := 0
	Default nPreSel   := 0
	Default cGSC      := "G"
	Default cValid    := Space(60)
	Default cF3       := Space(6)
	Default cGrpSxg   := Space(3)
	Default cPyme     := Space(1)
	Default cVar01    := Space(15)
	Default cDef01    := Space(15)
	Default cDefSpa1  := Space(15)
	Default cDefEng1  := Space(15)
	Default cCnt01    := Space(60)
	Default cDef02    := Space(15)
	Default cDefSpa2  := Space(15)
	Default cDefEng2  := Space(15)
	Default cDef03    := Space(15)
	Default cDefSpa3  := Space(15)
	Default cDefEng3  := Space(15)
	Default cDef04    := Space(15)
	Default cDefSpa4  := Space(15)
	Default cDefEng4  := Space(15)
	Default cDef05    := Space(15)
	Default cDefSpa5  := Space(15)
	Default cDefEng5  := Space(15)
	Default aHelpPor  := {}
	Default aHelpEng  := {}
	Default aHelpSpa  := {}
	Default cHelp     := ""

	//Se tiver Grupo, Ordem, Texto, Par�metro, Vari�vel, Tipo e Tamanho, continua para a cria��o do par�metro
	If !Empty(cGrupo) .And. !Empty(cOrdem) .And. !Empty(cPergunt) .And. !Empty(cVar01) .And. !Empty(cVar) .And. !Empty(cTipo) .And. nTamanho != 0
		
		//Defini��o de vari�veis
		cGrupo     := Padr(cGrupo, Len(SX1->X1_GRUPO), " ")           //Adiciona espa�os a direita para utiliza��o no DbSeek
		cChaveHelp := "P." + AllTrim(cGrupo) + AllTrim(cOrdem) + "."  //Define o nome da pergunta
		cVar01     := Upper(cVar01)                                   //Deixa o MV_PAR tudo em mai�sculo
		nPreSel    := Iif(cGSC == "C", 1, 0)                      	  //Se for Combo, o pr�-selecionado ser� o Primeiro
		cDef01     := Iif(cGSC == "F", "56", cDef01)              	  //Se for File, muda a defini��o para ser tanto Servidor quanto Local
		nTamanho   := Iif(nTamanho > 60, 60, nTamanho)                //Se o tamanho for maior que 60, volta para 60 - Limita��o do Protheus
		nDecimal   := Iif(nDecimal > 9,  9,  nDecimal)                //Se o decimal for maior que 9, volta para 9
		nDecimal   := Iif(cGSC == "N", nDecimal, 0)               	  //Se n�o for par�metro do tipo num�rico, ser� 0 o Decimal
		cTipo      := Upper(cTipo)                                	  //Deixa o tipo do Campo em mai�sculo
		cTipo  	   := Iif(! cTipo $ 'C;D;N;', 'C', cTipo)     		  //Se o tipo do Campo n�o estiver entre Caracter / Data / Num�rico, ser� Caracter
		cGSC       := Upper(cGSC)                                 	  //Deixa o tipo do Par�metro em mai�sculo
		cGSC       := Iif(Empty(cGSC), 'G', cGSC)             		  //Se o tipo do Par�metro estiver em branco, ser� um Get
		nTamanho   := Iif(cGSC == "C", 1, nTamanho)               	  //Se for Combo, o tamanho ser� 1
	
		DbSelectArea('SX1')
		SX1->(DbSetOrder(1)) // Grupo + Ordem
	
		//Se n�o conseguir posicionar, a pergunta ser� criada
		If ! SX1->(DbSeek(cGrupo + cOrdem))
			RecLock('SX1', .T.)
				X1_GRUPO   := cGrupo
				X1_ORDEM   := cOrdem
				X1_PERGUNT := cPergunt
				X1_PERSPA  := cPerSpa
				X1_PERENG  := cPerEng
				X1_VAR01   := cVar01
				X1_VARIAVL := cVar
				X1_TIPO    := cTipo
				X1_TAMANHO := nTamanho
				X1_DECIMAL := nDecimal
				X1_GSC     := cGSC
				X1_VALID   := cValid
				X1_F3      := cF3
				X1_DEF01   := cDef01
				X1_DEFSPA1 := cDefSpa1
				X1_DEFENG1 := cDefEng1
				X1_DEF02   := cDef02
				X1_DEFSPA2 := cDefSpa2
				X1_DEFENG2 := cDefEng2
				X1_DEF03   := cDef03
				X1_DEFSPA3 := cDefSpa3
				X1_DEFENG3 := cDefEng3
				X1_DEF04   := cDef04
				X1_DEFSPA4 := cDefSpa4
				X1_DEFENG4 := cDefEng4
				X1_DEF05   := cDef05
				X1_DEFSPA5 := cDefSpa5
				X1_DEFENG5 := cDefEng5
				X1_PRESEL  := nPreSel
				
				//Se tiver Help da Pergunta
				/*
				If !Empty(cHelp)
					X1_HELP    := ""
					
					fPutHelp(cChaveHelp, cHelp)
				EndIf
				*/
			SX1->(MsUnlock())
		EndIf
	EndIf
	
	RestArea(aArea)
Return

/*---------------------------------------------------*
 | Fun��o: fPutHelp                                  |
 | Desc:   Fun��o que insere o Help do Parametro     |
 *---------------------------------------------------*/
/*
Static Function fPutHelp(cKey, cHelp, lUpdate)
	Local cFilePor  := "SIGAHLP.HLP"
	Local cFileEng  := "SIGAHLE.HLE"
	Local cFileSpa  := "SIGAHLS.HLS"
	Local nRet      := 0

	Default cKey    := ""
	Default cHelp   := ""
	Default lUpdate := .F.
	
	//Se a Chave ou o Help estiverem em branco
	If Empty(cKey) .Or. Empty(cHelp)
		Return
	EndIf
	
	//**************************** Portugu�s
	nRet := SPF_SEEK(cFilePor, cKey, 1)
	
	//Se n�o encontrar, ser� inclus�o
	If nRet < 0
		SPF_INSERT(cFilePor, cKey, , , cHelp)
	
	//Sen�o, ser� atualiza��o
	Else
		If lUpdate
			SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
		EndIf
	EndIf
	
	//**************************** Ingl�s
	nRet := SPF_SEEK(cFileEng, cKey, 1)
	
	//Se n�o encontrar, ser� inclus�o
	If nRet < 0
		SPF_INSERT(cFileEng, cKey, , , cHelp)
	
	//Sen�o, ser� atualiza��o
	Else
		If lUpdate
			SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
		EndIf
	EndIf
	
	//**************************** Espanhol
	nRet := SPF_SEEK(cFileSpa, cKey, 1)
	
	//Se n�o encontrar, ser� inclus�o
	If nRet < 0
		SPF_INSERT(cFileSpa, cKey, , , cHelp)
	
	//Sen�o, ser� atualiza��o
	Else
		If lUpdate
			SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
		EndIf
	EndIf
Return
*/