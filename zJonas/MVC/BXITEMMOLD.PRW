//Bibliotecas Necessárias
#Include 'Totvs.ch'
#Include 'Fwmvcdef.ch'

/*/{Protheus.doc} BXITEMMOLD
    Programa que realiza manutenção das especificações dos produtos para o setor de Qualidade.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 02/09/2021
/*/
User Function BXITEMMOLD()

Local aArea := GetNextAlias()
Local oBrowse   //Declara o objeto que receberá a classe FwmBrowse

oBrowse := FwmBrowse():New() //Instancio a classe no objeto
oBrowse:SetAlias('SZN') //Passo como parâmetro a tabela que eu quero mostrar no Browse
oBrowse:SetDescription('Cadastro de Produto Item/Molde') //Título da tela

//Organiza os campos na tela
//oBrowse:SetOnlyFields({"Z05_FILIAL", "Z05_CODIGO", "Z05_NOME, Z05"})

//Adiciona Legenda personalizada na tela
//oBrowse:AddLegend("CONDICAO","COR", "DESCRICAO DA LEGENDA.")
//oBrowse:AddLegend("SZN->D_E_L_E_T_ != '*'","RED", "PROPRIEDADE INATIVA.")

//Cria um filtro padrão por programação. Não pode ser desmarcado.
//oBrowse:SetFilterDefault("Z05->Z05_PERDA == 'S'") 

//Desabilita a tela de detalhes embaixo do programa.
oBrowse:DisableDetails()
oBrowse:Activate()

RestArea(aArea)

Return Nil

/*/{Protheus.doc} ModelDef
    Minha Model
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 02/09/2021
    @return object, retorna o oModel oModel para ser utilizado em outros programas
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/public/PROT/FWFormModel
    @see https://tdn.totvs.com/display/public/PROT/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWLoadModel
    @see https://tdn.totvs.com/display/framework/FWFormView
/*/
Static Function ModelDef()

Local aKey := {"ZN_FILIA, ZN_MEDIDA, ZN_GRUPO"}
Local oModel := NIL //objeto que irá armazenas os métodos da minha modeldef
Local oStructSzn := FwFormStruct(1,"SZN") //Traz a estrutura da tabela, caracteristicas e campos para o modelo, por isso o parâmetro 1.

//MPFormModel é Herança da Classe FwFormModel que facilita o desenvolvimento em Mvc
oModel := MPFormModel():New("ModelSZN", /* < bPre >*/,/* < bPost >*/, /*< bCommit >*/,/* < bCancel >*/)

//Atribuindo formulário para o modelo de dados.
oModel:AddFields("FormsSZN",/*Ownder*/,oStructSzn)

//Definição da chave primária que só será ignorada se houver x2_unico para esta tabela
oModel:SetPrimaryKey({aKey})

//Insere uma descrição para o modelo de dados
oModel:SetDescription("Modelo de dados utilizado para manipulas as especificações dos produtos Bomix.")

//Traz o modelo selecionado no aFields
oModel:GetModel("FormsSZN"):SetDescription("Modelo de dados utilizado para manipulas as especificações dos produtos Bomix.")

Return oModel

Static Function ViewDef()

Local oView := Nil
Local oModel := FwLoadModel("BXITEMMOLD") //Função que retorna um objeto de model de determinado fonte ou função.
Local oStructSzn := FwFormStruct(2,"SZN") //Traz a estrutura da tabela, caracteristicas e campos para a view, por isso o parâmetro 2

//Constrói a visão dos dados
oView := FwFormView():New()

//Atribuição da estrutura de dados da visão
oView:AddField("ViewSZN",oStructSzn,"FormsSZN")

//Cria um contâiner de tela
oView:createHorizontalBox("TelaSzn",100)

oView:EnableTitleView("ViewSZN", "Visualização da Tela.")

//Força o fechamento da janela passando o parâmetro True. É possível adicionar vários blocos de código.
oView:SetCloseOnOk({||.T.})

oView:SetOwnerView("ViewSZN","TelaSzn")

Return oView


/*/{Protheus.doc} MenuDef
Função que cria as funcionalidades do Menu
@type function
@version 12.1.25
@author Jonas Machado
@since 03/09/2021
@return array, aRotina com as opções do Menu.
/*/
Static Function MenuDef()

Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.BXITEMMOLD' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.BXITEMMOLD' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.BXITEMMOLD' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.BXITEMMOLD' OPERATION 5 ACCESS 0

/*
1 - PESQUISAR
2 - VISUALIZAR
3 - INCLUIR
4 - ALTERAR
5 - EXCLUIR
6 - COPIAR
*/

Return aRotina
