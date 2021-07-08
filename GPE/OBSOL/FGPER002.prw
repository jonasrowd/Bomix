#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"

#DEFINE OLECREATELINK  400
#DEFINE OLECLOSELINK   401
#DEFINE OLEOPENFILE    403
#DEFINE OLESAVEASFILE  405
#DEFINE OLECLOSEFILE   406
#DEFINE OLESETPROPERTY 412
#DEFINE OLEWDVISIBLE   "206"
#DEFINE WDFORMATTEXT   "2"
#DEFINE WDFORMATPDF    "17" // FORMATO PDF


#DEFINE ENTER CHR(10)+CHR(13)

#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE


/*/{Protheus.doc} FGPER002
(Rotina responsavel por gerar contrato a titulo de experiencia)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, N�o tem Retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER002()

	Local c_Perg		:= "FGPER002"

	Private o_Telas	:= clsTelasGen():New()
//Private l_Opcao	:= o_Telas:mtdOkCancel("Janela de Teste da Classe TestaTelas","Esta rotina tem a finaldade de", "Imprimir o abono pecuniario", "Desenvolvido pela Totvs Bahia")
	Private l_Opcao	:= o_Telas:mtdParOkCan("Contrato de Experi�ncia","Esta rotina tem a finalidade de imprimir o contrato de trabalho a t�tulo de experi�ncia", "", "Desenvolvido pela Totvs Bahia","FGPER002")

	If l_Opcao

		f_ValidPerg(c_Perg)
		If !Pergunte(c_Perg, .T.)
			Return()
		Endif
		f_IntWord()

	Else
		//Alert("Clicou no Cancelar")
		Return()
	EndIf

Return


/*/{Protheus.doc} f_IntWord
Funcao de intrega��o com Word
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_IntWord()

	Local n_Opc		:= 0	//Botao selecionado
	Local c_FileOpen	:= ""	//Path do arquivo .dot

	Local c_MaskCNPJ	:= ""

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER002.dot"

	IF EMPTY(c_FileOpen)
		AVISO(SM0->M0_NOMECOM,"O Arquivo .dot n�o foi informado. Imposs�vel continuar.",{"Ok"},2,"Aten��o")
		Return()
	ENDIF

	LjMsgRun("Aguarde... Gerando Relat�rio","Contrato a T�tulo de Experi�ncia",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

/*/{Protheus.doc} f_GeraRelatorio
(Funcao reponsavel por gerar relatorio do word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Caminho do arquivo Word)
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local o_Word     	:= NIL
	Local c_GrvFile	:= getmv("FS_DIRDOC") + "FGPER002.doc"
	o_Word := OLE_CreateLink()
     
	If (o_Word < "0")
	     Help(" ",1,"A9810004") //"MS-WORD nao encontrado nessa maquina !!"
	//     Return
	Endif

	OLE_NewFile( o_Word, c_FileOpen )

	OLE_SetDocumentVar( o_Word, 'c_Empresa' , SM0->M0_NOMECOM)
	OLE_SetDocumentVar( o_Word, 'c_Cnpj' , SM0->M0_CGC)

	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )                             
	SRA->( DbSeek(xFilial("SRA")+ MV_PAR01 ))

	IF SRA->(!EOF())

		DbSelectArea("SQ3")
		SQ3->( DbSetOrder(1) )
		SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO ))

		DbSelectArea("SQ3")
		SR6->( DbSetOrder(1) )
		SR6->( DbSeek(xFilial("SR6")+SRA->RA_TNOTRAB ))


		OLE_SetDocumentVar( o_Word, 'c_Endereco' 	, Alltrim(SM0->M0_ENDCOB))
		OLE_SetDocumentVar( o_Word, 'c_Bairro' 	, Alltrim(SM0->M0_BAIRENT))
		OLE_SetDocumentVar( o_Word, 'c_Cidade' 	, Alltrim(SM0->M0_CIDENT))
		OLE_SetDocumentVar( o_Word, 'c_Func'	   , Alltrim(SRA->RA_NOME))
		OLE_SetDocumentVar( o_Word, 'c_Ctps'		, Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP))
		OLE_SetDocumentVar( o_Word, 'c_Est'		, Alltrim(SM0->M0_ESTCOB))
		OLE_SetDocumentVar( o_Word, 'c_Cep' 		, Transform(Alltrim(SM0->M0_CEPCOB), "@R 99999-999"))
		OLE_SetDocumentVar( o_Word, 'c_Cargo'		, Alltrim(SQ3->Q3_DESCSUM )    )
		OLE_SetDocumentVar( o_Word, 'c_Salario'	, SRA->RA_SALARIO)
		OLE_SetDocumentVar( o_Word, 'c_SalExt'		, Extenso(SRA->RA_SALARIO))
		OLE_SetDocumentVar( o_Word, 'c_Local'		, Alltrim(SM0->M0_CIDCOB))
		OLE_SetDocumentVar( o_Word, 'c_Est1'		, Alltrim(SM0->M0_ESTCOB))
		OLE_SetDocumentVar( o_Word, 'c_Horario'	    , mv_par02)
		OLE_SetDocumentVar( o_Word, 'c_Intervalo'	    , mv_par03)
		OLE_SetDocumentVar( o_Word, 'd_Inicio'		 , SRA->RA_ADMISSA)
		OLE_SetDocumentVar( o_Word, 'c_Cidade' 	 , Alltrim(SM0->M0_CIDENT))
		OLE_SetDocumentVar( o_Word, 'd_Data' 	    , STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4))

		SRA->(DBCLOSEAREA())
		SQ3->(DBCLOSEAREA())
		SR6->(DBCLOSEAREA())

	ELSE
		AVISO("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		SRA->(DBCLOSEAREA())
		Return()
	EndIF

	OLE_UpDateFields( o_Word )
	OLE_SaveAsFile( o_Word, c_GrvFile )
	OLE_CloseLink( o_Word )
	
	ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

Return()


/*/{Protheus.doc} f_ValidPerg
Criacao de Pergunta
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_Perg, character, (Nome da pergunta)
@return null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}

	Aadd(a_PAR01, "Informe a matr�cula do colaborador:")
	Aadd(a_PAR02, "Hor�rio de trabalho:")
	Aadd(a_PAR03, "Intervalo:")


	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matr�cula Colaborador?   ","","","mv_ch0","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Horario?   ","","","mv_ch1","C",10,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
	PutSx1(c_Perg,"03","Intervalo?   ","","","mv_ch2","C",10,0,0,"G","","","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)

Return()