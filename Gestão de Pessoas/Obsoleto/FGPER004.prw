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

/*/{Protheus.doc} FGPER004
(Rotina para gerar relacao de funcionarios)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER004()

	Local c_Perg		:= "FGPER004"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCancel("Relação de Funcionários","Esta rotina tem a finalidade de imprimir a relação de funcionários", "", "Desenvolvido pela Totvs Bahia")

	If l_Opcao

		f_IntWord()

	Else
		Return()
	EndIf

Return

// Integracao WORD

/*/{Protheus.doc} f_IntWord
(Funcao para integracao com word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_IntWord()

	Local n_Opc			:= 0	//Botao selecionado
	Local c_FileOpen	:= ""	//Path do arquivo .dot

	c_FileOpen	:= getmv("FS_DIRDOC") + "FGPER004.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Relação de Funcionários",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Funcao para gerar relatorio )
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Caminho para salvar arquivo word .doc)
@return null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local nI  := 0
	Local o_Word   	:= NIL
	Local c_GrvFile	:= getmv("FS_DIRDOT") + "FGPER004.doc"


	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH, RA_ADMISSA,Q3_DESCSUM
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SQ3% SQ3 ON (SQ3.Q3_CARGO = SRA.RA_CARGO AND SQ3.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		--AND SRA.RA_ADMISSA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
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
		Alert("Word não encontrado!")
		Return
	Endif

	OLE_NewFile( o_Word, c_FileOpen )

	OLE_SetDocumentVar( o_Word, 'c_Emp' , SM0->M0_NOMECOM)
	OLE_SetDocumentVar( o_Word, 'c_CNPJ' , SM0->M0_CGC)

	While QRY->(!Eof())


		nI++
		OLE_SetDocumentVar(o_Word,"c_Matricula1"+Alltrim(str(nI)),Alltrim(QRY->RA_MAT) )
		OLE_SetDocumentVar(o_Word,"c_Nome1"+Alltrim(str(nI)),Alltrim(QRY->RA_NOME) )
		OLE_SetDocumentVar(o_Word,"c_Admis1"+Alltrim(str(nI)),STOD(QRY->RA_ADMISSA) )
		OLE_SetDocumentVar(o_Word,"c_Cargo"+Alltrim(str(nI)),Alltrim(QRY->Q3_DESCSUM) )

		QRY->( DbSkip() )

	Enddo

	QRY->(DBCLOSEAREA())

	If nI > 0
		OLE_SetDocumentVar(o_Word,'ind_Func1',alltrim(Str(nI))) //Nome do indicado da tabela no WORD
		OLE_ExecuteMacro(o_Word,"mcrFunc") // Nome da macro usada para atualiYar os itens
	Endif

	OLE_SetDocumentVar(o_Word,"n_Total", nI )

	OLE_UpDateFields( o_Word )
	OLE_SaveAsFile( o_Word, c_GrvFile )
	OLE_CloseLink( o_Word )

	ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

Return()




