#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} PEDCOMP
Relatório - Relatorio Comparativo Valor Ultima Compra
@author Elmer Farias
@since 24/07/20
@version 1.0
	@example
	u_PEDCOMP()
/*/


User Function PEDCOMP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg		:=	"PEDC" 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjusaSX1()


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

oReport := TReport():New("COMPARATIVO ULTIMA COMPRA","ULTMA_COMPRA",cPerg,{|oReport| PrintRep(oReport)},"Relatorio Comparativo Valor Ultima Compra")
oReport:SetLandscape(.T.)

oSecCab := TRSection():New( oReport , "ULTMA_COMPRA", {"QRY"} )

    TRCell():New(oSecCab, "C7_FILIAL",  "QRY","Filial")
    TRCell():New(oSecCab, "C7_NUM",     "QRY","Pedido")
	TRCell():New(oSecCab, "C7_FSFLUIG", "QRY","Cod Fluig")
	TRCell():New(oSecCab, "C7_FORNECE", "QRY","Cod Fornec")
	TRCell():New(oSecCab, "A2_NOME",    "QRY","Nome Fornec")
	TRCell():New(oSecCab, "C7_LOJA",    "QRY","Loja") 
	TRCell():New(oSecCab, "C7_PRODUTO", "QRY","Cod.Produto")
	TRCell():New(oSecCab, "C7_DESCRI",  "QRY","Descricao")
    TRCell():New(oSecCab, "DTEMIS"  ,   "QRY", "Data Emissao")
    TRCell():New(oSecCab, "DTDIGIT ",   "QRY","Data Ult. Compra")
	TRCell():New(oSecCab, "C7_PRECO",   "QRY","Valor Pedido")
	TRCell():New(oSecCab, "DIFER",      "QRY","Valor Ultima Compra")
	TRCell():New(oSecCab, "DIFERENCA",  "QRY","DIFERENCA")
	
	
	
//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
//TRFunction():New(oSecCab:Cell("B1_COD"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o relatorio para impressao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function PrintRep(oReport)

Local cQuery     := ""

Pergunte(cPerg,.F.)

cQuery := " SELECT " + CRLF   
cQuery += "     C7.C7_FILIAL "  + CRLF
cQuery += "    ,C7.C7_NUM "  + CRLF
cQuery += "    ,C7.C7_FSFLUIG "  + CRLF
cQuery += "    ,C7.C7_FORNECE " + CRLF
cQuery += "    ,A2.A2_NOME " + CRLF
cQuery += "    ,C7.C7_LOJA " + CRLF
cQuery += "    ,C7.C7_PRODUTO " + CRLF
cQuery += "    ,C7.C7_DESCRI " + CRLF
cQuery += "    ,SUBSTRING(C7.C7_EMISSAO,7,2)+'/'+SUBSTRING(C7.C7_EMISSAO,5,2)+'/'+SUBSTRING(C7.C7_EMISSAO,1,4) AS DTEMIS " + CRLF
cQuery += "    ,SUBSTRING(D13.D1_DTDIGIT,7,2)+'/'+SUBSTRING(D13.D1_DTDIGIT,5,2)+'/'+SUBSTRING(D13.D1_DTDIGIT,1,4) AS DTDIGIT " + CRLF
cQuery += "    ,C7.C7_PRECO " + CRLF
cQuery += "    ,ISNULL(D13.D1_VUNIT,0) DIFER " + CRLF
cQuery += "    ,C7.C7_PRECO - ISNULL(D13.D1_VUNIT,0) AS DIFERENCA " + CRLF
cQuery += "    FROM " + RetSqlName("SC7") + " C7 " + CRLF
cQuery += "    INNER JOIN " + RetSQLName("SA2") + " A2 " + CRLF 
cQuery += "    ON A2.A2_FILIAL = '"+xFilial("SA2")+"'" + CRLF
cQuery += "    AND A2.A2_COD = C7.C7_FORNECE " + CRLF
cQuery += "    AND A2.A2_LOJA = C7.C7_LOJA " + CRLF 
cQuery += "    AND A2.D_E_L_E_T_ <> '*' " + CRLF 
cQuery += "    LEFT JOIN " + RetSQLName("SD1") + " D13 " + CRLF
cQuery += "    ON D13.D1_FILIAL = '"+xFilial("SD1")+"'" + CRLF
cQuery += "    AND D13.D1_FORNECE = C7.C7_FORNECE " + CRLF
cQuery += "    AND D13.D1_LOJA = C7.C7_LOJA " + CRLF 
cQuery += "    AND  D13.D1_COD = C7.C7_PRODUTO " + CRLF
cQuery += "    AND D13.D_E_L_E_T_ <> '*' " + CRLF
cQuery += "    AND D13.D1_DTDIGIT IN (  " + CRLF
cQuery += "    SELECT MAX(D1_DTDIGIT)  " + CRLF
cQuery += "    FROM  SD1010 (NOLOCK)  " + CRLF
cQuery += "    WHERE D1_COD = C7_PRODUTO  " + CRLF
cQuery += "    AND D1_DTDIGIT <= C7_EMISSAO  " + CRLF        
cQuery += "    AND D1_FORNECE  = C7_FORNECE  " + CRLF          
cQuery += "    AND D1_LOJA     = C7_LOJA   " + CRLF
cQuery += "    AND D1_LOJA     = C7_LOJA   " + CRLF          
cQuery += "    AND D1_QUANT    > 0    " + CRLF          
cQuery += "    AND D1_FILIAL   = C7_FILIAL " + CRLF    
cQuery += "    AND D_E_L_E_T_ <>'*' )
cQuery += " WHERE C7.C7_FILIAL = '"+xFilial("SC7")+"'" + CRLF
cQuery += " AND C7.C7_CONAPRO  = 'L' " + CRLF
cQuery += " AND C7.C7_FSFLUIG <> '0' " + CRLF
cQuery += " AND C7.C7_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF
cQuery += " AND C7.C7_PRODUTO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + CRLF
cQuery += " AND C7_FORNECE  BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + CRLF
cQuery += " AND C7_FSFLUIG  BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + CRLF
cQuery += " AND C7.C7_EMISSAO  BETWEEN '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' " + CRLF
cQuery += " AND C7.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "   GROUP BY C7.C7_FILIAL " + CRLF
cQuery += "   , C7.C7_NUM " + CRLF
cQuery += "   , C7.C7_NUM " + CRLF
cQuery += "   , C7.C7_FSFLUIG " + CRLF
cQuery += "   , C7.C7_FORNECE " + CRLF
cQuery += "   , A2.A2_NOME " + CRLF 
cQuery += "   , C7.C7_LOJA " + CRLF
cQuery += "   , C7.C7_PRODUTO " + CRLF
cQuery += "   , C7.C7_DESCRI " + CRLF
cQuery += "   , C7.C7_EMISSAO " + CRLF
cQuery += "   , D13.D1_DTDIGIT " + CRLF
cQuery += "   , C7.C7_PRECO " + CRLF
cQuery += "   , D13.D1_VUNIT " + CRLF 
cQuery += "   ORDER BY C7.C7_FILIAL, C7.C7_NUM, C7.C7_PRODUTO " + CRLF
MemoWrite("\queries\Elmer.sql", cQuery)
cQuery := ChangeQuery(cQuery)     
	
If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

oSecCab:BeginQuery()
//oSecCab:EndQuery({{"QRY"},cQuery})
oSecCab:setQuery("QRY",cQuery)
oSecCab:Print()  



Return Nil

//=============
// Cria o pergunte
//============
Static Function AjusaSX1()
     
   local aRegs       := {}
    
   
   DbSelectArea("SX1")	
   DbSetOrder(1) 
  
                
    AADD(aRegs,{cPerg,"01","Pedido De ?"    ,"","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Pedido Até ?"   ,"","","mv_ch2","C",,06,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Produto De ?"   ,"","","mv_ch3","C",15,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Produto Até ?"   ,"","","mv_ch4","C",15,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Fornecedor De ?"  ,"","","mv_ch5","C",06,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Fornecedor Até ?" ,"","","mv_ch6","C",06,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	AADD(aRegs,{cPerg,"07","Cod Fluig De ?"   ,"","","mv_ch7","C",16,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Cod Fluig Até ?"  ,"","","mv_ch8","C",16,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Da Emissao ?"     ,"","","mv_ch9","D",08,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Até Emissao ? "   ,"","","mv_cha","D",08,00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})       

    
	

Return()