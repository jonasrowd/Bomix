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


/*/{Protheus.doc} FGPER019
(Rotina para geração de relatorio com relação de prazos de contratos)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER019()

	Local c_Perg		:= "FGPER019"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Relação de Prazos de Contratos","Esta rotina tem a final	dade de imprimir a relação de prazos de contratos", "", "Desenvolvido pela Totvs Bahia","FGPER019")

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
(Função que realiza a integração com word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_IntWord()

	Local n_Opc		:= 0 	  //Botao selecionado
	Local c_FileOpen	:= ""	 //Path do arquivo .dot

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER019.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM, "O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Relação de prazos de contratos",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Função que gera a relação de prazos de contratos)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Parâmetro com caminho do modelo do arquivo da relação de prazos de contratos)
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local nI  := 0
	Local o_Word   	:= NIL
	Local c_GrvFile	:=getmv("FS_DIRDOC") + "FGPER019.doc"


	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_ADMISSA, RA_VCTOEXP, RA_VCTEXP2, RA_VIEMRAI, Q3_DESCSUM
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SQ3% SQ3 ON (SQ3.Q3_CARGO = SRA.RA_CARGO AND SQ3.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND SRA.RA_VCTOEXP BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		OR SRA.RA_VCTEXP2 BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		--AND SRA.RA_SITFOLH = %EXP:" "%
		AND SRA.%NOTDEL%

	ENDSQL


	DbSelectArea("QRY")

	If QRY->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		QRY->(DBCLOSEAREA())
		Return()
	Endif

	o_Word := OLE_CreateLink()

	If (o_Word == "1")
		Alert("word não encontrado!")
		Return
	Endif

	OLE_NewFile( o_Word, c_FileOpen )


	OLE_SetDocumentVar( o_Word, 'c_Emp' , SM0->M0_NOMECOM)
	OLE_SetDocumentVar(o_Word,"c_Per1", mv_Par01)
	OLE_SetDocumentVar(o_Word, "c_Per2", mv_Par02)

	While QRY->( !Eof() )

		nDias := Day((dDataBase)) - Day(STOD(QRY->RA_ADMISSA))

		nI++
		OLE_SetDocumentVar(o_Word,"c_Mat"+Alltrim(str(nI)),Alltrim(QRY->RA_MAT) )
		OLE_SetDocumentVar(o_Word,"c_Nome"+Alltrim(str(nI)),Alltrim( QRY->RA_NOME) )
		OLE_SetDocumentVar(o_Word,"c_Admis"+Alltrim(str(nI)),STOD(QRY->RA_ADMISSA) )
		OLE_SetDocumentVar(o_Word,"c_Cargo"+Alltrim(str(nI)),Alltrim(QRY->Q3_DESCSUM ) )
		OLE_SetDocumentVar(o_Word,"c_Exp1"+Alltrim(str(nI)), STOD(QRY->RA_VCTOEXP) )
		OLE_SetDocumentVar(o_Word,"c_Exp2"+Alltrim(str(nI)), STOD(QRY->RA_VCTEXP2) )
		OLE_SetDocumentVar(o_Word,"c_DiasExp1"+Alltrim(str(nI)), mv_Par03)
		OLE_SetDocumentVar(o_Word,"c_DiasExp2"+Alltrim(str(nI)), mv_Par04)
		OLE_SetDocumentVar(o_Word,"c_Vinculo"+Alltrim(str(nI)),QRY->RA_VIEMRAI)
		OLE_SetDocumentVar(o_Word,"c_Dias"+Alltrim(str(nI)), nDias )


	QRY->( DbSkip() )

Enddo

QRY->(DBCLOSEAREA())

If nI > 0
	OLE_SetDocumentVar(o_Word,'ind_Prazos',alltrim(Str(nI))) //Nome do indicado da tabela no WORD
	OLE_ExecuteMacro(o_Word,"mcrPrazos") // Nome da macro usada para atualiYar os itens
Endif


OLE_UpDateFields( o_Word )
OLE_SaveAsFile( o_Word, c_GrvFile )
OLE_CloseLink( o_Word )

ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

Return()


/*/{Protheus.doc} f_ValidPerg
(Funcao para criação de pergunta)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_Perg, character, (Parâmetro com nome da pergunta)
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}

	Aadd(a_PAR01, "Informe o período de:")
	Aadd(a_PAR02, "Informe o período até:")
	Aadd(a_PAR03, "Informe a quantidade de dias do primeiro período:")
	Aadd(a_PAR04, "Informe a quantidade de dias do segundo período::")


	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Período de?","","","mv_ch0","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Período até?","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
	PutSx1(c_Perg,"03","Número de dias do primeiro período?","","","mv_ch2","N",08,0,0,"G","","","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)
	PutSx1(c_Perg,"04","Número de dias do segundo período","","","mv_ch3","N",08,0,0,"G","","","","","mv_PAR04","","","","","","","","","","","","","","","","",a_PAR04)

Return()


