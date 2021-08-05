//Bibliotecas Necess�rias
#Include 'Totvs.ch'

/*/{Protheus.doc} Cadusr
    Fornece um objeto do tipo grid, bot�es laterais e detalhes das colunas baseado no dicion�rio de dados.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 04/08/2021
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
/*/
User Function Cadusr()

Local oBrowse   //Declara o objeto que receber� a classe FwmBrowse

oBrowse := FwmBrowse():New() //Instancio a classe no objeto
oBrowse:SetAlias('SZT') //Passo como par�metro a tabela que eu quero mostrar no Browse
oBrowse:SetDescription('Cadastro Gen�rico') //T�tulo da tela
oBrowse:Activate()

Return

Static Function MenuDef()
Return

Static Function ModelDef()
Return

Static Function ViewDef()
Return
