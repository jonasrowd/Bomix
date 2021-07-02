#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} FFATA001
    (long_description)
    @type  Function
    @author user
    @since 03/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see Job para manutenção dos status dos pedidos de vendas
    /*/
User Function FFATA001()

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010101'

If Select("C5TEMP") > 0
    C5TEMP->(dbCloseArea())
Endif

BeginSql alias 'C5TEMP'
    SELECT 

    DISTINCT
    C5_FILIAL FILIAL, C5_NUM NUM

    FROM 

    SC5010 C5 

    INNER JOIN SC6010 C6 ON 
    C5_FILIAL = C6_FILIAL AND 
    C5_NUM = C6_NUM AND 
    C6.D_E_L_E_T_ <> '*'

    WHERE 
    C5.D_E_L_E_T_ <> '*'   AND 
    C6_QTDENT < C6_QTDVEN  AND 
    C5_NOTA = ''  AND C6_NUMORC <> '' 
    AND C5_LIBEROK <> 'E'

EndSql

While C5TEMP->(!Eof())

    DBSelectArea("SC5")
    DBSetOrder(1)
    dbSeek(C5TEMP->FILIAL+C5TEMP->NUM)

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
    C5TEMP->(dbSkip())
EndDo

RESET ENVIRONMENT

Return
