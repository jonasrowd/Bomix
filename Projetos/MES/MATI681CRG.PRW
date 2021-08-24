#Include 'Protheus.ch'

/*/{Protheus.doc} MATI681CRG
Gatilho para adicionar ao array a data de validade do produto
@type function
@version 12.1.25
@author Alexandre Kuhnen
@since 24/08/2021
@return array, data de validade
/*/
User Function MATI681CRG()
Local aRet := {} 
Local nPosqtd  := aScan(PARAMIXB,{|aX| AllTrim(aX[1]) == "H6_QTDPROD"})
Local nPosProd := aScan(PARAMIXB,{|aX| AllTrim(aX[1]) == "H6_PRODUTO "})
Local aAreaSb1 := SB1->(GetArea())

If PARAMIXB[nPosqtd,2]  > 0 
    DBSELECTAREA("SB1")
    DBSETORDER(1)
    IF DBSEEK(XFILIAL("SB1")+PARAMIXB[nPosProd,2]  )
        IF SB1->B1_RASTRO == "L" .AND. ! EMPTY(SB1->B1_PRVALID)
            aAdd(aRet,{"H6_DTVALID",DATE()+ SB1->B1_PRVALID , Nil})
        ENDIF     
    
    ENDIF

EndIf

    restarea(aAreaSb1)

Return aRet
