#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT380SE()
	Local aArea1       := GetArea()
	
	Local lMT380SE := .F. //Customiza��es do usu�rio

	RestArea(aArea1)
Return(lMT380SE) 