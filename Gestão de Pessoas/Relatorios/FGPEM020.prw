#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"


User Function FGPEM020(c_texto,c_Titulo)
	Local oButton2
	Local oButton3
	Local oButton4
	Local oButton5
	Local oGroup1
	Local oPanel1
	Local oSay1
	Local oSay2
	Local oSay3
	Local n_Botao
	Static oDlg
	Private oArial11N	:=	TFont():New("Arial",,11,,.T.,,,,,.F.,.F.)
	DEFINE MSDIALOG oDlg TITLE ' ' + c_Titulo FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL
	//@ 002, 000 MSPANEL oPanel1 SIZE 242, 041 OF oDlg COLORS 3, 16777215 RAISED
	@ 001, 003 GROUP  oGroup2 TO 063, 245 PROMPT "" OF oDlg COLOR 0, 16777215 PIXEL
	@ 005, 011 SAY oSay1 PROMPT "Esta rotina tem a finalidade de" SIZE		072,  009 OF   oGroup2 COLORS 0, 16777215 PIXEL
	@ 012, 011 SAY oSay2 PROMPT "imprimir "+ c_texto			  SIZE 	182,  012 OF   oGroup2 COLORS 0, 16777215 PIXEL
	@ 021, 011 SAY oSay3 PROMPT "Desenvolvido pela Totvs Bahia"   SIZE		085,  012 OF   oGroup2 COLORS 0, 16777215 PIXEL
	@ 078, 174 BUTTON oButton2 PROMPT "oButton2" SIZE 000, 001 OF oDlg PIXEL
	@ 064, 003 GROUP  oGroup1 TO 093, 245 PROMPT "" OF oDlg COLOR 0, 16777215 PIXEL
	oButton5      := TButton():New( 76, 047,"Formato Word",oGroup1,{|| n_Botao:=1, oDlg:End() },037,012,,oArial11N,,.T.,,"",,,,.F. )
	oButton4      := TButton():New( 76, 095,"Formato Padrão",oGroup1,{|| n_Botao:=2, oDlg:End() },037,012,,oArial11N,,.T.,,"",,,,.F. )
	oButton4      := TButton():New( 76, 144,"Cancelar",oGroup1,{|| n_Botao:=3, oDlg:End() },037,012,,oArial11N,,.T.,,"",,,,.F. )
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return(n_Botao)





/*CLASS f_Relatorio
	
	// Declaracao das propriedades da Classe
	DATA n_Lin
	DATA n_Col
	
	// Declaração dos Métodos da Classe
	METHOD New() CONSTRUCTOR
	METHOD f_footer(n_Lin,n_col)
	
ENDCLASS

// Criação do construtor, onde atribuimos os valores default
// para as propriedades e retornamos Self
METHOD New() Class f_Relat
	::n_Lin  := 0
	::n_Col  := 0
Return Self

// Criação do Método f_footer imprimi imagem  no roda pé 
METHOD f_footer(n_Lin,n_col,oPrinter) Class f_Relat
	::n_Lin  := n_Lin
	::n_Col  := n_col
	MsgAlert("TESTE")
Return ::nAcumulador/*

 






