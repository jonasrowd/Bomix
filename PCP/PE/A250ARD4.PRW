#Include "Totvs.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} A250ARD4
    Não grava perda de itens específicos com base na tabela Z05 campo Z05_NOME = B1_BRTPPR
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 19/07/2021
    @return variant, Retorna os produtos que possuem perda.
/*/
User Function A250ARD4()
    Local nX := 0
    Local xRotAuto := {}
    Local aRefugos := {}
    Private cQtdProd    := 0
    Private aSd4        := PARAMIXB
    Private l_Email		:= .T.
	Private c_Email		:= 'ti@bomix.com.br'
	Private c_Titulo	:= "Erro no consumo da perda da OP: " + SH6->H6_OP + "."
	Private c_Corpo		:= c_Titulo + CRLF + "Acionamento: Key User para verificar com o usuário " + UsrRetName(__CUSERID) +" o ocorrido."
    Private nPerdaborra := 0
    Private cPt         := SH6->H6_PT
    Private cOp         := SH6->H6_OP
    Private cRec        := SH6->H6_RECURSO
    Private dData       := dDataBase
    Private cProd       := SH6->H6_PRODUTO
    Private cDtIni      := SH6->H6_DATAINI
    Private cHrIni      := SH6->H6_HORAINI
    Private cDtFim      := SH6->H6_DATAFIN
    Private cHrFim      := SH6->H6_HORAFIN
    Private cLocal      := SH6->H6_LOCAL
    Private cOperac     := SH6->H6_OPERAC
    Private cQtdPerd    := APERDA[1][2]
    Private cRfProd     := APERDA[1][10]
    Private lMsErroAuto := .F.

    If cFilAnt == "020101"
        If SH6->H6_QTDPERD > 0
            If ("BORRA" $ APERDA[1][4] .AND. APERDA[1][33]==.F.)
                // DBSELECTAREA("SD4")
                // DBSETORDER(1)
                // dbSeek(XFilial("SD4") + cRfProd + cOp)
                nPerdaborra := (APERDA[1][2] / SH6->H6_FSPESOI)
                xRotAuto := {;
                            {"H6_FILIAL"    , FWxFilial("SH6"),Nil},;
                            {"H6_OP"        , cOp             ,Nil},;
                            {"H6_PRODUTO"   , cProd           ,Nil},;
                            {"H6_OPERAC"    , cOperac         ,Nil},;
                            {"H6_RECURSO"   , cRec            ,Nil},;
                            {"H6_DATAINI"   , cDtIni          ,Nil},;
                            {"H6_HORAINI"   , cHrIni          ,Nil},;
                            {"H6_DATAFIN"   , cDtFim          ,Nil},;
                            {"H6_HORAFIN"   , cHrFim          ,Nil},;
                            {"H6_PT"        , cPt             ,Nil},;
                            {"H6_LOCAL"     , cLocal          ,Nil},;
                            {"H6_QTDPROD"   , cQtdProd        ,Nil},;
                            {"H6_QTDPERD"   , nPerdaborra     ,Nil};
                            }
                cRfLocOrig      := APERDA[1][12]
                cRfTipo         := APERDA[1][17]
                cRfMotivo       := APERDA[1][1]
                cRfQuant        := APERDA[1][2]

                aAdd(aRefugos, {;
                            {"BC_PRODUTO"  , cRfProd       ,Nil},;
                            {"BC_LOCORIG"  , cRfLocOrig    ,Nil},;
                            {"BC_TIPO"     , cRfTipo       ,Nil},;
                            {"BC_MOTIVO"   , cRfMotivo     ,Nil},;
                            {"BC_QUANT"    , cRfQuant      ,Nil};
                            })

                If Len(aRefugos) > 0
                    aAdd(xRotAuto, {"AUTREFUGO", aRefugos, Nil})
                EndIf

                msExecAuto({|x,y| MATA681(x,y)},xRotAuto,3)

                If lMsErroAuto
                    jEnvMail()
                    Help(NIL, NIL, 'ERR_OP', NIL, 'Erro no ajuste de Empenho e Op.',;
                        1, 0, NIL, NIL, NIL, NIL, NIL, {'Encaminhe esta Op ao time de TI para acompanhar o processo.'})
                    MostraErro()
                Endif
            EndIf

            For nX := 1 to Len(aSd4[1])
                DbSelectArea("SB1")
                DbSetOrder(1)
                If DbSeek(FwXFilial("SB1") + aSd4[1][nX][3])
                    If !gravaPerda(aSd4[1][nX][3])
                        aSd4[1][nX][2] := 0
                    EndIf
                EndIf
            Next
        EndIf
    EndIf

    If cFilAnt == "010101"
        If SH6->H6_QTDPROD > 0
            For nX := 1 to Len(aSd4[1])
                DbSelectArea("SB1")
                DbSetOrder(1)
                DbSeek(FwXFilial("SB1") + aSd4[1][nX][3])
                If !fConsumo(aSd4[1][nX][3],aSd4[1][nX][11])
                    aSd4[1][nX][2] := 0
                EndIf
            Next
        EndIf
        If SH6->H6_QTDPERD > 0
            For nX := 1 to Len(aSd4[1])
                DbSelectArea("SB1")
                DbSetOrder(1)
                If DbSeek(FwXFilial("SB1") + aSd4[1][nX][3])
                    If !gravaPerda(aSd4[1][nX][3])
                        aSd4[1][nX][2] := 0
                    EndIf
                EndIf
            Next
        EndIf
    EndIf

Return aSD4

/*/{Protheus.doc} gravaPerda
    Realiza a gravação da perda dos itens que possuem.
    @type  Function
    @author Rômulo Ferreira
    @since 28/05/2021
    @version 12.1.25
    @param _cCod, character, Codigo do Produto
