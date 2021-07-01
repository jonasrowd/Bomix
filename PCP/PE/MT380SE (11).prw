#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT380SE()
	Local aArea1       := GetArea()
	
	Local lMT380SE := .F. //Customizações do usuário

	RestArea(aArea1)
Return(lMT380SE) 