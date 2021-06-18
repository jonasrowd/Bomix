#include "apvt100.ch"
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH" 

User Function FACDA002
    Local c_Unitiz   := Space(TamSX3("DCO_CODANA")[1])
    Local c_UnitDest := Space(TamSX3("DCO_CODANA")[1])    
    Local l_Unitiz   := .F.
    Local c_Produto  := SDB->DB_PRODUTO
    Local n_Quant    := SDB->DB_QUANT
	Local c_Local    := SDB->DB_LOCAL
	Local c_Lote     := SDB->DB_LOTECTL
	Local c_Localiz  := SDB->DB_LOCALIZ
	Local c_Endereco := SDB->DB_ENDDES
	Local c_Codigo   := ""
	Local c_CodDest  := ""
	Local a_Area     := GetArea()
	Local a_AreaDC2  := DC2->(GetArea())
	Local l_Ret      := .T.
	Local a_Tela     := VTSave(0, 0, 4, 10)
	Local c_Norma    := DC3->DC3_CODNOR
	Local n_QtdNorma := 0
	Local n_QtdUnitz := 0
	Local c_ConfUnit := Space(TamSX3("DCO_CODANA")[1])
	Local c_ConfDest := Space(TamSX3("DCO_CODANA")[1])	
	Local c_Transp   := Space(1)
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
		@ 0, 0 VTSAY "Unit. Orig: " VTGET c_Unitiz
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
				If DCO->DCO_STATUS $ "13"
					VTAlert("Unitizador " + AllTrim(c_Unitiz) + " está com o status disponível ou indisponível. Por favor contactar o administrador do sistema.", "Aviso")
				Else
					c_Codigo   := DCO->DCO_FSCOD
					n_QtdUnitz := 0					
	
					dbSelectArea("SZT")
					dbSetOrder(1)
					dbSeek(xFilial("SZT") + c_Codigo)
					While SZT->(!EoF()) .And. SZT->(ZT_FILIAL + ZT_COD) == (xFilial("SZT") + c_Codigo)
						If SZT->ZT_PRODUTO == c_Produto .And. SZT->ZT_LOCAL == c_Local .And. SZT->ZT_LOTECTL == c_Lote .And. SZT->ZT_LOCALIZ == c_Localiz
							n_QtdUnitz += SZT->ZT_QUANT
						Endif

						SZT->(dbSkip())
					End

					If n_QtdUnitz == 0
						VTAlert("Unitizador " + AllTrim(c_Unitiz) + " não contém o Produto " + AllTrim(c_Produto) + " do Lote " + AllTrim(c_Lote) + ".", "Aviso")						
					Else
						If n_QtdUnitz < n_Quant
							VTAlert("Unitizador " + AllTrim(c_Unitiz) + " não contém a quantidade solicitada para Apanhe do Produto " + AllTrim(c_Produto) + " do Lote " + AllTrim(c_Lote) + ".", "Aviso")
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
	l_Unitiz := .F.
	
	While l_Unitiz == .F.
		@ 0, 0 VTSAY "Unit. Dest: " VTGET c_UnitDest
	    VTRead
	    
	    If c_Unitiz == c_UnitDest
	    	l_Unitiz := .T.
	    Else
	    
			If VtLastKey() == 27
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Endif

			dbSelectArea("DCO")
			dbSetorder(1)
			If dbSeek(xFilial("DCO") + DC2->DC2_CODUNI + c_UnitDest)
				If DCO->DCO_STATUS == "3"
					VTAlert("Unitizador " + AllTrim(c_UnitDest) + " está indisponível. Por favor contactar o administrador do sistema.", "Aviso")
				Else
					If DCO->DCO_STATUS == "1"
						c_CodDest := GetSXEnum("SZT", "ZT_COD")
						
						dbSelectArea("SZT")
						dbSetorder(1)
						While dbSeek(xFilial("SZT") + c_CodDest) == .T.
							c_CodDest := StrZero(Val(c_CodDest) + 1, TamSX3("ZT_COD")[1])
						End															
									
						l_Unitiz  := .T.
					Else
						c_CodDest  := DCO->DCO_FSCOD
						n_QtdUnitz := 0					
		
						dbSelectArea("SZT")
						dbSetOrder(1)
						dbSeek(xFilial("SZT") + c_CodDest)
						While SZT->(!EoF()) .And. SZT->(ZT_FILIAL + ZT_COD) == (xFilial("SZT") + c_CodDest)
							n_QtdUnitz += SZT->ZT_QUANT

							SZT->(dbSkip())
						End
	
						If (n_Quant + n_QtdUnitz) > n_QtdNorma
							VTAlert("Unitizador " + AllTrim(c_UnitDest) + " não possui capacidade para armazenar a quantidade informada, pois já existem " + ;
							Transform(n_QtdUnitz, "@E 999,999.99") + " itens alocados no Unitizador. Quantidade disponível: " + Transform(n_QtdNorma - n_QtdUnitz, "@E 999,999.99"), "Aviso")
						Else
							l_Unitiz := .T.
						Endif
					Endif
			    Endif
			Else
				VTAlert("Unitizador " + AllTrim(c_UnitDest) + " inválido.  Por favor informe um unitizador válido antes de prosseguir.", "Aviso")
				c_UnitDest := Space(TamSX3("DC1_CODUNI")[1] + TamSX3("DCO_CODANA")[1])
			Endif			
		Endif
	End

	While c_UnitDest <> c_ConfDest
		@ 2, 0 VTSAY "Confirme!" 
		@ 3, 0 VTGET c_ConfDest
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
		If c_Unitiz <> c_UnitDest
			//Atualiza o Unitizador Destino
			dbSelectArea("SZT")
			dbSetorder(1)
			If dbSeek(xFilial("SZT") + c_CodDest + DC2->DC2_CODUNI + c_UnitDest + c_Produto + c_Local + c_Lote + c_Endereco)
				RecLock("SZT", .F.)
				SZT->ZT_FILIAL  := XFILIAL("SZT")
				SZT->ZT_COD     := c_CodDest
				SZT->ZT_UNITIZ  := DC2->DC2_CODUNI
				SZT->ZT_CODANA  := c_UnitDest
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
				SZT->ZT_COD     := c_CodDest
				SZT->ZT_UNITIZ  := DC2->DC2_CODUNI
				SZT->ZT_CODANA  := c_UnitDest
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
			If dbSeek(xFilial("DCO") + DC2->DC2_CODUNI + c_UnitDest)
				RecLock("DCO", .F.)
				DCO->DCO_STATUS := "2"	//Em uso
				DCO->DCO_HRINI	:= SubStr(Time(), 1, 5)
				DCO->DCO_DTINI  := DDATABASE
				DCO->DCO_LOCAL  := c_Local
				DCO->DCO_ENDER  := c_Endereco
				DCO->DCO_FSCOD  := c_CodDest
				DCO->DCO_HRFIM	:= ""
				DCO->DCO_DTFIM  := Ctod("  /  /    ")
				MsUnlock()
				VTAlert("Alocação do Unitizador " + AllTrim(c_UnitDest) + " realizada com sucesso.", "Aviso")
			Endif			
			
            //Atualiza o Unitizador Origem
			dbSelectArea("SZT")
			dbSetorder(1)
			If dbSeek(xFilial("SZT") + c_Codigo + DC2->DC2_CODUNI + c_Unitiz + c_Produto + c_Local + c_Lote + c_Localiz)
				RecLock("SZT", .F.)
				SZT->ZT_COD     := c_Codigo
				SZT->ZT_UNITIZ  := DC2->DC2_CODUNI
				SZT->ZT_CODANA  := c_Unitiz
				SZT->ZT_PRODUTO := c_Produto
				SZT->ZT_QUANT   -= n_Quant
				SZT->ZT_LOCAL   := c_Local
				SZT->ZT_LOTECTL := c_Lote
				SZT->ZT_LOCALIZ := c_Localiz
				MsUnlock()
			Endif

			If n_Quant == n_QtdNorma
				dbSelectArea("DCO")
				dbSetorder(1)
				If dbSeek(xFilial("DCO") + DC2->DC2_CODUNI + c_Unitiz)
					RecLock("DCO", .F.)
					DCO->DCO_STATUS := "1"	//Disponível
					DCO->DCO_FSCOD  := ""
					DCO->DCO_HRFIM	:= SubStr(Time(), 1, 5)
					DCO->DCO_DTFIM  := DDATABASE
					MsUnlock()
					VTAlert("Liberação do Unitizador " + AllTrim(c_Unitiz) + " realizada com sucesso.", "Aviso")
				Endif
			Endif
		Else
			dbSelectArea("SZT")
			dbSetorder(1)
			If dbSeek(xFilial("SZT") + c_Codigo + DC2->DC2_CODUNI + c_Unitiz + c_Produto + c_Local + c_Lote + c_Localiz)
				RecLock("SZT", .F.)
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
				DCO->DCO_LOCAL  := c_Local
				DCO->DCO_ENDER  := c_Endereco
				DCO->DCO_FSCOD  := c_Codigo
				DCO->DCO_HRFIM	:= ""
				DCO->DCO_DTFIM  := Ctod("  /  /    ")
				MsUnlock()
				VTAlert("Alocação do Unitizador " + AllTrim(c_Unitiz) + " realizada com sucesso.", "Aviso")
			Endif		
		Endif
	End Transaction

	RestArea(a_AreaDC2)
	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret