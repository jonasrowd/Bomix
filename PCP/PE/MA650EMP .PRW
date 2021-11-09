#Include 'Totvs.ch'
#Include 'Ap5mail.ch'

/*/{Protheus.doc} MA650EMP
	Ponto de entrada desenvolvido para preencher campos personalizados na SD4
	e excluir as Op's e Empenhos que não querem que gere.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 05/10/2021
/*/
User Function MA650EMP()

    Local i,j,k			:= 0
    Local nOpc 			:= 5 //3 - Inclusao, 4 - Alteracao, 5 - Exclusao
    Local cOp			:= SD4->D4_OP //SD4 está posicionada na ultima op gerada
	Local cProd			:= SD4->D4_PRODUTO
	Local aMATA650		:= {} //-Array com os campos
    Local DDATABASE		:= DATE()
    Local nResori := 0   //Quantidade origem da Resina
    Local nMasori := 0   //Quantidade origem da Master
    Local nTotal  := 0   //Total Master+Resina
    Local nPerc   := 0   //Percentual de Master e Resina
	Private l_Email		:= .T.
    Private lMsErroAuto := .F.
	Private c_Email		:= 'ti@bomix.com.br'
	Private c_Titulo	:= "OP: " + SD4->D4_OP + " Notificação de erro na exclusão automática do MATA650."
	Private c_Corpo		:= c_Titulo + CRLF + "Acionamento Key User para verificar com o usuário " + UsrRetName(__CUSERID) +" o ocorrido."

    For i:=1 To Len(aCols)
        // Fecha a tabela de pedidos em aberto caso o alias esteja em uso
		If (Select("PEGALA") > 0)
			DBSelectArea("PEGALA")
			DBCloseArea()
		EndIf

        BEGINSQL ALIAS "PEGALA"
            SELECT 
                B1.B1_DESC AS BRITO, 
                B1.B1_BRTPPR AS BRITO1,
				G1.G1_QUANT AS BRITO2
            FROM  %TABLE:SD4% D4 (NOLOCK)
                INNER JOIN %TABLE:SB1% B1 (NOLOCK)
                ON B1.B1_FILIAL = %XFILIAL:SB1%
                AND B1.%NOTDEL%
                AND B1.B1_COD = %EXP:aCols[i][1]%
				LEFT JOIN %TABLE:SG1% G1 (NOLOCK)
				ON G1.G1_FILIAL=%XFILIAL:SG1% AND
				D4.%NOTDEL% AND G1.G1_COMP=%EXP:aCols[i][1]%
				AND G1.G1_COD=D4.D4_PRODUTO
            WHERE D4.D4_FILIAL = %XFILIAL:SD4%
                AND D4.%NOTDEL%
                AND D4.D4_QUANT <> 0
                AND D4.D4_OP = %EXP:cOp%
                AND D4.D4_COD = %EXP:aCols[i][1]%
        ENDSQL

        DbSelectArea("SD4")
        DbSetOrder(1)
        If dbSeek(FwXFilial("SD4")+aCols[i][1]+cOp)
            RecLock("SD4", .F.)
                SD4->D4_FSDSC := PEGALA->BRITO
                SD4->D4_FSTP  := PEGALA->BRITO1
				SD4->D4_FSQTDES := PEGALA->BRITO2
            MsUnlock()
        EndIf

		DBSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(FWXFILIAL("SB1")+cProd)
		If Found()
			cPeso := SB1->B1_FSPESOP
			cQb	  := SB1->B1_QB
		EndIf

        DbSelectArea("SD4")
        DbSetOrder(1)
        If dbSeek(FwXFilial("SD4")+aCols[i][1]+cOp)
            RecLock("SD4", .F.)
                SD4->D4_FSPESO  := cPeso
				SD4->D4_FSQTDBS := cQb
            MsUnlock()
        EndIf
    Next

    IF (INCLUI)//Se for alteração ou inclusão, realiza o cálculo
        For j:=1 to Len(Acols)
            If "RESINA" $ AllTrim(Acols[j][14])
                nResori := nResori + Acols[j][2] //Soma se tiver mais de uma resina no Acols
            EndIf
            If "MASTER" $ Alltrim(Acols[j][14])
                nMasori := nMasori + Acols[j][2] //Soma caso algum dia tenha mais de uma master
            EndIf
        Next j

        nTotal := nResori + nMasori

        For k:=1 to Len(Acols)
            If ("MASTER" $ Alltrim(Acols[k][14]) .Or. "RESINA" $ Alltrim(Acols[k][14]))
                nPerc := ((Acols[k][2]) / nTotal) * 100 //Calcula o percentual de cada Master / resina
                DbSelectArea("SD4")
                DbSetOrder(1)
                DbSeek(FwXFilial("SD4") + Acols[k][1] + cOp)
                RecLock("SD4", .F.)
                    SD4->D4_FSPM_R := Round(nPerc,2) //Grava no campo específico a proporção de cada item
                MsUnlock()
            EndIf
        Next k
    ENDIF

	// Gera um novo alias para a tabela temporária
	c_AliasAux := GetNextAlias()

	// Pesquisa pelos produtos que não devem
	// gerar Ordem de Produção
	BEGINSQL ALIAS c_AliasAux
		SELECT
			C2.C2_FILIAL   CFILAUX  ,
			C2.C2_NUM      CNUMAUX  ,
			C2.C2_ITEM     CITEMAUX ,
			C2.C2_SEQUEN   CSEQAUX  ,
			C2.C2_PRODUTO  CPRODAUX ,
			B1.B1_BRTPPR   CBRITOAUX,
			C2.C2_LOCAL	   CLOCALAUX,
			C2.C2_QUANT	   CQUANTAUX,
			Z05.Z05_GERAOP CCARROAUX
		FROM
			%TABLE:SC2% C2 (NOLOCK)
			INNER JOIN
				%TABLE:SB1% B1
				ON B1.B1_FILIAL = %XFILIAL:SB1%
				AND B1.B1_COD   = C2.C2_PRODUTO
				AND B1.%NOTDEL%
			INNER JOIN 
				%TABLE:Z05% Z05 (NOLOCK)
				ON Z05.Z05_FILIAL = %XFILIAL:Z05%
				AND Z05.Z05_NOME  = B1.B1_BRTPPR
				AND Z05.%NOTDEL%
		WHERE
			C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = %EXP:AllTrim(cOp)%
			AND Z05.Z05_GERAOP = 'N'
			AND C2.%NOTDEL%
			AND C2.C2_FILIAL= %XFILIAL:SC2%
	ENDSQL

	//Execauto para excluir as op's e empenhos 
	While (!EOF())
			aMATA650 := {;
                {'C2_FILIAL'    , CFILAUX   ,NIL},;
                {'C2_NUM'       , CNUMAUX   ,NIL},; 
                {'C2_ITEM'      , CITEMAUX  ,NIL},; 
                {'C2_SEQUEN'    , CSEQAUX   ,NIL},;
                {'C2_PRODUTO'   , CPRODAUX  ,NIL},;
                {'C2_LOCAL'     , CLOCALAUX ,NIL},;
                {'C2_QUANT'     , CQUANTAUX ,NIL},;
                {'C2_DATPRI'    , DDATABASE ,NIL},;
                {'C2_DATPRF'    , DDATABASE ,NIL},;
                {'AUTEXPLODE'   , "S"       ,NIL};
                }

    // Se alteracao ou exclusao, deve-se posicionar no registro da SC2 antes de executar a rotina automática
    If nOpc == 4 .Or. nOpc == 5
        SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
        SC2->(DbSeek(xFilial("SC2")+aMATA650[2][2]+aMATA650[3][2]+aMATA650[4][2]))
    EndIf

    msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)

	//Se Erro, apresenta mensagem para que o usuário possa nos informar
    If lMsErroAuto
		//jEnvMail()
		Help(NIL, NIL, 'ERR_OP', NIL, 'Erro no ajuste de Empenho e Op.',;
			1, 0, NIL, NIL, NIL, NIL, NIL, {'Encaminhe esta Op ao time de TI para acompanhar o processo.'})
        MostraErro()
    EndIf

	DBSkip()
	End

