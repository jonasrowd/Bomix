#Include "Totvs.ch"
/*/{Protheus.doc} AfterLogin
    Este ponto de entrada é executado após a abertura das Sxs. 
    Ao acessar pelo SIGAMDI, este ponto de entrada é chamado ao entrar na rotina.
    Pelo SIGAADV, a abertura das Sxs é executado após o login.
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 28/07/2021
/*/
User Function AfterLogin()

    SetKey(VK_F8, {|| U_EXECFONTE()})

Return Nil
