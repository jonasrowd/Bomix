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


/*/{Protheus.doc} FGPER013
(Rotina para geração de comunicado de ponto eletronico)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER013()

	Local c_Perg		:= "FGPER013"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("COMUNICADO","Esta rotina tem a finalidade de imprimir comunicado de ponto eletrônico", " ", "Desenvolvido pela Totvs Bahia","FGPER013")

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
(Funcao de integração com word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_IntWord()

	Local n_Opc			:= 0	//Botao selecionado
	Local c_FileOpen	:= ""	//Path do arquivo .dot

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER013.dot"

	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Comunicado",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio
/*/{Protheus.doc} f_GeraRelatorio
(Função para geração de comunicado de ponto eletronico)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Parâmetro com caminho do modelo do comunicado (arquivo .dot))
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local o_Word   	:= NIL
	Local c_GrvFile	:= " "

	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH
		FROM %TABLE:SRA% SRA
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND SRA.RA_MAT BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		--AND SRA.RA_SITFOLH = %EXP:" "%
		AND SRA.%NOTDEL%

	ENDSQL

	DbSelectArea("QRY")

	If QRY->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	o_Word := OLE_CreateLink()

	If (o_Word == "1")
		Alert("word não encontrado!")
		Return
	Endif

	If QRY->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	WHILE QRY->(!EOF())

		o_Word := OLE_CreateLink()

		If (o_Word == "1")
			Alert("Word não encontrado!")
			Return
		Endif

		OLE_NewFile( o_Word, c_FileOpen )

		OLE_SetDocumentVar(o_Word,"c_Matricula"    , Alltrim(QRY->RA_MAT))
		OLE_SetDocumentVar(o_Word,"c_Nome"       , Alltrim(QRY->RA_NOME ) )
		OLE_SetDocumentVar(o_Word,"c_Data"       ,  STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4) )

		c_GrvFile	:= GETMV("FS_DIRDOC") + Alltrim( QRY->RA_NOME ) + " - FGPER013.doc"

		OLE_UpDateFields(o_Word)
		OLE_SaveAsFile(o_Word, c_GrvFile)
		OLE_CloseLink(o_Word)

		ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

		QRY->(DBSKIP())

	ENDDO

	QRY->(DBCLOSEAREA())

	OLE_UpDateFields(o_Word)
	OLE_SaveAsFile(o_Word, c_GrvFile)
	OLE_CloseLink(o_Word)

	ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

Return()

/*/{Protheus.doc} f_ValidPerg
(Função para criação de perguntas)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_Perg, character, (Parâmetro com nome da pergunta)
@return null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}

	Aadd(a_PAR01, "Informe a matrícula de:")
	Aadd(a_PAR02, "Informe a matrícula até:")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matrícula de?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Matrícula até?  ","","","mv_ch2","C",06,0,0,"G","","SRA","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()