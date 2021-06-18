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


/*/{Protheus.doc} FGPER012
(Rotina para geração de relatorio de acordo de compensação)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER012()

	Local c_Perg		:= "FGPER012"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Acordo Compensação","Esta rotina tem a finalidade de imprimir o acordo compensação", " ", "Desenvolvido pela Totvs Bahia","FGPER012")

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
(Função que realiza a integração com o Word)
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

	c_FileOpen	:= getmv("FS_DIRDOT") + "FGPER012.dot"


	If Empty(c_FileOpen)
		Aviso(SM0->M0_NOMECOM,"O Arquivo .dot não foi informado. Impossível continuar.",{"Ok"},2,"Atenção")
		Return()
	Endif

	LjMsgRun("Aguarde... Gerando Relatório","Acordo compensação",{|| f_GeraRelatorio( c_FileOpen ) })

Return()

// Geracao Relatorio

/*/{Protheus.doc} f_GeraRelatorio
(Função para geração de acordo de compensação)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_FileOpen, character, (parâmetro contendo o caminho do modelo word de acordo de compensação)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function f_GeraRelatorio( c_FileOpen )

	Local o_Word   	:= NIL
	Local c_GrvFile	:= getmv("FS_DIRDOC") + "FGPER012.doc"


	BEGINSQL ALIAS "QRY"

		SELECT RA_NOME, RA_MAT, RA_SITFOLH, RA_NUMCP, RA_SERCP, RA_UFCP
		FROM %TABLE:SRA% SRA
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND SRA.RA_MAT BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		--AND SRA.RA_SITFOLH = %EXP:" "%
		AND SRA.%NOTDEL%

	ENDSQL

	DbSelectArea("QRY")


	If QRY->( Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
	   QRY->(DBCLOSEAREA())
		Return()
	EndIF

	WHILE QRY->(!EOF())

		o_Word := OLE_CreateLink()

		If (o_Word == "1")
			Alert("word não encontrado!")
			Return
		Endif

		OLE_NewFile( o_Word, c_FileOpen )

		c_Carteira   := Alltrim(QRY->RA_NUMCP) + "-" + Alltrim(QRY->RA_SERCP) + "-" + Alltrim(QRY->RA_UFCP)
		c_EndEmpresa := Alltrim(SM0->M0_CIDCOB) + "-" + Alltrim(SM0->M0_ESTCOB) + "   " + Alltrim(SM0->M0_ENDCOB) + "  " + Alltrim(SM0->M0_CEPCOB)

			OLE_SetDocumentVar(o_Word,"c_Empresa"    , Alltrim(SM0->M0_NOMECOM))
			OLE_SetDocumentVar(o_Word,"c_EndEmpresa" , c_EndEmpresa)
			OLE_SetDocumentVar(o_Word,"c_Nome"       , Alltrim(QRY->RA_NOME ) )
			OLE_SetDocumentVar(o_Word,"c_Carteira"   , c_Carteira )
			OLE_SetDocumentVar(o_Word,"c_Data"       ,  STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4) )


		c_GrvFile	:= GETMV("FS_DIRDOC") + Alltrim( QRY->RA_NOME ) + " - FGPER012.doc"

		OLE_UpDateFields(o_Word)
		OLE_SaveAsFile(o_Word, c_GrvFile)
		OLE_CloseLink(o_Word)

		ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)
		QRY->(DBSKIP())

	ENDDO

	QRY->(DBCLOSEAREA())


Return()


/*/{Protheus.doc} f_ValidPerg
(Funcao criação de pergunta)
@author lucas.jesus
@since 12/12/2014
@version 1.0
@param c_Perg, character, (Parâmetro com o nome da pergunta)
@return Null, Nao tem retorno
@example
(examples)
@see (links_or_references)
/*/
Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02	       := {}

	Aadd(a_PAR01, "Informe a matrícula inicial:")
	Aadd(a_PAR02, "Informe a matrícula final:")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Informe a matrícula de?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Informe a matrícula até?  ","","","mv_ch2","C",06,0,0,"G","","SRA","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)

Return()