#Include "Totvs.ch"
#Include "Apvt100.ch"

/*/{Protheus.doc} FACDA007
	Programa responsavel por validar e gravar os unitizadores o momento do cross docking.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 20/07/2021
	@param c_Local, character, Verificar de onde vem
	@param c_EstFis, character, Verificar de onde vem
	@param c_Endereco, character, Verificar de onde vem
	@param c_Produto, character, Verificar de onde vem
	@param c_Lote, character, Verificar de onde vem
	@param c_SubLote, character, Verificar de onde vem
	@param n_QtdNorma, numeric, Verificar de onde vem
	@param n_Quant, numeric, Verificar de onde vem
	@param n_QtdInf, numeric, Verificar de onde vem
	@return variant, Null
/*/
User Function FACDA007( c_Local, c_EstFis, c_Endereco, c_Produto, c_Lote, c_SubLote, n_QtdNorma, n_Quant, n_QtdInf )

	Local c_Unitiz   := Space(TamSX3("DC1_CODUNI")[1])
	Local c_CodAna   := Space(TamSX3("DCO_CODANA")[1])
	Local c_ConfAna  := Space(TamSX3("DCO_CODANA")[1])
	Local l_CodAna   := .F.
	Local c_Codigo   := ""
	Local a_Area     := GetArea()
	Local l_Ret      := .T.
	Local a_Tela     := VTSave(0, 0, 4, 10)
	Local c_CodUni   := Getmv("FS_CODUNI")
	Local c_MaskUni  := Getmv("FS_MASKUNI")
	Local a_CodUni   := StrTokArr(c_CodUni, ";")
	Local a_MaskUni  := StrTokArr(c_MaskUni, ";")
	Local l_MaskUni  := .F.
	Local i          := 1
	Local n_QtdUnitz := 0
	Local c_Norma	 := ""
	Local c_EndFinal := SDB->DB_ENDDES

	VTClear Screen
	While l_CodAna == .F.

		@ 1, 0 VTSAY "Unitizador: " VTGET c_CodAna
		VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif

		For i:=1 To Len(a_MaskUni)

			If AllTrim(a_MaskUni[i]) == SubStr(c_CodAna, 1, 1)

				l_MaskUni := .T.

				If i <= Len(a_CodUni)
					c_Unitiz := a_CodUni[i]

					dbSelectArea("DC1")
					dbSetOrder(1)
					If dbSeek(xFilial("DC1") + c_Unitiz)
						Exit
					Else
						VTAlert("Unitizador " + AllTrim(c_Unitiz) + " inv�lido. Por favor contactar o administrador do sistema e solicitar a verifica��o do conte�do do par�metro FS_CODUNI.", "Aviso")
						RestArea(a_Area)
						VTClear Screen
						VTRestore(0, 0, 4, 10, a_Tela)
						Return .F.
					Endif
				Else
					VTAlert("O par�metro FS_CODUNI n�o est� equivalente ao par�metro FS_MASKUNI. Por favor contactar o administrador do sistema e solicitar a verifica��o do conte�do destes par�metros.", "Aviso")
					RestArea(a_Area)
					VTClear Screen
					VTRestore(0, 0, 4, 10, a_Tela)
					Return .F.
				Endif
			Endif
		Next

		If l_MaskUni == .F.
			VTAlert("M�scara do Unitizador n�o foi encontrada. Por favor contactar o administrador do sistema e solicitar a verifica��o do conte�do do par�metro FS_MASKUNI.", "Aviso")
			RestArea(a_Area)
			VTClear Screen
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif

		dbSelectArea("DC3")
		dbSetOrder(1)
		If dbSeek(xFilial("DC3") + c_Produto + c_Local)
			c_Norma := DC3->DC3_CODNOR
		Endif

		dbSelectArea("DC2")
		dbSetOrder(1)
		if dbSeek(xFilial("DC2") + c_Norma,.t.)

			n_QtdNorma := DC2->DC2_LASTRO * DC2->DC2_CAMADA

			dbSelectArea("DCO")
			dbSetOrder(1)
			IF dbSeek(xFilial("DCO") + c_Unitiz + c_CodAna,.T.)

				If DCO->DCO_STATUS == "3" //1=Disponivel; 2=Em Uso; 3=Indisponivel

					VTAlert("Unitizador " + AllTrim(c_Unitiz) + " est� indispon�vel. Por favor contactar o administrador do sistema.", "Aviso")

				ElseIf DCO->DCO_STATUS == "1"

					dbSelectArea("DC3")
					dbSetOrder(1)
					If dbSeek(xFilial("DC3") + c_Produto + c_Local)
						c_Norma := DC3->DC3_CODNOR
					Endif

					c_Codigo := GetSXEnum("SZT", "ZT_COD")

					dbSelectArea("SZT")
					dbSetorder(1)
					While dbSeek(xFilial("SZT") + c_Codigo)	== .T.
						c_Codigo := StrZero(Val(c_Codigo) + 1, TamSX3("ZT_COD")[1])
					End

					l_CodAna := .T.

				ELSE

					c_Codigo   := DCO->DCO_FSCOD
					n_QtdUnitz := 0

					dbSelectArea("SZT")
					dbSetOrder(1)
					dbSeek(xFilial("SZT") + c_Codigo)
					While SZT->(!EoF()) .And. SZT->(ZT_FILIAL + ZT_COD) == (xFilial("SZT") + c_Codigo)

						n_QtdUnitz += SZT->ZT_QUANT

						SZT->(dbSkip())

					Enddo

					If (n_QtdInf + n_QtdUnitz) > n_QtdNorma

						VTAlert("Unitizador " + AllTrim(c_Unitiz) + " n�o possui capacidade para armazenar a quantidade informada, pois j� existem " + ;
						Transform(n_QtdUnitz, "@E 999,999.99") + " itens alocados no Unitizador. Quantidade dispon�vel: " + Transform(n_QtdNorma - n_QtdUnitz, "@E 999,999.99"), "Aviso")

					Else

						l_CodAna := .T.

					Endif

				Endif

			Else

				VTAlert("Unitizador " + AllTrim(c_Unitiz) + " inv�lido. Por favor contactar o administrador do sistema.", "Aviso")

			Endif
		Else

			VTAlert("Norma " + AllTrim(c_Norma) + " inv�lida. Por favor contactar o administrador do sistema.", "Aviso")

		Endif

	ENDDO

	While c_CodAna <> c_ConfAna

		@ 2, 0 VTSAY "Confirme!"
		@ 3, 0 VTGET c_ConfAna
		VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif
	End

	VTClear Screen

	Begin Transaction

	dbSelectArea("SZT")
	dbSetorder(1)
	If dbSeek(xFilial("SZT") + c_Codigo + c_Unitiz + c_CodAna + c_Produto + c_Local + c_Lote + c_Endereco)
		RecLock("SZT", .F.)
		SZT->ZT_FILIAL  := XFILIAL("SZT")
		SZT->ZT_COD     := c_Codigo
		SZT->ZT_UNITIZ  := c_Unitiz
		SZT->ZT_CODANA  := c_CodAna
		SZT->ZT_PRODUTO := c_Produto
		SZT->ZT_QUANT   += n_QtdInf
		SZT->ZT_LOCAL   := c_Local
		SZT->ZT_LOTECTL := c_Lote
		SZT->ZT_LOCALIZ := c_Endereco
		MsUnlock()
	Else
		RecLock("SZT", .T.)
		SZT->ZT_FILIAL  := XFILIAL("SZT")
		SZT->ZT_COD     := c_Codigo
		SZT->ZT_UNITIZ  := c_Unitiz
		SZT->ZT_CODANA  := c_CodAna
		SZT->ZT_PRODUTO := c_Produto
		SZT->ZT_QUANT   := n_QtdInf
		SZT->ZT_LOCAL   := c_Local
		SZT->ZT_LOTECTL := c_Lote
		SZT->ZT_LOCALIZ := c_EndFinal
		MsUnlock()
	Endif

	dbSelectArea("DCO")
	dbSetorder(1)
	If dbSeek(xFilial("DCO") + c_Unitiz + c_CodAna)
		RecLock("DCO", .F.)
		DCO->DCO_STATUS := "2"	//Em uso
		DCO->DCO_HRINI	:= SubStr(Time(), 1, 5)
		DCO->DCO_DTINI  := DDATABASE
		DCO->DCO_LOCAL  := c_Local
		DCO->DCO_ENDER  := c_EndFinal
		DCO->DCO_FSCOD  := c_Codigo
		DCO->DCO_HRFIM	:= ""
		DCO->DCO_DTFIM  := Ctod("  /  /    ")
		MsUnlock()

		VTAlert("Aloca��o do Unitizador " + AllTrim(c_CodAna) + " realizada com sucesso.", "Aviso")
	Endif

	End Transaction

	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)

Return l_Ret
