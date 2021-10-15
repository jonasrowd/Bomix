#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"

User Function JONAS() 
	Local aButtons := {}
	Local cCadastro := "Importação da Estrutura de Produtos"
	Local aSays     	:= {}
	Local aArea			:= GetArea()
	Private cArq		:= ""
	Private aErros 	:= {}

	AADD(aSays,OemToAnsi("Este programa tem o objetivo importar a Estrutura de Produtos do arquivo Excel..."))
	AADD(aSays,OemToAnsi(""						                                                 		      ))
	AADD(aSays,OemToAnsi(""																					  ))
	AADD(aSays,OemToAnsi("Clique no botão parâmetros para selecionar o ARQUIVO CSV de interface."		      ))
	AADD(aSays,OemToAnsi(""						                                                 		      ))
	AADD(aSays,OemToAnsi(""																					  ))
	AADD(aSays,OemToAnsi("                   E S T R U T U R A    D E    P R O D U T O S "		      		  ))
	AADD(aButtons, { 1,.T.						,{|o| (Iif(ImpArq(),o:oWnd:End(),Nil)) 						  }})
	AADD(aButtons, { 2,.T.						,{|o| o:oWnd:End()											  }})
	AADD(aButtons, { 5,.T.						,{|o| (AbreArq(),o:oWnd:refresh())							  }})
	FormBatch( cCadastro, aSays, aButtons )
	RestArea(aArea)
Return .T.

/*---------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Descricao         ! Seleciona arquivo que será copiado para a pasta         !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos                                              !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 07/06/2019                                              !
+------------------+--------------------------------------------------------*/
Static Function AbreArq()

	Local cType		:=	"Arquivos CSV|*.CSV|Todos os Arquivos|*.*"
	cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo de interface"),0,"C:\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

Return()
/*---------------------------------------------------------------------------+
!   DADOS DO PROGRAMA   - IMPARQ()                                           !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina que prepara a importação do arquivo              !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos                                              !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 07/06/2019                                              !
+------------------+--------------------------------------------------------*/
Static Function ImpArq()
	Local lRet := .T.

	If !File(cArq)
		Aviso("Atenção !","Arquivo não selecionado ou inválido !",{"Ok"})
		Return .F.
	Endif

	ProcRegua(474336)

	BEGIN TRANSACTION
		Processa({|| Importa() },"Processando...")
	END TRANSACTION

Return lRet

