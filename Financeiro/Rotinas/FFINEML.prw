#INCLUDE "Protheus.ch" 
#INCLUDE "topconn.ch"

User Function FFINEML()

 
 RPCSetEnv("01" , "01",,,"FIN",,,,,,)
    
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
        _LojaTemp := TABEA->EA_LOJA
        _TitTemp := TABEA->EA_NUM
        _ParTemp := TABEA->EA_PARCELA 
        

        cQ2  := " SELECT EA_LOCPDF, EA.R_E_C_N_O_ "  //-- Consulta Filtrando por Cliente
        cQ2  := " FROM " + RetSQLName("SEA") + " EA "
        cQ2  := " INNER JOIN " + RetSQLName("SE1") + " E1 "
        cQ2  := " ON EA.EA_FILIAL = '"+xFilial("SE1")+"'"
        cQ2  := " AND EA.EA_NUM = E1.E1_NUM " 
        cQ2  := " AND EA.EA_PARCELA = E1.E1_PARCELA " 
        cQ2  := " AND EA.EA_NUMBOR = E1.E1_NUMBOR "  
        cQ2  := " AND E1.D_E_L_E_T_ = ' ' "
        cQ2  := " WHERE EA.D_E_L_E_T_ = ' ' " 
        cQ2  := " AND EA.EA_LOCPDF  <> '' "  
        cQ2  := " AND EA.EA_ENVIADO = '' "
        cQ2  := " AND EA.EA_BOMCLI = '"+ _CliTemp +"'	
        cQ2  := " AND EA.EA_LOJA = '"+ _LojaTemp +"'
        cQ2  := " AND EA.EA_NUM = '"+ _TitTemp +"'
        cQ2  := " AND EA.EA_PARCELA = '"+ _ParTemp +"'
        cQ2  := " AND EA.EA_CART = 'R' "
    	TCQUERY cQ2 New Alias "TABEB" 
	
	    DBSELECTAREA("TABEB")
	    DBGOTOP()
        
        _Flag := .F.
        aAnexos := {}
        
        RPCSetType(3)
        RpcSetEnv( SEA->EA_FILIAL )
        
        DbSelectArea("SE1")
        DbSetOrder(1)
        While !Eof()       	

             _Rec := 0
             _Rec := TABEB->R_E_C_N_O_

            _Email  := POSICIONE("SA1", 1, xFilial("SA1") + _CliTemp, "A1_EMFAT")
            _Nome1  := POSICIONE("SA1", 1, xFilial("SA1") + _CliTemp, AllTrim(SA1->A1_NOME))
            _CGCCl  := POSICIONE("SA1", 1, xFilial("SA1") + _CliTemp, Subs(SA1->A1_CGC,1,2)+"."+Subs(SA1->A1_CGC,3,3)+"."+Subs(SA1->A1_CGC,6,3)+" / "+Subs(SA1->A1_CGC,9,4)+" - "+Subs(SA1->A1_CGC,13,2))
            _Flag   := .T.
            _ChvCli := POSICIONE("SE1", 1, xFilial("SE1") + _CliTemp, "E1_CLIENTE")  
            _ChvLoj := POSICIONE("SE1", 1, xFilial("SE1") + _LojaTemp, "E1_LOJA") 
            _ChvNum := POSICIONE("SE1", 1, xFilial("SE1") + _TitTemp, "E1_NUM")   
            _ChvPar := POSICIONE("SE1", 1, xFilial("SE1") + _ParTemp, "E1_PARCELA") 
            _cSubj	:= OemToAnsi('BOMIX - Boleto para Pagamento - ')+ _ChvNum	//Assunto 
            _cMsg	:= NIL			//Corpo da Mensagem
                 

            aAdd(aAnexos, TABEB->EA_LOCPDF)
 
            cQRY := " UPDATE SEA010 SET EA_ENVIADO = 'S' WHERE R_E_C_N_O_ = "+AllTrim(Str(_Rec))   
            TCSQLExec(cQRY) 
            
        	DBSELECTAREA("TABEB")	
        	Dbskip(1)        
        End

       	DBSELECTAREA("TABEB")	
       	DBCLOSEAREA()	

        If _Flag //-- Envia o Email
           u_zEnvMail(_Email, _cSubj, _cMsg, aAnexos)
        Endif

	    DBSELECTAREA("TABEA")	
		Dbskip(1)
	End
	
	DBSELECTAREA("TABEA")
	DBCLOSEAREA()
	
	
Return


