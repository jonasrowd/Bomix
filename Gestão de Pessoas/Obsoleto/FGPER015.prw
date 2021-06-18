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


/*/{Protheus.doc} FGPER015
(Rotina para geração de relatorio de relação de aniversariantes)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER015()

	Local c_Perg		:= "FGPER015"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Relação de aniversariantes","Esta rotina tem a finalidade de imprimir a relação de aniversariantes", " ", "Desenvolvido pela Totvs Bahia","FGPER015")

 	f_ValidPerg(c_Perg)
	If l_Opcao
		If !Pergunte(c_Perg, .T.)
			return
		EndIf
		f_IntWord()

	Else
		Return()
	EndIf

Return

// Integracao WORD

/*/{Protheus.doc} f_IntWord
(Função de intregação com word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_IntWord()

	Local n_Opc			:= 0	//Botao selecionado
	Local c_FileOpen	:= ""	//Path do arquivo .dot

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER015.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Relação de aniversariantes",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Função para geração da relação de de aniversariantes)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Parâmetro com caminho do modelo de relação de aniversariantes (.dot))
@return Null, Não tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local nI  			:= 0
	Local nCont 		:= 0
	Local o_Word   	:= NIL
	Local c_GrvFile	:= GETMV("FS_DIRDOC") + "FGPER015.doc"


	o_Word := OLE_CreateLink()

	If (o_Word == "1")
		Alert("Word não encontrado!")
		Return
	Endif

	OLE_NewFile( o_Word, c_FileOpen )

	DBSELECTAREA("SRA")

	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH, RA_ADMISSA, RA_NASC, RA_CRACHA, Q3_DESCSUM
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SQ3% SQ3 ON (SQ3.Q3_CARGO = SRA.RA_CARGO AND SQ3.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND MONTH(SRA.RA_NASC) BETWEEN MONTH(%EXP:DTOS(MV_PAR01)%) AND MONTH(%EXP:DTOS(MV_PAR02)%)
		--AND SRA.RA_SITFOLH = %EXP:" "%
		AND SRA.%NOTDEL%

	ENDSQL

	If !(Select("QRY") > 0 )
		QRY->(DBCLOSEAREA())
		DbSelectArea("QRY")
	Endif

	If QRY->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		QRY->(DBCLOSEAREA())
		Return()
	Endif

	OLE_SetDocumentVar( o_Word, 'c_Emp' , SM0->M0_NOMECOM)
	OLE_SetDocumentVar( o_Word, 'c_CNPJ' , SM0->M0_CGC)

	WHILE QRY->(!EOF())

		nI++
		OLE_SetDocumentVar(o_Word,"c_Mat"+Alltrim(str(nI)),Alltrim(QRY->RA_MAT) )
		OLE_SetDocumentVar(o_Word,"c_Nome"+Alltrim(str(nI)),Alltrim( QRY->RA_NOME ) )
		OLE_SetDocumentVar(o_Word,"c_Admis"+Alltrim(str(nI)),STOD(QRY->RA_ADMISSA))
		OLE_SetDocumentVar(o_Word,"c_Cargo"+Alltrim(str(nI)),(QRY->Q3_DESCSUMS))
		OLE_SetDocumentVar(o_Word,"c_Nasc"+Alltrim(str(nI)),STOD(QRY->RA_NASC))
		OLE_SetDocumentVar(o_Word,"c_SitAtual"+Alltrim(str(nI)),QRY->RA_SITFOLH)
		OLE_SetDocumentVar(o_Word,"c_CartPonto"+Alltrim(str(nI)),QRY->RA_CRACHA)

		QRY->(DBSKIP())

	ENDDO

	QRY->(DBCLOSEAREA())

	If nI > 0
		OLE_SetDocumentVar(o_Word,'ind_Aniver',alltrim(Str(nI))) //Nome do indicado da tabela no WORD
		OLE_ExecuteMacro(o_Word,"mcrAniver") // Nome da macro usada para atualiYar os itens
	Endif

	OLE_SetDocumentVar(o_Word,"n_Total", nI)

	OLE_UpDateFields( o_Word )
	OLE_SaveAsFile( o_Word, c_GrvFile )
	OLE_CloseLink( o_Word )

	ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

Return()


Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}

	Aadd(a_PAR01, "Informe o período de:")
	Aadd(a_PAR02, "Informe o período até:")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Período de?   ","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Período até?   ","","","mv_ch2","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()
