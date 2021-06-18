#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function ctbzlan() 

//----------------------------------------------------------------------------
//|Programa  | CTBZLAN     | Autor | BEATRIZ AZEVEDO     |Criado| 08.Jan.2005|  
//----------------------------------------------------------------------------
//|Descricao | Limpa os campos abaixo permitindo nova importação dos lança-  |
//|          | mentos para a Contagbilidade Gerencial                        |
//|          | Financeiro : E1_LA,E2_LA,EV_LA,EZ_LA,E5_LA,EF_LA             |
//|          | Fiscal     :                                                  | 
//|          | Doc.Entrada:                                                  | 
//|          | Doc.Saida  :                                                  | 
//----------------------------------------------------------------------------
//|Uso       | SIGACTB                                                       |
//----------------------------------------------------------------------------

SetPrvt("CSTRING,NLASTKEY,CCANCEL,WREGUA,LCONTINUA,WREGNAT")

nLastKey    := 0
cCancel     :="######## CANCELADO PELO OPERADOR ###########"
wRegua  :=0

cPerg:="PVZLAN"

Criaperg()
pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01            // data inicial                         ³
//³ mv_par02            // data final                           ³
//³ mv_par03            // Filial inicial                       ³
//³ mv_par04            // Filial final                         ³
//³ mv_par05            // 1-Financeiro                         ³
//³                        2-Doc.Entrada                        ³
//³                        3-Doc.Saida                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Zera campos Integracao Contabil"
@ 8,10 TO 84,222
@ 23,15 SAY "Este programa inicializa os registros do Periodo/Sistema selecionados,"
@ 33,15 SAY "permitindo nova integração com a Contabilidade Gerencial."
@ 53,15 SAY "ANTES DE CONFIRMAR VERIFIQUE SE OS DADOS ESTAO REALMENTE CORRETOS !"
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("ZERLAN")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5

If nLastKey = 27
   lContinua := .F.
   Return
Endif 

************************
Static Function OkProc()
************************
Close(oDlg5)                         
If 		mv_par05==1
   		RptStatus({||Limpa_Financ()},"Aguarde","Limpando Arquivos Financeiros")
ElseIf 	mv_par05==2
       	RptStatus({||Limpa_DocEnt()},"Aguarde","Limpando Arquivos Entrada")
Else
       	RptStatus({||Limpa_DocSai()},"Aguarde","Limpando Arquivos Saida")
Endif
Return

******************************
Static Function Limpa_Financ()   
******************************   

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄbém 8S+8S+¿
//³Alterado por Tiago Lima para remover limpar os flags também ³
//³das tabelas de rateio (SEV e SEZ), 07/08/2006               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄbém 8S+8S+Ù
ENDDOC*/
cQry := "UPDATE "+RetSqlName("SEV")+" SET EV_LA=' ' "  
cQry += "WHERE EV_RECPAG='P' "  
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "AND EXISTS (SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_FILIAL, E2_FORNECE, E2_TIPO, E2_LOJA "
		cQry += "FROM "+RetSqlName("SE2")+" E2 "
		cQry += "WHERE E2_NUM = EV_NUM AND E2_PREFIXO = EV_PREFIXO AND E2_PARCELA = EV_PARCELA " 
			cQry += "AND E2_FILIAL = EV_FILIAL AND E2_FORNECE = EV_CLIFOR AND E2_TIPO = EV_TIPO " 
			cQry += "AND E2_LOJA = EV_LOJA " 
			cQry += "AND E2.D_E_L_E_T_ <> '*' " 
			cQry += "AND RTRIM(E2_ORIGEM) NOT IN ('MATA100','MATA103') "
			cQry += "AND E2_EMIS1>='"+dtos(mv_par01)+"' " 
			cQry += "AND E2_EMIS1<='"+dtos(mv_par02)+"' "
			cQry += "AND E2_FILIAL>='"+mv_par03+"' " 
			cQry += "AND E2_FILIAL<='"+mv_par04+"') "
TCSQLExec(cQry) 

