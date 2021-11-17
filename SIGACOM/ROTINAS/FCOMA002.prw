//Bibliotecas
#include "Ap5Mail.ch"
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
#Include 'FWMVCDef.ch'
#include "vkey.ch"
#include "TOTVS.CH"
#include "TbiConn.ch"
#include 'FONT.CH'
#include 'COLORS.CH'
#include 'apvt100.ch'

#DEFINE ENTER CHR(13)+CHR(10)


/*/{Protheus.doc} FCOMA002
Programa responsavel por iniciar um processo no Fluig
//CHAMADO DO PE: WFW120P.PRW - aciona inclusão de pedido de compras no fluig

@author Francisco
@since 11/11/2016
@version 11.80
@param l_Flag, logical, controle de geracao do processo
@type function
/*/
User Function FCOMA002( l_Flag, c_GrpAprv )

	Local oServico						:= WSECMWorkflowEngineServiceService():New()
	Local cUsername						:= SuperGetMV("FS_FLGUSER",.F.,"bomix")
	Local cPassword						:= SuperGetMV("FS_FLGPASS",.F.,"bomix@2019")
	Local nCompanyId					:= 1
	Local cProcessId					:= "PedidoDeCompra"
	Local nChoosedState					:= 0
	Local cComments     				:= "PedidoDeCompra"
	Local cCuserId 						:= SuperGetMV("FS_FLGID",.F.,"bomix")
	Local lCompleteTask 				:= .T.
	Local processAttachmentDto  		:= ECMWorkflowEngineServiceService_processAttachmentDto():New()
	Local attach						:= ECMWorkflowEngineServiceService_attachment():New()
	Local oWSstartProcesscardData		:= ECMWorkflowEngineServiceService_STRINGARRAYARRAY():New()
	Local oWSstartProcessappointment	:= ECMWorkflowEngineServiceService_processTaskAppointmentDtoArray():New()
	Local LManagerMode					:= .F.
	Local CONT 							:= 1
	Local aprovador 					:= ""
	Local numScFluig 					:= ""
	Local justiFluig 					:= ""
	Local centroCusto 					:= ""
	Local nivel 						:= "01"
	Local c_ArqCotacao 					:= "cotacao_" + Alltrim ( SC7->C7_NUMCOT ) + ".html"
	Local c_ArqPedido 					:= "pedido_" + Alltrim( SC7->C7_NUM ) + ".html"
	Local o_Fluig 						:= clsFluig():New()
	Local c_Num							:= SC7->C7_NUM
	Local l_GeraFluig					:= .F.
	Local nTotReg						:= 0
	Local a_To		:= {}
	Local a_Usu		:= {}
	Local c_To		:= ""
	Local c_Subj	:= ""
	Local c_Anexo	:= {}
	Local c_Msg		:= ""
	Local c_Msg2	:= ""
	Local c_QrySCR := ""
	Local c_Solic := ""
	

		/*if !Altera .And. !l_Flag
			Return()
		endif*/
		
		If Findfunction("U_PCOMR001")
			U_PCOMR001( SC7->C7_NUMCOT, SC7->C7_NUMCOT, "\","\", .T., .T. )	//MAPA DE COTACAO
		Endif
		
		If Findfunction("U_PCOMR003")
			U_PCOMR003()
			//StartJob("U_PCOMR002",GetEnvServer(),.T.,1, "F")
			//U_PCOMR002(1, "F")
		Endif
	
		cCuserId := AllTrim(f_UsuFluig(usrretname(RetCodUsr())))
		
		//alert(cCuserId)
	
		/*f_UsuFluig( c_Num )
	
		nTotReg := Contar("QRYUSU","!Eof()")
		QRYUSU->(DbGoTop())
	
		IF nTotReg == 1
	
			While QRYUSU->(!EoF())
	
				IF AllTrim(QRYUSU->C1_FSUSRF) <> ""
					cCuserId := AllTrim(QRYUSU->C1_FSUSRF)
				ENDIF
	
				QRYUSU->(DbSkip())
			EndDo
	
		ENDIF
	
		QRYUSU->(DBCLOSEAREA())*/
	
		f_ScFluig( c_Num )
	
		While QRYSC->(!EoF())
	
			numScFluig += AllTrim(cvaltochar(QRYSC->C1_FSFLUIG)) +","
	
			QRYSC->(DbSkip())
	
		EndDo
		QRYSC->(DBCLOSEAREA())
		
		numScFluig := SUBSTR(numScFluig,1,LEN(numScFluig)-1)
		
		f_JustFluig( c_Num )
		c_Emerg	:=	""
		c_JEmerg:=	""
		
		While QRYJT->(!EoF())
	
			
	    	If SC1->(FieldPos("C1_FSJUS")) > 0
				justiFluig += QRYJT->C1_FSJUS +","
			Endif
		
			If SC1->(FieldPos("C1_FSTPEM")) > 0 .And. Empty(c_Emerg)
				c_Emerg += QRYJT->C1_FSTPEM
			Endif
			
			If SC1->(FieldPos("C1_URGENTE")) > 0 .And. Empty(c_JEmerg)
				c_JEmerg += Alltrim(QRYJT->C1_URGENTE)
				c_JEmerg := Iif(c_JEmerg=="0" .Or. Empty(c_JEmerg),"SEM EMERGENCIA"	,c_JEmerg)
				c_JEmerg := Iif(c_JEmerg=="1","MAQUINA PARADA"						,c_JEmerg)
				c_JEmerg := Iif(c_JEmerg=="2","SEGURANCA PATRIMONIAL"				,c_JEmerg)
				c_JEmerg := Iif(c_JEmerg=="3","GERENCIAMENTO DE CRISE"				,c_JEmerg)
				c_JEmerg := Iif(c_JEmerg=="4","SEGURANCA DO TRABALHO"				,c_JEmerg)
				c_JEmerg := Iif(c_JEmerg=="5","FOOD SAFETY"							,c_JEmerg)
				c_JEmerg := Iif(c_JEmerg=="6","INSUMOS/MATERIA-PRIMA"				,c_JEmerg) 
			Endif
	
	
			QRYJT->(DbSkip())
	
		EndDo
		QRYJT->(DBCLOSEAREA())
	
		justiFluig := SUBSTR(justiFluig,1,LEN(justiFluig)-1)
	
		IF numScFluig == ""
			SetAString(oServico:oWSstartProcesscardData, 	'hddIdentificador'	,	"Sem SC" )
		ELSE
			SetAString(oServico:oWSstartProcesscardData, 	'hddIdentificador'	,	numScFluig )
		ENDIF
		
		IF justiFluig == ""
			SetAString(oServico:oWSstartProcesscardData, 	'txtJustificativa'	,	"Sem SC" )
		ELSE
			SetAString(oServico:oWSstartProcesscardData, 	'txtJustificativa'	,	justiFluig )
		ENDIF
	
		If c_Emerg == ""
			SetAString(oServico:oWSstartProcesscardData, 	'txtEmergencial'	,	"Não" )
		Else
			SetAString(oServico:oWSstartProcesscardData, 	'txtEmergencial'	,	Iif(c_Emerg="S","Sim","Não") )
		Endif
	
		If c_JEmerg == ""
			SetAString(oServico:oWSstartProcesscardData, 	'txtJEmergencial'	,	"SEM EMERGENCIA" )
		Else
			SetAString(oServico:oWSstartProcesscardData, 	'txtJEmergencial'	,	c_JEmerg )
		Endif
	
		f_Query( c_Num, c_GrpAprv )
	
		While QRY->(!EoF())
		
				l_GeraFluig := .T.
		
				IF AllTrim(QRY->CR_STATUS) == "02"
					aprovador += usrretname(AllTrim(QRY->CR_USER)) +","
					SetAString(oServico:oWSstartProcesscardData, 	'nivel'	,	ALLTRIM( QRY->CR_NIVEL ) )
					aadd(oServico:oWSstartProcesscolleagueIds:cITEM, usrretname(AllTrim(QRY->CR_USER)))
				ENDIF
				
		
				IF CONT == 1
		
					SetAString( oServico:oWSstartProcesscardData, 	'txtNumPedido'     		,PADR( QRY->CR_NUM, TAMSX3("CR_NUM")[1]) )
					SetAString( oServico:oWSstartProcesscardData, 	'txtCodFornecedor'    	,AllTrim(QRY->C7_FORNECE))
					SetAString( oServico:oWSstartProcesscardData, 	'txtFornecedor' 		,AllTrim(QRY->A2_NREDUZ))
					SetAString( oServico:oWSstartProcesscardData, 	'txtCondPag' 			,AllTrim(QRY->E4_DESCRI))			
					SetAString( oServico:oWSstartProcesscardData, 	'txtValor'				,ALLTRIM( STR( QRY->CR_TOTAL ) ) )
					//SetAString( oServico:oWSstartProcesscardData, 	'txtValorTotal'			,ALLTRIM( STR( QRY->??? ) ) )
					SetAString( oServico:oWSstartProcesscardData, 	'txtFormatado'			,"0")
					//SetAString( oServico:oWSstartProcesscardData, 	'txtTotalFormatado'		,"0")
					SetAString( oServico:oWSstartProcesscardData, 	'hddFilial'				,ALLTRIM( QRY->C7_FILIAL ) )
					SetAString( oServico:oWSstartProcesscardData, 	'maxNivel'				,ALLTRIM( QRY->MAXNIVEL ))
					SetAString( oServico:oWSstartProcesscardData, 	'hddTipo'				,ALLTRIM( QRY->CR_TIPO ) )
		
				ENDIF
		
				IF !(AllTrim(QRY->C7_CC) $ centroCusto)
					centroCusto += AllTrim(QRY->C7_CC) +","
				ENDIF
		
				SetAString( oServico:oWSstartProcesscardData, 	'AL_COD___' +ALLTRIM( STR( CONT ) )		,	AllTrim(QRY->AL_COD))
				SetAString( oServico:oWSstartProcesscardData, 	'AL_NOME___'+ALLTRIM( STR( CONT ) )		,	f_UserFluig(usrretname(AllTrim(QRY->CR_USER))))
				SetAString( oServico:oWSstartProcesscardData, 	'AL_TPLIBER___'+ALLTRIM( STR( CONT ) )	,	AllTrim(QRY->AL_TPLIBER))
				SetAString( oServico:oWSstartProcesscardData, 	'CR_APROV___'+ALLTRIM( STR( CONT ) )	,	AllTrim(QRY->CR_APROV))
				SetAString( oServico:oWSstartProcesscardData, 	'CR_USER___'+ALLTRIM( STR( CONT ) )		,	AllTrim(QRY->CR_USER))
				SetAString( oServico:oWSstartProcesscardData, 	'CR_NIVEL___'+ALLTRIM( STR( CONT ) )	,	AllTrim(QRY->CR_NIVEL))
				SetAString( oServico:oWSstartProcesscardData, 	'CR_STATUS___'+ALLTRIM( STR( CONT ) )	,	AllTrim(QRY->CR_STATUS))
				SetAString( oServico:oWSstartProcesscardData, 	'CR_NUM___'+ALLTRIM( STR( CONT ) )		,	PADR( QRY->CR_NUM, TAMSX3("CR_NUM")[1] ) )
				SetAString( oServico:oWSstartProcesscardData, 	'CR_TOTAL___'+ALLTRIM( STR( CONT ) )	,	ALLTRIM( STR( QRY->CR_TOTAL ) ) )
				SetAString( oServico:oWSstartProcesscardData, 	'C7_APROV___'+ALLTRIM( STR( CONT ) )	,	AllTrim(QRY->CR_APROV))
		
				CONT++

	
			QRY->(DbSkip())
	
		EndDo
		
		QRY->(DBCLOSEAREA())

		If !l_GeraFluig
			Return(.T.)
		EndIf
	
		aprovador := ALLTRIM(aprovador)
	
		SetAString(oServico:oWSstartProcesscardData, 	'hddCentroCusto',	SUBSTR(centroCusto,1,LEN(centroCusto)-1))
		SetAString(oServico:oWSstartProcesscardData, 	'aprovador'	,	SUBSTR(aprovador,1,LEN(aprovador)-1))
		//SetAString(oServico:oWSstartProcesscardData, 	'aprovador'	,	'eletrodata')
		//SetAString(oServico:oWSstartProcesscardData, 	'nivel'	,	"01")
	
		processAttachmentDto:ndocumentId               	:= 0
		processAttachmentDto:nversion                  	:= 1000
		processAttachmentDto:noriginalMovementSequence	:= 1
		processAttachmentDto:ncompanyId                	:= 1
		processAttachmentDto:ccolleagueId              	:= AllTrim(cCuserId)//SuperGetMV("FS_FLGID",.F.,"bomix")//"eletrodata"
		processAttachmentDto:cdescription              	:= c_ArqCotacao
		processAttachmentDto:cfileName                 	:= c_ArqCotacao
		processAttachmentDto:ldeleted                  	:= .F.
		processAttachmentDto:cpermission               	:= "1"
		processAttachmentDto:lnewAttach                	:= .T.
	
		if file('\system\'+c_ArqCotacao)
	
			attach:lattach		:= .T.
			attach:cfileName	:= c_ArqCotacao
			attach:lprincipal	:= .T.
			attach:cfilecontent	:= o_Fluig:mtdArrayToByte('\system\'+c_ArqCotacao)
	
			aadd(processAttachmentDto:oWSattachments, attach)
			aadd(oServico:oWSstartProcessattachments:oWSitem, processAttachmentDto)
	
			processAttachmentDto	:= ECMWorkflowEngineServiceService_processAttachmentDto():New()
			attach					:= ECMWorkflowEngineServiceService_attachment():New()
	
		endif
	
		processAttachmentDto:ndocumentId               := 0
		processAttachmentDto:nversion                  := 1000
		processAttachmentDto:noriginalMovementSequence := 1
		processAttachmentDto:ncompanyId                := 1
		processAttachmentDto:ccolleagueId              := AllTrim(cCuserId)//SuperGetMV("FS_FLGID",.F.,"bomix")//"eletrodata"
		processAttachmentDto:cdescription              := c_ArqPedido
		processAttachmentDto:cfileName                 := c_ArqPedido
		processAttachmentDto:ldeleted                  := .F.
		processAttachmentDto:cpermission               := "1"
		processAttachmentDto:lnewAttach                := .T.
	
		if file('\system\'+c_ArqPedido)
	
			attach:lattach                   := .T.
			attach:cfileName                 := c_ArqPedido
			attach:lprincipal                := .T.
			attach:cfilecontent              := o_Fluig:mtdArrayToByte('\system\'+c_ArqPedido)
	
			aadd(processAttachmentDto:oWSattachments, attach)
			aadd(oServico:oWSstartProcessattachments:oWSitem, processAttachmentDto)
	
		endif
	
		if oServico:startProcess(cUsername,cPassword,nCompanyId,cProcessId,nChoosedState,oServico:oWSstartProcesscolleagueIds,cComments,cCuserId,lCompleteTask,oServico:oWSstartProcessattachments,oServico:oWSstartProcesscardData,oWSstartProcessappointment,LManagerMode)
	
			if oServico:oWSstartProcessresult:OWSITEM[1]:citem[1] <> "ERROR"
	
				f_QryDBM( c_Num, c_GrpAprv )
	
				While QRYDBM->(!EoF())
				
				
					DBSELECTAREA("SC7")
					DBSETORDER(1)
					DBSEEK( XFILIAL("SC7") + c_Num )
					WHILE SC7->(!EOF()) .AND. SC7->C7_FILIAL + SC7->C7_NUM == XFILIAL("SC7") + c_Num 
						If SC7->(FieldPos("C7_FSFLUIG"))>0
						
						if QRYDBM->DBM_ITEM == SC7->C7_ITEM
							n_FSFluig	:=	oServico:oWSstartProcessresult:OWSITEM[6]:citem[2]
							n_FSFluig	:=	Iif(valtype(n_FSFluig) = "N", n_FSFluig, Val(n_FSFluig))
							c_Solic		:= 	SC7->C7_NUMSC
									
							RECLOCK("SC7", .F.)
							SC7->C7_FSFLUIG	:= n_FSFluig 
							MSUNLOCK()
									
									
							c_Msg2 += '  <tr>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SM0->M0_FILIAL+'</font></td>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_PRODUTO+'</font></td>'
							c_Msg2 += '  	<td align="center" width="40%"><font face="Arial" size="2">'+SC7->C7_DESCRI+'</font></td>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+TRANSFORM(SC7->C7_QUANT,"@e 999,999,999.99")+'</font></td>'
							c_Msg2 += '  	<td align="center" width="10%"><font face="Arial" size="2">'+SC7->C7_CC+'</font></td>'
							c_Msg2 += '  </tr>'
							
						Endif
											
						SC7->(DBSKIP())
						
						Endif
					ENDDO
				
				QRYDBM->(DbSkip())		
				
				EndDo
				QRYDBM->(DBCLOSEAREA())
				
				c_Subj	:= "Pedido de Compra "+c_Num+" gerado."
									
				c_Msg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">''
				c_Msg += '<html xmlns="http://www.w3.org/1999/xhtml">'
				c_Msg += '<head>'
				c_Msg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
				c_Msg += '<title>LiberaÃ§Ã£o de SC</title>'
				c_Msg += '</head>'
				c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
				c_Msg += '  <tr>'
				c_Msg += '  	<td align="center" width="100%"><font face="Tahoma" size="2">Pedido de Compra aprovado</font></td>'
				c_Msg += '  </tr>'
				c_Msg += '</table>'
				c_Msg += '<br>'
				c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="0">'
				c_Msg += '  <tr>'
				c_Msg += '  	<td align="left" width="100%">'
				c_Msg += '    	<font face="Arial", Helvetica, sans-serif" size="2">'
				c_Msg += '    		<p>Prezado Usuário seu pedido NR. '+Alltrim(c_Num)+' já foi gerado e agora está aguardando aprovação da Diretoria.</p>'
				c_Msg += '		</font>'
				c_Msg += ' 	</td>'
				c_Msg += '  </tr>'
				c_Msg += '</table>'
				//Itens
				c_Msg += '<table cellpadding="0" cellspacing="0" width="800" border="1">'
				c_Msg += '  <tr>'
				c_Msg += '  	<td align="center" width="10%">Filial</td>'
				c_Msg += '  	<td align="center" width="10%">Produto</td>'
				c_Msg += '  	<td align="center" width="60%">Descrição</td>'
				c_Msg += '  	<td align="center" width="10%">Qtd</td>'
				c_Msg += '  	<td align="center" width="10%">CC</td>'
				c_Msg += '  </tr>'
				
				
				Conout("c_Docto 1 =>"+c_Num)
				
				DBSELECTAREA("SC1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SC1")+ Padr( c_Solic, TamSX3("C1_NUM")[1] ))
				IF FOUND()
				
				Conout("Entrou 1 =>")
				
					a_To		:= {}
					a_Usu		:= {}
				
					PswOrder(1)
					PswSeek(SC1->C1_USER, .T.)
					a_Usu	:= PswRet(1)
				
					If Ascan(a_To,Alltrim(a_Usu[1][14]))==0
						AADD(a_To,Alltrim(a_Usu[1][14]))
					ENDIF
					
					Conout("c_Docto 1 =>"+SC1->C1_USER)
					
					If Empty(c_To)
						c_To := a_To[1] //EMAIL DO SOLICITANTE
					Else
						c_To += ";"+a_To[1] //EMAIL DO SOLICITANTE
					EndIf
				
				ENDIF
				
				c_Msg += c_Msg2
				
				
				c_Msg += '  </tr>'
				c_Msg += '</table>'
				c_Msg += '<body>'
				c_Msg += '</body>'
				c_Msg += '</html>'
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Chama a função que envia email:                                 ³
				//³                                                                ³
				//³1º Parâmetro: Para                                              ³
				//³2º Parâmetro: Corpo do Email                                    ³
				//³3º Parâmetro: Assunto                                           ³
				//³4º Parâmetro: Se exibe a tela informando que o email foi enviado³
				//³5º Parâmetro: Anexo                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				U_TBSENDMAIL(c_To, c_Msg, c_Subj, .F., c_Anexo)			
	
				alert("A solicitação de Pedido de Compra número: "+ oServico:oWSstartProcessresult:OWSITEM[6]:citem[2]+" foi iniciada no Fluig!")
	
			else
	
				alert("Falha no Fluig ->"+ oServico:oWSstartProcessresult:OWSITEM[1]:citem[2])
	
			endif
		else
	
			alert("Erro de Execução ->"+GetWSCError())
	
		endif
	
		FERASE('\system\'+c_ArqPedido)
		FERASE('\system\'+c_ArqCotacao)
	

RETURN (.T.)

Static Function f_Query( c_Num , c_GrpAprv)

	Local c_Qry := ""
	
	c_Qry += " SELECT DISTINCT AL_COD, AK_NOME AL_NOME, AL_TPLIBER, CR_APROV, CR_USER,CR_NIVEL, CR_STATUS, CR_NUM, CR_TOTAL, C7_APROV, C7_FORNECE, A2_NREDUZ, '' C7_CC, C7_FILIAL " +CHR(13)+CHR(10)
	c_Qry += " ,(SELECT MAX(CR_NIVEL) FROM "+RETSQLNAME("SC7")+ " C7 INNER JOIN "+RETSQLNAME("SCR")+ " CR ON CR.CR_FILIAL = C7.C7_FILIAL AND CR.CR_NUM = C7.C7_NUM AND CR.D_E_L_E_T_ <> '*'   WHERE C7.D_E_L_E_T_ <> '*'  AND SC7.C7_FILIAL	= '"+xFilial("SC7")+"' AND C7.C7_NUM = '" + c_Num + "') MAXNIVEL " +CHR(13)+CHR(10)
	c_Qry += " ,E4_DESCRI " +CHR(13)+CHR(10)
	c_Qry += " ,CR_TIPO " +CHR(13)+CHR(10)
	c_Qry += " FROM "+RETSQLNAME("SC7")+ " SC7 " +CHR(13)+CHR(10)
	c_Qry += " INNER JOIN "+RETSQLNAME("SCR")+ " SCR ON SCR.CR_FILIAL = SC7.C7_FILIAL AND SCR.CR_NUM = SC7.C7_NUM AND SCR.D_E_L_E_T_ <> '*'  " +CHR(13)+CHR(10)
	c_Qry += " INNER JOIN "+RETSQLNAME("SAL")+ " SAL ON SAL.AL_FILIAL = SC7.C7_FILIAL AND SAL.AL_APROV = SCR.CR_APROV AND SAL.AL_USER = SCR.CR_USER	AND AL_COD = CR_GRUPO AND SAL.D_E_L_E_T_ <> '*'  " +CHR(13)+CHR(10)
	c_Qry += " INNER JOIN "+RETSQLNAME("SA2")+ " SA2 ON SA2.A2_FILIAL = SUBSTRING(SC7.C7_FILIAL,1,4)	AND SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA AND SA2.D_E_L_E_T_ <> '*'  " +CHR(13)+CHR(10)
	c_Qry += " INNER JOIN "+RETSQLNAME("SAK")+ " SAK ON SAK.AK_FILIAL = SAL.AL_FILIAL AND SAK.AK_USER = SAL.AL_USER AND SAK.AK_COD = SAL.AL_APROV AND SAK.D_E_L_E_T_ <> '*'  " +CHR(13)+CHR(10)
	c_Qry += " INNER JOIN "+RETSQLNAME("SE4")+ " SE4 ON SE4.E4_FILIAL = SC7.C7_FILIAL AND SE4.E4_CODIGO = SC7.C7_COND AND SE4.D_E_L_E_T_ <> '*'  " +CHR(13)+CHR(10)
	c_Qry += " WHERE SC7.D_E_L_E_T_ = '' " +CHR(13)+CHR(10)
	c_Qry += " AND SC7.C7_FILIAL	= '"+xFilial("SC7")+"' " +CHR(13)+CHR(10)
	c_Qry += " AND SC7.C7_NUM = '" + c_Num + "' " +CHR(13)+CHR(10)
	c_Qry += " AND SAL.AL_COD = '" + c_GrpAprv + "' " +CHR(13)+CHR(10)
	c_Qry += " ORDER BY CR_NIVEL  " +CHR(13)+CHR(10)

	TCQUERY c_Qry NEW ALIAS "QRY"

Return()

/*Static Function f_UsuFluig( c_Num )

	Local c_Qry := ""

	c_Qry += " SELECT C1_FSUSRF FROM "+RETSQLNAME("SC1")+ " C1 WHERE C1.D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_PEDIDO = '" + c_Num + "' GROUP BY C1_FSUSRF " +CHR(13)+CHR(10)

	TCQUERY c_Qry NEW ALIAS "QRYUSU"

Return()*/

Static Function f_UsuFluig( c_Chave )

	Local c_UsrFluig	:=	SuperGetMV("FS_FLGID",.F.,"bomix")
	Local c_Qry			:=	""
	Local c_AliasFl		:=	GetNextAlias()

	Default c_Chave		:=	""
	
	c_Qry	:=	"SELECT USER_CODE FROM fluigdb.dbo.FDN_USERTENANT WHERE LOGIN = '"+c_Chave+"'"
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_AliasFl, .T., .T.)
	(c_AliasFl)->(dbGoTop())
	If (c_AliasFl)->(!Eof())
		c_UsrFluig := (c_AliasFl)->USER_CODE 
	Endif
	(c_AliasFl)->(dbCloseArea())

Return(c_UsrFluig)


Static Function f_ScFluig( c_Num )

	Local c_Qry := ""

    c_Qry += " SELECT C1_FSFLUIG FROM "+RETSQLNAME("SC1")+ " C1 WHERE C1.D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_PEDIDO = '" + c_Num + "' GROUP BY C1_FSFLUIG " +CHR(13)+CHR(10)

	TCQUERY c_Qry NEW ALIAS "QRYSC"

Return()

Static Function f_QryDBM( c_Num, c_GrpAprv )

	Local c_Qry := ""

    c_Qry += " SELECT DISTINCT DBM_ITEM FROM "+RETSQLNAME("DBM")+ " DBM WHERE DBM_NUM = '" + c_Num + "'  AND DBM_FILIAL = '"+xFilial("DBM")+"' AND DBM_GRUPO = '" + c_GrpAprv + "' AND DBM.D_E_L_E_T_ <> '*' " +CHR(13)+CHR(10)
	
	TCQUERY c_Qry NEW ALIAS "QRYDBM"

Return()


Static Function f_JustFluig( c_Num )

	Local c_Qry := ""

    //c_Qry += " SELECT C1_FSJUS, C1_ FROM "+RETSQLNAME("SC1")+ " C1 WHERE C1.D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_PEDIDO = '" + c_Num + "'  GROUP BY C1_FSJUS " +CHR(13)+CHR(10)

    	If SC1->(FieldPos("C1_FSJUS")) > 0
			c_Qry += " C1_FSJUS " +CHR(13)+CHR(10)
		Endif
	
		If SC1->(FieldPos("C1_FSTPEM")) > 0
			c_Qry += " ,MAX(C1_FSTPEM) AS C1_FSTPEM  " +CHR(13)+CHR(10)
		Endif
		
		If SC1->(FieldPos("C1_FSCDEM")) > 0
			c_Qry += " ,MAX(C1_FSCDEM) AS C1_FSCDEM " +CHR(13)+CHR(10)
		Endif
		
		If SC1->(FieldPos("C1_URGENTE")) > 0
			c_Qry += " ,MAX(C1_URGENTE) AS C1_URGENTE " +CHR(13)+CHR(10)
		Endif

		If !Empty(c_Qry)
			c_Qry	:= "SELECT TOP 1 "  +CHR(13)+CHR(10) + c_Qry
			c_Qry	+= " FROM "+RETSQLNAME("SC1")+ " C1  WHERE C1.D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_PEDIDO = '" + c_Num + "' " +CHR(13)+CHR(10)
			c_Qry	+= " GROUP BY C1_FSJUS " +CHR(13)+CHR(10)
			
			TCQUERY c_Qry NEW ALIAS "QRYJT"
		Endif
	

Return()

//==============================
//funcao auxiliar
//==============================
//adiciona dados a matriz do objeto enviado ao fluig
//==============================
Static Function SetAString(aTMP1, cCampo, cValor)

	aTMP2 := ECMWorkflowEngineServiceService_STRINGARRAY():New()
	aadd(aTMP2:cITEM, cCampo)
	aadd(aTMP2:cITEM, cValor)
	aadd(aTMP1:OWSITEM, aTMP2)

Return nil

/*/{Protheus.doc} f_UserFluig
//Coleta matricula no fluig
@author carlo
@since 30/10/2019
@version 1.0
@return ${return}, ${return_description}
@param c_Chave, characters, descricao
@type function
/*/
Static Function f_UserFluig(c_Chave)
Local c_UsrFluig	:=	""
Local c_Qry			:=	""
Local c_AliasFl		:=	GetNextAlias()

Default c_Chave		:=	""

If !Empty(c_Chave)

	c_Qry	:=	"SELECT USER_CODE FROM fluigdb.dbo.FDN_USERTENANT WHERE LOGIN = '"+c_Chave+"'"
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_AliasFl, .T., .T.)
	(c_AliasFl)->(dbGoTop())
	If (c_AliasFl)->(!Eof())
		c_UsrFluig := (c_AliasFl)->USER_CODE 
	Endif
	(c_AliasFl)->(dbCloseArea())
Else
	msgInfo("Matricula nao cadastrada no fluig para o usuario "+c_Chave)

Endif	

Return(c_UsrFluig)


//-- SC7.C7_APROV	AND SAL.AL_APROV = SCR.CR_APROV AND