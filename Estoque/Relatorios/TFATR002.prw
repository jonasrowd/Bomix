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
���Programa  �TFATR002  �Autor  �                    � Data �FEVEREIRO/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Transferencias do ACD - ROMANEIO				  ���
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

User Function TFATR002()
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
	Local cTitulo   := OemToAnsi("Transferencias do ACD - ROMANEIO")
	Local cDesc1    := "Transferencias do ACD - ROMANEIO "
	Local cDesc2    := ""
	Local oSection1
	Local aOrdem    := {"Por Documento", "Por Produto"}
	Local c_Perg    := "FFATR007"
	Local a_Tables  := {"SZW"}   
	Local radape    := "ROMANEIO DE ACORDO COM O PARECER PROFERIDO NO PROCESSO 147870/2018-8 SEFAZ-BA"

	CriaPerg(c_Perg)

	Pergunte(c_Perg,.F.)

	oReport := TReport():New("TFATR002",cTitulo,c_Perg, {|oReport| f_GeraCarga(oReport, aOrdem)},cDesc1+" "+cDesc2)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oSection1 := TRSection():New(oReport,"Transferencias do ACD - ROMANEIO",a_Tables,aOrdem)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetHeaderPage()

	TRCell():New(oSection1,"ZW_OP" 			,"TRB",,,TamSX3("ZW_OP")[1] + 1,.F.,{|| TRB->ZW_OP})
	TRCell():New(oSection1,"ZW_PRODUTO"  	,"TRB",,,,.F.,{|| TRB->ZW_PRODUTO})	
	TRCell():New(oSection1,"B1_DESC"  		,"TRB",,,100,.F.,{|| TRB->B1_DESC})
	TRCell():New(oSection1,"ZW_LOTECTL"  	,"TRB",,,,.F.,{|| TRB->ZW_LOTECTL})
	TRCell():New(oSection1,"ZW_QUANT"  		,"TRB",,,,.F.,{|| TRB->ZW_QUANT})
	TRCell():New(oSection1,"ZW_LOCORIG"  	,"TRB",,,,.F.,{|| TRB->ZW_LOCORIG})
	TRCell():New(oSection1,"ZW_LOCDEST"  	,"TRB",,,,.F.,{|| TRB->ZW_LOCDEST})	
	TRCell():New(oSection1,"ZW_DOC"  		,"TRB",,,,.F.,{|| TRB->ZW_DOC})
	TRCell():New(oSection1,"ZW_EMISSAO"  	,"TRB",,,,.F.,{|| TRB->ZW_EMISSAO})
	TRCell():New(oSection1,"ZW_HORA"  		,"TRB",,,,.F.,{|| TRB->ZW_HORA})
	TRCell():New(oSection1,"ZW_USUARIO"  	,"TRB",,,TamSX3("ZW_USUARIO")[1] + 3,.F.,{|| TRB->ZW_USUARIO})
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
	Local radape    := "ROMANEIO DE ACORDO COM O PARECER PROFERIDO NO PROCESSO 147870/2018-8 SEFAZ-BA"

	oReport:SetTitle(oReport:Title() + " - ("+AllTrim(aOrdem[nOrdem])+")")
    
    oReport:SetPageFooter(3,{|| oReport:Say(oReport:Row(),10,radape,,,,,)}) 

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
		c_OrderBy += "ZW_DOC, ZW_PRODUTO, ZW_LOTECTL"
	Else
		c_OrderBy += "ZW_PRODUTO, ZW_LOTECTL, ZW_OP"
	Endif
	
	c_OrderBy += "%"

	MakeSqlExpr(oReport:uParam)
	oReport:Section(1):BeginQuery()

	If Empty(MV_PAR15)
		BeginSql Alias "TRB"
			SELECT * FROM %TABLE:SZW% SZW 
			INNER JOIN %TABLE:SB1% SB1 ON (B1_FILIAL = %EXP:XFILIAL("SB1")% AND ZW_PRODUTO = B1_COD AND SB1.%NOTDEL%)
	  		WHERE SZW.%NOTDEL% AND ZW_FILIAL = %EXP:XFILIAL("SZW")%
		  	AND (ZW_OP BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%)
		  	AND (ZW_PRODUTO BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%)
		  	AND (ZW_LOTECTL BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%)
		  	AND (ZW_EMISSAO BETWEEN %EXP:DTOS(MV_PAR07)% AND %EXP:DTOS(MV_PAR08)%)
		  	AND (ZW_LOCORIG BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR10%)
		  	AND (ZW_DOC BETWEEN %EXP:MV_PAR11% AND %EXP:MV_PAR12%)
		  	AND (ZW_LOCDEST BETWEEN %EXP:MV_PAR13% AND %EXP:MV_PAR14%)
			ORDER BY %Exp:c_OrderBy%
		EndSql
	Else
		BeginSql Alias "TRB"
			SELECT * FROM %TABLE:SZW% SZW 
			INNER JOIN %TABLE:SB1% SB1 ON (B1_FILIAL = %EXP:XFILIAL("SB1")% AND ZW_PRODUTO = B1_COD AND SB1.%NOTDEL%)
	  		WHERE SZW.%NOTDEL% AND ZW_FILIAL = %EXP:XFILIAL("SZW")%
		  	AND (ZW_OP BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%)
		  	AND (ZW_PRODUTO BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%)
		  	AND (ZW_LOTECTL BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%)
		  	AND (ZW_EMISSAO BETWEEN %EXP:DTOS(MV_PAR07)% AND %EXP:DTOS(MV_PAR08)%)
		  	AND (ZW_LOCORIG BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR10%)
		  	AND (ZW_DOC BETWEEN %EXP:MV_PAR11% AND %EXP:MV_PAR12%)
		  	AND (ZW_LOCDEST BETWEEN %EXP:MV_PAR13% AND %EXP:MV_PAR14%)
		  	AND (ZW_USUARIO = %EXP:MV_PAR15%)
			ORDER BY %Exp:c_OrderBy%
		EndSql
	Endif

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
Return()

