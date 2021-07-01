#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"


User Function FISEXPNFE()
	Local cXML 		:= PARAMIXB[1]
	If !Empty(cXML)                                	
		msgalert("Ponto de Entrada FISEXPNFE XML Gerado - > " + cXML )	
	Else	
		msgalert("Ponto de Entrada FISEXPNFE sem XML para exportação")
	EndIF	
Return Nil