#INCLUDE "rwmake.ch"
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBFOL   º Autor ³ Edlardo Neves      º Data ³  02/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Contabilização da Folha e Provisões.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ctbfol()
	Local c_Perg   	 := "ctbfol    "
	Local cFilAntBck := cFilAnt
	Private cString  := ""
	Private aLanc 	 := {}


	PutSx1( c_Perg, "01","Nº do Lote","","","mv_ch1","C",10,0,0,"G","","" ,"","","mv_par01"," "," "," ",""," "," "," "," "," "," "," "," "," ","","","")

	pergunte(c_Perg, .T. )

	cAlias := GetNextAlias()     
	
	IF Empty( MV_PAR01 )
		Alert("Operação cancelada, o Lote não foi preenchido!")
		Return
	Else
		
		cQuery := " SELECT CENTROCUSTOCREDITO AS CCC, CENTROCUSTODEBITO AS CCD, "
		cQuery += " CAST(  SUBSTRING(VALOR ,1,LEN(VALOR)-2) +'.'+ SUBSTRING(VALOR, LEN(VALOR)-1, 2)  AS FLOAT)   VALOR2 ,"
		cQuery += " * FROM VW_INTEGRACAO_FOLHA_CONTABILIDADE "
		cQuery += " WHERE LOTE = '"+ Alltrim(MV_PAR01) +"' "
		cQuery += " AND SUBSTRING(FILIAL,1,2) = '"+ CEMPANT +"' "
		
	EndIf
	
	If Select("T01") > 0
		T01->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias T01
	

	WHILE !T01->(EOF()) 
		_cFil := ""
		
		_cFil := substr(T01->FILIAL,3,6)	
		
		IF !EMPTY(ALLTRIM( _cFil ))    
			cFilAnt := _cFil
		ENDIF       
	
		aadd(aLanc, {cFilAnt, T01->CONTA_DEBITO, T01->CONTA_CREDITO, T01->VALOR2, Substr( T01->HISTORICO, 1, 40 ), T01->CCC, T01->CCD, T01->DATA}) 	

		T01->(DBSKIP())

	ENDDO

	T01->(DbCloseArea())

	IF ApMsgYesNo ( "Imprime Relatorio", "TOTVS" )
		U_RCTBFOL(aLanc)
	ENDIF

	IF ApMsgYesNo ( "Gera Contabilização", "TOTVS" )
		U_RCTBA100(aLanc,"A01")
	ENDIF
	
	cFilAnt := cFilAntBck 
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCTBA100  ³ Autor ³ Joel T argino          Data ³ 02/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Contabilização			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCTBA100(_aItens,cLanPad)

	//fContabiliza(_aItens,cLanPad)
	Processa({|| fContabiliza(_aItens,cLanPad) }, "Processando","Aguarde...",.F.)
	
Return

