#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
User Function TMata010()
Local aVetor := {}
private lMsErroAuto := .F.

/* 
//--- Exemplo: Inclusao --- //
aVetor:= { {"B1_COD" ,"000100001" ,NIL},;
 {"B1_DESC" ,"TESTE DOUG" ,NIL},;
 {"B1_TIPO" ,"PA" ,Nil},;
 {"B1_UM" ,"UN" ,Nil},;
 {"B1_LOCPAD" ,"01" ,Nil},;
 {"B1_PICM" ,0 ,Nil},;
 {"B1_IPI" ,0 ,Nil},;
 {"B1_CONTRAT" ,"N" ,Nil},;
 {"B1_LOCALIZ" ,"N" ,Nil}}
  
MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)
 */
//--- Exemplo: Alteracao --- //
aVetor:= { {"B1_COD" ,"000100001" ,NIL},;
 {"B1_DESC" ,"TESTE DOUGLAS__" ,NIL}}
  
MSExecAuto({|x,y| Mata010(x,y)},aVetor,4)
/* 
//--- Exemplo: Exclusao --- //
aVetor:= { {"B1_COD" ,"9994" ,NIL},;
 {"B1_DESC" ,"PRODUTO TESTE - ROTINA AUTOMATICA" ,NIL}}
*/  
//MSExecAuto({|x,y| Mata010(x,y)},aVetor,5)
 
If lMsErroAuto
 MostraErro()
Else
 Alert("Ok")
Endif
 
Return