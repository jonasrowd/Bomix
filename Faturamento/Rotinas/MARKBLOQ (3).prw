#include "rwmake.ch"
#include "topconn.ch"
#include "msobject.ch"
#include "protheus.ch"

/*/{Protheus.doc} MARKBLQ1
Tela para bloqueio de clientes inativos
@author Elmer Farias
@since 06/08/20
@version 1.0
	@example
	u_MARKBLQ1()
	Solicitado pelo Chamado GLPI: 2394
/*/


User Function MARKBLQ1

	//Declaracao de Variaveis                                             
    cPerg := "BLQCLI"
	Private cCadastro := "Bloqueio Clientes Inativos"
	Private cCodAnl  := "          "
    Private cString  := "TRB"
	Private _cArq
	Private aStru := {}
	
	
	//Monta um aRotina proprio                                            
	
	aRotina := {}
    
    aAdd(aRotina, {"Bloqueio Clientes"      ,"U_Bloqueio", 0, 2})
    aAdd(aRotina, {"Marcar Todos"           ,"U_MARQUE", 0, 3})
    aAdd(aRotina, {"Desmarcar Todos"        ,"U_DESMARK", 0, 4})
    aAdd(aRotina, {"Desbloquear Clientes"   ,"U_DesBloq", 0, 5})
	aAdd(aRotina, {"Visualizar"             ,"U_BVisual", 0, 6})
	aAdd(aRotina, {"Pesquisar"              ,"AxPesqui", 0, 7})


	If ! Pergunte(cPerg, .T.)
		Return .F.
	Endif

	
	 AADD(aStru,{"A1_OK"       ,"C",2,0})
     AADD(aStru,{"A1_COD"      ,"C",6,0})
     AADD(aStru,{"A1_NOME"     ,"C",30,0})
     AADD(aStru,{"A1_LOJA"     ,"C",2,0})
	 AADD(aStru,{"ULT_COMP"    ,"D",8,0})
     AADD(aStru,{"EMIS_TIT"    ,"D",8,0})
     AADD(aStru,{"VENC_TIT"    ,"D",8,0}) 


	//  Cria um arquivo temporario para a Query...
 	/*
 	_cArq := criaTrab(aStru) 
	dbCreate(_cArq, aStru)

	dbUseArea(.T.,, _cArq, cString, .F.,.F.)
	*/
	
	_cArq := CriaTrab(aStru,.T.)
	
	cIndA := substr(_cArq,1,7) + "A"
	cIndB := substr(_cArq,1,7) + "B"
	
	USE &_cArq Shared ALIAS TRB NEW

	//Set Key VK_F12 To TPerg()
	//Set Key VK_F5  To CarregaDados()

	Private cMarca := GetMark()

	Private aCampos := {}
	
	 AADD(aCampos,{"A1_OK"      ,,"  "})
     AADD(aCampos,{"A1_COD"     ,,"Cod. Cliente"})
     AADD(aCampos,{"A1_NOME"    ,,"Nome Cliente"})
     AADD(aCampos,{"A1_LOJA"    ,,"Loja"})
     AADD(aCampos,{"ULT_COMP"   ,,"Ultima Compra"})
     AADD(aCampos,{"EMIS_TIT"   ,,"Emissao Tit Receber"})
     AADD(aCampos,{"VENC_TIT"   ,,"Vencto. Tit Receber"})

	CarregaDados( 0 )
	dbSelectArea(cString)

	markBrow( cString, 'A1_OK', , aCampos,, cMarca, 'U_TMarkAll()',,,,'U_TMark()',,,, )

	dbCloseArea(cString)
	fErase( _cArq + getDBExtension() )
	fErase( _cArq + ordBagExt() )

Return
 

Static Function CarregaDados( Reg )

//Local nRecno
	
