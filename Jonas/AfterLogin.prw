#Include "TOTVS.ch"
/*/{Protheus.doc} AfterLogin
    Este ponto de entrada È executado apÛs a abertura das Sxs. 
    Ao acessar pelo SIGAMDI, este ponto de entrada È chamado ao entrar na rotina.
    Pelo SIGAADV, a abertura das Sxs È executado apÛs o login.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 28/07/2021
/*/
User Function AfterLogin()

// Local cId       := ParamIXB[1]
// Local cNome     := ParamIXB[2]


SetKey(VK_F8, {|| U_ExecMyFunc()})


//ApMsgAlert("Usuùrio "+ cId + " - " + Alltrim(cNome)+" efetuou login ùs "+Time())



Return Nil
