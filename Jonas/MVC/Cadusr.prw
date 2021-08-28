//Bibliotecas Necess�rias
#Include 'Totvs.ch'
#Include 'FwMvcDef.ch'

/*/{Protheus.doc} Cadusr
    Fornece um objeto do tipo grid, bot�es laterais e detalhes das colunas baseado no dicion�rio de dados.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 04/08/2021
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
/*/
User Function Cadusr()

Local aArea := GetNextAlias()
Local oBrowse   //Declara o objeto que receber� a classe FwmBrowse

oBrowse := FwmBrowse():New() //Instancio a classe no objeto
oBrowse:SetAlias('Z05') //Passo como par�metro a tabela que eu quero mostrar no Browse
oBrowse:SetDescription('Cadastro de Produto para Perda') //T�tulo da tela

//oBrowse:SetOnlyFields({"Z05_FILIAL", "Z05_CODIGO", "Z05_NOME, Z05"})

oBrowse:AddLegend("Z05->Z05_PERDA == 'S'","GREEN", "Perda Ativdada.")
oBrowse:AddLegend("Z05->Z05_PERDA == 'N'","RED", "Perda Inativa.")

//oBrowse:SetFilterDefault("Z05->Z05_PERDA == 'S'") Cria um filtro padr�o por programa��o. N�o pode ser desmarcado.
oBrowse:DisableDetails()
oBrowse:Activate()

RestArea(aArea)

Return

Static Function MenuDef()
Return

Static Function ModelDef()
Return

Static Function ViewDef()
Return
