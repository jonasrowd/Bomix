#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
/*/
�����������������������������������������������������������������������������
���Programa  �VRFUSER   � Autor � AP6 IDE            � Data �  24/01/08   ���
�������������������������������������������������������������������������͹��
���Descricao � GERA UM EXCEL COM O MODULO SELECIONADO E QUAIS USUARIOS TEM���
���          � ACESSO A ELE                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function VRFUSER()


Local Titulo := "Relat�rio User x Menu."

Private _cDirDocs
Private _cPath
Private _cArquivo
Private _cMenu := ""
Private oDlg
Private lProc := .F.
Private aModulo := {"Somente Users"		,;  
"Todos Menus"							,; 
"Ativo"									,; 
"Compras"								,; 
"Contabilidade"							,; 
"Estoque/Custos"						,; 
"Faturamento"							,; 
"Financeiro"							,; 
"Gest�o de Pessoal"						,; 
"Faturamento de Servi�o"				,; 
"Livros Fiscais"						,; 
"Planej.Contr.Produ��o"					,; 
"Ve�culos"								,; 
"Controle de Lojas"						,; 
"Call Center"							,; 
"Oficina"								,; 
"Protheus8 Report Utility"				,; 
"Ponto Eletr�nico"						,; 
"Easy Import Control"					,; 
"Terminal de Consulta do Funcion�rio"	,;  
"Manuten��o de Ativo"					,;  
"Recrutamento e selec��o de Pessoal"	,;  
"Inspe��o de Entrada"					,;  
"Metrologia"							,;  
"Front Loja"							,;  
"Controle de Documentos"				,;  
"Inspe��o de Processos"					,;  
"Treinamento"							,;  
"Importa��o - Financeiro"				,;   
"Field Service"							,;   
"Easy Export Control"					,;   
"Easy Financing"						,;   
"Easy Accounting"						,;   
"Administra��o de For�a de Venda"		,;  
"Plano de Sa�de"						,; 
"Contabilidade Gerencial"				,; 
"Medicina e Segura��o do Trabalho"		,; 
"Controle de N�o-Conformidades"			,; 
"Controle de Auditoria"					,; 
"Contole Estat�stico de Processo"		,;  
"OMS-Gest�o de Distribui��o"			,; 
"Cargos e S�larios"						,; 
"Auto Pe�as"							,; 
"WMS-Gest�o de Armazenagem"				,; 
"TMS-Gest�o de Transporte"				,; 
"Gest�o de Projetos"					,; 
"Controle de Direitos Autorais"			,; 
"Automa��o de Coletas de Dados"			,; 
"PPAP"									,; 
"R�plica"								,; 
"Gest�o Educacional"				   	,; 
"Easy Drawback Control"					,; 
"Gest�o Hospitalar"						,; 
"Viewer"								,; 
"Avalia��o e Pesquisa de Desempenho"	,; 
"Gest�o de Prefeituras"					,; 
"Sistema de Fideliza��o e An�lise de Cr�dit"	,; 
"Gest�o Ambiental"						,; 
"Planejamento e Controle Or�ament�rio"	,; 
"Gerenciamento de Pesquisa e Resultado"	,; 
"Gest�o de Acervos"						,; 
"HRP Estrutura Organizacional"			,; 
"HRP Gest�o de Pessoal"					,; 
"HRP Ferramentas de Informa��o"			,; 
"HRP Planejamento e Desenvolvimento"	,; 
"Processos Trabalhistas"				,; 
"Gest�o Avocat�cia"						,; 
"Gest�o de Riscos"						,; 
"Gest�o Agricola"						,; 
"Gest�o de Armazens Gerais"				,; 
"Gest�o de Contratos"					,; 
"Arquitetua Organizacional"				,; 
"Loca��o de Veiculos"					,; 
"Photo"									,; 
"C.R.M."								,; 
"B.P.M."								,; 
"Apontamento/Ponto eletronico"			,; 
"Gest�o Juridica"						,; 
"Pr�-faturamento de seri�o"				,; 
"Gest�o de Frete Embarcador"			,; 
"Espec�ficos"							,; 
"Espec�ficos I"							,;
"Espec�ficos II"						,;
"Configurador"}                           
                                           
DEFINE MSDIALOG oDlg TITLE "Relat�rio User x Menu." FROM 50,40 TO 170,350 OF oDlg PIXEL
@ 10,04 SAY OEMTOANSI("Este relatorio ser� 2xportado para o Excel diretamente.") SIZE 248,7 PIXEL OF oDlg
@ 25,04 COMBOBOX _cMenu ITEMS aModulo SIZE 100,8 PIXEL OF oDlg
@ 39,30 BMPBUTTON TYPE 01 ACTION ({If(!Empty(_cMenu),Processa({|| _ExpExcel()},Titulo),Nil)},{If(lProc,Close(oDlg),Nil)})
@ 39,60 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/
�����������������������������������������������������������������������������
���Fun��o    �_ExpExcel � Autor � AP6 IDE            � Data �  24/01/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela VRFUSER.A funcao _ExpExcel    ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�����������������������������������������������������������������������������
/*/

