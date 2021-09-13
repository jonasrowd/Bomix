

--SELECT * FROM VADVERTENCIA --> SOMAR QUANTAS ADVERTENCIAS CADA FUNCIONÁRIO POSSUI E COLOCAR NA COLUNA.

DECLARE @DATA_INI DATETIME,
        @DATA_FIM DATETIME,
        @COLIGADA INT

SET @DATA_INI = Cast('19990114' AS DATETIME)
SET @DATA_FIM = Cast('20200309' AS DATETIME)
SET @COLIGADA = 1

SELECT CHAPA,
       NOME,
       SECAO,
       FUNCAO,
       Sum(ATESTADO_DIAS)                              AS ATESTADO_DIAS,
       Sum(ATESTADOS)                                  AS ATESTADOS,
       Sum(FALTA)                                      AS FALTA,
       Sum(SUSPENSAO_DIAS)                             AS SUSPENSAO_DIAS,
       Sum(SUSPENSOES)                                 AS SUSPENSOES,
       (SELECT Count(ADVERTENCIA.CHAPA)
        FROM   VADVERTENCIA ADVERTENCIA
        WHERE  ADVERTENCIA.CODCOLIGADA = TABELA33.CODCOLIGADA
               AND ADVERTENCIA.CHAPA = TABELA33.CHAPA) AS ADVERTENCIA
