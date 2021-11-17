#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

WSSERVICE WS_FSFLUIG Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;•<span style='color:red;'> WS para <b>INTEGRACAO COM FLUIG</b>.</span>"

	//------------------------------------------------
	//Estrutura declarada no WS Fabrica (WSFABRICA.PRW)
	//------------------------------------------------
	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca
	//-------------------------------------

	WSDATA o_Produto	AS strProduto				//Estrutura de Produtos
	WSDATA o_SC			AS strSC					//Estrutura de Solicitacao de Compras
	WSDATA o_DadosTit	AS strDadosTitulos			//Estrutura de Dados dos Titulos
	WSDATA o_LibPedido	AS strLibPedido				//Estrutura de Liberacao de Pedidos
	WSDATA o_Fornecedor	AS strFornecedor			//Estrutura do cadastro de Fornecedor
	WSDATA o_Cotacao	AS strCotacao				//Estrutura do cadastro de Cotacao
	WSDATA o_SA			AS strSA					//Estrutura de Solicitacao de Armazem
	WSDATA c_nmUsuario  AS STRING
	WSDATA c_numCot	 	AS STRING
	WSDATA c_Fornece  	AS STRING
	WSDATA c_Loja		AS STRING

	WSDATA o_RetGeral	AS ARRAY OF strRetGeral

	WSMETHOD mtdGrvProduto		//METODO DE GRAVACAO DO PRODUTO/SERVICO
	WSMETHOD mtdGrvSC			//METODO DE GRAVACAO DA SOLICITACAO DE COMPRAS
	WSMETHOD mtdGrvFinanceiro	//METODO DE GRAVACAO DA LIBERACAO DO TITULO A PAGAR
	WSMETHOD mtdLibPedido		//METODO DE LIBERACAO DE PEDIDO DE COMPRAS
	WSMETHOD mtdGrvFornecedor	//METODO DE GRAVACAO DO FORNECEDOR

	WSMETHOD mtdRetTipo			//METODO DE CONSULTA DO TIPO DE PRODUTO
	WSMETHOD mtdRetProduto		//METODO DE CONSULTA DO PRODUTO
	WSMETHOD mtdRetUM			//METODO DE CONSULTA DA UNIDADE DE MEDIDA DO PRODUTO
	WSMETHOD mtdRetGrupo		//METODO DE CONSULTA DO GRUPO DE PRODUTO
	WSMETHOD mtdAtualizaCot		//METODO DE ATUALIZAÇÃO DA COTAÇÃO
	WSMETHOD mtdGrvSA			//METODO DE GRAVACAO DA SOLICITACAO DE ARMAZEM
	WSMETHOD mtdRetUsuario		//METODO DE RETORNO DE USUARIO
	WSMETHOD mtdEnvCot			//METODO DE RETORNO DE USUARIO

ENDWSSERVICE

WSSTRUCT strItens

	WsData iNumItem 	As String // Número do Item da Cotação
	WsData iNumProd 	As String // Número do Produto
	WsData fVlUnit 		AS FLOAT // Valor unitário
	WsData fVlTotal 	AS FLOAT // Valor Total
	WsData fIPI 		AS FLOAT // Aliquota de IPI
	WsData iPz	 		AS INTEGER // Prazo

ENDWSSTRUCT

WSSTRUCT strCotacao

	WsData iNumCotacao 	AS String // Número da Cotação
	WsData iNumFornece 	As String // Número do Fornecedor
	WsData iLojaFornece As String // Loja do Fornecedor
	WsData iNumPro 		AS String // Número da Proposta
	WsData iTpFrete 	AS String // Número da Proposta
	WsData fFrete 		AS FLOAT // Valor do Frete
	WsData fDesc 		AS FLOAT // Valor do Desconto
	WsData cCondPgto 	AS String // Condição de Pagamento
	wsData lItens		As Array of strItens

ENDWSSTRUCT

WSSTRUCT strFornecedor

	WSDATA c_Nome		AS STRING
	WSDATA c_Endereco	AS STRING
	WSDATA c_Bairro		AS STRING
	WSDATA c_Cidade		AS STRING
	WSDATA c_Estado		AS STRING
	WSDATA c_Email		AS STRING
	WSDATA c_CNPJ		AS STRING
	WSDATA c_IE			AS STRING
	WSDATA c_Contato	AS STRING
	WSDATA c_Tel		AS STRING
	WSDATA c_Iso		AS STRING
	WSDATA c_Pbqp		AS STRING
	WSDATA c_Cep		AS STRING
	WSDATA c_Ddd		AS STRING
	WSDATA n_NumFluig	AS INTEGER
	WSDATA c_Rdb		AS STRING

ENDWSSTRUCT

WSSTRUCT strLibPedido

	WSDATA c_Docto		AS STRING
	WSDATA n_Valor		AS FLOAT
	WSDATA c_Aprov		AS STRING
	WSDATA c_User		AS STRING
	WSDATA c_Grupo		AS STRING
	WSDATA l_TipoAcao	AS BOOLEAN
	WSDATA c_Tipo		AS STRING
	WSDATA c_Rejeit		AS STRING

ENDWSSTRUCT

WSSTRUCT strDadosTitulos

	WSDATA c_Fornece	AS STRING
	WSDATA c_Loja		AS STRING
	WSDATA c_Serie		AS STRING
	WSDATA c_Doc		AS STRING

ENDWSSTRUCT

WSSTRUCT strRetGeral

	WSDATA c_Codigo		AS STRING
	WSDATA c_Descricao	AS STRING
	WSDATA c_Tipo		AS STRING
	WSDATA c_Grupo		AS STRING
	WSDATA l_Tipo		AS BOOLEAN

ENDWSSTRUCT

WSSTRUCT strProduto

	WSDATA c_Codigo		AS STRING
	WSDATA c_Descricao	AS STRING
	WSDATA c_Tipo		AS STRING
	WSDATA c_UM			AS STRING
	WSDATA c_LocPad		AS STRING
	WSDATA c_Grupo		AS STRING
	WSDATA c_Conta		AS STRING
	WSDATA c_Emin 		AS STRING
	WSDATA c_SubFam 	AS STRING
	WSDATA n_NumFluig	AS INTEGER

ENDWSSTRUCT

WSSTRUCT strSC

	WSDATA C1_SOLICIT 	AS STRING
	WSDATA C1_FSUSRF 	AS STRING
	WSDATA C1_ITENS 	AS ARRAY OF strItSC
	WSDATA n_NumFluig	AS INTEGER

ENDWSSTRUCT

WSSTRUCT strItSC

	WSDATA C1_PRODUTO 	AS STRING
	WSDATA C1_DESCRI	AS STRING
	WSDATA C1_QUANT		AS FLOAT
	WSDATA C1_CC		AS STRING
	WSDATA C1_UM		AS STRING
	WSDATA C1_LOCAL		AS STRING
	WSDATA C1_CONTA		AS STRING
	WSDATA c_Obs		AS STRING
	WSDATA c_End		AS STRING
	WSDATA c_Just		AS STRING
	WSDATA c_Marca		AS STRING
	WSDATA c_Emerg		AS STRING
	WSDATA c_JEmerg		AS STRING
	WSDATA c_DTNEC		AS STRING

ENDWSSTRUCT


