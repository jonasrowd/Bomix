#Include 'Totvs.ch'

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
	Local aArea	:= GetArea() //Armazena a área do ponto de entrada
	Local lRet	:= .T. //Variável para controle da gravação da rotina

	If lRet .And. l681 //Variável Private para verificar qual o programa está chamando o ponto de entrada
		DbSelectArea('SZ7') //Seleciona a área da tabela customizada que controla as movimentações de estoque para o wms
		DbSetOrder(1)
		DbSeek(FwXFilial('SZ7') + __CUSERID + M->H6_LOCAL) //Busca a informação do usuário na tabela da rotina customizada

		If !(M->H6_OBSERVA $ 'TOTVSMES') .Or. !(Z7_TPMOV $ 'E|A') 	//Se NÃO vier do WebService MES ou o usuário não tenha permissão de entrada no estoque do wms. (E=Entrada, A=Ambos)
			lRet := .F.												//Não permite o apontamento e exibe o Help do bloqueio.
			Help(NIL, NIL, 'MOV_ARM', NIL, 'O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém ' + M->H6_LOCAL + '.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Contacte o administrador do sistema.'})
		ElseIf M->H6_QTDPERDA > 0 .And. lSavePerda == .F. .And. M->H6_PT == 'T'	
		//Identifica se é apontamento de perda pela quantidade apontada no campo H6_QTDPERDA. 
		//lSavePerda é variável privada da rotina de apontamento de perda que verifica se foi preenchida corretamente.
		//Verifica também que o apontamento de perda não pode ser Total, ou seja, não pode encerrar OP com Perda.
		//Caso não, bloqueia a gravação do apontamento de perda e exibe o Help do bloqueio.
			lRet := .F.
			M->H6_PT := 'P'
			Help(NIL, NIL, 'ERROR_PERD', NIL, 'Apontamento de perda preenchido incorretamente.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Verifique os dados do apontamento e lembre-se que não pode encerrar a Op com Perda.'})
		EndIf

		DbSelectArea('SB1') //Seleciona a área da SB1 para encontrar o produto do apontamento
		DbSetOrder(1)
		DbSeek(FwXFilial('SB1') + M->H6_PRODUTO) //Posiciona no produto correto
ConOut('---->>>Achou produto')
		If SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID) //Verifica se o produto controla lote e se o campo de dias para validade está preenchido
			nCount := SB1->B1_PRVALID	//Armazena a quantidade de dias na variável para cálculo da validade do mesmo
Conout('------>Armazenado a quantidade de dias para cálculo da data de validade!')
			EndIf

		DbSelectArea('SC2') //Seleciona a área da SC2
		DbSetOrder(1)
		DbSeek(FwXFilial('SC2')+ SUBSTR(M->H6_OP,1,6)) //Posiciona na Op correta, selecionando o primeiro registro do arquivo
		While !(EOF) //Enquanto não for o final do arquivo procura se já tem uma validade  preenchida em qualquer item da Op
			ProcValid :=  SC2->C2_FSDTVLD //Armazena a data de validade da Op
		End

		DbSeek(FwXFilial('SC2')+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3)) //Posiciona no item da Op do apontamento atual
		If Empty(ProcValid) //Se não encontrou nenhum apontamento anterior, ou seja, não tem validade do lote ainda.
			M->H6_DTVALID := date() + nCount //Calcula a data de validade pro lote
Conout('------>É o primeiro Apontamento')
			RecLock('SC2',.F.)
				SC2->C2_FSDTVLD := date() + nCount	//Salva a validade do lote na tabela de Ops, pois deve ser a mesma validade para todo o lote independente da datahora do apontamento
			SC2->(MsUnlock())
		Else
Conout('------>Já tem apontamento!')
			M->H6_DTVALID := ProcValid	//Se encontrou data de validade anterior para o mesmo lote, preenche com o valor correto
			RecLock('SC2',.F.)
				SC2->C2_FSDTVLD := ProcValid	//Realiza a gravação da validade no item correto.
			SC2->(MsUnlock())
		EndIf

		If M->H6_OPERAC =='' //Só tava verificando um erro que aparecia no Ws, vou deixar aqui enquanto não tiro uma conclusão final.
			Conout('------>Operação CHEGOU VAZIO AQUI')
		EndIf
	EndIf

	RestArea(aArea)

Return lRet
