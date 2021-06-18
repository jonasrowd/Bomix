// PONTO DE ENTRADA PARA BLOQUEAR ACESSO A DADOS  DE PEDIDOS DIVERSOS

User Function MC050CNT()
Local cProd := ParamIXB  
Local c_Users := Getmv("MV_DADOSPD") 

If __CUSERID $ c_Users
	 aRet := {.T.,.T.,.T.}
Else
    aRet := {.F.,.F.,.F.}
    Alert("Usuario sem acesso a essa rotina - Consulte o Administrador do Sistema!!")
endif    
Return(aRet)  
          
