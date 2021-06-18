#Include "protheus.ch"
#Include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA416PV  � Autor �                    � Data �Novembro/2012���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para grava��o do campo CK_FSTPITE no campo���
���          � C6_FSTPITE.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � BOMIX                                                      ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA416PV       




	Local n_Pos 	:= PARAMIXB 			//Numero do item atual do _aCols
	Local c_TipItem	:= SCK->CK_FSTPITE
	Local c_Mix 	:= SCK->CK_FSMIX


//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return
endif

////////




	M->C5_FSOBS   := SCJ->CJ_FSOBS
	M->C5_MENNOTA := SCJ->CJ_FSMNOTA

	_aCols[n_Pos][AScan(_aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]:= c_TipItem
	_aCols[n_Pos][AScan(_aHeader,{ |x| Alltrim(x[2]) == 'C6_FSMIX' })]  := c_Mix

	If c_TipItem == '1'
			ShowHelpDlg(SM0->M0_NOME, {"A arte do produto " + AllTrim(SCK->CK_PRODUTO) + " do or�amento " + SCK->CK_NUM + " � nova ou est� bloqueada."},5,;
	                                  {"Contacte o administrador do sistema."},5)
	Endif
Return