/*/
Static Function gravaPerda(_cCod)

    If Select("TRB") > 1
        TRB->(dbCloseArea())
    EndIf

    cQry := " SELECT
    cQry += " Z05_PERDA PERDA
    cQry += " FROM
    cQry += " SB1010 B1 (NoLock)
    cQry += " INNER JOIN Z05010 Z05 ON Z05_FILIAL = B1_FILIAL
    cQry += "                                     AND Z05.D_E_L_E_T_ <> '*'
    cQry += "                                     AND Z05_NOME = B1_BRTPPR
    cQry += " WHERE
    cQry += " B1_FILIAL = '"+xFilial("SB1")+"'
    cQry += " AND B1.D_E_L_E_T_ <> '*'
    cQry += " AND B1_BRTPPR <> ''
    cQry += " AND B1_COD = '"+_cCod+"'

    TCQUERY cQry NEW ALIAS "TRB"

    If TRB->(!EoF())
        Return TRB->PERDA = 'S'
    EndIf

Return .T. // Se não achou configuração de Perda, grava perda normalmente

/*/{Protheus.doc} fConsumo
    Função utilizada para verificar os itens que podem ser consumidos no apontamento de produção
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 27/09/2021
    @param cProd, character, Código do produto
    @param cOp, character, Número da Op
    @return logical, Retorna verdadeiro falso para consumir e verdadeiro não consome.
/*/
Static Function fConsumo(cProd,cOp)

    Local lRet  := .T.
    Local nCounter := 0

    If Select("CONSU") > 0
        CONSU->(dbCloseArea())
    EndIf

    BEGINSQL ALIAS "CONSU"
        SELECT
            C2.C2_QUANT - C2_QUJE AS SALDO,
            C2.C2_QUANT / B1_QB AS PALET,
            B1.B1_QB as QUANTBAS,
            Z05.Z05_CARRO AS CONSUMO,
            C2.C2_QUJE AS ENTREGUE,
            D4.D4_QUANT AS EMPENHO
        FROM %TABLE:SC2% C2 (NoLock)
            INNER JOIN %TABLE:SB1% B1 (NoLock) ON B1.B1_FILIAL = %XFILIAL:SB1%
            AND B1.%NOTDEL%
            AND B1.B1_COD = C2.C2_PRODUTO
            INNER JOIN %TABLE:SD4% D4 (NoLock) ON D4.D4_FILIAL = %XFILIAL:SD4%
            AND D4.%NOTDEL%
            AND D4.D4_OP = %Exp:cOp%
            INNER JOIN %TABLE:Z05% Z05 (NoLock) ON Z05.Z05_FILIAL = %XFILIAL:Z05%
            AND Z05.%NOTDEL%
            AND Z05.Z05_NOME = D4.D4_FSTP
        WHERE C2.C2_FILIAL = %XFilial:SC2%
            AND C2.%NOTDEL%
            AND C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = %Exp:cOp%
            AND D4.D4_COD = %Exp:cProd%
    ENDSQL

    If CONSU->CONSUMO  == 'N'
        If CONSU->ENTREGUE <> 0
            nCounter := Int(CONSU->ENTREGUE / CONSU->QUANTBAS)
        EndIf
        If Int(((CONSU->ENTREGUE + SH6->H6_QTDPROD) / CONSU->QUANTBAS)) == nCounter
            lRet := .F.
        EndIf
    EndIf

Return lRet