Static Function fContabiliza(_aItens,cLanPad)

	If MsgYesNo("Mostra lançamento contabil?","Totvs")
		lDigita   := .T.
	Else
		lDigita   := .F.
	EndIF

	aEstru := {}
	aAdd(aEstru,{"TRB_FILIAL","C",06,0})
	aAdd(aEstru,{"TRB_DEBITO","C",20,0})
	aAdd(aEstru,{"TRB_CREDIT","C",20,0})
	aAdd(aEstru,{"TRB_DEBIT3","C",20,0})
	aAdd(aEstru,{"TRB_CREDI3","C",20,0})
	aAdd(aEstru,{"TRB_CCD"   ,"C",20,0})
	aAdd(aEstru,{"TRB_CCC"   ,"C",20,0})
	aAdd(aEstru,{"TRB_ITEMD" ,"C",20,0})
	aAdd(aEstru,{"TRB_ITEMC" ,"C",20,0})
	aAdd(aEstru,{"TRB_HISTT" ,"C",50,0})
	aAdd(aEstru,{"TRB_VALOR" ,"N",15,2})
	aAdd(aEstru,{"TRB_VALOR3" ,"N",15,2})

	cArqTRB := CriaTrab(aEstru,.T.)
	Use &cArqTRB Alias TRB New
	_cIndex:=Criatrab(Nil,.F.)
	_cChave:="TRB_FILIAL"
	Indregua("TRB",_cIndex,_cchave,,,"Selecionando Registros...")
	dBSETINDEX(_cIndex+ordbagext()) 

	DbSelectArea("TRB")
	Index on TRB_FILIAL To &cArqTRB

	For i:=1 to Len(_aItens)
		TRB->(RecLock("TRB",.T.))
		TRB->TRB_FILIAL := _aItens[i,1]
		TRB->TRB_HISTT	:= IIF(EMPTY(ALLTRIM(_aItens[i,5])),"HIST",_aItens[i,5])
		TRB->TRB_DEBITO := STRTRAN(_aItens[i,2], ".", "")
		TRB->TRB_CREDIT	:= STRTRAN(_aItens[i,3], ".", "")
		TRB->TRB_VALOR	:= ABS(_aItens[i,4]) // Valor do lançamento tipo 1 (Real)   

		TRB->TRB_CCD	:= IIF( SUBSTR(TRB->TRB_DEBITO,1,1) $ "3_4",_aItens[i,7],"" )     
		TRB->TRB_CCC	:= IIF( SUBSTR(TRB->TRB_CREDIT,1,1) $ "3_4",_aItens[i,6],"" )

		//TRB->TRB_ITEMC	:= IIF( SUBSTR(TRB->TRB_CREDIT,1,1) $ "3_4",_aItens[i,7],"" )
		//TRB->TRB_ITEMD	:= IIF( SUBSTR(TRB->TRB_DEBITO,1,1) $ "3_4",_aItens[i,7],"" ) 

		TRB->(msUnLock())
	Next

	//Contabilizacao
	aRotina := {}
	cArquivo := "TRB"
	nTotal    := 0
	cLote     := StrZero( Val( SUBSTR(MV_PAR01,1,6) ) , 6) 
	cPadrao   := "A01" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	nHdlPrv:= HeadProva(cLote,"RCTBA100",Alltrim(cUserName),@cArquivo)

	DbSelectArea("TRB")
	ProcRegua(RecCount())
	TRB->(DbGoTop())

	While !Eof("TRB")
		//CEMPANTAnt := substr(TRB->TRB_FILIAL,1,4)
		cFilAnt := TRB->TRB_FILIAL

		Do While !Eof("TRB") .AND. substr(Alltrim(cFilAnt),1,4) == substr(Alltrim(TRB->TRB_FILIAL),1,4)
			IncProc("Gerando Lançamento Contábil...")

			nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"RCTBA100",cLote)

			DbSelectArea("TRB")
			TRB->(DbSkip())
		EndDo

		RodaProva(nHdlPrv,nTotal)

		// Envia para Lancamento Contabil
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.

	EndDo
	
	TRB->(DbCloseArea())
	
	MsgInfo("Contabilização finalizada com sucesso!")
	
Return


User Function RCTBFOL()
	Local oReport
	Local cQuery
	Local _cTime := ""
	Private _nTotal := 0
	Private _cFilial := ""
	Private _cStatus := ""


	oReport := ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem 	:= {}

	oReport := TReport():New("CTBFOL","Relatorio Contabilidade da Folha","",{|oReport| PrintReport(oReport)},"Relatorio Contabilidade da Folha")
	oReport:SetLandscape()
	//oReport:SetTotalInLine(.F.)


	oSection := TRSection():New(oReport,"Relatorio Contabilidade da Folha",{},/*aOrdem*/)

	TRCell():New(oSection,"DEBITO"	    ,"","Debito","@!",20)
	TRCell():New(oSection,"CREDITO"	    ,"","Credito","@!",11)
	TRCell():New(oSection,"CCD"	        ,"","Centro Custo Debito","@!",40) 
	TRCell():New(oSection,"CCC"	        ,"","Centro Custo Credito","@!",40)  
	TRCell():New(oSection,"HISTO"	    ,"","Historico","@!",40)  
	TRCell():New(oSection,"VALOR"	    ,"","Valor","@!",11)


