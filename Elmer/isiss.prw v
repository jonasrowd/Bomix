#INCLUDE "ISISS.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณISISS     บAutor  ณAndressa Ataides    บ Data ณ 05/05/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera as informacoes necessarias para declaracao Mensal de   บฑฑ
ฑฑบ          ณServicos Prestados e/ou Tomados do municipio de Vitoria -ES บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaFis                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Function ISISS(dDtInicial,dDtFinal) // Inicio da funcao Isiss

Local aTRBs	:= ISISSTemp()

If ISISSWiz() // Executa Wizard
	ISISSProc(dDtInicial,dDtFinal,aTRBs)
Endif

Return aTRBs

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณISISSWiz    บAutor  ณAndressa Ataides    บ Data ณ 05/05/2005  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a wizard com as perguntas necessarias                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISISS                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ISISSWiz()

// ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// ณDeclaracao das variaveisณ
// ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aTxtPre 		:= {}
Local aPaineis 		:= {}
Local cTitObj1		:= ""
Local nPos			:= 0
Local lRet			:= 0


// ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// ณMonta wizard com as perguntas necessariasณ
// ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// ordem de acordo com a posicao do array

aAdd(aTxtPre,STR0001) //"ISISS - Vitoria ES"
aAdd(aTxtPre,STR0002) //"Atencao"
aAdd(aTxtPre,STR0003) //"Preencha corretamente as informacoes solicitadas."
aAdd(aTxtPre,STR0004+STR0005)	//"Esta rotina ira gerar as informacoes referentes a ISISS: "
//"Internet Sistema de Impostos sobre Servicos  - Vitoria - ES"

// ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// ณPainel 1 - Informacoes da Empresa    ณ
// ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aPaineis,{})
nPos :=	Len(aPaineis)
aAdd(aPaineis[nPos],STR0006) //"Assistente de parametrizacao"  -- primeira posicao (titulo)
aAdd(aPaineis[nPos],STR0007) //"Informacoes sobre a empresa: " -- segunda posicao (subtitulo)
aAdd(aPaineis[nPos],{})
//
cTitObj1 :=	STR0008 //"Numero da Inscricao Municipal: "  -- terceira posicao
aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
aAdd(aPaineis[nPos][3],{2,,Replicate("X",14),1,,,,14}) // 14 posicoes
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
//
cTitObj1 :=	STR0009 //"Numero AIDF: "
aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
aAdd(aPaineis[nPos][3],{2,,Replicate("X",6),1,,,,6}) // caracter -- passar tamanho do campo (mascara).
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
//
cTitObj1 :=	STR0010 //"Ano AIDF: "
aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
aAdd(aPaineis[nPos][3],{2,,"XXXX",1,,,,4}) // 4 posicoes
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
//
cTitObj1 :=	STR0012 //"Data Pagamento do Documento Fiscal: "
aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
aAdd(aPaineis[nPos][3],{2,,"@d",3,,,,8}) // 8 posicoes
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})

lRet :=	xMagWizard(aTxtPre,aPaineis,"ISISS") // executa wizard(xMagWizard)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณISISSProc   บAutor  ณAndressa Ataides    บ Data ณ 05/05/2005  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa os movimentos                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISISS                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ISISSProc(dDtInicial,dDtFinal)

Local aWizard		:= {}
Local lRet			:= !xMagLeWiz("ISISS",@aWizard,.T.)
Local cNumAidf		:= Alltrim(aWizard[01][02])
Local cAnoAidf		:= Alltrim(aWizard[01][03])
Local cPagament		:= SubStr(Alltrim(aWizard[01][04]),7,2) + "/" + SubStr(Alltrim(aWizard[01][04]),5,2) + "/" + SubStr(Alltrim(aWizard[01][04]),1,4)

Local cAliasSF3		:= "SF3"    // tabela livros fiscais
Local cCNPJ         := ""
Local cRecISS 		:= ""
Local nValISSRet    := 0
Local cCondicao		:= ""
Local cIndex		:= ""
Local nIndex		:= ""
Local cInscM		:= ""
Local cEnd	        := ""
Local cCidade       := ""
Local cEstado       := ""
Local cCEP	        := ""
Local cEmail        := ""
Local cRazao		:= ""
local COBSERV := ""
local NQTDITEM := 0
local NVALIRF := 0
local NVALPIS := 0
local NVALCOF := 0
local NVALCSLL := 0
local NVALINSS := 0
local NVRETIS := 0
local ARETENCAO := {}
local lDescrNFE := ExistBlock("MTDESCRNFE")
local lMailNFE := ExistBlock("MTMAILNFE")
      
