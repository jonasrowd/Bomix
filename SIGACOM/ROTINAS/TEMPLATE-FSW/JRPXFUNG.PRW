#INCLUDE "TOTVS.CH"
#include 'Ap5Mail.ch'
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} TBSENDMAIL
Programa responsavel por envio de e-mail

@author francisco.ssa
@since 31/08/08
@version 1.0

@param c_To, character, Parametro com email do destinatario
@param c_Body, character, Parametro com o corpo do email
@param c_Subj, character, Parametro
@param l_ExibeTela, Logico, Exibe as telas de log (ex.: email enviado com sucesso)
@param c_Anexo, carater, Anexos

@return Logico, .T. = E-mail enviado com sucesso, .F. = Email nao enviado

@example
U_TBSENDMAIL("fulano@servidor.com","E-mail Teste","Assunto: Teste",.F.,c_Anexo)

@see (links_or_references)
/*/
User Function TBSENDMAIL(c_To,c_Body,c_Subj,l_ExibeTela,c_Anexo, c_CCO )

	Local c_Server   	:= GETMV("MV_RELSERV")	//Nome do Servidor de Envio de E-mail utilizado nos relatorios
	Local c_Account  	:= GETMV("MV_RELACNT")	//Conta a ser utilizada no envio de E-Mail para os relatorios
	Local c_Envia    	:= GETMV("MV_RELFROM")	//E-mail utilizado no campo FROM no envio de relatorios por e-mail
	Local c_Password	:= GETMV("MV_RELPSW")	//Senha da Conta de E-Mail para envio de relatorios
	Local c_Autentic	:= GETMV("MV_RELPSW")	//Senha para autenticacäo no servidor de e-mail
	Local l_Autentic	:= GETMV("MV_RELAUTH")	//Servidor de EMAIL necessita de Autenticacao?

	DEFAULT c_Subj		:= "Mensagem enviada pelo Protheus - Totvs"
	DEFAULT c_Body		:= "Mensagem enviada pelo Protheus - Totvs"
	DEFAULT l_ExibeTela := .T.	//Define se a tela de envio/erros devem ser exibidas ao final de cada processamento
	DEFAULT c_Anexo		:= ""	//Anexos
	DEFAULT c_CCO		:= ""

	IF c_To == NIL .or. Empty( c_To )
		If IsBlind()
			CONOUT("O e-mail não pôde ser enviado, pois o primeiro parâmetro (DESTINATÁRIO) não foi preenchido.")
		Else
			Aviso(SM0->M0_NOMECOM,"O e-mail não pôde ser enviado, pois o primeiro parâmetro (DESTINATÁRIO) não foi preenchido.",{"Ok"},2,"Erro de envio!")
		Endif
		Return(.F.)
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Conecta ao servidor de SMTP |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONNECT SMTP SERVER c_Server ACCOUNT c_Account PASSWORD c_Password RESULT lConectou

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso o servidor SMTP do cliente necessite de autenticacao |
	//|sera necessario habilitar o parametro MV_RELAUTH.         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF l_Autentic
		If !MailAuth( c_Account, c_Autentic )

			//Contingenciamento na autenticação
			DISCONNECT SMTP SERVER RESULT lDisConectou
			c_Account	:=	SubStr(c_Account,1,AT("@",c_Account)-1)
			CONNECT SMTP SERVER c_Server ACCOUNT c_Account PASSWORD c_Password RESULT lConectou
			If !MailAuth( c_Account, c_Autentic )
				IF l_ExibeTela .And. !(IsBlind())
					Aviso(SM0->M0_NOMECOM,"Falha na autenticação do Usuário!",{"Ok"},1,"Atenção")
				ENDIF
				CONOUT("Falha na autenticação do Usuário!")
				DISCONNECT SMTP SERVER RESULT lDisConectou
				Return(.F.)
			Endif
		Endif
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se houve conexao com o servidor SMTP |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lConectou
		IF l_ExibeTela .And. !(IsBlind())
			Aviso(SM0->M0_NOMECOM,"Erro ao conectar servidor de E-Mail (SMTP) - " + c_Server+CHR(10)+CHR(13)+;
			"Solicite ao Administrador que seja verificado os parâmretros e senhas do servidor de E-Mail (SMTP)",{"Ok"},3,"Atenção!")
		ENDIF
		CONOUT("Erro ao conectar servidor de E-Mail (SMTP) - " + c_Server+CHR(10)+CHR(13)+"Solicite ao Administrador que seja verificado os parâmretros e senhas do servidor de E-Mail (SMTP)")
		Return(.F.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o e-mail |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !Empty(c_Anexo) .and. FILE(c_Anexo)
		SEND MAIL FROM c_Envia TO Alltrim(c_To) BCC c_CCO SUBJECT c_Subj BODY c_Body ATTACHMENT c_Anexo RESULT lEnviado
	ELSE
		SEND MAIL FROM c_Envia TO Alltrim(c_To) BCC c_CCO SUBJECT c_Subj BODY c_Body RESULT lEnviado
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica possiveis erros durante o envio do e-mail |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnviado
		IF l_ExibeTela .And. !(IsBlind())
			Aviso(SM0->M0_NOMECOM,"Foi enviado e-mail para "+c_To+" com sucesso!",{"Ok"},3,"Informação!")
		ENDIF
		CONOUT("Foi enviado e-mail para "+c_To+" com sucesso!")
	Else
		c_Body := ""
		GET MAIL ERROR c_Body
		IF l_ExibeTela .And. !(IsBlind())
			Aviso(SM0->M0_NOMECOM,c_Body,{"Ok"},3,"Atenção!")
		Else
			Conout(SM0->M0_NOMECOM+": "+c_Body)
		ENDIF
		
		//CONOUT(c_Body)
		
		Return(.F.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Desconecta o servidor de SMTP |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DISCONNECT SMTP SERVER Result lDisConectou

Return(.T.)

/*/{Protheus.doc} TBCRIAPASTAS
Programa responsavel pela criacao de pastas