Return oReport

/*Inicia Logica Print Report */

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local oBreak
	Local cPart
	Local cCase
	Local nCont
	Local cCodigos		:= ""
	Local aVerbas		:= {}
	Local _cStatus
	Local cCodigo 	:= ""
	Local aUser 	:= {}
	Local cQuery 	:= " " 
	oSection:Init()
	/*
	cQuery := " SELECT ISNULL(CONTA_DEBITO,'') CONTA_DEBITO , ISNULL(VALORD,0) VALORD, ISNULL(CONTA_CREDITO,'') CONTA_CREDITO, ISNULL(VALORC,0) VALORC FROM ( "
	cQuery += " 			SELECT CONTA_DEBITO,  SUM(CAST(VALOR AS INT)) VALORD FROM VW_INTEGRACAO_FOLHA_CONTABILIDADE  "        
	cQuery += " 			WHERE LOTE = '"+ Alltrim(MV_PAR01) +"' "
	cQuery += " 			AND SUBSTRING(FILIAL,1,2) = '"+ CEMPANT +"' "
	cQuery += " 			GROUP BY CONTA_DEBITO "
	cQuery += " 	) TESTE "
	cQuery += " 	FULL JOIN ( "
	cQuery += " 			SELECT CONTA_CREDITO, SUM(CAST(VALOR AS INT)) VALORC FROM VW_INTEGRACAO_FOLHA_CONTABILIDADE  "        
	cQuery += " 			WHERE LOTE ='"+ Alltrim(MV_PAR01) +"' "
	cQuery += " 			AND SUBSTRING(FILIAL,1,2) = '"+ CEMPANT +"' "
	cQuery += " 			GROUP BY CONTA_CREDITO "
	cQuery += " 	) TESTE2 ON CONTA_CREDITO = CONTA_DEBITO   "
	cQuery += " ORDER BY CONTA_DEBITO, CONTA_CREDITO "
	*/
	
	cQuery := " SELECT CONTA_DEBITO, CONTA_CREDITO, CENTROCUSTOCREDITO AS CCC, CENTROCUSTODEBITO AS CCD,  HISTORICO, "
	cQuery += "SUM( CAST(  SUBSTRING(VALOR ,1,LEN(VALOR)-2) +'.'+ SUBSTRING(VALOR, LEN(VALOR)-1, 2)  AS FLOAT) )  VALOR "
	cQuery += "FROM VW_INTEGRACAO_FOLHA_CONTABILIDADE    "
	cQuery += "WHERE LOTE = '"+ Alltrim(MV_PAR01) +"'  AND SUBSTRING(FILIAL,1,2) =  '"+ CEMPANT +"' "
	cQuery += "GROUP BY  CONTA_DEBITO, CONTA_CREDITO, CENTROCUSTOCREDITO, CENTROCUSTODEBITO, HISTORICO "
	cQuery += "ORDER BY CONTA_DEBITO, CONTA_CREDITO "
	
	If Select("T02") > 0
		T02->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias T02
	
	WHILE !T02->(EOF()) 

		oReport:IncMeter()

		oSection:Cell( "DEBITO"		):SetBlock( { || T02->CONTA_DEBITO  })
		oSection:Cell( "CREDITO"	):SetBlock( { || T02->CONTA_CREDITO	})
		oSection:Cell( "CCD"		):SetBlock( { || T02->CCD  			})
		oSection:Cell( "CCC"		):SetBlock( { || T02->CCC			})
		oSection:Cell( "HISTO"	):SetBlock( { || T02->HISTORICO  	})
		oSection:Cell( "VALOR"		):SetBlock( { || T02->VALOR			})
		
		oSection:PrintLine()

		T02->(DBSKIP())
	ENDDO

	T02->(DbCloseArea())
	
	oSection:Finish()

Return

