#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

WSSERVICE WSFABRICA Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;•<span style='color:red;'> WS com estruturas padrões da Fábrica de Software.</span>"

	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca

ENDWSSERVICE

WSSTRUCT strEmpresa

	WSDATA c_Empresa 	AS STRING
	WSDATA c_Filial		AS STRING

ENDWSSTRUCT

WSSTRUCT strRetorno

	WSDATA l_Status 	AS BOOLEAN
	WSDATA c_Mensagem	AS STRING

ENDWSSTRUCT

WSSTRUCT strSeguranca

	WSDATA c_Usuario	AS STRING
	WSDATA c_Senha 		AS STRING

ENDWSSTRUCT