cQry := " SELECT A1.A1_COD "
cQry += " , A1.A1_NOME "
cQry += " , A1.A1_LOJA  "
cQry += " , ISNULL(A1.A1_ULTCOM,0)  ULT_COMP"
cQry += " , ISNULL(E1.E1_EMISSAO,0) EMIS_TIT "
cQry += " , ISNULL(E1.E1_VENCTO,0) VENC_TIT "
cQry += " , A1.A1_OK "
cQry += " FROM " + RetSqlName("SA1") + " A1 " 
cQry += " LEFT JOIN " + RetSqlName("SE1") + " E1 "  
cQry += " ON  LEFT (E1.E1_FILIAL,4) = A1.A1_FILIAL "  
cQry += " AND E1.E1_CLIENTE = A1.A1_COD " 
cQry += " AND E1.E1_LOJA = A1.A1_LOJA "
cQry += " AND E1.D_E_L_E_T_ <> '*' "
cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 "
cQry += " ON  C5.C5_FILIAL = E1.E1_FILIAL " 
cQry += " AND C5.C5_CLIENTE = E1.E1_CLIENTE " 
cQry += " AND C5.C5_LOJACLI = E1.E1_LOJA "
cQry += " AND C5.C5_NUM = E1.E1_PEDIDO "
cQry += " AND C5.D_E_L_E_T_ <> '*' "
cQry += " LEFT JOIN " + RetSqlName("SC6") + " C6 "
cQry += " ON C6.C6_FILIAL = C5.C5_FILIAL "
cQry += " AND C6.C6_NUM = C5.C5_NUM "
cQry += " AND C6.C6_CLI = C5.C5_CLIENTE "   
cQry += " AND C6.C6_LOJA = C5.C5_LOJACLI "  
cQry += " AND C6.D_E_L_E_T_ <> '*' "
cQry += " LEFT JOIN " + RetSqlName("SCJ") + "  CJ "
cQry += " ON  CJ.CJ_FILIAL = C6.C6_FILIAL "  
cQry += " AND CJ.CJ_LOJA = C6.C6_LOJA "
cQry += " AND CJ.CJ_CLIENT = C6.C6_CLI "
cQry += " AND CJ.CJ_NUM = C6.C6_NUMORC "
cQry += " AND CJ.D_E_L_E_T_ <> '*' "
cQry += " WHERE EXISTS ( "
cQry += "  SELECT MAX(C51.C5_EMISSAO) "
cQry += "  FROM  SC5010 C51 "
cQry += "  WHERE C51.C5_CLIENTE = E1.E1_CLIENTE "  
cQry += "  AND   C51.C5_LOJACLI = E1.E1_LOJA "     
cQry += "  AND   C51.C5_EMISSAO <= E1.E1_EMISSAO "   
cQry += "  AND   C51.C5_FILIAL = E1.E1_FILIAL "  
cQry += "  AND   C51.D_E_L_E_T_ <>'*') "
cQry += "  AND E1.E1_BAIXA = ' ' "
cQry += "  OR E1.E1_STATUS = 'A' "
cQry += "  AND C5.C5_NOTA = ' ' "
cQry += "  AND C6.C6_NOTA = ' ' "
cQry += "  AND A1.D_E_L_E_T_ <> '*' "
cQry += "  AND CJ.CJ_STATUS IN ('C','D') "
cQry += "  AND A1.A1_MSBLQL <> '1' "
cQry += "  AND A1.A1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " 
cQry += "  AND A1.A1_ULTCOM BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' " 
cQry += "  GROUP BY "
cQry += "  A1.A1_COD "
cQry += " ,A1.A1_NOME "
cQry += " ,A1.A1_LOJA "
cQry += " ,A1.A1_ULTCOM "
cQry += " ,E1.E1_EMISSAO "
cQry += " ,E1.E1_VENCTO "
cQry += " ,A1.A1_OK "
TCQUERY cQry New Alias "TMDD"


	/*If select(cString) > 0
		dbSelectArea(cString)
		ZAP
	EndIf  */

	dbSelectArea("TMDD")

	While !Eof()
		dbSelectArea(cString)
		RecLock(cString, .T.)

            TRB->A1_OK         := TMDD->A1_OK
			TRB->A1_COD  	   := TMDD->A1_COD
			TRB->A1_NOME 	   := TMDD->A1_NOME
			TRB->A1_LOJA	   := TMDD->A1_LOJA	
			TRB->ULT_COMP      := StoD(TMDD->ULT_COMP) 
			TRB->EMIS_TIT      := StoD(TMDD->EMIS_TIT)	
			TRB->VENC_TIT      := StoD(TMDD->VENC_TIT) 
					
		MsUnlock()
		dbSelectArea("TMDD")
		dbSkip()
	EndDo

	dbSelectArea("TMDD")
	lRet := IIf( ! TMDD->( EOF() ), .T., .F. )
	TMDD->( dbCloseArea() )

	dbSelectArea(cString)
    If ( Reg == 0 )
		TRB->( dbGotop() )
	Else
		TRB->( dbGotop() )
		TRB->( dbGoTo(Reg) )

	Endif

