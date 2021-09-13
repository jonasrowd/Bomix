SELECT
E1.E1_NUM
,C5.C5_NUM
, A1.A1_COD 
, A1.A1_NOME
, A1.A1_LOJA  
, C5.C5_EMISSAO
, E1.E1_EMISSAO
, E1.E1_VENCTO
, A1.A1_OK
FROM SA1010 A1
LEFT JOIN SE1010 E1 
ON  LEFT (E1.E1_FILIAL,4) = A1.A1_FILIAL    
AND E1.E1_CLIENTE = A1.A1_COD  
AND E1.E1_LOJA = A1.A1_LOJA
AND E1.D_E_L_E_T_ <> '*'
LEFT JOIN SC5010 C5
ON  C5.C5_FILIAL = E1.E1_FILIAL  
AND C5.C5_CLIENTE = E1.E1_CLIENTE  
AND C5.C5_LOJACLI = E1.E1_LOJA
AND C5.C5_NUM = E1.E1_PEDIDO
AND C5.D_E_L_E_T_ <> '*'
LEFT JOIN SC6010 C6
ON C6.C6_FILIAL = C5.C5_FILIAL 
AND C6.C6_NUM = C5.C5_NUM
AND C6.C6_CLI = C5.C5_CLIENTE    
AND C6.C6_LOJA = C5.C5_LOJACLI   
AND C6.D_E_L_E_T_ <> '*'
LEFT JOIN SCJ010 CJ
ON  CJ.CJ_FILIAL = C6.C6_FILIAL  
AND CJ.CJ_LOJA = C6.C6_LOJA
AND CJ.CJ_CLIENT = C6.C6_CLI
AND CJ.CJ_NUM = C6.C6_NUMORC
AND  CJ.D_E_L_E_T_ <> '*'
 WHERE EXISTS (
SELECT MAX(C51.C5_EMISSAO)
FROM  SC5010 C51
WHERE C51.C5_CLIENTE = E1.E1_CLIENTE  
 AND   C51.C5_LOJACLI = E1.E1_LOJA     
 AND   C51.C5_EMISSAO <= E1.E1_EMISSAO   
 AND   C51.C5_FILIAL = E1.E1_FILIAL   
 AND   C51.D_E_L_E_T_ <>'*')
 AND E1.E1_BAIXA = ' '
 OR E1.E1_STATUS = 'A'
 AND C5.C5_NOTA = ' '
 AND C6.C6_NOTA = ' '
 AND A1.D_E_L_E_T_ <> '*'
 AND CJ.CJ_STATUS IN ('C','D')
 AND A1.A1_MSBLQL <> '1'
 AND A1.A1_COD BETWEEN '000001' AND '002083'
 AND A1.A1_ULTCOM BETWEEN '20150601' AND '20200827'
GROUP BY 
E1.E1_NUM
,C5.C5_NUM
,A1.A1_COD
,A1.A1_NOME
,A1.A1_LOJA
,C5.C5_EMISSAO
,E1.E1_EMISSAO
,E1.E1_VENCTO
,A1.A1_OK  


SELECT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI FROM SC5010 WHERE C5_NOTA = ' '
SELECT C6_FILIAL,C6_NUM,C6_CLI,C6_LOJA,C6_D FROM SC6010 WHERE C6_NOTA = ' '

SELECT C5_NUM,E1_NUM,C5_EMISSAO,E1_EMISSAO,E1_VENCTO 
FROM SC5010 C5
LEFT JOIN SE1010 E1 
ON  E1.E1_FILIAL = C5.C5_FILIAL   
AND E1.E1_CLIENTE = C5.C5_CLIENTE  
AND E1.E1_LOJA = C5.C5_LOJACLI 
AND E1.E1_PEDIDO = C5.C5_NUM 
AND E1.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*' AND E1_CLIENTE = '001031'


027808	000034897	000655	BOMIX INDUSTRIA DE EMBALAGENS LTDA      	01	20200416	20200416	20200516

AND E1_EMISSAO IN (
SELECT MAX(E1_EMISSAO)  
FROM  SE1010 (NOLOCK) 
WHERE E1_EMISSAO >= C5_EMISSAO
AND E1_CLIENTE = C5.C5_CLIENTE
AND E1_LOJA    = C5.C5_LOJACLI
AND E1.E1_BAIXA = ' ' 
OR E1.E1_STATUS = 'A'
AND D_E_L_E_T_ <>'*' )

SELECT CND_PEDIDO, * FROM CND010 WHERE CND_CONTRA = '000000000000011'


SELECT C7_NUM,C7_FSFLUIG FROM SC7010 WHERE C7_MEDICAO = '000015' AND D_E_L_E_T_ = '*'

SELECT * FROM SF2010