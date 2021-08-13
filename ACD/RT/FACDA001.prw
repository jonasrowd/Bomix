#Include "Totvs.ch" 
#Include "Apvt100.ch"
#INCLUDE "Topconn.CH" 

/*/{Protheus.doc} FACDA001
	Add descrição após testar.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 20/07/2021
	@return variant, Null
/*/
User Function FACDA001()
    Local c_Unitiz   := Space(TamSX3("DCO_CODANA")[1])
    Local l_Unitiz   := .F.
    Local c_Produto  := SDB->DB_PRODUTO
    Local n_Quant    := SDB->DB_QUANT
	Local c_Local    := SDB->DB_LOCAL 
	Local c_Lote     := SDB->DB_LOTECTL
	Local c_Endereco := SDB->DB_ENDDES
	Local c_Codigo   := ""
	Local a_Area     := GetArea()
	Local a_AreaDC2  := DC2->(GetArea())
	Local l_Ret      := .T.
	Local a_Tela     := VTSave(0, 0, 4, 10)
	Local c_Norma    := DC3->DC3_CODNOR
	Local n_QtdNorma := 0
	Local n_QtdUnitz := 0
	Local c_ConfUnit := Space(TamSX3("DCO_CODANA")[1])
	Local c_IDDCF    := ""

	c_Qry := " SELECT DCF_ID FROM " + RetSqlName("DCF") + " DCF "
	c_Qry += " WHERE DCF_FILIAL='" + XFILIAL("DCF") + "' AND DCF.D_E_L_E_T_<>'*' "
	c_Qry += " AND DCF_SERVIC = '" + SDB->DB_SERVIC + "' "
	c_Qry += " AND DCF_DOCTO  = '" + SDB->DB_DOC + "' "
	c_Qry += " AND DCF_SERIE  = '" + SDB->DB_SERIE + "' "
	c_Qry += " AND DCF_CODPRO = '" + SDB->DB_PRODUTO + "' "
	c_Qry += " AND DCF_CLIFOR = '" + SDB->DB_CLIFOR + "' "
	c_Qry += " AND DCF_LOJA   = '" + SDB->DB_LOJA + "' "
	c_Qry += " AND DCF_NUMSEQ = '" + SDB->DB_NUMSEQ + "' "
	c_Qry += " AND DCF_CARGA  = '" + SDB->DB_CARGA + "' "
	c_Qry += " AND DCF_UNITIZ = '" + SDB->DB_UNITIZ + "' "
	c_Qry += " AND DCF_LOCAL  = '" + SDB->DB_LOCAL + "' "
	c_Qry += " AND DCF_ESTFIS = '" + SDB->DB_ESTFIS + "' "
	c_Qry += " AND DCF_ENDER  = '" + SDB->DB_LOCALIZ + "' "
 
	TCquery c_Qry New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())
	If QRY->(!EoF())
		c_IDDCF := QRY->DCF_ID
	Endif

	dbCloseArea("QRY")		

	a_AreaDC3 := DC3->(GetArea())

	dbSelectArea("DC3")
	dbSetOrder(1)
	If dbSeek(xFilial("DC3") + c_Produto + c_Local)
		c_Norma := DC3->DC3_CODNOR
	Endif

	RestArea(a_AreaDC3)
	
	VTClear Screen

	While l_Unitiz == .F.
		@ 0, 0 VTSAY "Unitizador: " VTGET c_Unitiz
	    VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif

		dbSelectArea("DC2")
		dbSetOrder(1)
		dbSeek(xFilial("DC2") + c_Norma)
		If Found()
			n_QtdNorma := DC2->DC2_LASTRO * DC2->DC2_CAMADA

			dbSelectArea("DCO")
			dbSetorder(1)
			If dbSeek(xFilial("DCO") + DC2->DC2_CODUNI + c_Unitiz)
				If DCO->DCO_STATUS == "3"
					VTAlert("Unitizador " + AllTrim(c_Unitiz) + " está indisponível. Por favor contactar o administrador do sistema.", "Aviso")
				Else
					If DCO->DCO_STATUS == "1"
						c_Codigo   := GetSXEnum("SZT", "ZT_COD")
						
						dbSelectArea("SZT")
						dbSetorder(1)
						While dbSeek(xFilial("SZT") + c_Codigo)	== .T.
							c_Codigo := StrZero(Val(c_Codigo) + 1, TamSX3("ZT_COD")[1])
						End						

						l_Unitiz := .T.
					Else
						c_Codigo   := DCO->DCO_FSCOD
						n_QtdUnitz := 0					
	
						dbSelectArea("SZT")
						dbSetOrder(1)
						dbSeek(xFilial("SZT") + c_Codigo)
						While SZT->(!EoF()) .And. SZT->(ZT_FILIAL + ZT_COD) == (xFilial("SZT") + c_Codigo)
							n_QtdUnitz += SZT->ZT_QUANT

							SZT->(dbSkip())
						End

						If (n_Quant + n_QtdUnitz) > n_QtdNorma
							VTAlert("Unitizador " + AllTrim(c_Unitiz) + " não possui capacidade para armazenar a quantidade informada, pois já existem " + ;
							Transform(n_QtdUnitz, "@E 999,999.99") + " itens alocados no Unitizador. Quantidade disponível: " + Transform(n_QtdNorma - n_QtdUnitz, "@E 999,999.99"), "Aviso")
						Else
							l_Unitiz := .T.
						Endif
					Endif
			    Endif
			Else
				VTAlert("Unitizador " + AllTrim(c_Unitiz) + " inválido.  Por favor informe um unitizador válido antes de prosseguir.", "Aviso")
				c_Unitiz := Space(TamSX3("DC1_CODUNI")[1] + TamSX3("DCO_CODANA")[1])
			Endif			
		Else
			VTAlert("Norma " + AllTrim(c_Norma) + " inválida. Por favor contactar o administrador do sistema.", "Aviso")					
		Endif			
	End

	While c_Unitiz <> c_ConfUnit
		@ 2, 0 VTSAY "Confirme!" 
		@ 3, 0 VTGET c_ConfUnit
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
		If dbSeek(xFilial("SZT") + c_Codigo + DC2->DC2_CODUNI + c_Unitiz + c_Produto + c_Local + c_Lote + c_Endereco)	
			RecLock("SZT", .F.)
			SZT->ZT_FILIAL  := XFILIAL("SZT")
			SZT->ZT_COD     := c_Codigo
			SZT->ZT_UNITIZ  := DC2->DC2_CODUNI
			SZT->ZT_CODANA  := c_Unitiz
			SZT->ZT_PRODUTO := c_Produto
			SZT->ZT_QUANT   += n_Quant
			SZT->ZT_LOCAL   := c_Local
			SZT->ZT_LOTECTL := c_Lote
			SZT->ZT_LOCALIZ := c_Endereco
			SZT->ZT_IDDCF   := c_IDDCF
			MsUnlock()
		Else
			RecLock("SZT", .T.)
			SZT->ZT_FILIAL  := XFILIAL("SZT")
			SZT->ZT_COD     := c_Codigo
			SZT->ZT_UNITIZ  := DC2->DC2_CODUNI
			SZT->ZT_CODANA  := c_Unitiz
			SZT->ZT_PRODUTO := c_Produto
			SZT->ZT_QUANT   := n_Quant
			SZT->ZT_LOCAL   := c_Local
			SZT->ZT_LOTECTL := c_Lote
			SZT->ZT_LOCALIZ := c_Endereco
			SZT->ZT_IDDCF   := c_IDDCF
			MsUnlock()
		Endif
	
		dbSelectArea("DCO")
		dbSetorder(1)
		If dbSeek(xFilial("DCO") + DC2->DC2_CODUNI + c_Unitiz)
			RecLock("DCO", .F.)
			DCO->DCO_STATUS := "2"	//Em uso
			DCO->DCO_HRINI	:= SubStr(Time(), 1, 5)
			DCO->DCO_DTINI  := DDATABASE
			DCO->DCO_LOCAL  := c_Local
			DCO->DCO_ENDER  := c_Endereco
			DCO->DCO_FSCOD  := c_Codigo
			DCO->DCO_HRFIM	:= ""
			DCO->DCO_DTFIM  := Ctod("  /  /    ")
			MsUnlock()
	
			VTAlert("Alocação do Unitizador " + AllTrim(c_Unitiz) + " realizada com sucesso.", "Aviso")
		Endif
	End Transaction

	RestArea(a_AreaDC2)
	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret
