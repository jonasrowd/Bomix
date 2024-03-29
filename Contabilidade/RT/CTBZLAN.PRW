#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function CTBZLAN()

// ---------------------------------------------------------------------------------------------------------------------------------------
// DATA     : 05/04/2016
// PROGRAMA : CTBZLAN()
// OBJETIVO : LIMPAR FLAG DE CONTABILIZA?O DAS TABELAS DO FATURAMENTO, COMPRAS, ESTOQUE E FINANCEIRO
// ALTERADO : PABLO REGIS
// ---------------------------------------------------------------------------------------------------------------------------------------

SetPrvt("CSTRING,NLASTKEY,CCANCEL,WREGUA,LCONTINUA,WREGNAT")

nLastKey := 0
cCancel  := "######## CANCELADO PELO OPERADOR ###########"
wRegua   := 0
cPerg    := "PVLAN2"

Criaperg()
*
*
   PERGUNTE(cPerg,.T.)

   //????????????????????????????????
   //?Variaveis utilizadas para par?metros                        ?
   //?mv_par01            // data inicial                         ?
   //?mv_par02            // data final                           ?
   //?mv_par03            // 1-Financeiro                         ?
   //?                       2-Fiscal                             ?
   //?                       3-Doc.Entrada                        ?
   //?                       4-Doc.Saida                          ?
   //????????????????????????????????
   *
   @ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Zera campos Integracao Contabil"
   @ 8,10 TO 84,222
   @ 23,15 SAY "Este programa inicializa os registros do Periodo/Sistema selecionados,"
   @ 33,15 SAY "permitindo nova integra��o com a Contabilidade Gerencial."
   @ 53,15 SAY "ANTES DE CONFIRMAR VERIFIQUE SE OS DADOS ESTAO RELAMENTE CORRETOS !"
   @ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
   @ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
   @ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
   ACTIVATE DIALOG oDlg5
   *
   If nLastKey = 27
      lContinua := .F.
      Return
   Endif 

************************
Static Function OkProc()
************************
Close(oDlg5)                         
If     mv_par03==1
       RptStatus({||Limpa_Financ()},"Aguarde","Limpando Arquivos Financeiros")
ElseIf mv_par03==2
       RptStatus({||Limpa_DocEnt()},"Aguarde","Limpando Arquivos Entrada")
ElseIf mv_par03==3
       RptStatus({||Limpa_DocSai()},"Aguarde","Limpando Arquivos Saida")
ElseIf mv_par03==4
       RptStatus({||Limpa_Todos()},"Aguarde","Limpar Flag em Todos os Modulos")
Endif
Return

// limpar flag contabil em todos os modulos com base no periodo informado
// -----------------------------------------------------------------------------------
Static Function Limpa_Todos()
   RptStatus({||Limpa_Financ()},"Aguarde","Limpando Arquivos Financeiros")
   RptStatus({||Limpa_DocEnt()},"Aguarde","Limpando Arquivos Entrada")
   RptStatus({||Limpa_DocSai()},"Aguarde","Limpando Arquivos Saida")
Return