cQry := "UPDATE "+RetSqlName("SEV")+" SET EV_LA=' ' "  
cQry += "WHERE EV_RECPAG='R' "  
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "AND EXISTS (SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_FILIAL, E1_CLIENTE, E1_TIPO, E1_LOJA "
		cQry += "FROM "+RetSqlName("SE1")+" E1 "
		cQry += "WHERE E1_NUM = EV_NUM AND E1_PREFIXO = EV_PREFIXO AND E1_PARCELA = EV_PARCELA " 
			cQry += "AND E1_FILIAL = EV_FILIAL AND E1_CLIENTE = EV_CLIFOR AND E1_TIPO = EV_TIPO " 
			cQry += "AND E1_LOJA = EV_LOJA " 
			cQry += "AND E1.D_E_L_E_T_ <> '*' " 
			cQry += "AND RTRIM(E1_ORIGEM) NOT IN ('MATA460') "
			cQry += "AND E1_EMIS1>='"+dtos(mv_par01)+"' " 
			cQry += "AND E1_EMIS1<='"+dtos(mv_par02)+"' "
			cQry += "AND E1_FILIAL>='"+mv_par03+"' " 
			cQry += "AND E1_FILIAL<='"+mv_par04+"') "
TCSQLExec(cQry) 

cQry := "UPDATE "+RetSqlName("SEZ")+" SET EZ_LA=' ' "  
cQry += "WHERE EZ_RECPAG='P' "  
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "AND EXISTS (SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_FILIAL, E2_FORNECE, E2_TIPO, E2_LOJA "
		cQry += "FROM "+RetSqlName("SE2")+" E2 "
		cQry += "WHERE E2_NUM = EZ_NUM AND E2_PREFIXO = EZ_PREFIXO AND E2_PARCELA = EZ_PARCELA " 
			cQry += "AND E2_FILIAL = EZ_FILIAL AND E2_FORNECE = EZ_CLIFOR AND E2_TIPO = EZ_TIPO " 
			cQry += "AND E2_LOJA = EZ_LOJA " 
			cQry += "AND E2.D_E_L_E_T_ <> '*' " 
			cQry += "AND RTRIM(E2_ORIGEM) NOT IN ('MATA100','MATA103') "
			cQry += "AND E2_EMIS1>='"+dtos(mv_par01)+"' " 
			cQry += "AND E2_EMIS1<='"+dtos(mv_par02)+"' "
			cQry += "AND E2_FILIAL>='"+mv_par03+"' " 
			cQry += "AND E2_FILIAL<='"+mv_par04+"') "
TCSQLExec(cQry) 

cQry := "UPDATE "+RetSqlName("SEZ")+" SET EZ_LA=' ' "  
cQry += "WHERE EZ_RECPAG='R' "  
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "AND EXISTS (SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_FILIAL, E1_CLIENTE, E1_TIPO, E1_LOJA "
		cQry += "FROM "+RetSqlName("SE1")+" E1 "
		cQry += "WHERE E1_NUM = EZ_NUM AND E1_PREFIXO = EZ_PREFIXO AND E1_PARCELA = EZ_PARCELA " 
			cQry += "AND E1_FILIAL = EZ_FILIAL AND E1_CLIENTE = EZ_CLIFOR AND E1_TIPO = EZ_TIPO " 
			cQry += "AND E1_LOJA = EZ_LOJA " 
			cQry += "AND E1.D_E_L_E_T_ <> '*' " 
			cQry += "AND RTRIM(E1_ORIGEM) NOT IN ('MATA460') "
			cQry += "AND E1_EMIS1>='"+dtos(mv_par01)+"' " 
			cQry += "AND E1_EMIS1<='"+dtos(mv_par02)+"' "
			cQry += "AND E1_FILIAL>='"+mv_par03+"' " 
			cQry += "AND E1_FILIAL<='"+mv_par04+"') "
TCSQLExec(cQry) 

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄbém 8S+8S+¿
// FIM DA ALTERACAO                                            ³//
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄbém 8S+8S+Ù
ENDDOC*/

