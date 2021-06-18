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


/*/{Protheus.doc} FGPER008
(Rotina para geraçao de Ficha de recadastramento)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER008()

	Local c_Perg		:= "FGPER008"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Ficha de Recastramento","Esta rotina tem a finalidade de imprimir a ficha para recastramento", "", "Desenvolvido pela Totvs Bahia","FGPER008")

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
(Funcao para integraçao com Word)
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

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER008.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Ficha de Recastramento",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Funcao para geração de relatorio Word)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (Parametro com caminho do modelo do arquivo )
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local nI  := 0
	Local o_Word   	:= NIL
	Local c_GrvFile	:= getmv("FS_DIRDOC") +"FGPER008.doc"


	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH, RA_ENDEREC, RA_COMPLEM, RA_BAIRRO, RA_MUNICIP,
		RA_ESTADO, RA_CEP, RA_DDDFONE, RA_TELEFON, RA_DDDCELU, RA_NUMCELU, RA_ESTCIVI, Q3_DESCSUM
		FROM %TABLE:SRA% SRA
	   --	INNER JOIN %TABLE:SQ3% SQ3 ON (SQ3.Q3_CARGO = SRA.RA_CARGO AND SQ3.%NOTDEL%)
	  --	WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
	 --	AND SRA.RA_MAT BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		--AND SRA.RA_SITFOLH = %EXP:" "%
		AND SRA.%NOTDEL%

	ENDSQL

	DbSelectArea("QRY")

	If QRY->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	WHILE QRY->(!EOF())

		o_Word := OLE_CreateLink()

		If (o_Word == "1")
			Alert("word não encontrado!")
			Return
		Endif

		OLE_NewFile( o_Word, c_FileOpen )

		Do Case
		Case QRY->RA_ESTCIVI = "C"
			c_Estcivi := "Casado(a)"
		Case QRY->RA_ESTCIVI = "D"
			c_Estcivi := "D-Divorciado(a)"
		Case QRY->RA_ESTCIVI = "M"
			c_Estcivi := "Marital"
		Case QRY->RA_ESTCIVI = "Q"
			c_Estcivi := "Desquitado(a)/Separado(a)"
		Case QRY->RA_ESTCIVI = "S"
			c_Estcivi := "Solteiro(a)"
		Case QRY->RA_ESTCIVI = "V"
			c_Estcivi := "Viuvo(a)"
		End Case

		OLE_SetDocumentVar(o_Word,"c_Nome"     , Alltrim(QRY->RA_NOME ) )
		OLE_SetDocumentVar(o_Word,"c_Matricula", Alltrim(QRY->RA_MAT ) )
		OLE_SetDocumentVar(o_Word,"c_Cargo"    , Alltrim(QRY->Q3_DESCSUM ) )
		OLE_SetDocumentVar(o_Word,"c_Enderec"  , Alltrim(QRY->RA_ENDEREC ) )
		OLE_SetDocumentVar(o_Word,"c_Complem"  , Alltrim(QRY->RA_COMPLEM ) )
		OLE_SetDocumentVar(o_Word,"c_Bairro"   , Alltrim(QRY->RA_BAIRRO ) )
		OLE_SetDocumentVar(o_Word,"c_Municip"  , Alltrim(QRY->RA_MUNICIP ) )
		OLE_SetDocumentVar(o_Word,"c_Estado"   , Alltrim(QRY->RA_ESTADO ) )
		OLE_SetDocumentVar(o_Word,"c_Cep"      , Alltrim(QRY->RA_CEP ) )
		OLE_SetDocumentVar(o_Word,"c_DDDFone"  , Alltrim(QRY->RA_DDDFONE ) )
		OLE_SetDocumentVar(o_Word,"c_Telefon"  , Alltrim(QRY->RA_TELEFON ) )
		OLE_SetDocumentVar(o_Word,"c_DDDCelu"  , Alltrim(QRY->RA_DDDCELU ) )
		OLE_SetDocumentVar(o_Word,"c_Numcelu"  , Alltrim(QRY->RA_NUMCELU ) )
		OLE_SetDocumentVar(o_Word,"c_Estcivi"  , Alltrim(c_EstCivi ) )

		c_GrvFile	:= GETMV("FS_DIRDOC") + Alltrim( QRY->RA_NOME ) + " - FGPER008.doc"

		OLE_UpDateFields( o_Word )
		OLE_SaveAsFile( o_Word, c_GrvFile )
		OLE_CloseLink( o_Word )

		ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)

		QRY->(DBSKIP())

	ENDDO

	DbCloseArea("QRY")

Return()


/*/{Protheus.doc} f_ValidPerg
(Funcao para criacao de pergunta)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_Perg, character, (Parametro que contem o nome da pergunta)
@return ${return}, ${return_description}
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
	PutSx1(c_Perg,"02","Matrícula até?   ","","","mv_ch2","C",06,0,0,"G","","SRA","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
Return()