//Includes necessários
#Include "Totvs.ch"
#Include "Tbiconn.ch"

/*/{Protheus.doc} MTA650I
    Ponto de entrada executado após a inclusão das Op's
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 30/09/2021
/*/
User Function MTA650I()

    TCSPEXEC("BOMIXBI.dbo.Pcp_SP_AtualizarBase_ProdutoEmpenho_DefinirNomesDoProdutosDoEmpenho_E_SeusTipos")

Return Nil
