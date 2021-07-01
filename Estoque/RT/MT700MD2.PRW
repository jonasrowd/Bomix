#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'     

#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³ Wellington Carvalho   ³ Data ³ 09/09/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ 			Custo atual dos Estoques    					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT700MD2
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private var_mat   := " "
Private var_cc    := " "
Private var_dt1 := CTOD("01/10/16")
Private var_dt2 := CTOD("30/10/16")



	 
dbSelectArea("SB1")                                                                 
SET DELE ON
SET ORDER TO 1
dbGoTop()   

     
While !EOF()               

     
     VAR_FILIAL  = ALLTRIM(SB1->B1_FILIAL)+"01"         
     VAR_COD     = SB1->B1_COD
     VAR_DESC    = SB1->B1_DESC
     VAR_GRUPO   = SB1->B1_GRUPO
     VAR_UM      = SB1->B1_UM 
     VAR_PRECOUNIT = 0.00         
     VAR_QTD = 0.00      
     VAR_DATA  = DDATABASE      
     VAR_TOTSLD  = 0.00
     VAR_PRECOUNITD1 = 0.00
     VAR_QUANTD1     = 0.00
     VAR_QUANTSD1    = 0.00
     VAR_PRECOD2     = 0.00
     VAR_QUANTD2     = 0.00       
     VAR_QUANTD3     = 0.00
     
          
     ////////////////// SALDO ATUAL ////////////////////////////
    
    /*
     
     dbSelectArea("SB2")
     SET ORDER TO 1
     dbGoTop()
     dbSeek(var_filial+var_COD)
     IF Eof()           
                
     ELSE  
     
        VAR_TOTSLD = 0
        dbSelectArea("SB2") 
        DO WHILE SB2->B2_FILIAL = VAR_FILIAL .AND. SB2->B2_COD = VAR_COD 
           VAR_TOTSLD = VAR_TOTSLD + B2_QATU
           DBSkip()     
        ENDDO
     
     ENDIF
      
     */
     
     /////////////////////VALORIZAÇÃO DOS ESTOQUES /////////////////////
     
     /// Valorizacao das entradas       
    
	
    c_Qry := "SELECT D1_FILIAL, D1_COD, D1_DTDIGIT, D1_QUANT, D1_QTSEGUM, D1_VUNIT FROM SD1010"
    c_Qry += " WHERE D1_FILIAL = '010101' AND  D1_DTDIGIT >='20161001' AND D1_DTDIGIT <='20161030' AND D_E_L_E_T_<>'*'"
    c_Qry += " ORDER BY D1_FILIAL, D1_COD"
	
	
    TCQUERY c_Qry NEW ALIAS QRYD1
     
    dbSelectArea("QRYD1")
	dbGoTop() 
                         
   	While QRYD1->(!EoF()) 
   
        IF QRYD1->D1_COD = VAR_COD 
          
           VAR_QUANTD1     = VAR_QUANTD1  + QRYD1->D1_QUANT
           VAR_QUANTSD1    = VAR_QUANTSD1 + QRYD1->D1_QTSEGUM
           
           IF QRYD1->D1_QUANT <> 0.00       
              VAR_PRECOUNITD1 = VAR_PRECOUNITD1 + QRYD1->D1_VUNIT
           ENDIF
           
            
         ENDIF
          
         DBSkip()    
    ENDDO             
     
     
    /// Valorizacao das saidas   
       
    
    c_Qry := "SELECT D2_FILIAL, D2_COD, D2_DTDIGIT, D2_QUANT, D2_QTSEGUM FROM SD2010"
    c_Qry += " WHERE D2_FILIAL = '010101' AND  D2_DTDIGIT >='20161001' AND D2_DTDIGIT <='20161030' AND D_E_L_E_T_<>'*'"
    c_Qry += " ORDER BY D2_FILIAL, D2_COD"
	  
    
    TCQUERY c_Qry NEW ALIAS QRYD2
    
    dbSelectArea("QRYD2")
	dbGoTop() 
                           
    While QRYD2->(!EoF()) 
          IF  QRYD2->D2_COD = VAR_COD 
              
              VAR_QUANTD2     = VAR_QUANTD2  + QRYD2->D2_QUANT
           
              IF QRYD2->D2_QUANT <> 0.00
                 VAR_PRECOD2 = VAR_PRECOD2 + QRYD2->D2_PRCVEN                               
              ENDIF   
                    
          
          ENDIF
             
          DBSkip()    
     ENDDO             
       
   
   
        
        // Valorizacao das Producao
        
      
   
    c_Qry := "SELECT D3_FILIAL, D3_COD, D3_CF, D3_QUANT, D3_QTSEGUM FROM SD3010"
    c_Qry += " WHERE D3_FILIAL = '010101' AND  D3_EMISSAO >='20161001' AND D3_EMISSAO <='20161030' AND D3_CF = 'RE1' AND D_E_L_E_T_<>'*'"
    c_Qry += " ORDER BY D3_FILIAL, D3_COD, D3_EMISSAO"
	  
    
    TCQUERY c_Qry NEW ALIAS QRYD3
   
    
    dbSelectArea("QRYD3")
	dbGoTop() 
                           
    While QRYD3->(!EoF()) 
          IF  QRYD3->D3_COD = VAR_COD 
              
              VAR_QUANTD3     = VAR_QUANTD3  + QRYD3->D3_QUANT
                               
          
          ENDIF
             
          DBSkip()    
     ENDDO
    
     
     
     RecLock("ZW4", .T.)
           
     ZW4->ZW4_FILIAL = VAR_FILIAL
     ZW4->ZW4_COD    = VAR_COD
     ZW4->ZW4_DESC   = VAR_DESC  
     ZW4->ZW4_UM     = VAR_UM
     ZW4->ZW4_GRUPO  = VAR_GRUPO
     ZW4->ZW4_QTD1   = VAR_QUANTD1 
     ZW4->ZW4_QTD12  = VAR_QUANTSD1
     ZW4->ZW4_PRD1   = VAR_PRECOUNITD1
     ZW4->ZW4_PRD2   = VAR_PRECOD2
     ZW4->ZW4_QTD3   = VAR_QUANTD3
     ZW4->ZW4_DATA   = var_dt2               
     ZW4->ZW4_SLDATU = VAR_TOTSLD
     MsUnlock()   
     
                                       
     QRYD1->(dbCloseArea())
     QRYD2->(dbCloseArea())    
     QRYD3->(dbCloseArea())
          
                   
     dbSelectArea("SB1")
     DBSkip()
     IF EOF()
        EXIT
     ENDIF        
enddo          
          
     
          
    
    Alert("Atualização efetuada com sucesso.")
    
   