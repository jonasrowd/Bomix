// Bibliotecas necessárias
#Include "TOTVS.ch"

User Function JBIGAUTO()
	Local aData := {} // Vetor com os dados da MsExecAuto

	Private lMsHelpAuto := .T. // Desvia o fluxo de help para o console
	Private lMsErroAuto := .F. // Controle de erros durante execução

	// Exibe uma mensagem para confirmar se o usuário quer seguir com o processo,
	// caso o usuário clique em OK, exibe a caixa de parâmetros
	If (MsgYesNo("Esta função tem a finalidade de dar uma capoeira carpada." + CRLF +;
		"Deseja prosseguir com o carpado twist?", "JBIGAUTO") .And. ParamBox())
		// Com os dados informados pelo usuário em ParamBox(), preenche a query abaixo
		BEGINSQL ALIAS cAlias
			SELECT
				SB1.B1_COD
			FROM
				SB1990 SB1
			WHERE
				SB1.%NOTDEL%
				AND SB1.B1_COD BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		ENDSQL

		// Inicia uma sequência
		BEGIN TRANSACTION
			BEGIN SEQUENCE
				// Verifica se foram retornados registros
				While (!EOF())
					// Monta a estrutura a ser enviada para a MsExecAuto
					AAdd(aData, {"C2_FILIAL",  (cAlias)->(B1_COD), NIL})
					AAdd(aData, {"C2_PRODUTO", (cAlias)->(B1_COD), NIL})
					AAdd(aData, {"C2_NUM",     (cAlias)->(B1_COD), NIL})
					AAdd(aData, {"C2_ITEM",    (cAlias)->(B1_COD), NIL})
					AAdd(aData, {"C2_SEQUEN",  (cAlias)->(B1_COD), NIL})

					// Persiste os dados na rotina
					MsExecAuto({|x, y| MATA650(x, y)}, aData, 3)

					// Verifica se houve sucesso
					// Caso não, exibe o motivo do erro ao usuário e encerra a sequência
					If (lMsErroAuto)
						MostraErro()
						BREAK
					Else
						ConOut("DEU BOM!")
					EndIf

					// Limpa o vetor aData para nova inclusão de valores
					aData := {}
				End
			RECOVER
				// Bloco de recuperação em caso de BREAK
				Help("Awee pai, deu ruim!")
				DisarmTransaction()
			END SEQUENCE
		END TRANSACTION
	EndIf
Return (NIL)
