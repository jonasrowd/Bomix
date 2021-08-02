#INCLUDE "TOTVS.ch"

/*/{Protheus.doc} NATU01
	Relatório Natureza
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 31/07/2021
	@return variant, Nil
/*/
User Function NATU01()

	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := "NATU01"

	Pergunte(cPerg,.F.)
	ReportDef()
	oReport:PrintDialog()

Return Nil

/*/{Protheus.doc} ReportDef
	Corpo do relatório
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 31/07/2021
	@return variant, Nil
/*/
Static Function ReportDef()

	oReport := TReport():New("Natureza Pagamento","Relatorio - Natureza Pagamento", ;
	cPerg,{|oReport| PrintReport(oReport)},"Natureza Pagamento")
	oReport:SetLandscape(.T.)
	oSecCab := TRSection():New( oReport , "NATUREZA", {"SQL"} )

	TRCell():New( oSecCab, "CAST(E5_DTDISPO AS DATE) AS DATA", "SE5")
	TRCell():New( oSecCab, "DATENAME(MONTH,E5_DTDISPO)", "SE5")
	TRCell():New( oSecCab, "RTRIM(E5_NATUREZ) AS NATUREZA", "SE5")
	TRCell():New( oSecCab, "RTRIM(ED_DESCRIC) AS DESCRIÇÃO", "SE5")
	TRCell():New( oSecCab, "CASE WHEN E5_RECPAG = 'P' THEN SUM(E5_VALOR)/-1 ELSE SUM(E5_VALOR) END AS TOTAL", "SE5")
	TRCell():New( oSecCab, "E5_BANCO", "SE5")
	TRCell():New( oSecCab, "E5_VLJUROS", "SE5")
	TRCell():New( oSecCab, "E5_CLIENTE", "SE5")
	TRCell():New( oSecCab, "E5_FORNECE", "SE5")
	TRCell():New( oSecCab, "E5_RECPAG", "SE5")

Return Nil

/*/{Protheus.doc} PrintReport
	Imprime o relatório em TReport
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 31/07/2021
	@param oReport, object, Dados do relatório
	@return variant, Nil
/*/
Static Function PrintReport(oReport)
	Local cAlias := GetNextAlias()

	oSecCab:BeginQuery()
		
	BeginSql Alias cAlias
			
	SELECT 
	CAST(E5_DTDISPO AS DATE) AS DATA,
	DATENAME(MONTH,E5_DTDISPO),
	RTRIM(E5_NATUREZ) AS NATUREZA,
	RTRIM(ED_DESCRIC) AS DESCRIÇÃO,
	CASE
		WHEN E5_RECPAG = 'P' 
			THEN SUM(E5_VALOR)/-1 
				ELSE SUM(E5_VALOR)
					END 
						AS TOTAL,
	E5_BANCO AS BANCO,
	E5_VLJUROS,
	E5_CLIENTE,
	E5_FORNECE,
	E5_RECPAG,
	SE5.R_E_C_N_O_
	FROM 
	%table:SE5% SE5(NOLOCK),
	%table:SED% SED(NOLOCK)
	WHERE
	E5_NATUREZ=ED_CODIGO
	AND E5_DTDISPO  BETWEEN '20210101' AND '20211201'
	AND E5_TIPODOC NOT IN ('DC','ES')
	AND E5_TIPO<>'NDF'
	//AND E5_RECONC='x' 
	AND E5_VALOR>'0'
	//AND E5_BANCO IN('341','CX3','PRE')
	AND E5_SITUACA<>'C'
	AND SE5.%notDel% 
	AND SED.%notDel% 
	AND   E5_DTDISPO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
	GROUP BY E5_NATUREZ,E5_NUMERO,ED_DESCRIC,E5_VALOR,E5_DTDISPO,E5_BANCO,E5_VLJUROS,E5_CLIENTE,E5_FORNECE,E5_RECPAG,SE5.R_E_C_N_O_,E5_DTDISPO

	EndSql	
		
	oSecCab:EndQuery()
	oSecCab:Print()

	(cAlias)->(DbCloseArea())
	
Return Nil
