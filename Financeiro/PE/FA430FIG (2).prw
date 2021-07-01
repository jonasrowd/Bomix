#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA430FIG  ³ Autor ³ Alfred Andersen      ³ Data ³ 20/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite modificar o CNPJ obtido da leitura do arquivo de   ³±±
±±			 ³ retorno DDA, de modo que a tabela SA2 seja posicionada     ³±±
±±			 ³ através do CNPJ modificado neste ponto de entrada.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Permitir modificar CNPJ retorno DDA ( < cCNPJ> ) --> cCNP  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Antes da gravação do movimento DDA na tabela FIG.          ³±±
±±           ³ Programa Fonte										      ³±±
±±           ³ FINA430.PRX                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FA430FIG


Local cCNPJ 	:= ParamIxb[1]
Local cNF 	:= ParamIxb[4]

LOCAL _cFornec	:= POSICIONE("SA2",3,xFilial("SA2")+cCNPJ,"A2_COD") 
LOCAL _nReg		:= 0
LOCAL _cValpgto
Local cCNPJParc 	:= left(cCNPJ,8)
//LOCAL _dVencto
LOCAL _cVencto	

cVencto 	//Vencimento Real - Origem fonte FINA430
cValpgto 	//Valor de Pagamento - Origem fonte FINA430
cCodBar 	//Codigo de Barras - Origem fonte FINA430

//Tratamento Valor
_cValpgto 	:= nValpgto

//Tratamento Data
//_dVencto	:= CTOD(cVencto)

//_dVencto	:= CTOD(DBAIXA)

//_cVencto	:= DTOS(_dVencto)

_cVencto	:= DTOS(DBAIXA)



IF(SELECT("QSE2")<>0)
	QSE2->(DBCLOSEAREA())
ENDIF

//Monta Query

//E2_FORNECE = %EXP:_cFornec%
BEGINSQL ALIAS "QSE2"

	SELECT * FROM %TABLE:SE2% SE2
	JOIN %TABLE:SA2% SA2 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND A2_TIPO <> 'X' AND SA2.%NOTDEL%
	AND LEFT(E2_FILIAL,4)=A2_FILIAL
	WHERE LEFT(A2_CGC,8)=%EXP:cCNPJParc% 
	AND E2_VALOR = %EXP:_cValpgto%
	AND E2_VENCREA = %EXP:_cVencto%
	AND E2_FILIAL = %EXP:xFilial("SE2")%
	AND E2_BAIXA = ' '
	AND SE2.%NOTDEL%
	AND CHARINDEX(CAST(CAST(SE2.E2_NUM AS INT) AS VARCHAR),%EXP:cNF%)>0
ENDSQL

//ALERT(GETLASTQUERY()[2])

DbSelectArea("QSE2")




//Conta Nro de Registros
COUNT TO _nReg
QSE2->(DBGOTOP())

//Verifica condicos conforme nro de registros
//If	_nReg == 0 
//	cCNPJ := REPL("9",14)
//Else
If 	_nReg == 1
	cCNPJ := QSE2->A2_CGC //POSICIONE("SA2",1,xFilial("SA2")+QSE2->E2_FORNECE+QSE2->E2_LOJA,"A2_CGC")
	
//ElseIf _nReg >= 2      
//	cCNPJ := REPL("9",14)
Endif

QSE2->(DbCloseArea())
_cFornec	:= POSICIONE("SA2",3,xFilial("SA2")+cCNPJ,"A2_COD")

Return cCNPJ