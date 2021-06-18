#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ BXMT020	  ºAutor ³TBA001 -XXX     º Data ³  15/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravar o transportador como fornecedor automáticamente     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BXMT020		  	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BXMT020()
Local PARAMIXB1 := {}
Local PARAMIXB2 := 3 
Local lRet 		:= .T.

PRIVATE lMsErroAuto := .F.
//------------------------//| Abertura do ambiente |//------------------------
//------------------------//| Teste de Inclusao    |//------------------------
lRet := BXGRVSA2()	
Return lRet	

	DBSELECTAREA("SA2")
	SA2->(DbSetOrder(3))
//    If !SA2->(DbSeek(xFilial("SA2")+M->A4_CGC))
    	If MsgBox("O Transportador não foi encontrado no cadastro de Fornecedores. Deseja fazer o cadastro?","Cadastro","YESNO")		
			Begin Transaction
				PARAMIXB1 := {}
					aadd(PARAMIXB1,{"A2_FILIAL"	,xFilial("SA2")	,nil})
					aadd(PARAMIXB1,{"A2_COD","P99999"	,nil})
					aadd(PARAMIXB1,{"A2_LOJA"	,"01"			,nil})
					aadd(PARAMIXB1,{"A2_NOME"	,trim(M->A4_NOME)   ,nil})
					aadd(PARAMIXB1,{"A2_NREDUZ"	,trim(M->A4_NREDUZ)	,nil})
					aadd(PARAMIXB1,{"A2_CGC"	,M->A4_CGC		,nil})
					aadd(PARAMIXB1,{"A2_TIPO"	,"J"			,nil})
					aadd(PARAMIXB1,{"A2_END"	,trim(M->A4_END),nil})
					aadd(PARAMIXB1,{"A2_MUN"	,trim(M->A4_MUN),nil})
					aadd(PARAMIXB1,{"A2_BAIRRO"	,trim(M->A4_BAIRRO)	,nil})
					aadd(PARAMIXB1,{"A2_EST"	,M->A4_EST		,nil})
					aadd(PARAMIXB1,{"A2_CEP"	,M->A4_CEP		,nil})
					aadd(PARAMIXB1,{"A2_DDI"	,M->A4_DDI		,nil})
					aadd(PARAMIXB1,{"A2_DDD"	,M->A4_DDD		,nil})
					aadd(PARAMIXB1,{"A2_TEL"	,M->A4_TEL		,nil})
					aadd(PARAMIXB1,{"A2_FAX"	,M->A4_TELEX	,nil})
					aadd(PARAMIXB1,{"A2_INSCR"	,trim(M->A4_INSEST)	,nil})
					aadd(PARAMIXB1,{"A2_EMAIL"	,trim(M->A4_EMAIL)	,nil})
					aadd(PARAMIXB1,{"A2_COMPLEM",trim(M->A4_COMPLEM),nil})
					aadd(PARAMIXB1,{"A2_COD_MUN",trim(M->A4_COD_MUN),nil}) 
				MSExecAuto({|x,y| mata020(x,y)},PARAMIXB1,PARAMIXB2)
				If !lMsErroAuto
					ALERT("Incluido com sucesso! "+M->A4_NOME) 
					confirmsx8("SA2")
				Else
					ALERT("Erro na inclusao!")
					RollBackSX8()
					lRet := .F.
				EndIf
				ALERT("Fim  : "+Time())
			End Transaction 	
		EndIf
  //	Endif
Return lRet   

Static Function BXGRVSA2()

//PRÓXIMO NÚMERO DO FORNECEDOR
Local cCodCont  := GetSx8Num("SA2")  
Local lRet		:= .T.

//CRIAÇÃO DO CONTATO COM ALGUMAS INFORMAÇÕES DO CLIENTE
DbSelectArea("SA2")
RecLock("SA2",.T.)
	SA1->A2_FILIAL	:=xFilial("SA2")	
	SA1->A2_COD		:="A99999" //cCodCont
	SA1->A2_LOJA	:="01"			
	SA1->A2_NOME	:=trim(M->A4_NOME)   
	SA1->A2_NREDUZ	:=trim(M->A4_NREDUZ)	
	SA1->A2_CGC		:=M->A4_CGC		
	SA1->A2_TIPO	:="J"			
	SA1->A2_END		:=trim(M->A4_END)
	SA1->A2_MUN		:=trim(M->A4_MUN)
	SA1->A2_BAIRRO	:=trim(M->A4_BAIRRO)	
	SA1->A2_EST		:=M->A4_EST		
	SA1->A2_CEP		:=M->A4_CEP		
	SA1->A2_DDI		:=M->A4_DDI		
	SA1->A2_DDD		:=M->A4_DDD		
	SA1->A2_TEL		:=M->A4_TEL		
	SA1->A2_FAX		:=M->A4_TELEX	
	SA1->A2_INSCR	:=trim(M->A4_INSEST)	
	SA1->A2_EMAIL	:=trim(M->A4_EMAIL)	
	SA1->A2_COMPLEM	:=trim(M->A4_COMPLEM)
	SA1->A2_COD_MUN :=trim(M->A4_COD_MUN) 
	_nRecno		    := SA2->(RECNO())
MsUnlock()
confirmsx8("SA2")                

If MsgBox("Deseja alterar as informações do Fornecedor cadastrado? ","Cadastro","YESNO")		
	//EXIBE A TELA DE ALTERAÇÃO DO CONTATO PARA O PREENCHIMENTO DE OUTRAS INFORMAÇÕES.
	DBSELECTAREA("SA2")   
	DBGOTO(_nRecno)
	A70ALTERA("SA2",recno(),4)
EndIf

Return  lRet