@author francisco.ssa
@since 20/11/2013
@version 1.0

@param c_GrvFile, character, Parametro com o caminho e suas pastas

@return Logico, Se verdadeiro pasta criada com sucesso

@example
U_TBCRIAPASTAS( "c:\totvs\temp" )

@see (links_or_references)
/*/
User Function TBCRIAPASTAS( c_GrvFile )

	Local n_PathNAt	:= At(':',c_GrvFile)
	Local c_PathFil := Left( c_GrvFile, n_PathNAt )
	Local a_TmpPath := StrToKArr( Right(c_GrvFile, Len(c_GrvFile) - n_PathNAt ) ,'\')
	Local n_Folders := Len(a_TmpPath)
	Local nY 		:= 0
	Local l_Ret		:= .T.

	For nY := 1 To n_Folders

		c_PathFil += '/' + a_TmpPath[nY]

		IF !ExistDir(c_PathFil)

			IF MakeDir(c_PathFil) <> 0
				If IsBlind()
					conout("Criacao de Diretorios:")
					conout("O caminho "+Alltrim(c_PathFil)+" não pôde ser criado.")
					conout("Contate o administrador de sistemas.")
				Else
					ShowHelpDlg("Criacao de Diretorios",;
					{"O caminho "+Alltrim(c_PathFil)+" não pôde ser criado."},5,;
					{"Contate o administrador de sistemas."},5)
				Endif
				
				l_Ret	:= .F.

			ENDIF

		ENDIF

	Next

Return(l_Ret)


/*/{Protheus.doc} TBFSMASKENT
Programa responsavel por criar as mascaras das entidades contabeis conforme configuracao

@author francisco.ssa
@since 20/11/2013
@version 1.0

@param c_Entidade, character, Parametro informando a entidade
@param c_Codigo, character, Parametro do codigo da mascara
@param c_Conta, character, Parametro com a conta que recebera a mascara

