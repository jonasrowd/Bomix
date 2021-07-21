#Include "Totvs.ch"

/*/{Protheus.doc} FCADUSERS
A rotina FCADUSERS vai alimentar as tabelas de usuarios e grupos com informacoes do cadastro de usuarios.
@type function
@version 12.1.25
@author jonas.machado
@since 21/07/2021
@return variant, Null
/*/
User Function FCADUSERS()

	//STARTJOB("U_ATUSERS",GetEnvServer(),.T.,"01","01")
	U_ATUSERS("01","01")
Return()


/*/{Protheus.doc} ATUSERS
Função para atualizar os usuários do ambiente
@type function
@version 12.1.25
@author jonas.machado
@since 21/07/2021
@param c_Empresa, character, Empresa
@param c_Filial, character, Filial
@return variant, Null
/*/
Static Function ATUSERS(c_Empresa,c_Filial)

	Local cPatch
	Local aUsers
	Local aGroups   
	Local aMenusuario
	Local cQryDel
	Local cHoras
	Local c_Empresa
	Local c_Filial
	Local n_totusu
	Local aArray
	Local cGrupo
	c_Empresa='01'
	c_Filial='01'
	cGrupo=""

	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA c_Empresa FILIAL c_Filial TABLES "ZAL","ZAQ","ZAT","ZAS"

	IF SELECT("SM0") <> 0
		SM0->(DbCloseArea())
	ENDIF

	DbUseArea(.T.,"DBFCDX","\system\sigamat.emp","SM0", .T., .F.)

	//cPatch	:= GetMV("BO_SCHEDHR")
	cPatch	:= GetMV("MV_PATH_DI")
	//aUsers	:= FWSFALLUSERS()
	aGroups	:= AllGroups()
	aUsers2	:= AllUsers()
	aArray := PswRet()
	agruposteste := FWSFAllGrps()

	//aMenu := FWGrpMenu(cGroup)
	n_totusu := Len(aUsers2)


	cQryDel := "DELETE FROM "+RetSQLName("ZAL")
	TCSQLEXEC(cQryDel)

	cQryDel := "DELETE FROM "+RetSQLName("ZAQ")
	TCSQLEXEC(cQryDel)

	cQryDel := "DELETE FROM "+RetSQLName("ZAS")
	TCSQLEXEC(cQryDel)

	cQryDel := "DELETE FROM "+RetSQLName("ZAT")
	TCSQLEXEC(cQryDel)

	/*
	c_ZAL	:= RetSQLName("ZAL")
	c_ZAQ	:= RetSQLName("ZAQ")
	c_ZAT	:= RetSQLName("ZAT")
	c_ZAS	:= RetSQLNamåe("ZAS")
	*/

	DbSelectArea("ZAL")
	DbSetOrder(1)
	//	DbSeek(c_Filial+aUsers[n][2])
	/*
	IF ZAL->(Found())
	RecLock("ZAL",.F.)

	ELSE
	RecLock("ZAL",.T.)
	ENDIF
	*/
	//cPatch	:= GetMV("MV_PATH_DI")
	//aUsers	:= AllUsers()
	//aGroups	:= AllGroups()

	FOR n := 1 TO n_totusu
		RecLock("ZAL",.T.)

		IF RTRIM(aUsers2[n][1][1])<>""
			ZAL->ZAL_ID	:= aUsers2[n][1][1]				//Codigo do usuario
			ZAL->ZAL_USER 	:= aUsers2[n][1][2]				//Usuario de acesso
			ZAL->ZAL_NOME 	:= aUsers2[n][1][4]				//Nome completo
			ZAL->ZAL_ALT 	:= aUsers2[n][1][16]				//Data da ultima alteracao
			ZAL->ZAL_EMAIL	:= aUsers2[n][1][14]				//E-mail
			ZAL->ZAL_ACESSO:= aUsers2[n][1][15]				//Numero de acessos simultaneos
			ZAL->ZAL_BLQL   := IIF(aUsers2[n][1][17]=.T.,'1','2')				//Numero de acessos simultaneos 
			ZAL->ZAL_MAT 	:= Substr(aUsers2[n][1][22],7,8)	//Matricula
			ZAL->ZAL_FILIAL	:= Substr(aUsers2[n][1][22],1,6)	//Filial do usuario
		ENDIF
		ZAL->(MsUnlock())


		//NEXT n

		//"aUsers2[n][1][22]"	"01010101900005"	


		FOR nX := 1 TO Len(aUsers2[n][1][10])

			IF !Empty(aUsers2[n][1][10][nX])

				RecLock("ZAQ",.T.)

				ZAQ_ID		:= aUsers2[n][1][1]
				ZAQ_USER	:= aUsers2[n][1][2]
				ZAQ_GRUPO	:= aUsers2[n][1][10][nX]
				ZAQ->ZAQ_FILIAL	:= Substr(aUsers2[n][1][22],1,6)

				ZAQ->(MsUnlock())   
				//		cGrupo:=aUsers2[n][1][10][nX]
				//		aMenusuario :=FWGrpMenu(cGrupo)
			ENDIF

		NEXT nX
	NEXT n

	FOR nZ := 1 TO LEN(aGroups)

		cGrupo:=aUsers2[nZ][1][10][nZ]
		aMenusuario :=FWGrpMenu(cGrupo)


		//[nX][2])
		//????????????????????????
		//?Faz a busca dos modulos e menus do usuario  ?
		//????????????????????????
		nK := 1
		WHILE nK+LEN(cPatch)-1 < LEN(aMenusuario)
			IF UPPER(cPatch) # UPPER(aMenusuario[nK])
				IF "X" # LEFT(UPPER(aMenusuario[nK]),10)

					RecLock("ZAT",.T.)

					ZAT_GRUPO	:= aGroups[nX][1][1]
					ZAT_MODULO	:= Rtrim(SUBSTR(aMenusuario[nK],12,150) )//RTrim(aGroups[nX][2][nZ])
					ZAT_MENU	:= Rtrim(SUBSTR(aMenusuario[nK],12,150) )//RTrim(aGroups[nX][2][nZ])
					//	ZAT->ZAT_FILIAL	:= adminSubstr(aUsers2[n][1][22],1,6)

					ZAT->(MsUnlock())

				ENDIF
				EXIT
			ENDIF
			nK++
		ENDDO
	NEXT nZ	
	//NEXT nX
	//NEXT n

	DbSelectArea("ZAS")

	FOR nY := 1 TO LEN(aGroups)
		//(aGroups[nY][1][11])

		RecLock("ZAS",.T.)
		ZAS_FILIAL	:= c_Filial
		ZAS_GRUPO	:= aGroups[nY][1][1]
		ZAS_NOME	:= aGroups[nY][1][2]
		//	ZAS_EMPRES	:= Substr(aGroups[nX][1][11][nY],1,2)
		//	ZAS_FILIAL	:= Substr(aGroups[nX][1][11][nY],3,2)

		ZAS->(MsUnlock())

	NEXT nY

	RESET ENVIRONMENT

Return()


