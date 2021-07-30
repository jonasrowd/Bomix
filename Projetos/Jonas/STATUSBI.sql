SELECT C5_BXSTATU, C5_BLQ, C5_LIBEROK, C5_FSSTBI,C5_EMISSAO,C5_NOTA, * FROM SC5010	WHERE C5_EMISSAO >='20210720' AND 
C5_FILIAL = '020101' AND D_E_L_E_T_<>'*' AND C5_NUM='014922'

select * from SC6010 WHERE C6_NUM ='014922' AND C6_FILIAL='020101'

SELECT C5_FSSTBI,  C5_BXSTATU, C5_BLQ, C5_LIBEROK, C5_FSSTBI,C5_EMISSAO,C5_NOTA,
				CASE 
						WHEN (
								(SELECT TOP 1 SUM(C6_QTDENT) FROM P12OFICIAL.dbo.SC6010 (nolock) C6
								WHERE  C6.D_E_L_E_T_ <> '*' AND C6_FILIAL = '010101' AND C6.C6_NUM = PedidoVenda.C5_NUM) > 0 			
								AND 			
								(PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA = '')) THEN 'PARCIAL' 
						WHEN (PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA = '')     THEN 'ABERTO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'S' AND PedidoVenda.C5_NOTA = '')     THEN 'ABERTO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'L' AND PedidoVenda.C5_NOTA = '')    THEN 'LIBERADO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'L' AND PedidoVenda.C5_NOTA <> '')    THEN 'LIBERADO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'S' AND PedidoVenda.C5_NOTA <> '')   THEN 'ENCERRADO' 
						WHEN (PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA <> '')   THEN 'ENCERRADO'
			END,*
		FROM P12OFICIAL.dbo.SC5010 AS PedidoVenda WITH (nolock) 
		WHERE PedidoVenda.D_E_L_E_T_ <> '*' 
		AND PedidoVenda.C5_FILIAL = '010101' 
		AND PedidoVenda.C5_TIPO = 'N'
		AND C5_FSSTBI <> 'ENCERRADO'
		AND C5_NUM='066694'


		-- Status Sopro ************************************************************************************************************
		-- *************************************************************************************************************************
SELECT C5_FSSTBI,  C5_BXSTATU, C5_BLQ, C5_LIBEROK, C5_FSSTBI,C5_EMISSAO,C5_NOTA,
				CASE 
						WHEN (
								(SELECT TOP 1 SUM(C6_QTDENT) FROM P12OFICIAL.dbo.SC6010 (nolock) C6
								WHERE  C6.D_E_L_E_T_ <> '*' AND C6_FILIAL = '010101' AND C6.C6_NUM = PedidoVenda.C5_NUM) > 0 			
								AND 			
								(PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA = '')) THEN 'PARCIAL' 
						WHEN (PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA = '')     THEN 'ABERTO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'S' AND PedidoVenda.C5_NOTA = '')     THEN 'ABERTO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'L' AND PedidoVenda.C5_NOTA = '')    THEN 'LIBERADO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'L' AND PedidoVenda.C5_NOTA <> '')    THEN 'LIBERADO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'S' AND PedidoVenda.C5_NOTA <> '')   THEN 'ENCERRADO'  
						WHEN (PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA <> '')   THEN 'ENCERRADO'
			END
			,*
		FROM P12OFICIAL.dbo.SC5010 AS PedidoVenda WITH (nolock) 
		WHERE PedidoVenda.D_E_L_E_T_ <> '*' 
		AND PedidoVenda.C5_FILIAL = '020101' 
		AND PedidoVenda.C5_TIPO = 'N'
		--AND C5_FSSTBI <> 'ENCERRADO'
		AND C5_NUM='014922'


		/*

				Update P12OFICIAL.dbo.SC5010
		Set C5_FSSTBI = 
				CASE 
						WHEN (
								(SELECT TOP 1 SUM(C6_QTDENT) FROM P12OFICIAL.dbo.SC6010 (nolock) C6
								WHERE  C6.D_E_L_E_T_ <> '*' AND C6_FILIAL = '010101' AND C6.C6_NUM = PedidoVenda.C5_NUM) > 0 			
								AND 			
								(PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA = '')) THEN 'PARCIAL' 
						WHEN (PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA = '')     THEN 'ABERTO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'S' AND PedidoVenda.C5_NOTA = '')     THEN 'ABERTO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'L' AND PedidoVenda.C5_NOTA = '')    THEN 'LIBERADO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'L' AND PedidoVenda.C5_NOTA <> '')    THEN 'LIBERADO' 
						WHEN (PedidoVenda.C5_LIBEROK = 'S' AND PedidoVenda.C5_NOTA <> '')   THEN 'ENCERRADO'  
						WHEN (PedidoVenda.C5_LIBEROK = '' AND PedidoVenda.C5_NOTA <> '')   THEN 'ENCERRADO'
			END
		FROM P12OFICIAL.dbo.SC5010 AS PedidoVenda WITH (nolock) 
		WHERE PedidoVenda.D_E_L_E_T_ <> '*' 
		AND PedidoVenda.C5_FILIAL = '020101' 
		AND PedidoVenda.C5_TIPO = 'N'
		AND C5_NUM = '014922'

		*/

		SELECT TOP 1 SUM(C6_QTDENT) FROM P12OFICIAL.dbo.SC6010 (nolock) C6
		INNER JOIN P12OFICIAL.dbo.SC5010 C5 ON C5_FILIAL=C6_FILIAL AND C6_NUM=C5_NUM
								WHERE  C6.D_E_L_E_T_ <> '*' AND C6_FILIAL = '010101' AND C6.C6_NUM = C5_NUM 		
								AND 			
								C5_LIBEROK = '' AND C5_NOTA = '' 