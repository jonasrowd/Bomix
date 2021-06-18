/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MT110ENDC  ºAutor  ³ VICTOR SOUSA       º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada disponibilizado para gravação de valores  º±±
±±º          ³ e campos específicos na SC1. Executado durante a aprovacao º±±
±±º          ³ bloqueio ou rejeição da Solicitação de Compras.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM - Compras									      º±±
±±Ì          ³ Este ponto de entrada está sendo utilizado para incluir    ¹±±
±±º          ³ a data de aprovação caso seja aprovado ou remover a data   ¹±±
±±º          ³ caso seja rejeitado o bloqueado.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º25/07/19  º                  º                                         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±    

*/                                          

                                    

User Function MT110END()

Local nNumSC := PARAMIXB[1]       // Numero da Solicitação de compras 
Local nOpca := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear
dbSelectArea("SC1")     
	RECLOCK("SC1",.F.)     
	IF nOpca == 1         
		SC1->C1_DATAAP := DDATABASE   
	ELSE
		SC1->C1_DATAAP := CTOD("  /  /  ")
	ENDIF
	 MSUNLOCK()

Return() 