#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MA415COR
Ponto de Entrada para inclusão de novas cores de legendas na tela de orçamentos SIGAFAT
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MA415COR()
/*/

user function MA415COR()
Local aCor := aclone(PARAMIXB)


aCor[1]:= {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_BXSTATU<>'B'" , "ENABLE"    }
aCor[2]:= {"SCJ->CJ_STATUS=='B' .AND. SCJ->CJ_BXSTATU<>'B'" , "DISABLE"   }

AADD(aCor,{"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_BXSTATU=='B'" , "BR_PINK"   })
AADD(aCor,{"SCJ->CJ_STATUS=='B' .AND. SCJ->CJ_BXSTATU=='B'" , "BR_AZUL_CLARO"   })
	
return aCor