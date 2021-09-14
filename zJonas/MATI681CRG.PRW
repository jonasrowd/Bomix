#Include 'Totvs.ch'

/*/{Protheus.doc} MATI681CRG
    Gatilho para adicionar ao array a data de validade do produto
    @type function
    @version 12.1.25
    @author Alexandre Kuhnen
    @since 24/08/2021
    @return array, data de validade
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=203759642
/*/
User Function MATI681CRG()
	Local aRet := {}
	Local aAreaSb1 := SB1->(GetArea())
	Local nPos := aScan(PARAMIXB,{|aX| AllTrim(aX[1]) == 'H6_TIPO'})
	Local nPosProd := aScan(PARAMIXB,{|aX| AllTrim(aX[1]) == 'H6_PRODUTO'})
	
	ConOut('---->>> Entrando no  ponto de entrada MATI681CRG')
	If PARAMIXB[nPos,2] == 'P'
		DBSELECTAREA('SB1')
		DBSETORDER(1)
		IF DBSEEK(XFILIAL('SB1')+PARAMIXB[nPosProd,2])
			ConOut('---->>>Achou produto')
			IF SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID)
				aAdd(aRet,{'H6_DTVALID',DATE()+ SB1->B1_PRVALID , Nil})
				ConOut('---->>>Adicionou o Array, b1_rastro = l e b1_prvalid diferente de branco')
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaSb1)

Return aRet
