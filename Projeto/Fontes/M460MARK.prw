#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} M460MARK
Ponto de Entrada para validação das retrições financeiras dos clientes na preparação do documento de saída
@author Elmer Farias
@since 04/01/21
@version 1.0
	@example
	u_M460MARK()
/*/

user function M460MARK()

Local lRet:= .T.	
Local nAtrasados := 0
Local cNome := ""
Local _CALIAS    :=GETAREA()
Local c_UserLib := GETMV("BM_USERLIB")


nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME

DbSelectArea("SC9")
DbSetOrder(1)
If dDataBase >= SC9->C9_DATALIB + 1
  RecLock("SC9", .F.)
  SC9->C9_BLCRED := '01'
  
  ALERT ("Liberação de crédito vencida, procure a área comercial e solicite uma nova liberação de crédito para o pedido. ")
  
    If nAtrasados <> 0

	   If !__CUSERID$(c_UserLib)
		  ShowHelpDlg(SM0->M0_NOME,;
		  {"O Cliente " + AllTrim(cNome)  + "Pedido "+SC5->C5_NUM+", possue restrições financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
		  {"Caso queira concluir a liberação deste pedido, solicite a liberação dos responsáveis."},5) 
	   EndIf
	
	   l_Ret := .F.	
	
	  DbSelectArea("SC5")
	  DbSetOrder(1)
	
	  If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		 RecLock("SC5", .F.)
			 SC5->C5_BXSTATU := 'B'		//Bloqueado Financeiro
		 MsUnlock()
	  EndIf
	
	  DbSelectArea("SC9")
	  DbSetOrder(1)
	
	  If (DBSEEK(xFilial("SC9")+SC9->C9_PEDIDO))
		 RecLock("SC9", .F.)
		   SC9->C9_BLCRED := ''
		   SC9->C9_QTDLIB := ''
		 MsUnlock()
	  EndIf 

  EndIf

If !lRet
	If  __CUSERID$(c_UserLib)

		cMensagem := "O pedido encontra-se com bloqueio, devido a restrição financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"# gostaria de realizar o desbloqueio?"
		If  u_BXMENATR(cMensagem,SA1->A1_COD, SA1->A1_LOJA)
		
			//MsgYesNo ("O pedido encontra-se com bloqueio, devido a restrição financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+" gostaria de realizar o desbloqueio?", "Atenção")

			l_Ret := .T. 

                   DbSelectArea("SC5")
                   DbSetOrder(1)
			
	                If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
	                   RecLock("SC5", .F.)
	                     SC5->C5_BXSTATU := 'A'		//Bloqueado Financeiro
	                   MsUnlock()
                    EndIf


	               DbSelectArea("SC9")
	               DbSetOrder(1)	
	
	               If (DBSEEK(xFilial("SC9")+SC9->C9_PEDIDO))
		             RecLock("SC9", .F.)
			           SC9->C9_BLCRED := ''
		               SC9->C9_QTDLIB := ''
		             MsUnlock()
	               EndIf                                                                                                                                                                                                           

		      EndIf
		
	       Endif
        EndIf

     If lRet .AND. !__CUSERID$(c_UserLib)

	   DbSelectArea("SC5")
	   DbSetOrder(1)		
	   If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		  RecLock("SC5", .F.)
			SC5->C5_BXSTATU := ''		//Bloqueado Financeiro
		  MsUnlock()
	   EndIf
    Endif

   lRet:= .F.

  EndIf

RESTAREA(_CALIAS)	

return lRet
