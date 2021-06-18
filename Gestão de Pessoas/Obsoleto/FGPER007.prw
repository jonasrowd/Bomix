#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

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


/*/{Protheus.doc} FGPER007
(Rotina para geração de carta de abertura de conta)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER007()

	Local c_Perg		:= "FGPER007"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Carta de abertura de conta","Esta rotina tem a finalidade de imprimir a carta de abertura de conta", " ", "Desenvolvido pela Totvs Bahia","FGPER007")

	If l_Opcao

		f_ValidPerg(c_Perg)
		If !Pergunte(c_Perg, .T.)
			Return()
		Endif
		f_IntWord()

	Else
		Return()
	EndIf

Return

// Integracao WORD

/*/{Protheus.doc} f_IntWord
(Rotina para integração com Word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_IntWord()

	Local n_Opc			:= 0	//Botao selecionado
	Local c_FileOpen	:= ""	//Path do arquivo .dot

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER007.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Carta de abertura de conta",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Funcao de geração de relatorio)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Contem o caminho para salvar arquivo Word(.doc))
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function f_GeraRelatorio( c_FileOpen )

Local nI  := 0
Local nCont := 0
Local o_Word   	:= NIL
Local c_GrvFile	:= getmv("FS_DIRDOC") + "FGPER007.doc"

o_Word := OLE_CreateLink()

If (o_Word == "1")
	Alert("word não encontrado!")
	Return
Endif

OLE_NewFile( o_Word, c_FileOpen )

OLE_SetDocumentVar( o_Word, 'c_Empresa' , SM0->M0_NOMECOM)
OLE_SetDocumentVar( o_Word, 'c_CNPJ' , SM0->M0_CGC)

DbSelectArea("SRA")
SRA->( DbSetOrder(1) )
SRA->( DbSeek(xFilial("SRA")+mv_par01 ))

If SRA->( Eof() )
	Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
	Return()
Else

	OLE_SetDocumentVar(o_Word, 'c_Local' 	, SM0->M0_CIDENT)
	OLE_SetDocumentVar(o_Word, 'd_Data' 	, STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4))
	OLE_SetDocumentVar(o_Word,"c_Nome",Alltrim( SRA->RA_NOME ) )
	OLE_SetDocumentVar(o_Word,"c_NomeBanco", mv_PAR04 )
    OLE_SetDocumentVar(o_Word,"c_LocalBanco", mv_PAR05 )
    OLE_SetDocumentVar(o_Word,"c_ContaBanco", mv_PAR07 )
    OLE_SetDocumentVar(o_Word,"c_AgenciaBanco", mv_PAR06 )
	OLE_SetDocumentVar(o_Word,"c_End",Alltrim(SRA->RA_ENDEREC) )
	OLE_SetDocumentVar(o_Word,"c_Bairro",Alltrim(SRA->RA_BAIRRO) )
	OLE_SetDocumentVar(o_Word,"d_Admissa",SRA->RA_ADMISSA)
	OLE_SetDocumentVar(o_Word,"c_Ctps",SRA->RA_NUMCP + " - " + SRA->RA_SERCP + " - " + SRA->RA_UFCP )
	OLE_SetDocumentVar(o_Word,"c_Registro" , SRA->RA_RG)
	OLE_SetDocumentVar(o_Word,"c_CPF",Transform(Alltrim(SRA->RA_CIC), "@R  999.999.999-99"))
	OLE_SetDocumentVar(o_Word,"c_Salario",SRA->RA_SALARIO)
	OLE_SetDocumentVar(o_Word,"c_SalExt",Extenso(SRA->RA_SALARIO))
	OLE_SetDocumentVar(o_Word,"c_Resp",mv_par02)
	OLE_SetDocumentVar(o_Word,"c_Setor",mv_par03)

ENDIF

DbCloseArea("SRA")


OLE_UpDateFields( o_Word )
OLE_SaveAsFile( o_Word, c_GrvFile )
OLE_CloseLink( o_Word )

ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

Return()


/*/{Protheus.doc} f_ValidPerg
(Funcao para criar pergunta)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_Perg, character, (Variavel com nome da pergunta)
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}
	Local a_PAR05        := {}
	Local a_PAR06        := {}
	Local a_PAR07        := {}
	Local a_PAR08        := {}

	Aadd(a_PAR01, "Informe a matrícula do colaborador:")
	Aadd(a_PAR02, "Informe o nome responsável pela declaração:")
	Aadd(a_PAR03, "Informe o cargo do responsável:")
	Aadd(a_PAR04, "Informe o nome do banco:")
	Aadd(a_PAR05, "Informe o local do banco:")
	Aadd(a_PAR06, "Informe a agência do banco:")
	Aadd(a_PAR07, "Informe o número da conta:")


	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matrícula Colaborador?   ","","","mv_ch0","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Nome Responsável?        ","","","mv_ch1","C",35,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
	PutSx1(c_Perg,"03","Cargo Responsável?       ","","","mv_ch2","C",35,0,0,"G","","","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)
	PutSx1(c_Perg,"04","Nome do Banco?        ","","","mv_ch3","C",35,0,0,"G","","","","","mv_PAR04","","","","","","","","","","","","","","","","",a_PAR04)
	PutSx1(c_Perg,"05","Local do Banco?        ","","","mv_ch4","C",35,0,0,"G","","","","","mv_PAR05","","","","","","","","","","","","","","","","",a_PAR05)
	PutSx1(c_Perg,"06","Número da Agência?        ","","","mv_ch5","C",35,0,0,"G","","","","","mv_PAR06","","","","","","","","","","","","","","","","",a_PAR06)
	PutSx1(c_Perg,"07","Número da Conta?        ","","","mv_ch6","C",35,0,0,"G","","","","","mv_PAR07","","","","","","","","","","","","","","","","",a_PAR07)


Return()