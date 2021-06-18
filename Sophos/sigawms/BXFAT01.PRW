/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³BXEST01   ºAutor  ³Elisangela Souza    º Data ³  15/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para gravar informações do WMS na rotina   º±±
±±º          ³apontamento de produção mod. 2                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bomix                                                      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function BXFAT01()

Local a_Area      := GetArea()
Local _cProduto   := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
Local _cLocal     := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_LOCAL' })]
Local _cTES       := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_TES' })]
Local _cRet       := Space(3)
                                                                     
DbSelectArea("SB1")
SB1->( DbSetorder(1) )
If SB1->( DbSeek(xFilial("SB1")+_cProduto ))
	If SB1->B1_LOCALIZ = "S"  // Produto tem controle de endereço
		DbSelectArea("SF4")
		SF4->( DbSetorder(1) )
		If SF4->( DbSeek(xFilial("SF4")+_cTES ))
			If SF4->F4_ESTOQUE = "S" // Tes tem controle de estoque
				DbSelectArea("SB5")
				SB5->( DbSetorder(1) )
				If SB5->( DbSeek(xFilial("SB5")+_cProduto )) // Verifica se existe o produto na tabela de complemento
					_cRet :=  SB5->B5_SERVSAI
					aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_REGWMS' })] := "3"
				Else
					aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_REGWMS' })] := ""
				Endif	
			Else
				aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_REGWMS' })] := ""
		    Endif
		Endif
	Else
		aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_REGWMS' })] := ""
    Endif
Endif

RestArea(a_Area)	

Return( _cRet )