@return character, Retorna a conta na mascara informada

@example
U_TBFSMASKENT("CT2","001", "101001001")

@see (links_or_references)
/*/
User Function TBFSMASKENT(c_Entidade,c_Codigo, c_Conta)

	Local c_NewConta	:= ""
	Local nX			:= 0

	BEGINSQL ALIAS "QRY"

	SELECT *
	FROM %TABLE:CTM% CTM
	WHERE CTM_IDENT = %EXP:c_Entidade%
	AND CTM_CODIGO = %EXP:c_Codigo%
	AND CTM.%NOTDEL%
	ORDER BY CTM_SEGMEN

	ENDSQL

	DBSELECTAREA("QRY")

	nX := 1
	WHILE QRY->(!EOF()) .AND. LEN(Alltrim(c_Conta)) >= nX

		c_NewConta += Substr(c_Conta,nX,VAL(QRY->CTM_DIGITO))+"."

		nX += VAL(QRY->CTM_DIGITO)

		QRY->(DBSKIP())

	ENDDO

	c_NewConta := Substr(c_NewConta,1,len(c_NewConta)-1)
	QRY->(DBCLOSEAREA())

Return(c_NewConta)

/*/{Protheus.doc} TBCSVTOARRAY
Programa responsavel por fazer a leitura da linha e retorna vetor. Para cada elemento do vetor um campo.

@author francisco.ssa
@since 20/11/2013
@version 1.0

@param c_Linha, character, Parametro com a linha que sera convertida
@param c_Chave, character, Parametro com o token separador

@return Vetor, Vetor com os elementos da linha

@example
U_TBCSVTOARRAY("01;0002;0344",";")

@see (links_or_references)
/*/
User Function TBCSVTOARRAY(c_Linha,c_Chave)

	Local a_Array	:= {}
	Local c_Campo	:= ""
	Local nX		:= 0

	Default c_Chave	:= ";"

	For nX := 1 TO LEN(c_Linha)

		IF Substr(c_Linha,nX,1) <> c_Chave

			c_Campo += Substr(c_Linha,nX,1)

		ELSE

			AADD(a_Array,c_Campo)

			c_Campo := ""

		ENDIF

	Next

	AADD(a_Array,c_Campo)

Return(a_Array)


/*/{Protheus.doc} TBVLDSENHA
Programa responsavel por abrir uma tela solicitando usuario e senha

@author francisco.ssa
@since 20/11/2013
@version 1.0

@return Vetor, Retorna um vetor com dois elementos, sendo primeiro logico onde T a senha funcionou e F caso contrario. O segundo elemento com o ID do usuario

@example
U_TBVLDSENHA()

@see (links_or_references)
/*/
User Function TBVLDSENHA()

	Local a_Area		:= GetArea()		//Salva Area de Trabalho
	Local c_Usuario	:= Space(25)		//Nome do usuario
	Local c_Senha		:= Space(20)		//Senha digitada pelo usuario

	Private oFont1						//Fonte 1
	Private oFont2						//Fonte 2
	Private oDlg1							//Tela 1
	Private oSay1							//Texto 1
	Private oSay2                      //Texto 2
	Private oGet1							//Caixa de Texto 1
	Private oGet2							//Caixa de Texto 2
	Private oSBtn1						//Botao de Comando 1
	Private oSBtn2						//Botao de comando 2
	Private l_VldoDlg	:= .F.				//Flag de validacao da tela
	Private a_UsrPwd	:= {}				//Vetor com a validacao da senha/usuario

	oFont1     := TFont():New("Arial Narrow",0,-15,,.T.,0,,700,.F.,.F.,,,,,,)
	oFont2     := TFont():New("Arial Narrow",0,-15,,.T.,0,,700,.F.,.F.,,,,,,)

	oDlg1      := MSDialog():New(089,232,209,568,"Liberação",,,.F.,,,,,,.T.,,,.T.)

	oSay1      := TSay():New(005,002,{||"Usuário/User:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,052,012)
	oGet1      := TGet():New(005,062,{|u| If( PCount() == 0, c_Usuario,c_Usuario := u ) },oDlg1,096,012,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay2      := TSay():New(022,003,{||"Senha/Password:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,055,011)
	oGet2      := TGet():New(022,062,{|u| If( PCount() == 0, c_Senha,c_Senha := u ) },oDlg1,096,012,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","",,)

	oSBtn1     := SButton():New(039,131,1,{|| f_ValidaUsr( c_Usuario, c_Senha ),oDlg1:End()},oDlg1,,"",)
	oSBtn2     := SButton():New(039,103,2,{|| l_VldoDlg:=.T.,AADD(a_UsrPwd,{.F.,""}),oDlg1:End()},oDlg1,,"",)

	oDlg1:Activate(,,,.T.,{||,l_VldoDlg})

	RestArea(a_Area)

Return(a_UsrPwd)

/*/{Protheus.doc} f_ValidaUsr
Funcao responsavel por Validar as informacoes digitadas na tela de login customizada

