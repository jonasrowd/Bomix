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



/*/{Protheus.doc} FGPER003
(Rotina para impressao da relacao de funcionarios demitidos)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER003()

	Local c_Perg		:= "FGPER003"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Rela��o de funcion�rios demitidos","Esta rotina tem a finalidade de imprimir a rela��o de funcion�rios demitidos", " ", "Desenvolvido pela Totvs Bahia","FGPER003")

	If l_Opcao

		f_ValidPerg(c_Perg)
		If !Pergunte(c_Perg, .T.)
			Return
		EndIf
		f_IntWord()

	Else
		Return()
	EndIf

Return

// Integracao WORD

/*/{Protheus.doc} f_IntWord
(Funcao de integracao com Word)
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

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER003.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot n�o foi informado. Imposs�vel continuar.",{"Ok"},2,"Aten��o")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando relat�rio","Rela��o de funcion�rios demitidos",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Funcao reponsavel por gerar relatorio do word)
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
	Local nCont := 0
	Local o_Word   	:= NIL
	Local c_GrvFile	:= getmv("FS_DIRDOC") + "FGPER003.doc"


	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH, RA_DEMISSA, RA_NASC, RA_CRACHA, Q3_DESCSUM
		FROM %TABLE:SRA% SRA
		INNER JOIN %TABLE:SQ3% SQ3 ON (SQ3.Q3_CARGO = SRA.RA_CARGO AND SQ3.%NOTDEL%)
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND MONTH(SRA.RA_DEMISSA) BETWEEN MONTH(%EXP:DTOS(MV_PAR01)%) AND MONTH(%EXP:DTOS(MV_PAR02)%)
		AND SRA.RA_SITFOLH = %EXP:"D"%
		AND SRA.%NOTDEL%

	ENDSQL

	If !(Select("QRY") > 0 )
		QRY->(DBCLOSEAREA())
		DbSelectArea("QRY")
	Endif

	If QRY->( Eof() )

		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		QRY->(DBCLOSEAREA())
		Return()

	Endif

	o_Word := OLE_CreateLink()

	If (o_Word == "1")
		Alert("word n�o econtrado!")
		Return
	Endif

	OLE_NewFile( o_Word, c_FileOpen )

	OLE_SetDocumentVar( o_Word, 'c_Emp' , SM0->M0_NOMECOM)
	OLE_SetDocumentVar( o_Word, 'c_CNPJ' , SM0->M0_CGC)


	While QRY->( !Eof() )

		nI++
      If SRA->RA_SITFOLH == "D"
		OLE_SetDocumentVar(o_Word,"c_Matricula1"+Alltrim(str(nI)),Alltrim(QRY->RA_MAT) )
		OLE_SetDocumentVar(o_Word,"c_Nome1"+Alltrim(str(nI)),Alltrim( QRY->RA_NOME ) )
		OLE_SetDocumentVar(o_Word,"c_Demissa1"+Alltrim(str(nI)),STOD(QRY->RA_DEMISSA))
		OLE_SetDocumentVar(o_Word,"c_Cargo1"+Alltrim(str(nI)),Alltrim( QRY->Q3_DESCSUM ) )
		OLE_SetDocumentVar(o_Word,"c_CartPonto"+Alltrim(str(nI)),QRY->RA_CRACHA)
     EndIf
		QRY->( DbSkip() )

	Enddo

	QRY->(DBCLOSEAREA())

	If nI > 0
		OLE_SetDocumentVar(o_Word,'Ind_Demissa',alltrim(Str(nI))) //Nome do indicado da tabela no WORD
		OLE_ExecuteMacro(o_Word,"mcrDemissa") // Nome da macro usada para atualiYar os itens
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

	Aadd(a_PAR01, "Informe o per�odo de:")
	Aadd(a_PAR02, "Informe o per�odo at�:")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Per�odo de?   ","","","mv_ch1","D",08,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Per�odo at�?   ","","","mv_ch2","D",08,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()