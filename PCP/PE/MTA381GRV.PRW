#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MTA381GRV 
    Ponto de Entrada utilizado para realizar operações complementares após a inclusão, alteração e exclusão de um item de ajuste de empenho mod II.
    @type Function
    @version 12.1.25
    @author JONAS MACHADO
    @since 28/10/2021
    @return logical, lRet
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6087881
/*/
USER FUNCTION MTA381GRV()

    Local i,j     := 0   //Variáveis de contagem
    Local nResori := 0   //Quantidade origem da Resina
    Local nMasori := 0   //Quantidade origem da Master
    Local nTotal  := 0   //Total Master+Resina
    Local nPerc   := 0   //Percentual de Master e Resina
    Local c_Op    := COP //Op posicionada

    IF (ALTERA .OR. INCLUI)//Se for alteração ou inclusão, realiza o cálculo
        For i:=1 to Len(Acols)
            If AllTrim(Acols[i][24]) $ "RESINA"
                nResori := nResori + Acols[i][4] //Soma se tiver mais de uma resina no Acols
            EndIf
            If Alltrim(Acols[i][24]) $ "MASTER"
                nMasori := nMasori + Acols[i][4] //Soma caso algum dia tenha mais de uma master
            EndIf
        Next i

        nTotal := nResori + nMasori

        For j:=1 to Len(Acols)
            If Alltrim(Acols[j][24]) $ "MASTER|RESINA"
                nPerc := ((Acols[j][4]) / nTotal) * 100 //Calcula o percentual de cada Master / resina
                DbSelectArea("SD4")
                DbSetOrder(1)
                DbSeek(FwXFilial("SD4") + Acols[j][1] + c_Op)
                RecLock("SD4", .F.)
                    SD4->D4_FSPM_R := Round(nPerc,2) //Grava no campo específico a proporção de cada item
                MsUnlock()
            EndIf
        Next j
    ENDIF

RETURN NIL
