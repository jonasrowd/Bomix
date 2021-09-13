SELECT B1_MSBLQL,B1.R_E_C_N_O_, Z2.R_E_C_N_O_,CASE WHEN Z2_BLOQ ='1' THEN 'ARTE NOVA'
WHEN Z2_BLOQ ='2' THEN 'ARTE BLOQUEADA'
WHEN Z2_BLOQ ='3' THEN 'DESENVOLVIMENTO'
ELSE 'LIBERADO P IMP' END AS 'Z2_BLOQ'
,B1_FSARTE,Z2_COD,A7_PRODUTO,B1_COD, A7_CLIENTE, A1_NOME, A1_LOJA FROM SB1010 B1 
FULL OUTER JOIN SZ2010 Z2 ON B1_FSARTE=Z2_COD AND Z2_FILIAL=B1_FILIAL
FULL OUTER JOIN  SA7010 A7 ON B1_COD=A7_PRODUTO AND B1_FILIAL=A7_FILIAL
FULL OUTER JOIN SA1010 A1 ON A1_COD=A7_CLIENTE AND A1_LOJA = A7_LOJA AND A1_FILIAL=A7_FILIAL
WHERE --B1.D_E_L_E_T_='' AND A7.D_E_L_E_T_='' AND Z2.D_E_L_E_T_='' AND A1.D_E_L_E_T_=''
A1.A1_COD='000771' 

SELECT B1_MSBLQL,* FROM SB1010 WHERE B1_COD ='B15D00087'                     

SELECT * FROM SZ2010 WHERE R_E_C_N_O_='4838'
SELECT * FROM SB1010 WHERE B1_FSARTE='05986'


--UPDATE SZ2010 SET Z2_BLOQ='4' WHERE R_E_C_N_O_='4838'
--UPDATE SB1010 SET B1_MSBLQL='2' WHERE R_E_C_N_O_ IN ('25858','35972','36098')
