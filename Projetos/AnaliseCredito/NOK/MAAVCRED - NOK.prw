#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MAAVCRED
	Ponto de entrada que valida se o cliente possui boletos em atraso e se j� foi liberado anteriormente
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 09/08/2021
	@return Logical, Se verdadeiro, deixa seguir, sen�o, bloqueia.
	@see https://tdn.totvs.com/display/public/PROT/MAAVCRED
/*/
User Function MAAVCRED()

	Local aArea := GetArea()
	Local l_Ret := .T.
	If (FWCodFil() != '030101') //Se n�o for filial 03, segue o fonte
		nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
		cNome := SA1->A1_NOME
		If nAtrasados <> 0 .AND. (!estaLib(SC5->C5_NUM))
			l_Ret := .F.
			Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Cliente: " + AllTrim(cNome)  + " Pedido: "+SC5->C5_NUM+", possui restri��es financeiras no total de R$ " ;
			+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a libera��o ao departamento comercial."})
		EndIf
	EndIf
	RestArea(aArea)
Return l_Ret


/*/{Protheus.doc} estaLib
	Verifica se o pedido j� foi liberado anteriormente.
	@type Function
	@version 12.1.25
	@author Sandro Santos
	@since 04/08/2021
	@param _cPed, variant, N�mero do pedido capturado pelo ponto de entrada
	@return Logical, lOK, Controle de libera��o
/*/
Static Function estaLib(_cPed)
	
	Local lOK	  := .F.
	Default _cPed := ''

	DbSelectArea('Z07')
	DbSetOrder(1)

	If DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)
		While Z07->(!Eof()) .And. SC5->C5_NUM == Z07->Z07_PEDIDO
			If 'Venda' $ Z07->Z07_JUSTIF .OR. 'Exped' $ Z07->Z07_JUSTIF
				lOK := .T.
			EndIf
			Z07->(dbSkip())
		End
	ElseIf SC5->C5_BXSTATU $ ("B|P")
		lOK := .T.
	Else
		lOK := .F.
	EndIf

Return (lOK)
