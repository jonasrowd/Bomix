#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"

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

/*/{Protheus.doc} FGPER002
(long_description)
@author francisco.ssa
@since 12/12/2014
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function FGPER002()

	Local c_Perg		:= "FGPER002"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Contrato de Experiencia","Esta rotina tem a finaldade de imprimir o contrato de trabalho a titulo de experiencia.", "Desenvolvido pela Totvs Bahia", "","FGPER002")
	
	If l_Opcao
		
		f_ValidPerg(c_Perg)
		if !Pergunte(c_Perg,.T.)
			Return()
		endif
		
		f_relatorio()
	else
		Return()
	endif

Return


Static Function f_relatorio()

	Private oArial12N	    :=	TFont():New("Arial Narrow",,12,,.T.,,,,,.F.,.F.)
	Private oArial10  	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
	Private oArial9  	:=	TFont():New("Arial Narrow",,9,,.F.,,,,,.F.,.F.)
	Private oArial12  	:=	TFont():New("Arial Narrow",,12,,.F.,,,,,.F.,.F.)
	Private oArial4  	:=	TFont():New("Arial Narrow",,4,,.F.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("CONTRATO DE EXPERIÊNCIA")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return()



Static Function printPage()

	c_Empresa =     ALLTRIM(SM0->M0_NOMECOM)
	c_Cnpj    =     Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
	DbSelectArea("SRA")
	DbSetOrder(1)
	IF DbSeek(xFilial("SRA")+ MV_PAR01 )      
	
		DbSelectArea("SRJ")
		SRJ->( DbSetOrder(1))
		SRJ->( DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
		DbSelectArea("SR6")
		SR6->( DbSetOrder(1))
		SR6->( DbSeek(xFilial("SR6")+SRA->RA_TNOTRAB))
		c_Endereco  := Alltrim(SM0->M0_ENDCOB)
		c_Bairro    := Alltrim(SM0->M0_BAIRENT)
		c_Cidade    := Alltrim(SM0->M0_CIDENT)
		c_Func      := Alltrim(SRA->RA_NOME)
		c_Ctps      := Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP)
		c_Est      := Alltrim(SM0->M0_ESTCOB)
		c_Cep       := Transform(Alltrim(SM0->M0_CEPCOB), "@R 99999-999")
		c_Cargo     := Alltrim(SRJ->RJ_DESC )
		c_Salario   := SRA->RA_SALARIO
		c_SalExt    := Extenso(SRA->RA_SALARIO)
		c_Local     := Alltrim(SM0->M0_CIDCOB)
		c_Est1      := Alltrim(SM0->M0_ESTCOB)
		d_Inicio    := SRA->RA_ADMISSA
		c_Cidade    := Alltrim(SM0->M0_CIDENT)
		d_Data      := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4)

		SRA->(DBCLOSEAREA())
		SQ3->(DBCLOSEAREA())
		SR6->(DBCLOSEAREA())

				
		c_texto = ''
		n_col := 67
		n_lin := 60
		oPrinter:Say(0111,0852,"CONTRATO DE TRABALHO A TÍTULO DE EXPERIÊNCIA",oArial12N,,0)
		oPrinter:Say(0180 + n_lin,1166,"(Art. 479 da CLT)",oArial10,,0)
		c_emp :=    "Entre "+ c_Empresa + ",CNPJ Nº " + c_Cnpj+",com sede na: "
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
		oPrinter:Say(n_Lin, n_Col, ",portador (a) da Carteira de Trabalho e Previdência   Social de número e série:"+ alltrim (c_Ctps)+"",oArial10,,0)
	   n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,"a seguir designado (a) EMPREGADO(A), é celebrado o presente CONTRATO DE  TRABALHO ",oArial10,,0)
		n_Lin = n_Lin+50
	 	oPrinter:Say(n_Lin, n_Col,"A TÍTULO DE EXPERIÊNCIA de acordo com as condições a seguir especificadas:" ,oArial10,,0)

		n_Lin = n_Lin -350
		oPrinter:Say(0500 + n_lin,n_col,"1. O(A) EMPREGADO(A), exercerá exercerá a função de " + c_Cargo + ", em serviço",oArial10,,0)
		oPrinter:Say(0550 + n_lin,n_col,"externo não sujeito a controle de jornada, com a remuneração mensal de "+Transform(c_Salario,"@E 9,999,999.99"),oArial10,,0)
	    n_Lin = n_Lin+50
		oPrinter:Say(0550 + n_lin,n_col, ALLTRIM(c_SalExt)+"****************************,por mês.",oArial10,,0)
		n_Lin = n_Lin+50
	 	oPrinter:Say(0600 + n_lin,n_col,"2. O local de trabalho situa-se em: " + c_Local + "-" + c_Est1,oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(0650 + n_lin,n_col,"3. Fica ajustado nos termos do parágrafo 1º do artigo 469 da CLT que a EMPREGADORA  poderá, a qualquer",oArial10,,0)
		oPrinter:Say(0700 + n_lin,n_col,"tempotransferir o(a) EMPREGADO(A), para qualquer outra localidade do País. ",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(0750 + n_lin,n_col, "4. O EMPREGADO deverá observar o cumprimento de jornada mínima diária de "+ MV_PAR02 + " horas e 44(quarenta e quatro)",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(0750 + n_lin,n_col,"horas semanais bem como o intervalo de" + mv_par03 +" horas diárias, para refeição.",oArial10,,0)

		n_lin:= n_lin+50
		oPrinter:Say(0800 + n_lin,n_col,"5. Qualquer gratificação, prêmio, beneficio, etc., que EMPREGADORA, vier a conceder por  liberalidade, não ",oArial10,,0)
		oPrinter:Say(0850 + n_lin,n_col,"serão incorporados ao salário  para os efeitos legais não se considerando renovação contratual a concessão ",oArial10,,0)
		oPrinter:Say(0900 + n_lin,n_col,",habitual ou não,de tais gratificações.",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(0950 + n_lin,n_col,"6. A prática de qualquer ato prejudicial à EMPREGADORA, tais como: indisciplina, insubordinação desídia,etc.",oArial10,,0)
		oPrinter:Say(01000 + n_lin,n_col,",implica na rescisão automática deste Contrato.",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(1050 + n_lin,n_col,"7. Em caso de dano causado pelo(a) EMPREGADO (A), fica a EMPREGADORA, autorizada a efetuar o descon-",oArial10,,0)
		oPrinter:Say(1100 + n_lin,n_col,"to da importância correspondente ao prejuízo, conforme previsto no parágrafo 1º  do artigo 462 da CLT,",oArial10,,0)
		oPrinter:Say(1150 + n_lin,n_col,"concordando o empregado, desde já, em ressarcir o  já, em ressarcir o dano.",oArial10,,0)
		n_lin:= n_lin+50


		oPrinter:Say(1200 + n_lin,n_col,"8. Sempre que a necessidade assim o exigir, o (a) EMPREGADO(A),se compromete a trabalhar em regime de ",oArial10,,0)
		oPrinter:Say(1250 + n_lin,n_col,"compensação de horas e revezamento de horário,  inclusive em  período noturno.",oArial10,,0)
		n_lin:= n_lin+50


		oPrinter:Say(1300 + n_lin,n_col,"9. Toda e qualquer informação que o(a) empregado venha a ter conhecimento em decorrência do contrato de tra-",oArial10,,0)
		oPrinter:Say(1350 + n_lin,n_col,"to de trabalho é de caráter sigiloso e não poderá ser divulgada pelo(a) empregado(a), sob qualquer hipótese,",oArial10,,0)
		oPrinter:Say(1400 + n_lin,n_col,"balho é de caráter sigiloso do contra responsabilizando-se o(a)empregado(a)  ,civil e criminalmente,a qualquer",oArial10,,0)
		n_lin:= n_lin + 50
		oPrinter:Say(1400 + n_lin,n_col,"tempo, pela violação do sigilo ou uso das informações em desconfor-midade com o",oArial10,,0)
	   n_lin:= n_lin+50

		oPrinter:Say(1450 + n_lin,n_col,"10. O prazo deste Contrato é de 30(trinta) dias, com início em " + alltrim(DTOC(d_inicio)) +" podendo ser prorrogado até 90(nove-",oArial10,,0)
		n_lin:= n_lin + 50
		oPrinter:Say(1450 + n_lin,n_col,"nta) dias.",oArial10,,0)
		n_lin:= n_lin + 50
		oPrinter:Say(1500 + n_lin,n_col,PADR("11. Permanecendo o (a) EMPREGADO(A) a serviço da EMPREGADORA após o término da experiência, o Con-",100),oArial10,,0)
		oPrinter:Say(1550 + n_lin,n_col,PADR("trato passará a viger por prazo indeterminado, com plena vigência das demais Cláusulas aqui pactuadas.",100),oArial10,,0)

		oPrinter:Say(1700 + n_lin,n_col,"E, por estarem de pleno acordo, as partes contratantes assinam o presente Contrato de Trabalho em duas",oArial10,,0)
		oPrinter:Say(1750 + n_lin,n_col,"vias,ficando a primeira em poder da EMPREGADORA e a segunda como(a) EMPREGADO(A), que dela dará o",oArial10,,0)
		oPrinter:Say(1800 + n_lin,n_col,"competente recibo.",oArial10,,0)

		n_lin:=  n_lin-60

		oPrinter:Say(1980 + n_lin,200, PADR(""+ c_local + ","+ d_data,80),oArial10,,0)
		n_lin:=  n_lin+50
		oPrinter:Box(2068 + n_lin,0500,2068+ n_lin,1188)
		oPrinter:Box(2068 + n_lin,1348,2068+ n_lin,2020)


		oPrinter:Say(2085 + n_lin,0600,"EMPREGADORA " ,oArial12,,0)
		oPrinter:Say(2085 + n_lin,1605,"EMPREGADO   " ,oArial12,,0)

		oPrinter:Box(2266 + n_lin,0500,2266+ n_lin,1188)
		oPrinter:Box(2266 + n_lin,1346,2266+ n_lin,2020)

		oPrinter:Say(2275 + n_lin,0600,"TESTEMUNHA  ",oArial12,,0)
		oPrinter:Say(2275 + n_lin,1605,"TESTEMUNHA	",oArial12,,0)

	ELSE    
	
		AVISO("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		SRA->(DBCLOSEAREA())
		Return()
	EndIF      
	
	
Return()




static Function f_incLin(c_line ,n_valor)
  c_line :=  c_line + n_valor
Return(c_line)


//formata o texto
static function f_FormatText(c_Texto)
	a_lines := {}
	c_len :=  100
	c_ini :=  1
	For n_Cnt := 1 To 3
		AADD(a_lines,SUBSTR(c_Texto,c_ini,c_len))
		c_ini = c_ini + 100
	Next
return(a_lines)


static function f_negrito(n_li,n_co,c_palavra)
	oPrinter:Say(n_li,n_co,c_palavra,oArial12N0,,0)
return(c_palavra)



Static Function f_ValidPerg(c_Perg)
	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}

	Aadd(a_PAR01, "Informe a matricula do colaborador")
	Aadd(a_PAR02, "Horario:")
	Aadd(a_PAR03, "Intervalo:")
	Aadd(a_PAR04, "Informe o setor do funcionario:")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
   PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch0","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
   PutSx1(c_Perg,"02","Jornada de Trabalho?   ","","","mv_ch1","C",10,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
   PutSx1(c_Perg,"03","Intervalo?   ","","","mv_ch2","C",10,0,0,"G","","","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)
  
Return()
