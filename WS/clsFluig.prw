#INCLUDE "TOTVS.CH"

Class clsFluig

	Method New() CONSTRUCTOR
	Method mtdArrayToByte( c_Arquivo )
	Method mtdCancelaProcesso( n_NumProc, c_User, c_TextCancel, c_UserFluig, c_PwsFluig, n_Empresa )
	Method mtdPegaSX6( c_Param )

EndClass

Method New() Class clsFluig

Return()

Method mtdCancelaProcesso( n_NumProc, c_User, c_TextCancel, c_UserFluig, c_PwsFluig, n_Empresa ) Class clsFluig

	Local c_Retorno		:= ""
	Private oServico	:= WSECMWorkflowEngineServiceService():New()

	//Cancelamento dos processos que foram abertos anteriormente
	if oServico:cancelInstance( c_UserFluig, c_PwsFluig, n_Empresa, n_NumProc, Alltrim( c_User ), c_TextCancel )
		if oServico:cresult <> "OK"
			c_Retorno	:= "1. Falha no Fluig ->"+ oServico:cresult
		else
			c_Retorno	:= "2. Processo " + Alltrim( Str( n_NumProc ) ) + " cancelado com sucesso!!!"
		endif
	else
		c_Retorno	:= "3. Erro de Execução ->" + GetWSCError()
	endif

Return( c_Retorno )

Method mtdArrayToByte( c_Arquivo ) Class clsFluig

	Local n_Buffer		:= 0
	Local n_Size		:= 0
	Local n_Read		:= 0
	Local c_Buffer		:= ""
	Local c_FileContent	:= 0

	n_Buffer := Fopen( c_Arquivo,0 )
	If n_Buffer == -1
		Return .F.
	Endif

	n_Size := fSeek( n_Buffer, 0, 2 )

	fSeek(n_Buffer,0)

	// Aloca buffer para ler o arquivo do disco
	// e le o arquivo para a memoria
	c_Buffer 	:= space( n_Size )
	n_Read		:= fRead( n_Buffer, @c_Buffer, n_Size )

	// e fecha o arquivo no disco
	fClose( n_Buffer )

Return ( c_Buffer )

Method mtdPegaSX6( c_Param ) Class clsFluig


Return( GetMV( c_Param ) )