#Include 'Totvs.ch'

/*/{Protheus.doc} ExecFonte
    Busca a fun��o compilada no rpo e executa.
    @type Function
    @author Augusto
    @since 04/06/2020
    @version 12.1.27
/*/

User Function ExecFonte()

    Local cNomeFonte    := ""  //vari�vel que ir� receber o nome do fonte digitado 
    Local aFonte        := {}  //Array que ir� armazenar os dados da fun��o retornada pelo GetApoInfo()
    Local aPergs        := {}  //Array que armazena as perguntas do ParamBox()

//adiciona elementos no array de perguntas 
    aAdd( aPergs , {1, "Nome do fonte ", space(10), "", "", "", "", 40, .T.} ) 
 
//If que valida o OK do ParamBox() e passa o conte�do do par�metro para a vari�vel
    If ParamBox(aPergs, "DIGITAR NOME DO ARQUIVO .PRW" )
        cNomeFonte := ALLTRIM( MV_PAR01 )
    Else
        RETURN
    ENDIf

//Caso o usu�rio digite o U_ ou () no nome do fonte, retira esses caracteres
    cNomeFonte := StrTran( cNomeFonte , "U_" , "" )
    cNomeFonte := StrTran( cNomeFonte , "()" , "" )
//Valida se o fonte existe no rpo
   aFonte := GETAPOINFO( cNomeFonte + ".prw" )

//Valida se retornou os dados do fonte do rpo
    If !LEN( aFonte )
        MsgAlert( DECODEUTF8( "Fonte não encontrado no RPO" ) , "ops!" )
        RETURN u_ExecFonte()
    ENDIf

//complementa a variavel e executa macro substitui��o chamando a rotina
    cNomeFonte := "U_"+cNomefonte+"()"
    &cNomeFonte

RETURN
