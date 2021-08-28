#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados do apontamento de Produ��o no MATA681 (Produ��o PCP Mod2)
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return variant, Logical
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6089410
/*/
User Function MT680VAL()
	Local aArea	:= GetArea() //Armazena a �rea do ponto de entrada
	Local lRet	:= .T. //Vari�vel para controle da grava��o da rotina

	If lRet .And. l681 //Vari�vel Private para verificar qual o programa est� chamando o ponto de entrada
		DbSelectArea('SZ7') //Seleciona a �rea da tabela customizada que controla as movimenta��es de estoque para o wms
		DbSetOrder(1)
		DbSeek(FwXFilial('SZ7') + __CUSERID + M->H6_LOCAL) //Busca a informa��o do usu�rio na tabela da rotina customizada

		If !(M->H6_OBSERVA $ 'TOTVSMES') .Or. !(Z7_TPMOV $ 'E|A') 	//Se N�O vier do WebService MES ou o usu�rio n�o tenha permiss�o de entrada no estoque do wms. (E=Entrada, A=Ambos)
			lRet := .F.												//N�o permite o apontamento e exibe o Help do bloqueio.
			Help(NIL, NIL, 'MOV_ARM', NIL, 'O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m ' + M->H6_LOCAL + '.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Contacte o administrador do sistema.'})
		ElseIf M->H6_QTDPERDA > 0 .And. lSavePerda == .F. .And. M->H6_PT == 'T'	
		//Identifica se � apontamento de perda pela quantidade apontada no campo H6_QTDPERDA. 
		//lSavePerda � vari�vel privada da rotina de apontamento de perda que verifica se foi preenchida corretamente.
		//Verifica tamb�m que o apontamento de perda n�o pode ser Total, ou seja, n�o pode encerrar OP com Perda.
		//Caso n�o, bloqueia a grava��o do apontamento de perda e exibe o Help do bloqueio.
			lRet := .F.
			M->H6_PT := 'P'
			Help(NIL, NIL, 'ERROR_PERD', NIL, 'Apontamento de perda preenchido incorretamente.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Verifique os dados do apontamento e lembre-se que n�o pode encerrar a Op com Perda.'})
		EndIf

		DbSelectArea('SB1') //Seleciona a �rea da SB1 para encontrar o produto do apontamento
		DbSetOrder(1)
		DbSeek(FwXFilial('SB1') + M->H6_PRODUTO) //Posiciona no produto correto
ConOut('---->>>Achou produto')
		If SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID) //Verifica se o produto controla lote e se o campo de dias para validade est� preenchido
			nCount := SB1->B1_PRVALID	//Armazena a quantidade de dias na vari�vel para c�lculo da validade do mesmo
Conout('------>Armazenado a quantidade de dias para c�lculo da data de validade!')
			EndIf

		DbSelectArea('SC2') //Seleciona a �rea da SC2
		DbSetOrder(1)
		DbSeek(FwXFilial('SC2')+ SUBSTR(M->H6_OP,1,6)) //Posiciona na Op correta, selecionando o primeiro registro do arquivo
		While !(EOF) //Enquanto n�o for o final do arquivo procura se j� tem uma validade  preenchida em qualquer item da Op
			ProcValid :=  SC2->C2_FSDTVLD //Armazena a data de validade da Op
		End

		DbSeek(FwXFilial('SC2')+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3)) //Posiciona no item da Op do apontamento atual
		If Empty(ProcValid) //Se n�o encontrou nenhum apontamento anterior, ou seja, n�o tem validade do lote ainda.
			M->H6_DTVALID := date() + nCount //Calcula a data de validade pro lote
Conout('------>� o primeiro Apontamento')
			RecLock('SC2',.F.)
				SC2->C2_FSDTVLD := date() + nCount	//Salva a validade do lote na tabela de Ops, pois deve ser a mesma validade para todo o lote independente da datahora do apontamento
			SC2->(MsUnlock())
		Else
Conout('------>J� tem apontamento!')
			M->H6_DTVALID := ProcValid	//Se encontrou data de validade anterior para o mesmo lote, preenche com o valor correto
			RecLock('SC2',.F.)
				SC2->C2_FSDTVLD := ProcValid	//Realiza a grava��o da validade no item correto.
			SC2->(MsUnlock())
		EndIf

		If M->H6_OPERAC =='' //S� tava verificando um erro que aparecia no Ws, vou deixar aqui enquanto n�o tiro uma conclus�o final.
			Conout('------>Opera��o CHEGOU VAZIO AQUI')
		EndIf
	EndIf

	RestArea(aArea)

Return lRet
