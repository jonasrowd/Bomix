#Include "Totvs.ch"

/*/{Protheus.doc} MTA103OK
   Ponto de entrada na Inclusão do documento de entrada.
   @type function
   @version 12.1.25
   @author Jonas Machado
   @since 02/08/2021
   @return variant, lRet Logical
/*/
User Function MTA103OK()

    Local lRet := .T.
    Local CHAVE := M->F1_CHVNFE

    If CHAVE = ""
        Help(NIL, NIL, "DOC_BLOCKED", NIL, "Tipo Nota Fiscal = SPED, sem a chave da Nota Fiscal, inclusao nao permitida !!!",;
            1, 0, NIL, NIL, NIL, NIL, NIL, {"Digite a chave da nota."})
        lRet  := .F.
    EndIf

    If M->D1_RATEIO == 1
        lRet := .T.
    ElseIf M->D1_RATEIO ==2
        !Empty(M->D1_CC)
        lRet := .F.
        Help(NIL, NIL, "DOC_BLOCKED", NIL, "Não é possível gravar o documento de entrada sem o campo Centro de Custo preenchido.",;
            1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o centro de custo."})
    EndIf

Return lRet
