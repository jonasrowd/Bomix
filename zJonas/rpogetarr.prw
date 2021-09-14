#Include 'Totvs.ch'

user function RREPORT()
    Local cModulo     := 'SIGAADV' //Defino em qual módulo irei abrir a minha função
    MsApp():New(cModulo) //
    oApp:cInternet := NIL     
    oApp:CreateEnv()
    PtSetTheme("OCEAN")
    oApp:cStartProg        := 'U_XRREPORT'
    oApp:lMessageBar    := .T. 
    oApp:cModDesc        := cModulo
    __lInternet         := .T.
    lMsFinalAuto         := .F.
    oApp:lMessageBar    := .T. 
    oApp:Activate()
Return
