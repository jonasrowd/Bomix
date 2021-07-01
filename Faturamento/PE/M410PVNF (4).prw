/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410PVNF   � Autor � Christian Rocha    � Data �			  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para validar a gera��o do documento de    ���
���          � sa�da													  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT													  ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410PVNF     


	Local c_Prefixo := IIF(cFilAnt == "010101", "ABT", "ABST")
	Local a_Area    := GetArea()
	Local l_Ret     := .T.

    Local nAtrasados := 0
    Local cNome := ""
    Local c_UserLib := GETMV("BM_USERLIB")


//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   Return(l_Ret)
endif

////////

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6") + SC5->C5_NUM)
	While SC6->(!EoF()) .And. SC6->(C6_FILIAL + C6_NUM) == xFilial("SC6") + SC5->C5_NUM
		If Substr(SC6->C6_PRODUTO, 1, 1) $ c_Prefixo
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1") + SC6->C6_PRODUTO)
				If SB1->B1_PESO == 0
					If SB1->B1_TIPO == "SU" .And. cFilAnt == "020101"
						l_Ret := .T.
                    Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"Cadastro do Produto " + AllTrim(SC6->C6_PRODUTO)  + " foi efetuado sem o preenchimento da informa��o de Peso L�quido."},5,;
						{"Contacte o respons�vel pelo cadastro de produtos e solicite o preenchimento do campo Peso L�quido."},5)
						l_Ret := .F.
						Exit
					Endif
				Endif
			Endif
        Endif

        SC6->(dbSkip())
	End
	

/*
Altera��es realizadas para valida��o das retri��es financeiras dos clientes na prepara��o do documento de sa�da
@author Elmer Farias
@since 14/01/21
/*/


//aResult := TCSPEXEC("BOMIXBI.dbo.Fin_SP_AtualizarBase_ClientesTitulosAbertos", SA1->A1_FILIAL, �SA1->A1_COD, SA1->A1_LOJA) // Array que passa os par�metros para Store Procedure

nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)//SA1->A1_ATR
cNome := SA1->A1_NOME
 


DbSelectArea("SC9")
DbSetOrder(1)
If (DBSEEK(xFilial("SC9")+SC5->C5_NUM))
	If dDataBase >= SC9->C9_DATALIB + 1
	  RecLock("SC9", .F.)
	  	SC9->C9_BLCRED := '01'
	  MsUnlock()
	   
	  ALERT ("A libera��o de cr�dito est� vencida, procure a �rea comercial e solicite uma nova libera��o de cr�dito para este pedido. ")
	  
	  return .F.
	EndIf  
	  
EndIf 
  
If nAtrasados <> 0

	If !__CUSERID$(c_UserLib)
		  ShowHelpDlg(SM0->M0_NOME,;
		  {"O Cliente " + AllTrim(cNome)  + "Pedido "+SC5->C5_NUM+", possue restri��es financeiras no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"."},5,;
	  {"Caso queira concluir a libera��o deste pedido, solicite a libera��o dos respons�veis."},5) 
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

   If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
	 RecLock("SC9", .F.)
	   SC9->C9_BLCRED := ''
	   SC9->C9_QTDLIB := 0
	 MsUnlock()�
   EndIf 
EndIf

If !l_Ret
	If  __CUSERID$(c_UserLib)

		cMensagem := "O pedido encontra-se com bloqueio, devido a restri��o financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+"# gostaria de realizar o desbloqueio?"
		If  u_BXMENATR(cMensagem,SA1->A1_COD, SA1->A1_LOJA)
		
			//MsgYesNo ("O pedido encontra-se com bloqueio, devido a restri��o financeira do cliente no total de R$ "+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+" gostaria de realizar o desbloqueio?", "Aten��o")

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
	
	               If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		             RecLock("SC9", .F.)
			           SC9->C9_BLCRED := ''
		             MsUnlock()
	               EndIf                                                                                                                                                                                                           

		     EndIf
		
	     Endif
    EndIf

    If l_Ret .AND. !__CUSERID$(c_UserLib)

	   DbSelectArea("SC5")
	   DbSetOrder(1)		
	   If (DBSEEK(xFilial("SC5")+SC5->C5_NUM))
		  RecLock("SC5", .F.)
			SC5->C5_BXSTATU := ''		//Bloqueado Financeiro
		  MsUnlock()
	   EndIf
    Endif

l_Ret := .F.


RestArea(a_Area)
	
Return l_Ret