#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} BMULTCOM
Relatório - Controle de Ultimas Compras   
@author Elmer Farias / Daniel França
@since 09/12/2020
@version 1.0
	@example
	u_BMULTCOM()
/*/

User Function BMULTCOM()

    Local oReport := nil
    Local cPerg	:=	"BMUCOM" 
    
    //Perguntas na tabela SX1
    AjustaSX1(cPerg)    
    //Gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
    Pergunte(cPerg,.F.)              
        
    oReport := RptDef(cPerg)
    oReport:PrintDialog()
    
Return


Static Function RptDef(cNome)
    Local oReport := Nil
    Local oSection1:= Nil
    Local oSection2:= Nil
    //Local oBreak
    //Local oFunction
    
    /*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
    oReport := TReport():New(cNome,"Controle de Últimas Compras",cNome,{|oReport| ReportPrint(oReport)},"Controle de Últimas Compras")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)   

	//Primeira seção, para apresentação dos grupos dos produtos
  
    oSection1:= TRSection():New(oReport, "Grupos", {"SBM"}, , .F., .T.)
	
	TRCell():New(oSection1,"BM_GRUPO","TABQRY","Grupo")
	TRCell():New(oSection1,"BM_DESC","TABQRY", "Descricao")
  
    //Segunda seção, para apresentação dos produtos

    oSection2:= TRSection():New(oReport, "Produtos", {"SBM","SD1","SB1","SA2"}, NIL, .F., .T.) 

	TRCell():New(oSection2, "D1_COD",   "TABQRY","Código Prod.")
	TRCell():New(oSection2, "B1_DESC",  "TABQRY","Desc. Produto")
	TRCell():New(oSection2, "BM_GRUPO", "TABQRY","Código Grupo")
    TRCell():New(oSection2, "BM_DESC",  "TABQRY","Desc. Grupo")
	TRCell():New(oSection2, "D1_DOC",   "TABQRY","Nota")
	TRCell():New(oSection2, "DTEMIS",   "TABQRY","Emissão")
	TRCell():New(oSection2, "DTDIG",    "TABQRY","Data de Entrada")
	TRCell():New(oSection2, "D1_VUNIT", "TABQRY","Valor_Unit")
	TRCell():New(oSection2, "D1_QUANT", "TABQRY","Quantidade")
	TRCell():New(oSection2, "D1_UM",    "TABQRY","UM")
	TRCell():New(oSection2, "D1_TOTAL", "TABQRY","Valor_Total")
	TRCell():New(oSection2, "D1_VALIPI","TABQRY","Valor_IPI")
	TRCell():New(oSection2, "D1_VALICM","TABQRY","Valor ICMS")
	TRCell():New(oSection2, "A2_EST",   "TABQRY", "UF")
	TRCell():New(oSection2, "A2_NOME",  "TABQRY","Fornecedor")

	
    TRFunction():New(oSection2:Cell("D1_COD"),NIL,"COUNT",,,,,.F.,.T.)
    
    oReport:SetTotalInLine(.F.)
       
    //Aqui, fasso a quebra por seção
    oSection1:SetPageBreak(.T.)
    oSection1:SetTotalText(" ") 
                   
Return(oReport)


Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)     
    Local cQuery    := ""        
    Local cGrup      := ""   
    //Local lPrim     := .T.   
    
    cQuery := " SELECT " + CRLF	
    cQuery += "     D1.D1_COD "  + CRLF
	cQuery += "    ,B1_DESC "  + CRLF
	cQuery += "    ,BM.BM_GRUPO " + CRLF
    cQuery += "    ,BM.BM_DESC " + CRLF
    cQuery += "    ,D1.D1_DOC " + CRLF
    cQuery += "    ,SUBSTRING(D1.D1_EMISSAO,7,2)+'/'+SUBSTRING(D1.D1_EMISSAO,5,2)+'/'+SUBSTRING(D1.D1_EMISSAO,1,4) AS DTEMIS " + CRLF
    cQuery += "    ,SUBSTRING(D1.D1_DTDIGIT,7,2)+'/'+SUBSTRING(D1.D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1.D1_DTDIGIT,1,4) AS DTDIG " + CRLF
    cQuery += "    ,D1.D1_VUNIT "   + CRLF
    cQuery += "    ,D1.D1_QUANT " + CRLF 
    cQuery += "    ,D1.D1_UM " + CRLF 
    cQuery += "    ,D1.D1_TOTAL " + CRLF
    cQuery += "    ,D1.D1_VALIPI " + CRLF
    cQuery += "    ,D1.D1_VALICM " + CRLF
    cQuery += "    ,A2.A2_EST " + CRLF
    cQuery += "    ,A2.A2_NOME " + CRLF
    cQuery += "    FROM ( " + CRLF
    cQuery += "    SELECT " + CRLF   
    cQuery += "     Rank() Over(PARTITION BY D1_FILIAL, D1_COD Order by D1_FILIAL, D1_COD, R_E_C_N_O_ desc) as Rank "  + CRLF
    cQuery += "    ,D1_FILIAL " + CRLF 
    cQuery += "    ,D1_COD " + CRLF 
    cQuery += "    ,R_E_C_N_O_ " + CRLF 
    cQuery += "    FROM SD1010 D1 (nolock) " + CRLF 
    cQuery += "    WHERE 1=1 " + CRLF
    cQuery += "    AND D1_FILIAL = '"+xFilial("SD1")+"'" + CRLF  
    cQuery += "    AND D1_TIPO = 'N' " + CRLF          
    cQuery += "    AND D1_GRUPO <> 'STPJ' " + CRLF 	
    cQuery += "    AND D1.D_E_L_E_T_ <> '*' " + CRLF  
    cQuery += "    ) TB " + CRLF 
    cQuery += "    INNER JOIN " + RetSQLName("SD1") + " D1 " + CRLF   
    cQuery += "    ON D1.R_E_C_N_O_ = TB.R_E_C_N_O_ " + CRLF  
    cQuery += "    INNER JOIN  " + RetSQLName("SB1") + " B1 " + CRLF  
    cQuery += "    ON B1.B1_FILIAL = '"+xFilial("SB1")+"'" + CRLF 
    cQuery += "    AND B1.B1_COD = TB.D1_COD " + CRLF 
    cQuery += "    AND B1.D_E_L_E_T_ <> '*' " + CRLF 
    cQuery += "    INNER JOIN   " + RetSQLName("SBM") + " BM " + CRLF 
    cQuery += "    ON BM.BM_FILIAL = '"+xFilial("SBM")+"'" + CRLF  
    cQuery += "    AND BM.BM_GRUPO = B1.B1_GRUPO " + CRLF 
	cQuery += "    AND BM.D_E_L_E_T_ <> '*' " + CRLF 
    cQuery += "    INNER JOIN  " + RetSQLName("SA2") + " A2 " + CRLF 
    cQuery += "    ON A2.A2_FILIAL = '"+xFilial("SA2")+"'" + CRLF 
    cQuery += "    AND A2.A2_COD = D1.D1_FORNECE " + CRLF	
    cQuery += "    AND A2.D_E_L_E_T_ <> '*' " + CRLF
    cQuery += "    WHERE Rank <= 3 " + CRLF
    cQuery += "    AND B1.B1_COD    BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF
    cQuery += "    AND BM.BM_GRUPO  BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + CRLF
    cQuery += "    ORDER BY TB.D1_COD, TB.R_E_C_N_O_ DESC " + CRLF
        
    // Verifico se o alias esta aberto, e fecho a tabela temporária
    IF Select("TABQRY") <> 0
        DbSelectArea("TABQRY")
        DbCloseArea()
    ENDIF
    
    //crio o novo alias
    TCQUERY cQuery NEW ALIAS "TABQRY"    
    
    dbSelectArea("TABQRY")
    TABQRY->(dbGoTop())
    
    oReport:SetMeter(TABQRY->(LastRec()))    
    
    //Percorro todos os registros da consulta
    
    While !Eof()
        
        If oReport:Cancel()
            Exit
        EndIf
    
        //inicializo a primeira seção
        oSection1:Init()
        oReport:IncMeter()
                    
        cGrup     := TABQRY->BM_GRUPO
        IncProc("Imprimindo Grupos"+alltrim(TABQRY->BM_GRUPO))
        
        //imprimo a primeira seção                
        oSection1:Cell("BM_GRUPO"):SetValue(TABQRY->BM_GRUPO)
        oSection1:Cell("BM_DESC"):SetValue(TABQRY->BM_DESC)                
        oSection1:Printline()
        
        //inicializo a segunda seção
        oSection2:init()
        
        //verifico se o codigo do grupo é o mesmo, se sim, imprimo os produtos
        While TABQRY->BM_GRUPO == cGrup
            oReport:IncMeter()        
        
            IncProc("Imprimindo produtos "+alltrim(TABQRY->D1_COD))
            oSection2:Cell("D1_COD"):SetValue(TABQRY->D1_COD)
            oSection2:Cell("B1_DESC"):SetValue(TABQRY->B1_DESC)
            oSection2:Cell("BM_GRUPO"):SetValue(TABQRY->BM_GRUPO)
            oSection2:Cell("BM_DESC"):SetValue(TABQRY->BM_DESC)
            oSection2:Cell("D1_DOC"):SetValue(TABQRY->D1_DOC)            
            oSection2:Cell("DTEMIS"):SetValue(TABQRY->DTEMIS) 
            oSection2:Cell("DTDIG"):SetValue(TABQRY->DTDIG)  
            oSection2:Cell("D1_VUNIT"):SetValue(TABQRY->D1_VUNIT)
            oSection2:Cell("D1_QUANT"):SetValue(TABQRY->D1_QUANT)
            oSection2:Cell("D1_UM"):SetValue(TABQRY->D1_UM)            
            oSection2:Cell("D1_TOTAL"):SetValue(TABQRY->D1_TOTAL) 
            oSection2:Cell("D1_VALIPI"):SetValue(TABQRY->D1_VALIPI)
            oSection2:Cell("D1_VALICM"):SetValue(TABQRY->D1_VALICM)
            oSection2:Cell("A2_EST"):SetValue(TABQRY->A2_EST)            
            oSection2:Cell("A2_NOME"):SetValue(TABQRY->A2_NOME) 	
            oSection2:Printline()
    
             TABQRY->(dbSkip())
         EndDo        
         //finalizo a segunda seção para que seja reiniciada para o proximo registro
         oSection2:Finish()
         //imprimo uma linha para separar um Grupo do outro
         oReport:ThinLine()
         //finalizo a primeira seção
        oSection1:Finish()
    Enddo
Return

Static function ajustaSx1(cPerg)
   
   local aRegs := {}
    
   DbSelectArea("SX1")	
   DbSetOrder(1)
	
    aAdd(aRegs,{cPerg,"01","Do Produto ?"    ,"","","mv_ch1","C",15,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"02","Ate Produto ?"   ,"","","mv_ch2","C",15,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Do Grupo ?"   ,"","","mv_ch3","C",04,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate Grupo ?"   ,"","","mv_ch4","C",04,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
    	
return