SELECT DISTINCT PessoaFuncao.CHAPA Matricula,Pessoa.NOME Nome_do_Funcionario,
Case			
When PessoaFuncao.CODSITUACAO = 'D' then 'DEMITIDO' else 'ATIVO'
end as Situacao_do_Func,
Horario.DESCRICAO Horario_da_Jornada, Pessoa.CPF CPF,Pessoa.RUA Endeco,Pessoa.NUMERO Numero,Pessoa.COMPLEMENTO Complemento,
Pessoa.BAIRRO,Pessoa.ESTADO,Pessoa.CIDADE,Pessoa.CARTIDENTIDADE RG,Pessoa.CARTEIRATRAB Carteira_de_Trab,Pessoa.SERIECARTTRAB Serie,PessoaFuncao.DATAADMISSAO,
PessoaFuncao.DATADEMISSAO,CCUSTO.CODCCUSTO CENTRO_CUSTO,CCUSTO.NOME NOME_CCUSTO,PFUNCAONOME.NOME FUNCAO,Secao.DESCRICAO AREA,PessoaFuncao.SALARIO SALARIO
FROM [CorporeRM].dbo.PPESSOA Pessoa (nolock) 
INNER JOIN [CorporeRM].dbo.PFUNC PessoaFuncao (nolock)  ON PessoaFuncao.CODPESSOA = Pessoa.CODIGO
Inner JOin [CorporeRM].dbo.GCOLIGADA Empresa (nolock) ON Empresa.CODCOLIGADA = PessoaFuncao.CODCOLIGADA
Inner Join [CorporeRM].dbo.PCODSITUACAO StatusFuncionario (nolock) ON StatusFuncionario.CODINTERNO = PessoaFuncao.CODSITUACAO
Inner Join [CorporeRM].dbo.AHORARIO Horario (nolock) ON Horario.CODCOLIGADA = PessoaFuncao.CODCOLIGADA
																			AND Horario.CODIGO = PessoaFuncao.CODHORARIO
Left  Join [CorporeRM].dbo.PCCUSTO CCUSTO (nolock) ON CCUSTO .CODCOLIGADA = PessoaFuncao.CODCOLIGADA AND CCUSTO.CODCCUSTO = PessoaFuncao.CODCCUSTO
Inner Join [CorporeRM].dbo.PFCOMPL Complemento (nolock) On Complemento.CODCOLIGADA = PessoaFuncao.CODCOLIGADA
																		 And Complemento.CHAPA = PessoaFuncao.CHAPA
Inner Join [CorporeRM].dbo.PFUNCAO PFUNCAONOME (nolock) ON PessoaFuncao.CODCOLIGADA = PFUNCAONOME.CODCOLIGADA AND PFUNCAONOME.CODIGO = PessoaFuncao.CODFUNCAO
INNER JOIN [CorporeRM].dbo.PSECAO (nolock) Secao ON PessoaFuncao.CODCOLIGADA = Secao.CODCOLIGADA AND PessoaFuncao.CODSECAO = Secao.CODIGO
--INNER JOIN [CorporeRM].dbo.PMOTADMISSAO (nolock) Motivo_ADM ON PessoaFuncao.MOTIVOADMISSAO = Motivo_ADM.CODINTERNO
--INNER JOIN [CorporeRM].dbo.PMOTDEMISSAO (nolock) Motivo_DEM ON PessoaFuncao.MOTIVODEMISSAO = Motivo_DEM.CODINTERNO 
WHERE Pessoa.NOME LIKE '%WILLIAN%'


ORDER BY Nome_do_Funcionario

SELECT * FROM PFCOMPL

BEGIN TRANSACTION; 

ALTER TABLE PFCOMPL DROP COLUMN MP;

COMMIT; 

SELECT CUST FROM [dbo].[PRATEIO] RATEIOFIXO where NOME LIKE '%AZEVEDO%'

SELECT * FROM  WHERE 

CHAPA = '0103031'
