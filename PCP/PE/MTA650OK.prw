#Include 'Totvs.ch'

/*/{Protheus.doc} MTA650OK
	Ponto de entrada antes de gerar as Op's intermedi�rias e Sc's. � utilizado para inibir o di�logo confirmando a cria��o dessas Op's e Sc's.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/08/2021
	@return logical, Gera Op's Intermedi�rias e Sc's.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6089305
/*/
User Function MTA650OK()

Conout("MTA650OK PASSOU AQUI.")

Return .T.
