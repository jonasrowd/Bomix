#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} FFATG003
Gatilho no campo CJ_CLIENTE, para valida��o das retri��es financeiras dos clientes na inclu��o dos or�amentos
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
			{"O Cliente " + AllTrim(cNome)  + " or�amento "+M->CJ_NUM+", possui restri��es financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
			{"Caso queira concluir a libera��o deste pedido, solicite a libera��o dos respons�veis."},5) 
			
			lRet := .T.
			c_Ret := 'B'
		EndIf
		
			
Endif 

   RESTAREA(_CALIAS)
   	
return c_Ret