@author francisco.ssa
@since 20/11/2013
@version 1.0

@param c_Usuario, character, Parametro com o usuario
@param c_Senha, character, Parametro com a senha

@return Nil

@example
f_ValidaUsr( "fulano", "123456" )

@see (links_or_references)
/*/
Static Function f_ValidaUsr( c_Usuario, c_Senha )

	Local c_UserId	:= ""
	Local a_Area2		:= GetArea()

	PswOrder(2)
	IF PswSeek(Alltrim(c_Usuario),.T.)
		IF PswName(c_Senha)
			l_VldoDlg	:= .T.
			c_UserId	:= PswID()

			AADD(a_UsrPwd,{.T.,c_UserId})

			RestArea(a_Area2)
			Return(.T.)
		ELSE
			Aviso(SM0->M0_NOMECOM,"Usuário/Senha não cadastrados.",{"Voltar"},1,"Atenção")
			l_VldoDlg	:= .F.
			c_UserId	:= PswID()

			AADD(a_UsrPwd,{.F.,c_UserId})

			RestArea(a_Area2)
			Return(.F.)
		ENDIF
	ELSE
		Aviso(SM0->M0_NOMECOM,"Usuário/Senha não cadastrados.",{"Voltar"},1,"Atenção")
		l_VldoDlg	:= .F.
		c_UserId	:= PswID()

		AADD(a_UsrPwd,{.F.,c_UserId})

		RestArea(a_Area2)
		Return(.F.)
	ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ConvUm   ³ Autor ³Marcelo Pimentel       ³  Data³06.01.98  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Converte a Unidade de Medida.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := ConvUm(ExpC1,ExpN1,ExpN2,ExpC2)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Produto                                  ³±±
±±³          ³ ExpN1 = Quantidade 1a Unidade Medida                       ³±±
±±³          ³ ExpN2 = Quantidade 2a Unidade Medida                       ³±±
±±³          ³ ExpC2 = Unidade de Medida(1|2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Todos os Parametros Devem Ser Passados !!!                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TBCONVUM( cCod,nQtd1,nQtd2,nUnid )

	Static nToler1UM
	Static nToler2UM
	Static lPConvUm

	Local nBack := 0
	Local aArea := NIL
	Local aArea1:= {}
	Local nValPe:=0

	nToler1UM := QtdComp(If(ValType(nToler1UM) == "N",nToler1UM,GetMV("MV_NTOL1UM")))
	nToler2UM := QtdComp(If(ValType(nToler2UM) == "N",nToler2UM,GetMV("MV_NTOL2UM")))
	lPConvUm  := If(Valtype(lPConvUm) # "L",ExistBlock("CONVUM"),lPConvUM)

	If ((ValType(nQtd1) == "N") .And. ;
	(ValType(nQtd2) == "N") .And. ;
	(ValType(nUnid) == "N"))

		aArea := { Alias(),IndexOrd(),Recno() }
		nBack := If( (nUnid == 1),nQtd1,nQtd2 )

		DbSelectArea("SB1")
		aArea1 := GetArea()
		DbSetOrder(1)

		If ((xFilial("SB1")+cCod == B1_FILIAL+B1_COD) .Or. ;
		DbSeek(xFilial("SB1")+cCod,.F.))
			If (B1_CONV != 0)
				If ( SB1->B1_TIPCONV != "D" )
					If ( nUnid == 1 )
						nBack := (nQtd2 / B1_CONV)
						If nToler1UM > QtdComp(0) .And. ABS(QtdComp(nBack-nQtd1)) <= nToler1UM
							nBack:=nQtd1
						EndIf
					Else
						nBack := (nQtd1 * B1_CONV)
						If nToler2UM > QtdComp(0) .And. ABS(QtdComp(nBack-nQtd2)) <= nToler2UM
							nBack:=nQtd2
						EndIf
					EndIf
				Else
					If ( nUnid == 1 )
						nBack := (nQtd2 * B1_CONV)
						If nToler1UM > QtdComp(0) .And. ABS(QtdComp(nBack-nQtd1)) <= nToler1UM
							nBack:=nQtd1
						EndIf
					Else
						nBack := (nQtd1 / B1_CONV)
						If nToler2UM > QtdComp(0) .And. ABS(QtdComp(nBack-nQtd2)) <= nToler2UM
							nBack:=nQtd2
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		// Ponto de Entrada para calcular qtd nas unidades de medida
		If lPConvUm
			nValPe:=ExecBlock("CONVUM",.F.,.F.,{nQtd1,nQtd2,nUnid,nBack})
			If ValType(nValPe) == "N"
				nBack:=nValPe
			EndIf
		EndIf
		RestArea(aArea1)
		DbSelectArea( aArea[1] )
		DbSetOrder(   aArea[2] )
		If (RecNo() != aArea[3])
			DbGoto( aArea[3] )
		EndIf
	EndIf
Return( nBack )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TBRETMES  ºAutor  ³Francisco Rezende   º Data ³ outubro/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao generica.                                            º±±
±±º          ³Retorna o mes por extenso                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ParamIxb[1] Numero do mes                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno(C)³ Mes por extenso                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A T U A L I Z A C O E S                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ºANALISTA           ºALTERACOES                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TBRETMES(n_Mes)

	Local a_MesExt	:= {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
	Local c_MesExt	:= a_MesExt[n_Mes]

Return(c_MesExt)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TBCHKFIL  ºAutor  ³Christian Tanaka    º Data ³setembro/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao generica para INNER JOIN dos campos _FILIAL          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ c_Alias1		Primeiro Alias                                º±±
±±º          ³ c_Alias2		Segundo Alias                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ INNER JOIN                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    A T U A L I Z A C O E S                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      |PROGRAMADOR       |ALTERACOES                               º±±
±±º          |                  |                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TBCHKFIL(c_Alias1,c_Alias2)

	Local c_Campo1	:= ""
	Local c_Campo2 := ""
	Local c_CmdSql := ""

	If SubStr(c_Alias1, 1, 1) == "S"
		c_Campo1 := SubStr(c_Alias1, 2, 2) + "_FILIAL"
	Else
		c_Campo1 := c_Alias1 + "_FILIAL"
	Endif

	If SubStr(c_Alias2, 1, 1) == "S"
		c_Campo2 := SubStr(c_Alias2, 2, 2) + "_FILIAL"
	Else
		c_Campo2 := c_Alias2 + "_FILIAL"
	Endif

	If Len(AllTrim(xFilial(c_Alias1))) == Len(AllTrim(xFilial(c_Alias2)))
		c_CmdSql := "(" + c_Campo1 + " = " + c_Campo2 + ") "
	Else
		If Len(AllTrim(xFilial(c_Alias1))) > Len(AllTrim(xFilial(c_Alias2)))
			If Empty(AllTrim(xFilial(c_Alias2)))
				c_CmdSql := "(" + c_Campo2 + " = '" + xFilial(c_Alias2) + "') "
			Else
				c_CmdSql := "(SUBSTRING(" + c_Campo1 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias2)))) + ") = " + "SUBSTRING(" + c_Campo2 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias2)))) + ")) "
			Endif
		Else
			If Empty(AllTrim(xFilial(c_Alias1)))
				c_CmdSql := "(" + c_Campo1 + " = '" + xFilial(c_Alias1) + "') "
			Else
				c_CmdSql := "(SUBSTRING(" + c_Campo2 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias1)))) + ") = " + "SUBSTRING(" + c_Campo1 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias1)))) + ")) "
			Endif
		Endif
	Endif

Return(c_CmdSql)

User Function TBLINTOVETOR( c_Linha, n_String )

	Local a_Strings	:= {}
	Local c_Strings	:= ""
	Local n_TamStr	:= 0
	Local n_TLin    := LEN(c_Linha)
	Local nH        := 0

	//c_Linha => 016029112

	FOR nH:=1 TO n_TLin

		IF n_TamStr < n_String

			c_Strings += Substr(c_Linha,nH,1)
			n_TamStr++

		ELSE

			IF !EMPTY(c_Strings)
				AADD(a_Strings,c_Strings)
			ENDIF

			c_Strings	:= ""
			c_Strings 	+= Substr(c_Linha,nH,1)
			n_TamStr	:= 1

		ENDIF

	NEXT

Return(a_Strings)

User Function TB2SENDMAIL( c_To, c_Body, c_Subj, c_Arquivo )

	Local o_Server		:= Nil
	Local o_Message 	:= Nil
	Local n_Err     	:= 0
	Local c_PopAddr  	:= GETMV("MV_WFPOP3")	//"pop.totvs.com"      // Endereco do servidor POP3
	Local c_SMTPAddr 	:= GETMV("MV_RELSERV")	//"smtp.gmail.com" //GETMV("MV_RELSERV")     // Endereco do servidor SMTP
	Local c_POPPort  	:= 110                    // Porta do servidor POP
	Local c_SMTPPort 	:= 465	//587                   // Porta do servidor SMTP
	Local c_User     	:= GETMV("MV_RELACNT")	// Usuario que ira realizar a autenticacao
	Local c_Pass     	:= GETMV("MV_RELPSW")             // Senha do usuario
	Local n_SMTPTime 	:= 60                     // Timeout SMTP

	// Instancia um novo TMailManager
	o_Server := tMailManager():New()

	// Usa SSL na conexao
	o_Server:setUseSSL(.T.)

	// Inicializa
	o_Server:Init(c_PopAddr, c_SMTPAddr, c_User, c_Pass, c_POPPort, c_SMTPPort)

	// Define o Timeout SMTP
	if o_Server:SetSMTPTimeout(n_SMTPTime) != 0
		Alert("[ERROR]Falha ao definir timeout")
		Return .F.
	endif

	// Conecta ao servidor
	n_Err := o_Server:smtpConnect()
	if n_Err <> 0
		Alert("[ERROR]Falha ao conectar: " + o_Server:getErrorString(n_Err))
		o_Server:smtpDisconnect()
		Return .F.
	endif

	// Realiza autenticacao no servidor
	n_Err := o_Server:smtpAuth(c_User, c_Pass)
	if n_Err <> 0
		Alert("[ERROR]Falha ao autenticar: " + o_Server:getErrorString(n_Err))
		o_Server:smtpDisconnect()
		Return .F.
	endif

	// Cria uma nova mensagem (TMailMessage)
	//c_To, c_Body, c_Subj, c_Arquivo
	o_Message := tMailMessage():new()
	o_Message:Clear()
	o_Message:cFrom    	:= "francisco.ssa@totvs.com.br"
	o_Message:cTo     	:= "francisco.ssa@totvs.com.br"
	o_Message:cCC      	:= ""
	o_Message:cBCC    	:= ""
	o_Message:cSubject	:= "Teste de Classe tMailMessage"
	o_Message:cBody    	:= "Corpo do e-mail"

	//Adiciona um attach anexa arquivo
	n_Err := o_Message:AttachFile( c_Arquivo )
	If n_Err < 0
		Alert("[ERROR]Falha ao Anexar: " + o_Server:getErrorString(n_Err))
		Return .F.
	Endif

	// Envia a mensagem
	n_Err := o_Message:Send(o_Server)
	if n_Err <> 0
		Alert("[ERROR]Falha ao enviar: " + o_Server:getErrorString(n_Err))
		o_Server:smtpDisconnect()
		Return .F.
	endif// Disconecta do Servidor
	o_Server:smtpDisconnect()

Return .T.

/*/{Protheus.doc} TBCARRCLASS
Programa responsavel por carregar uma classe na pergunta do SX1