WSSTRUCT strSA

	WSDATA CP_NUM 		AS STRING
	WSDATA CP_FSUSRF 	AS STRING
	WSDATA CP_ITENS 	AS ARRAY OF strItSA
	WSDATA n_NumFluig	AS INTEGER

ENDWSSTRUCT

WSSTRUCT strItSA

	WSDATA CP_PRODUTO 	AS STRING
	WSDATA CP_QUANT		AS FLOAT
	WSDATA CP_CC		AS STRING
	WSDATA CP_LOCAL		AS STRING
	WSDATA c_Obs		AS STRING
	WSDATA c_Just		AS STRING
	WSDATA c_Emerg		AS STRING
	WSDATA c_JEmerg		AS STRING

ENDWSSTRUCT


WSMETHOD mtdGrvFornecedor WSRECEIVE o_Empresa, o_Seguranca, o_Fornecedor WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local n_Oper	:= 0
	Local c_UserWS	:= ""
	Local c_PswWS	:= ""
	Local a_Vetor 	:= {}

	Private lMsHelpAuto	:= .F. //se .t. direciona as mensagens de help
	Private lMsErroAuto	:= .F. //necessario a criacao
	Private INCLUI := .T.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	If Findfunction("U_FCOMA004")

		c_Codigo	:= U_FCOMA006() //GETSXENUM("SA2","A2_COD")
	
		aadd(a_Vetor,{"A2_COD"		,c_Codigo													  ,NIL})
		aadd(a_Vetor,{"A2_LOJA"		,"01"														  ,NIL})
		aadd(a_Vetor,{"A2_NOME"		,PADR(ALLTRIM(o_Fornecedor:c_Nome),TAMSX3("A2_NOME")[1]) 	  ,NIL})
		aadd(a_Vetor,{"A2_NREDUZ"	,PADR(ALLTRIM(o_Fornecedor:c_Nome),TAMSX3("A2_NREDUZ")[1])	  ,NIL})
		aadd(a_Vetor,{"A2_END"		,PADR(ALLTRIM(o_Fornecedor:c_Endereco),TAMSX3("A2_END")[1])	  ,NIL})
		aadd(a_Vetor,{"A2_EST"		,PADR(ALLTRIM(o_Fornecedor:c_Estado),TAMSX3("A2_EST")[1])	  ,NIL})
		aadd(a_Vetor,{"A2_MUN"		,PADR(ALLTRIM(o_Fornecedor:c_Cidade),TAMSX3("A2_MUN")[1])	  ,NIL})
		aadd(a_Vetor,{"A2_CEP"		,PADR(ALLTRIM(o_Fornecedor:c_Cep),TAMSX3("A2_CEP")[1])		  ,NIL})
		aadd(a_Vetor,{"A2_BAIRRO"	,PADR(ALLTRIM(o_Fornecedor:c_Bairro),TAMSX3("A2_BAIRRO")[1])	  ,NIL})
		aadd(a_Vetor,{"A2_TIPO"		,IIF(LEN(o_Fornecedor:c_CNPJ)==14,"J","F")					  ,NIL})
		aadd(a_Vetor,{"A2_CGC"		,o_Fornecedor:c_CNPJ										  ,NIL})
		aadd(a_Vetor,{"A2_EMAIL"	,PADR(ALLTRIM(o_Fornecedor:c_Email),TAMSX3("A2_EMAIL")[1])	  ,NIL})
		aadd(a_Vetor,{"A2_INSCR"	,PADR(ALLTRIM(o_Fornecedor:c_IE),TAMSX3("A2_INSCR")[1])		  ,NIL})
		aadd(a_Vetor,{"A2_CONTATO"	,PADR(ALLTRIM(o_Fornecedor:c_Contato),TAMSX3("A2_CONTATO")[1]) ,NIL})
		aadd(a_Vetor,{"A2_DDD"		,PADR(ALLTRIM(o_Fornecedor:c_Ddd),TAMSX3("A2_DDD")[1])		  ,NIL})
		aadd(a_Vetor,{"A2_TEL"		,PADR(ALLTRIM(o_Fornecedor:c_Tel),TAMSX3("A2_TEL")[1])		  ,NIL})
		aadd(a_Vetor,{"A2_CONTA"	,"21101001"													  ,NIL})
		aadd(a_Vetor,{"A2_FSCTIS"	,o_Fornecedor:c_Iso											  ,NIL})
		aadd(a_Vetor,{"A2_FSPBQPH"	,o_Fornecedor:c_Pbqp										  ,NIL})
		aadd(a_Vetor,{"A2_FSRDB"	,o_Fornecedor:c_Rdb											  ,NIL})
		aadd(a_Vetor,{"A2_FSFLUIG"	,o_Fornecedor:n_NumFluig									  ,NIL})
	
		If SA2->(FieldPos("A2_MSBLQL")) > 0
	
			aadd(a_Vetor,{"A2_MSBLQL"	,"1"									,NIL})
	
		EndIf
	
		BEGIN TRANSACTION
	
			MSExecAuto({|x,y| mata020(x,y)},a_Vetor,3)
	
			If lMsErroAuto
	
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= MostraErro()
				DisarmTransaction()
				//RollBackSX8()
				//break
	
			Else
	
				::o_Retorno:l_Status		:= .T.
				::o_Retorno:c_Mensagem	:= "Fornecedor " + Alltrim( c_Codigo ) + " cadastrado com sucesso!!!"
				//ConfirmSX8()
	
			EndIf
	
		END TRANSACTION
	Else
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Fonte FCOMA006 nao compilado. Cadastro de fornecedor nao executado!"
		Return(.T.)
	Endif
Return(.T.)

WSMETHOD mtdLibPedido WSRECEIVE o_Empresa, o_Seguranca, o_LibPedido WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local a_Ret		:= {}

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If Findfunction("U_FCOMW001")
		a_Ret := StartJob("U_FCOMW001",GetEnvServer(),.T., ::o_Empresa:c_Empresa,::o_Empresa:c_Filial, ::o_Seguranca:c_Usuario, ::o_Seguranca:c_Senha, o_LibPedido:c_Docto, o_LibPedido:c_Tipo, o_LibPedido:n_Valor, o_LibPedido:c_Aprov, o_LibPedido:c_User, o_LibPedido:c_Grupo, o_LibPedido:l_TipoAcao, o_LibPedido:c_Rejeit )
	Else
		aAdd(a_Ret, .F.)
		aAdd(a_Ret, "Fonte FCOMW001 nao compilado. liberacao de pedido nao executada!")
	Endif
	
	::o_Retorno:l_Status	:= a_Ret[ 1 ]
	::o_Retorno:c_Mensagem	:= a_Ret[ 2 ]

Return(.T.)


WSMETHOD mtdRetUsuario WSRECEIVE o_Empresa, c_nmUsuario WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	::o_Retorno:l_Status	:= .T.
	::o_Retorno:c_Mensagem	:= f_UserFluig(usrretname(AllTrim(c_nmUsuario)))

Return(.T.)

