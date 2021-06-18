#include 'protheus.ch'
#include 'rwmake.ch'

/*{Protheus.doc} F060BOR
Ponto de Entrada para utilizado para gerar o numero do proximo bordero com base no parâmetro MV_NUMBORR
@author Elmer Farias
@since 22/10/20
@version 1.0
	@example
	u_F060BOR()
/*/

User Function F060BOR
Local	_cNumBor := ""
Public _cNumNhoca

DbSelectArea("SE1")
DbSetOrder(1)

  	_cNumBor := Soma1(SUPERGETMV("MV_NUMBORR"),6)
	_cNumBor := Replicate("0",6-Len(Alltrim(_cNumBor)))+Alltrim(_cNumBor)   
	
	While !MayIUseCode("SE1"+_cNumBor) //verifica se esta na memoria, sendo usado 
	//busca o proximo numero disponivel 
	  _cNumBor := Soma1(_cNumBor)
	EndDo
	
	_cNumNhoca := _cNumBor

Return(_cNumBor)