#INCLUDE "Protheus.ch" 
#INCLUDE "topconn.ch"

User function FINEMAL()

RPCSetEnv("01" , "02",,,"FIN",,,,,,)
    
	cQ1  := " SELECT DISTINCT(EA_BOMCLI) "  //-- Agupa Clientes 
	cQ1  += " FROM " + RetSQLName("SEA")
	cQ1  += " WHERE D_E_L_E_T_ = ' ' "
	cQ1  += " AND EA_LOCPDF  <>''  "
	cQ1  += " AND EA_ENVIADO = '' "
	cQ1  += " AND EA_CART = 'R' "
	cQ1  += " ORDER BY EA_BOMCLI "  

	TCQUERY cQ1 New Alias "TABEA" 
	
	DBSELECTAREA("TABEA")
	DBGOTOP()
	
	While !Eof()

        _CliTemp := TABEA->EA_BOMCLI

        cQ2  := " SELECT EA_LOCPDF, R_E_C_N_O_ "  //-- Consulta Filtrando por Cliente 
        cQ2  += " FROM " + RetSQLName("SEA")
        cQ2  += " WHERE D_E_L_E_T_ = ' ' "
        cQ2  += " AND EA_LOCPDF  <>''  "
        cQ2  += " AND EA_ENVIADO = '' "	
        cQ2  += " AND EA_BOMCLI = '"+ _CliTemp +"'	
        cQ2  += " AND EA_CART = 'R' "
    	TCQUERY cQ2 New Alias "TABEB" 
	
	    DBSELECTAREA("TABEB")
	    DBGOTOP()
        
        _Flag := .F.
        aAnexos := {}
        
        RPCSetType(3)
        RpcSetEnv( SEA->EA_FILIAL )
        
        While !Eof()       	

             _Rec := 0
             _Rec := TABEB->R_E_C_N_O_

            _Email := POSICIONE("SA1", 1, xFilial("SA1") + _CliTemp, "A1_EMFAT")
            _Flag := .T.

            aAdd(aAnexos, TABEB->EA_LOCPDF)
 
            cQRY := " UPDATE SEA010 SET EA_ENVIADO = 'S' WHERE R_E_C_N_O_ = "+AllTrim(Str(_Rec))   
            TCSQLExec(cQRY) 
            
        	DBSELECTAREA("TABEB")	
        	Dbskip(1)        
        End

       	DBSELECTAREA("TABEB")	
       	DBCLOSEAREA()	

        If _Flag //-- Envia o Email
           u_EnvEmail(_Email, "Boleto via Email", "Seguem os Boletos via Email", aAnexos)
        Endif

	    DBSELECTAREA("TABEA")	
		Dbskip(1)
	End
	
	DBSELECTAREA("TABEA")
	DBCLOSEAREA()
	
	
Return


User Function EnvEmail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
    Local aArea        := GetArea()
    Local nAtual       := 0
    Local lRet         := .T.
    Local oMsg         := Nil
    Local oSrv         := Nil
    Local nRet         := 0
    Local cFrom        := Alltrim(GetMV("BM_BOLMAIL"))
    Local cUser        := SubStr(cFrom, 1, At('@', cFrom)-1)
    Local cPass        := Alltrim(GetMV("BM_BOLSNH"))
    Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
    Local cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
    Local nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
    Local nTimeOut     := GetMV("MV_RELTIME")
    Local cLog         := ""
    Default cPara      := ""
    Default cAssunto   := ""
    Default cCorpo     := ""
    Default aAnexos    := {}
    Default lMostraLog := .F.
    Default lUsaTLS    := .F.
 
    //Se tiver em branco o destinatário, o assunto ou o corpo do email
    If Empty(cPara) .Or. Empty(cAssunto) .Or. Empty(cCorpo)
        cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
        lRet := .F.
    EndIf
 
    If lRet
        //Cria a nova mensagem
        oMsg := TMailMessage():New()
        oMsg:Clear()
 
        //Define os atributos da mensagem
        oMsg:cFrom    := cFrom
        oMsg:cTo      := cPara
        oMsg:cSubject := cAssunto
        oMsg:cBody    := cCorpo
 
        //Percorre os anexos
        For nAtual := 1 To Len(aAnexos)
            //Se o arquivo existir
            If File(aAnexos[nAtual])
 
                //Anexa o arquivo na mensagem de e-Mail
                nRet := oMsg:AttachFile(aAnexos[nAtual])
                If nRet < 0
                    cLog += "002 - Nao foi possivel anexar o arquivo '"+aAnexos[nAtual]+"'!" + CRLF
                EndIf
 
            //Senao, acrescenta no log
            Else
                cLog += "003 - Arquivo '"+aAnexos[nAtual]+"' nao encontrado!" + CRLF
            EndIf
        Next
 
        //Cria servidor para disparo do e-Mail
        oSrv := tMailManager():New()
 
        //Define se irá utilizar o TLS
        If lUsaTLS
            oSrv:SetUseTLS(.T.)
        EndIf
 
        //Inicializa conexão
        nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
        If nRet != 0
            cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
            lRet := .F.
        EndIf
 
        If lRet
            //Define o time out
            nRet := oSrv:SetSMTPTimeout(nTimeOut)
            If nRet != 0
                cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
            EndIf
 
            //Conecta no servidor
            nRet := oSrv:SMTPConnect()
            If nRet <> 0
                cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                lRet := .F.
            EndIf
 
            If lRet
                //Realiza a autenticação do usuário e senha
                nRet := oSrv:SmtpAuth(cFrom, cPass)
                If nRet <> 0
                    cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                    lRet := .F.
                EndIf
 
                If lRet
                    //Envia a mensagem
                    nRet := oMsg:Send(oSrv)
                    If nRet <> 0
                        cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
                        lRet := .F.
                    EndIf
                EndIf
 
                //Disconecta do servidor
                nRet := oSrv:SMTPDisconnect()
                If nRet <> 0
                    cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                EndIf
            EndIf
        EndIf
    EndIf
 
    //Se tiver log de avisos/erros
    If !Empty(cLog)
        cLog := "EnvEmail - "+dToC(Date())+ " " + Time() + CRLF + ;
            "Funcao - " + FunName() + CRLF + CRLF +;
            "Existem mensagens de aviso: "+ CRLF +;
            cLog
        ConOut(cLog)
 
        //Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
        If lMostraLog .And. ! IsBlind()
            Aviso("Log", cLog, {"Ok"}, 2)
        EndIf
    EndIf
     
    RestArea(aArea)
Return lRet