#IFDEF TOP  // Verificando as variaveis utilizadas em cada ambiente (TOP/CODBASE)
	Local nX		:= 0
	Local aStruSF3	:= {}
	Local lQuery	:= .F.
#ENDIF

If lRet
	Return
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento dos documentos Fiscais                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbselectarea("SB1")
dbsetorder(1)

dbselectarea("SFT")
dbsetorder(1)

dbSelectArea("SF3") // Varrendo a tabela SF3
dbSetOrder(1) // Primeiro indice da tabela
ProcRegua(LastRec()) // Numero maximo de registro p/ fazer barra de progresso

#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery	 := .T.
		cAliasSF3 := "SF3_ISISS"
		aStruSF3  := SF3->(dbStruct())
		cQuery    := "SELECT * "
		cQuery    += "FROM " + RetSqlName("SF3") + " "
		cQuery    += "WHERE F3_FILIAL='" + xFilial("SF3") + "' AND " // padrao filial
		cQuery    += "F3_ENTRADA >= '" + Dtos(dDtInicial) + "' AND "
		cQuery    += "F3_ENTRADA <= '" + Dtos(dDtFinal) + "' AND "
		cQuery    += "F3_TIPO = 'S' AND "  // = S (notas de servicos -- ISS)
		cQuery    += "F3_NFELETR = '' AND "
		cQuery    += "F3_DTCANC = '' AND "
		cQuery    += "D_E_L_E_T_ = ' ' "
		cQuery    += "ORDER BY "+SqlOrder(SF3->(IndexKey()))
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3)
		
		For nX := 1 To len(aStruSF3) // le estrutura da tabela sf3 -- padrao
			If aStruSF3[nX][2] <> "C" .And. FieldPos(aStruSF3[nX][1])<>0
				TcSetField(cAliasSF3,aStruSF3[nX][1],aStruSF3[nX][2],aStruSF3[nX][3],aStruSF3[nX][4])
			EndIf
		Next nX
		dbSelectArea(cAliasSF3)
	Else
#ENDIF
	cIndex    := CriaTrab(NIL,.F.)
	cCondicao := 'F3_FILIAL == "' + xFilial("SF3") + '" .And. '
	cCondicao += 'DTOS(F3_ENTRADA) >= "' + DTOS(dDtInicial) + '" '
	cCondicao += '.And. DTOS(F3_ENTRADA) <= "' + DTOS(dDtFinal) + '"'
	cCondicao += '.And. F3_TIPO == "S" '
	IndRegua(cAliasSF3,cIndex,SF3->(IndexKey()),,cCondicao) // efetua o filtro
	nIndex := RetIndex("SF3")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
		dbSelectArea("SF3")
		dbSetOrder(nIndex+1)
	#ENDIF
	dbSelectArea(cAliasSF3)
	ProcRegua(LastRec())
	dbGoTop()
Endif