Static Function CriaPerg(c_Perg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 	PutSx1(c_Perg,"01","OP de?"  	    ,"","","mv_ch1","C",08,0,0,"G","","SZW","","","mv_par01","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"02","OP at�?" 		,"","","mv_ch2","C",08,0,0,"G","","SZW","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Produto de?"    ,"","","mv_ch3","C",TamSX3("B1_COD")[1],0,0,"G","","SB1"   ,"","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Produto at�?"   ,"","","mv_ch4","C",TamSX3("B1_COD")[1],0,0,"G","","SB1"   ,"","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Lote de?"    	,"","","mv_ch5","C",TamSX3("D3_LOTECTL")[1],0,0,"G","",""  ,"","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Lote at�?"   	,"","","mv_ch6","C",TamSX3("D3_LOTECTL")[1],0,0,"G","",""  ,"","","mv_par06","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"07","Emiss�o de?"    ,"","","mv_ch7","D",8,0,0,"G","",""   	  ,"","","mv_par07","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"08","Emiss�o at�?"   ,"","","mv_ch8","D",8,0,0,"G","",""   	  ,"","","mv_par08","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"09","Local de?"    	,"","","mv_ch9","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par09","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"10","Local at�?"   	,"","","mv_cha","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par10","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"11","Documento de?" 	,"","","mv_chb","C",TamSX3("D3_DOC")[1],0,0,"G","",""   	  ,"","","mv_par11","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"12","Documento at�?"	,"","","mv_chc","C",TamSX3("D3_DOC")[1],0,0,"G","",""   	  ,"","","mv_par12","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"13","Destino de?"    ,"","","mv_chd","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par13","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"14","Destino at�?"   ,"","","mv_che","C",TamSX3("D3_LOCAL")[1],0,0,"G","",""   	  ,"","","mv_par14","","","","","","","","","","","","","","","","")
  	PutSx1(c_Perg,"15","Usu�rio?"       ,"","","mv_chf","C",TamSX3("ZW_USUARIO")[1],0,0,"G","","SZWU" ,"","","mv_par15","","","","","","","","","","","","","","","","")

Return Nil