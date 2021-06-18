#INCLUDE "protheus.ch"




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TRV  � Autor � VICTOR SOUSA       � Data �18/01/2020  2���
�������������������������������������������������������������������������͹��
���Descricao � PE Otimiza��o do Lock de regs tabelas SA1/SA2/SB2          ���
���            habilita/desabilita campos em PEDIDO DE VENDAS  			  ���
�������������������������������������������������������������������������͹��
���Uso       � Utilizado para habilita/desabilita campos em PV            ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function MT410TRV()
	Local cCliForn := ParamIXB[1] // Codigo do cliente/fornecedor
	Local cLoja := ParamIXB[2] // Loja
	Local cTipo := ParamIXB[3] // C=Cliente(SA1) - F=Fornecedor(SA2)
	Local aRet := Array(4)
	Local lTravaSA1 := .F. // Desliga trava da tabela SA1
	Local lTravaSA2 := .F. // Desliga trava da tabela SA2
	Local lTravaSB2 := .F. // Desliga trava da tabela SB2

	Local aRet[1] := lTravaSA1
	Local aRet[2] := lTravaSA2
	Local aRet[3] := lTravaSB2


	//	MsgAlert("P.E MT410TRV...","Alerta")

Return(aRet)

