SELECT * FROM PFUNC p

select * from PFRATEIOFIXO

select s.SO_ID, s.SO_STATUS, s.SO_TB_FUN_RECNO, f2.CHAPA, f2.NOME, s.SO_DATA_HORA, s.SO_TB_DEP_DEPARTAMENTO_FK, e.DESCRICAO as DEPARTAMENTO, 
                                      s.SO_TB_DEP_CENTROCUSTO_FK, c.NOME as CENTROCUSTO, s.SO_JUSTIFICATIVA, s.SO_DADOS_FORMULARIO, s.RQ_ID, r.RQ_NOME, s.US_ID, u.US_NOME 
                                      from BomixBI.dbo.Pes_TB_SMP_Solicitacao s 
                                                                
                                      inner join (select p.CODIGO, p.NOME, f.CHAPA, f.CODCOLIGADA, f.CODCCUSTO from CorporeRM.dbo.PPESSOA p 
                                      inner join CorporeRM.dbo.PFUNC f on f.CODPESSOA = p.CODIGO and f.MOTIVODEMISSAO IS NULL) f2 on f2.CODIGO = s.SO_TB_FUN_RECNO
                                                                
                                      inner join CorporeRM.dbo.PSECAO e on e.CODCOLIGADA = SUBSTRING(s.SO_TB_DEP_DEPARTAMENTO_FK, 1, 1) 
                                      and e.CODIGO = SUBSTRING(s.SO_TB_DEP_DEPARTAMENTO_FK, 3, LEN(s.SO_TB_DEP_DEPARTAMENTO_FK)) COLLATE Latin1_General_Bin
                                                                
                                      inner join CorporeRM.dbo.PCCUSTO c on c.CODCOLIGADA = SUBSTRING(s.SO_TB_DEP_CENTROCUSTO_FK, 1, 1) 
                                      and c.CODCCUSTO = SUBSTRING(s.SO_TB_DEP_CENTROCUSTO_FK, 3, LEN(s.SO_TB_DEP_CENTROCUSTO_FK)) COLLATE Latin1_General_Bin
                                                                
                                      inner join BomixBI.dbo.Pes_TB_SMP_Requisicao r on r.RQ_ID = s.RQ_ID 
                                                                
                                      inner join BomixBI.dbo.Pes_TB_SMP_Usuario u on u.US_ID = s.US_ID 
