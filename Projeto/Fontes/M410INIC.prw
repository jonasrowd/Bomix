/*/{Protheus.doc} M410INIC
(long_description)
@type  Function
@author Romulo Ferreira
@since 26/03/2021
@version version
@param , ,
@return nil, ,
@example
(examples)
@see (links_or_references)
    /*/
User Function M410INIC()

	If IsInCallStack("MATA416") 

        If Select("E1TEMP") > 0
            E1TEMP->(dbCloseArea())
        Endif

    BeginSql alias 'E1TEMP'
        column E1_EMISSAO as Date
        column E1_VENCTO  as Date

        SELECT 

        E1_NUM,
        E1_EMISSAO,
        E1_VENCTO,
        E1_VALOR, 
        E1_HIST 

        FROM %table:SE1% SE1

        WHERE 
        E1_SALDO > 0 AND 
        E1_CLIENTE = %exp:M->C5_CLIENTE% AND
        E1_LOJA = %exp:M->C5_LOJACLI% AND
        SE1.%notDel% AND
        E1_TIPO = 'NF' AND 
        E1_VENCTO < %exp:DtoS(dDataBase)%
        ORDER BY E1_VENCTO ASC
        EndSql

        If E1TEMP->(!Eof())
        M->C5_BXSTATU := 'B'
        M->C5_BLQ := 'B'
        EndIf
	EndIf
Return nil
