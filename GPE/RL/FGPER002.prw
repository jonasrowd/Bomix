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
	
	Local c_Perg		:= "FGPER2A"
	
	Private o_Telas	:= clsTelasGen():New()
	//Private l_Opcao	:= o_Telas:mtdOkCancel("Janela de Teste da Classe TestaTelas","Esta rotina tem a finaldade de", "Imprimir o abono pecuniario", "Desenvolvido pela Totvs Bahia")
	Private l_Opcao	:= o_Telas:mtdParOkCan("Contrato de Experiencia","Esta rotina tem a finaldade de", "imprimir o contrato de trabalho a titulo de experiencia", "Desenvolvido pela Totvs Bahia","FGPER002")
	If l_Opcao
		f_ValidPerg(c_Perg)
		if !Pergunte(c_Perg,.T.)
			Return()
		endif
		//f_IntWord()
		f_relatorio()
	else
		//Alert("Clicou no Cancelar")
		Return()
	endif
Return


Static Function f_relatorio()
	Private oArial12N	    :=	TFont():New("Arial Narrow",,12,,.T.,,,,,.F.,.F.)
	Private oArial10  	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
	Private oArial9  	:=	TFont():New("Arial Narrow",,9,,.F.,,,,,.F.,.F.)
	Private oArial12  	:=	TFont():New("Arial Narrow",,12,,.F.,,,,,.F.,.F.)
	Private oArial4  	:=	TFont():New("Arial Narrow",,4,,.F.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("CONTRATO DE EXPERI�NCIA")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()
Return()

Static Function printPage()
	
	c_Empresa =     SM0->M0_NOMECOM
	c_Cnpj    =     SM0->M0_CGC
	DbSelectArea("SRA")
    DbSetOrder(1)
	dbgotop()
	IF  dbSeek(xFilial("SRA")+MV_PAR01)
		DbSelectArea("SQ3")
		SQ3->( DbSetOrder(1))
		SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO))
		DbSelectArea("SQ3")
		SR6->( DbSetOrder(1))
		SR6->( DbSeek(xFilial("SR6")+SRA->RA_TNOTRAB)) 
		SRJ->( DbSeek(substring(xFilial("SRA"),1,4)+SRA->RA_CODFUNC))
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
		c_Horario   := mv_par02
		c_Intervalo := mv_par03
		d_Inicio    := SRA->RA_ADMISSA
		c_Cidade    := Alltrim(SM0->M0_CIDENT)
		d_Data      := STRZERO(Day(SRA->RA_ADMISSA), 2) + " de " + MesExtenso(SRA->RA_ADMISSA) + " de " + StrZero(Year(SRA->RA_ADMISSA), 4)
	                   
	    DbSelectArea("SRJ")   
	    DbSetOrder(1)
	    DBGOTOP()
	    DbSeek(substring(xFilial("SRA"),1,4)+"  "+ALLTRIM(SRA->RA_CODFUNC))
	    MDESC := ALLTRIM(SRJ->RJ_DESC)
                                      
        DbSelectArea("SR6")   
	    DbSetOrder(1)
	    DBGOTOP()
	    DbSeek(xFilial("SRA")+ALLTRIM(SRA->RA_TNOTRAB))
	    MTURNO = alltrim(SR6->R6_DESC)    
	    
	    DbSelectArea("SPJ")   
	    DbSetOrder(1)
	    DBGOTOP()
	    DbSeek(xFilial("SRA")+ALLTRIM(SRA->RA_TNOTRAB))
	    MINTER = allTRIM(SPJ->PJ_HRSINT1)
        
        
		
		SRA->(DBCLOSEAREA())
		SQ3->(DBCLOSEAREA())
		SR6->(DBCLOSEAREA())
		SRJ->(DBCLOSEAREA())
		
		//PREENCHIMENTO PARA TESTE 
		c_empresa:= 'BOMIX INDUSTRIA DE EMBALAGEM LTDA'
		C_bairro := 'JARDIM CAJAZEIRAS'
		c_Cnpj   := '01.561.279/0001-45'
		c_Cep    := '41.230.455'
		c_Endereco  :='AV. ALIOMAR BALEEIRO'
	
		c_texto = ''
		n_col := 67
		n_lin := 60
		oPrinter:Say(0111,0852,"CONTRATO DE TRABALHO A T�TULO DE EXPERI�NCIA",oArial12N,,0)
		oPrinter:Say(0180 + n_lin,1166,"(Art. 479 da CLT)",oArial10,,0)
		c_emp :=    "Entre "+ c_Empresa + ",CNPJ N� " + c_Cnpj+",com sede na: "
	    c_end :=    c_Endereco +", " + alltrim(c_Bairro) + ", " + alltrim(c_Cidade) + "-" + alltrim(c_Est1) + ", CEP: " + alltrim(c_cep) 
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
		oPrinter:Say(n_Lin, n_Col,",portador (a)  da  Carteira de Trabalho e  Previd�ncia   Social de n�mero e s�rie:"+ alltrim (c_Ctps)+"",oArial10,,0)
	   n_Lin = n_Lin+50
		oPrinter:Say(n_Lin, n_Col,"a seguir designado (a) EMPREGADO(A), � celebrado o presente CONTRATO DE  TRABALHO ",oArial10,,0)
		n_Lin = n_Lin+50
	 	oPrinter:Say(n_Lin, n_Col,"A T�TULO  DE  EXPERI�NCIA  de  acordo  com  as  condi��es  a seguir especificadas:" ,oArial10,,0)
		n_Lin = n_Lin+100	        
    	oPrinter:Say(n_lin, n_col,"1.O(A) EMPREGADO(A),exercera a fun��o de :"+ MDESC +",com a remunera��o mensal de "+Transform(c_Salario,"@E 9,999,999.99"),oArial10,,0)
	    n_Lin = n_Lin+50  
		oPrinter:Say(n_lin,n_col, ALLTRIM(c_SalExt)+"*****,por m�s.",oArial10,,0)
        n_Lin = n_Lin+100      
        oPrinter:Say(n_lin,n_col,"2. O local de trabalho situa-se em: " + c_Local + "-" + c_Est1,oArial10,,0)
        n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"3. Fica ajustado nos termos do parafrafo 1o do artigo 468 da CLT que a EMPREGADORA podera, a qualquer tempo ",oArial10,,0)
	    n_lin:= n_lin+50 
		oPrinter:Say( n_lin,n_col,"transferir o(a) EMPREGADO (A), para qualquer outra localidade do Pais.",oArial10,,0)
		n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"4. O  horario  de  trabalho  do  (a)  EMPREGADO  (A),sera de " + MTURNO + "  com  intervalo  de 01:15Hs para",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"refei��o, podendo a EMPREGADORA, alter�-lo de acordo com as necessidades do servi�o.",oArial10,,0)
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
        oPrinter:Say(n_lin,n_col,"7. Em  caso  de  dano  causado  pelo(a)  EMPREGADO (A), fica a EMPREGADORA, autorizada a efetuar o descon-",oArial10,,0)
		n_lin:= n_lin+50 
		oPrinter:Say( n_lin,n_col,"to da import�ncia correspondente ao  preju�zo,  conforme  previsto no par�grafo 1�  do artigo 462 da CLT,",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say( n_lin,n_col,"concordando o empregado, desde j�, em ressarcir o  j�, em ressarcir o dano causado.",oArial10,,0)
		n_lin:= n_lin+100
        oPrinter:Say(n_lin,n_col,"8.Sempre que a  necessidade  assim o  exigir,  o (a) EMPREGADO(A),se compromete a trabalhar em regime de ",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"compensa��o de horas e revezamento de hor�rio,  inclusive em  per�odo noturno.",oArial10,,0)
		n_lin:= n_lin+100         
		
        oPrinter:Say(n_lin,n_col,"9.Toda e qualquer informa��o que o(a) empregado venha a ter conhecimento em decorrencia do contrato de trabalho",oArial10,,0)
        n_lin:= n_lin+50
        oPrinter:Say(n_lin,n_col,"� de carater sigiloso e n�o poder� ser divulgada pelo(a) empregado(a), sob qualquer hipotese responsabilizando-se",oArial10,,0)
        n_lin:= n_lin+50
        oPrinter:Say(n_lin,n_col,"o(a) empregado civil e criminalmente, a qualquer tempo pela viola��o do sigilo ou uso das informa��es em disconfor- ",oArial10,,0)                
        n_lin:= n_lin+50
        oPrinter:Say(n_lin,n_col,"midade com o presente contrato",oArial10,,0)                
        
		n_lin:= n_lin+100                 
		oPrinter:Say(n_lin,n_col,"10.O prazo deste Contrato � de 30 (trinta) dias, com inicio em "+alltrim(PADR(d_data,80))+" podendo ser prorrogado",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"ate 90(noventa) dias.",oArial10,,0)
		n_lin:= n_lin+100
		oPrinter:Say(n_lin,n_col,"11.Permanecendo o (a) EMPREGADO(A) a servi�o da EMPREGADORA ap�s o t�rmino da experi�ncia,o Contrato",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"passar� a viger por prazo indeterminado,com plena vig�ncia das demais Cl�usulas aqui pactuadas.",oArial10,,0)
		n_lin:= n_lin+100   
		oPrinter:Say(n_lin,n_col,"E, por estarem de pleno acordo, as partes contratantes assinam o presente Contrato de Trabalho em duas",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"vias , ficando  a primeira  em  poder da EMPREGADORA e a segunda como(a) EMPREGADO(A), que dela dar� o",oArial10,,0)
		n_lin:= n_lin+50
		oPrinter:Say(n_lin,n_col,"competente recibo.",oArial10,,0)
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
		
	ELSE
		AVISO("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		SRA->(DBCLOSEAREA())
		Return()
	EndIF
Return()


Static Function f_IntWord()
	
	Local n_Opc			:= 0	//Botao selecionado
	Local c_FileOpen	:= ""	//Path do arquivo .dot
	Local c_MaskCNPJ	:= ""
	c_FileOpen	:= "C:\totvs\WorkSpace\BOMIX\ADVPL\SIGAGPE\ADVPL\MODELOS\FGPER002.dot"
	IF EMPTY(c_FileOpen)
		AVISO(SM0->M0_NOMECOM,"O Arquivo .dot n�o foi informado. Imposs�vel continuar.",{"Ok"},2,"Aten��o")
		Return()
	ENDIF
	LjMsgRun("Aguarde... Gerando Relatorio","Contrato a Titulo de Experiencia",{|| f_GeraRelatorio( c_FileOpen ) })
Return()
Static Function f_GeraRelatorio( c_FileOpen )
	Local o_Word     	:= NIL
	Local c_GrvFile	:= "C:\Users\lucas.jesus\Documents\Bomix Relatorios\FGPER002.doc"
	o_Word := OLE_CreateLink()
	If (o_Word == "1")
		alert("word n�o econtrado!")
		Return
	Endif
	OLE_NewFile( o_Word, c_FileOpen )
	OLE_SetDocumentVar( o_Word, 'c_Empresa' , SM0->M0_NOMECOM)
	OLE_SetDocumentVar( o_Word, 'c_Cnpj' , SM0->M0_CGC)
	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA")+ MV_PAR01 ))
	IF SRA->(!EOF())
		DbSelectArea("SQ3")
		SQ3->( DbSetOrder(1) )
		SQ3->( DbSeek(xFilial("SQ3")+SRA->RA_CARGO ))
		DbSelectArea("SQ3")
		SR6->( DbSetOrder(1) )
		SR6->( DbSeek(xFilial("SR6")+SRA->RA_TNOTRAB ))
		OLE_SetDocumentVar( o_Word, 'c_Endereco' 	, Alltrim(SM0->M0_ENDCOB))
		OLE_SetDocumentVar( o_Word, 'c_Bairro' 	, Alltrim(SM0->M0_BAIRENT))
		OLE_SetDocumentVar( o_Word, 'c_Cidade' 	, Alltrim(SM0->M0_CIDENT))
		OLE_SetDocumentVar( o_Word, 'c_Func'	    , Alltrim(SRA->RA_NOME))
		OLE_SetDocumentVar( o_Word, 'c_Ctps'		, Alltrim(SRA->RA_NUMCP) + " - " + Alltrim(SRA->RA_SERCP) + " - " + Alltrim(SRA->RA_UFCP))
		OLE_SetDocumentVar( o_Word, 'c_Est'		, Alltrim(SM0->M0_ESTCOB))
		OLE_SetDocumentVar( o_Word, 'c_Cep' 		, Transform(Alltrim(SM0->M0_CEPCOB), "@R 99999-999"))
		OLE_SetDocumentVar( o_Word, 'c_Cargo'		, Alltrim(SQ3->Q3_DESCSUM )    )
		OLE_SetDocumentVar( o_Word, 'c_Salario'	, SRA->RA_SALARIO)
		OLE_SetDocumentVar( o_Word, 'c_SalExt'		, Extenso(SRA->RA_SALARIO))
		OLE_SetDocumentVar( o_Word, 'c_Local'		, Alltrim(SM0->M0_CIDCOB))
		OLE_SetDocumentVar( o_Word, 'c_Est1'		, Alltrim(SM0->M0_ESTCOB))
		OLE_SetDocumentVar( o_Word, 'c_Horario'	, mv_par02)
		OLE_SetDocumentVar( o_Word, 'c_Intervalo'	, mv_par03)
		OLE_SetDocumentVar( o_Word, 'd_Inicio'		, SRA->RA_ADMISSA)
		OLE_SetDocumentVar( o_Word, 'c_Cidade' 	, Alltrim(SM0->M0_CIDENT))
		OLE_SetDocumentVar( o_Word, 'd_Data' 	    , STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + StrZero(Year(dDataBase), 4))
		SRA->(DBCLOSEAREA())
		SQ3->(DBCLOSEAREA())
		SR6->(DBCLOSEAREA())
	ELSE
		AVISO("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		SRA->(DBCLOSEAREA())
		Return()
	EndIF
	OLE_UpDateFields( o_Word )
	OLE_SaveAsFile( o_Word, c_GrvFile )
	OLE_CloseLink( o_Word )
	ShellExecute ("open",c_GrvFile,"","",SW_SHOWMAXIMIZED)
Return()
Static Function f_ValidPerg(c_Perg)
	Local a_PAR01        := {}
	Local a_PAR02        := {}
	Local a_PAR03        := {}
	Local a_PAR04        := {}
	Aadd(a_PAR01, "Informe a matricula do colaborador")
	Aadd(a_PAR02, "Horario:")
	Aadd(a_PAR03, "Intervalo:")
	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch0","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)
	PutSx1(c_Perg,"03","Horario Entrada?   ","","","mv_ch1","C",10,0,0,"G","","","","","mv_PAR02","","","","","","","","","","","","","","","","",a_PAR02)
	PutSx1(c_Perg,"02","Intervalo?   ","","","mv_ch2","C",10,0,0,"G","","","","","mv_PAR03","","","","","","","","","","","","","","","","",a_PAR03)
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


