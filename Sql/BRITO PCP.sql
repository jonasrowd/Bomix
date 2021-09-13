--Pcp_SP_AtualizarBase_OrdemProducao_DeletarOrdemProducaoDeAlca 
--Pcp_SP_AtualizarBase_OrdemProducao_DeletarOrdemProducaoDeSaco
--Pcp_SP_AtualizarBase_OrdemProducao_DeletarOrdemProducaoIniciadasComZERO FALTA TRATAR
--Pcp_SP_AtualizarBase_OrdemProducao_DeletarOrdemProducaoRelacionadasPaletizacaoUNICA
--Consultar para Reiniciar o teste do Pedido 067307

--Delete from P12OFICIAL.dbo.SD4010 where D4_FILIAL ='010101' AND Substring(D4_OP,1,6)='P67274'
--delete from P12OFICIAL.dbo.SC2010 where C2_NUM ='P67274'

--Update P12OFICIAL.dbo.SC6010
--Set C6_NUMOP ='',
--C6_ITEMOP ='',
--C6_OP =''
--where C6_NUM ='067274'

Select C6_NUMOP, C6_ITEMOP, C6_OP,*from P12OFICIAL.dbo.SC6010 where C6_NUM ='067526'
select * from P12OFICIAL.dbo.SC2010 where C2_NUM ='P67274' and D_E_L_E_T_=''
SELECT * FROM SD4010 WHERE D4_OP like 'P67274%'  AND D_E_L_E_T_=''     order by D4_OP              
--Select TOP 100 C2_PEDIDO,C2_SEQPAI,* from P12OFICIAL.dbo.SC2010(nolock) Order by R_E_C_N_O_ desc

Select DISTINCT
C2_PRODUTO, B1_BRTPPR, Z05_GERAOP from P12OFICIAL.dbo.SC2010 C2 (Nolock)
 INNER Join P12OFICIAL.dbo.SB1010 (Nolock) B1 ON B1_FILIAL ='0101' AND B1.D_E_L_E_T_ <>'*' AND B1_COD = C2_PRODUTO
 INNER Join P12OFICIAL.dbo.Z05010 (Nolock) Z05 ON Z05_FILIAL ='0101' AND Z05.D_E_L_E_T_ <>'*' AND Z05_NOME = B1_BRTPPR                                                       
  Where Z05_GERAOP='N'


