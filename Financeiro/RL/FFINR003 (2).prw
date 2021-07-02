#INCLUDE "RWMAKE.CH"
#Include "PROTHEUS.CH"
#INCLUDE "Report.CH"
#INCLUDE "topconn.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FFINR003  �Autor  �                    � Data �			  ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Posi��o do Cliente/Fornecedor			      ���
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

User Function FFINR003()
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
	Local cTitulo  := OemToAnsi("Posi��o do Cliente/Fornecedor")
	Local cDesc1   := "Posi��o do Cliente/Fornecedor"
	Local cDesc2   := ""
	Local oSection1
	Local c_Perg  := "FFINR003"
 	Local aOrdem    := {}
	Local a_Tables  := {"SE1"}

	f_ValidPerg(c_Perg)

	Pergunte(c_Perg,.F.)

	oReport := TReport():New("FFINR003",cTitulo,c_Perg, {|oReport| f_GeraCarga(oReport)},cDesc1+" "+cDesc2)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oSection1 := TRSection():New(oReport,"Posi��o do Cliente/Fornecedor",a_Tables,aOrdem)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetHeaderPage()

	TRCell():New(oSection1,"E1_CLIENTE"		,"TRB","Cli/For",,,.F.,{|| TRB->CLIFOR})
	TRCell():New(oSection1,"E1_LOJA"  		,"TRB",,,,.F.,{|| TRB->LOJA})
	TRCell():New(oSection1,"E1_NOMCLI"  	,"TRB","Nome",,,.F.,{|| TRB->NOMCLIFOR})
	TRCell():New(oSection1,"E1_PREFIXO"		,"TRB",,,,.F.,{|| TRB->PREFIXO})
	TRCell():New(oSection1,"E1_NUM"  		,"TRB",,,,.F.,{|| TRB->NUM})	
	TRCell():New(oSection1,"E1_PARCELA"  	,"TRB",,,,.F.,{|| TRB->PARCELA})
	TRCell():New(oSection1,"E1_TIPO"	  	,"TRB",,,,.F.,{|| TRB->TIPO})
	TRCell():New(oSection1,"E1_EMISSAO"  	,"TRB",,,,.F.,{|| DTOC(STOD(TRB->EMISSAO))})
	TRCell():New(oSection1,"E1_VENCREA"  	,"TRB",,,,.F.,{|| DTOC(STOD(TRB->VENCREA))})
	TRCell():New(oSection1,"E1_VALOR"  		,"TRB",,,,.F.,{|| TRB->VALOR})
	TRCell():New(oSection1,"E1_VALJUR"  	,"TRB",,,,.F.,{|| TRB->VALJUR})
	TRCell():New(oSection1,"E1_VALOR"  		,"TRB","Valor Rec/Pag",,,.F.,{|| TRB->VALRECPAG})
	TRCell():New(oSection1,"E5_VALOR"  		,"TRB","Valor Atrasado",,,.F.,{|| TRB->VALOR - TRB->VALRECPAG})
	TRCell():New(oSection1,"E1_JUROS"  		,"TRB",,,,.F.,{|| IIF(STOD(TRB->VENCREA) < MV_PAR09, (TRB->VALOR * 0.009) + DateDiffDay(MV_PAR09, STOD(TRB->VENCREA)) * TRB->VALJUR, 0)})
	TRCell():New(oSection1,"E1_HIST"  	    ,"TRB",,,,.F.,{|| TRB->HIST})
	TRCell():New(oSection1,"E1_NATUREZ"     ,"TRB",,,,.F.,{|| TRB->NATUREZA})

	oBreak := TRBreak():New(oSection1,oSection1:Cell("E1_CLIENTE"),Nil,.F.)

	TRFunction():New(oSection1:Cell("E5_VALOR"),/* cID */,"SUM", oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("E1_JUROS"),/* cID */,"SUM", oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
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

Static Function f_GeraCarga(oReport)
	Local oSection1 := oReport:Section(1)

	f_SelectDados(oReport)

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

Static Function f_SelectDados(oReport)
	Local c_Query := ""

	MakeSqlExpr(oReport:uParam)
	oReport:Section(1):BeginQuery()
	
	IF MV_PAR10 == 1
		BeginSql Alias "TRB"
			SELECT E1_PREFIXO PREFIXO, E1_NUM NUM, E1_PARCELA PARCELA, E1_TIPO TIPO, E1_CLIENTE CLIFOR, E1_LOJA LOJA, E1_NOMCLI NOMCLIFOR, E1_EMISSAO EMISSAO, E1_VENCREA VENCREA, E1_VALOR VALOR,  E1_VALJUR VALJUR, 
			E1_HIST HIST, ISNULL(SUM(E5_VALOR),0) VALRECPAG, E1_NATUREZ NATUREZA FROM %TABLE:SE1% SE1 
			LEFT JOIN %TABLE:SE5% SE5 ON SE5.D_E_L_E_T_='' AND E5_FILIAL=E1_FILIAL AND E5_PREFIXO=E1_PREFIXO AND E5_NUMERO=E1_NUM AND E5_PARCELA=E1_PARCELA AND E5_TIPO=E1_TIPO 
			AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA AND E5_RECPAG='R' AND E5_DATA<=%EXP:DTOS(MV_PAR09)% AND E5_SITUACA<>'C'  AND E5_MOTBX NOT IN ('LIQ') AND NOT EXISTS (SELECT * FROM %TABLE:SE5% WHERE 
			D_E_L_E_T_<>'*' AND E5_FILIAL=SE5.E5_FILIAL AND E5_PREFIXO=SE5.E5_PREFIXO AND E5_NUMERO=SE5.E5_NUMERO AND E5_PARCELA=SE5.E5_PARCELA AND E5_TIPO=SE5.E5_TIPO 
			AND E5_CLIFOR=SE5.E5_CLIFOR AND E5_LOJA=SE5.E5_LOJA AND E5_RECPAG='P' AND E5_TIPODOC='ES' AND E5_SEQ=SE5.E5_SEQ)
			WHERE SE1.D_E_L_E_T_<>'*' AND E1_FILIAL=%EXP:XFILIAL("SE1")% AND E1_CLIENTE BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND E1_LOJA BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
			AND E1_EMISSAO BETWEEN %EXP:DTOS(MV_PAR07)% AND %EXP:DTOS(MV_PAR08)% AND E1_TIPO NOT IN ('PR','RA','PA','NCC','NDF') AND E1_VENCREA BETWEEN %EXP:DTOS(MV_PAR11)% AND %EXP:DTOS(MV_PAR12)%
			AND E1_NATUREZ BETWEEN %EXP:MV_PAR13% AND %EXP:MV_PAR14%
			GROUP BY E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_VALJUR, E1_HIST, E1_NATUREZ
			HAVING E1_VALOR>ISNULL(SUM(E5_VALOR),0)
			ORDER BY E1_CLIENTE, E1_LOJA
		EndSql
	ELSE
		BeginSql Alias "TRB"
			SELECT E2_PREFIXO PREFIXO, E2_NUM NUM, E2_PARCELA PARCELA, E2_TIPO TIPO, E2_FORNECE CLIFOR, E2_LOJA LOJA, E2_NOMFOR NOMCLIFOR, E2_EMISSAO EMISSAO, E2_VENCREA VENCREA, E2_VALOR VALOR, E2_VALJUR VALJUR, 
			E2_HIST HIST, ISNULL(SUM(E5_VALOR),0) VALRECPAG, E2_NATUREZ NATUREZA FROM %TABLE:SE2% SE2 
			LEFT JOIN %TABLE:SE5% SE5 ON SE5.D_E_L_E_T_='' AND E5_FILIAL=E2_FILIAL AND E5_PREFIXO=E2_PREFIXO AND E5_NUMERO=E2_NUM AND E5_PARCELA=E2_PARCELA AND E5_TIPO=E2_TIPO 
			AND E5_CLIFOR=E2_FORNECE AND E5_LOJA=E2_LOJA AND E5_RECPAG='P' AND E5_DATA<=%EXP:DTOS(MV_PAR09)% AND E5_SITUACA<>'C'  AND E5_MOTBX NOT IN ('LIQ') AND NOT EXISTS (SELECT * FROM %TABLE:SE5% WHERE 
			D_E_L_E_T_<>'*' AND E5_FILIAL=SE5.E5_FILIAL AND E5_PREFIXO=SE5.E5_PREFIXO AND E5_NUMERO=SE5.E5_NUMERO AND E5_PARCELA=SE5.E5_PARCELA AND E5_TIPO=SE5.E5_TIPO 
			AND E5_CLIFOR=SE5.E5_CLIFOR AND E5_LOJA=SE5.E5_LOJA AND E5_RECPAG='R' AND E5_TIPODOC='ES' AND E5_SEQ=SE5.E5_SEQ)
			WHERE SE2.D_E_L_E_T_<>'*' AND E2_FILIAL=%EXP:XFILIAL("SE2")% AND E2_FORNECE BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND E2_LOJA BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
			AND E2_EMISSAO BETWEEN %EXP:DTOS(MV_PAR07)% AND %EXP:DTOS(MV_PAR08)% AND E2_TIPO NOT IN ('PR','RA','PA','NCC','NDF') AND E2_VENCREA BETWEEN %EXP:DTOS(MV_PAR11)% AND %EXP:DTOS(MV_PAR12)%
			AND E2_NATUREZ BETWEEN %EXP:MV_PAR13% AND %EXP:MV_PAR14%
			GROUP BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_EMISSAO, E2_VENCREA, E2_VALOR, E2_VALJUR, E2_HIST, E2_NATUREZ
			HAVING E2_VALOR>ISNULL(SUM(E5_VALOR),0)
			ORDER BY E2_FORNECE, E2_LOJA
		EndSql
	ENDIF

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_ValidPer�Autor  �                    � Data �FEVEREIRO/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao resposnvel pela criacao do dicionario de perguntas X1���
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

Static Function f_ValidPerg(c_Perg)
	Local a_MV_PAR01 := {}
	Local a_MV_PAR02 := {}
	Local a_MV_PAR03 := {}
	Local a_MV_PAR04 := {}
	Local a_MV_PAR05 := {}
	Local a_MV_PAR06 := {}
	Local a_MV_PAR07 := {}
	Local a_MV_PAR08 := {}
	Local a_MV_PAR09 := {}
	Local a_MV_PAR10 := {}
	Local a_MV_PAR11 := {}
	Local a_MV_PAR12 := {}
	Local a_MV_PAR13 := {}
	Local a_MV_PAR14 := {}

	Aadd(a_MV_PAR01, "Informe o Cliente inicial")
	Aadd(a_MV_PAR02, "Informe o Cliente final")
	Aadd(a_MV_PAR03, "Informe o Fornecedor inicial")
	Aadd(a_MV_PAR04, "Informe o Fornecedor final")
	Aadd(a_MV_PAR05, "Informe o Loja inicial")
	Aadd(a_MV_PAR06, "Informe o Loja final")
	Aadd(a_MV_PAR07, "Informe a Data de Emiss�o inicial")
	Aadd(a_MV_PAR08, "Informe a Data de Emiss�o final")
	Aadd(a_MV_PAR09, "Informe a Data da Posi��o")
	Aadd(a_MV_PAR10, "Informe a Posi��o a ser considerada")
	Aadd(a_MV_PAR11, "Informe a Data de Vencimento inicial")
	Aadd(a_MV_PAR12, "Informe a Data de Vencimento final")
	Aadd(a_MV_PAR13, "Informe a Natureza inicial")
	Aadd(a_MV_PAR14, "Informe a Natureza final")

	//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Cliente de?  	      ","","","mv_ch1","C",TamSX3("A1_COD")[1],0,0,"G","","SA1","","","mv_par01","","","","","","","","","","","","","","","","",a_MV_PAR01)
	PutSx1(c_Perg,"02","Cliente ate?    	  ","","","mv_ch2","C",TamSX3("A1_COD")[1],0,0,"G","","SA1","","","mv_par02","","","","","","","","","","","","","","","","",a_MV_PAR02)
	PutSx1(c_Perg,"03","Fornecedor de?        ","","","mv_ch3","C",TamSX3("A2_COD")[1],0,0,"G","","SA2","",""   ,"MV_PAR03","","","","","","","","","","","","","","","","",a_MV_PAR03)
	PutSx1(c_Perg,"04","Fornecedor ate?       ","","","mv_ch4","C",TamSX3("A2_COD")[1],0,0,"G","","SA2" ,"","","mv_par04","","","","","","","","","","","","","","","","",a_MV_PAR04)
	PutSx1(c_Perg,"05","Loja de?           	  ","","","mv_ch5","C",02,0,0,"G","","" ,"","","mv_par05","","","","","","","","","","","","","","","","",a_MV_PAR05)
	PutSx1(c_Perg,"06","Loja ate?             ","","","mv_ch6","C",02,0,0,"G","","" ,"","","mv_par06","","","","","","","","","","","","","","","","",a_MV_PAR06)
	PutSx1(c_Perg,"07","Data Emissao de?      ","","","mv_ch7","D",08,0,0,"G","","" ,"","","mv_par07","","","","","","","","","","","","","","","","",a_MV_PAR07)
	PutSx1(c_Perg,"08","Data Emissao ate?     ","","","mv_ch8","D",08,0,0,"G","","" ,"","","mv_par08","","","","","","","","","","","","","","","","",a_MV_PAR08)
	PutSx1(c_Perg,"09","Data da Posi��o?      ","","","mv_ch9","D",08,0,0,"G","","" ,"","","mv_par09","","","","","","","","","","","","","","","","",a_MV_PAR09)
	PutSx1(c_Perg,"10","Posi��o?              ","","","mv_cha","N",01,0,0,"C","","","","","mv_par10","Cliente","","","","Fornecedor","","","","","","","","","","","",a_MV_PAR10)
	PutSx1(c_Perg,"11","Vencimento de?        ","","","mv_chb","D",08,0,0,"G","","" ,"","","mv_par11","","","","","","","","","","","","","","","","",a_MV_PAR11)
	PutSx1(c_Perg,"12","Vencimento ate?       ","","","mv_chc","D",08,0,0,"G","","" ,"","","mv_par12","","","","","","","","","","","","","","","","",a_MV_PAR12)
	PutSx1(c_Perg,"13","Natureza de?          ","","","mv_chd","C",TamSX3("E1_NATUREZ")[1],0,0,"G","","SED" ,"","","mv_par13","","","","","","","","","","","","","","","","",a_MV_PAR13)
	PutSx1(c_Perg,"14","Natureza ate?         ","","","mv_che","C",TamSX3("E1_NATUREZ")[1],0,0,"G","","SED" ,"","","mv_par14","","","","","","","","","","","","","","","","",a_MV_PAR14)
Return