Return (Nil)

/*/{Protheus.doc} jEnvMail
	Envia email se erro
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 08/10/2021
	@return logical, .T.
/*/
Static Function jEnvMail()
	Local _cServer   	:= Alltrim(GETMV("MV_RELSERV"))	//Servidor smtp
	Local _cAccount  	:= Alltrim(GETMV("BM_BOLMAIL"))	//Conta de e-mail
	Local _cPassword	:= Alltrim(GETMV("BM_BOLSNH"))	//Senha da conta de e-mail
	Local _cEnvia    	:= Alltrim(GETMV("BM_BOLMAIL"))	//Endereco de e-mail
	Local _cTo			:= "jonas.machado@bomix.com.br"// _Par1+";"+ALLTRIM(UsrRetMail(__cUserID))			//Destinatario
	Local _cMsg			:= "Erro na geração das op x pedidos de venda."			//Corpo da Mensagem
	Local _cSubj		:= OemToAnsi('BOMIX - Geração de Op ') //Assunto

	//Conecta ao servidor de SMTP
	CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword Result lConectou
	//Caso o servidor SMTP do cliente necessite de autenticacao
	//sera necessario habilitar o parametro MV_RELAUTH.
	If GETMV("MV_RELAUTH")
		If !MailAuth( _cAccount, _cPassword )
			DISCONNECT SMTP SERVER RESULT lDisConectou
			Return (.F.)
		EndIf
	EndIf
	//Verifica se houve conexao com o servidor SMTP
	If !lConectou
		Return (.F.)
	EndIf
	//Envia o e-mail
	SEND MAIL FROM _cEnvia TO Alltrim(_cTo) SUBJECT _cSubj BODY _cMsg RESULT lEnviado
	//Verifica possiveis erros durante o envio do e-mail
	If lEnviado
		Return (.T.)
	Else
		_cMsg := ""
		GET MAIL ERROR _cMsg
		Return (.F.)
	EndIf
	//Desconecta o servidor de SMTP
	DISCONNECT SMTP SERVER Result lDisConectou
Return (.T.)
