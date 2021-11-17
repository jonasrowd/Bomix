#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'SHELL.CH'

#DEFINE ENTER CHR(13) + CHR(10)

User Function FCOMA007(c_Origem)

Local c_Link	:=	""
Local c_Id		:=	""
Local c_Mens	:=	"Fonte: "+Iif( len(AllTrim(Procname())) > 3 ,SubStr(Procname(),3,len(AllTrim(Procname()))), "" )+ENTER+ENTER	
Local c_Titulo	:=	"Link no Fluig não pode ser acionado"

Default c_Origem = ""

If c_Origem = "PC"

	If SC7->(FieldPos("C7_FSFLUIG")) > 0
		c_Id := Iif(Valtype(SC7->C7_FSFLUIG)=="N",Alltrim(Str(SC7->C7_FSFLUIG)),Iif(Valtype(SC7->C7_FSFLUIG)=="C",Alltrim(SC7->C7_FSFLUIG),""))
		If !Empty(c_Id) 
			c_Link	+=	SUPERGETMV("FS_LNKPC",.F.,"http://192.168.254.65:8081/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID=")			
			c_Link	+=	c_Id 	
			ShellExecute("open",c_Link,"","",SW_SHOWMAXIMIZED)
		Else
			If Empty(c_Id)
				c_Mens	+=	"O Pedido número "+SC7->C7_NUM+" está sem id fluig, "+ENTER
				c_Mens	+=	"por favor realize alteração do mesmo para gerar novo Id."+ENTER
				c_Mens	+=	"Lembramos que essa operação de alteraçao irá reiniciar o"+ENTER
				c_Mens	+=	"fluxo de aprovação do pedido no fluig."+ENTER+ENTER
			Endif
			
			msgInfo(c_Mens,c_Titulo)
			
		Endif	

	Else
		msgInfo("Campo C7_FSFLUIG não existe na tabela de pedidos de compras(SC7) !")

	Endif
	
ElseIf c_Origem = "SC"
	If SC1->(FieldPos("C1_FSFLUIG")) > 0
		c_Id := Iif(Valtype(SC1->C1_FSFLUIG)=="N",Alltrim(Str(SC1->C1_FSFLUIG)),Iif(Valtype(SC1->C1_FSFLUIG)=="C",Alltrim(SC1->C1_FSFLUIG),""))
		If !Empty(c_Id) 
			c_Link	+=	SUPERGETMV("FS_LNKSC",.F.,"http://192.168.254.65:8081/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID=")			
			c_Link	+=	c_Id 	
			ShellExecute("open",c_Link,"","",SW_SHOWMAXIMIZED)
		Else
			If Empty(c_Id)
				c_Mens	+=	"A Sol.compras número "+SC1->C1_NUM+" está sem id fluig. "+ENTER
			Endif
			
			msgInfo(c_Mens,c_Titulo)
			
		Endif	

	Else
		msgInfo("Campo C1_FSFLUIG não existe na tabela de solicitação de compras(SC1) !")

	Endif

ElseIf c_Origem = "SA"
	If SCP->(FieldPos("CP_FSFLUIG")) > 0
		c_Id := Iif(Valtype(SCP->CP_FSFLUIG)=="N",Alltrim(Str(SCP->CP_FSFLUIG)),Iif(Valtype(SCP->CP_FSFLUIG)=="C",Alltrim(SCP->CP_FSFLUIG),""))
		If !Empty(c_Id) 
			c_Link	+=	SUPERGETMV("FS_LNKSA",.F.,"http://192.168.254.65:8081/portal/p/1/pageworkflowview?app_ecm_workflowview_detailsProcessInstanceID=")			
			c_Link	+=	c_Id 	
			ShellExecute("open",c_Link,"","",SW_SHOWMAXIMIZED)
		Else
			If Empty(c_Id)
				c_Mens	+=	"A Sol.Armazém número "+SCP->CP_NUM+" está sem id fluig. "+ENTER
			Endif
			
			msgInfo(c_Mens,c_Titulo)
			
		Endif	

	Else
		msgInfo("Campo CP_FSFLUIG não existe na tabela de solicitação ao armazém(SCP) !")

	Endif

Else

Endif

Return

