#Include "Totvs.ch"

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados do apontamento de Produção no MATA681 (Produção PCP Mod2)
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return variant, Logical
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6089410
/*/
User Function MT680VAL()
	Local lRet	:= .T. //Variável para controle da gravação da rotina
	Local aArea	:= GetArea() //Armazena a área do ponto de entrada
	Local nOp	:= SubStr(M->H6_OP,1,6)
	Local nCount	:= 0
	Local ProcValid	:= ""
	Local ProcLote	:= ""

	If lRet .And. l681 //Variável Private para verificar qual o programa está chamando o ponto de entrada
		DbSelectArea("SZ7") //Seleciona a área da tabela customizada que controla as movimentações de estoque para o wms
		DbSetOrder(1)
		DbSeek(FwXFilial("SZ7") + __CUSERID + M->H6_LOCAL)	//Busca a informação do usuário na tabela da rotina customizada
		If !("TOTVSMES" $ M->H6_OBSERVA)
			If !(Z7_TPMOV $ "E|A")	//Se NÃO vier do WebService MES ou o usuário não tenha permissão de entrada no estoque do wms. (E=Entrada, A=Ambos)
				lRet := .F.	//Não permite o apontamento e exibe o Help do bloqueio.
				Help(NIL, NIL, "MOV_ARM", NIL, "O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + M->H6_LOCAL + ".",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contacte o administrador do sistema."})
			ElseIf (M->H6_QTDPERD > 0 .And. lSavePerda == .F. .And. M->H6_PT == "T")
				//Identifica se é apontamento de perda pela quantidade apontada no campo H6_QTDPERD.
				//lSavePerda é variável privada da rotina de apontamento de perda que verifica se foi preenchida corretamente.
				//Verifica também que o apontamento de perda não pode ser Total, ou seja, não pode encerrar OP com Perda.
				//Caso não, bloqueia a gravação do apontamento de perda e exibe o Help do bloqueio.
				lRet := .F.
				M->H6_PT := "P"
				Help(NIL, NIL, "ERROR_PERD", NIL, "Apontamento de perda preenchido incorretamente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os dados do apontamento e lembre-se que não pode encerrar a Op com Perda."})
			EndIf
		EndIf

		If (M->H6_QTDPROD > 0 .And. M->H6_QTDPERD > 0)
			lRet := .F.
			M->H6_QTDPERD	:= 0
			M->H6_QTDPROD	:= 0
			M->H6_PT := "P"
			Help(NIL, NIL, "ERR_APPO", NIL, "Apontamento preenchido incorretamente. Verifique os dados do apontamento.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Lembre-se que não pode encerrar a Op com Perda e não pode apontar perda e produção ao mesmo tempo. Vou resetar os apontamentos para te ajudar."})
		ElseIf (M->H6_QTDPERD > 0 .And. M->H6_PT == "T")
			lRet := .F.
			M->H6_QTDPERD	:= 0
			M->H6_QTDPROD	:= 0
			M->H6_PT := "P"
			Help(NIL, NIL, "ERR_APPO", NIL, "Apontamento preenchido incorretamente. Verifique os dados do apontamento.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Lembre-se que não pode totalizar a Op com Perda e não apontar perda e produção ao mesmo tempo. Vou resetar os apontamentos para te ajudar."})
		EndIf

		DbSelectArea("SB1") //Seleciona a área da SB1 para encontrar o produto do apontamento
		DbSetOrder(1)
		DbSeek(FwXFilial("SB1") + M->H6_PRODUTO)	//Posiciona no produto correto
		If !Empty(SB1->B1_PRVALID) //Verifica se o produto controla lote e se o campo de dias para validade está preenchido
			nCount := SB1->B1_PRVALID	//Armazena a quantidade de dias na variável para cálculo da validade do mesmo
		EndIf

		If Select("SC2TEMP") > 0 //Verifica se o Alias já possui registro
			SC2TEMP->(DbCloseArea()) //Fecha a tabela se já estiver aberta
		EndIf

		//SELECIONA OS REGISTROS DA OP
		BEGINSQL ALIAS "SC2TEMP" 
			COLUMN C2_FSDTVLD AS DATE

			SELECT
				C2.C2_FSDTVLD FSDTVLD,
				C2.C2_FSLOTOP FSLOTOP
			FROM
				%TABLE:SC2% C2
			WHERE
				C2.C2_FILIAL = %XFILIAL:SC2% AND
				C2.C2_NUM = %EXP:nOp% AND
				C2.%NOTDEL%
		ENDSQL

		While SC2TEMP->(!EOF()) //Enquanto não for o final do arquivo procura se já tem uma validade preenchida em qualquer item da Op
			If !Empty(SC2TEMP->FSDTVLD) //Se não é o primeiro apontamento
				ProcValid := STOD(SC2TEMP->FSDTVLD) //Armazena a data de validade da Op
				ProcLote  := SC2TEMP->FSLOTOP
				EXIT
			EndIf
			DbSkip()
		End

		SC2TEMP->(DbCloseArea())

		If (Empty(ProcValid) .Or. Empty(ProcLote))
			If Select("SH6TEMP") > 0 //Verifica se o Alias já possui registro
				SH6TEMP->(DbCloseArea()) //Fecha a tabela se já estiver aberta
			EndIf

			//SELECIONA OS REGISTROS DA OP
			BEGINSQL ALIAS "SH6TEMP" 
				COLUMN H6_DTVALID AS DATE

				SELECT
					TOP 1
					H6.H6_DTVALID AS FSDTVLD,
					H6.H6_LOTECTL AS H6LOTECTL
				FROM
					%TABLE:SH6% H6
				WHERE
					H6.H6_FILIAL = %XFILIAL:SH6% AND
					SubString(H6.H6_OP,1,6) = %EXP:nOp% AND
					H6.%NOTDEL%
				ORDER BY H6.H6_DTVALID DESC
			ENDSQL

			While SH6TEMP->(!EOF()) //Enquanto não for o final do arquivo procura se já tem uma validade preenchida em qualquer item da Op
				If !Empty(SH6TEMP->FSDTVLD) //Se não é o primeiro apontamento
					ProcValid := STOD(SH6TEMP->FSDTVLD) //Armazena a data de validade da Op
					ProcLote  := SH6TEMP->H6LOTECTL
				EndIf
				DbSkip()
			End

			SH6TEMP->(DbCloseArea())
		EndIf

		DbSelectArea("SC2") //Seleciona a área da SC2
		DbSetOrder(1) //Ordena a tabela de acordo com a minha busca
		DbSeek(FwXFilial("SC2") + SubStr(M->H6_OP,1,6) + SubStr(M->H6_OP,7,2) + SubStr(M->H6_OP,9,3)) //Posiciona no item da Op do apontamento atual
		RecLock("SC2", .F.)
			//Se o lote na SC2 for diferente do que está sendo apontado, atualiza o lote na SC2
			If (M->H6_LOTECTL <> ProcLote .Or. M->H6_DTVALID <> ProcValid)
				SC2->C2_FSLOTOP := M->H6_LOTECTL
				SC2->C2_FSDTVLD := M->H6_DTVALID
			EndIf

			If Empty(SC2->C2_FSSALDO)
				SC2->C2_FSSALDO := SC2->C2_QUANT - SC2->C2_QUJE
			Else
				SC2->C2_FSSALDO := (SC2->C2_QUANT - SC2->C2_QUJE) - (M->H6_QTDPROD) //Calcula o saldo no campo customizado na tabela de Op
			EndIf

		SC2->(MsUnlock())

		If Empty(ProcValid)	//Se não encontrou nenhum apontamento anterior, ou seja, não tem validade do lote ainda.
			M->H6_DTVALID := Date() + nCount //Calcula a data de validade pro lote
			RecLock("SC2",.F.)
				SC2->C2_FSDTVLD := M->H6_DTVALID //Salva a validade do lote na tabela de Ops, pois deve ser a mesma validade para todo o lote independente da datahora do apontamento
			SC2->(MsUnlock())
		Else
			M->H6_DTVALID := ProcValid	//Se encontrou data de validade anterior para o mesmo lote, preenche com o valor correto
		EndIf

		IF M->H6_QTGANHO > 0
			MsgYesNo("Excede a produção em: " + STR(M->H6_QTGANHO), "Excedente")
			M->H6_PT := "T"
		Else 
			M->H6_PT := "P"
		EndIf

		DbSelectArea("SB8") //Necessidade de manter a mesma validade para o lote independente de qual armazem ele esteja
		DbSetOrder(5)
		DbSeek(FwXFilial("SB8") + M->H6_PRODUTO + M->H6_LOTECTL ) //Busca o registro atual
		While (!(EOF()) .And. SB8->B8_PRODUTO == M->H6_PRODUTO .And. SB8->B8_LOTECTL == M->H6_LOTECTL)
			If (Empty(SB8->B8_DTVALID) .Or. SB8->B8_DTVALID <> M->H6_DTVALID) 	//Se encontrar o registro e a data de validade estiver vazia
				RecLock("SB8", .F.)
					SB8->B8_DTVALID := M->H6_DTVALID //Grava a data de validade de acordo com o primeiro apontamento
				MsUnlock()
			EndIf
			SB8->(DbSkip())
		End

		DbSelectArea("SG2") //Seleciona a área da SG2 para preencher o apontamento com informações da estrutura do produto
		DbSetOrder(3)
		If (DbSeek(FwXFilial("SG2")+ M->H6_PRODUTO+M->H6_OPERAC))
			M->H6_FERRAM  := SG2->G2_FERRAM //Preenche a ferramenta
			M->H6_FSCAVI  := SG2->G2_FSCAVI //Preenche a cavidade
			M->H6_FSSETOR := SG2->G2_DESCRI //Preenche a descrição do setor
			M->H6_CICLOPD := SG2->G2_FSCICLO //Preenche o ciclo padrão
		EndIf
	EndIf

	RestArea(aArea)

Return (lRet)
