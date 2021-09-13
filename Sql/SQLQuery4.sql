SELECT * FROM [dbo].[Pes_TB_SMP_Usuario]
SELECT * FROM Pes_TB_SMP_Setor
SELECT * FROM Pes_TB_SMP_Requisicao
SELECT * FROM Pes_TB_SMP_Formulario
SELECT * FROM Pes_TB_SMP_Solicitacao
SELECT * FROM Pes_TB_SMP_Solicitacao_Status

Update Pes_TB_SMP_Usuario
Set US_SENHA = 'e10adc3949ba59abbe56e057f20f883e'
Where US_LOGIN = 'denise.benzano'

delete from Pes_TB_SMP_Usuario where US_ID = 2

select u.*, f2.CODIGO, f2.CHAPA, f2.NOME, f2.CODCOLIGADA, f2.CODCCUSTO 
from BomixBI.dbo.Pes_TB_SMP_Usuario u 
inner join (select p.CODIGO, p.NOME, f.CHAPA, f.CODCOLIGADA, f.CODCCUSTO 
from CorporeRM.dbo.PPESSOA p 
inner join CorporeRM.dbo.PFUNC f on f.CODPESSOA = p.CODIGO and f.MOTIVODEMISSAO IS NULL) f2 
on f2.CODIGO = u.TB_FUN_RECNO 
where u.US_LOGIN = 'denise.benzano' and u.US_SENHA = 'e10adc3949ba59abbe56e057f20f883e' 
and US_STATUS = 'A'


select s.SO_ID, s.SO_STATUS, s.SO_TB_FUN_RECNO, f2.CHAPA, f2.NOME, s.SO_DATA_HORA, s.SO_TB_DEP_DEPARTAMENTO_FK, e.DESCRICAO as DEPARTAMENTO, 
s.SO_TB_DEP_CENTROCUSTO_FK, c.NOME as CENTROCUSTO, s.SO_JUSTIFICATIVA, s.SO_DADOS_FORMULARIO, s.RQ_ID, r.RQ_NOME, s.US_ID, u.US_NOME
from BomixBI.dbo.Pes_TB_SMP_Solicitacao s 
                          
inner join (select p.CODIGO, p.NOME, f.CHAPA from CorporeRM.dbo.PPESSOA p 
inner join CorporeRM.dbo.PFUNC f on f.CODPESSOA = p.CODIGO and f.MOTIVODEMISSAO IS NULL) f2 on f2.CODIGO = s.SO_TB_FUN_RECNO
                          
inner join CorporeRM.dbo.PSECAO e on e.CODCOLIGADA = SUBSTRING(s.SO_TB_DEP_DEPARTAMENTO_FK, 1, 1) 
and e.CODIGO = SUBSTRING(s.SO_TB_DEP_DEPARTAMENTO_FK, 3, LEN(s.SO_TB_DEP_DEPARTAMENTO_FK)) COLLATE Latin1_General_Bin
                          
inner join CorporeRM.dbo.PCCUSTO c on c.CODCOLIGADA = SUBSTRING(s.SO_TB_DEP_CENTROCUSTO_FK, 1, 1) 
and c.CODCCUSTO = SUBSTRING(s.SO_TB_DEP_CENTROCUSTO_FK, 3, LEN(s.SO_TB_DEP_CENTROCUSTO_FK)) COLLATE Latin1_General_Bin
                          
inner join BomixBI.dbo.Pes_TB_SMP_Requisicao r on r.RQ_ID = s.RQ_ID 
                          
inner join BomixBI.dbo.Pes_TB_SMP_Usuario u on u.US_ID = s.US_ID 
                          
where (s.SO_STATUS = 'E' or (s.SO_STATUS in ('A', 'R') and s.SO_EDITA_VALIDADO = 'S')) 
 and s.SO_FINALIZADA = 'N' 
                          
 order by s.SO_DATA_HORA desc, s.SO_TB_DEP_DEPARTAMENTO_FK asc


select p.CODIGO, p.NOME, f.CHAPA from CorporeRM.dbo.PPESSOA p 
inner join CorporeRM.dbo.PFUNC f on f.CODPESSOA = p.CODIGO and f.MOTIVODEMISSAO IS NULL 
order by p.codigo