@author eliene.ssa
@since 02/06/2017
@version 1.0

@param c_perg, character, Nome da pergunta
@param c_NumPerg, character, Número da pergunta
@param c_Tabela, character, Alias da tabela a ser pesquisada

@example
U_TBCARRCLASS( 'FFINR007','04','CTT' ) // Colocar no valid da pergunta

@see (links_or_references)
/*/
User Function TBCARRCLASS( c_perg,c_NumPerg,c_Tabela )

	Local o_Select	:= clsMultSelect():New()

	o_Select:mtdSelect(c_perg,c_NumPerg,c_Tabela)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³FSCHKFIL  º Autor ³ AP6 IDE            º Data ³  13/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para verificar se as tabelas que   º±±
±±º          ³ serão relacionadas são exclusivas ou compartilhadas e      º±±
±±º          ³ gerar a parte da query relacionando a filial das tabelas.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Caractere		                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºExemplos   ³ (E1_FILIAL = E5_FILIAL)                                   º±±
±±º			  ³ (CTT_FILIAL = '')		                                  º±±
±±º           ³ (SUBSTRING(E1_FILIAL,1,2) = SUBSTRING(E5_FILIAL,1,2))     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FSCHKFIL(c_Alias1, c_Alias2)
	Local c_Campo1 := ""
	Local c_Campo2 := ""
	Local c_CmdSql := ""

	If SubStr(c_Alias1, 1, 1) == "S"
		c_Campo1 := SubStr(c_Alias1, 2, 2) + "_FILIAL"
	Else
		c_Campo1 := c_Alias1 + "_FILIAL"
	Endif

	If SubStr(c_Alias2, 1, 1) == "S"
		c_Campo2 := SubStr(c_Alias2, 2, 2) + "_FILIAL"
	Else
		c_Campo2 := c_Alias2 + "_FILIAL"
	Endif

	If Len(AllTrim(xFilial(c_Alias1))) == Len(AllTrim(xFilial(c_Alias2)))
		c_CmdSql := "(" + c_Campo1 + " = " + c_Campo2 + ") "
	Else
		If Len(AllTrim(xFilial(c_Alias1))) > Len(AllTrim(xFilial(c_Alias2)))
			If Empty(AllTrim(xFilial(c_Alias2)))
				c_CmdSql := "(" + c_Campo2 + " = '" + xFilial(c_Alias2) + "') "
			Else
				c_CmdSql := "(SUBSTRING(" + c_Campo1 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias2)))) + ") = " + "SUBSTRING(" + c_Campo2 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias2)))) + ")) "
			Endif
		Else
			If Empty(AllTrim(xFilial(c_Alias1)))
				c_CmdSql := "(" + c_Campo1 + " = '" + xFilial(c_Alias1) + "') "
			Else
				c_CmdSql := "(SUBSTRING(" + c_Campo2 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias1)))) + ") = " + "SUBSTRING(" + c_Campo1 + ", 1, " + cValToChar(Len(AllTrim(xFilial(c_Alias1)))) + ")) "
			Endif
		Endif
	Endif

Return c_CmdSql