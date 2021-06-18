#include "apvt100.ch"
#INCLUDE "PROTHEUS.CH" 

User Function FACDA005
    Local c_Unitiz   := Space(TamSX3("DC1_CODUNI")[1])
//    Local l_Unitiz   := .F.
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

	VTClear Screen
/*
	While l_Unitiz == .F.
		@ 0, 0 VTSAY "Unitizador: " VTGET c_Unitiz
	    VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif

		dbSelectArea("DC1")
		dbSetOrder(1)
		dbSeek(xFilial("DC1") + c_Unitiz)
		If Found()
			l_Unitiz := .T.
		Else
			VTAlert("Unitizador " + AllTrim(c_Unitiz) + " inválido. Por favor contactar o administrador do sistema.", "Aviso")
		Endif
	End
*/	
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
						VTAlert("Unitizador " + AllTrim(c_Unitiz) + " inválido. Por favor contactar o administrador do sistema e solicitar a verificação do conteúdo do parâmetro FS_CODUNI.", "Aviso")
						RestArea(a_Area)
						VTClear Screen			
						VTRestore(0, 0, 4, 10, a_Tela)
						Return .F.
					Endif
				Else
					VTAlert("O parâmetro FS_CODUNI não está equivalente ao parâmetro FS_MASKUNI. Por favor contactar o administrador do sistema e solicitar a verificação do conteúdo destes parâmetros.", "Aviso")
					RestArea(a_Area)
					VTClear Screen			
					VTRestore(0, 0, 4, 10, a_Tela)
					Return .F.					
				Endif
			Endif
		Next

		If l_MaskUni == .F.		
			VTAlert("Máscara do Unitizador não foi encontrada. Por favor contactar o administrador do sistema e solicitar a verificação do conteúdo do parâmetro FS_MASKUNI.", "Aviso")
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.			
		Endif

		dbSelectArea("DCO")
		dbSetOrder(1)
		dbSeek(xFilial("DCO") + c_Unitiz + c_CodAna)
		If Found()
			l_CodAna := .T.
		Else
			VTAlert("Unitizador " + AllTrim(c_Unitiz) + " inválido. Por favor contactar o administrador do sistema.", "Aviso")
		Endif
	End	

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
		dbSelectArea("DCO")
		dbSetorder(1)
		If dbSeek(xFilial("DCO") + c_Unitiz + c_CodAna)
			RecLock("DCO", .F.)
			DCO->DCO_STATUS := "1"	//Disponível
			DCO->DCO_HRINI	:= ""
			DCO->DCO_DTINI  := Ctod("  /  /    ")
			DCO->DCO_LOCAL  := ""
			DCO->DCO_ENDER  := ""
			DCO->DCO_FSCOD  := ""
			DCO->DCO_HRFIM	:= SubStr(Time(), 1, 5)
			DCO->DCO_DTFIM  := DDATABASE
			MsUnlock()

			VTAlert("Liberação do Unitizador " + AllTrim(c_CodAna) + " realizada com sucesso.", "Aviso")
		Endif
	End Transaction

	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret