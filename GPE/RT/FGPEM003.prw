#INCLUDE "TOTVS.CH"
#INCLUDE "APWIZARD.CH"       


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGPEM003	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera��o de documentos em lote.		                      ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE			                                          ���
�������������������������������������������������������������������������͹��
*/

User Function FGPEM003	
	
	Private o_Combo
	Private oWizard
	Private a_fil		:= {}
	Private c_fil		:= FWCodFil()
	Private a_acessos	:= FWEmpLoad(.F.)
	Private n_cont		:= 1
	Private	oOK			:= LoadBitmap(GetResources(),'br_verde')
	Private oNO			:= LoadBitmap(GetResources(),'br_vermelho')
	Private	a_cabec		:= {"", "C�digo", "Modelo"}
	Private a_tamcb		:= {20, 25      , 140}
	Private a_arqsel	:= {}
	Private	a_campos	:= {"RAFILIAL", "RAMAT"}
	Private a_cab2		:= {}
	Private a_itens		:= {}
	Private a_arqs		:= {}		
	Private n_usado 	:= 0
	Private n_posfil	:= 0
	Private n_posmat	:= 0
	Private n_posnome	:= 0
	Private bLinOk 		:= {|| f_LOK()}
	Private oPrinter  	:= tAvPrinter():New("DOCUMENTA��ES")
	Private oArial12N   := TFont():New("Arial Narrow",,12,,.T.,,,,,.F.,.F.)
	Private oArial10  	:= TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
	Private oArial9  	:= TFont():New("Arial Narrow",,9,,.F.,,,,,.F.,.F.)
	Private oArial12  	:= TFont():New("Arial Narrow",,12,,.F.,,,,,.F.,.F.)
	Private oArial4  	:= TFont():New("Arial Narrow",,4,,.F.,,,,,.F.,.F.)
	Private cImag001	:= "C:\Users\ivan.cardoso\Documents\TDS\Workspace\TDS112\BOMIX\IMAGENS\RODAP�.png"
	Private oArial13N	:= TFont():New("Arial",,13,,.T.,,,,,.F.,.F.)
	Private o11N	   	:= TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private o11NI		:= TFont():New("",,11,,.T.,,,,,.F.,.T.)
	Private o14N		:= TFont():New("",,14,,.T.,,,,,.F.,.F.)
	Private o14			:= TFont():New("",,14,,.F.,,,,,.F.,.F.)
	Private o10N	    := TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private o10	    	:= TFont():New("",,10,,.F.,,,,,.F.,.F.)
	Private oArial10N	:= TFont():New("Arial",,12,,.T.,,,,,.F.,.F.)
	Private oArial�32N	:= TFont():New("Arial Narrow",,32,,.T.,,,,,.F.,.F.)
	Private oArial�32	:= TFont():New("Arial Narrow",,32,,.F.,,,,,.F.,.F.)
	Private oVerda10N	:= TFont():New("Verdana",,10,,.T.,,,,,.F.,.F.)
	Private oVerda10	:= TFont():New("Verdana",,10,,.F.,,,,,.F.,.F.)
	Private oVerdan10  	:= TFont():New("Verdana",,12,,.F.,,,,,.F.,.F.)
	Private o13	    	:= TFont():New("",,13,,.F.,,,,,.F.,.F.)	
	
	for n_cont := 1 to len(a_acessos)
		aadd(a_fil, a_acessos[n_cont, 3])
	next
	
	oPrinter:SetPortrait()
		
	//PAINEL 1 - APRESENTA��O
		DEFINE WIZARD oWizard;
			TITLE alltrim(SM0->M0_NOMECOM) + " - Assistente para Gera��o de Documentos em Lote";
			HEADER "Gera��o de Documentos em Lote";
			TEXT "Assistente respons�vel pela gera��o de documentos em lote, a partir de modelos existentes." + CRLF +;
				 "Clique em AVAN�AR para iniciar.";
		NEXT {|| .T.}
	//FIM
	
	//PAINEL 2 - SELE��O DA FILIAL
		CREATE PANEL oWizard;
			HEADER "Sele��o da Filial";
			MESSAGE "Selecione a Filial dos documentos a serem gerados.";
			PANEL BACK {|| .T.};
		NEXT {|| f_P2A()}
		oSayFIL	:= TSay():New(60,140,{|| FWFilName(FWGrpCompany(), c_fil)},oWizard:oMPanel[2],,,,,,.T.,,,150,20)
		o_Combo := TComboBox():New(60,90,{|u|if(PCount()>0,c_fil:=u,c_fil)}, a_fil,40,20,oWizard:oMPanel[2],,{|| oSayFIL:SetText(FWFilName(FWGrpCompany(), c_fil))},,,,.T.,,,,,,,,,"c_fil")
		o_Combo:Select(ascan(a_fil, c_fil))
	//FIM
	
	//PAINEL 3 - SELE��O DOS MODELOS
		CREATE PANEL oWizard;
			HEADER "Modelos Dispon�veis";
			MESSAGE "Selecione os modelos para gera��o dos documentos." + CRLF +;
					"Obs: clique duplo ou <ENTER> para marcar e desmarcar.";
			PANEL BACK {|| .T.};
		NEXT {|| f_P3A()}
		oBrw1 := TCBrowse():New(000,000,__DlgWidth(oWizard:oMPanel[3]),__DlgHeight(oWizard:oMPanel[3]) - 25,,a_cabec,a_tamcb,oWizard:oMPanel[3],,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
		oBrw1:bLine := {|| {oOK, "", ""}}
		oBrw1:bLDblClick := {|| f_CDPL() }
		oBtnLeg	:= TButton():New(130,50,"Legenda",oWizard:oMPanel[3],{|| f_Leg()},50,10,,,,.T.,,"",,,,.F.)
		oBtnMT 	:= TButton():New(130,100,"Marca Todos",oWizard:oMPanel[3],{|| f_MT()},50,10,,,,.T.,,"",,,,.F.)
		oBtnDT 	:= TButton():New(130,150,"Desmarca Todos",oWizard:oMPanel[3],{|| f_DT()},50,10,,,,.T.,,"",,,,.F.)
		oBtnIS 	:= TButton():New(130,200,"Inverte Sele��o",oWizard:oMPanel[3],{|| f_IS()},50,10,,,,.T.,,"",,,,.F.)
	//FIM
	
	//PAINEL 4 - SELE��O DAS MATR�CULAS
		CREATE PANEL oWizard;
			HEADER "Matr�culas";
			MESSAGE "Informe as matr�culas para a gera��o dos documentos." + CRLF +;
					"Obs: seta para baixo para adicionar matr�cula.";
			PANEL BACK {|| .T.};
		NEXT {|| f_P4A()}
		f_PC()
		f_PI()
		oMSNGD := MsNewGetDados():New(0,0,__DlgHeight(oWizard:oMPanel[4]) - 27,__DlgWidth(oWizard:oMPanel[4]), GD_INSERT + GD_UPDATE + GD_DELETE,"Eval(bLinOk)",,,a_campos,,999,,,,oWizard:oMPanel[4],a_cab2,a_itens)
	//FIM
	
	//PAINEL 5 - FINALIZA��O
		CREATE PANEL oWizard;
			HEADER "Finaliza��o";
			MESSAGE "Processo Finalizado.";
			PANEL BACK {|| aviso(alltrim(SM0->M0_NOMECOM) + " Mensagem","A partir desse ponto, a volta n�o � permitida. Finalize o assistente.",{"OK"},1,"Aviso"), .F.};
		FINISH {|| .T.}
	//FIM
	
	ACTIVATE WIZARD oWizard CENTERED
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_P2A()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � PAINEL 2 - AVAN�AR.										  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_P2A()

	Local l_ret 	:= .T.
	Local a_comp 	:= {}
	Local c_comp	:= ""
	
	a_arqs			:= {}
	
	do case
		case c_fil == "010101"
			aadd(a_arqs, {.F., "001", "Contrato de Experi�ncia - Ind�stria"})			
			aadd(a_arqs, {.F., "004", "Acordo de Compensa��o de Horas - Administrativo"})
			aadd(a_arqs, {.F., "005", "Termo de Sigilo - Administrativo"})
			aadd(a_arqs, {.F., "014", "Comunicado Marca��o de Ponto Eletr�nico"})
		case c_fil == "010102"
			aadd(a_arqs, {.F., "004", "Acordo de Compensa��o de Horas - Administrativo"})
			aadd(a_arqs, {.F., "005", "Termo de Sigilo - Administrativo"})
			aadd(a_arqs, {.F., "010", "Contrato de Experi�ncia - Vendedor"})			
		case c_fil == "020101"
			aadd(a_arqs, {.F., "001", "Contrato de Experi�ncia - Ind�stria"})
			aadd(a_arqs, {.F., "004", "Acordo de Compensa��o de Horas - Administrativo"})
			aadd(a_arqs, {.F., "005", "Termo de Sigilo - Administrativo"})
			aadd(a_arqs, {.F., "010", "Contrato de Experi�ncia - Vendedor"})
			aadd(a_arqs, {.F., "011", "Contrato de Experi�ncia - Motorista"})			
		case c_fil == "030101"			
			aadd(a_arqs, {.F., "011", "Contrato de Experi�ncia - Motorista"})
			aadd(a_arqs, {.F., "012", "Contrato de Experi�ncia - Auxiliar de P�tio"})
	endcase
	
	aadd(a_arqs, {.F., "002", "Contrato de Experi�ncia - Administrativo"})
	aadd(a_arqs, {.F., "003", "Acordo de Compensa��o de Horas"})
	aadd(a_arqs, {.F., "006", "Recibo de Integra��o"})
	aadd(a_arqs, {.F., "007", "Termo de Compromisso/Autoriza��o de Desconto do VT"})
	aadd(a_arqs, {.F., "008", "Comprovante de Devolu��o da CTPS"})
	aadd(a_arqs, {.F., "009", "Termo de Prorroga��o da Experi�ncia"})
	aadd(a_arqs, {.F., "013", "Op��o Vale Transporte"})
	
	asort(a_arqs,,,{|x,y| x[2]<y[2]})
	oBrw1:SetArray(a_arqs)
	oBrw1:bLine := {|| {iif(a_arqs[oBrw1:nAt,1], oOK, oNO), a_arqs[oBrw1:nAt,2], a_arqs[oBrw1:nAt,3]}}

Return(l_ret)

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  	 �f_MT()	�Autor  �Pablo VB Carvalho   � Data �  22/05/2017 ���
�����������������������������������������������������������������������������͹��
���Desc.         � Marca todos os itens.                   					  ���
�����������������������������������������������������������������������������͹��
���Uso           � FGPEM003			                                          ���
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

Static Function f_MT()

	Local n_cont := 1
	
	while n_cont <= len(a_arqs)
		a_arqs[n_cont][1] := .T.
		n_cont ++
	enddo
	oBrw1:DrawSelect()

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  	 �f_MT()	�Autor  �Pablo VB Carvalho   � Data �  22/05/2017 ���
�����������������������������������������������������������������������������͹��
���Desc.         � Desmarca todos os itens.                					  ���
�����������������������������������������������������������������������������͹��
���Uso           � FGPEM003			                                          ���
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

Static Function f_DT()

	Local n_cont := 1
	
	while n_cont <= len(a_arqs)
		a_arqs[n_cont][1] := .F.
		n_cont ++
	enddo
	oBrw1:DrawSelect()

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  	 �f_IS()	�Autor  �Pablo VB Carvalho   � Data �  22/05/2017 ���
�����������������������������������������������������������������������������͹��
���Desc.         � Inverte a sele��o.	                					  ���
�����������������������������������������������������������������������������͹��
���Uso           � FGPEM003			                                          ���
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

Static Function f_IS()

	Local n_cont := 1
	
	while n_cont <= len(a_arqs)
		a_arqs[n_cont][1] := !a_arqs[n_cont][1]
		n_cont ++
	enddo
	oBrw1:DrawSelect()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_CDPL()	� Autor �PABLO VB CARVALHO   � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Clique duplo no browse dos itens.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_CDPL()

	a_arqs[oBrw1:nAt][1] := !a_arqs[oBrw1:nAt][1]
	oBrw1:DrawSelect()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_P3A()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � PAINEL 3 - AVAN�AR.										  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_P3A()

	Local l_ret := .F.
	Local n_cont := 1
	
	a_arqsel := {}
	while n_cont <= len(a_arqs)
		if a_arqs[n_cont][1]
			aadd(a_arqsel, a_arqs[n_cont][2])
			l_ret := .T.
		endif
		n_cont ++
	enddo
	
	if !l_ret
		alert("Selecione ao menos um modelo para continuar.")
	endif
	
Return(l_ret)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_Leg()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Legenda.													  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_Leg()
	
	BrwLegenda("Gest�o de Pessoal","Legenda dos modelos",{		{"ENABLE"		,"Selecionado"},;
														{"DISABLE"		,"N�o Selecionado"}})
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_PC()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Preenche cabe�alho da msnewgetdados.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_PC()
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SRA")
	While !Eof() .And. (x3_arquivo == "SRA")
		if alltrim(X3_CAMPO) == "RA_FILIAL" .or. alltrim(X3_CAMPO) == "RA_MAT" .or. alltrim(X3_CAMPO) == "RA_NOMECMP"
			if (X3USO(x3_usado) .AND. cNivel >= x3_nivel) .or. alltrim(X3_CAMPO) == "RA_FILIAL"
				n_usado ++
				AADD(a_cab2,{TRIM(x3_titulo),substr(X3_CAMPO,1,2) + alltrim(substr(X3_CAMPO,4,7)),;
				 x3_picture,x3_tamanho, x3_decimal,,x3_usado, x3_tipo,,x3_context})
			Endif
		endif
		dbSkip()
	EndDo
	
	n_posfil				:= aScan(a_cab2,{|x| alltrim(x[2]) == "RAFILIAL"})
	n_posmat				:= aScan(a_cab2,{|x| alltrim(x[2]) == "RAMAT"})
	n_posnome				:= aScan(a_cab2,{|x| alltrim(x[2]) == "RANOMECMP"})
	a_cab2[n_posfil][6]		:= "U_FGPEM004()" //VALIDA��O
	a_cab2[n_posfil][9]   	:= "XM0"          //F3
	a_cab2[n_posmat][6]		:= "U_FGPEM005()" //VALIDA��O
	a_cab2[n_posmat][9]   	:= "SRA"          //F3
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_PI()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Preenche cabe�alho da msnewgetdados.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_PI()

	Local n_cont := 1
	
	a_itens := Array(1, n_usado + 1)
	n_usado := 0
	While n_cont <= len(a_cab2)
		n_usado ++
		if a_cab2[n_cont, 8] == "C"
			a_itens[1][n_usado] := SPACE(a_cab2[n_cont, 4])
		Elseif a_cab2[n_cont, 8] == "N"
			a_itens[1][n_usado] := 0
		Elseif a_cab2[n_cont, 8] == "D"
			a_itens[1][n_usado] := dDataBase
		Elseif a_cab2[n_cont, 8] == "M"
			a_itens[1][n_usado] := ""
		Else
			a_itens[1][n_usado] := .F.
		Endif
		n_cont ++
	EndDo
	a_itens[1][n_usado + 1] := .F.

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_LOK()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da linha.                  					  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_LOK()

	Local l_ret 	:= .F.
	Local l_dupl 	:= .F.
	Local n_cont	:= 1
	Local c_film	:= alltrim(oMSNGD:acols[oMSNGD:nAt, n_posfil])
	Local c_mat 	:= alltrim(oMSNGD:acols[oMSNGD:nAt, n_posmat])
	Local c_nome	:= alltrim(oMSNGD:acols[oMSNGD:nAt, n_posnome])
	
	if empty(c_film)
		alert("Filial n�o pode ficar em branco.")
	else
		if empty(c_mat)
			alert("Matr�cula n�o pode ficar em branco.")
		else
			if empty(c_nome)
				alert("Nome n�o pode ficar em branco.")
			else
				if len(oMSNGD:acols) >= 2
					while n_cont <= len(oMSNGD:acols) .and. !l_dupl
						if n_cont <> oMSNGD:nAt .and.;
						!oMSNGD:acols[n_cont, Len(oMSNGD:aHeader) + 1] .and.;
						c_film == alltrim(oMSNGD:acols[n_cont, n_posfil]) .and.;
						c_mat == alltrim(oMSNGD:acols[n_cont, n_posmat]) .and.;
						c_nome == alltrim(oMSNGD:acols[n_cont, n_posnome])
							l_dupl := .T.
						endif
						n_cont ++
					enddo
				endif
				if l_dupl
					alert("Funcion�rio j� informado na linha " + cvaltochar(n_cont - 1) + ".")
				else
					l_ret := .T.
				endif
			endif
		endif
	endif
	
Return(l_ret)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_P4A()	�Autor  �Pablo VB Carvalho	 � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � PAINEL 4 - AVAN�AR.										  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_P4A()

	Local l_ret  	:= .F.
	Local n_cont 	:= 1
	Local n_cont2	:= 1
	Local l_dupl 	:= .F.
	Local c_fil		:= ""
	Local c_mat 	:= ""
	Local c_nome	:= ""
	
	while n_cont <= len(oMSNGD:acols) .and. !l_ret
		if !oMSNGD:acols[n_cont, Len(oMSNGD:aHeader) + 1] .and. !empty(alltrim(oMSNGD:acols[n_cont, 1])) .and. !empty(alltrim(oMSNGD:acols[n_cont, 2])) .and. !empty(alltrim(oMSNGD:acols[n_cont, 3]))
			l_ret := .T.
		endif
		n_cont ++
	enddo
	
	if !l_ret
		alert("Informe ao menos um funcion�rio para continuar.")
	else
		if len(oMSNGD:acols) >= 2
			n_cont := 1
			while n_cont <= len(oMSNGD:acols) .and. !l_dupl
				if !oMSNGD:acols[n_cont, Len(oMSNGD:aHeader) + 1]
					c_fil := alltrim(oMSNGD:acols[n_cont, n_posfil])
					c_mat := alltrim(oMSNGD:acols[n_cont, n_posmat])
					c_nome:=alltrim(oMSNGD:acols[n_cont, n_posnome])
					n_cont2 := 1
					while n_cont2 <= len(oMSNGD:acols) .and. !l_dupl
						if !oMSNGD:acols[n_cont2, Len(oMSNGD:aHeader) + 1] .and.;
						c_fil == alltrim(oMSNGD:acols[n_cont2, n_posfil]) .and.;
						c_mat == alltrim(oMSNGD:acols[n_cont2, n_posmat]) .and.;
						c_nome == alltrim(oMSNGD:acols[n_cont2, n_posnome]) .and.;
						n_cont <> n_cont2
							l_dupl := .T.
						endif
						n_cont2 ++
					enddo
				endif
				n_cont ++
			enddo
			if l_dupl
				alert("Existem funcion�rios duplicados. Corrija para poder prosseguir.")
				l_ret := .F.
			else
				if apmsgyesno("Confirma a gera��o dos documentos?")
					processa({|| f_proc() }, "Aguarde", "Processando...")
				else
					l_ret := .F.
				endif
			endif
		else
			if apmsgyesno("Confirma a gera��o dos documentos?")
				processa({|| f_proc() }, "Aguarde", "Processando...")
			else
				l_ret := .F.
			endif
		endif
	endif

Return(l_ret)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_proc	  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento.											  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_proc()

	Local n_cont2 	:= 1
	Local n_cont3	:= 1
	Local n_totfunc	:= 0
		
	for n_cont2 := 1 to len(oMSNGD:acols) //varre a msnew de funcion�rios para saber quantos registros ir� processar
		if !oMSNGD:acols[n_cont2, Len(oMSNGD:aHeader) + 1]
			n_totfunc ++ 
		endif
	next	
	
	procregua(n_totfunc * len(a_arqsel))
	
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	DbSelectArea("SR6")
	SR6->(DbSetOrder(1))
	DbSelectArea("SRJ")
	SRJ->(DbSetOrder(1))
	DbSelectArea("SPJ")
	SPJ->(DbSetOrder(1))
	DbSelectArea("SQ3")
	SQ3->(DbSetOrder(1))

	for n_cont2 := 1 to len(oMSNGD:acols) //varre a msnew de funcion�rios para a impress�o
		if !oMSNGD:acols[n_cont2, Len(oMSNGD:aHeader) + 1]
			SRA->(DbSeek(oMSNGD:acols[n_cont2, n_posfil] + oMSNGD:acols[n_cont2, n_posmat]))
			SR6->(DbSeek(SRA->RA_FILIAL + SRA->RA_TNOTRAB))
			SRJ->(DbSeek(substr(SRA->RA_FILIAL, 1, 4) + "  " + SRA->RA_CODFUNC))
			SPJ->(DbSeek(SRA->RA_FILIAL + ALLTRIM(SRA->RA_TNOTRAB)))
			SQ3->(DbSeek(xFilial("SQ3") + SRA->RA_CARGO))
			SM0->(DbSeek(FWGrpCompany() + SRA->RA_FILIAL))
			for n_cont3 := 1 to len(a_arqsel) //varre o vetor de modelos selecionados
				do case
					case a_arqsel[n_cont3] == "001" //FGPER2A.PRW - Contrato de Experi�ncia - Ind�stria.
						oPrinter:StartPage()
						f_FGPER2A()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "002" //FGPER002.PRW - Contrato de Experi�ncia - Administrativo.
						oPrinter:StartPage()
						f_FGPER002()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "003" //FGPER012.PRW - Acordo de Compensa��o de Horas.
						oPrinter:StartPage()
						f_FGPER012()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "004" //FGPER012A.PRW - Acordo de Compensa��o de Horas - Administrativo.
						oPrinter:StartPage()
						f_AGPER012()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "005" //FGPER018.PRW - Termo de Sigilo - Administrativo.
						oPrinter:StartPage()
						f_FGPER018()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "006" //FGPER016.PRW - Recibo de Integra��o.
						oPrinter:StartPage()
						f_FGPER016()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "007" //FGPER017.PRW - Termo de Compromisso/Autoriza��o de Desconto do VT.
						oPrinter:StartPage()
						f_FGPER017()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "008" //FGPER009.PRW - Comprovante de Devolu��o da CTPS.
						oPrinter:StartPage()
						f_FGPER009()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "009" //FGPER011.PRW - Termo de Prorroga��o da Experi�ncia.
						oPrinter:StartPage()
						f_FGPER011()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "010" //FGPER2B.PRW - Contrato de Experi�ncia - Vendedor
						oPrinter:StartPage()
						f_FGPER2B()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "011" //FGPER02M.PRW - Contrato de Experi�ncia - Motorista
						oPrinter:StartPage()
						f_FGPER02M()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "012" //FGPER011.PRW - Contrato de Experi�ncia - Auxiliar de P�tio
						oPrinter:StartPage()        //falta o cliente fornecer
						//f_FGPER011()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "013" //FGPER010.PRW - Op��o Vale Transporte
						oPrinter:StartPage()
						f_FGPER010()
						oPrinter:EndPage()
					case a_arqsel[n_cont3] == "014" //FGPER013.PRW - Comunicado Marca��o de Ponto Eletr�nico
						oPrinter:StartPage()
						f_FGPER013()
						oPrinter:EndPage()						
				endcase
				incproc()
			next
		endif
	next
	
	oPrinter:Preview()
	FreeObj(oPrinter)
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER2A	  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Contrato de Experi�ncia - Ind�stria.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER2A()
	
	Local c_Empresa := SM0->M0_NOMECOM
	Local c_Cnpj    := SM0->M0_CGC
	
	c_Endereco  := Alltrim(SM0->M0_ENDENT)
	c_Bairro    := Alltrim(SM0->M0_BAIRENT)
	c_Cidade    := Alltrim(SM0->M0_CIDENT)
	c_Func      := Alltrim(SRA->RA_NOME)
	c_Ctps      := Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
	c_Est		:= Alltrim(SM0->M0_ESTENT)
	c_Cep       := Transform(Alltrim(SM0->M0_CEPENT), "@R 99999-999")
	c_Cargo     := Alltrim(SRJ->RJ_DESC )
	c_Salario   := SRA->RA_SALARIO
	c_SalExt    := Extenso(SRA->RA_SALARIO)
	c_Local     := Alltrim(SM0->M0_CIDENT)
	c_Est1      := Alltrim(SM0->M0_ESTENT)
	c_Horario   := mv_par02
	c_Intervalo := mv_par03
	d_Inicio    := SRA->RA_ADMISSA
	c_Cidade    := Alltrim(SM0->M0_CIDENT)
	d_Data      := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + StrZero(Year(SRA->RA_ADMISSA), 4)
                   
    MDESC := ALLTRIM(SRJ->RJ_DESC)
                                  
    MTURNO := alltrim(SR6->R6_DESC)
    
    MINTER := allTRIM(SPJ->PJ_HRSINT1)

	c_texto := ''
	n_col := 67
	n_lin := 60
	oPrinter:Say(0111,0852,"CONTRATO DE TRABALHO A T�TULO DE EXPERI�NCIA",oArial12N,,0)
	oPrinter:Say(0180 + n_lin,1166,"(Art. 479 da CLT)",oArial10,,0)
	c_emp :=    "Entre "+ c_Empresa + ",CNPJ N� " + c_Cnpj+",com sede na: "
    c_end :=    c_Endereco +", " + alltrim(c_Bairro) + ", " + alltrim(c_Cidade) + "-" + alltrim(c_Est1) + ", CEP: " + alltrim(c_cep) 
    c_fun :=   "doravante designada Empregadora, e o Sr.(a) " + c_Func
    
 	n_Col   := 0187
   	n_Lin   := 250
	n_Lin := n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_emp,oArial10,,0)
	n_Lin := n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_end,oArial10,,0)
	n_Lin := n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_fun,oArial10,,0)
	n_Lin := n_Lin+50
	oPrinter:Say(n_Lin, n_Col,",portador (a)  da  Carteira de Trabalho e  Previd�ncia   Social de n�mero e s�rie:"+ alltrim (c_Ctps)+"",oArial10,,0)
   n_Lin := n_Lin+50
	oPrinter:Say(n_Lin, n_Col,"a seguir designado (a) EMPREGADO(A), � celebrado o presente CONTRATO DE  TRABALHO ",oArial10,,0)
	n_Lin := n_Lin+50
 	oPrinter:Say(n_Lin, n_Col,"A T�TULO  DE  EXPERI�NCIA  de  acordo  com  as  condi��es  a seguir especificadas:" ,oArial10,,0)
	n_Lin := n_Lin+100	        
	oPrinter:Say(n_lin, n_col,"1.O(A) EMPREGADO(A),exercera a fun��o de :"+ MDESC +",com a remunera��o mensal de",oArial10,,0)
    n_Lin := n_Lin+50  
	oPrinter:Say(n_lin,n_col, alltrim(Transform(c_Salario,"@E 9,999,999.99")) + " (" + ALLTRIM(c_SalExt)+"*****)",oArial10,,0)
    n_Lin := n_Lin+50  
    oPrinter:Say(n_lin,n_col, "por m�s.",oArial10,,0)
    
    n_Lin := n_Lin+100
 	oPrinter:Say(n_lin,n_col,"2.A Designa��o da Fun��o :"+ MDESC +", � abrangente para todos os empregados da �rea",oArial10,,0)  
	n_Lin := n_Lin+50
    
    oPrinter:Say(n_lin,n_col,"industrial, que recebem o piso salarial da categoria, podendo o empregado vir a exercer a fun��o em qualquer",oArial10,,0)
   	n_Lin := n_Lin+50 
    oPrinter:Say(n_lin,n_col,"setor da empresa, n�o podendo alegar desvio ou ac�mulo de fun��o em raz�o do deslocamento eventual ou",oArial10,,0)
	n_Lin := n_Lin+50
	oPrinter:Say(n_lin,n_col,"permanente para outro setor.",oArial10,,0)			
	
	n_Lin := n_Lin+100 
 	oPrinter:Say(n_lin,n_col,"3. O local de trabalho situa-se em: " + c_Local + "-" + c_Est1,oArial10,,0)
	n_lin:= n_lin+100    
    
    oPrinter:Say(n_lin,n_col,"4. Fica ajustado nos termos do parafrafo 1o do artigo 469 da CLT que a EMPREGADORA podera, a qualquer",oArial10,,0)
    n_lin:= n_lin+50 
	oPrinter:Say( n_lin,n_col,"tempo transferir o(a) EMPREGADO (A), para qualquer outra localidade do Pa�s.",oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"5. O  horario  de  trabalho  do  (a)  EMPREGADO  (A),sera de " + MTURNO + "  com",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"intervalo de 01:10Hs para refei��o, podendo a EMPREGADORA, alter�-lo de acordo com as necessidades",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"do servi�o.",oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"6. Qualquer gratifica��o, pr�mio, beneficio, etc., que EMPREGADORA, vier a conceder por  liberalidade, n�o ",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say( n_lin,n_col,"ser�o incorporados ao sal�rio para os efeitos legais n�o se considerando renova��o contratual a concess�o ",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,",habitual ou n�o,de tais gratifica��es.",oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"7. A pr�tica de qualquer ato prejudicial � EMPREGADORA,tais como: indisciplina, insubordina��o des�dia,etc.",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,",implica na rescis�o autom�tica deste Contrato.",oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"8. Em  caso  de  dano  causado  pelo(a)  EMPREGADO (A), fica a EMPREGADORA, autorizada a efetuar o",oArial10,,0)
	n_lin:= n_lin+50 
	oPrinter:Say( n_lin,n_col,"desconto da import�ncia correspondente ao  preju�zo,  conforme  previsto no par�grafo 1�  do artigo 462 da CLT,",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say( n_lin,n_col,"concordando o empregado, desde j�, em ressarcir o dano causado.",oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"9.Sempre que a  necessidade  assim o  exigir,  o (a) EMPREGADO(A),se compromete a trabalhar em regime de ",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"compensa��o de horas e revezamento de hor�rio,  inclusive em  per�odo noturno.",oArial10,,0)
	n_lin:= n_lin+100                 
	oPrinter:Say(n_lin,n_col,"10.O prazo deste Contrato � de 30 (trinta) dias, com inicio em "+PADR(d_data,80),oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"podendo ser prorrogado ate 90(noventa) dias.",oArial10,,0)
	n_lin:= n_lin+100                 
	oPrinter:Say(n_lin,n_col,PADR("11. Permanecendo o (a) EMPREGADO(A) a servi�o da EMPREGADORA ap�s o t�rmino da experi�ncia, o Con-",100),oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,PADR("trato passar� a viger por prazo indeterminado,com plena vig�ncia das demais Cl�usulas aqui pactuadas.",100),oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"E, por estarem de pleno acordo, as partes contratantes assinam o presente Contrato de Trabalho em duas",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"vias , ficando  a primeira  em  poder da EMPREGADORA e a segunda com o(a) EMPREGADO(A), que dela dar�",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"o competente recibo.",oArial10,,0)
	n_lin:=  n_lin+100
	
	oPrinter:Say(n_lin,200, PADR(""+ c_local + ","+ d_data,80),oArial10,,0)
	n_lin:=  n_lin+200
	
	oPrinter:Say(n_lin,0600,"__________________________________ " ,oArial12,,0)
	oPrinter:Say(n_lin,1605,"___________________________________" ,oArial12,,0)
	n_lin:=  n_lin+50
	oPrinter:Say(n_lin,0600,"EMPREGADORA " ,oArial12,,0)
	oPrinter:Say(n_lin,1605,"EMPREGADO   " ,oArial12,,0)
	n_lin:=  n_lin+200     
	oPrinter:Say(n_lin,0600,"__________________________________ " ,oArial12,,0)
	oPrinter:Say(n_lin,1605,"___________________________________" ,oArial12,,0)
	n_lin:=  n_lin+50 
	oPrinter:Say(n_lin,0600,"TESTEMUNHA  ",oArial12,,0)
	oPrinter:Say(n_lin,1605,"TESTEMUNHA	",oArial12,,0)
			
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER002  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Contrato de Experi�ncia - Administrativo.				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER002()
	
	c_Empresa =     SM0->M0_NOMECOM
	c_Cnpj    =     SM0->M0_CGC
		c_Endereco  := Alltrim(SM0->M0_ENDENT)
		c_Bairro    := Alltrim(SM0->M0_BAIRENT)
		c_Cidade    := Alltrim(SM0->M0_CIDENT)
		c_Func      := Alltrim(SRA->RA_NOME)
		c_Ctps      := Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
		c_Est      := Alltrim(SM0->M0_ESTENT)
		c_Cep       := Transform(Alltrim(SM0->M0_CEPENT), "@R 99999-999")
		c_Cargo     := Alltrim(SRJ->RJ_DESC )
		c_Salario   := SRA->RA_SALARIO
		c_SalExt    := Extenso(SRA->RA_SALARIO)
		c_Local     := Alltrim(SM0->M0_CIDENT)
		c_Est1      := Alltrim(SM0->M0_ESTENT)
		c_Horario   := mv_par02
		c_Intervalo := mv_par03
		d_Inicio    := SRA->RA_ADMISSA
		c_Cidade    := Alltrim(SM0->M0_CIDENT)
		d_Data      := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + StrZero(Year(SRA->RA_ADMISSA), 4)
	                   
	    MDESC := ALLTRIM(SRJ->RJ_DESC)
                                      
	    MTURNO = alltrim(SR6->R6_DESC)    
	    
	    MINTER = allTRIM(SPJ->PJ_HRSINT1)        
			
		c_texto = ''
		n_col := 67
		n_lin := 60
		oPrinter:Say(0111,0852,"CONTRATO DE TRABALHO A T�TULO DE EXPERI�NCIA",oArial12N,,0)
		oPrinter:Say(0180 + n_lin,1166,"(Art. 479 da CLT)",oArial10,,0)
		c_emp :=    "Entre "+ c_Empresa + ",CNPJ N� " + c_Cnpj+",com sede na: "
	    c_end :=    c_Endereco +", " + alltrim(c_Bairro) + ", " + alltrim(c_Cidade) + "-" + alltrim(c_Est1) + ", CEP: " + alltrim(c_cep) 
	    c_fun :=   "doravante designada Empregadora, e o Sr.(a) " + c_Func
	    
	 	n_Col   := 0187
	   	n_Lin   := 250
		n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,c_emp,oArial10,,0)
		n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,c_end,oArial10,,0)
		n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,c_fun,oArial10,,0)
		n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,",portador (a)  da  Carteira de Trabalho e  Previd�ncia   Social de n�mero e s�rie:"+ alltrim (c_Ctps)+"",oArial10,,0)
	   n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,"a seguir designado (a) EMPREGADO(A), � celebrado o presente CONTRATO DE  TRABALHO ",oArial10,,0)
		n_Lin = n_Lin+50
	 	oPrinter:Say(n_Lin, n_Col,"A T�TULO  DE  EXPERI�NCIA  de  acordo  com  as  condi��es  a seguir especificadas:" ,oArial10,,0)
		n_Lin = n_Lin+100	        
    	oPrinter:Say(n_lin, n_col,"1.O(A) EMPREGADO(A),exercera a fun��o de :"+ MDESC +",com a remunera��o mensal de",oArial10,,0)
	    n_Lin = n_Lin+50
	    oPrinter:Say(n_lin, n_col, alltrim(Transform(c_Salario,"@E 9,999,999.99")) + " (*****" + ALLTRIM(c_SalExt)+"*****)",oArial10,,0)
        n_Lin := n_Lin+50  
	    oPrinter:Say(n_lin,n_col, "por m�s.",oArial10,,0)
        n_Lin = n_Lin+100      
        oPrinter:Say(n_lin,n_col,"2. O local de trabalho situa-se em: " + c_Local + "-" + c_Est1,oArial10,,0)
        n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"3. Fica ajustado nos termos do par�frafo 1� do artigo 469 da CLT que a EMPREGADORA poder�, a qualquer",oArial10,,0)
	    n_lin:= n_lin+50 
		oPrinter:Say( n_lin,n_col,"tempo transferir o(a) EMPREGADO (A), para qualquer outra localidade do Pa�s.",oArial10,,0)
		n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"4. O  horario  de  trabalho  do  (a)  EMPREGADO  (A),sera de " + MTURNO + "  com",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"intervalo de 01:15Hs para refei��o, podendo a EMPREGADORA, alter�-lo de acordo com as necessidades do",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"servi�o.",oArial10,,0)
		n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"5. Qualquer gratifica��o, pr�mio, beneficio, etc., que EMPREGADORA, vier a conceder por  liberalidade, n�o ",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say( n_lin,n_col,"ser�o incorporados ao sal�rio para os efeitos legais n�o se considerando renova��o contratual a concess�o ",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,",habitual ou n�o,de tais gratifica��es.",oArial10,,0)
		n_lin:= n_lin+100    
		oPrinter:Say(n_lin,n_col,"6. A pr�tica de qualquer ato prejudicial � EMPREGADORA,tais como: indisciplina, insubordina��o des�dia,etc.",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,",implica na rescis�o autom�tica deste Contrato.",oArial10,,0)
		n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"7. Em  caso  de  dano  causado  pelo(a)  EMPREGADO (A), fica a EMPREGADORA, autorizada a efetuar o",oArial10,,0)
		n_lin:= n_lin+50 
		oPrinter:Say( n_lin,n_col,"desconto da import�ncia correspondente ao  preju�zo,  conforme  previsto no par�grafo 1�  do artigo 462 da CLT,",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say( n_lin,n_col,"concordando o empregado, desde j�, em ressarcir o dano causado.",oArial10,,0)
		n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"8.Sempre que a  necessidade  assim o  exigir, o (a) EMPREGADO(A),se compromete a trabalhar em regime de ",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"compensa��o de horas e revezamento de hor�rio,  inclusive em  per�odo noturno.",oArial10,,0)
		n_lin:= n_lin+100         
		
        oPrinter:Say(n_lin,n_col,"9.Toda e qualquer informa��o que o(a) empregado venha a ter conhecimento em decorrencia do contrato de",oArial10,,0)
        n_lin:= n_lin+50
        oPrinter:Say(n_lin,n_col,"trabalho � de carater sigiloso e n�o poder� ser divulgada pelo(a) empregado(a), sob qualquer hip�tese",oArial10,,0)
        n_lin:= n_lin+50
        oPrinter:Say(n_lin,n_col,"responsabilizando-se o(a) empregado civil e criminalmente, a qualquer tempo pela viola��o do sigilo ou uso das",oArial10,,0)                
        n_lin:= n_lin+50
        oPrinter:Say(n_lin,n_col,"informa��es em desconformidade com o presente contrato.",oArial10,,0)                
        
		n_lin:= n_lin+100                 
		oPrinter:Say(n_lin,n_col,"10.O prazo deste Contrato � de 30 (trinta) dias, com inicio em "+alltrim(PADR(d_data,80))+" podendo ser prorrogado",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"ate 90(noventa) dias.",oArial10,,0)
		n_lin:= n_lin+100
		oPrinter:Say(n_lin,n_col,"11.Permanecendo o (a) EMPREGADO(A) a servi�o da EMPREGADORA ap�s o t�rmino da experi�ncia, o",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"Contrato passar� a viger por prazo indeterminado,com plena vig�ncia das demais Cl�usulas aqui pactuadas.",oArial10,,0)
		n_lin:= n_lin+100   
		oPrinter:Say(n_lin,n_col,"E, por estarem de pleno acordo, as partes contratantes assinam o presente Contrato de Trabalho em duas",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"vias , ficando  a primeira  em  poder da EMPREGADORA e a segunda com o(a) EMPREGADO(A), que dela dar�",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"o competente recibo.",oArial10,,0)
		n_lin:=  n_lin+100              
		
		oPrinter:Say(n_lin,200, PADR(""+ c_local + ","+ d_data,80),oArial10,,0)
		n_lin:=  n_lin+200
		
		oPrinter:Say(n_lin,0600,"__________________________________ " ,oArial12,,0)
		oPrinter:Say(n_lin,1605,"___________________________________" ,oArial12,,0)
		n_lin:=  n_lin+50
		oPrinter:Say(n_lin,0600,"EMPREGADORA " ,oArial12,,0)
		oPrinter:Say(n_lin,1605,"EMPREGADO   " ,oArial12,,0)
		n_lin:=  n_lin+200     
		oPrinter:Say(n_lin,0600,"__________________________________ " ,oArial12,,0)
		oPrinter:Say(n_lin,1605,"___________________________________" ,oArial12,,0)
		n_lin:=  n_lin+50 
		oPrinter:Say(n_lin,0600,"TESTEMUNHA  ",oArial12,,0)
		oPrinter:Say(n_lin,1605,"TESTEMUNHA	",oArial12,,0)
		
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER012  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Acordo de Compensa��o de Horas.							  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER012()

	c_Carteira   := Alltrim(SRA->RA_NUMCP) + "-" +  Alltrim(SRA->RA_SERCP) + "-" + Alltrim(SRA->RA_UFCP)
	c_EndEmpresa := Alltrim(SM0->M0_CIDENT) + "-" + Alltrim(SM0->M0_ESTENT) + "   " + Alltrim(SM0->M0_ENDENT) + "  " + Alltrim(SM0->M0_CEPENT)
	c_Empresa := Alltrim(SM0->M0_NOMECOM)
	c_Nome := Alltrim(SRA->RA_NOME )
	c_Data	:= cValToChar(Day(SRA->RA_ADMISSA)) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + cValToChar(Year(SRA->RA_ADMISSA))

	oPrinter:Say(0166,0749,"Acordo Compensa��o de Horas",oArial13N,,0)

	c_texto := "Pelo presente acordo para compensa��o de jornada de trabalho firmado entre a Empresa: "
	c_Texto := c_Texto + c_Empresa + ", estabelecida em: "+ alltrim(c_EndEmpresa) + " com o ramo de Ind�stria "
	c_Texto := c_Texto + "de Embalagens Pl�sticas,e o(a) funcion�rio(a) Sr.(a) " + alltrim (c_Nome) +" portador(a) da    CTPS/S�rie: "  
	c_Texto := c_Texto + c_Carteira + " fica convencionado o seguinte:"
	c_Texto := (alltrim(c_Texto))
	n_Col   := 0387
	n_Lin   := 453
	a_line  := f_FormatText(c_Texto)
	
	For n_Cnt := 1 To 6
		if alltrim(a_Line[n_Cnt])!=''
			n_Lin = n_Lin+50
			oPrinter:Say(n_Lin, n_Col,"" + a_Line[n_Cnt],oArial10,,0)
		endif
	next

	oPrinter:Say(0915,n_Col,"a-Havendo necessidade de prorroga��o da jornada, as horas excedentes, atendido o",oArial10,,0)
	oPrinter:Say(0964,n_Col,"limite legal, ser�o compensadas em outro dia da semana.",oArial10,,0)
	
	oPrinter:Say(1055,n_Col,"b � Optando a empresa por n�o trabalhar no dia de s�bado, a jornada di�ria, de se-",oArial10,,0)
	oPrinter:Say(1104,n_Col,"gunda a sexta, ser� estendida para compensar as horas n�o trabalhadas no s�bado  ,",oArial10,,0)
	oPrinter:Say(1151,n_Col,"observando o limite legal de 44 (quarenta e quatro) horas semanais.",oArial10,,0)
	
	oPrinter:Say(1264,n_Col,"c � Em havendo trabalho em dia de domingo ou feriado ser� compensado com outro dia.",oArial10,,0)
	oPrinter:Say(1326,n_Col,"N�o ocorrendo compensa��o das horas trabalhadas nesses dias, estas ser�o pagas",oArial10,,0)
	oPrinter:Say(1373,n_Col,"com acr�scimo de 100%",oArial10,,0)
	oPrinter:Say(1662,0648,"SALVADOR, " + c_Data,oArial10,,0)
	
	oPrinter:Say(1951,0676,"________________________________________________",oArial10,,0)
	
	oPrinter:Say(1997,0688,"          " + c_Empresa ,oArial10,,0)
	
	oPrinter:Say(2177,0690,"________________________________________________",oArial10,,0)
	
	oPrinter:Say(2222,0700,"          " + c_Nome ,oArial10,,0)
	oPrinter:SayBitMap(2796,0324,cImag001,1811,0218)
	
