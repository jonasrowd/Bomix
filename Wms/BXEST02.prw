/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矪XEST02   篈utor  矱lisangela Souza    � Data �  15/10/2013 罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     砅onto de entrada para gravar informa珲es do WMS na rotina   罕�
北�          砊ransfer阯cia mod. 2                                        罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Bomix                                                      罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function BXEST02()

Local a_Area      := GetArea()
Local _cProduto   := ""
Local _cRet       := Space(TamSX3("D3_SERVIC")[1])
Local c_SrvTran   := Getmv("BM_SRVTRAN")
Local c_SrvMov    := Getmv("BM_SRVMOV")

If FunName() == "MATA261"
	_cProduto := aCols[n][AScan(aHeader,{ |x| Upper(AllTrim(x[1])) == "PROD.ORIG." .And. Alltrim(x[2]) == 'D3_COD' })]

    If !Empty(_cProduto)
		dbSelectArea("SB1")
		SB1->( dbSetorder(1) )
		If SB1->( dbSeek(xFilial("SB1")+_cProduto ))
			If SB1->B1_LOCALIZ = "S"  // Produto tem controle de endere鏾
				dbSelectArea("SB5")
				SB5->( dbSetorder(1) )
				If SB5->( dbSeek(xFilial("SB5")+_cProduto )) // Verifica se existe o produto na tabela de complemento
					_cRet :=  SB5->B5_BXSRVTR
					
					If Empty(_cRet)
						_cRet := c_SrvTran
					Endif
					
					If AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' }) > 0
						aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' })] := _cRet
					Endif
				Else
					If AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' }) > 0
						aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' })] := ""
					Endif
				Endif	
			Else
				If AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' }) > 0
					aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' })] := ""
				Endif
		    Endif
		Endif
	Endif
/* Gatilho para atualizar o c骴igo do servi鏾 em movimentos internos
Elseif FunName() == "MATA241"
	_cProduto := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_COD' })]

    If !Empty(_cProduto)
		dbSelectArea("SB1")
		SB1->( dbSetorder(1) )
		If SB1->( dbSeek(xFilial("SB1")+_cProduto ))
			If SB1->B1_LOCALIZ = "S"  // Produto tem controle de endere鏾
				dbSelectArea("SB5")
				SB5->( dbSetorder(1) )
				If SB5->( dbSeek(xFilial("SB5")+_cProduto )) // Verifica se existe o produto na tabela de complemento
					_cRet :=  SB5->B5_SERVINT
					
					If Empty(_cRet)
						_cRet := c_SrvMov
					Endif
					
					If AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' }) > 0
						aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' })] := _cRet
					Endif
				Else
					If AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' }) > 0
						aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' })] := ""
					Endif
				Endif	
			Else
				If AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' }) > 0
					aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_SERVIC' })] := ""
				Endif
		    Endif
		Endif
	Endif
*/
Endif

RestArea(a_Area)	

Return( _cRet )