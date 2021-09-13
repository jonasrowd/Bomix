SELECT B1.B1_UPRC, B1.B1_UCOM 
FROM SB1010 B1 
INNER JOIN SD1010 D1 ON D1.D1_COD = B1.B1_COD 
INNER JOIN SF4010 F4 ON F4.F4_CODIGO = D1.D1_TES 

SELECT DISTINCT C7.C7_NUM,C7.C7_FSFLUIG,C7.C7_FORNECE,C7.C7_PRODUTO,C7.C7_DESCRI,C7.C7_EMISSAO,B1.B1_UCOM ULTIMA_COMPRA,C7.C7_TOTAL VALOR,B1.B1_UPRC VLR_ULT_COMPRA,(C7.C7_TOTAL - B1.B1_UPRC) DIFEREN�A  
FROM SC7010 C7
INNER JOIN SD1010 D1 ON D1.D1_PEDIDO = C7.C7_NUM 
INNER JOIN SB1010 B1 ON B1.B1_COD = D1.D1_COD  
INNER JOIN SF4010 F4 ON F4.F4_CODIGO = D1.D1_TES 

SELECT * FROM SC7010

Para que os campos B1_UPRC e B1_UCOM sejam preenchidos automaticamente, a TES utilizada no
documento de entrada dever� ter o campo F4_UPRC = Sim (Atualiza pre�o de compra). Esta altera��o ser� considerada somente para novas NFE.