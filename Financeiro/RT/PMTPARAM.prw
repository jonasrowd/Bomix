#include "totvs.ch"
#include "TbiConn.ch"
#include "topconn.ch"
#include "rwmake.ch"     

 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o	 ³ PMTPARAM	³ Autor ³ Tito Duarte 		    ³ Data ³ 11.06.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina de Alteracao de Parametros dos Fechamentos     	  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function PMTPARAM()

cALT1  := "N"
cALT2  := "N"
cALT3  := "N"
cALT4  := "N"
cALT5  := "N"
cPar1  := Ctod("  /  /  ")
cPar1  := Getmv("MV_DATAFIN")
cPar2  := "" //Ctod("  /  /  ")
cPar2  := Getmv("MV_BXDTFIN")
cPar3  := Ctod("  /  /  ")
cPar3  := Getmv("MV_DBLQMOV")
cPar4  := Ctod("  /  /  ")
cPar4  := Getmv("MV_DATAFIS")
cPar5  := Ctod("  /  /  ")
cPar5  := Getmv("MV_DATAREC")     
//cFilial:= XFILIAL('SX6')

@ 001,001 TO 460,500 DIALOG oDlg TITLE "Rotina de Bloqueio de Parametros"
@ 010,010 Say "* Atenção, o sistema só irá permitir lançamentos acima da data informada"
@ 030,010 Say "Parametro MV_DATAFIN-Fechamento Mensal (Financeiro) "
@ 040,010 Say "Deseja Alterar (S/N) ? "
@ 040,070 Get cALT1  Picture "@!" Size 30,20 Valid Pertence("SN")
@ 040,130 Say "Data: "
@ 040,180 Get cPar1  Picture "@!" Size 50,20 When cALT1="S"
@ 065,010 Say "Parametro MV_BXDTFIN-Permitir baixa menor que parametro MV_DATAFIN"
@ 075,010 Say "Deseja Alterar (S/N) ?"
@ 075,070 Get cALT2  Picture "@!" Size 30,20 Valid Pertence("SN")
@ 075,130 Say "1=Permite/2=Nao ?"
@ 075,180 Get cPar2  Picture "9" Size 50,20 When cALT2="S"
@ 100,010 Say "Parametro MV_DBLQMOV-Fechamento Mensal (Estoque) "
@ 110,010 Say "Deseja Alterar (S/N) ? "
@ 110,070 Get cALT3  Picture "@!" Size 30,20 Valid Pertence("SN")
@ 110,130 Say "Data: "
@ 110,180 Get cPar3  Picture "@!" Size 50,20 When cALT3="S"
@ 135,010 Say "Parametro MV_DATAFIS-Fechamento Mensal (Fiscal) "
@ 145,010 Say "Deseja Alterar (S/N) ? "
@ 145,070 Get cALT4  Picture "@!" Size 30,20 Valid Pertence("SN")
@ 145,130 Say "Data: "
@ 145,180 Get cPar4  Picture "@!" Size 50,20 When cALT4="S"
@ 170,010 Say "Parametro MV_DATAREC-Data Limite Reconc Bancaria (Financeiro) "
@ 185,010 Say "Deseja Alterar (S/N) ? "
@ 185,070 Get cALT5  Picture "@!" Size 30,20 Valid Pertence("SN")
@ 185,130 Say "Data: "
@ 185,180 Get cPar5  Picture "@!" Size 50,20 When cALT5="S"
@ 210,010 BmpButton Type 01 Action Atualiza()
@ 210,070 BmpButton Type 02 Action Close(oDlg)

Activate Dialog oDlg Centered

Return

// Efetuar alteração dos parametros
Static Function Atualiza()

If cALT1=="S"    
PUTMV("MV_DATAFIN", Dtoc(cPar1))      
endif

If cALT2=="S"           
IF cPar2="1" .OR. cPar2="2" 
	PUTMV("MV_BXDTFIN", cPar2)  
Else   
MsgBox("VALOR ERRADO !!! INFORME O VALOR CORRETO PARA MV_BXDTFIN !!! 1=Permite/2=Nao ?")
return .f.
endif	
Endif

If cALT3=="S"
	PUTMV("MV_DBLQMOV", Dtoc(cPar3)) 	 
Endif

If cALT4=="S"
	PUTMV("MV_DATAFIS", Dtoc(cPar4)) 	 	
Endif

If cALT5=="S"
	PUTMV("MV_DATAREC", Dtoc(cPar5))    
Endif

Close(oDlg)          

MsgBox("ATUALIZADO COM SUCESSO !!!")

Return

User Function BLQFECHA()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

cPar1 := dDataBase - GetMv("MV_BLQMES1")
cPar2 := dDataBase - GetMv("MV_BLQMES2")
cPar3 := "2"

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_DATAFIN")
RecLock('SX6',.F.)
	SX6->X6_CONTEUD := Dtoc(cPar1)
MsUnLock()

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_BXDTFIN")
RecLock('SX6',.F.)
	SX6->X6_CONTEUD := cPar3 //Dtoc(cPar1) **** Alterado por Victor Sousa *****  Parametro MV_BXDTFIN-Permitir baixa menor que parametro MV_DATAFIN **** 1=Permite/2=Nao ?      
MsUnLock()

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_DBLQMOV")
RecLock('SX6',.F.)
	SX6->X6_CONTEUD := Dtoc(cPar1)
MsUnLock()

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_DATAFIS")
RecLock('SX6',.F.)
	SX6->X6_CONTEUD := Dtoc(cPar1)
MsUnLock()

DbSelectArea("SX6")
DbSeek(xFilial()+"MV_DATAREC")
RecLock('SX6',.F.)
	SX6->X6_CONTEUD := Dtoc(cPar2)
MsUnLock()

MsgBox("ATUALIZADO COM SUCESSO !!!")

Return