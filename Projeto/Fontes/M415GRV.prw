/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M415GRV   º Autor ³ Christian Rocha    º Data ³Novembro/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada acionado após a gravação das informações  º±±
±±º          ³ do Orçamento em todas as opções (inclusão, alteração e 	  º±±
±±º          ³ exclusão). O PARAMIXB estará com o número da opção (1, 2   º±±
±±º          ³ ou 3).													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bloqueia a arte caso o Orçamento defina o bloqueio da arte.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A T U A L I Z A C O E S                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ºANALISTA           ºALTERACOES                              º±±
±±º          º                   º                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M415GRV

	private cfil :="      "
	cFil := FWCodFil()
	if cFil = "030101"
		return
	endif

	If PARAMIXB[1] == 1 .OR. PARAMIXB[1] == 2

		If Select("E1TEMP") > 0
			E1TEMP->(dbCloseArea())
		Endif

		BeginSql alias 'E1TEMP'
        column E1_EMISSAO as Date
        column E1_VENCREA  as Date

        SELECT 

        sum(E1_VALOR) VALOR

        FROM %table:SE1% SE1

        WHERE 
        E1_SALDO > 0 AND 
        E1_CLIENTE = %exp:SCJ->CJ_CLIENTE% AND
        E1_LOJA = %exp:SCJ->CJ_LOJA% AND
        SE1.%notDel% AND
        E1_TIPO = 'NF' AND 
        E1_VENCREA < %exp:DtoS(dDataBase)% AND 
        E1_BAIXA = ''
        
		EndSql

		RecLock("SCJ",.F.)
		If E1TEMP->(VALOR) != 0
			SCJ->CJ_BXSTATU := 'B'
		Else
			SCJ->CJ_BXSTATU := 'L'
		EndIf

		SCJ->(MsUnlock())

	EndIF

	If SCJ->CJ_BXSTATU = 'B'
		MsgStop("Tratar as pendências financeiras deste cliente.", "Atenção!")
	EndIf
Return