******************************
Static Function Limpa_Financ()   
******************************   
//???????????????????????????????? 8S+8S+?
//?lterado por Tiago Lima para remover limpar os flags tamb? ?
//?as tabelas de rateio (SEV e SEZ), 07/08/2006               ?
//???????????????????????????????? 8S+8S+?
If MV_PAR04==1 .OR. MV_PAR04==5
   cQry := ""
   cQry := "UPDATE "+RETSQLNAME("SE1")
   cQry := cQry + " SET E1_LA = ' '"
   cQry := cQry + " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND E1_EMISSAO>='"+dtos(mv_par01)+"'"
   cQry := cQry + " AND E1_EMISSAO<='"+dtos(mv_par02)+"'"  
   IF MV_PAR13 == 1 
	   cQry := cQry + " AND E1_LA='S'"
   ENDIF		   
   cQry := cQry + " AND D_E_L_E_T_<>'*'"  
   cQry := cQry + " AND RTRIM(E1_ORIGEM) NOT IN ('MATA460')  "

   //Alan 09/07/13
   If !EMPTY(trim(DTOS(mv_par09))) .AND. !EMPTY(trim(DTOS(mv_par10)))
	   cQry := cQry + " AND E1_BAIXA BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"' "
   EndIf

   //Pablo Regis 26/04/11
   cQry := cQry + " AND E1_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
   cQry := cQry + " AND E1_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
   cQry := cQry + " AND E1_PORTADO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' " 
   
	//
   TCSQLExec(cQry)           
   *         
   cQry := ""   
   cQry := "UPDATE "+RETSQLNAME("SEV")+" SET EV_LA = ' ' FROM "+RETSQLNAME("SE1")+" E1,"+RETSQLNAME("SEV")+" EV "
   cQry += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND EV_FILIAL = '"+xFilial("SEV")+"' AND E1_NUM = EV_NUM AND E1_PREFIXO = EV_PREFIXO AND E1_PARCELA = EV_PARCELA "
   cQry += " AND E1_FILIAL = EV_FILIAL AND E1_CLIENTE = EV_CLIFOR  AND E1_TIPO = EV_TIPO "
   cQry += " AND E1_LOJA = EV_LOJA AND E1.D_E_L_E_T_ <> '*' AND EV.D_E_L_E_T_ <> '*' AND E1_EMISSAO>='"+dtos(mv_par01)+"' "
   cQry += " AND E1_EMISSAO<='"+dtos(mv_par02)+"' " 
   cQry += " AND RTRIM(E1_ORIGEM) NOT IN ('MATA460')  "
   
   //Pablo Regis 26/04/11
   cQry := cQry + " AND E1_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
   cQry := cQry + " AND E1_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "   
   cQry := cQry + " AND E1_PORTADO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "
	// 
   TCSQLExec(cQry) 
   *         
   cQry := ""   
   cQry := "UPDATE "+RETSQLNAME("SEZ")+" SET EZ_LA = ' ' FROM "+RETSQLNAME("SE1")+" E1,"+RETSQLNAME("SEZ")+" EZ "
   cQry += "WHERE  E1_FILIAL = '"+xFilial("SE1")+"' AND EZ_FILIAL = '"+xFilial("SEZ")+"' AND E1_NUM = EZ_NUM AND E1_PREFIXO = EZ_PREFIXO AND E1_PARCELA = EZ_PARCELA "
   cQry += " AND E1_FILIAL = EZ_FILIAL AND E1_CLIENTE = EZ_CLIFOR  AND E1_TIPO = EZ_TIPO "
   cQry += " AND E1_LOJA = EZ_LOJA AND E1.D_E_L_E_T_ <> '*' AND EZ.D_E_L_E_T_ <> '*' AND E1_EMISSAO>='"+dtos(mv_par01)+"' "
   cQry += " AND E1_EMISSAO<='"+dtos(mv_par02)+"' "  
   cQry += " AND RTRIM(E1_ORIGEM) NOT IN ('MATA460')  "
   
   //Pablo Regis 26/04/11
   cQry := cQry + " AND E1_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
   cQry := cQry + " AND E1_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "  
   cQry := cQry + " AND E1_PORTADO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "
	//
   
   TCSQLExec(cQry) 
