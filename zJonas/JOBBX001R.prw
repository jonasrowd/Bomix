#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "BGAS_LIB.CH"   
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJ_PROGRAMACAO		tor  TBA001 -XXX     บ Data ณ  21/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSistema de sigma x progama็ใo (Job)						  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAPCP - Scheduler                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function J_AUDIT_RECEBER

If Select("SX6") == 0
	Conout("Inicio  : "+Time())
	Conout(OemToAnsi("JOB - Sistema de SIGMA - PROGAMAวรO") )
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SH9"
EndIf

cAmbiente := GetEnvServer()

// Valida o horแrio de execu็ใo do schedule
Private lExecuta    := .T. //iif(Left(Time(),5)>="02:30".And.Left(Time(),5)<="03:00",.T.,.F.)
private c_server   	:= alltrim(GetMv("MV_WFSMTP"))
private c_account  	:= alltrim(GetMv("MV_WFACC"))
private c_password 	:= alltrim(GetMv("MV_WFPASSW"))
private c_body		:= ""
private l_enviado 	:= .F.
private l_conectou 	:= .F.
private c_destino  	:= ""
private c_erro1		:= ""
private c_erro2		:= ""
private c_data		:= ""
Private cAcao		:= ""
Private lCobrado	:= .F.
Private cIncons 	:= "" 	
Private cTextIncons	:= "" 
Private cObserv 	:= ""
Private aParadasProg    := {}



cQuery  := " "
cQuery  += " SELECT * FROM BMX_CS_Progamacao_Parada_Sigma "
	
If Select("QRY") <> 0
	DBSelectArea("QRY")
	DBCLOSEAREA("QRY")
Endif 

TCQUERY cQuery New Alias "QRY"

dbselectarea("QRY")
QRY->(dbgotop())
while QRY->(!eof())  
    DbSelectArea("SH9")                 
	RecLock("SH9",.T.)       
			SH9->H9_FILIAL := xFilial("SH9")
			SH9->H9_RECURSO:= QRY->MAQUINA_FK
			SH9->H9_CCUSTO := QRY->CENTRO_DE_CUSTO_FK
			SH9->H9_MOTIVO := QRY->MOTIVO
			SH9->H9_DTINI  := QRY->DATA_INICIO
			SH9->H9_DTFIM  := QRY->HORA_INICIO
			SH9->H9_HRINI  := QRY->DATA_TERMINO
			SH9->H9_HRFIM  := QRY->HORA_TERMINO
	MsUnlock() 	
    
    AADD(aParadasProg,{QRY->MAQUINA_FK ,QRY->CENTRO_DE_CUSTO_FK ,QRY->MOTIVO ,QRY->DATA_INICIO  ,QRY->HORA_INICIO  ,QRY->DATA_TERMINO  ,QRY->HORA_TERMINO, QRY->SETOR_FK})    
    
	QRY->(dbskip())
enddo
DBCLOSEAREA("QRY") 

c_Upd  += " UPDATE Sigma_Teste.dbo.OS SET INTEGRADO_TOTVS = 'S' WHERE OS_CODIGO = "+QRY->CODIGO_PK+"  "

If TcSqlExec(c_Upd) < 0
	MsgStop("SQL Error: " + TcSqlError())
	TcSqlExec("ROLLBACK")
Else
	TcSqlExec("COMMIT")	
Endif

If len(aParadasProg) > 0
  	CONNECT SMTP SERVER c_server ACCOUNT c_account PASSWORD c_password RESULT l_conectou
	if l_conectou
		c_body 	  := f_BODY(aParadasProg)
	 	c_destino := "bacoetrom@gmail.com"
	   	SEND MAIL FROM c_account TO c_destino SUBJECT "ATENวรO - PROGAMAวรO - Paradas de Recurso(s)" BODY c_body RESULT l_enviado
			if !l_enviado
			  	GET MAIL ERROR c_erro1
		  		Memowrite("c:\protheus_data\___consultores\__TBA001\erro_envio.txt",alltrim(c_erro1))
			endif
		DISCONNECT SMTP SERVER
	else
  		  	GET MAIL ERROR c_erro2
		Memowrite("c:\protheus_data\___consultores\__TBA001\erro_envio.txt",alltrim(c_erro2))
  	endif
Endif	

//FINALIZA A CONEXAO

If Select("SX6") == 0
	Conout(OemToAnsi("Job Sistema de SIGMA/PARADAS executado!")  )	
	RESET ENVIRONMENT
Else 
	MsgBox(OemtoAnsi("Job Sistema de SIGMA/PARADAS executado!") ,OemToAnsi("Aten็ใo"), OemToAnsi("Informa็ใo"))
Endif

BGAJUSALDO()

