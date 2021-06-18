#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³ Wellington Carvalho   ³ Data ³ 09/09/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ 			Acerto de Saldo em Estoques    					  ³±±
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

User Function ACSALDO
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private var_mat   := " "
Private var_cc    := " "
	 
dbSelectArea("SB2") 
SET ORDER TO 1
dbGoTop()        
While !EOF()     

     VAR_FILIAL  = SB2->B2_FILIAL         
     VAR_COD     = SB2->B2_COD
     VAR_LOCAL   = SB1->B2_LOCAL
     VAR_GRUPO   = SB1->B1_GRUPO 
     VAR_PRECOUNIT = 0.00         
     VAR_QTD = 0.00      
     VAR_DATA  = CTOD("  /  /  ")      
     VAR_TOTSLD  = 0.00
     
     ////////////////// SALDO ATUAL ////////////////////////////
     
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
     
     
     /////////////////////VALORIZAÇÃO DOS ESTOQUES /////////////////////
     
     IF SUBSTR(SB1->B1_GRUPO,1,1) = "B" .OR. SUBSTR(SB1->B1_GRUPO,1,1) = "T"
        dbSelectArea("SD2")
        SET ORDER TO 1
        dbGoTop()
        dbSeek(var_filial+var_COD)
        IF  Eof()     
            
        ELSE    
            VAR_PRECOUNIT = 0.00
            DbSelectArea("SD2")
            DO WHILE SD2->D2_FILIAL = VAR_FILIAL .AND. SD2->D2_COD = VAR_COD
               VAR_PRECOUNIT = SD2->D2_PRCVEN
               VAR_DATA      = SD2->D2_EMISSAO 
               DBSkip()    
            ENDDO 
        ENDIF
                 
        
     ELSE
             
        dbSelectArea("SD1")
        SET ORDER TO 7
        dbGoTop()
        dbSeek(var_filial+var_COD)
        IF !Eof()     
                           
          VAR_PRECOUNIT = 0.00
          DbSelectArea("SD1")
          DO WHILE SD1->D1_FILIAL = VAR_FILIAL .AND. SD1->D1_COD = VAR_COD
             VAR_PRECOUNIT = SD1->D1_VUNIT
             VAR_DATA      = SD1->D1_DTDIGIT 
             DBSkip()    
          ENDDO             
     
        ENDIF
     ENDIF 
     
     RecLock("ZW4", .T.)
     TOT = 0.00
     TOT = VAR_PRECOUNIT *  VAR_TOTSLD 
     ZW4->ZW4_FILIAL = VAR_FILIAL
     ZW4->ZW4_COD    = VAR_COD
     ZW4->ZW4_DESC   = VAR_DESC  
     ZW4->ZW4_QTD    =  VAR_TOTSLD 
     ZW4->ZW4_VLR    = VAR_PRECOUNIT
     ZW4->ZW4_VLRTOT = TOT
     ZW4->ZW4_DATA   = VAR_DATA  
     MsUnlock()   
                   
     dbSelectArea("SB1")
     DBSkip()
     IF EOF()
        EXIT
     ENDIF        
enddo          
          
     
          
    
    Alert("Atualização efetuada com sucesso.")
    
   