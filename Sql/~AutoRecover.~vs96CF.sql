SELECT * FROM SPED000 WHERE PARAMETRO = 'MV_AUTDIST'

SELECT * FROM SPED000 WHERE PARAMETRO = 'MV_NFEDID'

--DANFE do TSS por email
MV_AUTDIST = 1
MV_NFEDID = 1


--DANFE do ERP por email
MV_AUTDIST = 0
MV_NFEDID = 1

FISVALNFE: Este ponto de entrada foi disponibilizado a fim de permitir a validação da transmissão das Notas Fiscais pela rotina SPEDNFE.



FISENVNFE: Ponto de entrada executado logo após a transmissão da NF-e.

FISEXPNFE: Ponto de entrada executado logo após a exportação do arquivo XML pela rotina de exportação.

BEGIN TRANSACTION

INSERT INTO SPED000 (ID_ENT,PARAMETRO,CONTEUDO,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,LOGID)
VALUES('000004','MV_NFEDID','1','',(SELECT MAX(R_E_C_N_O_)+1 FROM SPED000),0,'');

COMMIT TRANSACTION



000001	MV_AUTDIST	1                                                                                                                                                                                                                                                         	 	272	0	                                        
000002	MV_AUTDIST	1                                                                                                                                                                                                                                                         	 	273	0	                                        
000004	MV_AUTDIST	1                                                                                                                                                                                                                                                         	 	274	0	                                        