WSMETHOD mtdGrvProduto WSRECEIVE o_Empresa, o_Seguranca, o_Produto WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local n_Oper	:= 0
	Local c_UserWS	:= ""
	Local c_PswWS	:= ""
	Local c_Cod		:= ""
	Local cQry		:= ""
	Local aVetor	:= {}
	Local n_Emin	:= 0

	Private lMsHelpAuto	:= .F. // se .t. direciona as mensagens de help
	Private lMsErroAuto	:= .F. //necessario a criacao

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")
	c_PathLog	:= SUPERGETMV("FS_PATHLOG",,"\WS_LOG\")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	n_Emin := val(REPLACE(REPLACE(o_Produto:c_Emin,'.',''),',','.'))

	cQry := "SELECT TOP 1 B1_COD FROM " + RetSqlName("SB1") + " B1 "
	cQry += "WHERE B1.D_E_L_E_T_ <> '*' AND B1_SUBFAMI = '" + o_Produto:c_Codigo + "' "
	cQry +=	"ORDER BY B1_COD DESC "

	TCQUERY cQry NEW ALIAS QRY

	dbSelectArea("QRY")
	dbGoTop()

	If Empty(QRY->B1_COD)
		cCod := AllTrim(o_Produto:c_Codigo) + "001"
	Else
		cCod := AllTrim(o_Produto:c_Codigo) + StrZero((Val(SubStr(QRY->B1_COD,7,3))+1),3)
	Endif

	Conout( "Cod=> " + cCod )

	dbSelectArea("QRY")
	dbCloseArea()

	If Len( o_Produto:c_Grupo ) > 4
		Conout( "O grupo está maior que o campo " + o_Produto:c_Grupo )
	EndIf

	/*//Prod
	aVetor	:= {;
	{"B1_COD"     	,Padr(cCod, TamSx3("B1_COD")[1])	 					,NIL},;
	{"B1_DESC"    	,Padr(o_Produto:c_Descricao, TamSx3("B1_DESC")[1]) 		,NIL},;
	{"B1_TIPO"    	,Padr(o_Produto:c_Tipo, TamSx3("B1_TIPO")[1])			,Nil},;
	{"B1_UM"      	,Padr(o_Produto:c_UM, TamSx3("B1_UM")[1])            	,Nil},;
	{"B1_LOCPAD"  	,Padr(o_Produto:c_LocPad, TamSx3("B1_LOCPAD")[1])		,Nil},;
	{"B1_GARANT" 	,"1"             										,Nil},;
	{"B1_GRUPO" 	,Padr(o_Produto:c_Grupo, TamSx3("B1_GRUPO")[1])			,Nil},;
	{"B1_SUBFAMI" 	,Padr(o_Produto:c_SubFam, TamSx3("B1_SUBFAMI")[1])			,Nil},;
	{"B1_EMIN" 		,n_Emin													,Nil},;
	{"B1_FSFLUIG" 	,o_Produto:n_NumFluig								,Nil},;
	{"B1_CONTA" 	,Padr(o_Produto:c_Conta, TamSx3("B1_CONTA")[1])			,Nil}}

	BEGIN TRANSACTION

	MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)

	If lMsErroAuto

	::o_Retorno:l_Status	:= .F.
	::o_Retorno:c_Mensagem	:= MostraErro()
	DisarmTransaction()
	//break

	Else

	::o_Retorno:l_Status		:= .T.
	::o_Retorno:c_Mensagem	:= cCod

	EndIf

	END TRANSACTION*/


	BEGIN TRANSACTION

		dbSelectArea("SB1")
		RecLock( "SB1", .T. )
		SB1->B1_FILIAL	:= XFILIAL("SB1")
		SB1->B1_COD		:= cCod
		SB1->B1_DESC	:= ::o_Produto:c_Descricao
		SB1->B1_TIPO	:= ::o_Produto:c_Tipo
		SB1->B1_UM		:= ::o_Produto:c_UM
		SB1->B1_LOCPAD	:= ::o_Produto:c_LocPad
		SB1->B1_GARANT	:= "1"
		SB1->B1_GRUPO	:= ::o_Produto:c_Grupo
		SB1->B1_SUBFAMI	:= ::o_Produto:c_SubFam
		SB1->B1_EMIN	:= n_Emin
		SB1->B1_FSFLUIG	:= ::o_Produto:n_NumFluig
		SB1->B1_CONTA	:= ::o_Produto:c_Conta
		MsUnlock()

		::o_Retorno:l_Status		:= .T.
		::o_Retorno:c_Mensagem	:= cCod

	END TRANSACTION

Return(.T.)

WSMETHOD mtdGrvFinanceiro WSRECEIVE o_Empresa, o_Seguranca, o_DadosTit WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local c_UserWS	:= ""
	Local c_PswWS	:= ""
	Local c_For		:= ""
	Local c_Lj		:= ""
	Local c_Num		:= ""
	Local c_Prf		:= ""

	Private lMsHelpAuto	:= .F. // se .t. direciona as mensagens de help
	Private lMsErroAuto	:= .F. //necessario a criacao

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")
	c_PathLog	:= SUPERGETMV("FS_PATHLOG",,"\WS_LOG\")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	c_For		:= PADR( o_DadosTit:c_Fornece, TAMSX3("E2_FORNECE")[1] )
	c_Lj		:= PADR( o_DadosTit:c_Loja, TAMSX3("E2_LOJA")[1] )
	c_Num		:= PADR( o_DadosTit:c_Doc, TAMSX3("E2_NUM")[1] )
	c_Prf		:= PADR( o_DadosTit:c_Serie, TAMSX3("E2_PREFIXO")[1] )

	DBSELECTAREA("SE2")
	DBSETORDER(6)
	DBSEEK( XFILIAL("SE2") + c_For + c_Lj + c_Prf + c_Num )
	WHILE SE2->(!EOF()) .AND. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == XFILIAL("SE2") + c_For + c_Lj + c_Prf + c_Num

		RECLOCK( "SE2", .F. )
		SE2->E2_FSLIB	:= '1'
		MSUNLOCK()

		SE2->(DBSKIP())

	ENDDO

	::o_Retorno:l_Status		:= .T.
	::o_Retorno:c_Mensagem	:= "Titulo liberado com sucesso!!!"

Return(.T.)

WSMETHOD mtdGrvSC WSRECEIVE o_Empresa, o_Seguranca, o_SC WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local n_Oper	:= 0
	Local c_UserWS	:= ""
	Local c_PswWS	:= ""
	Local aVetor	:= {}
	Local c_Doc		:= ""
	Local a_Cabec	:= {}
	Local a_Itens	:= {}
	Local nX
	Local nY
	Local c_CC		:= ""
	Local a_ItCC	:= {}
	Local a_GrpAprv	:= {}

	Private lMsHelpAuto	:= .F. // se .t. direciona as mensagens de help
	Private lMsErroAuto	:= .F. //necessario a criacao

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")
	c_PathLog	:= SUPERGETMV("FS_PATHLOG",,"\WS_LOG\")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	/*DBSELECTAREA("SX6")
	DBSETORDER(1)
	DBSEEK( ::o_Empresa:c_Filial + "FS_NUMSC" )

	//	c_Doc := "F" + StrZero(Val(GetMV("FS_NUMSC")),5)
	//c_Doc := GetSXENum("SC1","C1_NUM")

	c_Doc := "F" + StrZero(Val(SX6->X6_CONTEUD),5)

	dbSelectArea("SX6")
	dbSetorder(1)
	if dbSeek(::o_Empresa:c_Filial + "FS_NUMSC")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD	:= StrZero(Val(SX6->X6_CONTEUD)+1,5)
		MsUnlock()
	endif*/
	
	c_Doc := GetSXENum("SC1","C1_NUM")           
	SC1->(dbSetOrder(1))           
	While SC1->(dbSeek(xFilial("SC1")+c_Doc))                
	     ConfirmSX8()                
	     c_Doc := GetSXENum("SC1","C1_NUM")           
	EndDo  

	a_Login 	:= f_wsLogin(::o_SC:C1_FSUSRF)
	c_Login 	:= Iif(Valtype(a_Login) == "A" .And. !Empty(a_Login),a_Login[3],"")
	c_IdUsr		:= Iif(Valtype(a_Login) == "A" .And. !Empty(a_Login),a_Login[2],"")	 
	c_usr		:= Iif(Valtype(a_Login) == "A" .And. !Empty(a_Login),"******"+Padr(c_Login,15)+"SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNNNNNNNNNNSNSNNSNNSNSSNNSSSSSSSSNNNNNSSSSNNNSSSSSSSSSSSNNNNNNSNNNSNNSSSSSSSSSNNSSSNSSSSSSSSSSSSNSSNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN","")	
	
	a_UsrAutoOld:=	{}
	aAdd(a_UsrAutoOld,CUSUARIO)
	aAdd(a_UsrAutoOld,__CUSERID)
	aAdd(a_UsrAutoOld,CUSERNAME)
	
	CUSUARIO 	:= Iif(Empty(CUSUARIO)  .And. !Empty(a_Login),c_usr,CUSUARIO)
	__CUSERID	:= Iif(Empty(__CUSERID) .And. !Empty(a_Login),a_Login[2],__CUSERID)
	CUSERNAME	:= Alltrim(Iif(Empty(CUSERNAME) .And. Valtype(a_Login) == "A" .And. !Empty(a_Login),a_Login[3],""))
	
	Conout("RetCodUsr: "+RetCodUsr())


	aadd(a_Cabec,{"C1_NUM"    ,c_Doc})
	aadd(a_Cabec,{"C1_SOLICIT",::o_SC:C1_SOLICIT})
	aadd(a_Cabec,{"C1_EMISSAO",dDataBase})

	FOR nX:=1 TO LEN(::o_SC:C1_ITENS)

		a_Linha := {}

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial("SB1") + PADR(::o_SC:C1_ITENS[nX]:C1_PRODUTO, TAMSX3("C1_PRODUTO")[1]), .T. )

		aadd(a_Linha,{"C1_FILIAL"   ,PADR( xFilial("SC1"), TAMSX3( "C1_ITEM" )[ 1 ] )							,Nil})
		aadd(a_Linha,{"C1_ITEM"   	,StrZero( nX, TAMSX3( "C1_ITEM" )[ 1 ] )									,Nil})
		aadd(a_Linha,{"C1_PRODUTO"	,PADR(::o_SC:C1_ITENS[nX]:C1_PRODUTO, TAMSX3("C1_PRODUTO")[1])				,Nil})
		aadd(a_Linha,{"C1_UM"  		,PADR(::o_SC:C1_ITENS[nX]:C1_UM, TAMSX3("C1_UM")[1])						,Nil})
		aadd(a_Linha,{"C1_QUANT"  	,::o_SC:C1_ITENS[nX]:C1_QUANT												,Nil})
		//aadd(a_Linha,{"C1_QTSEGUM"  ,::o_SC:C1_ITENS[nX]:C1_2QUANT												,Nil})
		aadd(a_Linha,{"C1_LOCAL"  	,SB1->B1_LOCPAD		,Nil})//PADR(::o_SC:C1_ITENS[nX]:C1_LOCAL, TAMSX3("C1_LOCAL")[1])					,Nil})
		aadd(a_Linha,{"C1_CC"  		,PADR(::o_SC:C1_ITENS[nX]:C1_CC, TAMSX3("C1_CC")[1])						,Nil})
		//aadd(a_Linha,{"C1_CONTA"  ,PADR(::o_SC:C1_ITENS[nX]:C1_CONTA, TAMSX3("C1_CONTA")[1])					,Nil})
		aadd(a_Linha,{"C1_CONTA"  	,SB1->B1_CONTA		,Nil})
		aadd(a_Linha,{"C1_DATPRF"	,PADR(ALLTRIM(::o_SC:C1_ITENS[nX]:c_DTNEC), TAMSX3("C1_DATPRF")[1])		,Nil})
		aadd(a_Linha,{"C1_DESCRI"	,PADR(ALLTRIM(::o_SC:C1_ITENS[nX]:C1_DESCRI), TAMSX3("C1_DESCRI")[1])		,Nil})
		
		If SC1->(FieldPos("C1_FSFLUIG")) > 0
			aadd(a_Linha,{"C1_FSFLUIG"	,::o_SC:n_NumFluig															,Nil})
		Endif
		
		If SC1->(FieldPos("C1_FSUSRF")) > 0
			aadd(a_Linha,{"C1_FSUSRF"	,::o_SC:C1_FSUSRF															,Nil})
		Endif
		
		aadd(a_Linha,{"C1_OBS"		,::o_SC:C1_ITENS[nX]:c_Obs													,Nil})
		//aadd(a_Linha,{"C1_FSEND"	,::o_SC:C1_ITENS[nX]:c_End													,Nil})
		
		If SC1->(FieldPos("C1_FSJUS")) > 0
			aadd(a_Linha,{"C1_FSJUS"	,::o_SC:C1_ITENS[nX]:c_Just												,Nil})
		Endif
		
		If SC1->(FieldPos("C1_FSMARC")) > 0
			aadd(a_Linha,{"C1_FSMARC"	,::o_SC:C1_ITENS[nX]:c_Marca											,Nil})
		Endif
		
		If SC1->(FieldPos("C1_FSTPEM")) > 0
			aadd(a_Linha,{"C1_FSTPEM"	,::o_SC:C1_ITENS[nX]:c_Emerg											,Nil})
		Endif
		
		If SC1->(FieldPos("C1_FSCDEM")) > 0
			aadd(a_Linha,{"C1_FSCDEM"	,::o_SC:C1_ITENS[nX]:c_JEmerg											,Nil})
		Endif
		
		If SC1->(FieldPos("C1_URGENTE")) > 0
			aadd(a_Linha,{"C1_URGENTE"	,::o_SC:C1_ITENS[nX]:c_JEmerg											,Nil})
		Endif

		aadd(a_Itens,a_Linha)
		aadd(a_ItCC, { c_Doc, StrZero( nX, TAMSX3( "C1_ITEM" )[ 1 ] ), PADR(::o_SC:C1_ITENS[nX]:C1_CC, TAMSX3("C1_CC")[1]),::o_SC:C1_ITENS[nX]:c_Marca,::o_SC:C1_ITENS[nX]:c_Emerg,::o_SC:C1_ITENS[nX]:c_JEmerg })

		/*IF SUPERGETMV("FS_1CC",.F.,.F.)
			DBSELECTAREA( "CTT" )
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("CTT") + PADR(::o_SC:C1_ITENS[nX]:C1_CC, TAMSX3("C1_CC")[1] ), .T. )
				IF EMPTY( CTT->CTT_FSAPV )
					//Aviso(SM0->M0_NOMECOM,c_Texto+" não possui um grupo de aprovador definido, favor solicitar que este "+c_Texto+" seja atualizado ou defina outro "+c_Texto,{"Voltar"},2,"Atenção")
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "O centro de custo " + Alltrim( PADR(::o_SC:C1_ITENS[nX]:C1_CC, TAMSX3("C1_CC")[1] ) ) + " não possui um grupo de aprovador definido, favor solicitar que este seja atualizado ou defina outro."
					Return( .T. )
				ELSE
					IF ASCAN( a_GrpAprv, CTT->CTT_FSAPV ) == 0
						AADD( a_GrpAprv, CTT->CTT_FSAPV )
					ENDIF
				ENDIF
			ENDIF
		EndIF*/

	NEXT

	IF SUPERGETMV("FS_1CC",.F.,.F.)
		IF Len(  a_GrpAprv) >= 2
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Não é permitido em uma única SC Centro de Custos com grupos de aprovadores diferentes."
			Return( .T. )
		ENDIF
	EndIf
	
	Private lAutoErrNoFile	:=	.T.
	lMsErroAuto	:=	.F.
	
	BEGIN TRANSACTION

		MSExecAuto({|x,y| mata110(x,y)},a_Cabec,a_Itens,3)

		If lMsErroAuto
	
			a_LogErr := GetAutoGRLog()
			c_Motivo := "Erro na inclusao do registro de solicitacao de compras. "+ENTER
	
			For n_i := 1 to Len(a_LogErr)
				c_Motivo += a_LogErr[n_i] +ENTER
			Next
			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				c_Motivo:=  NoAcento(c_Motivo)
			EndIf

			//c_Mensagem	:=	c_Motivo 
	
			
			//c_Mensagem		:= 	MostraErro()
			
			::o_Retorno:l_Status		:= 	.F.
			::o_Retorno:c_Mensagem		:=	c_Motivo
			DisarmTransaction()
			//RollBackSX8()

		Else

			For nY:=1 To Len( a_ItCC )

				dbSelectArea("SC1")
				dbSetorder(1)
				if dbSeek(xFilial("SC1") + a_ItCC[nY][1] + a_ItCC[nY][2], .T. )
					RecLock("SC1",.F.)

					SC1->C1_FILIAL	:= 	::o_Empresa:c_Filial
					SC1->C1_FILENT	:= 	::o_Empresa:c_Filial
					SC1->C1_CC		:= 	a_ItCC[nY][3]
					SC1->C1_SOLICIT	:= 	::o_SC:C1_SOLICIT   
					If SC1->(FieldPos("C1_FSMARC")) > 0
						SC1->C1_FSMARC	:= 	a_ItCC[nY][4]
					Endif  
					If SC1->(FieldPos("C1_FSTPEM")) > 0
						SC1->C1_FSTPEM	:= 	a_ItCC[nY][5]
					Endif  
					If SC1->(FieldPos("C1_FSCDEM")) > 0
						SC1->C1_FSCDEM	:= 	a_ItCC[nY][6]
					Endif  
					If SC1->(FieldPos("C1_URGENTE")) > 0
						SC1->C1_URGENTE	:=	a_ItCC[nY][6]
					Endif

					If SC1->(FieldPos("C1_FSFLUIG")) > 0
						If SC1->C1_FSFLUIG == 0
							SC1->C1_FSFLUIG	:=	::o_SC:n_NumFluig
						Endif
					Endif

					If SC1->(FieldPos("C1_FSUSRF")) > 0
						SC1->C1_FSUSRF	:=	::o_SC:C1_FSUSRF
					Endif

					MsUnlock()
				endif

			Next

			::o_Retorno:l_Status		:= .T.
			::o_Retorno:c_Mensagem	:= Alltrim( c_Doc )

			//dbSelectArea("SX6")
			//dbSetorder(1)
			//if dbSeek(::o_Empresa:c_Filial + "FS_NUMSC")
			//RecLock("SX6",.F.)
			//SX6->X6_CONTEUD	:= StrZero(Val(SX6->X6_CONTEUD)+1,5)
			//MsUnlock()
			//endif

			//	PutMV("FS_NUMSC", StrZero(Val(GetMV("FS_NUMSC"))+1,5) )

			//ConfirmSX8()

		EndIf

	END TRANSACTION

	CUSUARIO 	:=	a_UsrAutoOld[1] 
	__CUSERID	:= 	a_UsrAutoOld[2]
	CUSERNAME	:=	a_UsrAutoOld[3]

Return(.T.)



WSMETHOD mtdEnvCot WSRECEIVE o_Empresa, o_Seguranca, c_numCot, c_Fornece, c_Loja  WSSEND o_RetGeral WSSERVICE WS_FSFLUIG

	Local o_Result
	Local c_UserWS		:= ""
	Local c_PswWS		:= ""
	Local c_To		:= ""
	Local c_Subj	:= ""
	Local c_Anexo	:= {}
	Local c_Msg		:= ""

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= "ERRO:2527"
		o_Result:c_Descricao	:= "Tentativa de acesso ao WS nao permitida!"
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .F.

		AADD( ::o_RetGeral, o_Result )

		Return(.T.)

	ENDIF
	
	dbSelectArea("SA2")
	dbSetorder(1)
	if dbSeek(xFilial("SA2") + Padr( c_Fornece, TamSX3("A2_COD")[1] ) + Padr( c_Loja, TamSX3("A2_LOJA")[1] ), .T. )

		c_Subj	:= "Cotação "+c_numCot+" atualizada - "+Alltrim(SA2->A2_NREDUZ)+"."
		
		c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
		c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
		c_Msg += '<head>'
		c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
		c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
		c_Msg += '</head>'
		c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Cotação Atualizada</font></td>'
		c_Msg += '  </tr>'
		c_Msg += '</table>'
		c_Msg += '<br>'
		c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
		c_Msg += '  <tr>'
		c_Msg += '  	<td align="left" width="100%">'
		c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
		c_Msg += '    		<p>Prezado Usuário a cotação Nr. '+Alltrim(c_numCot)+' foi atualizada pelo fornecedor: '+Alltrim(SA2->A2_NREDUZ)+'.</p>'
		c_Msg += '		</font>'
		c_Msg += ' 	</td>'
		c_Msg += '  </tr>'
		c_Msg += '</table>'
		c_Msg += '<body>'
		c_Msg += '</body>'
		c_Msg += '</html>'
		
		
		c_To := SUPERGETMV("FS_MAILCOM",,"compras@bomix.com.br")
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama a função que envia email:                                 ³
		//³                                                                ³
		//³1º Parâmetro: Para                                              ³
		//³2º Parâmetro: Corpo do Email                                    ³
		//³3º Parâmetro: Assunto                                           ³
		//³4º Parâmetro: Se exibe a tela informando que o email foi enviado³
		//³5º Parâmetro: Anexo                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)
	ENDIF

Return(.T.)

WSMETHOD mtdRetTipo WSRECEIVE o_Empresa, o_Seguranca WSSEND o_RetGeral WSSERVICE WS_FSFLUIG

	Local o_Result
	Local c_UserWS		:= ""
	Local c_PswWS		:= ""

	Private lMsHelpAuto := .f. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= "ERRO:2527"
		o_Result:c_Descricao	:= "Tentativa de acesso ao WS nao permitida!"
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .F.

		AADD( ::o_RetGeral, o_Result )

		Return(.T.)

	ENDIF

	BEGINSQL ALIAS "QRY"

		SELECT X5_CHAVE, X5_DESCRI FROM %TABLE:SX5% SX5 WHERE X5_FILIAL= %xfilial:SX5% AND X5_TABELA = %EXP:'02'% AND SX5.%NOTDEL%

	ENDSQL

	DBSELECTAREA("QRY")
	QRY->(DBGOTOP())

	WHILE QRY->(!EOF())

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= QRY->X5_CHAVE
		o_Result:c_Descricao	:= QRY->X5_DESCRI
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .T.

		AADD( ::o_RetGeral, o_Result )

		QRY->(DBSKIP())

	ENDDO
	QRY->(dbCloseArea())

Return(.T.)

WSMETHOD mtdRetProduto WSRECEIVE o_Empresa, o_Seguranca WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local o_Result
	Local c_UserWS		:= ""
	Local c_PswWS		:= ""

	Private lMsHelpAuto := .f. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= "ERRO:2527"
		o_Result:c_Descricao	:= "Tentativa de acesso ao WS nao permitida!"
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .F.

		AADD( ::o_Retorno, o_Result )

		Return(.T.)

	ENDIF

	BEGINSQL ALIAS "QRY"

		SELECT TOP 5000 B1_COD, B1_DESC, B1_TIPO, B1_GRUPO FROM %TABLE:SB1% SB1 WHERE B1_FILIAL= %xfilial:SB1% AND SB1.%NOTDEL%

	ENDSQL

	DBSELECTAREA("QRY")
	QRY->(DBGOTOP())

	WHILE QRY->(!EOF())

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= QRY->B1_COD
		o_Result:c_Descricao	:= QRY->B1_DESC
		o_Result:c_Tipo			:= QRY->B1_TIPO
		o_Result:c_Grupo		:= QRY->B1_GRUPO
		o_Result:l_Tipo			:= .T.

		AADD( ::o_Retorno, o_Result )

		QRY->(DBSKIP())

	ENDDO
	QRY->(dbCloseArea())

Return(.T.)

WSMETHOD mtdRetUM WSRECEIVE o_Empresa, o_Seguranca WSSEND o_RetGeral WSSERVICE WS_FSFLUIG

	Local o_Result
	Local c_UserWS		:= ""
	Local c_PswWS		:= ""

	Private lMsHelpAuto := .f. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= "ERRO:2527"
		o_Result:c_Descricao	:= "Tentativa de acesso ao WS nao permitida!"
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .F.

		AADD( ::o_RetGeral, o_Result )

		Return(.T.)

	ENDIF

	BEGINSQL ALIAS "QRY"

		SELECT AH_UNIMED, AH_DESCPO FROM %TABLE:SAH% SAH WHERE AH_FILIAL= %xfilial:SAH% AND SAH.%NOTDEL%

	ENDSQL

	DBSELECTAREA("QRY")
	QRY->(DBGOTOP())

	WHILE QRY->(!EOF())

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= QRY->AH_UNIMED
		o_Result:c_Descricao	:= QRY->AH_DESCPO
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .T.

		AADD( ::o_RetGeral, o_Result )

		QRY->(DBSKIP())

	ENDDO
	QRY->(dbCloseArea())

Return(.T.)

WSMETHOD mtdRetGrupo WSRECEIVE o_Empresa, o_Seguranca WSSEND o_RetGeral WSSERVICE WS_FSFLUIG

	Local o_Result
	Local c_UserWS		:= ""
	Local c_PswWS		:= ""

	Private lMsHelpAuto := .f. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= "ERRO:2527"
		o_Result:c_Descricao	:= "Tentativa de acesso ao WS nao permitida!"
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .F.

		AADD( ::o_RetGeral, o_Result )

		Return(.T.)

	ENDIF

	BEGINSQL ALIAS "QRY"

		SELECT BM_GRUPO, BM_DESC FROM %TABLE:SBM% SBM WHERE BM_FILIAL= %xfilial:SBM% AND SBM.%NOTDEL%

	ENDSQL

	DBSELECTAREA("QRY")
	QRY->(DBGOTOP())

	WHILE QRY->(!EOF())

		o_Result := WSCLASSNEW("strRetGeral")

		o_Result:c_Codigo		:= QRY->BM_GRUPO
		o_Result:c_Descricao	:= QRY->BM_DESC
		o_Result:c_Tipo			:= ""
		o_Result:c_Grupo		:= ""
		o_Result:l_Tipo			:= .T.

		AADD( ::o_RetGeral, o_Result )

		QRY->(DBSKIP())

	ENDDO
	QRY->(dbCloseArea())

Return(.T.)

WsMethod mtdAtualizaCot WsReceive o_Empresa, o_Seguranca, o_Cotacao WsSend o_Retorno WsService WS_FSFLUIG

	Local n	:= 1

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	for n := 1 to LEN(::o_Cotacao:lItens)
		// Efetuar o update no Banco do item corrente
		DBSELECTAREA("SC8")
		DBSETORDER(1)

		cSeek := XFILIAL("SC8")+ PADR(o_Cotacao:iNumCotacao, TAMSX3("C8_NUM")[1]) + PADR(o_Cotacao:iNumFornece, TAMSX3("C8_FORNECE")[1]) + PADR(o_Cotacao:iLojaFornece, TAMSX3("C8_LOJA")[1]) + PADR(o_Cotacao:lItens[n]:iNumItem, TAMSX3("C8_ITEM")[1]) + PADR(o_Cotacao:iNumPro, TAMSX3("C8_NUMPRO")[1])

		if (DBSEEK(cSeek,.T.))
			if (SC8->C8_FSSTAT == "3")
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Esta cotação já foi atualizada anteriormente, caso deseje enviar uma nova, entre em contato com a empresa solicitante para que a mesma lhe envie uma nova proposta."
				exit
			else

				If SC8->C8_VALIDA <= DDATABASE
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Esta cotação não é mais válida. Contate o setor de compras!"
					exit
				EndIf

				If !Empty( SC8->C8_NUMPED )
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Esta cotação já foi encerrada pela BOMIX. Em caso de dúvidas contate o setor de compras!"
					exit
				EndIF

				RECLOCK("SC8",.F.)
				SC8->C8_PRECO   	:= ::o_Cotacao:lItens[n]:fVlUnit
				SC8->C8_TOTAL   	:= ::o_Cotacao:lItens[n]:fVlTotal
				SC8->C8_ALIIPI  	:= ::o_Cotacao:lItens[n]:fIPI
				SC8->C8_VALIPI  	:= ::o_Cotacao:lItens[n]:fVlTotal * (::o_Cotacao:lItens[n]:fIPI / 100)
				SC8->C8_TOTFRE  	:= ::o_Cotacao:fFrete	 // Total do Frete
				SC8->C8_VALFRE  	:= ::o_Cotacao:fFrete / LEN(::o_Cotacao:lItens) // Valor rateado do Frete
				SC8->C8_VLDESC  	:= ::o_Cotacao:fDesc  / LEN(::o_Cotacao:lItens)  // Valor rateado do Desconto
				SC8->C8_TPFRETE		:= ::o_Cotacao:iTpFrete       // FIXO
				SC8->C8_PRAZO   	:= ::o_Cotacao:lItens[n]:iPz
				SC8->C8_COND		:= ::o_Cotacao:cCondPgto
				SC8->C8_FSSTAT 		:= "3" // Marca o item como atualizado, para evitar atualizações futuras
				MSUNLOCK()

				::o_Retorno:l_Status		:= .T.
				::o_Retorno:c_Mensagem	:= "Cotação atualizada com sucesso!"

			endif
		else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Esta cotação não existe mais no sistema. Procure o setor de compras da BOMIX!"
			Return(.T.)
		endif
	next

Return (.t.)

//===================
//INCLUSAO DE SA
//===================
WSMETHOD mtdGrvSA WSRECEIVE o_Empresa, o_Seguranca, o_SA WSSEND o_Retorno WSSERVICE WS_FSFLUIG

	Local n_Oper	:= 0
	Local c_UserWS	:= ""
	Local c_PswWS	:= ""
	Local aVetor	:= {}
	Local c_Doc		:= ""
	Local a_Cabec	:= {}
	Local a_Itens	:= {}
	Local nX
	Local nY
	Local c_CC		:= ""
	Local a_ItCP	:= {}
	Local a_GrpAprv	:= {}

	Private lMsHelpAuto	:= .F. // se .t. direciona as mensagens de help
	Private lMsErroAuto	:= .F. //necessario a criacao

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")
	c_PathLog	:= SUPERGETMV("FS_PATHLOG",,"\WS_LOG\")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	c_Doc := GetSXENum("SCP","CP_NUM")           
	SCP->(dbSetOrder(1))           
	While SCP->(dbSeek(xFilial("SCP")+c_Doc))                
	     ConfirmSX8()                
	     c_Doc := GetSXENum("SCP","CP_NUM")           
	EndDo  

	/*
	a_Login - Array com dados do os usuário solicitante enviado pelo fluig no protheus
	[n][1] Id da tabela de usuários
	[n][2] Id do usuário
	[n][3] Login do Usuário
	[n][4] Nome do usuário
	[n][5] email do usuário
	[n][6] departamento do usuário
	[n][7] cargo do usuário
	*/	
	a_Login 	:= f_wsLogin(::o_SA:CP_FSUSRF)
	c_Login 	:= Iif(Valtype(a_Login) == "A" .And. !Empty(a_Login),a_Login[3],"")
	c_IdUsr		:= Iif(Valtype(a_Login) == "A" .And. !Empty(a_Login),a_Login[2],"")	 
	c_usr		:= Iif(Valtype(a_Login) == "A" .And. !Empty(a_Login),"******"+Padr(c_Login,15)+"SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNNNNNNNNNNSNSNNSNNSNSSNNSSSSSSSSNNNNNSSSSNNNSSSSSSSSSSSNNNNNNSNNNSNNSSSSSSSSSNNSSSNSSSSSSSSSSSSNSSNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN","")	
	
	a_UsrAutoOld:=	{}
	aAdd(a_UsrAutoOld,CUSUARIO)
	aAdd(a_UsrAutoOld,__CUSERID)
	aAdd(a_UsrAutoOld,CUSERNAME)
	
	CUSUARIO 	:= Iif(Empty(CUSUARIO)  .And. !Empty(a_Login),c_usr,CUSUARIO)
	__CUSERID	:= Iif(Empty(__CUSERID) .And. !Empty(a_Login),a_Login[2],__CUSERID)
	CUSERNAME	:= Alltrim(Iif(Empty(CUSERNAME) .And. Valtype(a_Login) == "A" .And. !Empty(a_Login),a_Login[3],""))
	
	Conout("RetCodUsr: "+RetCodUsr())
	
	aadd(a_Cabec,{"CP_NUM"    	,c_Doc												, NIL})
	aadd(a_Cabec,{"CP_SOLICIT"	,c_Login											, NIL})
	aadd(a_Cabec,{"CP_EMISSAO"	,dDataBase											, NIL})
	//aadd(a_Cabec,{"CP_CODSOLI"	,PADR(::o_SA:CP_CODSOLI, TAMSX3("CP_CODSOLI")[1])	, NIL})
	
	l_Continua := (!Empty(c_Login))
	
	
	FOR nX:=1 TO LEN(::o_SA:CP_ITENS)

		a_Linha := {}

		dbSelectArea("SB1")
		dbSetOrder(1)
		c_ChaveB1	:=	xFilial("SB1") + PADR(::o_SA:CP_ITENS[nX]:CP_PRODUTO, TAMSX3("CP_PRODUTO")[1])
		If dbSeek( c_ChaveB1 , .T. )
		
			c_CC	:=	PADR(::o_SA:CP_ITENS[nX]:CP_CC, TAMSX3("CP_CC")[1])
			
			aadd(a_Linha,{"CP_FILIAL"   ,PADR( xFilial("SCP"), TAMSX3( "CP_FILIAL" )[ 1 ] )							,Nil})
			aadd(a_Linha,{"CP_ITEM"   	,StrZero( nX, TAMSX3( "CP_ITEM" )[ 1 ] )									,Nil})
			aadd(a_Linha,{"CP_PRODUTO"	,Alltrim(SB1->B1_COD)														,Nil})
			aadd(a_Linha,{"CP_UM"  		,SB1->B1_UM																	,Nil})
			aadd(a_Linha,{"CP_QUANT"  	,::o_SA:CP_ITENS[nX]:CP_QUANT												,Nil})
			aadd(a_Linha,{"CP_LOCAL"  	,SB1->B1_LOCPAD																,Nil})
			aadd(a_Linha,{"CP_CC"  		,c_CC																		,Nil})
			aadd(a_Linha,{"CP_CONTA"  	,SB1->B1_CONTA																,Nil})
			aadd(a_Linha,{"CP_DESCRI"	,SB1->B1_DESC																,Nil})
			
			If SCP->(FieldPos("CP_FSFLUIG")) > 0
				aadd(a_Linha,{"CP_FSFLUIG"	,::o_SA:n_NumFluig														,Nil})
			Endif
			
			If SCP->(FieldPos("CP_FSUSRF")) > 0
				aadd(a_Linha,{"CP_FSUSRF"	,::o_SA:CP_FSUSRF														,Nil})
			Endif
			
			aadd(a_Linha,{"CP_OBS"		,::o_SA:CP_ITENS[nX]:c_Obs													,Nil})
			
			If SCP->(FieldPos("CP_FSJUS")) > 0
				aadd(a_Linha,{"CP_FSJUS"	,::o_SA:CP_ITENS[nX]:c_Just												,Nil})
			Endif
			
			If SCP->(FieldPos("CP_FSTPEM")) > 0
				aadd(a_Linha,{"CP_FSTPEM"	,::o_SA:CP_ITENS[nX]:c_Emerg											,Nil})
			Endif
			
			If SCP->(FieldPos("CP_FSCDEM")) > 0
				aadd(a_Linha,{"CP_FSCDEM"	,::o_SA:CP_ITENS[nX]:c_JEmerg											,Nil})
			Endif
			
			If SCP->(FieldPos("CP_URGENTE")) > 0
				aadd(a_Linha,{"CP_URGENTE"	,::o_SA:CP_ITENS[nX]:c_JEmerg											,Nil})
			Endif
	
			aadd(a_Itens,a_Linha)
			//			   1      2                                        3                                                     4                            5          
			aadd(a_ItCP, { c_Doc, StrZero( nX, TAMSX3( "CP_ITEM" )[ 1 ] ), PADR(::o_SA:CP_ITENS[nX]:CP_CC, TAMSX3("CP_CC")[1]),::o_SA:CP_ITENS[nX]:c_Emerg,::o_SA:CP_ITENS[nX]:c_JEmerg })
	
			/*IF SUPERGETMV("FS_1CP",.F.,.F.)
				DBSELECTAREA( "CTT" )
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("CTT") + PADR(::o_SA:CP_ITENS[nX]:CP_CC, TAMSX3("CP_CC")[1] ), .T. )
					IF EMPTY( CTT->CTT_FSAPV )
						//Aviso(SM0->M0_NOMECOM,c_Texto+" não possui um grupo de aprovador definido, favor solicitar que este "+c_Texto+" seja atualizado ou defina outro "+c_Texto,{"Voltar"},2,"Atenção")
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "O centro de custo " + Alltrim( PADR(::o_SA:CP_ITENS[nX]:CP_CC, TAMSX3("CP_CC")[1] ) ) + " não possui um grupo de aprovador definido, favor solicitar que este seja atualizado ou defina outro."
						Return( .T. )
					ELSE
						IF ASCAN( a_GrpAprv, CTT->CTT_FSAPV ) == 0
							AADD( a_GrpAprv, CTT->CTT_FSAPV )
						ENDIF
					ENDIF
				ENDIF
			EndIF*/
		Else
			l_Continua := .F.
			
		Endif
	NEXT

	If l_Continua 
		IF SUPERGETMV("FS_1CP",.F.,.F.)
			IF Len(  a_GrpAprv) >= 2
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Não é permitido em uma única SC Centro de Custos com grupos de aprovadores diferentes."
				Return( .T. )
			ENDIF
		EndIf
		
		Private lAutoErrNoFile	:=	.T.
		lMsErroAuto	:=	.F.
		//SetFunName("MATA105")
		
		BEGIN TRANSACTION
	
	//		MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , nOpcx )
			MsExecAuto( { | x, y, z | Mata105( x, y , z ) },a_Cabec, a_Itens ,3)
			
			If lMsErroAuto
		
				a_LogErr := GetAutoGRLog()
				c_Motivo := "Erro na inclusao do registro de solicitacao de armazem. "+ENTER
		
				For n_i := 1 to Len(a_LogErr)
					c_Motivo += a_LogErr[n_i] +ENTER
				Next
				//Exclusivo para a versao 12
				If (GetVersao(.F.) == "12")
					c_Motivo:=  NoAcento(c_Motivo)
				EndIf
	
				::o_Retorno:l_Status		:= 	.F.
				::o_Retorno:c_Mensagem		:=	c_Motivo
				DisarmTransaction()
	
			Else
	
				For nY:=1 To Len( a_ItCP )
	
					dbSelectArea("SCP")
					dbSetorder(1)
					if dbSeek(xFilial("SCP") + a_ItCP[nY][1] + a_ItCP[nY][2], .T. )
						RecLock("SCP",.F.)
	
						SCP->CP_FILIAL	:= 	::o_Empresa:c_Filial
						SCP->CP_CC		:= 	a_ItCP[nY][3]
						SCP->CP_SOLICIT	:= 	c_Login    
						If SCP->(FieldPos("CP_FSTPEM")) > 0
							SCP->CP_FSTPEM	:= 	a_ItCP[nY][4]
						Endif  
						If SCP->(FieldPos("CP_FSCDEM")) > 0
							SCP->CP_FSCDEM	:= 	a_ItCP[nY][5]
						Endif  
						If SCP->(FieldPos("CP_URGENTE")) > 0
							SCP->CP_URGENTE	:=	a_ItCP[nY][5]
						Endif
	
						If SCP->(FieldPos("CP_FSFLUIG")) > 0
							If SCP->CP_FSFLUIG == 0
								SCP->CP_FSFLUIG	:=	::o_SA:n_NumFluig
							Endif
						Endif
	
						If SCP->(FieldPos("CP_FSUSRF")) > 0
							SCP->CP_FSUSRF	:=	::o_SA:CP_FSUSRF
						Endif
	
						MsUnlock()
					endif
	
				Next
	
				::o_Retorno:l_Status		:= .T.
				::o_Retorno:c_Mensagem	:= Alltrim( c_Doc )
	
			EndIf
	
		END TRANSACTION
	
	Else
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Inconsistência na linha de itens da solicitação ao armazem. Produto chave: ["+c_ChaveB1+"] nao encontrado na filial "+cFilAnt

	Endif

	CUSUARIO 	:=	a_UsrAutoOld[1] 
	__CUSERID	:= 	a_UsrAutoOld[2]
	CUSERNAME	:=	a_UsrAutoOld[3]

Return(.T.)

/*/{Protheus.doc} f_UserFluig
//Coleta matricula no fluig
@author carlo
@since 30/10/2019
@version 1.0
@return ${return}, ${return_description}
@param c_Chave, characters, descricao
@type function
/*/
Static Function f_UserFluig(c_Chave)
Local c_UsrFluig	:=	""
Local c_Qry			:=	""
Local c_AliasFl		:=	GetNextAlias()

Default c_Chave		:=	""

If !Empty(c_Chave)

	c_Qry	:=	"SELECT USER_CODE FROM fluigdb.dbo.FDN_USERTENANT WHERE LOGIN = '"+c_Chave+"'"
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_AliasFl, .T., .T.)
	(c_AliasFl)->(dbGoTop())
	If (c_AliasFl)->(!Eof())
		c_UsrFluig := (c_AliasFl)->USER_CODE 
	Endif
	(c_AliasFl)->(dbCloseArea())
Else
	msgInfo("Matricula nao cadastrada no fluig para o usuario "+c_Chave)

Endif	

Return(c_UsrFluig)


//-------------------------
//login do usuario protheus
/*
aUsers - Array com os usuários do sistema no seguinte formato:
[n][1] Id da tabela de usuários
[n][2] Id do usuário
[n][3] Login do Usuário
[n][4] Nome do usuário
[n][5] email do usuário
[n][6] departamento do usuário
[n][7] cargo do usuário
*/
//-------------------------
Static Function f_wsLogin(c_Login)
Local n_x
Local a_Allusers 	:= 	FWSFALLUSERS()
Local a_Login		:=	{}

Default c_Login		:=	""

If valtype(c_Login) == "C"

	For n_x := 1 To Len(a_Allusers)
	    If Alltrim(c_Login) == Alltrim(a_Allusers[n_x][3])
	    	a_Login	:=	a_Allusers[n_x]
	    	Exit
	    Endif
	Next

Else
	Conout("Id do usuario nao esta no formato correto para busca no protheus, favor passar o id do usuario no protheus.")

Endif

Return(a_Login)