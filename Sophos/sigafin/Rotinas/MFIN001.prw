#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
���Programa  � MFIN001  � Autor � Bete               � Data �  31/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo para cadastro do status de cobran�a                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�����������������������������������������������������������������������������
/*/

User Function MFIN001

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z01"

DbSelectArea("Z01")
DbSetOrder(1)

AxCadastro(cString,"Cadastro de Status de Cobran�a",cVldExc,cVldAlt)

Return