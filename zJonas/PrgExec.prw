#Include 'Totvs.ch'

/*/{Protheus.doc} PrgExec
    Busca a função compilada no rpo e executa.
    @type Function
    @author Jonas Machado
    @since 03/08/2021
    @version 12.1.27
/*/
User Function PrgExec()

    Local oSay      := Nil
    Local oGet      := Nil
    Local oBtn1     := Nil
    Local oBtn2     := Nil
    Local oMsDialog := Nil
    Local aFonte    := {}  //Array que irá armazenar os dados da função retornada pelo GetApoInfo()
    Local cGet      := PadR('Ex.: u_NomeFuncao() ', 50)

    oMsDialog := MSDialog():New(180,180,550,700,'Executa Fontes',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    oSay      := TSay():New( 008 ,008 ,{ || 'Digite aqui o nome do programa' } ,oMsDialog ,,,.F. ,.F. ,.F. ,.T. ,CLR_BLACK ,CLR_WHITE ,084 ,008 )
    oGet      := TGet():New( 020 ,008 ,{ | u | If( PCount() == 0 ,cGet ,cGet := u ) } ,oMsDialog ,150 ,008 ,'!@',,CLR_BLACK ,CLR_WHITE ,,,,.T. ,'' ,,,.F. ,.F. ,,.F. ,.F. ,'' ,'cGet' ,,)
    oBtn1     := TButton():New( 040 ,008 ,'Executar' ,oMsDialog ,{ || &(cGet)    } ,037 ,012 ,,,,.T. ,,'' ,,,,.F. )
    oBtn2     := TButton():New( 040 ,120 ,'Sair'     ,oMsDialog ,{ || oMsDialog:End() } ,037 ,012 ,,,,.T. ,,'' ,,,,.F. )

    cGet   := StrTran( cGet , 'U_' , '' ) //Caso o usuário digite o U_ ou () no nome do fonte, retira esses caracteres
    cGet   := StrTran( cGet , '()' , '' ) 
    aFonte := GetApoInfo( cGet + '.prw' )     //Valida se o fonte existe no rpo
    cGet   := 'U_' + cGet + '()' //complementa a variável

    If !Len(aFonte) //Valida se retornou os dados do fonte do rpo
        MsgAlert( DecodeUtf8( 'Fonte não compilado no seu RPO.' ) , 'Atenção!' )
    EndIf

oMsDialog:Activate( ,,,.T.)

Return
