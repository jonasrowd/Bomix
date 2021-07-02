#include 'protheus.ch'
#include 'parmtype.ch'

user function OBSBLOQ()

  Local cOBS := M->CNE_OBS
     
   IF !EMPTY(CNE->CNE_OBS)

     DbSelectArea("SC7")

          RecLock("SC7", .F.)
          SC7->C7_OBS := cOBS
          MsUnLock()
     ENDIF
	
return(cOBS)