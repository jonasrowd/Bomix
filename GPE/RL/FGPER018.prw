#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function FGPER018()         


Local c_Perg		:= "FGPER018"

Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Termo de Sigilo e Confidencialidade","Esta rotina tem a finaldade de", "imprimirno termo de sigilo e confidencialidade", "Desenvolvido pela Totvs Bahia","FGPER018")

If l_Opcao
	If !Pergunte()
		f_ValidPerg(c_Perg)
	EndIf
	f_GeraRelatorio()

Else
	Return()
EndIf

Return

Static Function 	f_GeraRelatorio()

Private o11N		    :=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
Private o11NI			:=	TFont():New("",,11,,.T.,,,,,.F.,.T.)
Private oPrinter  	:=	tAvPrinter():New("FGPER018")

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

Return

Static Function printPage()

  
  DbSelectArea("SRA")
  DbSetOrder(1)
  DbSeek(xFilial("SRA")+mv_par01)                                                                                     
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


Static Function f_ValidPerg(c_Perg)

Local a_PAR01        := {}

Aadd(a_PAR01, "Informe a matricula")

//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()











