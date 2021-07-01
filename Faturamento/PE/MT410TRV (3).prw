#INCLUDE "protheus.ch"




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT410TRV  บ Autor ณ VICTOR SOUSA       บ Data ณ18/01/2020  2บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PE Otimiza็ใo do Lock de regs tabelas SA1/SA2/SB2          บฑฑ
ฑฑบ            habilita/desabilita campos em PEDIDO DE VENDAS  			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Utilizado para habilita/desabilita campos em PV            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

