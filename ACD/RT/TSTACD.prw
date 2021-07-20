#Include "Totvs.ch"

/*/{Protheus.doc} TSTACD
    Teste
    @type function
    @version 12.1.25
    @author jonas.machado
    @since 20/07/2021
    @return variant, null
/*/
User Function TSTACD()
        
    VTAlert("Funcao de Usuario","Aviso",.T.)
    DLAviso(.F., 'DLGXFUN03', "Funcao de Usuario") //'Produto '###' nao cadastrado nos Dados Adicionais do Produto (SB5).'
    DLXGrvEnd("T03A00016","CDR01","E2","999999993","1",,"000018","000002",100,"FD",,,,,"3")

Return()
