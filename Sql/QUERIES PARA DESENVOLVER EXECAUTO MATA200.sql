			SELECT DISTINCT 
			--B1_COD AS 'PRODUTO PAI',
			B1_GRUPO AS 'GRUPO PAI',
			B1_QB AS 'QTDE. BASE PROD. PAI', 
			'' AS '3 - Inc / 4 - Alt / 5 - Exc', 
			'' AS 'PRODUTO FILHO ORIGEM',
			'' AS 'PRODUTO FILHO NOVO',
			'' AS 'QTDE PROD. FILHO',
			'PREENCHER PRODUTO FILHO ORIGEM APENAS QUANDO FOR SUBSTITUIR UM PRODUTO POR OUTRO' AS 'INFORMAÇÕES COMPL.'
			FROM SB1010 B1
			INNER JOIN SG1010 G1 
			ON B1_COD=G1_COD AND B1_FILIAL='0101' AND G1_FILIAL='010101'
			AND B1.D_E_L_E_T_='' AND G1.D_E_L_E_T_='' AND B1_MSBLQL<>1
			AND B1_GRUPO='B05D' AND B1_QB='12600'
			ORDER BY B1_GRUPO

	SELECT B1_COD FROM SB1010 
			WHERE 
			B1_GRUPO='A16A' AND 
			B1_QB='1000' AND 
			D_E_L_E_T_='' AND 
			B1_MSBLQL<>1


	SELECT * FROM SB1010 WHERE B1_COD='P00B00145'



	SELECT 	G1_FILIAL,B1_COD,G1_COMP,G1_QUANT,G1_PERDA,G1_INI,G1_FIM,G1_TRT
			FROM SB1010 B1
			INNER JOIN SG1010 G1 
			ON B1_COD=G1_COD AND B1_FILIAL='0101' AND G1_FILIAL='010101'
			AND B1.D_E_L_E_T_='' AND G1.D_E_L_E_T_='' AND B1_MSBLQL<>1
			AND B1_GRUPO='B05D' AND B1_QB='12600'
			ORDER BY B1_GRUPO, B1_COD

