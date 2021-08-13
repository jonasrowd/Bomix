#INCLUDE 'TOTVS.ch'
#INCLUDE "tbiconn.ch"
#include "topconn.ch"

User Function FFATA003

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO 'FAT'

    
cQry := " SELECT DISTINCT C5_NUM FROM 
cQry += " SC5010 WHERE 
cQry += " C5_NUM IN (
cQry += " '062485',
cQry += " '062485'
cQry += " ) AND C5_FILIAL = '010101' 
cQry += " and C5_CLIENTE <> '001857'

TcQuery cQry NEW ALIAS 'TRB' 
dbSelectArea("SC5")
dbSetOrder(1)

while TRB->(!EOF())

    If SC5->(dbSeek("010101"+TRB->C5_NUM))
        cBx := 'E'

        RecLock("SC5",.F.)
		SC5->C5_BXSTATU := cBx
		If cBx = 'L' .OR. cBx = 'E'
			SC5->C5_LIBEROK := 'L'	
			SC5->C5_BLQ := ''		
		EndIf
		SC5->(MsUnlock())

		atuSC9(SC5->C5_NUM)

		dbSelectArea("Z07")
		RecLock("Z07",.T.)
			Z07->Z07_FILIAL := SC5->C5_FILIAL
			Z07->Z07_PEDIDO := SC5->C5_NUM
			Z07->Z07_JUSTIF := 'Liberada '+IIF(cBx = 'P','Produção','Venda')+' Usuário: '+RetCodUsr()
			Z07->Z07_DATA := dDataBase
			Z07->Z07_HORA := SUBSTRING(TIME(),1,5)
		MsUnlock()
        
    EndIf

    TRB->(dbSkip())
end

RESET ENVIRONMENT

Return

Static Function atuSC9(_cPed)

	TcSqlExec(" UPDATE SC9010 SET C9_BLCRED = '' WHERE C9_PEDIDO = '"+_cPed+"' AND D_E_L_E_T_ <> '*'" )

Return 
*/
