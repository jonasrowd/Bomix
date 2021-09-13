#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "REPORT.CH"

/*/{Protheus.doc} FFATR99
Relatório - Relatorio de Custo NF de Saida 
@author Elmer Farias
@since 12/03/20
@version 1.0
	@example
	u_FFATR99()
/*/


User Function FFATR99()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg		:=	"CUSTD2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjudaSX1()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ReportDef()
oReport:PrintDialog()

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definição da estrutura do relatório.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function ReportDef()                                             

oReport := TReport():New("FFATR99","Custo NF de Saida",cPerg,{|oReport| PrintReport(oReport)},"Custo NF de Saida")
oReport:SetLandscape(.T.)

oSecCab := TRSection():New( oReport , "Custo", {"QRY"} )
 

    TRCell():New(oSecCab, "D2_DOC",   "QRY","NF Saída")
	TRCell():New(oSecCab, "D2_EMISSAO", "QRY","Emissão")
//	TRCell():New(oSecCab, "D2_COD",  "QRY","Cod Produto") 
	TRCell():New(oSecCab, "B1_COD",  "QRY","Cod Produto") 	
	TRCell():New(oSecCab, "B1_DESC",  "QRY","Produto")
    TRCell():New(oSecCab, "D3_QUANT",  "QRY","Quant")
	TRCell():New(oSecCab, "D2_PESO",  "QRY","Peso")
	TRCell():New(oSecCab, "D2_LOTECTL","QRY","Lote")
//	TRCell():New(oSecCab, "CTOD(D2_DTVALID)",  "QRY","Validade")
	TRCell():New(oSecCab, "D2_DTVALID",  "QRY","Validade")
	TRCell():New(oSecCab, "H6_OP", "QRY","Operacao")
//	TRCell():New(oSecCab, "H6_IDENT", "QRY","Identif")
//	TRCell():New(oSecCab, "B1_RASTRO", "QRY","Rastro")
	TRCell():New(oSecCab, "D3_CUSTO1", "QRY","Custo")
	


//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
//TRFunction():New(oSecCab:Cell("B1_COD"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o relatorio para impressao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function PrintReport(oReport)

Local cQuery     := ""

Pergunte(cPerg,.F.)

/*
cQuery += " SELECT " + CRLF   
cQuery += "     D2_DOC "  + CRLF
cQuery += "    ,D2_EMISSAO "  + CRLF
cQuery += "    ,D2_COD " + CRLF
cQuery += "    ,B1_DESC " + CRLF 
cQuery += "    ,D2_QUANT " + CRLF 
cQuery += "    ,D2_PESO " + CRLF 
cQuery += "    ,D2_LOTECTL "  + CRLF
cQuery += "    ,D2_DTVALID " + CRLF
cQuery += "    ,H6_OP " + CRLF 
cQuery += "    ,H6_IDENT " + CRLF
cQuery += "    ,B1_RASTRO " + CRLF 
cQuery += "    ,D3_CUSTO1 " + CRLF 
cQuery += " FROM " + RetSqlName("SD2") + " D2 (NOLOCK) " + CRLF
cQuery += " INNER JOIN " + RetSQLName("SB1") + " B1 (NOLOCK) ON B1.D_E_L_E_T_ <> '*' AND B1_FILIAL = '0101' AND D2_COD = B1_COD " + CRLF
cQuery += " INNER JOIN " + RetSQLName("SH6") + " H6 (NOLOCK) ON H6.D_E_L_E_T_ <> '*' AND H6_FILIAL = '010101' AND D2_COD = H6_PRODUTO AND D2_LOTECTL = H6_LOTECTL AND B1_RASTRO = 'L' " + CRLF
cQuery += " INNER JOIN " + RetSQLName("SD3") + " D3 (NOLOCK) ON D3.D_E_L_E_T_ <> '*' AND D3_FILIAL = '010101' AND D3_ESTORNO <> 'S' AND H6_OP = D3_OP AND H6_IDENT = D3_IDENT AND D3_CF <> 'PR0' " + CRLF
cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2") + "' " + CRLF
cQuery += " AND  D2_DOC    BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF     
cQuery += " AND  D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04) + "' " + CRLF
cQuery += " AND  D2.D_E_L_E_T_ <> '*' " + CRLF
*/                 



