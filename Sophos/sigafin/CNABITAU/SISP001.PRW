#include "rwmake.ch"

User Function SISP001()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SISP001  ³ Autor ³ Anderson Reis         ³ Data ³ 20/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExecBlock disparado do 341REM.PAG para retornar agencia e  ³±±
±±³          ³ conta do fornecedor.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNAB SISPAG SANKYO                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
IF AT("-",SA2->A2_NUMCON) == 0 
//	If	SA2->A2_BANCO <> '399'
		_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON))-1)),12)
//	Else
//		_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON))-2)),12)
//	Endif
Else
	_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON)-1)),12)
Endif

Return(_cReturn)