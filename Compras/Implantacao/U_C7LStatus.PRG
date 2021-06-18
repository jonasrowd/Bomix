#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
User Function C7LStatus()

	Local cC7DLStatus

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

		ChkFile( "SC7" )
		While SC7->( !Eof() )
	
			//Obtenho a Descricao do Status
			cC7DLStatus := StaticCall( U_MT120COR , GetC7Status )
			
			//Direciono a Saida para o Console do Server
			ConOut( cC7DLStatus )
			
			SC7->( dbSkip() )	
		
		End While
		
	RESET ENVIRONMENT		

Return( NIL )