Return ( lRet )



// Grava marca no campo
User Function TMark()

	If IsMark( "A1_OK", cMarca )
		RecLock( cString, .F. )
		Replace A1_OK With Space(2)
		MsUnLock()
	Else
		RecLock( cString, .F. )
		Replace A1_OK With cMarca
		MsUnLock()
	EndIf

Return



// Grava marca em todos os registros validos
User Function TMarkAll()

Local nRecno := Recno()

	dbSelectArea(cString)
	dbGotop()
	While !Eof()
		U_TMark()
		dbSkip()
	End
	dbGoto( nRecno )

Return  


Static Function DeleteMarcacao (cChave)
//DELETAR O REGISTRO DA TABELA TEMPORARIA/ 

DbSelectArea("TRB")
TRB->(dbgotop())
DbSetOrder(1)
DbSeek(trim(cChave))
If !EOF("TRB") 
	RecLock( cString, .F. )
		TRB->( DbDelete() )
	MsUnLock()
Endif

Return


// Função para marcar todos os registros do browse

User Function Marque()                              
Local oMark := GetMarkBrow()


While !Eof()	
  IF RecLock( cString, .F. )		
       Replace A1_OK With cMarca		
      MsUnLock()	
  EndIf	
  
  dbSkip()
Enddo

// atualiza o browse
MarkBRefresh( )      		
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()	

return


// Função para desmarcar todos os registros do browse

User Function DesMark()
Local oMark := GetMarkBrow()

While !Eof()	
  IF RecLock( cString, .F. )		
     Replace A1_OK With SPACE(2)		
     MsUnLock()	
  EndIf	
  
  dbSkip()
Enddo

// atualiza o browse
MarkBRefresh( )		

// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()	
Return


User Function Bloqueio ()

Local aAreaAnt := GetArea()

DbSelectArea("TRB")
DbGotop()
While !eof()

If IsMark( 'A1_OK', cMarca )
	DbselectArea("SA1")
	DbsetOrder(1)
	IF DbSeek(xFilial("SA1")+TRB->A1_COD+TRB->A1_LOJA) 
	    RecLock( "SA1", .F. )
	       SA1->A1_MSBLQL := "1"
	    MsUnlock()
	Endif
endif

DbSelectArea("TRB")
DbSkip()
Enddo

alert("Cliente Bloqueado com Sucesso!")

RestArea(aAreaAnt)

Return   


User Function DesBloq ()

Local aAreaAnt := GetArea()

DbSelectArea("TRB")
DbGotop()
While !eof()

If IsMark( 'A1_OK', cMarca )
	DbselectArea("SA1")
	DbsetOrder(1)
	IF DbSeek(xFilial("SA1")+TRB->A1_COD+TRB->A1_LOJA) 
	    RecLock( "SA1", .F. )
	       SA1->A1_MSBLQL := "2"
	    MsUnlock()
	Endif
endif

DbSelectArea("TRB")
DbSkip()
Enddo

alert("Cliente Desbloqueado com Sucesso!")

RestArea(aAreaAnt)

Return 


User Function BVisual(cAlias,nReg,nOpc)
	Local nOpcao := 0
	Private cAlias 	:= "SA1"
	
	dbSelectArea(cAlias)
    dbSetOrder(1)
	
	nOpcao := AxVisual(cAlias,nReg,nOpc)

Return