ENDIF                          
*
If MV_PAR04==2 .OR. MV_PAR04==5
   cQry := ""
   cQry := "UPDATE "+RETSQLNAME("SE2")
   cQry := cQry + " SET E2_LA = ' '"
   cQry := cQry + " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND  E2_EMISSAO>='"+dtos(mv_par01)+"'"
   cQry := cQry + " AND E2_EMISSAO<='"+dtos(mv_par02)+"'"  
   
   cQry := cQry + " AND RTRIM(E2_ORIGEM) NOT IN ('MATA100','MATA103') "   
   
   IF MV_PAR13 == 1
	   cQry := cQry + " AND E2_LA='S'"
   ENDIF
   cQry := cQry + " AND D_E_L_E_T_<>'*'" 
   
   //Pablo Regis 26/04/11
   cQry := cQry + " AND E2_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
   cQry := cQry + " AND E2_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	//

   TCSQLExec(cQry)
   *         
   cQry := ""   
   cQry := "UPDATE "+RETSQLNAME("SEV")+" SET EV_LA = ' ' FROM "+RETSQLNAME("SE2")+" E2,"+RETSQLNAME("SEV")+" EV "
   cQry += "WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND EV_FILIAL = '"+xFilial("SEV")+"' AND E2_NUM = EV_NUM AND E2_PREFIXO = EV_PREFIXO AND E2_PARCELA = EV_PARCELA "
   cQry += " AND E2_FILIAL = EV_FILIAL AND E2_FORNECE = EV_CLIFOR  AND E2_TIPO = EV_TIPO "
   cQry += " AND E2_LOJA = EV_LOJA AND E2.D_E_L_E_T_ <> '*' AND EV.D_E_L_E_T_ <> '*' AND E2_EMISSAO>='"+dtos(mv_par01)+"' "
   cQry += " AND E2_EMISSAO<='"+dtos(mv_par02)+"' " 
   cQry += " AND RTRIM(E2_ORIGEM) NOT IN ('MATA100','MATA103') "      
   
   //Pablo Regis 26/04/11
   cQry := cQry + " AND E2_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
   cQry := cQry + " AND E2_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	//
   TCSQLExec(cQry)  
   *         
   cQry := ""   
   cQry := "UPDATE "+RETSQLNAME("SEZ")+" SET EZ_LA = ' ' FROM "+RETSQLNAME("SE2")+" E2,"+RETSQLNAME("SEZ")+" EZ "
   cQry += "WHERE  E2_FILIAL = '"+xFilial("SE2")+"' AND EZ_FILIAL = '"+xFilial("SEZ")+"' AND E2_NUM = EZ_NUM AND E2_PREFIXO = EZ_PREFIXO AND E2_PARCELA = EZ_PARCELA "
   cQry += " AND E2_FILIAL = EZ_FILIAL AND E2_FORNECE = EZ_CLIFOR  AND E2_TIPO = EZ_TIPO "
   cQry += " AND E2_LOJA = EZ_LOJA AND E2.D_E_L_E_T_ <> '*' AND EZ.D_E_L_E_T_ <> '*' AND E2_EMISSAO>='"+dtos(mv_par01)+"' "
   cQry += " AND E2_EMISSAO<='"+dtos(mv_par02)+"' " 
   cQry += " AND RTRIM(E2_ORIGEM) NOT IN ('MATA100','MATA103') "         
   
   //Pablo Regis 26/04/11
   cQry := cQry + " AND E2_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
   cQry := cQry + " AND E2_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	//
   TCSQLExec(cQry) 
ENDIF
*
If MV_PAR04 ==1 .OR. MV_PAR04==3 .OR. MV_PAR04==5
   cQry := ""
   cQry := "UPDATE "+RETSQLNAME("SE5")
   cQry := cQry + " SET E5_LA = ' '"
   cQry := cQry + " WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_DATA>='"+dtos(mv_par09)+"'"
   cQry := cQry + " AND E5_DATA<='"+dtos(mv_par10)+"'"
   IF MV_PAR13 == 1
	   cQry := cQry + " AND E5_LA='S'"
   ENDIF
   cQry := cQry + " AND D_E_L_E_T_<>'*'" 
   
   //Pablo Regis 26/04/11
	cQry := cQry + " AND E5_NUMERO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQry := cQry + " AND E5_PREFIXO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "	
	cQry := cQry + " AND E5_BANCO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "    
	//
   TCSQLExec(cQry)
ENDIF
*   
If MV_PAR04==4 .OR. MV_PAR04==5
   cQry := ""
   cQry := "UPDATE "+RETSQLNAME("SEF")
   cQry := cQry + " SET EF_LA = ' '"
   cQry := cQry + " WHERE EF_FILIAL = '"+xFilial("SEF")+"' AND EF_DATA>='"+dtos(mv_par01)+"'"
   cQry := cQry + " AND EF_DATA<='"+dtos(mv_par02)+"'"
   
   IF MV_PAR13 == 1
	   cQry := cQry + " AND EF_LA='S'"
   Endif
   cQry := cQry + " AND D_E_L_E_T_<>'*'"
   TCSQLExec(cQry)
ENDIF
*
Return

******************************
Static Function Limpa_Fiscal()   
******************************
Return

******************************
Static Function Limpa_DocEnt()   
******************************
cQry := "UPDATE "+RETSQLNAME("SF1")
cQry := cQry + " SET F1_DTLANC = '        '"
cQry := cQry + " WHERE F1_FILIAL = '"+xFilial("SF1")+"' AND F1_DTDIGIT>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND F1_DTDIGIT<='"+dtos(mv_par02)+"'"   
cQry := cQry + " AND D_E_L_E_T_<>'*'" 

