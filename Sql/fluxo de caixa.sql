 SELECT * FROM 
(
SELECT 
SC7.C7_DESCRI
,A2_NOME FORNECE
,C7_CC AS NATUREZA
,CTT_DESC01 AS ED_DESCRIC
,C7_OBS OBS
,'' NOTA
,C7_NUM PEDIDO
,C7_DESCRI AS DESC_PEDIDO
,C7_FSDTPRE EMISSAO
,'' VENC
,
CASE WHEN C7_QUJE > 0 AND C7_QUJE < C7_QUANT THEN (SUM(C7_QUJE*C7_PRECO)+SUM(C7_VALIPI)) 
ELSE (SUM(C7_TOTAL)+SUM(C7_VALIPI)) END AS VALOR

,C7_COND CONDICAO
,'Previstos' TIPO 
FROM SC7010 SC7 (NOLOCK)
INNER JOIN SA2010 SA2  (NOLOCK) ON A2_COD = C7_FORNECE 
AND A2_LOJA = C7_LOJA 
AND SA2.D_E_L_E_T_<>'*' 
AND A2_FILIAL='0101' 
--AND (A2_COD BETWEEN '' AND '') 
LEFT JOIN CTT010 CTT (NOLOCK) ON C7_CC=CTT.CTT_CUSTO 
AND CTT.D_E_L_E_T_<>'*' 
AND CTT.CTT_FILIAL= '010101'
WHERE C7_QUJE < C7_QUANT 
AND SC7.C7_RESIDUO <> 'S'  
AND SC7.D_E_L_E_T_<>'*' 
AND C7_FILIAL = '010101' 
AND C7_EMISSAO >='20210701'
--AND C7_NUM NOT IN (SELECT C7_NUM FROM SC7010 SC7 
--JOIN SD1010 SD1  (NOLOCK) ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM AND D1_FILIAL = 'xFilial("SD1")' AND SD1.D_E_L_E_T_<>'*'
--WHERE SC7.D_E_L_E_T_<>'*' AND SC7.C7_RESIDUO <> 'S' AND C7_FILIAL = '010101' GROUP BY C7_NUM)
GROUP BY C7_NUM, A2_NOME, C7_OBS, C7_FSDTPRE, C7_COND,  C7_CC, CTT_DESC01, SC7.C7_DESCRI,C7_QUJE,C7_QUANT
UNION ALL 
SELECT 
'' AS C7_DESCRI
,CASE WHEN E2_ORIGEM='MATA460' THEN A1_NOME ELSE A2_NOME END
,E2_NATUREZ AS NATUREZA
,SED.ED_DESCRIC
,E2_HIST OBS
,E2_NUM NOTA
,'' PEDIDO
,'' AS DESC_PEDIDO
,E2_EMISSAO EMISSAO
,E2_VENCREA VENC
,E2_SALDO VALOR
,''
,'Pagar' TIPO 
FROM SE2010 SE2 (NOLOCK)
LEFT JOIN SA2010 SA2 (NOLOCK) ON A2_COD = E2_FORNECE 
AND A2_LOJA = E2_LOJA 
AND SA2.D_E_L_E_T_<>'*' 
AND A2_FILIAL = '0101'
LEFT JOIN SA1010 SA1 (NOLOCK) ON A1_COD = E2_FORNECE 
AND A1_LOJA = E2_LOJA AND SA1.D_E_L_E_T_<>'*' 
AND A1_FILIAL = '0101'
INNER JOIN SED010 SED (NOLOCK) ON SED.ED_CODIGO=SE2.E2_NATUREZ 
AND SED.D_E_L_E_T_ <>'*' AND SED.ED_FILIAL='010101'
WHERE E2_TIPO <> 'PA' 
AND E2_SALDO <> 0 
AND SE2.D_E_L_E_T_<>'*' 
AND E2_FILIAL = '010101' 
AND E2_EMISSAO >= '20210701' 
AND E2_VENCREA>='20210701' 
--AND E2_FORNECE >= ''
UNION ALL 
SELECT 
'' AS C7_DESCRI
,A1_NOME
, E1_NATUREZ AS NATUREZA
, SED.ED_DESCRIC
, E1_HIST OBS
, E1_NUM NOTA
, '' PEDIDO
, '' AS DESC_PEDIDO
, E1_EMISSAO EMISSAO
, E1_VENCREA VENC
, E1_SALDO VALOR
, '', 'Receber' TIPO 
FROM  SE1010 SE1 (NOLOCK) 
JOIN  SA1010 SA1 (NOLOCK) ON A1_COD = E1_CLIENTE 
AND A1_LOJA = E1_LOJA 
AND SA1.D_E_L_E_T_<>'*' 
AND A1_FILIAL = '0101'
INNER JOIN SED010 SED (NOLOCK) ON SED.ED_CODIGO=SE1.E1_NATUREZ 
AND SED.D_E_L_E_T_ <>'*' 
AND SED.ED_FILIAL = '010101'
WHERE E1_SALDO <> 0 
AND SE1.D_E_L_E_T_<>'*' 
AND E1_FILIAL = '010101' 
AND E1_EMISSAO>='20210701' 
AND E1_VENCREA >='20210701' 
--AND E1_CLIENTE >=''
) 
TAB 
ORDER BY EMISSAO