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

	If nAtrasados <> 0 .AND. (!estaLib(SC5->C5_NUM))

		If !__CUSERID$(c_UserLib) 
		
		If Select("E1TEMP") > 0
			E1TEMP->(dbCloseArea())
		Endif

		BeginSql alias 'E1TEMP'
        column E1_EMISSAO as Date
        column E1_VENCREA  as Date

        SELECT 

        sum(E1_VALOR) VALOR

        FROM %table:SE1% SE1

        WHERE 
        E1_SALDO > 0 AND 
        E1_CLIENTE = %exp:SC5->C5_CLIENTE% AND
        E1_LOJA = %exp:SC5->C5_LOJACLI% AND
        SE1.%notDel% AND
		E1_TIPO = 'NF' AND 
        E1_VENCREA < %exp:DtoS(dDataBase)% AND 
        E1_BAIXA = ''
        
		EndSql

		EndIf

		l_Ret := .F.

	EndIf

return l_Ret


 /*/{Protheus.doc} pesqLib
	(long_description)
	@type  Function
	@author Rômulo Ferreira
	@since 13/07/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, , return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function estaLib(_cPed)
Default _cPed := ""

DbSelectArea("Z07")
DbSetOrder(1)

If dbSeek( SC5->C5_FILIAL + SC5->C5_NUM )

	While Z07->(!Eof()) .AND.  SC5->C5_NUM  = Z07->Z07_PEDIDO 

		If 'Venda' $ Z07->Z07_JUSTIF
			Return .T.
		EndIf

		Z07->(dbSkip())
	EndDo

EndIf
	
Return .F.

