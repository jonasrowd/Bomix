#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} FFATG003
Gatilho no campo CJ_CLIENTE, para validação das retrições financeiras dos clientes na inclução dos orçamentos
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_FFATG003()
/*/

user function FFATG003()
Local lRet := .T.
Local c_Ret := ""
Local _CALIAS    :=GETAREA()
//Local c_UserLib := GETMV("BM_USERLIB")
	
 If  FunName()=="MATA415"
		nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
		cNome := SA1->A1_NOME
		
		If nAtrasados <> 0 
			ShowHelpDlg(SM0->M0_NOME,;
			{"O Cliente " + AllTrim(cNome)  + " orçamento "+M->CJ_NUM+", possui restrições financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
			{"Caso queira concluir a liberação deste pedido, solicite a liberação dos responsáveis."},5) 
			
			lRet := .T.
			c_Ret := 'B'
		EndIf
		
			
Endif 

   RESTAREA(_CALIAS)
   	
return c_Ret

