SELECT * FROM SE2010 WHERE E2_NUM = '020205687' AND D_E_L_E_T_ = ''

SELECT CT5_CCD FROM CT5010 WHERE CT5_LANPAD = '610' AND CT5_SEQUEN = '015' 

020101     4020202002 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

--IF(SE5->E5_MOTBX$"DEBACO",SE5->E5_VRETPIS+SE5->E5_VRETCOF+SE5->E5_VRETCSL,0)

-- IF(!(SD1->D1_RATEIO$"1").AND.SD1->D1_TIPO$"N/P".AND.SF4->F4_CFCTB$"S".AND.SUBSTR(SD1->D1_CF,2,3)$"556/407",SD1->(D1_TOTAL+D1_DESPESA+D1_VALFRE+D1_SEGURO+D1_VALIPI)-(IF(SF4->F4_PISCRED$"1",SD1->(D1_VALIMP5+D1_VALIMP6 ),0)) +SD1->D1_ICMSCOM,0)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

SELECT E5_MOTBX, E5_NATUREZ FROM SE5010 WHERE E5_NUMERO = '020205687' AND D_E_L_E_T_ = ''

SELECT D1_RATEIO,D1_TIPO,D1_TES,D1_CF,(D1_TOTAL+(D1_DESPESA+D1_VALFRE+D1_SEGURO+D1_VALIPI)-(D1_VALIMP5+D1_VALIMP6 )) DIFERENCA FROM SD1010 WHERE D1_DOC = '000000291' AND D1_FORNECE = '001292' AND D_E_L_E_T_ = '' 

SELECT F4_CFCTB,F4_PISCRED FROM SF4010 WHERE F4_CODIGO = '279' AND F4_FILIAL =  '0101' 


SELECT * FROM SDE010 WHERE DE_FILIAL = '010101' AND DE_DOC = '002020740' 

SELECT * FROM CT5010 WHERE CT5_LANPAD = '651' AND CT5_SEQUEN = '001'

SELECT * FROM CT5010 WHERE CT5_LANPAD = '610' AND CT5_SEQUEN = '015'

SELECT D1_VALDESC, D1_ICMSRET FROM SD1010 WHERE D1_FILIAL = '020101' AND D1_DOC = '000000388' AND D1_FORNECE = '000343' AND D_E_L_E_T_ = '' 

SELECT A2_EST FROM SA2010 WHERE A2_COD = '000343' SP

SELECT * FROM SDE010 WHERE DE_FORNECE = '122640'

DE_DOC = 002728765 , DE_SERIE, DE_FORNECE, DE_CC, DE_CONTA = 40101060009  

1131 - JAIARA

ALLTRIM(SF1->F1_ESPECIE)+" "+ ALLTRIM(SD1->D1_DOC)+" - "+ALLTRIM(SA2->A2_COD)+" - "+ALLTRIM(SA2->A2_NOME)+" - "+SUBSTR(SB1->B1_DESC,1,10)  

ALLTRIM(SF1->F1_ESPECIE)+" "+ ALLTRIM(SD1->DE_DOC)+" - "+ALLTRIM(SA2->A2_COD)+"-"+ALLTRIM(SA2->A2_NOME)+" - "+SUBSTR(SB1->B1_DESC,1,20) 


SELECT * FROM CTT010 WHERE CTT_BLOQ = '2' AND CTT_CLASSE = '2'