cQry := "UPDATE "+RETSQLNAME("SE1")
cQry := cQry + " SET E1_LA = ' '"
cQry := cQry + " WHERE E1_EMIS1>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND E1_EMIS1<='"+dtos(mv_par02)+"'"   
cQry := cQry + " AND E1_FILIAL>='"+mv_par03+"'" 
cQry := cQry + " AND E1_FILIAL<='"+mv_par04+"'"
cQry := cQry + " AND E1_LA='S'"
cQry := cQry + " AND RTRIM(E1_ORIGEM) NOT IN ('MATA460') "
cQry := cQry + " AND D_E_L_E_T_<>'*'"
TCSQLExec(cQry)           

cQry := "UPDATE "+RETSQLNAME("SE2")
cQry := cQry + " SET E2_LA = ' '"
cQry := cQry + " WHERE E2_EMIS1>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND E2_EMIS1<='"+dtos(mv_par02)+"'"
cQry := cQry + " AND E2_FILIAL>='"+mv_par03+"'" 
cQry := cQry + " AND E2_FILIAL<='"+mv_par04+"'"
cQry := cQry + " AND E2_LA='S'"
cQry := cQry + " AND RTRIM(E2_ORIGEM) NOT IN ('MATA100','MATA103') "
cQry := cQry + " AND D_E_L_E_T_<>'*'"
TCSQLExec(cQry)

cQry := "UPDATE "+RETSQLNAME("SE5")
cQry := cQry + " SET E5_LA = ' '"
cQry := cQry + " WHERE E5_DATA>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND E5_DATA<='"+dtos(mv_par02)+"'"
cQry := cQry + " AND E5_LA='S'"
cQry := cQry + " AND E5_FILIAL>='"+mv_par03+"'" 
cQry := cQry + " AND E5_FILIAL<='"+mv_par04+"'"
cQry := cQry + " AND D_E_L_E_T_<>'*'"
TCSQLExec(cQry)

cQry := "UPDATE "+RETSQLNAME("SEF")
cQry := cQry + " SET EF_LA = ' '"
cQry := cQry + " WHERE EF_DATA>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND EF_DATA<='"+dtos(mv_par02)+"'"
cQry := cQry + " AND EF_LA='S'"
cQry := cQry + " AND EF_FILIAL>='"+mv_par03+"'" 
cQry := cQry + " AND EF_FILIAL<='"+mv_par04+"'"
cQry := cQry + " AND D_E_L_E_T_<>'*'"
TCSQLExec(cQry)

Return

******************************
Static Function Limpa_DocEnt()   
******************************
cQry := "UPDATE "+RETSQLNAME("SF1")
cQry := cQry + " SET F1_DTLANC = '        '"
cQry := cQry + " WHERE F1_DTDIGIT>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND F1_DTDIGIT<='"+dtos(mv_par02)+"'"   
cQry := cQry + " AND F1_FILIAL>='"+mv_par03+"'" 
cQry := cQry + " AND F1_FILIAL<='"+mv_par04+"'"
cQry := cQry + " AND D_E_L_E_T_<>'*'"
TCSQLExec(cQry)           
Return

******************************
Static Function Limpa_DocSai()   
******************************
cQry := "UPDATE "+RETSQLNAME("SF2")
cQry := cQry + " SET F2_DTLANC = '        '"
cQry := cQry + " WHERE F2_EMISSAO>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND F2_EMISSAO<='"+dtos(mv_par02)+"'"   
cQry := cQry + " AND F2_FILIAL>='"+mv_par03+"'" 
cQry := cQry + " AND F2_FILIAL<='"+mv_par04+"'"
cQry := cQry + " AND D_E_L_E_T_<>'*'"
TCSQLExec(cQry)    
Return

*---------------------------------------------------------------------------------*
Static Function CriaPerg
*---------------------------------------------------------------------------------*
Local _sAlias := Alias()
Local aRegs   := {}
Local i
Local j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial    ","","","mv_ch1","D",8,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final      ","","","mv_ch2","D",8,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Filial Inicial  ","","","mv_ch3","C",2,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
aAdd(aRegs,{cPerg,"04","Filial Final    ","","","mv_ch4","C",2,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
aAdd(aRegs,{cPerg,"05","Origem          ","","","mv_ch5","N",1,00,0,"C","","mv_par03","Financeiro","","","","","Doc. Entrada","","","","","Doc. Saida","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to Len(aRegs[i])//FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)

Return