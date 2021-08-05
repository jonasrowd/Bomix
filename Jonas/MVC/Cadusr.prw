//Bibliotecas Necessárias
#Include 'Totvs.ch'

/*/{Protheus.doc} Cadusr
    Fornece um objeto do tipo grid, botões laterais e detalhes das colunas baseado no dicionário de dados.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 04/08/2021
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
/*/
User Function Cadusr()

Local oBrowse   //Declara o objeto que receberá a classe FwmBrowse

oBrowse := FwmBrowse():New() //Instancio a classe no objeto
oBrowse:SetAlias('SZT') //Passo como parâmetro a tabela que eu quero mostrar no Browse
oBrowse:SetDescription('Cadastro Genérico') //Título da tela
oBrowse:Activate()

Return

Static Function MenuDef()
Return

Static Function ModelDef()
Return

Static Function ViewDef()
Return
