#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FESTA004 � Autor � AP6 IDE            � Data �  25/03/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Controle de Tipos de Movimenta��o              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FESTA004


	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
	
	Private cString := "SZJ"
	
	dbSelectArea("SZJ")
	dbSetOrder(1)
	
	AxCadastro(cString,"Controle de Tipos de Movimenta��o",cVldExc,cVldAlt)

Return