cQuery := " SELECT																" + CRLF			
cQuery += "     D2.D2_DOC                                                       " + CRLF
cQuery += "   , D2.D2_EMISSAO                                                   " + CRLF
cQuery += "   , B1_IN.B1_COD                                                       " + CRLF
cQuery += "   , D3.D3_QUANT                                                     " + CRLF
cQuery += "   , B1_IN.B1_DESC                                                      " + CRLF
cQuery += "   , D3.D3_GRUPO                                                     " + CRLF
cQuery += "   , D2.D2_PESO                                                      " + CRLF
cQuery += "   , D3.D3_CUSTO1                                                    " + CRLF
cQuery += "   , D2.D2_LOTECTL                                                   " + CRLF
cQuery += "   , D2.D2_DTVALID                                                   " + CRLF
cQuery += "   , H6.H6_OP                                                        " + CRLF
cQuery += "   , H6.H6_IDENT                                                     " + CRLF
cQuery += "   , D3.D3_COD                                                       " + CRLF
cQuery += "   , B1_IN.B1_DESC INS                                               " + CRLF
cQuery += "   , B1.B1_RASTRO                                                    " + CRLF
cQuery += "   , D3.D3_LOTECTL                                                   " + CRLF
cQuery += "   , D5.D5_LOTECTL                                                   " + CRLF
cQuery += "   , D5.D5_QUANT                                                     " + CRLF
cQuery += "   , D3.D3_QUANT                                                     " + CRLF
cQuery += " FROM                                                                " + CRLF
cQuery += "     SD2010 D2 (NOLOCK)                                              " + CRLF
cQuery += "     INNER JOIN                                                      " + CRLF
cQuery += "         " + RetSqlName("SB1") + " B1(NOLOCK)                		" + CRLF
cQuery += "         ON                                                          " + CRLF
cQuery += "             B1_FILIAL          = '0101'                             " + CRLF
cQuery += "             AND B1.D_E_L_E_T_ <> '*'                                " + CRLF
cQuery += "             AND D2.D2_COD      = B1.B1_COD                          " + CRLF
cQuery += "     INNER JOIN                                                      " + CRLF
cQuery += "         " + RetSqlName("SH6") + " H6 (NOLOCK)                       " + CRLF
cQuery += "         ON                                                          " + CRLF
cQuery += "             H6_FILIAL          = '010101'                           " + CRLF
cQuery += "             AND H6.D_E_L_E_T_ <> '*'                                " + CRLF
cQuery += "             AND D2.D2_COD      = H6.H6_PRODUTO                      " + CRLF
cQuery += "             AND D2.D2_LOTECTL  = H6.H6_LOTECTL                      " + CRLF
cQuery += "             AND B1_RASTRO      = 'L'                                " + CRLF
cQuery += "     INNER JOIN                                                      " + CRLF
cQuery += "         " + RetSqlName("SD3") + " D3 (NOLOCK)                       " + CRLF
cQuery += "         ON                                                          " + CRLF
cQuery += "             D3_FILIAL          = '010101'                           " + CRLF
cQuery += "             AND D3.D_E_L_E_T_ <> '*'                                " + CRLF
cQuery += "             AND D3.D3_ESTORNO <> 'S'                                " + CRLF
cQuery += "             AND H6.H6_OP       = D3.D3_OP                           " + CRLF
cQuery += "             AND H6.H6_IDENT    = D3.D3_IDENT                        " + CRLF
cQuery += "             AND D3.D3_CF      <> 'PR0'                              " + CRLF
cQuery += "     INNER JOIN                                                      " + CRLF
cQuery += "         " + RetSqlName("SB1") + " B1_IN (NOLOCK)                    " + CRLF
cQuery += "         ON                                                          " + CRLF
cQuery += "             B1_IN.B1_FILIAL       = '0101'                          " + CRLF
cQuery += "             AND B1_IN.D_E_L_E_T_ <> '*'                             " + CRLF
cQuery += "             AND D3.D3_COD         = B1_IN.B1_COD                    " + CRLF
cQuery += "     INNER JOIN                                                      " + CRLF
cQuery += "         " + RetSqlName("SD5") + " D5 (NOLOCK)                       " + CRLF
cQuery += "         ON                                                          " + CRLF
cQuery += "             D5_FILIAL          = '010101'                           " + CRLF
cQuery += "             AND D5.D_E_L_E_T_ <> '*'                                " + CRLF
cQuery += "             AND D3.D3_COD      = D5.D5_PRODUTO                      " + CRLF
cQuery += "             AND D3.D3_NUMSEQ   = D5.D5_NUMSEQ                       " + CRLF
cQuery += "             AND D3.D3_OP       = D5.D5_OP                           " + CRLF
cQuery += " WHERE                                                               " + CRLF
cQuery += "     D2.D_E_L_E_T_    <> '*'                                         " + CRLF
cQuery += "     AND D2_FILIAL     = '010101'                                    " + CRLF
cQuery += "     AND D2_DOC      BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF
cQuery += " AND  D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04) + "' " + CRLF



cQuery := ChangeQuery(cQuery)
	
If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

oSecCab:BeginQuery()
oSecCab:EndQuery({{"QRY"},cQuery})
oSecCab:Print()

Return Nil

//=============
// Cria o pergunte
//============
Static Function AjudaSX1(cPerg,aRegs)

	DbSelectArea("SX1")
	DbSetOrder(1)
	
	aRegs :={}
	
    aAdd(aRegs,{cPerg,"01","Da NF Saída ?"    ,"","","mv_ch1","C",09,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"02","Ate NF Saída ?"   ,"","","mv_ch2","C",09,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"03","Da Emissao ?"   ,"","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"04","Ate Emissao ?"   ,"","","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
    
	
   //	U_AjudaSx1(cPerg,aRegs)

Return()