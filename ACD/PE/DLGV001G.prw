#Include "Totvs.ch"
#Include "Apvt100.ch"

/*/{Protheus.doc} DLGV001G
	Este Ponto de Entrada é executado em dois momentos distintos: Um deles é exatamente antes da execução da atividade.
	O outro é exatamente após a execução da atividade.
	@type function
	@version  12.1.25
	@author Jonas Machado
	@since 20/07/2021
	@return variant, Null
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=614932850
/*/
User Function DLGV001G()

	Local c_FunExe := PARAMIXB[1]
	Local l_Ret    := .F.

	If Upper(c_FunExe) == "DLENDERECA()" .And. SDB->DB_STATUS == '1'
		While l_Ret == .F.
			l_Ret := U_FACDA001()
		End
	Elseif Upper(c_FunExe) == "DLTRANSFER()" .And. SDB->DB_STATUS == '1'
		While l_Ret == .F.
			l_Ret := U_FACDA003()
		End
	Elseif (Upper(c_FunExe) == "DLAPANHE()" .Or. Upper(c_FunExe) == "DLAPANHEC1()" /* .Or. Upper(c_FunExe) == "DLAPANHEC2()" .Or. Upper(c_FunExe) == "DLAPANHEVL()" */) .And. SDB->DB_STATUS == '1'
		While l_Ret == .F.
			l_Ret := U_FACDA006()
		End

	/*Elseif Upper(c_FunExe) == "DLCROSSDOC()" .And. SDB->DB_STATUS == '1'
		While l_Ret == .F.
			l_Ret := U_FACDA003()
		End*/

	EndIf

Return Nil
