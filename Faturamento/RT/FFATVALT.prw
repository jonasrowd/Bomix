
User Function FFATVALT      


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SC5"

DbSelectArea("SC5")
DbSetOrder(1)

AxCadastro(cString,"Cabecalho do Pedido de Vendas",cVldExc,cVldAlt)

Return