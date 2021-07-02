#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"
#include "protheus.ch"

User Function FGPER007()

	Local c_Perg		:= "FGPER007"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Carta de Abertura de Conta","Esta rotina tem a finaldade de imprimir a carta de abertura de conta.", "Desenvolvido pela Totvs Bahia", "","FGPER007")

	If l_Opcao

	f_ValidPerg(c_Perg)
	if !Pergunte(c_Perg,.T.)
			Return()
	endif

		f_RelatPadrao()

	Else

		Return()

	EndIf

Return

Static Function f_RelatPadrao()

	Private oArial10N	:=	TFont():New("Arial",,11,,.f.,,,,,.F.,.F.)
	Private o10N	:=	TFont():New("Arial",,11,,.f.,,,,,.F.,.F.)
	Private o11N	:=	TFont():New("Arial",,12,,.f.,,,,,.F.,.F.)
	Private o14N	:=	TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("Abertura de Contas")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

Static Function printPage()

	Local c_linha := ''
	n_Lin := 0900
	n_Col := 0225
	c_Emp 	:= ALLTRIM(SM0->M0_NOMECOM)
	c_CNPJ := SM0->M0_CGC

	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )
	IF DbSeek(xFilial("SRA")+mv_par01) .AND. SRA->RA_SITFOLH = " "

		c_Local 	:= SM0->M0_CIDENT
		//d_Data 	:= STRZERO(Day(dDataBase),2,0) + " de " + MesExtenso(dDataBase) + " de " + Year(dDataBase)
		c_extdata	:= cValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + cValToChar(Year(dDataBase))
		n_dia 		:= STRZERO(Day(dDataBase),2,0)
		c_mes 		:= MesExtenso(dDataBase)
		n_ano 		:= Year(dDataBase)
		c_Nome 	:= Alltrim(SRA->RA_NOME)
		c_End 		:= Alltrim(SRA->RA_ENDEREC)
		c_Bairro 	:= Alltrim(SRA->RA_BAIRRO)
		c_Estado   := Alltrim(SRA->RA_ESTADO)
		d_Admissa 	:= SRA->RA_ADMISSA
		c_Ctps 	:=  alltrim(SRA->RA_NUMCP) + "-" + alltrim(SRA->RA_SERCP) + "-" + alltrim(SRA->RA_UFCP)
		c_Munici   := Alltrim(SRA->RA_ESTADO)
		c_Registro	:=  Transform(Alltrim(SRA->RA_RG), "@R  99999999-99")
		c_CPF 		:= Transform(Alltrim(SRA->RA_CIC), "@R  999.999.999-99")
		n_Salario 	:= Transform(SRA->RA_SALARIO,"@E 9,999,999.99")
		c_SalExt 	:= ALLTRIM(Extenso(SRA->RA_SALARIO))
		c_Resp 	:= Alltrim(mv_par02)
		c_Setor 	:= Alltrim(mv_par03)

		oPrinter:Say(0200,n_Col,Alltrim(c_Local)+ ", " + c_extdata,o14N,,0)
		oPrinter:Say(0393,n_Col,"Ao",oArial10N,,0)
		//nome do banco
		oPrinter:Say(0451,n_Col,mv_PAR04,oArial10N,,0)
		oPrinter:Say(0502,n_Col,mv_PAR05,oArial10N,,0)
		oPrinter:Say(0677,0959,"DECLARAÇÃO",o14N,,0)
	    c_End:= c_End +', '+ c_Bairro +'-'+ c_Estado
		//Imprime texto 'declaração de abertura de conta

	   oPrinter:Say(n_Lin+= 50, n_Col  ,"Declaramos para fins exclusivos de abertura de conta salário, que Sr(a): " +  c_Nome ,oArial10N,,0)
	   oPrinter:Say(n_Lin+= 50, n_Col  ,', CTPS: ' + alltrim(c_Ctps) + ', RG n°:  '+  alltrim(c_Registro) +' , '+ 'CPF n°: '+ c_CPF + ' residente : ' ,oArial10N,,0)
	   oPrinter:Say(n_Lin+= 50, n_Col  ,c_End + ', é nosso funcionário desde ' +  dtoc(d_Admissa) + ' com salário mensal de: ',oArial10N,,0)
	   oPrinter:Say(n_Lin+= 50, n_Col  ,alltrim(cvaltochar(n_Salario)) + ' (' + c_SalExt + ').',oArial10N,,0)

		n_Lin:= 1300
		oPrinter:Say(n_Lin+=50,n_Col,"Atenciosamente,",oArial10N,,0)
		n_Lin+=150
		oPrinter:Box(n_Lin,n_Col,n_Lin+=150,1064)

		oPrinter:Say(n_Lin+=20,n_Col, c_Emp ,o10N,,0)
		oPrinter:Say(n_Lin+=50,n_Col,c_Resp +'/' + c_Setor,o10N,,0)
		oPrinter:Say(n_Lin+=50,n_Col,"Conta Pagadora Ag: "+ alltrim(mv_PAR06) + " C/C: " + alltrim(mv_PAR07),o10N,,0)
		//imagem roda pé
		//oPrinter:SayBitMap(2980,0261,cImag001,1811,0217)

 	 Else

		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()

	ENDIF

	DBCLOSEAREA("SRA")

Return

//formata o texto
Static function f_FormatText(c_Texto)

	a_lines := {}
	c_len :=  73
	c_ini :=  1
	For n_Cnt := 1 To 5
		AADD(a_lines,SUBSTR(c_Texto,c_ini,c_len))
		c_ini = c_ini + 73
	Next

Return(a_lines)

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}
	Local a_PAR05        := {}
	Local a_PAR06        := {}
	Local a_PAR07        := {}

	Aadd(a_PAR01, "Informe a matricula do colaborador")
	Aadd(a_PAR02, "Informe o nome responsavel pela declaracao")
	Aadd(a_PAR03, "Informe o Cargo do Responsavel")
	Aadd(a_PAR04, "Informe o Nome do Banco")
	Aadd(a_PAR05, "Informe Local do Banco")
	Aadd(a_PAR06, "Número da Agência")
	Aadd(a_PAR07, "Número da Conta")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch0","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"02","Nome Responsavel?        ","","","mv_ch1","C",35,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
	PutSx1(c_Perg,"03","Cargo Responsavel?       ","","","mv_ch2","C",35,0,0,"G","","","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)
	PutSx1(c_Perg,"04","Nome do Banco?       ","","","mv_ch3","C",35,0,0,"G","","","","","mv_PAR04","","","","","","","","","","","","","","","","",a_PAR04)
	PutSx1(c_Perg,"05","Local do Banco?       ","","","mv_ch4","C",35,0,0,"G","","","","","mv_PAR05","","","","","","","","","","","","","","","","",a_PAR05)
	PutSx1(c_Perg,"06","Número da Agência?       ","","","mv_ch5","C",10,0,0,"G","","","","","mv_PAR06","","","","","","","","","","","","","","","","",a_PAR06)
	PutSx1(c_Perg,"07","Número da Conta?       ","","","mv_ch6","C",10,0,0,"G","","","","","mv_PAR07","","","","","","","","","","","","","","","","",a_PAR07)

Return()