/*---------------------------------------------------------------------------+
!   DADOS DO PROGRAMA   - Importa()                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina que prepara a importação do arquivo              !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos                                              !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 07/06/2019                                              !
+------------------+--------------------------------------------------------*/
Static Function Importa(PARAMIXB3)

	Local cLinha  	:= ""
	Local aDados  	:= {}
	Local nX := 0
	Local nY := 0
	Local aCabec := {}
	Local aItens := {}
	Local aLinhas := {}
	Local cCodigo := ""
	Local lContinua := .T.
	Local nVlr100 := 0
	Local cVlr100 :=""
	Local nPerda := 0
	Local cPerda :=""
	Local lExclui := .T.
	Private lMsErroAuto := .F.
	Default PARAMIXB3 := 3
	/*
	Filial		- aDados[nX][1]
	Codigo 		- aDados[nX][2]
	Componente	- aDados[nX][3]
	Quantidade	- aDados[nX][4]
	Perda		- aDados[nX][5]
	Data Inicial- aDados[nX][6]
	DAta Final 	- aDados[nX][7]
	TRT			- aDados[nX][8]
	"Filial","Codigo","Componente","Quantidade","Perda","Data Inicial","Data Final","TRT"
	*/
	FT_FUSE(cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
		cLinha := FT_FREADLN()
		IncProc("Lendo arquivo csv...")
		If !Empty(cLinha) .and. !(cLinha$";;;;;;;")
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo
	FT_FUSE()
	//Verifica o total de colunas. caso seja < 8 o arquivo está incorreto
	If len(aTail(aDados)) <> 8
		Aviso("Atenção","A estrutura do arquivo está incorreta.", {"Ok"}, 2)
		Return
	EndIf
	//Rotina para validação de todo o arquivo importado. caso haja erros em alguma linha, retorna FAlse e aborta a importação
	lContinua := ValArq(aDados)
	If lContinua
		dbSelectArea("SG1")
		SG1->(dbSetOrder(1))//	G1_FILIAL+G1_COD+G1_COMP+G1_TRT
		ProcRegua(Len(aDados))
		For nX:=1 to Len(aDados)//FAZER 02 LAÇOS 1 PARA O CODIGO PAI
			//pega o novo codigo
			If cCodigo <> aDados[nX][2]
				cCodigo := aDados[nX][2]
				aCabec := {}
				aItens := {}
				aCabec := {{"G1_COD",cCodigo,NIL}}
				IncProc("Importando produto " + cCodigo +" ") 
				For nY:=2 to Len(aDados)
					If 	cCodigo == aDados[nY][2]
						cVlr100:= StrTran( aDados[nY,4],",", "." )//retira virgula
						cPerda:= StrTran( aDados[nY,5],",", "." )//retira virgula				
						nVlr100:= Val(cVlr100)
						nPerda:= Val(cPerda)
						aLinhas := {} 
						aadd(aLinhas,{"G1_COD",cCodigo,NIL}) 
						aadd(aLinhas,{"G1_COMP",aDados[nY][3],NIL}) 
						aadd(aLinhas,{"G1_TRT",aDados[nY][8],NIL}) 
						aadd(aLinhas,{"G1_QUANT",nVlr100,NIL}) 
						aadd(aLinhas,{"G1_PERDA",nPerda,NIL}) 
						aadd(aLinhas,{"G1_INI",CTOD(aDados[nY][6]),NIL}) 
						aadd(aLinhas,{"G1_FIM",CTOD(aDados[nY][7]),NIL}) 
						aadd(aItens,aLinhas) 	
					Endif
				Next nY
				//Verifica se o codigo da estrutura ja existe. Caso exista, exclui a estrutura
				If SG1->(MsSeek(cFilAnt+cCodigo)) 
					Begin Transaction
						//Chama a rotina de execauto	
						MSExecAuto({|x,y,z| mata200(x,y,z)},aCabec,Nil,5) 
						If lMsErroAuto
							MostraErro()
							DisarmTransaction()
							lExclui := .F.
						EndIf
					End Transaction
				EndIf
				If lExclui
					Begin Transaction
						//Chama a rotina de execauto	
						MSExecAuto({|x,y,z| mata200(x,y,z)},aCabec,aItens,3) 
						If lMsErroAuto
							MostraErro()
							DisarmTransaction()
						EndIf
					End Transaction
				EndIf
			EndIf
			If !lExclui
				Exit
			EndIf
		Next nX	
		If !lMsErroAuto
			Aviso("Atenção","A Importação foi executada com sucesso.", {"Ok"}, 2)
		EndIf
	EndIF

	Return

/*/{Protheus.doc} ValArq(aDados)
	Função de validação do arquivo TXT 
	@author Jair Matos
	@since 29/05/2019 
	@version 1.0
	@return lContinua 
/*/
Static Function ValArq(aDados)
	Local lRet := .T.
	Local nX := 0
	Local nCount := 0
	Local cErro := ""
	Local aDadosBkp := {}
	DbSelectArea("SM0")
	SM0->(DbGoTop())
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	//grava a primeira linha no novo array
	AADD(aDadosBkp,{"Filial","Codigo","Componente","Quantidade","Perda","Data Inicial","Data Final","TRT"})
	//Verifica se filial que está no arquivo é da empresa correta. Valida todo o arquivo. Caso haja inconsistencia, o arquivo será rejeitado
	For nX := 2 to (len(aDados)-nCount)
		lRet := .T.
		SB1->(DbGoTop())
		//Verifica se o codigo pai é igual ao codigo do componente. Caso sim, exclui da lista.
		If aDados[nX][2] == aDados[nX][3]
			cErro 	:= "O produto acabado "+Alltrim(aDados[nX][2])+" não pode ser igual ao componente "+Alltrim(aDados[nX][2])+". Verifique a linha "+Alltrim(Str(nX))+" ."
			aAdd(aErros, cErro)
			lRet := .F.
		EndIf
		If !SM0->(dbSeek( cEmpAnt + aDados[nX][1] ) )
			cErro 	:= "A filial "+Alltrim(aDados[nX][1])+" pertence a outra empresa. Verifique a linha "+Alltrim(Str(nX))+" ."
			aAdd(aErros, cErro)
			lRet := .F.
		EndIf
		If cFilant <> aDados[nX][1] //.and. lRet
			cErro 	:= "A filial "+Alltrim(aDados[nX][1])+" no arquivo não é a filial corrente. Verifique a linha "+Alltrim(Str(nX))+" ."
			aAdd(aErros, cErro)
			lRet := .F.
		EndIf
		If !SB1->(MsSeek(cFilAnt+aDados[nX][2])) //.and. lRet
			cErro 	:= "O produto acabado "+Alltrim(aDados[nX][2])+" não está cadastrado para a filial "+Alltrim(aDados[nX][1])+". Verifique a linha "+Alltrim(Str(nX))+" ."
			aAdd(aErros, cErro)
			lRet := .F.
		EndIf
		If !SB1->(MsSeek(cFilAnt+aDados[nX][3])) //.and. lRet
			cErro 	:= "O componente "+Alltrim(aDados[nX][3])+" não está cadastrado para a filial "+Alltrim(aDados[nX][1])+". Verifique a linha "+Alltrim(Str(nX))+" ."
			aAdd(aErros, cErro)
			lRet := .F.
		EndIf
		If lRet
			//grava a linha no novo array
			AADD(aDadosBkp,{aDados[nX][1],aDados[nX][2],aDados[nX][3],aDados[nX][4],aDados[nX][5],aDados[nX][6],aDados[nX][7],aDados[nX][8]})
			//
		EndIf
	Next nX
	If len(aErros) > 0
		nRetMsg := Aviso("Atenção","Existem produtos com erros no arquivo. Verifique o Log de Erros 'Erro_SG1.txt' ", {"Gera Log.Erros","Fechar"}, 2)
		If nRetMsg == 1
			fSalvArq()
		EndIf
	EndIf
	aDados= {}
	aDados := AClone(aDadosBkp)
Return .T.
/*-----------------------------------------------*
| Função: fSalvArq                              |
| Descr.: Função para gerar um arquivo texto    |
*-----------------------------------------------*/
Static Function fSalvArq()
	Local cFileNom :='\x_arq_'+dToS(Date())+StrTran(Time(),":")+".TXT"
	Local cQuebra  := CRLF + "+=======================================================================+" + CRLF
	Local lOk      := .T.
	Local cTexto   := ""
	Local nX := 0
	//Pegando o caminho do arquivo
	cFileNom:= cGetFile( '*.txt|*.txt' , 'Selecione a pasta para gerar o arquivo', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
	//Se o nome não estiver em branco
	If !Empty(cFileNom)
		//Teste de existência do diretório
		If ! ExistDir(SubStr(cFileNom,1,RAt('\',cFileNom)))
			Alert("Diretório não existe:" + CRLF + SubStr(cFileNom, 1, RAt('\',cFileNom)) + "!")
			Return
		EndIf
		cArqCPag := cFileNom+"Erro_SG1.txt"
		//Montando a mensagem
		cTexto := "Função:"+ FunName()
		cTexto += " Usuário:"+ cUserName
		cTexto += " Data:"+ dToC(dDataBase)
		cTexto += " Hora:"+ Time() + cQuebra  + "Log de Erros" + cQuebra
		For nX := 1 To Len(aErros)
			cTexto +=aErros[nX]+ CRLF
		Next nX
		//Testando se o arquivo já existe
		If File(cArqCPag)
			lOk := MsgYesNo("Arquivo já existe, deseja substituir?", "Atenção")
		EndIf
		If lOk
			MemoWrite(cArqCPag, cTexto)
			MsgInfo("Arquivo Gerado com Sucesso:"+CRLF+cArqCPag,"Atenção")
		EndIf
	EndIf
Return

User Function jmata200()

Local PARAMIXB1 := {}
Local PARAMIXB2 := {}
Local aGets     := {}
Local lOK       := .T.
Local cString   := ''
 
Private lMsErroAuto := .F.
 
Default PARAMIXB3 := 3
 
//------------------------//| Abertura do ambiente |//----------------------------
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "PCP" TABLES "SB1","SG1","SG5"
ConOut(Repl("-",80))
ConOut(PadC("Teste de rotina automatica para estrutura de produtos",80))
//------------------------//| Teste de Inclusao |//-------------------------------
 
If PARAMIXB3==3
    PARAMIXB1 := {{"G1_COD","PA001",NIL},;
                {"G1_QUANT",1,NIL},;
                {"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura
    aGets := {}
    aadd(aGets,{"G1_COD","PA001",NIL})
    aadd(aGets,{"G1_COMP","PI001",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI001",NIL})
    aadd(aGets,{"G1_COMP","PI002",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI001",NIL})
    aadd(aGets,{"G1_COMP","MP002",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI002",NIL})
    aadd(aGets,{"G1_COMP","MP001",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PA001",NIL})
    aadd(aGets,{"G1_COMP","PI003",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PA001",NIL})
    aadd(aGets,{"G1_COMP","MP004",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI003",NIL})
    aadd(aGets,{"G1_COMP","MP003",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
 
    If lOk
        ConOut("Teste de Inclusao")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3)
        //Inclusao
        ConOut("Fim: "+Time())
    EndIf
Else
    //--------------- Exemplo de Exclusao ------------------------------------
    If lOk
        SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+PadR('PA001',Len(SG1->G1_COD))))
        PARAMIXB1 := {{"G1_COD","PA001",NIL},;
        {"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular
        // ou nao a estrutura
        ConOut("Teste de Exclusao do codigo PA001")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)
        //Exclusao
        lOk := !lMsErroAuto
        ConOut("Fim: "+Time())
    EndIf
 
    If lOk
        SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+PadR('PI001',Len(SG1->G1_COD))))
        PARAMIXB1 := {{"G1_COD","PI001",NIL},; 
		{"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular
        // ou nao a estrutura
        ConOut("Teste de Exclusao do codigo PI001")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)
        //Exclusao
        lOk := !lMsErroAuto
        ConOut("Fim: "+Time())
    EndIf
 
    If lOk
        SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+PadR('PI002',Len(SG1->G1_COD))))
        PARAMIXB1 := {{"G1_COD","PI002",NIL},; 
		{"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular
        // ou nao a estrutura
        ConOut("Teste de Exclusao do codigo PI002")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)
        //Exclusao
        lOk := !lMsErroAuto
        ConOut("Fim: "+Time())
    EndIf
 
    If lOk
        SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+PadR('PI003',Len(SG1->G1_COD))))
        PARAMIXB1 := {{"G1_COD","PI003",NIL},; 
		{"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular
        // ou nao a estrutura
        ConOut("Teste de Exclusao do codigo PI003")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5) //Exclusao
        ConOut("Fim: "+Time()) 
	EndIf
    EndIf
 
    If lMsErroAuto
        If IsBlind()
            If IsTelnet()
                VTDispFile(NomeAutoLog(),.t.)
            Else
                cString := MemoRead(NomeAutoLog())
                Aviso("Aviso de Erro:",cString)
            EndIf
        Else
            MostraErro()
        EndIf
    Else
        If lOk
            Aviso("Aviso","Operacao efetuada com sucesso",{"Ok"})
        Else
            Aviso("Aviso","Fazer os devidos cadastros",{"Ok"})
        EndIf
    Endif

 
Return


//SUBSTITUICAO ITEM ESPECIFICO


User Function MyMATA200()
 
Local PARAMIXB1 := {}
Local PARAMIXB2 := {}
Local PARAMIXB3 := 7
 
Private lMsErroAuto := .F.
 
//------------------------//| Abertura do ambiente |//---------------------------------------------
RPCSetType(3)
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "SIGAPCP" TABLES "SB1","SG1","SG5","SC2","SD4"
ConOut(Repl("-",80))
ConOut(PadC("Teste de rotina automatica para estrutura de produtos",80))
//------------------------//| Teste de Substituição |//--------------------------------------------
 
aadd(PARAMIXB1,{"G1_CODORIG","9475-MP3",NIL})
aadd(PARAMIXB1,{"G1_GRPORIG","",NIL})
aadd(PARAMIXB1,{"G1_OPCORIG","",NIL})
 
aadd(PARAMIXB1,{"G1_SEQORIG","001",NIL}) //Este campo não é obrigatório. Se for passado, filtrará o componente a ser substituído por uma sequência específica.
 
aadd(PARAMIXB1,{"G1_CODDEST","9475-MP4",NIL})
aadd(PARAMIXB1,{"G1_GRPDEST","",NIL})
aadd(PARAMIXB1,{"G1_OPCDEST","",NIL})
aadd(PARAMIXB1,{"ALTEMPENHO","S",NIL}) //Se altera os empenhos. S = Sim e N = Não.
//Este campo não é obrigatório. Se ele não estiver no array, será considerado N - Não.
 
// Informar os itens Pais que será feito a substituição do componente origem pelo componente destino
 
aadd(PARAMIXB2,{"G1_COD","94751-PA",NIL})  
aadd(PARAMIXB2,{"G1_COD","PI002",NIL}) 
 
MSExecAuto({|x,y,Z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3) //Substituição
 
If lMsErroAuto 
    MostraErro()   
Else
    alert("Substituição efetuada com sucesso") 
Endif
 
Return

//EXCLUSAO ITEM ESPECÍFICO

User Function ExcMyMATA200()
 
Local cItemPai := "PA-20868       "
Local cFilho1  := "MP-20868       "
Local cFilho2  := "MP-20868-2     "
Local cSeqTrt  := "   "
Local aCab     := {}
Local aItem    := {}
Local aDetalhe := {}
 
Private lMsErroAuto := .F.
 
aCab := {{"G1_COD"      , cItemPai  , NIL},;
         {"ATUREVSB1"   , "S"       , NIL},;
         {"NIVEL1"      , "S"       , NIL},;
         {"NIVALT"      , "S"       , NIL},;
         {"G1_QUANT"    , 1         , NIL}}
 
aadd(aDetalhe, {"G1_COD"    , cItemPai              , NIL})
aadd(aDetalhe, {"G1_COMP"   , cFilho1               , NIL})
aadd(aDetalhe, {"G1_TRT"    , cSeqTrt               , NIL})
aadd(aDetalhe, {"G1_INI"    , dDataBase             , NIL})
aadd(aDetalhe, {"G1_FIM"    , DaySum(dDataBase, 365), NIL})
aadd(aDetalhe, {"G1_FIXVAR" ,"V"                    , NIL})
aadd(aDetalhe, {"G1_QUANT"  , 1                     , NIL})
aadd(aDetalhe, {"G1_PERDA"  , 0                     , NIL})
 
aadd(aItem,aDetalhe)
 
dbSelectArea('SG1')
SG1->(dbSetOrder(1))
if SG1->(dbSeek(xFilial('SG1')+cItemPai))
    MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,4) //Alteração ou Exclusão de Item não enviado no array aItem
Else
    MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,3)
Endif
 
If lMsErroAuto 
    MostraErro()   
Else
    alert("Alteração/Exclusão item efetuada com sucesso") 
Endif
 
Return