//Pablo Regis 26/04/11
cQry := cQry + " AND F1_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQry := cQry + " AND F1_SERIE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
//
TCSQLExec(cQry)           
Return

******************************
Static Function Limpa_DocSai()   
******************************
cQry := "UPDATE "+RETSQLNAME("SF2")
cQry := cQry + " SET F2_DTLANC = '        '"
cQry := cQry + " WHERE F2_FILIAL = '"+xFilial("SF2")+"' AND F2_EMISSAO>='"+dtos(mv_par01)+"'"
cQry := cQry + " AND F2_EMISSAO<='"+dtos(mv_par02)+"'"   
cQry := cQry + " AND D_E_L_E_T_<>'*'"

//Pablo Regis 26/04/11
cQry := cQry + " AND F2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQry := cQry + " AND F2_SERIE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "

TCSQLExec(cQry)  
//
Return

*---------------------------------------------------------------------------------*
// 
Static Function CriaPerg
   Local _sAlias := Alias()
   Local aRegs   := {}
   Local i
   Local j
   *
   dbSelectArea("SX1")
   dbSetOrder(1)
   cPerg := PADR(cPerg,10)

   // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
   aAdd(aRegs,{cPerg,"01","Data Emi. De    ","","","mv_ch1" ,"D",8,00,0,"G","","mv_par01","              ","","","","","            ","","","","","            ","","","","","       ","","","","","     ","","","","","","","","","" })
   aAdd(aRegs,{cPerg,"02","Data Emi. At�   ","","","mv_ch2" ,"D",8,00,0,"G","","mv_par02","              ","","","","","            ","","","","","            ","","","","","       ","","","","","     ","","","","","","","","","" })
   aAdd(aRegs,{cPerg,"03","Origem          ","","","mv_ch3" ,"N",1,00,0,"C","","mv_par03","Financeiro    ","","","","","Doc. Entrada","","","","","Doc. Saida  ","","","","","Ambos  ","","","","","     ","","","","","","","","",""})
   aAdd(aRegs,{cPerg,"04","Rotinas         ","","","mv_ch4" ,"N",1,00,0,"C","","mv_par04","Ct.Receber/Prov","","","","","Ct.Pagar/Prov","","","","","Mov.Banc/Tit.Pagos","","","","","Cheques","","","","","Ambos","","","","","","","","",""})
   aAdd(aRegs,{cPerg,"05","Notas de ?	   ","","","mv_ch5" ,"C",9,00,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   aAdd(aRegs,{cPerg,"06","Notas at�? 	   ","","","mv_ch6" ,"C",9,00,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   aAdd(aRegs,{cPerg,"07","Serie de ? 	   ","","","mv_ch7" ,"C",3,00,0,"C","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   aAdd(aRegs,{cPerg,"08","Serie at�? 	   ","","","mv_ch8" ,"C",3,00,0,"C","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   aAdd(aRegs,{cPerg,"09","Dt Baixa Ini    ","","","mv_ch9" ,"D",8,00,0,"G","","mv_par09","              ","","","","","            ","","","","","            ","","","","","       ","","","","","     ","","","","","","","","","" })
   aAdd(aRegs,{cPerg,"10","Dt Baixa Fim    ","","","mv_ch10","D",8,00,0,"G","","mv_par10","              ","","","","","            ","","","","","            ","","","","","       ","","","","","     ","","","","","","","","","" })
   aAdd(aRegs,{cPerg,"11","Banco de	       ","","","MV_CH11","C",3,0,0, "G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
   aAdd(aRegs,{cPerg,"12","Banco at�?   ","","","MV_CH12","C",3,0,0, "G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
   aAdd(aRegs,{cPerg,"13","For�ar Limpeza  ","","","mv_ch13","N",1,00,0,"C","","MV_PAR13","N?    ","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","",""})
   *
   For i:=1 to Len(aRegs)
       If !dbSeek(cPerg+aRegs[i,2])
           RecLock("SX1",.T.)
           For j:=1 to Len(aRegs[i])
               If j <= Len(aRegs[i])
                  FieldPut(j,aRegs[i,j])
               Endif
           Next
           MsUnlock()
        Endif
   Next
   dbSelectArea(_sAlias)
Return
