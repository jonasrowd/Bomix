/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³A680WMSO  ºAutor  ³Elisangela Souza    º Data ³  15/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para gravar informações do WMS na rotina   º±±
±±º          ³apontamento de produção mod. 2                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bomix                                                      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function A680WMSO()

Local _cProduto   := PARAMIXB[1]
Local _cOp        := PARAMIXB[2]
Local _cIdMov     := PARAMIXB[3]
Local _aRet       := {}
Local _cArm       := GetMv("BM_STAGE")
Local _nPosAt     := 0
Local _nPosAt1    := 0
Local _nPosAt2    := 0
Local _cString    := ""
Local _cEnder     := ""
Local _cEstFis    := ""        
Local c_LocalCD   := Getmv("BM_LOCALCD")
Local l_ExistArm  := .F.

                  
// Verifica se o produto esta no complemento de produto - SB5
DbSelectArea("SB5")
SB5->( DbSetOrder(1) )
If SB5->( DbSeek(xFilial("SB5")+_cProduto ))
	
	_cServ := SB5->B5_BXSRVPR // Servico de producao
/*
	DbSelectArea("SH1") // Pesquisa o recurso
	SH1->( DbSetOrder(1) )
	If SH1->( DbSeek(xFilial("SH1")+SH6->H6_RECURSO ) )
		If SH1->H1_FSLOCAL $ c_LocalCD
			_cServ := SB5->B5_FSSVECD // Servico de Entrada de Cross-Docking
		Endif
*/
		If SH6->H6_LOCAL $ c_LocalCD
			_cServ := SB5->B5_FSSVECD // Servico de Entrada de Cross-Docking
		Endif

		/*
		_nPosAt  := At(SH1->H1_FSLOCAL,_cArm) // achei o local
	    _cString := Substr(_cArm,_nPosAt+2)
		_nPosAt1 := At("=",_cString) // achei simbolo =
	    _cString := Substr(_cString,_nPosAt1+1)
		_nPosAt2 := At(";",_cString) // achei o ponto e virgula
		
		If _nPosAt2 = 0 // Se for o ultimo e não tiver ; então essa posicao retorna 0
			_cEnder  := Alltrim(Substr(_cString,_nPosAt1))
		Else	
			_cEnder  := Alltrim(Substr(_cString,_nPosAt1,_nPosAt2-1))
		Endif	
		*/
		
		a_BmStage := StrTokArr(_cArm, "/")
		
		If Len(a_BmStage) == 2
			a_Armazem  := StrTokArr(a_BmStage[1], ";")
			a_Endereco := StrTokArr(a_BmStage[2], ";")
		Endif

		For i:=1 To Len(a_Armazem)
//			If a_Armazem[i] == SH1->H1_FSLOCAL
			If a_Armazem[i] == SH6->H6_LOCAL
				If Type("a_Endereco[i]") <> "U"
					_cEnder    := a_Endereco[i]
					l_ExistArm := .T.
				Endif

				Exit
			Endif
		Next

		If l_ExistArm
			DbSelectArea("SBE")
			SBE->( DbSetOrder(1) )
//			If SBE->( DbSeek(xFilial("SBE") + SH1->H1_FSLOCAL + _cEnder ))
			If SBE->( DbSeek(xFilial("SBE") + SH6->H6_LOCAL + _cEnder ))
				_cEstFis := SBE->BE_ESTFIS

				AAdd( _aRet, PadR(_cServ  ,TamSX3('DB_SERVIC' )[1]) ) //-- Servico
				AAdd( _aRet, PadR(_cEnder ,TamSX3('DB_LOCALIZ')[1]) ) //-- Endereco   
				AAdd( _aRet, PadR(_cEstFis,TamSX3('DB_ESTFIS' )[1]) ) //-- Estrutura Fisica				
			Endif	
		Endif
//	Endif
Endif

Return( _aRet )