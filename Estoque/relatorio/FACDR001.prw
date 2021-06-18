#INCLUDE "RWMAKE.CH"
#Include "PROTHEUS.CH"
#INCLUDE "Report.CH"
#INCLUDE "topconn.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FACDR001  �Autor  �                    � Data �			  ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Invent�rio Sint�tico do ACD				      ���
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

User Function FACDR001()
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
	Local cTitulo   := OemToAnsi("Invent�rio Sint�tico do ACD")
	Local cDesc1    := "Invent�rio Sint�tico do ACD"
	Local cDesc2    := ""
	Local oSection1
	Local c_Perg    := "FACDR001"
 	Local aOrdem    := {}
	Local a_Tables  := {"SZX"}

	f_ValidPerg(c_Perg)

	Pergunte(c_Perg,.F.)

	oReport := TReport():New("FACDR001",cTitulo,c_Perg, {|oReport| f_GeraCarga(oReport)},cDesc1+" "+cDesc2)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oSection1 := TRSection():New(oReport,"Invent�rio Sint�tico do ACD",a_Tables,aOrdem)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetHeaderPage()

	TRCell():New(oSection1,"ZX_PRODUTO"		,"TRB",,,,.F.,{|| TRB->ZX_PRODUTO})
	TRCell():New(oSection1,"B1_DESC"		,"TRB",,,,.F.,{|| TRB->B1_DESC})
	TRCell():New(oSection1,"ZX_LOCAL"  		,"TRB",,,,.F.,{|| TRB->ZX_LOCAL})	
	TRCell():New(oSection1,"ZX_LOTECTL"  	,"TRB",,,,.F.,{|| TRB->ZX_LOTECTL})
	TRCell():New(oSection1,"ZX_END" 		,"TRB",,,,.F.,{|| TRB->ZX_END})
	TRCell():New(oSection1,"ZX_QUANT1"	  	,"TRB","Contagem 1",,,.F.,{|| TRB->ZX_QUANT1})
	TRCell():New(oSection1,"ZX_QUANT2"	  	,"TRB","Contagem 2",,,.F.,{|| TRB->ZX_QUANT2})
	TRCell():New(oSection1,"ZX_QUANT3"	  	,"TRB","Contagem 3",,,.F.,{|| TRB->ZX_QUANT3})
	TRCell():New(oSection1,"STATUS"	  		,"TRB","Status",,10,.F.,{|| IIF(TRB->ZX_QUANT1 <> TRB->ZX_QUANT2, IIF(TRB->ZX_QUANT3 == 0, "DIVERGENTE", "OK"), "OK")})

	oBreak := TRBreak():New(oSection1,oSection1:Cell("ZX_PRODUTO"),Nil,.F.)

	TRFunction():New(oSection1:Cell("ZX_QUANT1"),/* cID */,"SUM", oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("ZX_QUANT2"),/* cID */,"SUM", oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("ZX_QUANT3"),/* cID */,"SUM", oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
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

	BeginSql Alias "TRB"
		SELECT ZX_FILIAL, ZX_PRODUTO, B1_DESC, ZX_LOCAL, ZX_LOTECTL, ZX_END, 
			ISNULL((SELECT SUM(ZX_QUANT) FROM %TABLE:SZX% ZX WHERE ZX.ZX_FILIAL=SZX.ZX_FILIAL AND ZX.ZX_PRODUTO=SZX.ZX_PRODUTO AND ZX.ZX_LOCAL=SZX.ZX_LOCAL AND ZX.ZX_LOTECTL=SZX.ZX_LOTECTL AND ZX.ZX_END=SZX.ZX_END 
			AND ZX.ZX_CONT=1 AND ZX.D_E_L_E_T_='' AND ZX.ZX_STATUS='C' AND ZX.ZX_DATA >= %EXP:DTOS(MV_PAR09)% AND ZX.ZX_DATA <=%EXP:DTOS(MV_PAR10)%), 0) ZX_QUANT1,
			ISNULL((SELECT SUM(ZX_QUANT) FROM %TABLE:SZX% ZX WHERE ZX.ZX_FILIAL=SZX.ZX_FILIAL AND ZX.ZX_PRODUTO=SZX.ZX_PRODUTO AND ZX.ZX_LOCAL=SZX.ZX_LOCAL AND ZX.ZX_LOTECTL=SZX.ZX_LOTECTL AND ZX.ZX_END=SZX.ZX_END 
			AND ZX.ZX_CONT=2 AND ZX.D_E_L_E_T_='' AND ZX.ZX_STATUS='C' AND ZX.ZX_DATA >= %EXP:DTOS(MV_PAR09)% AND ZX.ZX_DATA <=%EXP:DTOS(MV_PAR10)%), 0) ZX_QUANT2,
			ISNULL((SELECT SUM(ZX_QUANT) FROM %TABLE:SZX% ZX WHERE ZX.ZX_FILIAL=SZX.ZX_FILIAL AND ZX.ZX_PRODUTO=SZX.ZX_PRODUTO AND ZX.ZX_LOCAL=SZX.ZX_LOCAL AND ZX.ZX_LOTECTL=SZX.ZX_LOTECTL AND ZX.ZX_END=SZX.ZX_END 
			AND ZX.ZX_CONT=3 AND ZX.D_E_L_E_T_='' AND ZX.ZX_STATUS='C' AND ZX.ZX_DATA >= %EXP:DTOS(MV_PAR09)% AND ZX.ZX_DATA <=%EXP:DTOS(MV_PAR10)%), 0) ZX_QUANT3
		FROM %TABLE:SZX% SZX 
			JOIN %TABLE:SB1% SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL=%EXP:XFILIAL("SB1")% AND B1_COD=ZX_PRODUTO
		WHERE
			ZX_FILIAL = %EXP:XFILIAL("SZX")% AND SZX.D_E_L_E_T_='' AND ZX_STATUS = 'C' AND
			ZX_PRODUTO >= %EXP:MV_PAR01% AND ZX_PRODUTO    <= %EXP:MV_PAR02% AND
			ZX_LOCAL   >= %EXP:MV_PAR03% AND ZX_LOCAL      <= %EXP:MV_PAR04% AND
			ZX_LOTECTL >= %EXP:MV_PAR05% AND ZX_LOTECTL    <= %EXP:MV_PAR06% AND
			ZX_END     >= %EXP:MV_PAR07% AND ZX_END        <= %EXP:MV_PAR08% AND
			ZX_DATA    >= %EXP:DTOS(MV_PAR09)% AND ZX_DATA <=%EXP:DTOS(MV_PAR10)%
		GROUP BY
			ZX_FILIAL, ZX_PRODUTO, B1_DESC, ZX_LOCAL, ZX_LOTECTL, ZX_END
		ORDER BY
			ZX_LOCAL, ZX_PRODUTO, ZX_END, ZX_LOTECTL
	EndSql

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

	Aadd(a_MV_PAR01, "Informe o Produto inicial")
	Aadd(a_MV_PAR02, "Informe o Produto final")
	Aadd(a_MV_PAR03, "Informe o Armazem inicial")
	Aadd(a_MV_PAR04, "Informe o Armazem final")
	Aadd(a_MV_PAR05, "Informe o Lote inicial")
	Aadd(a_MV_PAR06, "Informe o Lote final")
	Aadd(a_MV_PAR07, "Informe o Endere�o inicial")
	Aadd(a_MV_PAR08, "Informe o Endere�o final")
	Aadd(a_MV_PAR09, "Informe a Data inicial")
	Aadd(a_MV_PAR10, "Informe a Data final")

	//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Produto de?  	    ","","","mv_ch1","C",TamSX3("B1_COD")[1],0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","",a_MV_PAR01)
	PutSx1(c_Perg,"02","Produto ate?    	","","","mv_ch2","C",TamSX3("B1_COD")[1],0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","",a_MV_PAR02)
	PutSx1(c_Perg,"03","Armazem de?        	","","","mv_ch3","C",TamSX3("B1_LOCPAD")[1],0,0,"G","","NNR","",""   ,"MV_PAR03","","","","","","","","","","","","","","","","",a_MV_PAR03)
	PutSx1(c_Perg,"04","Armazem ate?       	","","","mv_ch4","C",TamSX3("B1_LOCPAD")[1],0,0,"G","","NNR" ,"","","mv_par04","","","","","","","","","","","","","","","","",a_MV_PAR04)
	PutSx1(c_Perg,"05","Lote de?           	","","","mv_ch5","C",TamSX3("D3_LOTECTL")[1],0,0,"G","","" ,"","","mv_par05","","","","","","","","","","","","","","","","",a_MV_PAR05)
	PutSx1(c_Perg,"06","Lote ate?           ","","","mv_ch6","C",TamSX3("D3_LOTECTL")[1],0,0,"G","","" ,"","","mv_par06","","","","","","","","","","","","","","","","",a_MV_PAR06)
	PutSx1(c_Perg,"07","Endere�o de?      	","","","mv_ch7","C",TamSX3("ZX_END")[1],0,0,"G","","" ,"","","mv_par07","","","","","","","","","","","","","","","","",a_MV_PAR07)
	PutSx1(c_Perg,"08","Endere�o ate?     	","","","mv_ch8","C",TamSX3("ZX_END")[1],0,0,"G","","" ,"","","mv_par08","","","","","","","","","","","","","","","","",a_MV_PAR08)
	PutSx1(c_Perg,"09","Data de?      		","","","mv_ch9","D",08,0,0,"G","","" ,"","","mv_par09","","","","","","","","","","","","","","","","",a_MV_PAR09)
	PutSx1(c_Perg,"10","Data ate?           ","","","mv_cha","D",08,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",a_MV_PAR10)
Return