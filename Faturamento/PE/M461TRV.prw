#INCLUDE "protheus.ch"




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M461TRV  � Autor � VICTOR SOUSA        � Data �18/01/2020  2���
�������������������������������������������������������������������������͹��
���Descricao � PE Otimiza��o do Lock de regs tabela SB2                   ���
���            habilita/desabilita locks no Documento de Saida           ���
�������������������������������������������������������������������������͹��
���Uso       � Habilita/desabilita locks no Documento de Saida            ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M461TRV()

	//.T. - Trava os registros
	//.F. - Desativa a trava dos registros
	//Alert("Passou pelo PE: M461TRV")

Return .F.