Return            
/*
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Montagem do corpo do e-mail 										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
Static Function f_BODY(aParadasProg)

Local  cBody:= ""


cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cBody += '<html xmlns="http://www.w3.org/1999/xhtml"> '
cBody += '<head>'
cBody += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
cBody += '<title>Documento sem tรญtulo</title> '
cBody += '<style type="text/css">'
cBody += '.header {'
cBody += '	font-size: 15px;'
cBody += '	text-align: center;'
cBody += '	font-weight: bold;'
cBody += '	background-color:#CBF2FE;'
cBody += '}'
cBody += '.header2 {'
cBody += '	font-size: 13px;'
cBody += '	text-align: center;'
cBody += '	font-weight: bold;'
cBody += '	background-color:#E8FAFF;'
cBody += '}'
cBody += '.itens_texto {'
cBody += '	font-size: 12px;'
cBody += '	text-align: center;'
cBody += '}'
cBody += '.itens_numero {'
cBody += '	font-size: 12px;'
cBody += '	text-align: right;'
cBody += '}' 
cBody += '.itens_texto2 {'
cBody += '	font-size: 12px;'
cBody += '	text-align: center;'
cBody += '	background-color:#E8FAFF;'
cBody += '}'
cBody += '.itens_numero2 {'
cBody += '	font-size: 12px;'
cBody += '	text-align: right;'
cBody += '	background-color:#E8FAFF;'
cBody += '}'
cBody += '</style>'
cBody += '</head>'
cBody += ''
cBody += '<body>'
cBody += '<table cellspacing="0" cellpadding="0" id="table44" style="width: 720px" class="style3">'
cBody += '	<tr>'
cBody += '		<td valign="top" class="style1">'
cBody += '		<table>'
cBody += '			<tr>'
cBody += '				<td>'
cBody += '				<p class="MsoNormal" align="center" style="margin-bottom:0cm;margin-bottom:.0001pt;'
cBody += 'text-align:center;line-height:normal"><b><i>'
cBody += '				<span style="font-size:22.0pt;'
cBody += 'font-family:&quot;Arial&quot;,&quot;sans-serif&quot;">
cBody += '				<div align="center"><img src="logobomix.png"/>'
cBody += ' </div></span></i></b><span style="font-family:&quot;Arial&quot;,&quot;sans-serif&quot;"><br />'
cBody += '				</p>'
cBody += '				</td>'
cBody += '			</tr>'
cBody += '		</table>'
cBody += '		</td>'
cBody += '	</tr>'
cBody += '</table>'
cBody += '<br>'
cBody += '<table style="width: 720px; font-weight: bold;" cellpadding="5" class="style9" cellspacing="0">'
cBody += '	<tr>'
cBody += '		<td class="rat">INFORMAวีES DAS PARADAS PROGAMADAS</td>
cBody += '		'
cBody += '	</tr>'
cBody += '</table>'
cBody += '<br>'
cBody += '<table cellspacing="0" id="table45" style="width: 720px; height: 30px;" class="style3" cellpadding="0">'
cBody += '	<tr>'
cBody += '		<td class="aviso">ATENวรOO: POR FAVOR, NรO RESPONDA ESTE E-MAIL. <br />'
cBody += '		Este e-mail foi enviado por uma caixa postal automแtica. <br />		'
cBody += '		D๚vidas e comentแrios, favor entrar em contato com a TI<br />
cBody += '		analista.sistemas@bomix.com.br.</td>'
cBody += '	</tr>'
cBody += '</table>'
cBody += '<br>'
cBody += '<table width="200" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000">'
cBody += '  <tr>'
cBody += '    <td colspan="3"  class="header">Infor. dos Recursos</td>
cBody += '    '
cBody += '    <td colspan="9" class="header"> Dados da Ordem de Sevi็o</td>
cBody += '    '
cBody += '  </tr>'
cBody += '  <tr>'
cBody += '    <td class="header2">Recurso</td>
cBody += '    '
cBody += '    <td class="header2">Centro de Custo</td>
cBody += '    '
cBody += '    <td class="header2">Setor</td>
cBody += '    '
cBody += '    <td class="header2">O.S.</td>
cBody += '    '
cBody += '    <td class="header2">Programa็ใo</td>
cBody += '    '
cBody += '    <td class="header2">Data de Inicํo</td>
cBody += '    '
cBody += '    <td class="header2">Hora de Inicํo</td>
cBody += '    '
cBody += '    <td class="header2">Data Termino</td>
cBody += '    '
cBody += '    <td class="header2">Hora Termino</td>
cBody += '    '
cBody += '    <td class="header2">Motivo</td>
cBody += '    '
cBody += '  </tr>'

//  AADD(aParadasProg,{QRY->MAQUINA_FK ,QRY->CENTRO_DE_CUSTO_FK , QRY->SETOR_FK, QRY->CODIGO_PK, QRY->PROGAMACAO_PK ,QRY->DATA_INICIO  ,QRY->HORA_INICIO  ,QRY->DATA_TERMINO  ,QRY->HORA_TERMINO, QRY->MOTIVO})    

For i:=1 to len(aParadasProg)   
	cBody += '	  <tr>'
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][1]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][2]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][3]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][4]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][5]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][6]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][7]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][8]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][9]+'</td> '   
	cBody += '  	<td class="'+cCssTexto+'">'+aParadasProg[i][10]+'</td> '   
	cBody += '	</tr>
next    

cBody += '</table> ' 
cBody += '</html>  '
cBody += '</body>  '


Return   cBody     