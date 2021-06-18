#include 'protheus.ch'
#include 'parmtype.ch'

user function MTALCALT()
	Local cObs := CN9->CN9_OBJCTO
	
	ALERT ('MTALCALT')
	
	RecLock("SCR", .F.)
    SCR->CR_OBS := posicione('CN9',1,xFilial('CN9')+cObs,'CR_OBS')  
    MsUnLock()

return