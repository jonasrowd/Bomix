#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MAAVCRED
Ponto de Entrada para validação das retrições financeiras dos clientes, na Análise de Crédito Customizada dos Pedidos  
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_MAAVCRED()
/*/

user function MAAVCRED()

Local c_UserLib := GETMV("BM_USERLIB")
Local l_Ret := .T.
nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
cNome := SA1->A1_NOME

	If nAtrasados <> 0

		If !__CUSERID$(c_UserLib)
		
		If Select("E1TEMP") > 0
			E1TEMP->(dbCloseArea())
		Endif

		BeginSql alias 'E1TEMP'
        column E1_EMISSAO as Date
        column E1_VENCTO  as Date

        SELECT 

        sum(E1_VALOR) VALOR

        FROM %table:SE1% SE1

        WHERE 
        E1_SALDO > 0 AND 
        E1_CLIENTE = %exp:SC5->C5_CLIENTE% AND
        E1_LOJA = %exp:SC5->C5_LOJACLI% AND
        SE1.%notDel% AND
		E1_TIPO = 'NF' AND 
        E1_VENCTO < %exp:DtoS(dDataBase)% AND 
        E1_BAIXA = ''
        
		EndSql

		RecLock("SC5",.F.)
		If E1TEMP->(!Eof())
			SC5->C5_BXSTATU := 'B'
			SC5->C5_BLQ := 'B'
		Else
			SC5->C5_BXSTATU := 'L'
			SC5->C5_BLQ := ''
		EndIf
		MsUnlock()

		EndIf

		l_Ret := .F.

	EndIf

return l_Ret
