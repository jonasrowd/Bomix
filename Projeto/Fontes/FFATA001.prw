#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} FFATA001
    (long_description)
   @type  Function
   @author R�mulo Ferreira
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
    AND C5_LIBEROK <> 'E' // AND C6_BLQ<>'R' ACRESCENTAR O CAMPO DE RES�DUO COMO FILTRO

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

    lAtualiza := .T.
    dbSelectArea("Z07")
    dbSetOrder(1)
    If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
        While Z07->(!Eof()) .AND. Z07->Z07_PEDIDO = SC5->C5_NUM
            If 'Venda' $ Z07->Z07_JUSTIF .OR. 'Produ' $ Z07->Z07_JUSTIF 
                lAtualiza := .F.
            EndIf
            Z07->(dbSkip())
        EndDo

    EndIf

    If lAtualiza

        RecLock("SC5",.F.)
        If E1TEMP->(VALOR) != 0
            SC5->C5_BXSTATU := 'B'
            SC5->C5_BLQ := 'B'
            //VERIFICAR SE N�O DEVERIA COLOCAR O CAMPO C5_LIBEROK COMO S TAMB�M;
        Else
            SC5->C5_BXSTATU := 'L'
            SC5->C5_BLQ := ''
            SC5->C5_LIBEROK = 'L'
        EndIf
        MsUnlock()
    EndIf
    
    C5TEMP->(dbSkip())
EndDo

RESET ENVIRONMENT

Return
