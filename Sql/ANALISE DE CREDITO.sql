SELECT E1_SALDO,E1_VENCREA,E1_JUROS,E1_PEDIDO,E1_NOMCLI,*
FROM SE1010 SE1
WHERE
E1_SALDO > 0 AND
SE1.D_E_L_E_T_='' AND
E1_TIPO = 'NF' AND
E1_VENCREA >= '20200101' AND
E1_VENCREA < '20210824' AND
E1_SALDO <> E1_JUROS AND
D_E_L_E_T_=''
AND E1_CLIENTE IN (
     SELECT
DISTINCT 
    C5_CLIENT
    FROM
    SC5010 C5
    INNER JOIN SC6010 C6 ON
    C5_FILIAL = C6_FILIAL AND
    C5_NUM = C6_NUM AND
    C6.D_E_L_E_T_ <> '*'
    WHERE
    C5.D_E_L_E_T_ <> '*'   AND
    C6_QTDENT = '0' AND
    C5_NOTA = '' AND
    C6_NOTA = '' AND
    C6_NUMORC <> '' AND
    C5_LIBEROK <> 'E'  AND
    C6_BLQ<>'R' 
	AND C5_NUM NOT IN (SELECT DISTINCT Z07_PEDIDO FROM Z07010)
	) 
	
--BLOQUEIA PARCIAL--
--UPDATE SC5010 SET C5_LIBEROK='E', C5_BXSTATU='' WHERE C5_NUM IN (SELECT DISTINCT C6_NUM FROM SC6010 WHERE SC6010.D_E_L_E_T_='' AND C6_QTDVEN>C6_QTDENT AND C6_QTDENT>0 AND C6_BLQ<>'R' AND C6_NOTA <>'' AND C6_FILIAL ='010101') AND C5_FILIAL='010101'
--LIBERA PARCIAL--
--UPDATE SC5010 SET C5_LIBEROK='', C5_BXSTATU='A', C5_FSSTBI='PARCIAL' WHERE C5_NUM IN (SELECT DISTINCT C6_NUM FROM SC6010 WHERE SC6010.D_E_L_E_T_='' AND C6_QTDVEN>C6_QTDENT AND C6_QTDENT>0 AND C6_NUMORC<>'' AND C6_BLQ<>'R' AND C6_FILIAL ='010101' AND D_E_L_E_T_='') AND C5_FILIAL='010101' AND C5_NOTA='' AND SC5010.D_E_L_E_T_=''
--UPDATE INDIVIDUAL PARA STATUS 
--UPDATE SC5010 SET C5_LIBEROK='', C5_BXSTATU='A', C5_FSSTBI='PARCIAL' WHERE C5_NUM ='062161' AND C5_FILIAL='010101'

SELECT C6_NOTA,C6_BLQ, C6_DATFAT, * FROM SC6010 WHERE C6_NUM ='067295'

SELECT C5_NOTA,C5_LIBEROK,C5_BXSTATU, C5_BLQ,C5_FSSTBI,* FROM SC5010 WHERE C5_NUM ='067295'
SELECT C5_LIBEROK,R_E_C_N_O_, C5_NOTA,C5_BXSTATU, C5_BLQ, C5_FSSTBI,* FROM SC5010  WHERE C5_NUM IN (SELECT DISTINCT C6_NUM FROM SC6010 WHERE SC6010.D_E_L_E_T_='' AND C6_QTDVEN>C6_QTDENT AND C6_QTDENT>0 AND C6_NUMORC<>'' AND C6_BLQ<>'R' AND C6_FILIAL ='010101' AND D_E_L_E_T_='') AND C5_FILIAL='010101' AND C5_NOTA='' AND SC5010.D_E_L_E_T_='' AND C5_LIBEROK='E'
SELECT  C6_NUM,* FROM SC6010 WHERE SC6010.D_E_L_E_T_='' AND C6_QTDENT>0 AND C6_BLQ<>'R' AND C6_NOTA <>'' AND C6_FILIAL ='010101' AND C6_NUM='062161'



    SELECT
	C5_NOTA,C5_LIBEROK,C5_BXSTATU, C5_BLQ,C5_FSSTBI,C6_QTDENT, C6_QTDVEN,*
    FROM
    SC5010 C5
    INNER JOIN SC6010 C6 ON
    C5_FILIAL = C6_FILIAL AND
    C5_NUM = C6_NUM AND
    C6.D_E_L_E_T_ <> '*'
    WHERE
    C5.D_E_L_E_T_ <> '*'   AND
    C6_QTDENT = '0' AND
    C5_NOTA = '' AND
    C6_NOTA = '' AND
    C6_NUMORC <> '' AND
    C5_LIBEROK <> 'E'  AND
    C5_FILIAL = '010101' AND 
    C6_FILIAL = '010101' AND 
    C6_BLQ<>'R' 

000149	01	CITROLIFE           
000502	01	LUZTOL QUIMICA      
002347	01	IMPORT FOODS        
000502	01	LUZTOL QUIMICA      
003062	01	QUALLY TREND        
003132	01	PINECO PINTURAS ECOL

--UPDATE SC5010 SET C5_LIBEROK='', C5_BXSTATU='A',C5_BLQ='', C5_FSSTBI='PARCIAL' WHERE C5_NUM IN (
    SELECT
	--DISTINCT C5_NUM
	C5_NOTA,C5_LIBEROK,C5_BXSTATU, C5_BLQ,C5_FSSTBI,C6_QTDENT, C6_QTDVEN,*
    FROM
    SC5010 C5
    INNER JOIN SC6010 C6 ON
    C5_FILIAL = C6_FILIAL AND
    C5_NUM = C6_NUM AND
    C6.D_E_L_E_T_ <> '*'
    WHERE
    C5.D_E_L_E_T_ <> '*'   AND
    C6_QTDENT < C6_QTDVEN AND
    C5_NOTA = '' AND
    C6_NOTA <> '' AND
    C6_NUMORC <> '' AND
    C5_LIBEROK <> 'E'  AND
    C5_FILIAL = '010101' AND 
    C6_FILIAL = '010101' AND 
    C6_BLQ<>'R'
	)
	AND C5_FILIAL='010101' AND D_E_L_E_T_=''



	SELECT * FROM SD1010 WHERE D1_FORNECE='000073' AND D1_DOC='000008992'
    SELECT * FROM SF3010 WHERE F3_NFISCAL='000008992' AND F3_CLIEFOR='000073'
	SELECT * FROM SF1010 WHERE F1_DOC='000008992' AND F1_FILIAL ='020101' ORDER BY R_E_C_N_O_ DESC