Static Function _ExpExcel(Titulo)

Local aUser:= AllUsers(.T.)
Local n := nPosB := nPosA := nPos := y :=  W := nHandle := nProc := 0
Local _cCabEx := IIf(_cMenu <> "","UserId;NomeId;Nome;E-Mail;Menu;Bloqueado;Departamento;Acessos","UserId;NomeId;Nome;E-Mail;Bloqueado;Departamento")
Local _cNomRel := ";Usu�rio do M�dulo: "+_cMenu
Local cBuffer := "" , cPerProc := ""
Local _nMenu := Ascan(aModulo,{|x|x == _cMenu})  - 2

_cDirDocs := MsDocPath()
_cPath		:= AllTrim(GetTempPath())
_cArquivo  	:= CriaTrab(,.F.)+".CSV"

nHandle := FCreate(_cDirDocs + "\" + _cArquivo)

If nHandle == -1
	MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
	Return
EndIf

FWrite(nHandle,_cNomRel) // Nome do Relatorio
FWrite(nHandle, CRLF)
FWrite(nHandle, "")
FWrite(nHandle, CRLF)

FWrite(nHandle,_cCabEx) // Cabe�alho
FWrite(nHandle, CRLF)

//���������������������������������������������������������������������Ŀ
//� PROCREGUA-> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
ProcRegua(Len(aUser))

For n := 1 To Len(aUser)
	nProc += 1
	cPerProc := AllTrim(Str((Round(nProc/Len(aUser)*100,2))))
	
	IncProc("Percentual "+cPerProc+"%")
	If _cMenu <> aModulo[1] .And. _cMenu <> aModulo[2]  .And. aUser[n,1,1] <> "000000" // gera somente o Menu selecionado
		If Upper(Substr(aUser[n,3,_nMenu],3,1)) <> "X"
			
			cBuffer := "'"+ToXlsFormat(aUser[n,1,1])+";"+ ;
			ToXlsFormat(aUser[n,1,2])+";"+ ;
			ToXlsFormat(aUser[n,1,4])+";"+ ;
			ToXlsFormat(AllTrim(aUser[n,1,14]))+";"+ ;
			ToXlsFormat(AllTrim(aUser[n,3,_nMenu]))+";"+ ;
			ToXlsFormat(IIF(aUser[n,1,17],"SIM","N�O"))+";"+ ;
			ToXlsFormat(AllTrim(Str(aUser[n,1,15])))
			
			FWrite(nHandle, cBuffer)
			FWrite(nHandle, CRLF)
			
		Endif
	ElseIf _cMenu == aModulo[1] .Or. aUser[n,1,1] == "000000" //Somente os usuarios
		
		cBuffer := "'"+ToXlsFormat(aUser[n,1,1])+";"+ ;
		ToXlsFormat(aUser[n,1,2])+";"+ ;
		ToXlsFormat(aUser[n,1,4])+";"+ ;
		ToXlsFormat(AllTrim(aUser[n,1,14]))+";;"+ ;
		ToXlsFormat(IIF(aUser[n,1,17],"SIM","N�O"))+";"+ ;
		ToXlsFormat(AllTrim(Str(aUser[n,1,15])))
		
		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)
		
	ElseIf _cMenu == aModulo[2] // GERA TODOS OS MENUS 
		For nY := 1 To Len(aUser[n,3])  
			If Upper(Substr(aUser[n,3,nY],3,1)) <> "X"
				cBuffer := "'"+ToXlsFormat(aUser[n,1,1])+";"+ ;
				ToXlsFormat(AllTrim(aUser[n,1,2]))+";"+ ;
				ToXlsFormat(AllTrim(aUser[n,1,4]))+";"+ ;
				ToXlsFormat(AllTrim(aUser[n,1,14]))+";"+ ;
				ToXlsFormat(AllTrim(aUser[n,3,nY]))+";"+ ;
				ToXlsFormat(IIF(aUser[n,1,17],"SIM","N�O"))+";"+ ;
				ToXlsFormat(AllTrim(aUser[n,1,12]))+";"+ToXlsFormat(aModulo[nY+2])
		
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
			Endif
		Next
	Endif
Next

cBuffer := "Fim "
FWrite(nHandle, cBuffer)
FClose(nHandle)

CpyS2T(_cDirDocs + "\" + _cArquivo, _cPath, .T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(_cPath + _cArquivo)
oExcelApp:SetVisible(.T.)
oExcelApp:Destroy()

lProc := .T.

Return