Return	
	
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FormatText �Autor  �Pablo VB Carvalho � Data � 22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Formata o texto.               							  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FormatText(c_Texto)
	
	a_lines := {}
	c_len :=  76
	c_ini :=  1
	For n_Cnt := 1 To 6
		AADD(a_lines,SUBSTR(c_Texto,c_ini,c_len))
		c_ini = c_ini + 76
	Next

Return(a_lines)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER018  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Termo de Sigilo - Administrativo.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER018()

	c_Data   := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + STRZERO(Year(SRA->RA_ADMISSA), 4)

	oPrinter:Say(0130,0434,"TERMO DE SIGILO E CONFIDENCIALIDADE - ANEXO AO CONTRATO DE TRABALHO",o11N,,0)
	oPrinter:Say(0284,0133,"EMPREGRADO(A): " + ALLTRIM(SRA->RA_NOME) + "  , j� qualificado(a) no Contrato de Trabalho, ",o11N,,0)
	oPrinter:Say(0331,0133,"doravante denominado simplesmente EMPREGADO(A).",o11N,,0)
	oPrinter:Say(0411,0133,"EMPRESA:" +"BOMIX INDUSTRIA DE EMBALAGENS LTDA"+ " , inscrita no CNPJ/MF sob n� "+"01.561.279/0001-45"+",",o11N,,0)
	oPrinter:Say(0457,0133," com sede na Avenida Aliomar Baleeiro, n 1.111, Jardim Cajazeiras, KM ,",o11N,,0)    
  
	oPrinter:Say(0503,0133,"01 de Estrada Velha do Aeroporto, Salvador, Bahia, doravante denominada simplesmente EMPRESA.",o11N,,0)
	oPrinter:Say(0577,0133,"Sempre que em conjunto referidas, doravante denominadas como PARTES.",o11N,,0)
	oPrinter:Say(0657,0133,"Considerando que, em raz�o do contrato de trabalho celebrado entre as PARTES, doravante ",o11N,,0)
	oPrinter:Say(0759,0133,"constituem informa��o comercial confidencial.",o11N,,0)
	oPrinter:Say(0708,0133,"denominado CONTRATO, as mesmas ter�o acesso a informa��es confidenciais, as quais se",o11N,,0)
	oPrinter:Say(0834,0133,"Considerando que as PARTES desejam ajustar as condi��es de revela��o destas informa��es",o11N,,0)
	oPrinter:Say(0888,0133,"confidenciais j� disponibilizadas e aquelas que no futuro ser�o disponibilizadas para a execu��o",o11N,,0)
	oPrinter:Say(0937,0133,"do CONTRATO, bem como definir as regras relativas ao seu uso e prote��o:",o11N,,0)
	oPrinter:Say(1028,0133,'Considerando que as PARTES declaram-se conhecedoras do art.482,"g" da CLT:',o11N,,0)
	oPrinter:Say(1139,0891,'"Art. 482. Constituem justa causa para rescis�o',o11NI,,0)
	oPrinter:Say(1097,0907,"do contrato de trabalho pelo empregador: ",o11N,,0)
	oPrinter:Say(1294,0917,"'g) viola��o de segredo da empresa'." ,o11N,,0)
	oPrinter:Say(1401,0133,"RESOLVEM AS PARTES acima qualificadas, celebrar o presente TERMO DE ",o11N,,0)
	oPrinter:Say(1459,0133,'CONFIDENCIALIDADE ("Termo"), Acordo Vinculado ao Contrato, mediante as cl�usulas e ',o11N,,0)
	oPrinter:Say(1512,0133,"condi��es que seguem:",o11N,,0)
	oPrinter:Say(1637,0133,"1. CL�USULA PRIMEIRA - DO OBJETO",o11N,,0)
	oPrinter:Say(1717,0133,"O objeto deste Termo � prover a necess�ria e adequada prote��o das informa��es confidenciais ",o11N,,0)
	oPrinter:Say(1763,0133,"fornecidas pela EMPRESA, ou pelos seus Clientes ao EMPREGADO, em raz�o do",o11N,,0)
	oPrinter:Say(1821,0133,"CONTRATO, a fim de que as mesmas possam desenvolver as atividades contempladas no CONTRATO, o qual  ",o11N,,0)
	oPrinter:Say(1867,0133,"vincular-se-� expressamente a este ",o11N,,0)  
	oPrinter:Say(1930,0133,"1.1. As estipula��es e obriga��es constantes do presente instrumento ser�o aplicadas a toda e qualquer",o11N,,0)  
	oPrinter:Say(1976,0133,"informacao que seja revelada pela EMPRESA ou pelos seus Clientes",o11N,,0)
	oPrinter:Say(2022,0133,"2. CL�USULA SEGUNDA: DAS INFORMA��ES CONFIDENCIAIS.",o11N,,0)
	oPrinter:Say(2068,0133,"2.1. O EMPREGADO se obriga a manter o mais absoluto sigilo com rela��o a toda e qualquer",o11N,,0)
	oPrinter:Say(2114,0133,"venham a ser, a partir desta data, fornecida pela EMPRESA ou pelo seus Clientes, devendo ser ",o11N,,0)
	oPrinter:Say(2160,0133,"informa��o, conforme abaixo definida, que tenha sido revelada anteriormente e tamb�m as que ",o11N,,0)
	oPrinter:Say(2206,0133,"tratada como informa��o sigilosa.",o11N,,0)
	oPrinter:Say(2252,0133,"2.2. Dever� ser considerada como informa��o confidencial, toda e qualquer informa��o escrita ",o11N,,0)
	oPrinter:Say(2298,0133,'"ou oral , revelada ao EMPREGADO, contendo ela ou nao a ecpress�o "Confidencial". O Termo, informacao ' ,o11N,,0)
	oPrinter:Say(2344,0133,'"Abranger� toda informa��o escrita, verbal, digitalizada ou de qualquer outro modo ' ,o11N,,0)
	oPrinter:Say(2390,0133,'"apresentada, tangivel ou intangivel, virtual ou fisica, podendo incluir, mas nao se limitando a ',o11N,,0)
	oPrinter:Say(2436,0133,'"know-how", t�cnicas, "designs", especifica��es, diagramas, fluxogramas, configura��es, ',o11N,,0)
	oPrinter:Say(2482,0133,"solu��es, f�rmulas, modelos, desenhos, c�pias, amostras, cadastro de clientes, pre�os e custos, ",o11N,,0)
	oPrinter:Say(2528,0133,"contratos, planos de neg�cios, processos, projetos, fotografias, programas de computador, ",o11N,,0)
	oPrinter:Say(2574,0133,"discos, disquetes, fitas, conceitos de produto, instala��es, infraestrutura, especifica��es,",o11N,,0)
	oPrinter:Say(2620,0133,"amostras de ideias, defini��es e informa��es mercadol�gicas, inven��es e ideias, outras ",o11N,,0)
	
	oPrinter:Say(3000,0010,'_________________________________________________________________________________________________________' ,o11N,,0)
	oPrinter:Say(3069,1670,'P�g.: 1' ,o11N,,0)
	oPrinter:EndPage()
	
	oPrinter:Say(0130,0434,"TERMO DE SIGILO E CONFIDENCIALIDADE - ANEXO AO CONTRATO DE TRABALHO",o11N,,0)
	oPrinter:Say(0280,0133,"informa��es t�cnicas, financeiras, cont�beis, fiscais ou comerciais, dentre outros, doravante ",o11N,,0)
	oPrinter:Say(0328,0133,'denominados "INFORMA��ES CONFIDENCIAIS", a que, diretamente ou atrav�s de seus ',o11N,,0)
	oPrinter:Say(0384,0133,"Diretores, Clientes, empregados e/ou prepostos, venha o EMPREGADO, ter acesso, ",o11N,,0)
	oPrinter:Say(0431,0133,"conhecimento, ou que venha lhe ser confiadas durante e em raz�o dos trabalhos realizados e do ",o11N,,0)
	oPrinter:Say(0482,0133,"Contrato Principal celebrado entre as PARTES.",o11N,,0)
	oPrinter:Say(0573,0133,"2.3. Compromete-se, igualmente, o EMPREGADO, a n�o revelar, reproduzir, utilizar ou dar ",o11N,,0)
	oPrinter:Say(0626,0133,"conhecimento, ou alugar ou vender, em hip�tese alguma, a terceiros as INFORMA��ES ",o11N,,0)
	oPrinter:Say(0682,0133,"CONFIDENCIAIS.",o11N,,0)
	oPrinter:Say(0764,0133,"2.4. As PARTES dever�o cuidar para que as informa��es confidenciais fiquem restritas a sede ",o11N,,0)
	oPrinter:Say(0822,0133,"da EMPRESA durante as discuss�es, an�lises, reuni�es e neg�cios, trabalhos e projetos.",o11N,,0)
	oPrinter:Say(0920,0133,"3. CL�USULA TERCEIRA - DOS DIREITOS E OBRIGA��ES.",o11N,,0)
	oPrinter:Say(1002,0133,"O EMPREGADO se compromete e se obriga a utilizar a informa��o confidencial revelada pela",o11N,,0)
	oPrinter:Say(1055,0133,"EMPRESA exclusivamente para os prop�sitos deste Termo e da execu��o do Contrato ",o11N,,0)
	oPrinter:Say(1111,0133,"Principal, mantendo sempre estrito sigilo acerca de tais informa��es.",o11N,,0)
	oPrinter:Say(1197,0133,"3.1. O EMPREGADO se compromete a n�o efetuar qualquer c�pia da informa��o confidencial ",o11N,,0)
	oPrinter:Say(1244,0133,"sem consentimento pr�vio e expresso da EMPRESA.",o11N,,0)
	oPrinter:Say(1331,0133,"3.2. O EMPREGADO obriga-se a tomar todas as medidas necess�rias � prote��o da informa��o ",o11N,,0)
	oPrinter:Say(1382,0133,"confidencial da EMPRESA, bem como para evitar e prevenir revela��o a terceiros, exceto se ",o11N,,0)
	oPrinter:Say(1482,0133,"permitida para empresas controladoras, controladas e/ou coligadas, assim consideradas as ",o11N,,0)
	oPrinter:Say(1526,0133,"empresas que direta ou indiretamente controlem ou sejam controladas pela EMPRESA.",o11N,,0)
	oPrinter:Say(1693,0133,"O presente Termo tem natureza irrevog�vel e irretrat�vel, permanecendo em vigor desde a data ",o11N,,0)
	oPrinter:Say(1615,0133,"4. CL�USULA QUARTA - DA VIG�NCIA.",o11N,,0)
	oPrinter:Say(1431,0133,"devidamente autorizado por escrito pela EMPRESA. De qualquer forma, a revela��o � ",o11N,,0)
	oPrinter:Say(1744,0133,"da revela��o das INFORMA��ES CONFIDENCIAS e mesmo ap�s o t�rmino do Contrato",o11N,,0)
	oPrinter:Say(1795,0133,"Principal, ao qual este � vinculado.",o11N,,0)
	oPrinter:Say(1875,0133,"5. CL�USULA QUINTA- DAS PENALIDADES.",o11N,,0)
	                       
	oPrinter:Say(1971,0133,"A quebra do sigilo profissional, devidamente comprovada sem autorizacao expressa da ",o11N,,0)    
	oPrinter:Say(2017,0133,"EMPRESA, possibilitar� a imediata rescis�o de qualquer contrato firmado entre as PARTES, ",o11N,,0)
	oPrinter:Say(2063,0133,"sem qualquer onus para a EMPRESA. Neste caso, o EMPREGADO estara sujeito, por acao ou omissao ao, ",o11N,,0) 
	oPrinter:Say(2109,0133,"pagamento ou recomposi��o de todas as perdas e danos sofrido pela EMPRESA," ,o11N,,0) 
	  
	oPrinter:Say(2155,0133,"inclusive as de ordem moral ou concorrencial, bem como as de responsabilidades civil e ",o11N,,0)
	oPrinter:Say(2201,0133,"criminal respectivas, as quais ser�o apuradas em regular processo judicial ou administrativo, ",o11N,,0)
	oPrinter:Say(2247,0133,"mais o valor de eventuais lucros cessantes resultantes de INFORMA��ES CONFIDENCIAIS ",o11N,,0)
	oPrinter:Say(2293,0133,"indevidamente transferidas, devidamente corrigidos." ,o11N,,0)
	  
	oPrinter:Say(2385,0133,"6. CL�USULA SEXTA - DAS DISPOSI��ES GERAIS.",o11N,,0)
	oPrinter:Say(2431,0133,"6.1 O presente Termo constitui acordo entre as PARTES, relativamente ao tratamento das ",o11N,,0)
	oPrinter:Say(2477,0133,"INFORMA��ES CONFIDENCIAIS, aplicando-se a todos os acordos, promessas, propostas, ",o11N,,0)
	oPrinter:Say(2523,0133,"declara��es, entendimentos e negocia��es anteriores ou posteriores, escritas ou verbais, ",o11N,,0)
	oPrinter:Say(2569,0133,"a��es feitas direta ou indiretamente pelas PARTES, em conjunto ou separadamente, e, ser� ",o11N,,0)
	
	oPrinter:Say(3000,0010,'_________________________________________________________________________________________________________' ,o11N,,0)
	oPrinter:Say(3069,1670,'P�g.: 2' ,o11N,,0)
	oPrinter:EndPage()
	
	oPrinter:Say(0130,0434,"TERMO DE SIGILO E CONFIDENCIALIDADE - ANEXO AO CONTRATO DE TRABALHO",o11N,,0)
	  
	oPrinter:Say(0280,0133,"Empreendidas pelas PARTES contratantes no que que diz repeito ao Contrato pricipal, sejam estas",o11N,,0)
	oPrinter:Say(0326,0133,"a��es feitas direta ou indiretamente pelas PARTES,em conjunto ou separadamente, e , ser�",o11N,,0)
	oPrinter:Say(0372,0133,"igualmente aplicado a todo e qualquer acordo ou entendimento futuro, que venha a ser firmado ",o11N,,0)
	oPrinter:Say(0418,0133,"entre as PARTES.",o11N,,0)
	oPrinter:Say(0464,0133,"6.2 Este Termo de Confidencialidade constitui termo vinculado ao Contrato Principal, parte ",o11N,,0)
	oPrinter:Say(0510,0133,"independente e regulat�ria daquele.",o11N,,0)
	oPrinter:Say(0556,0133,"6.3 Surgindo diverg�ncias quanto � interpreta��o do pactuado neste Termo ou quanto � ",o11N,,0)
	oPrinter:Say(0602,0133,"execu��o das obriga��es dele decorrentes, ou constatando-se nele a exist�ncia de lacunas, ",o11N,,0)
	oPrinter:Say(0648,0133,"solucionar�o as PARTES tais diverg�ncias, de acordo com os princ�pios de boa f�, da equidade, ",o11N,,0)
	oPrinter:Say(0694,0133,"da razoabilidade, e da economicidade e, preencher�o as lacunas com estipula��es que, ",o11N,,0)
	oPrinter:Say(0740,0133,"presumivelmente, teriam correspondido � vontade das PARTES na respectiva ocasi�o.",o11N,,0)
	oPrinter:Say(0786,0133,"6.4 O disposto no presente Termo de Confidencialidade prevalecer�, sempre, em caso de ",o11N,,0)
	oPrinter:Say(0832,0133,"d�vida, e salvo expressa determina��o em contr�rio, sobre eventuais disposi��es constantes de ",o11N,,0)
	oPrinter:Say(0878,0133,"outros instrumentos conexos firmados entre as PARTES quanto ao sigilo de informa��es ",o11N,,0)
	oPrinter:Say(0924,0133,"confidenciais, tal como aqui definidas.",o11N,,0)
	oPrinter:Say(970,0133,"6.5 A omiss�o ou toler�ncia das PARTES, em exigir o estrito cumprimento dos termos e ",o11N,,0)
	oPrinter:Say(1016,0133,"condi��es deste contrato, n�o constituir� nova��o ou ren�ncia, nem afetar� os seus direitos, que ",o11N,,0)
	oPrinter:Say(1062,0133,"7. CL�USULA S�TIMA - DO FORO.",o11N,,0)
	oPrinter:Say(1108,0133,"� eleito o foro da Cidade do Salvador, capital do Estado da Bahia, renunciando as PARTES a ",o11N,,0)
	oPrinter:Say(1154,0133,"domic�lio, para quaisquer a��es decorrentes deste contrato.",o11N,,0)
	oPrinter:Say(1200,0133,"qualquer outro por mais especial ou privilegiado que seja ou que de futuro venha a ter por ",o11N,,0)
	oPrinter:Say(1246,0133,"poder�o ser exercidos a qualquer tempo.",o11N,,0)
	oPrinter:Say(1292,0133,"E, por estarem assim justas e contratadas, as PARTES assinam o presente instrumento de ",o11N,,0)
	oPrinter:Say(1338,0133,"contrato, em 02 (duas) vias de igual teor e forma, na presen�a das testemunhas abaixo.",o11N,,0)
	  
	oPrinter:Say(1430,0133,"Salvador," + c_data ,o11N,,0)
	oPrinter:Say(1522,0133,"_________________________________",o11N,,0)
	oPrinter:Say(1568,0133,ALLTRIM(SM0->M0_NOMECOM) ,o11N,,0)
	oPrinter:Say(1700,0133,"_________________________________",o11N,,0)
	oPrinter:Say(1746,0133,"EMPREGADO",o11N,,0)
	oPrinter:Say(1800,0133,"TESTEMUNHAS",o11N,,0)
	oPrinter:Say(1892,0133,"CPF. N�",o11N,,0)
	oPrinter:Say(1938,0133,"_________________________________",o11N,,0)
	oPrinter:Say(2030,0133,"CPF. N�",o11N,,0)
	oPrinter:Say(2076,0133,"_________________________________",o11N,,0)
	  
	oPrinter:Say(2200,0010,'_________________________________________________________________________________________________________' ,o11N,,0)
	oPrinter:Say(2246,1670,'P�g.: 3' ,o11N,,0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER016  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Recibo de Integra��o.									  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER016()

	Local c_Cidade := Alltrim(SM0->M0_CIDENT)

	c_Data   := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + STRZERO(Year(SRA->RA_ADMISSA), 4)  

	oPrinter:Say(0122,0950,"RECIBO ENTREGA MANUAL DE INTEGRACAO",o14N,,0)
	oPrinter:Say(0353,0200,"Recebi da " + ALLTRIM(SM0->M0_NOMECOM) + " , o manual de Integra��o IT-PES-3 e o Kit ISO 9001, " ,oArial10,,0)
	oPrinter:Say(0410,0200,"declarando, portanto ter sido informado de todo seu conte�do.",oArial10,,0)

	oPrinter:Say(0600,1380, c_Cidade +", " + c_Data ,oArial10,,0)
	oPrinter:Say(0738 ,0200,"________________________________" ,oArial10,,0)
	oPrinter:Say(0826,0220, ALLTRIM(SRA->RA_NOME) ,oArial10,,0)
	oPrinter:Say(0895,0220,"Registro: " + SRA->RA_MAT,oArial10,,0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER017  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Termo de Compromisso/Autoriza��o de Desconto do VT.		  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER017()

	Local c_Cidade := Alltrim(SM0->M0_CIDENT) 
	Local c_Data   := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + STRZERO(Year(SRA->RA_ADMISSA), 4)

	oPrinter:Say(0122,0476,"TERMO DE COMPROMISSO/AUTORIZACAO DE DESCONTO",o14N,,0)
	oPrinter:Say(0353,0200,"Comprometo-me a atualizar as informa��es anualmente ou sempre que ocorrem altera��es, e a utilizar os",oArial10,,0)
	oPrinter:Say(0411,0200,"vale  transporte que me forem concedidos exclusivamente no percurso resid�ncia/trabalho/resid�ncia.",oArial10,,0)
	oPrinter:Say(0527,0200,"Estou ciente de que, na hip�tese de infringir tal compromisso, a empresa poder� dispensar-me por justa",oArial10,,0)
	oPrinter:Say(0585,0200,"causa, nos termos do artigo nr.07, par�grafo nr. 03, do Decreto nr. 95.247/87.",oArial10,,0)
	oPrinter:Say(0701,0200,"Autorizo a empresa a descontar mensalmente de meus vencimentos at� o limite de 6%(seis por cento) do ",oArial10,,0)
	oPrinter:Say(0759,0200,"sal�rio, o valor destinado a cobrir o fornecimento dos vales transporte por mim utilizados.",oArial10,,0)

	oPrinter:Say(0991,1250, c_Cidade +", " + c_Data ,oArial10,,0)
	oPrinter:Say(1270,0220, ALLTRIM(SRA->RA_NOME) ,oArial10,,0)
	oPrinter:Say(1270,1150, ALLTRIM(SM0->M0_NOMECOM),oArial10,,0)
	oPrinter:Say(1555,0220,"Responsavel Legal (Quando Menor)",oArial10,,0)
	oPrinter:Say(1322,0220,"Registro: " + SRA->RA_MAT,oArial10,,0)
	oPrinter:Say(1205,1140,"________________________________________" ,oArial10,,0)
  	oPrinter:Say(1492,0200,"________________________________" ,oArial10,,0)
	oPrinter:Say(1205,0200,"______________________________" ,oArial10,,0)
		
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER009  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Comprovante de Devolu��o da CTPS.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER009()

	Local c_Cbo       := Alltrim(SRJ->RJ_CODCBO)
	Local c_Funcao    := Alltrim(SRJ->RJ_DESC)

	c_Nome			:= SRA->RA_MAT+" - "+Alltrim( SRA->RA_NOME )
	c_Ctps			:= Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
	d_Admissa		:= SRA->RA_ADMISSA
	c_Local		:= SM0->M0_CIDENT
	c_Matricula	:= Alltrim(SRA->RA_MAT )
	c_Funcao		:= c_Funcao
	n_enter		:=	30

	oPrinter:Box(n_enter + 0098,0140,0250,2279)
	oPrinter:Say(n_enter + 0127,0270,"COMPROVANTE DE DEVOLU��O DA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL",o11N,,0)
	oPrinter:Say(n_enter + 0524,0212,"Nome do Empregado: "  + c_Nome,oVerdan10,,0)
	oPrinter:Say(n_enter + n_enter + 0628,0203,"Carteira de Trabalho: " + c_Ctps ,oVerdan10,,0)
	oPrinter:Say(n_enter + 0713,0203,"CBO: " + c_Cbo,oVerdan10,,0)
	oPrinter:Say(n_enter + 0713,0578,"Fun��o: " + c_Funcao ,oVerdan10,,0)
	oPrinter:Say(n_enter + 0722,1640,"Admiss�o: "+ dtoc(d_Admissa),oVerdan10,,0)
	n_enter := n_enter + 50
	oPrinter:Say(n_enter + 0982,0177,"Recebi em devolu��o a carteira de trabalho e previdencia social acima, com as respectivas anota��es.",oVerdan10,,0)
	oPrinter:Say(n_enter + 1384,1103, alltrim(c_Local) + ",  ______\______\______" ,oVerdan10,,0)
	oPrinter:Box(n_enter + 1656,1085,n_enter + 1656,2060)
	oPrinter:Say(n_enter + 1700,1103,alltrim(c_nome),oVerdan10,,0)
	oPrinter:SayBitMap(n_enter + 2980,0261,cImag001,1811,0217)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 �f_FGPER011  �Autor  �Pablo VB Carvalho � Data �  22/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Termo de Prorroga��o da Experi�ncia.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER011()

	Local cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP"  
	
	cImag001 	:= cBitmap
	c_Nome      := Alltrim(SRA->RA_NOME )
	c_Matricula := Alltrim(SRA->RA_MAT )
	c_Empresa 	:= Alltrim(SM0->M0_NOMECOM )

	oPrinter:Say(0151,0835,"TERMO DE PRORROGA��O",o14,,0)

	oPrinter:Say(0491,0332,"Por m�tuo acordo entre as partes o presente Contrato de Experi�ncia que deveria vencer em",o10,,0)
	oPrinter:Say(0570,0322,"_____/_____/_____ , fica prorrogado at� _____/_____/_____",oVerda10,,0)

	oPrinter:Box(793,0386,793,1605)
	oPrinter:Box(1086,0376,1086,1605)
	oPrinter:Say(802,0470,c_Empresa,oVerda10,,0)
	oPrinter:Say(1104,0420,c_Nome,oVerda10,,0)
	oPrinter:Say(1204,0600,"REGISTRO:  "+c_Matricula,oVerda10,,0)
	oPrinter:SayBitMap(2766,0324,cImag001,1811,0218)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 f_AGPER012   �Autor  �Pablo VB Carvalho � Data �  09/07/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Acordo de Compensa��o de Horas - Administrativo.			  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_AGPER012()

	c_Nome      := Alltrim(SRA->RA_NOME )
	c_Matricula := Alltrim(SRA->RA_MAT )
	c_Empresa 	:= Alltrim(SM0->M0_NOMECOM )                                                            
	c_Carteira  := Alltrim(SRA->RA_NUMCP) + "-" +  Alltrim(SRA->RA_SERCP) + "-" + Alltrim(SRA->RA_UFCP)
    c_EndEmpresa:= Alltrim(SM0->M0_ENDENT)
    c_turno     := SRA->RA_TNOTRAB      
    c_Cidade := Alltrim(SM0->M0_CIDENT) 
    c_Data   := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + STRZERO(Year(SRA->RA_ADMISSA), 4)
    
	oPrinter:Say(0151,0835,"ACORDO DE COMPENSA��O DE HORAS",o14,,0)  
	oPrinter:Say(0491,0500,"Pelo presente acordo para compensa��o de jornada de trabalho firmado entre a Empresa: ",o10,,0)
	oPrinter:Say(0570,0500,c_Empresa + ", estabelecida em: "+ alltrim(c_EndEmpresa),o10,,0)
	oPrinter:Say(0649,0500," com o ramo de Ind�stria de Embalagens Pl�sticas, e o(a) funcion�rio(a) Sr.(a) " + alltrim (c_Nome),o10,,0)
	oPrinter:Say(0728,0500," portador(a) da CTPS/S�rie:	" + c_Carteira + ", fica convencionado que o hor�rio normal ",o10,,0)
	oPrinter:Say(0807,0500," de trabalho ser� o seguinte para compensa��o de horas n�o trabalhadas nos dias de S�bado:",o10,,0)                        
	oPrinter:Say(0965,0500,"DIAS DA SEMANA        DE      AS                 DE      AS ",o10,,0)
    LIN = 1035
    
	DbSelectArea("SPJ")
    SPJ->(DbSetOrder(1))
    dbgotop()
    dbSeek(xFilial("SPJ")+c_turno)
	If Found()    	                   
	        
	   MDIA := ""
       do While .t. 
         
          if SPJ->PJ_TURNO <> c_turno 
   		      oPrinter:Say(LIN,0500,mdiad,o10,,0)
		      oPrinter:Say(LIN,870,str(SPJ->PJ_ENTRA1,5,2),o10,,0)
		      oPrinter:Say(LIN,980,str(SPJ->PJ_SAIDA1,5,2),o10,,0)
		      oPrinter:Say(LIN,1200,str(SPJ->PJ_ENTRA2,5,2),o10,,0)
		      oPrinter:Say(LIN,1310,str(SPJ->PJ_SAIDA2,5,2),o10,,0)                     
		      LIN := LIN + 60
             exit
          endif   
             
	      if SPJ->PJ_dia == "2"
	         mdia := "Segunda-Feira"
	      endif    
	      if SPJ->PJ_dia == "3"
	         mdia := "Terca-Feira"
	      endif
          if SPJ->PJ_dia == "4"
	         mdia := "Quarta-Feira"
	      endif
	      if SPJ->PJ_dia == "5"
	         mdia := "Quinta-Feira"
	      endif
	      if SPJ->PJ_dia == "6"
	         mdia := "Sexta-Feira"
	      endif
	      if SPJ->PJ_dia == "7"
	         mdia := "S�bado"
	      endif
   	      if SPJ->PJ_dia == "1"
   	      	mdiad := "Domingo"
   	      	c_entra1 := str(SPJ->PJ_ENTRA1,5,2)
   	      	c_saida1 := str(SPJ->PJ_SAIDA1,5,2)
   	      	c_entra2 := str(SPJ->PJ_ENTRA2,5,2)
   	      	c_saida2 := str(SPJ->PJ_SAIDA2,5,2)
   	      else
		      oPrinter:Say(LIN,0500,mdia,o10,,0)
		      oPrinter:Say(LIN,870,str(SPJ->PJ_ENTRA1,5,2),o10,,0)
		      oPrinter:Say(LIN,980,str(SPJ->PJ_SAIDA1,5,2),o10,,0)
		      oPrinter:Say(LIN,1200,str(SPJ->PJ_ENTRA2,5,2),o10,,0)
		      oPrinter:Say(LIN,1310,str(SPJ->PJ_SAIDA2,5,2),o10,,0)                     
		      LIN := LIN + 60
		  endif
		  
		  dbskip()

	   enddo
	ELSE   
	   alert("TURNO N�O ENCONTRADO")
	ENDIF         
	LIN = LIN + 60   
	oPrinter:Say(LIN,1000,"TOTAL DE HORAS SEMANAIS 44:00" ,o10,,0) 

    LIN = LIN + 200
	oPrinter:Say(lin,600,c_Cidade +", " + c_Data ,o10,,0)
    LIN = LIN + 100
    oPrinter:Say(LIN,600,"__________________________________________________" ,o10,,0)        
    LIN = LIN + 50
    oPrinter:Say(LIN,600,C_EMPRESA,o10,,0) 
    LIN = LIN + 100 
    oPrinter:Say(LIN,600,"__________________________________________________" ,o10,,0)        
    LIN = LIN + 50
    oPrinter:Say(LIN,600,C_MATRICULA+" - "+C_NOME,o10,,0) 

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 f_FGPER2B    �Autor  �Pablo VB Carvalho � Data �  09/07/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Contrato de Experi�ncia - Vendedor.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER2B()

	c_Empresa =     SM0->M0_NOMECOM
	c_Cnpj    =     SM0->M0_CGC
	DbSelectArea("SQ3")
	SQ3->( DbSetOrder(1))
	SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO))
	SR6->( DbSeek(xFilial("SR6")+SRA->RA_TNOTRAB)) 
	SRJ->( DbSeek(substring(xFilial("SRA"),1,4)+SRA->RA_CODFUNC))
	c_Endereco  := Alltrim(SM0->M0_ENDENT)
	c_Bairro    := Alltrim(SM0->M0_BAIRENT)
	c_Cidade    := Alltrim(SM0->M0_CIDENT)
	c_Func      := Alltrim(SRA->RA_NOME)
	c_Ctps      := Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
	c_Est      := Alltrim(SM0->M0_ESTENT)
	c_Cep       := Transform(Alltrim(SM0->M0_CEPENT), "@R 99999-999")
	c_Cargo     := Alltrim(SRJ->RJ_DESC )
	c_Salario   := SRA->RA_SALARIO
	c_SalExt    := Extenso(SRA->RA_SALARIO)
	c_Local     := Alltrim(SM0->M0_CIDENT)
	c_Est1      := Alltrim(SM0->M0_ESTENT)
	c_Horario   := mv_par02
	c_Intervalo := mv_par03
	d_Inicio    := SRA->RA_ADMISSA
	c_Cidade    := Alltrim(SM0->M0_CIDENT)
	d_Data      := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + StrZero(Year(SRA->RA_ADMISSA), 4)
                   
    DbSelectArea("SRJ")   
    DbSetOrder(1)
    DbSeek(substring(xFilial("SRA"),1,4)+"  "+ALLTRIM(SRA->RA_CODFUNC))
    MDESC := ALLTRIM(SRJ->RJ_DESC)
                                      
    DbSelectArea("SR6")   
    DbSetOrder(1)
    DbSeek(xFilial("SRA")+ALLTRIM(SRA->RA_TNOTRAB))
    MTURNO = alltrim(SR6->R6_DESC)    
    
    DbSelectArea("SPJ")   
    DbSetOrder(1)
    DbSeek(xFilial("SRA")+ALLTRIM(SRA->RA_TNOTRAB))
    MINTER = allTRIM(SPJ->PJ_HRSINT1)	
	
	c_texto = ''
	n_col := 67
	n_lin := 60
	oPrinter:Say(0111,0852,"CONTRATO DE TRABALHO A T�TULO DE EXPERI�NCIA",oArial12N,,0)
	oPrinter:Say(0180 + n_lin,1166,"(Art. 479 da CLT)",oArial10,,0)
	c_emp :=    "Entre "+ALLTRIM(c_Empresa) + ",CNPJ N� " + c_Cnpj+",com sede na: "
    c_end :=    ALLTRIM(c_Endereco) +", " + alltrim(c_Bairro) + ", " + alltrim(c_Cidade) + "-" + alltrim(c_Est1) + ", CEP: " + alltrim(c_cep) 
    c_fun :=   "doravante designada Empregadora, e o Sr.(a) " + c_Func
   
   // c_desc :=   "1. O(A) EMPREGADO(A), exercer� a fun��o de "+ MDESC +", submetido a controle de ponto em ",oArial10,,0)"
    
 	n_Col   := 0187
   	n_Lin   := 250
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_emp,oArial10,,0)
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_end,oArial10,,0)
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_fun,oArial10,,0)
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col, ",portador (a) da Carteira de Trabalho e Previd�ncia   Social de n�mero e s�rie:"+ alltrim (c_Ctps)+"",oArial10,,0)
    n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,"a seguir designado (a) EMPREGADO(A), � celebrado o presente CONTRATO DE  TRABALHO ",oArial10,,0)
	n_Lin = n_Lin+50
 	oPrinter:Say(n_Lin, n_Col,"A T�TULO DE EXPERI�NCIA de acordo com as condi��es a seguir especificadas:" ,oArial10,,0)
	n_Lin = n_Lin-500                 		
	oPrinter:Say(0550 + n_lin,n_col,"1. O(A) EMPREGADO(A), exercer� a fun��o de: "+MDESC+" , em servi�o externo n�o sujeito a controle de jornada",oArial10,,0)        
	n_Lin = n_Lin+50
    oPrinter:Say(0550 + n_lin,n_col,", com a remunera��o mensal de "+Transform(c_Salario,"@E 9,999,999.99")+" "+ALLTRIM(c_SalExt)+"***",oArial10,,0)
    n_Lin := n_Lin+50  
    oPrinter:Say(n_lin,n_col, "por m�s.",oArial10,,0) 
    n_Lin = n_Lin+50
    oPrinter:Say(0600 + n_lin,n_col,"2. O local de trabalho situa-se em: " + c_Local + "-" + c_Est1,oArial10,,0)
	n_lin:= n_lin+100    
   	oPrinter:Say(0600 + n_lin,n_col,"3.Fica ajustado nos termos do paragrafo 1o do artigo  469 da CLT que a EMPREGADORA podera, a qualquer tempo,",oArial10,,0)
    n_lin:= n_lin+50
    oPrinter:Say(0600 + n_lin,n_col,"transferir o(a) EMPREGADO(A), para qualquer outra localidade do Pais.",oArial10,,0)  
    n_lin:= n_lin+50
    oPrinter:Say(0650 + n_lin,n_col,"4. O horario de trabalho do (a) EMPREGADO (A),sera de " + MTURNO + " com intervalo de 01:30Hs para",oArial10,,0)
    oPrinter:Say(0700 + n_lin,n_col,"refei��o, podendo a EMPREGADORA, alter�-lo de acordo com as necessidades do servi�o.",oArial10,,0)
	oPrinter:Say(0800 + n_lin,n_col,"5. Qualquer gratifica��o, pr�mio, beneficio, etc., que EMPREGADORA, vier a conceder por  liberalidade, n�o ",oArial10,,0)
    oPrinter:Say(0850 + n_lin,n_col,"ser�o incorporados ao sal�rio  para os efeitos legais n�o se considerando renova��o contratual a concess�o ",oArial10,,0)
	oPrinter:Say(0900 + n_lin,n_col,",habitual ou n�o,de tais gratifica��es.",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(0950 + n_lin,n_col,"6. A pr�tica de qualquer ato prejudicial � EMPREGADORA, tais como: indisciplina, insubordina��o des�dia,etc.",oArial10,,0)
	oPrinter:Say(01000 + n_lin,n_col,",implica na rescis�o autom�tica deste Contrato.",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(1050 + n_lin,n_col,"7. Em caso de dano causado pelo(a) EMPREGADO (A), fica a EMPREGADORA, autorizada a efetuar o descon-",oArial10,,0)
	oPrinter:Say(1100 + n_lin,n_col,"to da import�ncia correspondente ao preju�zo, conforme previsto no par�grafo 1�  do artigo 462 da CLT,",oArial10,,0)
	oPrinter:Say(1150 + n_lin,n_col,"concordando o empregado, desde j�, em ressarcir o  j�, em ressarcir o dano causado.",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(1200 + n_lin,n_col,"8. Sempre que a necessidade assim o exigir, o (a) EMPREGADO(A),se compromete a trabalhar em regime de ",oArial10,,0)
	oPrinter:Say(1250 + n_lin,n_col,"compensa��o de horas e revezamento de hor�rio,  inclusive em  per�odo noturno.",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(1300 + n_lin,n_col,"9. Toda e qualquer informa��o que o(a) empregado venha a ter conhecimento em decorr�ncia do contrato de tra-",oArial10,,0)
	oPrinter:Say(1350 + n_lin,n_col,"to de trabalho � de car�ter sigiloso e n�o poder� ser divulgada pelo(a) empregado(a), sob qualquer hip�tese,",oArial10,,0)
	oPrinter:Say(1400 + n_lin,n_col,"responsabilizando-se o(a)empregado(a)  ,civil e criminalmente,a qualquer presente contrato",oArial10,,0)
	oPrinter:Say(1450 + n_lin,n_col,"tempo, pela viola��o do sigilo ou uso das informa��es em desconformidade com o presente contrato",oArial10,,0)
    n_lin:= n_lin+50
	oPrinter:Say(1450 + n_lin,n_col,"10. O prazo deste Contrato � de 30(trinta) dias, com in�cio em " + alltrim(DTOC(d_inicio)) +" podendo ser prorrogado at� 90(nove-",oArial10,,0)
	n_lin:= n_lin + 50
	oPrinter:Say(1450 + n_lin,n_col,"nta) dias.",oArial10,,0)
	n_lin:= n_lin + 50
	oPrinter:Say(1500 + n_lin,n_col,PADR("11. Permanecendo o (a) EMPREGADO(A) a servi�o da EMPREGADORA ap�s o t�rmino da experi�ncia, o Con-",100),oArial10,,0)
	oPrinter:Say(1550 + n_lin,n_col,PADR("trato passar� a viger por prazo indeterminado, com plena vig�ncia das demais Cl�usulas aqui pactuadas.",100),oArial10,,0)
	oPrinter:Say(1700 + n_lin,n_col,"E, por estarem de pleno acordo, as partes contratantes assinam o presente Contrato de Trabalho em duas",oArial10,,0)
	oPrinter:Say(1750 + n_lin,n_col,"vias,ficando a primeira em poder da EMPREGADORA e a segunda como(a) EMPREGADO(A), que dela dar� o",oArial10,,0)
	oPrinter:Say(1800 + n_lin,n_col,"competente recibo.",oArial10,,0)
	n_lin:=  n_lin+50
	
	oPrinter:Say(1980 + n_lin,200, PADR(""+ c_local + ","+ d_data,80),oArial10,,0)
	n_lin:=  n_lin+100
	
	oPrinter:Say(2230 + n_lin,0600,"__________________________________ " ,oArial12,,0)
	oPrinter:Say(2230 + n_lin,1605,"___________________________________" ,oArial12,,0)
	n_lin:=  n_lin+50
	oPrinter:Say(2280+n_lin,0600,"EMPREGADORA " ,oArial12,,0)
	oPrinter:Say(2280+n_lin,1605,"EMPREGADO   " ,oArial12,,0)
	n_lin:=  n_lin+50     
	oPrinter:Say(2480+n_lin,0600,"__________________________________ " ,oArial12,,0)
	oPrinter:Say(2480+n_lin,1605,"___________________________________" ,oArial12,,0)
	n_lin:=  n_lin+50 
	oPrinter:Say(2530+n_lin,0600,"TESTEMUNHA  ",oArial12,,0)
	oPrinter:Say(2530+n_lin,1605,"TESTEMUNHA	",oArial12,,0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 f_FGPER02M   �Autor  �Pablo VB Carvalho � Data �  09/07/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Contrato de Experi�ncia - Motorista.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER02M()

	c_Empresa =     SM0->M0_NOMECOM
	c_Cnpj    =     SM0->M0_CGC

	DbSelectArea("SQ3")
	SQ3->( DbSetOrder(1))
	SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO))
	SR6->( DbSetOrder(1))
	SR6->( DbSeek(xFilial("SR6")+SRA->RA_TNOTRAB)) 
	SRJ->( DbSeek(substring(xFilial("SRA"),1,4)+SRA->RA_CODFUNC))
	c_Endereco  := Alltrim(SM0->M0_ENDENT)
	c_Bairro    := Alltrim(SM0->M0_BAIRENT)
	c_Cidade    := Alltrim(SM0->M0_CIDENT)
	c_Func      := Alltrim(SRA->RA_NOME)
	c_Ctps      := Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
	c_Est      := Alltrim(SM0->M0_ESTENT)
	c_Cep       := Transform(Alltrim(SM0->M0_CEPENT), "@R 99999-999")
	c_Cargo     := Alltrim(SRJ->RJ_DESC )
	c_Salario   := SRA->RA_SALARIO
	c_SalExt    := Extenso(SRA->RA_SALARIO)
	c_Local     := Alltrim(SM0->M0_CIDENT)
	c_Est1      := Alltrim(SM0->M0_ESTENT)
	c_Horario   := mv_par02
	c_Intervalo := mv_par03
	d_Inicio    := SRA->RA_ADMISSA
	c_Cidade    := Alltrim(SM0->M0_CIDENT)
	d_Data      := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + StrZero(Year(SRA->RA_ADMISSA), 4)
	                   
    DbSelectArea("SRJ")   
    DbSetOrder(1)
    DbSeek(substring(xFilial("SRA"),1,4)+"  "+ALLTRIM(SRA->RA_CODFUNC))
    MDESC := ALLTRIM(SRJ->RJ_DESC)
                                      
    DbSelectArea("SR6")   
    DbSetOrder(1)
    DbSeek(xFilial("SRA")+ALLTRIM(SRA->RA_TNOTRAB))
    MTURNO = alltrim(SR6->R6_DESC)    
    
    DbSelectArea("SPJ")   
    DbSetOrder(1)
    DbSeek(xFilial("SRA")+ALLTRIM(SRA->RA_TNOTRAB))
    MINTER = allTRIM(SPJ->PJ_HRSINT1)

	c_texto = ''
	n_col := 67
	n_lin := 60
	oPrinter:Say(0111,0852,"CONTRATO DE TRABALHO A T�TULO DE EXPERI�NCIA",oArial12N,,0)
	oPrinter:Say(0170,1166,"(Art. 479 da CLT)",oArial10,,0)
	c_emp :=    "Entre "+ c_Empresa + ",CNPJ N� " + c_Cnpj+",com sede na: "
    c_end :=    c_Endereco +", " + alltrim(c_Bairro) + ", " + alltrim(c_Cidade) + "-" + alltrim(c_Est1) + ", CEP: " + alltrim(c_cep) 
    c_fun :=   "doravante designada Empregadora, e o Sr.(a) " + c_Func
   
   // c_desc :=   "1. O(A) EMPREGADO(A), exercer� a fun��o de , submetido a controle de ponto em ",oArial10,,0)"          
    
 	n_Col   := 0187
   	n_Lin   := 150
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_emp,oArial10,,0)
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_end,oArial10,,0)
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,c_fun,oArial10,,0)
	n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,",portador (a)  da  Carteira de Trabalho e  Previd�ncia   Social de n�mero e s�rie:"+ alltrim (c_Ctps)+"",oArial10,,0)
   n_Lin = n_Lin+50
	oPrinter:Say(n_Lin, n_Col,"a seguir designado (a) EMPREGADO(A), � celebrado o presente CONTRATO DE  TRABALHO ",oArial10,,0)
	n_Lin = n_Lin+50
 	oPrinter:Say(n_Lin, n_Col,"A T�TULO  DE  EXPERI�NCIA  de  acordo  com  as  condi��es  a seguir especificadas:" ,oArial10,,0)
	n_Lin = n_Lin+100	        
   	oPrinter:Say(n_lin, n_col,"1.O(A) EMPREGADO(A),exercera a fun��o de : MOTORISTA,com a remunera��o mensal de "+Transform(c_Salario,"@E 9,999,999.99"),oArial10,,0)
    n_Lin = n_Lin+50  
	oPrinter:Say(n_lin,n_col, ALLTRIM(c_SalExt)+"****************************,por m�s.",oArial10,,0)
    n_Lin = n_Lin+100      
    oPrinter:Say(n_lin,n_col,"2. O local de trabalho situa-se em: " + c_Local + "-" + c_Est1,oArial10,,0)
    n_lin:= n_lin+100
    oPrinter:Say(n_lin,n_col,"3. Fica ajustado nos termos do parafrafo 1o do artigo 469 da CLT que a EMPREGADORA podera, a qualquer tempo ",oArial10,,0)
    n_lin:= n_lin+50 
	oPrinter:Say( n_lin,n_col,"transferir o(a) EMPREGADO (A), para qualquer outra localidade do Pais.",oArial10,,0)
	n_lin:= n_lin+100
    oPrinter:Say(n_lin,n_col,"4. Jornada: O Empregado  exercera uma jornada de 08(oito) horas e 44(quarenta e quatro)horas semanais,",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"com horario flexivel, intervalo de 01(uma) hora para descanso e refei��o e intervalo de 11(onze) horas entre jornadas,",oArial10,,0)
	n_lin:= n_lin+100  
	oPrinter:Say(n_lin,n_col,"podendo esse intervalo ser concedido na forma prevista no 3o do art. 235-C, da Lei 13.103, de mar�o de 2015.",oArial10,,0)
    n_lin:= n_lin+100
    oPrinter:Say(n_lin,n_col,"4.1 O Empregado compromete-se a anotar corretamente a papeleta de controle externo, de forma precisa e, caso ",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say( n_lin,n_col,"n�o anote, ou fa�a de forma errada, poder� ser punido com advert�ncia, suspens�o ou at� mesmo dispensa. Por ",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"impregado observar qualquer outro meio id�neo de controle de jornada que for institu�do pelo empregador, atendidas",oArial10,,0)
	n_lin:= n_lin+100    
    oPrinter:Say(n_lin,n_col,"as disposi��es da Lei 12.619 de abril/ 2012 e Lei 13.103 de mar�o/ 2015.",oArial10,,0)  
    n_lin:= n_lin+100		
    oPrinter:Say(n_lin,n_col,"4.2 O Empregado dever� respeitar a legisla��o de tr�nsito e, em especial, as normas relativas ao tempo de dire��o",oArial10,,0)
    n_lin:= n_lin+50                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"e a programa de controle de uso de droga e de bebida alco�lica, institu�do pelo Empregador.",oArial10,,0)
    n_lin:= n_lin+100		
    oPrinter:Say(n_lin,n_col,"4.3 O Empregado tem conhecimento pleno de que dever� respeitar a legisla��o de tr�nsito e de que as anota��es ",oArial10,,0)
    n_lin:= n_lin+50                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"referentes as viagens s�o de sua inteira responsabilidade..",oArial10,,0)
    n_lin:= n_lin+100		
    oPrinter:Say(n_lin,n_col,"4.4 O Empregado tem ci�ncia de que as horas excedentes a jornada, quando o mesmo estiver aguardando carga  e ",oArial10,,0)
    n_lin:= n_lin+50                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"descarga, ser� considerado como tempo de espera e n�o como jornada de trabalho, sendo remunerado de acordo com ",oArial10,,0)
    n_lin:= n_lin+50                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"a legisla��o especifica. ",oArial10,,0)
    n_lin:= n_lin+100		
    oPrinter:Say(n_lin,n_col,"4.5 As horas adicionais ou de sobre-tempo realizadas pelo EMPREGADO, excedentes de 44 horas semanais, poder�o ser  ",oArial10,,0)
    n_lin:= n_lin+50                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"objeto de compensa��o futura ou de conformidade com o BANCO DE HORAS a ser implementado pela EMPREGADORA. ",oArial10,,0)
    n_lin:= n_lin+100                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"5.0 Qualquer gratifica��o, pr�mio, beneficio, etc., que a Empregadora vier a conceder por liberalidade, n�o ",oArial10,,0)
    n_lin:= n_lin+50                                                                                                                                                        
    oPrinter:Say(n_lin,n_col,"ser�o incorporados ao sal�rio para os efeitos legais n�o se considerando nova��o contratual a concess�o, habitual  ",oArial10,,0)
    n_lin:= n_lin+50    
    oPrinter:Say(n_lin,n_col,"ou n�o, de tais gratifica��es.",oArial10,,0)                                                                                                                                                              
    n_lin:= n_lin+100 
   	oPrinter:Say(n_lin,n_col,"6. A pr�tica de qualquer ato prejudicial � EMPREGADORA,tais como: indisciplina, insubordina��o des�dia,etc.",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,",implica na rescis�o autom�tica deste Contrato.",oArial10,,0)
	n_lin:= n_lin+100
    oPrinter:Say(n_lin,n_col,"7. Em  caso  de  dano  causado  pelo(a)  EMPREGADO (A), fica a EMPREGADORA, autorizada a efetuar o descon-",oArial10,,0)
	n_lin:= n_lin+50 
	oPrinter:Say( n_lin,n_col,"to da import�ncia correspondente ao  preju�zo,  conforme  previsto no par�grafo 1�  do artigo 462 da CLT,",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say( n_lin,n_col,"concordando o empregado, desde j�, em ressarcir o dano causado.",oArial10,,0)
	n_lin:= n_lin+100
    oPrinter:Say(n_lin,n_col,"8.Sempre que a  necessidade  assim o  exigir,  o (a) EMPREGADO(A),se compromete a trabalhar em regime de ",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"compensa��o de horas .",oArial10,,0)
	n_lin:= n_lin+100         
    oPrinter:Say(n_lin,n_col,"9.O prazo deste Contrato � de 30 (trinta) dias, com inicio em "+alltrim(PADR(d_data,80))+" podendo ser prorrogado",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"ate 90(noventa) dias.",oArial10,,0)
	n_lin:= n_lin+100
	oPrinter:Say(n_lin,n_col,"10.Permanecendo o (a) EMPREGADO(A) a servi�o da EMPREGADORA ap�s o t�rmino da experi�ncia,o Contrato",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"passar� a viger por prazo indeterminado,com plena vig�ncia das demais Cl�usulas aqui pactuadas.",oArial10,,0)
	n_lin:= n_lin+50   
	oPrinter:Say(n_lin,n_col,"E, por estarem de pleno acordo, as partes contratantes assinam o presente Contrato de Trabalho em duas",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"vias , ficando  a primeira  em  poder da EMPREGADORA e a segunda como(a) EMPREGADO(A), que dela dar� o",oArial10,,0)
	n_lin:= n_lin+50
	oPrinter:Say(n_lin,n_col,"competente recibo.",oArial10,,0)
	n_lin:=  n_lin+100              
	
	oPrinter:Say(n_lin,200, PADR(""+ c_local + ","+ d_data,80),oArial10,,0)
	n_lin:=  n_lin+100
	
	oPrinter:Say(n_lin,0600,"__________________________________ " ,oArial12,,0)
	oPrinter:Say(n_lin,1605,"___________________________________" ,oArial12,,0)
	n_lin:=  n_lin+50
	oPrinter:Say(n_lin,0600,"EMPREGADORA " ,oArial12,,0)
	oPrinter:Say(n_lin,1605,"EMPREGADO   " ,oArial12,,0)
	n_lin:=  n_lin+50     
	oPrinter:Say(n_lin,0600,"__________________________________ " ,oArial12,,0)
	oPrinter:Say(n_lin,1605,"___________________________________" ,oArial12,,0)
	n_lin:=  n_lin+50 
	oPrinter:Say(n_lin,0600,"TESTEMUNHA  ",oArial12,,0)
	oPrinter:Say(n_lin,1605,"TESTEMUNHA	",oArial12,,0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 f_FGPER010() �Autor  �Pablo VB Carvalho � Data �  09/07/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Op��o Vale Transporte.									  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER010()

   Local c_Data   := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + STRZERO(Year(dDataBase), 4)
   Local c_Cidade := Alltrim(SM0->M0_CIDENT)
   
	c_Empresa 	:= Alltrim(SM0->M0_NOMECOM )
	                                          
	    c_bairro    := Alltrim(SRA->RA_BAIRRO) 
		c_Carteira 	:= Alltrim(SRA->RA_NUMCP)   + "-" + Alltrim(SRA->RA_SERCP) + "-" + Alltrim(SRA->RA_UFCP)
		c_End 	    := Alltrim(SRA->RA_ENDEREC) + "-" + Alltrim(SRA->RA_COMPLEM) +" - "+c_bairro
		c_Mun 	   		:= Alltrim(SRA->RA_MUNICIP) + "-" + Alltrim(SRA->RA_ESTADO)+ " CEP: " + Alltrim(SRA->RA_CEP)

		c_Nome 		:= Alltrim(SRA->RA_NOME )
		c_Matricula 	:= Alltrim(SRA->RA_MAT )
		c_Carteira 	:= c_Carteira

		n_col := 410  
		
		oPrinter:Say(0380,n_col,"Esclarecimentos Legais: ",oArial10,,0)
		oPrinter:Say(0448,n_col,"1. O vale transporte sera pago pelo beneficiario ate o limite de 6% (seis por cento) de seu salario",oArial10,,0)
		oPrinter:Say(0495,n_col,"(excluindo quaisquer adicionais ou vantagens) e pelo empregador, no que exceder a  esse limite.",oArial10,,0)

		oPrinter:Say(0586,n_col,"2. No caso em que o valor limite dos vales recebidos for inferior a  6% (seis por cento) do salario,",oArial10,,0)
		oPrinter:Say(0631,n_col,"o empregado  podera  optar  pelo  recebimento  antecipado  do  vale  transporte, cujo  valor  sera ",oArial10,,0)
		oPrinter:Say(0673,n_col,"integralmente descontado por ocasi�o do pagamento do respectivo sal�rio.",oArial10,,0)

		oPrinter:Say(0751,n_col,"3. N�o e permitido  substituir o fornecimento do Vale Transporte por antecipa��o em dinheiro ou",oArial10,,0)
		oPrinter:Say(0795,n_col,"qualquer outra forma de pagamento,salvo caso de falta ou insufici�ncia de estoque de vales trans-",oArial10,,0)
		oPrinter:Say(0848,n_col,"porte.",oArial10,,0)

		oPrinter:Say(0142,0697,"VALE TRANSPORTE - DECLARA��O / TERMO DE COMPROMISSO",oArial12,,0)
		oPrinter:Say(0917,1024,"DADOS DO EMPREGADO",oArial12,,0)

		oPrinter:Say(1108,n_col,"Nome: "  + c_Nome,oArial10,,0)
		oPrinter:Say(1202,n_col,"Registro: " + c_Matricula,oArial10,,0)
		oPrinter:Say(1286,n_col,"Carteira Profissional: " + c_Carteira,oArial10,,0)
        oPrinter:Say(1435,0707,"OP��O PELO SISTEMA DO VALE TRANSPORTE",oArial12,,0)   
		oPrinter:Say(1542,n_col,"O vale transporte e um direito do trabalhador,  fa�a sua op��o por recebe-lo ou  n�o, ",oArial10,,0)
		oPrinter:Say(1642,n_col,"assinalando um dos quadros abaixo:",oArial10,,0)
		oPrinter:Say(1763,n_col,"Sim (  )                      N�o (  )",oArial10,,0)

		oPrinter:Say(1888,n_col,"Qualquer que  seja sua  op��o, o formulario, total  ou parcialmente preenchido e  assinado,",oArial10,,0)
		oPrinter:Say(1951,n_col,"deve ser encaminhado ao setor de pessoal.",oArial10,,0)
		oPrinter:Say(2077,1024,"DECLARA��O",oArial10,,0)
		oPrinter:Say(2203,n_col,"Para ter uso do Vale Transporte, declaro:",oArial10,,0)
		
		oPrinter:Say(2245,n_col,"",oArial10,,0)

		oPrinter:Say(2285,n_col,"1. Residir a : ",oArial10,,0)
		oPrinter:Say(2342,n_col,"Endere�o: " + c_End,oArial10,,0)
		oPrinter:Say(2400,n_col,"Muncipio: "   + c_Mun ,oArial10,,0)

		oPrinter:Say(2482,n_col,"2. Utilizar os seguintes meios de transporte de minha residencia ate o trabalho e vice-versa:",oArial10,,0)
		oPrinter:Say(2522,n_col,"(  ) ONIBUS 	(  )  TREM  (  ) ONIBUS/TREM ",oArial10,,0)
		oPrinter:Say(2605,n_col,"3. No perimetro:",oArial10,,0)
		oPrinter:Say(2649,n_col,"(  ) MUNICIPAL   (  ) INTERMUNICIPAL   (  ) INTERESTADUAL",oArial10,,0)

		oPrinter:Say(2732,n_col,"4. Utilizar diariamente 01 (uma) condu��o para locomover-me de minha residencia ao traba-",oArial10,,0)
		oPrinter:Say(2776,n_col,"lho e 01 (uma) para  retorno do trabalho para a residencia.",oArial10,,0)
		
		oPrinter:Box(3050,0386,3050,1205)
		oPrinter:Box(3050,1305,3050,2124)
		oPrinter:Say(3100,0400,c_Empresa,oVerda10,,0)
		oPrinter:Say(3100,1325,c_Nome,oVerda10,,0)
		oPrinter:Say(3150,1325,"REGISTRO:  "+c_Matricula,oVerda10,,0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o  	 f_FGPER010() �Autor  �Pablo VB Carvalho � Data �  20/07/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Comunicado Marca��o de Ponto Eletr�nico.					  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPEM003			                                          ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

Static Function f_FGPER013()

  Local c_Data := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + StrZero(Year(SRA->RA_ADMISSA), 4)

  oPrinter:Say(0111,1092,"COMUNICADO",o14,,0)

  oPrinter:Say(0255,0982,"MARCA��O DE PONTO ELETR�NICO",o13,,0)

  oPrinter:Say(0391,0354,"Devido ao repetitivo descumprimento dos procedimentos de marca��o de Ponto Eletr�nico, ",o13,,0)
  oPrinter:Say(0442,0354,"pela maioria dos nossos colaboradores, a BOMIX adverte que:",o13,,0)

  oPrinter:Say(0560,0424,"-  Todos os colaboradores est�o obrigados a registrar diariamente o hor�rio de:",o13,,0)
  oPrinter:Say(0604,0471,"entrada, intervalo de almo�o e sa�da, nos pontos eletr�nicos localizados nas �reas:",o13,,0)
  oPrinter:Say(0653,0471,"industrial, personaliza��o, almoxarifado e administrativa, conforme legisla��o",o13,,0)
  oPrinter:Say(0704,0471,"trabalhista vigente.",o13,,0)

  oPrinter:Say(0791,0424,"-  Os colaboradores dever�o realizar a marca��o do ponto no rel�gio localizado  ",o13,,0)
  oPrinter:Say(0840,0471,"�rea de atua��o.",o13,,0)


  oPrinter:Say(0964,0424,"-  Caso surja algum problema t�cnico com o rel�gio de ponto da �rea, que impe�a a ",o13,,0)
  oPrinter:Say(1013,0471,"marca��o, o colaborador devera imediatamente comunicar ao seu gerente que ",o13,,0)
  oPrinter:Say(1062,0471,"tomar� as provid�ncias cab�veis.",o13,,0)

  oPrinter:Say(1157,0424,"-  Os funcion�rios dever�o realizar a marca��o do ponto obedecendo a sua escala de ",o13,,0)
  oPrinter:Say(1213,0471,"trabalho.",o13,,0)

  oPrinter:Say(1308,0424,"-  Qualquer altera��o do hor�rio de marca��o devera ser imediatamente comunicada ao",o13,,0)
  oPrinter:Say(1362,0471,"gerente respons�vel pela �rea, que registrara a ocorr�ncia.",o13,,0)

  oPrinter:Say(1491,0987,"ATEN��O",o13,,0)
  oPrinter:Say(1584,0660,"Hor�rio para a marca��o do Ponto:",o13,,0)

  oPrinter:Say(1657,0737,"a)  Na Entrada: Inicio da Jornada",o13,,0)
  oPrinter:Say(1722,0737,"b)  Intervalo: Inicio do hor�rio de descanso intrajornada",o13,,0)
  oPrinter:Say(1780,0737,"c)  Retorno do Intervalo: at� dois minutos(2), do reinicio da jornada.",o13,,0)
  oPrinter:Say(1844,0737,"d)  Na Sa�da: Imediatamente ap�s o termino da jornada.",o13,,0) 
  
  
  oPrinter:Say(1936,0354,"Nao ser�o descontadas e nem computadas como jornada extraordinaria as varia��es de registro",o13,,0)
  oPrinter:Say(1982,0354,"no hor�rio n�o excedentes de cinco(05) minutos, observado o limite maximo de dez minutos(10)",o13,,0)  
  
  oPrinter:Say(2028,0354,"di�rios.(art.58.paragrafo 1, da CLT).",o13,,0)
  oPrinter:Say(2074,0354,"A marca��o fora do hor�rio ou falta de marca��o consiste em falta grave, e resultar� em",o13,,0)
  oPrinter:Say(2120,0354,"advert�ncia por escrito, sendo que a repeti��o desta, ser� seguida de suspens�o, podendo",o13,,0)  
  oPrinter:Say(2166,0354,"levar a aplica��o da pena de demiss�o por justa causa, caso o colaborador n�o corrija o",o13,,0)  
  oPrinter:Say(2212,0354,"seu procedimento.",o13,,0)  

  oPrinter:Say(2304,0940,"ESPERAMOS A COLABORACAO DE TODOS",o13,,0)

  oPrinter:Say(2396,0354,"Declaro que recebi copia do regulamento interno para marca��o de ponto eletr�nico, bem ",o13,,0)
  oPrinter:Say(2442,0359,"como estou ciente e de acordo com seu conte�do.",o13,,0)

  oPrinter:Say(2672,0380,"Salvador, "+ c_Data ,o13,,0)
  oPrinter:Say(2806,0368,"___________________________________",o13,,0)
  oPrinter:Say(2852,0380,Alltrim(SRA->RA_NOME ),o13,,0)
  oPrinter:Say(2898,0375,"Matricula: " + Alltrim(SRA->RA_MAT),o13,,0)

Return