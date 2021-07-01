#INCLUDE "PROTHEUS.CH"
/*/
	Funcao:		MT120LEG
	Autor:		Marinaldo de Jesus
	Descricao:	Implementacao do Ponto de Entrada MT120LEG executado na funcao A120Legenda
				do programa MATA120 para adicionar novos elementos na Legenda
/*/
User Function MT120LEG()
	
	Local aLegend	:= ParamIxb[1]	////Obtenho a Legenda padrao

	//Testo o Tipo
	IF !( ValType( aLegend ) == "A" )
		aLegend := {}
	EndIF

	/*/
		Se necessario, adiciono novos elementos aa Legenda Padrao
		
		aAdd( aLegend , { "RNPSOLICITACNT_16"	, OemToAnsi( "Solicitação de Contrato" ) } )
		aAdd( aLegend , { "RNPADITIVOCNT_16"	, OemToAnsi( "Solicitação de Aditivo"  ) } )
		aAdd( aLegend , { "BPMSDOCA_16"			, OemToAnsi( "Bloqueado por Contrato"  ) } )
		aAdd( aLegend , { "CADEADO_16"			, OemToAnsi( "Bloqueado por Orçamento" ) } )
	
	/*/	

	//Verifico se estou querendo, apenas, as informacoes da Legenda
	IF IsInCallStack( "GetC7Status" )
		//"Roubo"/Recupero as Informacoes da Legenda de Cores
		__aLegend_ := aLegend
		//Forco o Erro
		UserException( "IGetC7Status" )
	EndIF

Return( aLegend )