User Function zEnvMail(cPara, _cSubj, _cMsg, aAnexos, lMostraLog, lUsaTLS)
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
    Default aAnexos    := {}
    Default lMostraLog := .F.
    Default lUsaTLS    := .F.
 
    //Se tiver em branco o destinatário, o assunto ou o corpo do email
   /* If Empty(cPara) .Or. Empty(cAssunto) .Or. Empty(cCorpo)
        cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
        lRet := .F.
    EndIf */
 
    If lRet
        //Cria a nova mensagem
        oMsg := TMailMessage():New()
        oMsg:Clear()
 
        //Define os atributos da mensagem
        oMsg:cFrom    := cFrom
        oMsg:cTo      := cPara
        oMsg:cSubject := _cSubj
        oMsg:cBody    := _cMsg
        
    cQ  := " SELECT  convert(varchar, cast(E1_EMISSAO as date), 103) AS EMISSAO, E1_NUM AS NOTA,IIF( E1_PARCELA = '', 'UNICA', E1_PARCELA ) AS PARCELA, convert(varchar, cast(E1_VENCTO as date), 103) AS VENCIMENTO,E1_VALOR AS VALOR "
	cQ  += " FROM " + RetSQLName("SE1")
	cQ  += " WHERE D_E_L_E_T_ = ' ' "
	cQ  += " AND E1_SERIE   = '"+_ChvSer+"'
	cQ  += " AND E1_NUM     = '"+_ChvNum+"'
	cQ  += " AND E1_PARCELA = '"+_ChvPar+"'
	cQ  += " AND E1_CLIENTE = '"+_ChvCli+"'
	cQ  += " AND E1_LOJA = '"+_ChvLoj+"'
	cQ  += " ORDER BY E1_EMISSAO "  

	TCQUERY cQ New Alias "TABTR" 
	
	DBSELECTAREA("TABTR")
	DBGOTOP() 
				

//IF _cMsg == NIL
WHILE TABTR->(!EOF()) 

	_cMsg := '<html>' 
	_cMsg += '<body>' 
	_cMsg += '<font face="arial" size="2"><p><b>Prezado Cliente</b><br>' 
	_cMsg += '<font face="arial" size="2"><p><b>Razão Social: </b>'+ _Nome1+'<br>' 
	_cMsg += '<font face="arial" size="2"><p><b>CNPJ/CPF: </b>'+ _CGCCl+'<br>' 
	_cMsg += '<font face="arial" size="2"><p> <br>' 
	_cMsg += '<b>Segue em anexo o boleto do titulo abaixo:</b><br>'
	_cMsg += '<TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#F0FFFF background="" '
    _cMsg += 'border=1>'
	_cMsg += '<TBODY>'
    _cMsg +=  "<TR><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Data Emissão'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Nota Fiscal'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Parcela'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Vencimento'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Valor'+"</B></TD>"
    _cMsg +=  "<TR><TD style=text-align:center>"+AllTrim(TABTR->EMISSAO)+"</TD><TD style=text-align:center>"+AllTrim(TABTR->NOTA)+"</TD><TD style=text-align:center>"+AllTrim(TABTR->PARCELA)+"</TD><TD style=text-align:center>"+AllTrim(TABTR->VENCIMENTO)+"</TD><TD style=text-align:center>"+TRANSFORM(TABTR->VALOR, "@E 99,999,999.99")+"</TD>"     
	_cMsg += '</TBODY></TABLE>'
	_cMsg += '<font face="arial" size="2"><p> <br>' 
	_cMsg += '<font face="arial" size="2"><p> <br>' 
	_cMsg += '<b>ATENÇÃO - Este e-mail foi disparado automaticamente pelo nosso sistema, favor não responder.</b><br>' 
	_cMsg += 'Caso não tenha recebido o boleto bancário, favor entrar em contato, através do e-mail creditocobranca@bomix.com.br, ou através do telefone abaixo:<br>' 
    _cMsg += '+55 (71) 3215-8600 - Falar com Setor Financeiro<br>' 
	_cMsg += '<font face="arial" size="2"><p> <br>' 
	_cMsg += 'Atenciosamente,<br>' 
	_cMsg += '<font face="arial" size="2"><p><b>BOMIX INDUSTRIA DE EMBALAGENS LTDA</b><br>' 
	_cMsg += '<font face="arial" size="2"><p><b>CNPJ: 01.561.279 / 0001 - 45</b><br>'	
	_cMsg += '</font>' 
	_cMsg += '</body></html>' 
	
//ENDIF

   TABTR->(dbSkip())
			
ENDDO
	
	TABTR->(DBCLOSEAREA())
        
 
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
        cLog := "zEnvMail - "+dToC(Date())+ " " + Time() + CRLF + ;
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