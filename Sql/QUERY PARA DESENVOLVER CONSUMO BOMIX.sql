        SELECT 
            C2.C2_QUANT - C2_QUJE AS SALDO,
            C2.C2_QUANT / B1_QB AS PALET,
            B1.B1_QB as QUANTBAS, 
            Z05.Z05_CARRO AS CONSUMO,
            C2.C2_QUJE AS ENTREGUE,
            D4.D4_QUANT AS EMPENHO,
			D4_COD
        FROM SC2010 C2 (NoLock)
            INNER JOIN SB1010 B1 (NoLock) ON B1.B1_FILIAL = '0101  '
            AND B1.D_E_L_E_T_=''
            AND B1.B1_COD = C2.C2_PRODUTO
            INNER JOIN SD4010 D4 (NoLock) ON D4.D4_FILIAL ='010101'
            AND D4.D_E_L_E_T_=''
            AND D4.D4_OP = 'P6824602001'
            INNER JOIN Z05010 Z05 (NoLock) ON Z05.Z05_FILIAL = '0101'
            AND Z05.D_E_L_E_T_=''
            AND Z05.Z05_NOME = D4.D4_FSTP 
        WHERE C2.C2_FILIAL = '010101'
            AND C2.D_E_L_E_T_=''
            AND C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = 'P6824602001'
            AND D4.D4_COD ='P00B00028'



