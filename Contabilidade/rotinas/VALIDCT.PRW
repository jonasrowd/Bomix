                                  

User Function VALIDCT
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private var_mat   := " "
	Private var_cc    := " "
	          
       dbSelectArea("CT1")
       SET ORDER TO 1      
       dbGoTop() 
       do while !eof()    
          
          BUSCACT = CT1->CT1_CONTA
          dbSelectArea("CVD")
          SET ORDER TO 1      
          dbGoTop()
          CONTACONTA = 0   
          If dbSeek(xFilial("CVD")+BUSCACT)
             DO while .t.
                if CVD->CVD_CONTA = BUSCACT
                   CONTACONTA = CONTACONTA + 1
                   dbskip() 
                   if eof()
                      exit
                   endif   
                else   
                   if CONTACONTA > 1  
                      CONTACONTA = 0   
                      Alert(BUSCACT)
                      exit
                   endif   
                endif
             enddo
           endif
           dbSelectArea("CT1")
           dbskip()
        enddo   
          
                                   Ê