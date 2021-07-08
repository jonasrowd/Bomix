#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function FGPER018()

Local c_Perg		:= "FGPER018"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Termo de Sigilo e Confidencialidade","Esta rotina tem a finaldade de imprimir o termo de sigilo e confidencialidade.", "Desenvolvido pela Totvs Bahia", "","FGPER018")

If l_Opcao
	f_ValidPerg(c_Perg)
	If !Pergunte(c_Perg,.T.)
			Return()
	Endif
	f_GeraRelatorio()

Else

	Return()

EndIf

Return

Static Function 	f_GeraRelatorio()

Private o11N		    :=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private o11NI			:=	TFont():New("Arial",,10,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("Termo de Sigilo e Confidencialidade")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

  Local c_Data   := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + STRZERO(Year(dDataBase), 4)

  BEGINSQL ALIAS "QRY"

		SELECT	RA_NOME
		FROM %TABLE:SRA% SRA
		WHERE SRA.RA_FILIAL = %EXP:XFILIAL("SRA")%
		AND RA_MAT = %EXP:MV_PAR01% 
		AND RA_SITFOLH = " "
		AND SRA.%NOTDEL%

	ENDSQL

  	DBSELECTAREA("QRY")
	If QRY->( Eof() )

		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		QRY->(DBCLOSEAREA())
		Return()

   Else   
   
   	  n_Lin := 0284
	  oPrinter:Say(0130,0434,"TERMO DE SIGILO E CONFIDENCIALIDADE - ANEXO AO CONTRATO DE TRABALHO",o11NI,,0)
	  oPrinter:Say(n_Lin,0133,"EMPREGRADO(A): " + ALLTRIM(QRY->RA_NOME) + "  , j� qualificado(a) no Contrato de Trabalho, doravante denominado",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"simplesmente EMPREGADO(A).",o11N,,0)
	  oPrinter:Say(n_Lin += 100,0133,"EMPRESA: BOMIX INDUSTRIA DE EMBALAGENS PLASTICAS, inscrita no CNPJ/MF sob n�"+ Transform(SM0->M0_CGC,'@R 99.999.999/9999-99')+", com sede na,",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"doravante denominada simplesmente EMPRESA.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"Sempre que em conjunto referidas, doravante denominadas como PARTES.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"Considerando que, em raz�o do contrato de trabalho celebrado entre as PARTES, doravante denominado CONTRATO, as mesmas",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"acesso a informa��es confidenciais, as quais se constituem informa��o comercial confidencial.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"Considerando que as PARTES desejam ajustar  as condi��es de revela��o destas informa��es confidenciais j� disponibilizadas ",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"e aquelas que no futuro ser�o disponibilizadas para a execu��o do CONTRATO, bem como definir as regras relativas ao seu uso",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"e prote��o:",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,'Considerando que as PARTES declaram-se conhecedoras do art.482,"g" da CLT:',o11N,,0)

	  oPrinter:Say(n_Lin += 100,1210,'"Art. 482. Constituem justa causa para rescis�o',o11N,,0)
	  oPrinter:Say(n_Lin += 50,1227,"do contrato de trabalho pelo empregador: ",o11N,,0)
	  oPrinter:Say(n_Lin += 50,1227,"empregador: ",o11N,,0)
/////
	  oPrinter:Say(n_Lin += 100,1227,"'g) viola��o de segredo da empresa'." ,o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,'RESOLVEM AS PARTES acima qualificadas, celebrar o presente TERMO DE CONFIDENCIALIDADE  ("Termo"), Acordo ',o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,'Vinculado ao Contrato, mediante as cl�usulas e condi��es que seguem:',o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"1.  CL�USULA PRIMEIRA - DO OBJETO",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"O objeto deste Termo � prover a  necess�ria e adequada prote��o das informa��es confidenciais fornecidas pela EMPRESA,",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"ou pelos seus Clientes ao EMPREGADO, em raz�o do CONTRATO, a fim de que as mesmas possam desenvolver as atividades",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"contempladas no CONTRATO, o qual vincula-se-� expressamente a este.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"1.1.  As estipula��es e obriga��es constantes do presente instrumento ser�o aplicadas a toda e qualquer informacao que seja",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"revelada pela EMPRESA ou pelos seus Clientes.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"2. CL�USULA SEGUNDA: DAS INFORMA��ES CONFIDENCIAIS.",o11N,,0)
	  oPrinter:Say(n_Lin += 100,0133,"2.1.  O EMPREGADO se obriga a manter o mais absoluto sigilo com rela��o a toda e qualquer informa��o, conforme abaixo",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"definida, que tenha sido revelada anteriormente e tamb�m as que venham a ser, a partir desta data, fornecida pela EMPRESA",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"ou pelo seus Clientes, devendo ser tratada como informa��o sigilosa.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"2.2. Dever� ser considerada como informa��o confidencial, toda e qualquer informa��o escrita ou oral, revelada ao EMPREGADO,",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,'contendo ela ou n�o a express�o "Confidencial". O termo "informa��o" abranger� toda informa��o escrita, verbal, digitalizada',o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,'ou de qualquer outro modo apresentada, tangivel ou intangivel, virtual ou fisica, podendo incluir,  mas n�o se limitando a: ' ,o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,'"know-how", t�cnicas, "designs", especifica��es, diagramas, fluxogramas, configura��es, solu��es, f�rmulas, modelos, desenhos,',o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"c�pias, amostras, cadastro de clientes, pre�os e  custos, contratos, planos de neg�cios, processos, projetos, fotografias, programas",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"de computador, discos, disquetes, fitas, conceitos de produto, instala��es, infraestrutura, especifica��es, amostras ",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"de ideias, defini��es e informa��es mercadol�gicas, inven��es e ideias, outras informa��es t�cnicas, financeiras, cont�beis,",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,'fiscais ou comerciais, dentre outros, doravante denominados "INFORMA��ES CONFIDENCIAIS", a que, diretamente ou atrav�s',o11N,,0)

	  oPrinter:Say(3000,0010,'___________________________________________________________________________________________________________' ,o11N,,0)
	  oPrinter:Say(3069,1770,'P�g.: 1' ,o11N,,0)
	  oPrinter:EndPage()

	  n_Lin := 0284

	  oPrinter:Say(0130,0434,"TERMO DE SIGILO E CONFIDENCIALIDADE - ANEXO AO CONTRATO DE TRABALHO",o11NI,,0)
	  oPrinter:Say(n_Lin,0133,"de seus Diretores, Clientes, empregados e/ou prepostos, venha o EMPREGADO, ter acesso, conhecimento, ou que venha",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"lhe ser confiadas durante e em raz�o dos trabalhos realizados e do Contrato Principal celebrado entre as PARTES.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"2.3. Compromete-se, igualmente, o EMPREGADO, a n�o revelar, reproduzir, utilizar ou dar conhecimento, ou alugar",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"ou vender, em hip�tese alguma, a terceiros as INFORMA��ES CONFIDENCIAIS.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"2.4. As PARTES dever�o cuidar para que as informa��es confidenciais fiquem restritas a sede da EMPRESA durante as",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"discuss�es, an�lises, reuni�es e neg�cios, trabalhos e projetos.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"3. CL�USULA TERCEIRA - DOS DIREITOS E OBRIGA��ES.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"O EMPREGADO se compromete e se obriga a utilizar a informa��o confidencial revelada pela EMPRESA exclusivamente",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"para os prop�sitos deste Termo e da execu��o do Contrato Principal, mantendo sempre estrito sigilo acerca de tais",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"informa��es.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"3.1. O EMPREGADO se compromete a n�o efetuar qualquer c�pia da informa��o confidencial sem consentimento pr�vio",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"e expresso da EMPRESA.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"3.2. O EMPREGADO obriga-se a tomar todas as medidas necess�rias � prote��o da informa��o confidencial da EMPRESA,",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"bem como para evitar e prevenir revela��o a terceiros, exceto se permitida devidamente autorizado por escrito pela EMPRESA.",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"De qualquer forma, a revela��o � � permitida para empresas controladoras, controladas e/ou coligadas, assim consideradas as",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"empresas que direta ou indiretamente controlem ou sejam controladas pela EMPRESA.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"4. CL�USULA QUARTA - DA VIG�NCIA.",o11N,,0)
	  oPrinter:Say(n_Lin += 100,0133,"O presente Termo tem natureza irrevog�vel e irretrat�vel, permanecendo em vigor desde a data da revela��o das INFORMA��ES",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"CONFIDENCIAS e mesmo ap�s o t�rmino do Contrato Principal, ao qual este � vinculado.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"5. CL�USULA QUINTA- DAS PENALIDADES.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"A quebra do  sigilo profissional, devidamente comprovada, sem autorizacao expressa da EMPRESA, possibilitar� a imediata",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"rescis�o de qualquer contrato firmado entre as PARTES, sem  qualquer, �nus para a EMPRESA. Neste caso, o EMPREGADO",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"estar� sujeito, por a��o ou omiss�o, ao pagamento ou recomposi��o de todas de ordem moral ou concorrencial, bem como as  de ",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"responsabilidades civil e criminal respectivas, as quais ser�o apuradas em regular processo judicial ou administrativo, mais o valor",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"de eventuais lucros cessantes resultantes de INFORMA��ES CONFIDENCIAIS indevidamente transferidas, devidamente corrigidos.",o11N,,0)


	  oPrinter:Say(n_Lin += 100,0133,"6. CL�USULA SEXTA - DAS DISPOSI��ES GERAIS.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"6.1 O presente Termo constitui acordo entre as PARTES, relativamente ao tratamento das INFORMA��ES CONFIDENCIAIS, ",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"aplicando-se a todos os acordos, promessas, propostas, declara��es, entendimentos e negocia��es anteriores ou posteriores, escritas ou",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"verbais, a��es feitas direta ou indiretamente pelas PARTES, em conjunto ou separadamente, e, ser� igualmente aplicado a todo",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"e qualquer acordo ou entendimento futuro, que venha a ser firmado entre as PARTES.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"6.2 Este Termo de Confidencialidade constitui termo vinculado ao Contrato Principal, parte independente e regulat�ria daquele.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"6.3 Surgindo diverg�ncias quanto � interpreta��o do pactuado neste Termo ou quanto � execu��o das obriga��es dele decorrentes,",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"ou constatando-se nele a exist�ncia de lacunas, solucionar�o as PARTES tais diverg�ncias, de acordo com os princ�pios de boa",o11N,,0)


	  oPrinter:Say(3000,0010,'____________________________________________________________________________________________________________' ,o11N,,0)
	  oPrinter:Say(3069,1770,'P�g.: 2' ,o11N,,0)
	  oPrinter:EndPage()

	  oPrinter:Say(0130,0434,"TERMO DE SIGILO E CONFIDENCIALIDADE - ANEXO AO CONTRATO DE TRABALHO",o11NI,,0)

	  n_Lin := 0284

	  oPrinter:Say(n_Lin += 50,0133,"f�, da equidade, da razoabilidade, e da economicidade e, preencher�o as lacunas com estipula��es que, presumivelmente, teriam",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"correspondido � vontade das PARTES na respectiva ocasi�o.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"6.4 O disposto no presente Termo de Confidencialidade prevalecer�, sempre, em caso de d�vida, e salvo expressa determina��o em",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"contr�rio, sobre eventuais disposi��es constantes de outros instrumentos conexos firmados entre confidenciais, tal como aqui as",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"PARTES quanto ao sigilo de informa��es  definidas.",o11N,,0)

	  oPrinter:Say(n_Lin += 50,0133,"6.5 A omiss�o ou toler�ncia das PARTES, em exigir o estrito cumprimento dos termos e condi��es deste contrato, n�o constituir�",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"nova��o ou ren�ncia, nem afetar� os seus direitos, que o poder�o ser exercidos a qualquer tempo.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"7. CL�USULA S�TIMA - DO FORO.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"� eleito o foro da Cidade do Salvador, capital do Estado da Bahia, renunciando as PARTES a domic�lio, qualquer outro por mais",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"especial ou privilegiado que seja ou que de futuro venha a ter por poder�o domicilio, para quaiquer a��es decorrentes deste contrato.",o11N,,0)

	  oPrinter:Say(n_Lin += 100,0133,"E, por estarem assim justas e contratadas, as PARTES assinam o presente instrumento de contrato, em 02 (duas) vias de igual teor e",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"forma, na presen�a das testemunhas abaixo.",o11N,,0)

	   oPrinter:Say(n_Lin += 250,0133,"Salvador, " + c_data ,o11N,,0)

	  oPrinter:Say(n_Lin += 200,0133,"_________________________________",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,ALLTRIM(SM0->M0_NOMECOM) ,o11N,,0)
	  oPrinter:Say(n_Lin += 100,0133,"_________________________________",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"EMPREGADO",o11N,,0)
	  oPrinter:Say(n_Lin += 100,0133,"_________________________________",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"TESTEMUNHAS",o11N,,0)
	  oPrinter:Say(n_Lin += 100,0133,"_________________________________",o11N,,0)
	  oPrinter:Say(n_Lin += 50,0133,"CPF. N�",o11N,,0)
	  // oPrinter:Say(2564,0133,"CPF. N�",o11N,,0)
	   oPrinter:Say(3000,0010,'____________________________________________________________________________________________________________' ,o11N,,0)
	   oPrinter:Say(3069,1770,'P�g.: 3' ,o11N,,0)

	   oPrinter:EndPage()

	ENDIF
	QRY->(DBCLOSEAREA())
Return


Static Function f_ValidPerg(c_Perg)

 Local a_PAR01        := {}
 Local a_PAR02        := {}

 Aadd(a_PAR01, "Informe a Matricula de")
 
 //PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 PutSx1(c_Perg,"01","Matricula de?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
 
Return()











