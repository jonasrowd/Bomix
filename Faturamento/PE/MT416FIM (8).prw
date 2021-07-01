#Include "protheus.ch"
#Include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT416FIM  º Autor ³ Christian Rocha    º Data ³Novembro/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada acionado após o termino da efetivação do  º±±
±±º          ³ Orçamento de Venda.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bloqueia a arte caso o PV defina a situação da arte como   º±±
±±º          ³ nova ou alterada.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A T U A L I Z A C O E S                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ºANALISTA           ºALTERACOES                              º±±
±±º          º                   º                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function MT416FIM
	Local pMensagem := "" 

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
        E1_CLIENTE = %exp:M->C5_CLIENTE% AND
        E1_LOJA = %exp:M->C5_LOJACLI% AND
        SE1.%notDel% AND
		E1_TIPO = 'NF' AND 
        E1_VENCTO < %exp:DtoS(dDataBase)% AND 
        E1_BAIXA = ''
        
	EndSql

	If E1TEMP->(!Eof())
		M->C5_BXSTATU := 'B'
		M->C5_BLQ := 'B'
		pMensagem += " Este Cliente possui pendências financeiras com valor total somado: "+ Transform(E1TEMP->VALOR,PesqPict("SC6","C6_VALOR"))
	Else
		M->C5_BXSTATU := 'L'
		M->C5_BLQ := ''
	EndIf

	statusUpd() 

Return

Static Function statusUpd() 


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


Return 
