#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³VRFUSER   º Autor ³ AP6 IDE            º Data ³  24/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GERA UM EXCEL COM O MODULO SELECIONADO E QUAIS USUARIOS TEMº±±
±±º          ³ ACESSO A ELE                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VRFUSER()


Local Titulo := "Relatório User x Menu."

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
"Gestão de Pessoal"						,; 
"Faturamento de Serviço"				,; 
"Livros Fiscais"						,; 
"Planej.Contr.Produção"					,; 
"Veículos"								,; 
"Controle de Lojas"						,; 
"Call Center"							,; 
"Oficina"								,; 
"Protheus8 Report Utility"				,; 
"Ponto Eletrônico"						,; 
"Easy Import Control"					,; 
"Terminal de Consulta do Funcionário"	,;  
"Manutenção de Ativo"					,;  
"Recrutamento e selecção de Pessoal"	,;  
"Inspeção de Entrada"					,;  
"Metrologia"							,;  
"Front Loja"							,;  
"Controle de Documentos"				,;  
"Inspeção de Processos"					,;  
"Treinamento"							,;  
"Importação - Financeiro"				,;   
"Field Service"							,;   
"Easy Export Control"					,;   
"Easy Financing"						,;   
"Easy Accounting"						,;   
"Administração de Força de Venda"		,;  
"Plano de Saúde"						,; 
"Contabilidade Gerencial"				,; 
"Medicina e Seguração do Trabalho"		,; 
"Controle de Não-Conformidades"			,; 
"Controle de Auditoria"					,; 
"Contole Estatístico de Processo"		,;  
"OMS-Gestão de Distribuição"			,; 
"Cargos e Sálarios"						,; 
"Auto Peças"							,; 
"WMS-Gestão de Armazenagem"				,; 
"TMS-Gestão de Transporte"				,; 
"Gestão de Projetos"					,; 
"Controle de Direitos Autorais"			,; 
"Automação de Coletas de Dados"			,; 
"PPAP"									,; 
"Réplica"								,; 
"Gestão Educacional"				   	,; 
"Easy Drawback Control"					,; 
"Gestão Hospitalar"						,; 
"Viewer"								,; 
"Avaliação e Pesquisa de Desempenho"	,; 
"Gestão de Prefeituras"					,; 
"Sistema de Fidelização e Análise de Crédit"	,; 
"Gestão Ambiental"						,; 
"Planejamento e Controle Orçamentário"	,; 
"Gerenciamento de Pesquisa e Resultado"	,; 
"Gestão de Acervos"						,; 
"HRP Estrutura Organizacional"			,; 
"HRP Gestão de Pessoal"					,; 
"HRP Ferramentas de Informação"			,; 
"HRP Planejamento e Desenvolvimento"	,; 
"Processos Trabalhistas"				,; 
"Gestão Avocatícia"						,; 
"Gestão de Riscos"						,; 
"Gestão Agricola"						,; 
"Gestão de Armazens Gerais"				,; 
"Gestão de Contratos"					,; 
"Arquitetua Organizacional"				,; 
"Locação de Veiculos"					,; 
"Photo"									,; 
"C.R.M."								,; 
"B.P.M."								,; 
"Apontamento/Ponto eletronico"			,; 
"Gestão Juridica"						,; 
"Pré-faturamento de seriço"				,; 
"Gestão de Frete Embarcador"			,; 
"Específicos"							,; 
"Específicos I"							,;
"Específicos II"						,;
"Configurador"}                           
                                           
DEFINE MSDIALOG oDlg TITLE "Relatório User x Menu." FROM 50,40 TO 170,350 OF oDlg PIXEL
@ 10,04 SAY OEMTOANSI("Este relatorio será 2xportado para o Excel diretamente.") SIZE 248,7 PIXEL OF oDlg
@ 25,04 COMBOBOX _cMenu ITEMS aModulo SIZE 100,8 PIXEL OF oDlg
@ 39,30 BMPBUTTON TYPE 01 ACTION ({If(!Empty(_cMenu),Processa({|| _ExpExcel()},Titulo),Nil)},{If(lProc,Close(oDlg),Nil)})
@ 39,60 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    ³_ExpExcel º Autor ³ AP6 IDE            º Data ³  24/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela VRFUSER.A funcao _ExpExcel    º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _ExpExcel(Titulo)

Local aUser:= AllUsers(.T.)
Local n := nPosB := nPosA := nPos := y :=  W := nHandle := nProc := 0
Local _cCabEx := IIf(_cMenu <> "","UserId;NomeId;Nome;E-Mail;Menu;Bloqueado;Departamento;Acessos","UserId;NomeId;Nome;E-Mail;Bloqueado;Departamento")
Local _cNomRel := ";Usuário do Módulo: "+_cMenu
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

FWrite(nHandle,_cCabEx) // Cabeçalho
FWrite(nHandle, CRLF)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PROCREGUA-> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			ToXlsFormat(IIF(aUser[n,1,17],"SIM","NÃO"))+";"+ ;
			ToXlsFormat(AllTrim(Str(aUser[n,1,15])))
			
			FWrite(nHandle, cBuffer)
			FWrite(nHandle, CRLF)
			
		Endif
	ElseIf _cMenu == aModulo[1] .Or. aUser[n,1,1] == "000000" //Somente os usuarios
		
		cBuffer := "'"+ToXlsFormat(aUser[n,1,1])+";"+ ;
		ToXlsFormat(aUser[n,1,2])+";"+ ;
		ToXlsFormat(aUser[n,1,4])+";"+ ;
		ToXlsFormat(AllTrim(aUser[n,1,14]))+";;"+ ;
		ToXlsFormat(IIF(aUser[n,1,17],"SIM","NÃO"))+";"+ ;
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
				ToXlsFormat(IIF(aUser[n,1,17],"SIM","NÃO"))+";"+ ;
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