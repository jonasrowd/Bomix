#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.CH'
#include "rwmake.ch"




//
// P.E. executado antes da geracao das OP's    ?
//
user function MTA650POK()

Local cAliaSC6 := PARAMIXB[1]
Local cMarcaC6 := PARAMIXB[2]
Local lRet := .T.

SC6->(dbGoTop())

while SC6->(!Eof())
    If cMarcaC6 = (cAliaSC6)->C6_OK
        dbSelectArea("SC5")
        dbSetOrder(1)
        dbSeek(SC6->C6_FILIAL+SC6->C6_NUM)

        If SC5->C5_BXSTATU <> 'L' .AND. SC5->C5_BXSTATU <> 'P'
            MsgStop("Pedido com bloqueio financeiro. Por favor solicitar liberação aos responsáveis.")
            Return .F.
        EndIf
    EndIf
    SC6->(dbSkip())
end
	
return lRet





	