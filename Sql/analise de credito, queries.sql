SELECT CJ_BXSTATU,CJ_STATUS, * FROM SCJ010 WHERE CJ_NUM='359557'


/*
CJ_BXSTATU, CJ_STATUS
L,B VERMELHO ORCAMENTO BAIXADO 
B,B AZUL CLARO OR�AMENTO BAIXADO COM RESTRI��ES FINANCEIRAS
B,A OR�AMENTO BLOQUEADO POR RESTRI��O FINANCEIRA
'',A OR�AMENTO ABERTO
L,A OR�AMENTO ABERTO QUE PASSOU PELO LIBERA��O
*/

SELECT isnull(sum(SE1.E1_SALDO),0) as SALDO FROM SE1010 SE1 
WHERE SE1.D_E_L_E_T_ <> '*' 
AND SE1.E1_CLIENTE = '000004' 
AND SE1.E1_LOJA = '01' 
AND E1_VENCREA < '20210809' 
AND SE1.E1_SALDO > 0 AND E1_TIPO = 'NF' AND E1_VENCREA >= '20210101'
AND SE1.E1_SALDO <> SE1.E1_JUROS


SELECT C5_LIBEROK, C5_BLQ, C5_BXSTATU,C5_NOTA, C5_FSSTBI,C5_EMISSAO,* FROM SC5010 C5
	INNER JOIN SC6010 C6 ON
    C5_FILIAL = C6_FILIAL AND
    C5_NUM = C6_NUM 
WHERE C5_NUM ='067164'

	SELECT C6_NOTA,* FROM SC6010 WHERE C6_NUM='067164'
SELECT DISTINCT C5_LIBEROK FROM SC5010
SELECT Z07_PEDIDO,* FROM Z07010 WHERE Z07_PEDIDO='067164'

select * FROM SC9010 WHERE C9_PEDIDO='067164'

 SELECT E1_PEDIDO FROM SE1010 SE1
        WHERE
        E1_SALDO > 0 AND
        SE1.D_E_L_E_T_='' AND
        E1_TIPO = 'NF' AND
        E1_VENCREA >= '20210701' AND
        E1_VENCREA < '20210809' AND
        E1_SALDO <> E1_JUROS AND E1_CLIENTE IN (
    SELECT C5_CLIENT FROM SC5010 C5
	INNER JOIN SC6010 C6 ON
    C5_FILIAL = C6_FILIAL AND
    C5_NUM = C6_NUM 

    WHERE
    C5.D_E_L_E_T_ <> '*'   AND
    C6.D_E_L_E_T_ <> '*' AND
    C6_QTDENT < C6_QTDVEN  AND
    (C5_NOTA = '' OR C5_NOTA LIKE '%X%') AND
    C6_NUMORC <> '' AND
    C5_LIBEROK <> 'E'  AND
    C6_BLQ<>'R')

    SELECT C6_QTDENT, C6_QTDVEN,C5_LIBEROK, C5_BLQ, C5_BXSTATU,C5_NOTA, C5_FSSTBI,C5_EMISSAO,* FROM SC5010 C5
	INNER JOIN SC6010 C6 ON
    C5_FILIAL = C6_FILIAL AND
    C5_NUM = C6_NUM 
    WHERE
    C5.D_E_L_E_T_ <> '*'   AND
    C6.D_E_L_E_T_ <> '*' AND
    C6_QTDENT <	C6_QTDVEN  AND C6_QTDENT >	0 AND
    (C5_NOTA = '' OR C5_NOTA LIKE '%X%') AND
    C6_NUMORC <> '' AND
    C5_LIBEROK <> 'E'  AND
    C6_BLQ<>'R' AND C5_EMISSAO>'20210101'