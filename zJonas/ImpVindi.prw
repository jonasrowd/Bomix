#Include "Protheus.ch"
#Include "totvs.ch"

/*/{Protheus.doc} ImpVindi
Criação de tela para que o usuario possa selecionar se deseja importar cliente ou assinatura. 
@type function
@version  
@author Familia Kimura
@since 28/07/2021
@return variant, return_description
/*/
User Function ImpVindi()

Local oDlg1 // Variavel que receberá a chamada da classe TDialog
Local oTButton1 //Variavel que armazenará a classe do primeiro botão. 
Local oTButton2 //Variavel que armazenará a classe do segundo botão. 
Local oTButton3 //Variavel que armazenará a classe do terceiro botão
Local oTBitmap
Local cTituloJanela := "Importação Cliente / Assinatura VINDI"

oDlg1       := TDialog():New(180,180,500,650,cTituloJanela,,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oTBitmap    := TBitmap():New(0,0,500,650,,"C:\Temp\logo.bmp",.T.,oDlg1,{||Alert("Clique em TBitmap1")},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap:lAutoSize := .T.
oTButton1   := TButton():New( 55, 35,  "Integra Cliente"    ,oDlg1,{||EnviaCli()}, 50,20,,,.F.,.T.,.F.,,.F.,,,.F. ) // Chama tela de clientes
oTButton2   := TButton():New( 55, 150, "Integra Assinatura"  ,oDlg1,{||EnviaFat()}, 50,20,,,.F.,.T.,.F.,,.F.,,,.F. ) //Chama tela de fornecedores
oTButton3   := TButton():New( 120,90,  "Fechar"      ,oDlg1,{||oDlg1:End()}, 50,20,,,.F.,.T.,.F.,,.F.,,,.F. ) //Fecha a aplicação

oDlg1       :Activate(,,,.F.)  //Methodo que chama a tela TDialog

Return 

/*/{Protheus.doc} EnviaCli
Rotina que irá realizara importação dos clientes paraa VINDI com base em um arquivo TXT
@type function
@version  
@author Familia Kimura
@since 28/07/2021
@return variant, return_description
/*/
Static Function EnviaCli()

Local nHandle   
Local cArqAux
Local nCount    := 0

Local aDadosCli :={}

cArqAux := cGetFile( 'Arquivo TXT|*.txt| Arquivo CSV|*.csv',;     //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         ,;                                       //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)                                     //[ lArvore] 
     

nHandle := FT_FUse(cArqAux)// Abre o arquivo

// Se houver erro de abertura abandona processamento
    IF nHandle = -1
        MsgAlert("Arquivo inválido")
    ENDIF

FT_FGoTop()// Posiciona na primeria linha

nLast := FT_FLastRec()// Retorna o número de linhas do arquivo
MsgAlert( nLast )

WHILE !FT_FEOF()
    cLine     := FT_FReadLn()
    
    nRecno    := FT_FRecno() // Retorna a linha corrente
    
    //MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) ) // Retorna o recno da Linha
    aDadosCli := SEPARA(cLine, ';')
    //aDadosCli := STRTOKARR(cLine, ';' )
       
    //AADD(aClientes[1],aDadosCli)
    
      ClixVnd(aClone(aDadosCli)) //Chama rotina de integração de cliente VINDI
    nCount++
    FT_FSKIP() // Pula para próxima linha
ENDDO

// Fecha o Arquivo
FT_FUSE()
    Alert("A quantidade de clientes integrados foram" + str(nCount++) )
Return

Static Function ClixVnd(aClientes)

local aHeader   as array
local oRest     as object
local nStatus   as numeric
local cError    as char
local jBody
//Local nX        := 1
//Local lRet      := .T.

Private oJSON     as object

            aHeader := {}
            //oRest := FWRest():New("https://sandbox-app.vindi.com.br/") // URL de consumo do servico Restapi do cliente
            oRest := FWRest():New("https://app.vindi.com.br/") // URL de consumo do servico Restapi do cliente

            //Endpoint
            oRest:setPath("/api/v1/customers") // caminho de gravação dos dados. 

            //Cabeçalho de requisição
            //Aadd(aHeader, "Authorization: Basic " + Encode64("yxXamH9RMrSgRXjnQu2FnZNuv9xsuaVA6kJOy24kPcw:''"))
            Aadd(aHeader, "Authorization: Basic " + Encode64("OtqD4iks_nbwefQO4dd_oL_8nU8u8qW40nznGRirRjc:''"))
            Aadd(aHeader, "Content-Type: application/json")
            aAdd(aHeader,"Accept-Encoding: UTF-8")

            //Corpo para enviar os dados via requisição Json para gravar o cliente na VINDI
            
            jBody := JsonObject():New()
            jBody["name"]                                       := aClientes[1]
            jBody["email"]                                      := aClientes[2]
            jBody["registry_code"]                              := aClientes[3]
            //jBody["metadata"] := JsonObject():New()
            //jBody["metadata"]["_invoice_issuing_type"]          := "manual"
            jBody["address"] := JsonObject():New()
            jBody["address"]["street"]                          := aClientes[4]
            jBody["address"]["number"]                          := aClientes[5]
            jBody["address"]["neighborhood"]                    := aClientes[6]
            jBody["address"]["city"]                            := aClientes[7]
            jBody["address"]["zipcode"]                         := aClientes[8]
            jBody["address"]["state"]                           := aClientes[9]
            jBody["address"]["country"]                         := "BR"
      
            oRest:SetPostParams(jBody:toJson()) 
            oRest:SetChkStatus(.F.)

            IF oRest:Post(aHeader)
                FwJSONDeserialize(oREST:cResult, @oJSON)
                cError  := ""
                nStatus := HTTPGetStatus(@cError)   

                IF nStatus >= 200 .And. nStatus <= 299
                    IF Empty(oRest:getResult())
                        //MsgInfo(nStatus)
                    ELSE
                        GrvCli(aClientes)
                        //MsgInfo(oRest:getResult())
                    ENDIF
                ELSE
                    //MsgStop(cError)
                ENDIF
            ENDIF
Return

/*/{Protheus.doc} GrvCli
Apos a confirmação da gravação do cliente na Vindi, pega o retorno do ID e grava no cadastro do cliente
para que possa ser usado este ID no envio da assinatura e também grava no cliente se já foi integrado com a VINDI
@type function
@1.0  
@author Familia Kimura
@since 17/06/2021
@return return_type, return_description
/*/
Static Function GrvCli(aClientes)
Local lRet      := .T.
Local oCliente  as object

oCliente    := oJson:CUSTOMER // Criado o objeto oCliente para para receber o array da variavel Privada oJson. 

DbSelectArea("SA1")
SA1->(DbSetOrder(3))

IF SA1->(DbSeek(xFilial("SA1")+aClientes[3])) //Verifica se o cliente em questão existe. 
    lRet := .T.
    Reclock("SA1",.F.)
        SA1->A1_XINTVND := "1" //grava se o cliente foi integrado ou não. 
        SA1->A1_XID     := oCliente:ID // Grava o ID que a VINDI retornou apos a gravação do cliente. 
    SA1->(MsUnlock())
    ELSE
    lRet :=.F.
ENDIF

Return lRet

/*/{Protheus.doc} EnviaFat
Rotina que irá realizar o envio da assinaturaa VINDI através de um arquivo TXT
@type function
@version  
@author Familia Kimura
@since 28/07/2021
@return variant, return_description
/*/
Static Function EnviaFat()

Local nHandle   
Local cArqAux
Local aDadosFat := {}
Local nCount    := 0


cArqAux := cGetFile( 'Arquivo TXT|*.txt| Arquivo CSV|*.csv',;     //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         ,;                                       //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)                                     //[ lArvore] 
     

nHandle := FT_FUse(cArqAux)// Abre o arquivo

// Se houver erro de abertura abandona processamento
    IF nHandle = -1
        MsgAlert("Arquivo inválido")
    ENDIF

FT_FGoTop()// Posiciona na primeria linha

nLast := FT_FLastRec()// Retorna o número de linhas do arquivo
MsgAlert( nLast )

WHILE !FT_FEOF()
    cLine  := FT_FReadLn()
    
    nRecno := FT_FRecno()// Retorna a linha corrente
    
    //MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) )// Retorna o recno da Linha

        aDadosFat  := SEPARA(cLine, ';')
    //aDadosFat  := STRTOKARR(cLine, ';')
    
    //AADD( aFatura, aDadosFat)
        FatxVnd(aDadosFat) //Chama a rotina de integração Assinatura VINDI
    nCount++

FT_FSKIP()// Pula para próxima linha
END
Alert("Quantidade de Assinaturas importadas foram: "+ str(nCount++) )
// Fecha o Arquivo
FT_FUSE()
 
Return 

Static Function FatxVnd(aFatura)

local aHeader   as array
local oRest     as object
local nStatus   as numeric
local cError    as char
Local jBody     as object
Local aArea     := GetArea()
Local lRet      := .T.
local oProduct  as object

   
Private oJsonAss   

aHeader := {}
//oRest := FWRest():New("https://sandbox-app.vindi.com.br/") // URL de consumo do servico Restapi do cliente
oRest := FWRest():New("https://app.vindi.com.br/") // URL de consumo do servico Restapi do cliente

//Endpoint
oRest:setPath("/api/v1/subscriptions") // caminho de gravação dos dados. 

//Cabeçalho de requisição
//Aadd(aHeader, "Authorization: Basic " + Encode64("yxXamH9RMrSgRXjnQu2FnZNuv9xsuaVA6kJOy24kPcw:''"))
Aadd(aHeader, "Authorization: Basic " + Encode64("OtqD4iks_nbwefQO4dd_oL_8nU8u8qW40nznGRirRjc:''"))
Aadd(aHeader, "Content-Type: application/json")
aAdd(aHeader,"Accept-Encoding: UTF-8")

DbSelectArea("SA1")
SA1->(DbSetOrder(3))

        //Monta a estrutura  Json para enviar os dados para criar a Assinatura.
        //aAdd(ajBody,JsonObject():New()) 
        jBody := JsonObject():New() //Cria o objeto Json
        jBody["plan_id"]                                                    := aFatura[1]
        jBody["customer_id"]                                                := Posicione("SA1",3,xFilial("SA1")+aFatura[2],'A1_XID')
        jBody["payment_method_code"]                                        := IF(aFatura[3]=="BOL","online_bank_slip",IF(ALLTRIM(aFatura[3])=="CC","credit_card",0))
        jBody['metadata']:= JsonObject():New()
        jBody['metadata']["mes_aniversario"]                                := aFatura[6]
     
        jBody['product_items']  := {}
        oProduct := JSonObject():New()
        oProduct['product_id']                               := aFatura[4] //"154140"
        Product['pricing_schema']  := JSonObject():New() //Cria o objeto product_items
        oProduct['pricing_schema']['price']                   := aFatura[5]
        aadd(jBody['product_items'] , oProduct) 

        conout(jBody:toJson())
                             
        oRest:SetPostParams(jBody:toJson()) 
        oRest:SetChkStatus(.F.)
    
    IF oRest:Post(aHeader)
        FwJSONDeserialize(oREST:cResult, @oJsonAss)
        cError  := ""
        nStatus := HTTPGetStatus(@cError)   

        IF nStatus >= 200 .And. nStatus <= 299

        IF Empty(oRest:getResult())
                //MsgInfo(nStatus)
                lRet := .F.
            ELSE
                //MsgInfo(oRest:getResult())
                lRet := .T.
            ENDIF
        ELSE
            //MsgStop(cError)
        ENDIF
    ENDIF
RestArea(aArea) 

Return lRet

