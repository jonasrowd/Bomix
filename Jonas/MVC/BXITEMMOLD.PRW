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
    @return, oModel, objeto da função mvc meu modelo de dados.
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/public/PROT/FWFormModel
    @see https://tdn.totvs.com/display/public/PROT/MPFormModel
/*/
Static Function ModelDef()

Local aKey := {"ZN_FILIAL, ZN_ORDEM, ZN_GRUPO, ZN_ITEM"}
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
Return

Static Function MenuDef()
Return