Do While !(cAliasSF3)->(Eof()) // inicio processo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCliente/Fornecedorณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cRecISS  := ""
	cCNPJ 	:= ""
	cInscM   := ""
	cEnd	   := ""
	cCidade  := ""
	cEstado  := ""
	cCEP	   := ""
	cEmail   := ""
	cRazao   := ""
	
	If SubStr((cAliasSF3)->F3_CFO,1,1) >= "5" // NF SAIDA -- se for nf de saida
		If (cAliasSF3)->F3_TIPO $ "DB" // verifica se a nf saida e devolucao/beneficiamento (fornecedor)
			If ! SA2->(dbSeek(xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)) // se nao localizada nota
				(cAliasSF3)->(dbSkip()) // proximo registro
				Loop
			Else // localizou nota...armazena valor do cgc/cpf
				cCNPJ 	:= SA2->A2_CGC
				cInscM   := SA2->A2_INSCRM
				cEnd	   := SA2->A2_END
				cCidade  := SA2->A2_MUN
				cEstado  := SA2->A2_EST
				cCEP	   := SA2->A2_CEP
				cEmail   := SA2->A2_EMAIL
				cRazao   := SA2->A2_NOME
				If SA2->(FieldPos("A2_RECISS")) > 0
					cRecISS := SA2->(FieldGet(FieldPos("A2_RECISS")))
				Endif
			Endif
		Else // se nao for nf de devolucao/beneficiamento (cliente)
			If ! SA1->(dbSeek(xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
				(cAliasSF3)->(dbSkip())
				Loop
			Else
				cCNPJ 	:= SA1->A1_CGC
				cInscM   := SA1->A1_INSCRM
				cEnd	   := SA1->A1_END
				cCidade  := SA1->A1_MUN
				cEstado  := SA1->A1_EST
				cCEP	   := SA1->A1_CEP
				cRazao   := SA1->A1_NOME
				
				If SA1->(FieldPos("A1_RECISS")) > 0
					cRecISS := SA1->(FieldGet(FieldPos("A1_RECISS")))
				Endif

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Ponto de entrada para possibilitar modificar a regra de geracao do ณ
				//ณ contato do contato do cliente que serแ notificado pelo site.       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lMailNFE
					cEmail := ExecBlock("MTMAILNFE", .F. , .F. ,{SA1->A1_COD})
				Else
					cEmail := SA1->A1_EMAIL
				endIf

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Ponto de entrada para possibilitar a gravacao do campo observa็ใo  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lDescrNFE
					aAreaRPS := SF3->(GETAREA())
					cObServ  := ExecBlock("MTDESCRNFE", .F. , .F. ,{(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA})
					RestArea(aAreaRPS)
				EndIf
			Endif
		Endif
	Else    // NF ENTRADA
		If (cAliasSF3)->F3_TIPO$"DB" // verifica se a nf entrada e devolucao/beneficiamento (cliente)
			If ! SA1->(dbSeek(xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)) // se nao localizada nota
				(cAliasSF3)->(dbSkip()) // proximo registro
				Loop
			Else
				cCNPJ 	:= SA1->A1_CGC // localizou nota...armazena valor do cgc/cpf
				cInscM  := SA1->A1_INSCRM
				cEnd	:= SA1->A1_END
				cCidade := SA1->A1_MUN
				cEstado := SA1->A1_EST
				cCEP	:= SA1->A1_CEP
				cRazao  := SA1->A1_NOME
				If SA1->(FieldPos("A1_RECISS")) > 0
					cRecISS := SA1->(FieldGet(FieldPos("A1_RECISS")))
				Endif

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Ponto de entrada para possibilitar modificar a regra de geracao do ณ
				//ณ contato do contato do cliente que serแ notificado pelo site.       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lMailNFE
					cEmail := ExecBlock("MTMAILNFE", .F. , .F. ,{SA1->A1_COD})
				Else
					cEmail := SA1->A1_EMAIL
				EndIf

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Ponto de entrada para possibilitar a gravacao do campo observa็ใo  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lDescrNFE
					aAreaRPS := SF3->(GetArea())
					cObserv  := ExecBlock("MTDESCRNFE", .F. , .F. ,{(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA})
					RestArea(aAreaRPS)
				EndIf
			Endif
		Else // se nao for nf de devolucao/beneficiamento (fornecedor)
			If ! SA2->(dbSeek(xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
				(cAliasSF3)->(dbSkip())
				Loop
			Else
				cCNPJ 	:= SA2->A2_CGC
				cInscM   := SA2->A2_INSCRM
				cEnd	   := SA2->A2_END
				cCidade  := SA2->A2_MUN
				cEstado  := SA2->A2_EST
				cCEP	   := SA2->A2_CEP
				cEmail   := SA2->A2_EMAIL
				cRazao   := SA2->A2_NOME
				If SA2->(FieldPos("A2_RECISS")) > 0
					cRecISS := SA2->(FieldGet(FieldPos("A2_RECISS")))
				Endif
			Endif
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se recolhe ISS Retido ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SF3->(FieldPos("F3_RECISS")) > 0
		cRecISS := (cAliasSF3)->(FieldGet(FieldPos("F3_RECISS")))
	Endif
	
	If cRecISS $ "1S"
		nValISSRet := (cAliasSF3)->F3_VALICM
	Else
		nValISSRet := 0
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInserindo dados nas tabelas temporariasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SubStr((cAliasSF3)->F3_CFO,1,1) >= "5" // NF SAIDA
		RecLock("P02",.T.) // cria reg. em branco na tabela P02 -- reservando a tabela P02
		P02->NF		:= (cAliasSF3)->F3_NFISCAL
		P02->SERIE	:= (cAliasSF3)->F3_SERIE
		P02->NAIDF	:= cNumAidf
		P02->AAIDF	:= cAnoAidf
		P02->EMISS	:= (cAliasSF3)->F3_EMISSAO
		If !Empty((cAliasSF3)->F3_DTCANC) .Or. ('CANCELAD'$(cAliasSF3)->F3_OBSERV) // se nf cancelada
			P02->SITNF	:= "CANCELADO"
			P02->CNAE 	:= "0"
		Else
			P02->SITNF	:= "NORMAL"
			P02->CNAE	:= SM0->M0_CNAE
			P02->VLRDOC	:= (cAliasSF3)->F3_VALCONT
			P02->BASE	:= (cAliasSF3)->F3_BASEICM
			P02->ISS    := NVALISSRET
		EndIf
		
		If !(("Fisica") $ ( trim(P02->TPPES)))
			P02->CNPJ := CCNPJ
		Else
			P02->CPF := CCNPJ
		EndIf
		
		If SA1->A1_EST == "EX"
			P02->TPPES := "ESTRANGEIRA"
		ElseIf RETPESSOA(CCNPJ)=="F"
			P02->TPPES := "Fisica"
		Else
			P02->TPPES := "Juridica"
		EndIf
		
		P02->END		   := cEnd
		P02->CIDADE		:= cCidade
		P02->ESTADO		:= cEstado
		P02->CEP		   := cCep
		P02->EMAIL		:= cEmail
		P02->RAZAO		:= cRazao
		P02->INSC		:= cInscM
		P02->OBSERV    := cObserv
		
		SFT->(dbseek(XFILIAL("SFT")+"S"+(cAliasSF3)->(F3_SERIE+F3_NFISCAL)))
		cChaveSFT := SFT->(&(indexkey()))
		nQtdItem  := 0
		
		While SFT->(!Eof()) .and. cChaveSFT = xFilial("SFT")+"S"+(cAliasSF3)->(F3_SERIE+F3_NFISCAL)
			RecLock("T03", .T. )
			T03->NF := (cAliasSF3)->F3_NFISCAL
			T03->SERIE := (cAliasSF3)->F3_SERIE
			
			SB1->(dbseek(XFILIAL("SB1")+SFT->FT_PRODUTO))
			T03->UNIMED := SB1->B1_UM
			If  .T. //Ponto de entrada
				T03->DESCSERV :=  trim(SB1->B1_DESC)+" - "+ trim(SB1->B1_COD)
			Else
				If SX5->(dbseek(XFILIAL("SX5")+"60"+(cAliasSF3)->F3_CODISS))
					T03->DESCSERV := SX5->X5_DESCRI
				EndIf
			EndIf
			T03->QTDSERV := SFT->FT_QUANT
			T03->VLRUNIT := SFT->FT_PRCUNIT
			T03->VLRTOTAL := SFT->FT_TOTAL
			T03->(MsUnLock())
			nQtdItem++
			
			SFT->(dbskip())
			cChaveSFT := SFT->(&(indexkey()))
		EndDo
		
		aRetencao := DemoRetSE1((cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE)
		nValIRF   := ARETENCAO[1]
		nValPis   := ARETENCAO[2]
		nValCof   := ARETENCAO[3]
		nValCsll  := ARETENCAO[4]
		nValINSS  := ARETENCAO[5]
		nVRetIS   := ARETENCAO[7]
		
		P02->OUTRETE := nValIRF+nValPis+nValCof+nValCsll+nValINSS
		P02->QTDITEM := nQtdItem
		P02->(MsUnLock())
		
	Else // NF ENTRADA
		If !Empty((cAliasSF3)->F3_DTCANC) .Or. ('CANCELAD'$(cAliasSF3)->F3_OBSERV) // se nf for cancelada nao faz nada...
			(cAliasSF3)->(dbSkip())
			Loop
		Endif
		RecLock("T02",.T.)
		T02->NF		:= (cAliasSF3)->F3_NFISCAL
		T02->MODNF	:= AModNot((cAliasSF3)->F3_ESPECIE) // Funcao AModNot --> pega modelo da nota fiscal
		T02->SERIE	:= (cAliasSF3)->F3_SERIE
		T02->TPNF	:= "NOTA FISCAL"
		T02->NCONTR	:= "0"                    // verificar
		T02->EMISS	:= (cAliasSF3)->F3_EMISSAO
		T02->PAGAM	:= cPagament
		If !Empty((cAliasSF3)->F3_DTCANC) .Or. ('CANCELAD'$(cAliasSF3)->F3_OBSERV)
			T02->SITNF	:= "CANCELADO"
		Else
			T02->SITNF	:= "NORMAL"
		Endif
		T02->ALIQ	:= (cAliasSF3)->F3_ALIQICM
		T02->VLRDOC	:= (cAliasSF3)->F3_VALCONT
		T02->VLRSUB	:= Iif(SF3->(FieldPos(("F3_ISSSUB"))) > 0,(cAliasSF3)->F3_ISSSUB,0)
		T02->ISS	   := nValISSRet
		If ("J"$AllTrim(SA2->A2_TIPO)) .Or. (SA2->A2_EST == "EX")
			T02->CNPJ  := cCNPJ
		Else
			T02->CPF	  := cCNPJ
		Endif
		If SA2->A2_EST == "EX"
			T02->TPPES := "ESTRANGEIRA"
		Elseif RetPessoa(cCNPJ) == "F"
			T02->TPPES := "Fisica"
		Else                                                   
		
			T02->TPPES := "Juridica"
		Endif
		T02->END    :=cEnd
		T02->CIDADE	:=cCidade
		T02->ESTADO	:=cEstado
		T02->CEP		:=cCep
		T02->EMAIL	:=cEmail
		T02->RAZAO	:=cRazao
		T02->INSC	:=cInscM
		T02->OBSERV :=cObserv
		
		MsUnlock() // Destrava tabela T02
	Endif
	(cAliasSF3)->(dbSkip()) // Proximo registro
Enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณISISSTemp   บAutor  ณAndressa Ataides    บ Data ณ 05/05/2005  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria os arquivos temporarios                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISISS                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ISISSTemp()

Local aTrbs	  	:= {}
Local aStruP02	:= {}	 // registro 02 -- prestados
Local aStruT02	:= {}  // registro 02 -- tomados
Local aStruT03	:= {}  // registro 02 -- tomados
Local cArqP02	:= ""
Local cArqT02	:= ""
Local cArqT03	:= ""


/* Criacao dos campos na tabela temporaria P02 --> tabela de servicos prestados registro 02*/
AADD(aStruP02,{"NF"	   ,"C",009,0})
AADD(aStruP02,{"SERIE"	,"C",003,0})
AADD(aStruP02,{"NAIDF"	,"C",006,0})
AADD(aStruP02,{"AAIDF"	,"C",004,0})
AADD(aStruP02,{"EMISS"	,"D",008,0})
AADD(aStruP02,{"SITNF"	,"C",017,0})
AADD(aStruP02,{"CNAE"	,"C",007,0})
AADD(aStruP02,{"VLRDOC"	,"N",014,2})
AADD(aStruP02,{"BASE"	,"N",014,2})
AADD(aStruP02,{"TPPES"	,"C",011,0})
AADD(aStruP02,{"ISS"	   ,"N",014,2})
AADD(aStruP02,{"INSC"	,"C",014,0})
AADD(aStruP02,{"CNPJ"	,"C",014,0})
AADD(aStruP02,{"CPF"	   ,"C",011,0})
AADD(aStruP02,{"END"	   ,"C",040,0})
AADD(aStruP02,{"CIDADE"	,"C",015,0})
AADD(aStruP02,{"ESTADO"	,"C",002,0})
AADD(aStruP02,{"CEP"	   ,"C",008,0})
AADD(aStruP02,{"EMAIL"	,"C",030,0})
AADD(aStruP02,{"RAZAO"	,"C",040,0})
AADD(aStrUP02,{"OBSERV" ,"C",254,0})
AADD(aStrUP02,{"QTDITEM","N",003,0})
AADD(aStrUP02,{"OUTRETE","N",014,2})

cArqP02	:=	CriaTrab(aStruP02)
dbUseArea(.T.,__LocalDriver,cArqP02,"P02")
IndRegua("P02",cArqP02,"NF") // ordernar por nf -- chave NF

/* Criacao dos campos na tabela temporaria T02 --> tabela de servicos tomados registro 02*/
AADD(aStruT02,{"NF"	   ,"C",009,0})
AADD(aStruT02,{"MODNF"	,"C",006,0})
AADD(aStruT02,{"SERIE"	,"C",002,0})
AADD(aStruT02,{"TPNF"	,"C",011,0})
AADD(aStruT02,{"NCONTR"	,"C",009,0})
AADD(aStruT02,{"EMISS"	,"D",008,0})
AADD(aStruT02,{"PAGAM"	,"C",010,0})
AADD(aStruT02,{"SITNF"	,"C",017,0})
AADD(aStruT02,{"ALIQ"	,"N",005,2})
AADD(aStruT02,{"VLRDOC"	,"N",014,2})
AADD(aStruT02,{"VLRGLO"	,"N",014,2})
AADD(aStruT02,{"VLRMAT"	,"N",014,2})
AADD(aStruT02,{"VLRSUB"	,"N",014,2})
AADD(aStruT02,{"ISS"	   ,"N",014,2})
AADD(aStruT02,{"CNPJ"	,"C",014,0})
AADD(aStruT02,{"CPF"	   ,"C",011,0})
AADD(aStruT02,{"TPPES"	,"C",011,0})
AADD(aStruT02,{"END"	   ,"C",040,0})
AADD(aStruT02,{"CIDADE"	,"C",015,0})
AADD(aStruT02,{"ESTADO"	,"C",002,0})
AADD(aStruT02,{"CEP"	   ,"C",008,0})
AADD(aStruT02,{"EMAIL"	,"C",254,0})
AADD(aStruT02,{"RAZAO"	,"C",040,0})
AADD(aStruT02,{"INSC"	,"C",014,0})
AADD(aStruT02,{"OBSERV" ,"C",254,0})

cArqT02	:=	CriaTrab(aStruT02)
dbUseArea(.T.,__LocalDriver,cArqT02,"T02")
IndRegua("T02",cArqT02,"NF") // ordernar por nf -- chave NF

aadd(ASTRUT03,{"NF"      ,"C",009,0})
aadd(ASTRUT03,{"SERIE"   ,"C",002,0})
aadd(ASTRUT03,{"QTDSERV" ,"N",010,0})
aadd(ASTRUT03,{"UNIMED"  ,"C",002,0})
aadd(ASTRUT03,{"DESCSERV","C",200,0})
aadd(ASTRUT03,{"VLRUNIT" ,"N",014,2})
aadd(ASTRUT03,{"VLRTOTAL","N",014,2})

cArqT03 := CriaTrab(aStrut03)
dbUseArea( .T. ,__LOCALDRIVER,cArqT03,"T03")
IndRegua("T03",cArqT03,"NF")

aTrbs := {{cArqP02,"P02"},{cArqT02,"T02"},{cArqT03,"T03"}}

Return aTrbs

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณISISSDel    บAutor  ณAndressa Ataides    บ Data ณ 05/05/2005  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDeleta os arquivos temporarios processados                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISISS                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function ISISSDel(aDelArqs) // Chamada da funcao no ini.

Local aAreaDel := GetArea()
Local nI := 0

For nI:= 1 To Len(aDelArqs)
	If File(aDelArqs[nI,1]+GetDBExtension())
		dbSelectArea(aDelArqs[ni,2])
		dbCloseArea()
		Ferase(aDelArqs[nI,1]+GetDBExtension())
		Ferase(aDelArqs[nI,1]+OrdBagExt())
	Endif
Next

RestArea(aAreaDel)

Return