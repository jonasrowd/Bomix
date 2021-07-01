#include "rwmake.ch"    



/*/                                     

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

±±³Programa  ³ ESTFG001  ³ Autor ³ Beatriz            ³Criado³ Nov/2008   ³±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±

±±³Descricao ³ Gatilho para criacao da sequencia do codigo inteligente de ³±±

±±³produtos                                                               ³±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

±±³Uso       ³ SIGAEST                                                    ³±±

±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±³Arquivos Relacionados³ SB1                                             ³±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

/*/

       

**********************

User Function ESTFG001()

**********************

_cAlias := Alias()

_cOrd   := IndexOrd()

_nReg   := Recno()



_cGrupo:= M->B1_GRUPO



dbSelectArea("SB1")

dbSetOrder(4)                                           

dbSeek(xFilial("SB1")+_cGrupo,.T.)

If	ST9->(Found())=.T.

	Do	While ST9->T9_CODFAMI == _cFamilia 

		_cSeqTemp:=Substr(ST9->T9_CODBEM,9,5)       
       // ALERT(_cSeqTemp)
 		ST9->(Dbskip())                   

	Enddo    

Else

	_cSeqTemp := "00000"

Endif

 

_cSeq := StrZero(Val(_cSeqTemp)+1,5)

_cCod := "MNT" + alltrim(_cFamilia) + _cSeq 



 

Dbselectarea(_cAlias)

Dbsetorder(_cOrd)  

Dbgoto(_nReg)

//ALERT(_cCod)

Return(_cCod)