FROM   (SELECT CODCOLIGADA,
               CHAPA,
               NOME,
               SECAO,
               FUNCAO,
               ( CASE
                   WHEN DESCRICAO = 'ATESTADO' THEN [QUANT DIAS]
                   ELSE ''
                 END ) AS ATESTADO_DIAS,
               ( CASE
                   WHEN DESCRICAO = 'ATESTADO' THEN 1
                   ELSE 0
                 END ) AS ATESTADOS,
               ( CASE
                   WHEN DESCRICAO = 'FALTA' THEN [QUANT DIAS]
                   ELSE ''
                 END ) AS FALTA,
               ( CASE
                   WHEN DESCRICAO = 'SUSPENSAO' THEN [QUANT DIAS]
                   ELSE ''
                 END ) AS SUSPENSAO_DIAS,
               ( CASE
                   WHEN DESCRICAO = 'SUSPENSAO' THEN 1
                   ELSE 0
                 END ) AS SUSPENSOES
        FROM   (SELECT PFUNC.CODCOLIGADA,
                       PFUNC.CHAPA,
                       PFUNC.NOME,
                       PSECAO.DESCRICAO   AS SECAO,
                       PFUNCAO.NOME       AS FUNCAO,
                       'ATESTADO'         AS DESCRICAO,
                       VATESTADO.DTINICIO AS DATA_INI,
                       VATESTADO.DTFINAL  AS DATA_FIM,
                       ( CASE
                           WHEN Datediff(DAY, VATESTADO.DTINICIO, VATESTADO.DTFINAL) <= 0 THEN ( Datediff(DAY, VATESTADO.DTINICIO, VATESTADO.DTFINAL)
                                                                                                 + 1 )
                           ELSE ( Datediff(DAY, VATESTADO.DTINICIO, VATESTADO.DTFINAL)
                                  + 1 )
                         END )            AS [QUANT DIAS]
                FROM   VCHAPAATESTADO
                       LEFT OUTER JOIN PFUNC(NOLOCK)
                                    ON (( ( VCHAPAATESTADO.CHAPA = PFUNC.CHAPA )
                                          AND ( VCHAPAATESTADO.CODCOLIGADA = PFUNC.CODCOLIGADA ) ))
                       LEFT OUTER JOIN VATESTADO(NOLOCK)
                                    ON (( ( VCHAPAATESTADO.CODPESSOA = VATESTADO.CODPESSOA )
                                          AND ( VCHAPAATESTADO.CODCOLIGADA = VATESTADO.CODCOLIGADA )
                                          AND ( VCHAPAATESTADO.DTINICIO = VATESTADO.DTINICIO ) ))
                       LEFT OUTER JOIN VTIPOATESTADO(NOLOCK)
                                    ON ( VATESTADO.CODTPATESTADO = VTIPOATESTADO.CODTPATESTADO )
                       LEFT OUTER JOIN VCID(NOLOCK)
                                    ON ( VATESTADO.CID = VCID.CID )
                       LEFT OUTER JOIN PFUNCAO(NOLOCK)
                                    ON (( ( VCHAPAATESTADO.CODCOLIGADA = PFUNCAO.CODCOLIGADA )
                                          AND ( PFUNC.CODFUNCAO = PFUNCAO.CODIGO ) ))
                       LEFT OUTER JOIN PSECAO(NOLOCK)
                                    ON (( ( VCHAPAATESTADO.CODCOLIGADA = PSECAO.CODCOLIGADA )
                                          AND ( PFUNC.CODSECAO = PSECAO.CODIGO ) ))
                       LEFT OUTER JOIN VPROFISSIONALSAUDE(NOLOCK)
                                    ON ( VATESTADO.CODMEDICO = VPROFISSIONALSAUDE.CODIGO )
                WHERE  VATESTADO.CODCOLIGADA = @COLIGADA
                       AND ( VATESTADO.DTINICIO BETWEEN @DATA_INI AND @DATA_FIM
                              OR VATESTADO.DTFINAL BETWEEN @DATA_INI AND @DATA_FIM )

UNION ALL
                SELECT PFUNC.CODCOLIGADA,
                       Ocorrencia.CHAPA AS CHAPA,
                       PFUNC.NOME       AS NOME,
                       PSECAO.DESCRICAO AS SECAO,
                       PFUNCAO.NOME     AS FUNCAO,
                       'FALTA'          AS DESCRICAO,
                       Ocorrencia.DATA  AS DATA_INI,
                       ''               AS DATA_FIM,
                       1                QUANT
                FROM   (SELECT AJUSTFUN.CODCOLIGADA,
                               AJUSTFUN.CHAPA,
                               AJUSTFUN.DATA,
                               AJUSTFUN.ATITUDE,
                               Cast(CONVERT(NUMERIC, Sum(AJUSTFUN.NUMHORAS)) / 60 AS DECIMAL(10, 2)) AS HRS_FALTAS
                        FROM   AJUSTFUN AS AJUSTFUN (NOLOCK)
                        WHERE  AJUSTFUN.CODCOLIGADA = @COLIGADA
                               AND AJUSTFUN.DATA BETWEEN @DATA_INI AND @DATA_FIM
                               AND AJUSTFUN.TIPOOCORRENCIA = 'F'
                               AND AJUSTFUN.ATITUDE <> '1'
                        GROUP  BY AJUSTFUN.CODCOLIGADA,
                                  AJUSTFUN.CHAPA,
                                  AJUSTFUN.DATA,
                                  AJUSTFUN.TIPOOCORRENCIA,
                                  AJUSTFUN.ATITUDE) Ocorrencia
                       INNER JOIN PFUNC AS PFUNC (NOLOCK)
                               ON PFUNC.CODCOLIGADA = Ocorrencia.CODCOLIGADA
                                  AND PFUNC.CHAPA = Ocorrencia.CHAPA
                       INNER JOIN PSECAO AS PSECAO (NOLOCK)
                               ON PSECAO.CODCOLIGADA = PFUNC.CODCOLIGADA
                                  AND PSECAO.CODIGO = PFUNC.CODSECAO
                       INNER JOIN PFUNCAO AS PFUNCAO (NOLOCK)
                               ON PFUNCAO.CODCOLIGADA = PFUNC.CODCOLIGADA
                                  AND PFUNCAO.CODIGO = PFUNC.CODFUNCAO
                WHERE  Cast(Ocorrencia.CODCOLIGADA AS VARCHAR)
                           + Ocorrencia.CHAPA
                           + CONVERT(VARCHAR(8), Ocorrencia.DATA, 112) NOT IN (SELECT Cast(AAFHTFUN.CODCOLIGADA AS VARCHAR)
                                                                                      + AAFHTFUN.CHAPA
                                                                                      + CONVERT(VARCHAR(8), AAFHTFUN.DATA, 112) AS DATA
                                                                               FROM   AAFHTFUN
                                                                                      INNER JOIN PFUNC
                                                                                              ON PFUNC.CHAPA = AAFHTFUN.CHAPA
                                                                                                 AND PFUNC.CODCOLIGADA = AAFHTFUN.CODCOLIGADA
                                                                                                 AND AAFHTFUN.DATA BETWEEN @DATA_INI AND @DATA_FIM
                                                                                                 AND AAFHTFUN.CODCOLIGADA = @COLIGADA
                                                                                      LEFT JOIN (SELECT SUSP.CHAPA,
                                                                                                        SUSP.CODCOLIGADA,
                                                                                                        Cast(SUSP.DATAINICIO AS DATETIME) AS DATA_INI,
                                                                                                        Cast(SUSP.DATAFIM AS DATETIME)    AS DATA_FIM
                                                                                                 FROM   ASUSPENSAO SUSP WITH (NOLOCK)
                                                                                                        INNER JOIN PFUNC FUNC WITH (NOLOCK)
                                                                                                                ON SUSP.CHAPA = FUNC.CHAPA
                                                                                                                   AND ( DATAINICIO BETWEEN @DATA_INI AND @DATA_FIM
                                                                                                                          OR DATAFIM BETWEEN @DATA_INI AND @DATA_FIM )
                                                                                                                   AND FUNC.CODCOLIGADA = SUSP.CODCOLIGADA
                                                                                                 WHERE  FUNC.CODCOLIGADA = @COLIGADA) TABELA99
                                                                                             ON TABELA99.CHAPA = AAFHTFUN.CHAPA
                                                                                                AND TABELA99.CODCOLIGADA = AAFHTFUN.CODCOLIGADA
                                                                                                AND AAFHTFUN.DATA BETWEEN TABELA99.DATA_INI AND TABELA99.DATA_FIM
                                                                               WHERE  AAFHTFUN.DATA BETWEEN @DATA_INI AND @DATA_FIM
                                                                                      AND PFUNC.CHAPA = AAFHTFUN.CHAPA
                                                                                      AND AAFHTFUN.CODCOLIGADA = @COLIGADA
                                                                                      AND PFUNC.CODCOLIGADA = AAFHTFUN.CODCOLIGADA
                                                                                      AND Cast(CONVERT(NUMERIC, AAFHTFUN.FALTA) / 60 AS DECIMAL(10, 2)) <> 0
                                                                                      AND AAFHTFUN.DATA BETWEEN TABELA99.DATA_INI AND TABELA99.DATA_FIM)

UNION ALL -- 
                SELECT FUNC.CODCOLIGADA,
                       SUSP.CHAPA,
                       FUNC.NOME,
                       SECAO.DESCRICAO AS SECAO,
                       FUNCAO.NOME     AS FUNCAO,
                       'SUSPENSÃO'     AS DESCRICAO,
                       SUSP.DATAINICIO AS DATA_INI,
                       SUSP.DATAFIM    AS DATA_FIM,
                       ( CASE
                           WHEN Datediff(DAY, SUSP.DATAINICIO, SUSP.DATAFIM) <= 0 THEN ( Datediff(DAY, SUSP.DATAINICIO, SUSP.DATAFIM)
                                                                                         + 1 )
                           ELSE ( Datediff(DAY, SUSP.DATAINICIO, SUSP.DATAFIM)
                                  + 1 )
                         END )         AS [QUANT DIAS]
                FROM   ASUSPENSAO SUSP WITH (NOLOCK)
                       INNER JOIN PFUNC FUNC WITH (NOLOCK)
                               ON SUSP.CHAPA = FUNC.CHAPA
                                  AND ( DATAINICIO BETWEEN @DATA_INI AND @DATA_FIM
                                         OR DATAFIM BETWEEN @DATA_INI AND @DATA_FIM )
                                  AND FUNC.CODCOLIGADA = SUSP.CODCOLIGADA
                       INNER JOIN PSECAO SECAO WITH (NOLOCK)
                               ON SECAO.CODIGO = FUNC.CODSECAO
                                  AND FUNC.CODCOLIGADA = SECAO.CODCOLIGADA
                       INNER JOIN PFUNCAO FUNCAO WITH (NOLOCK)
                               ON FUNC.CODCOLIGADA = FUNCAO.CODCOLIGADA
                                  AND FUNC.CODFUNCAO = FUNCAO.CODIGO
                WHERE  FUNC.CODCOLIGADA = @COLIGADA) TAB) TABELA33
GROUP  BY CHAPA,
          NOME,
          SECAO,
          FUNCAO,
          CODCOLIGADA
ORDER  BY CHAPA,
          NOME