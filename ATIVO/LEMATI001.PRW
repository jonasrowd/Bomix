#Include "Totvs.ch"    

/*/{Protheus.doc} LEMATI001
	Gatilho para criacao da sequencia do codigo inteligente de ativo fixo.
	@type function
	@version 12.1.25 
	@author jonas.machado
	@since 21/07/2021
	@return variant, codigo
/*/
User Function LEMATI001()

	SetPrvt("_CGRUPO,_CCLAS1,_CCLAS2,CALIAS,CORD")
	SetPrvt("CREG,_CCODANT,_CCOD,_CSEQTEMP,_CSEQ,")
	cAlias := Alias()
	cOrd   := IndexOrd()
	cReg   := Recno()
	
	_cGrupoant:= ALLTRIM(M->N1_GRUPO)
	
	DbSelectArea("SN1")
	DbSetOrder(1)
	DbSeek(xFilial("SN1")+_cGrupoAnt,.T.)
	
	 If Found()
	
		While ALLTRIM(SN1->N1_GRUPO) == _cGrupoAnt  
	
			_cSeqTemp := Substr(SN1->N1_CBASE,5,4) 
	
	 		Dbskip()                   
	
		Enddo    
	
	 Else
	
		 _cSeqTemp := "0000"
	
	 Endif
	
	 _cSeq := StrZero(Val(_cSeqTemp)+1,4)
	 _cCod := _cGrupoAnt + _cSeq 
	
	
	Dbselectarea(cAlias)
	Dbsetorder(cOrd)  
	Dbgoto(cReg)

Return(_cCod)
