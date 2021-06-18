#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
 Funcao:  MT120COR
 Autor:  Marinaldo de Jesus
 Descricao: Implementacao do Ponto de Entrada MT120COR executado na funcao MATA120
    do programa MATA120 Tratamento de cores na mBrowse
/*/
User Function MT120COR()

 Local aCores  := ParamIxb[1] //Obtenho a Legenda padrao
 
* Local cC7XCTNCNB := Space( GetSx3Cache( "C7_XCTNCNB" , "X3_TAMANHO" ) ) //Tratamento especifico para novos elementos

 //Testo o Tipo
 IF !( ValType( aCores ) == "A" )
  aCores := {}
 EndIF

 /*/
  
  Se necessario, adiciono novos elementos aa Legenda Padrao
    
  aAdd( aCores , { "C7_XCNTSOL .and. !C7_XCNTADT .and. C7_XCTNCNB == '" +cC7XCTNCNB + "'"    , "RNPSOLICITACNT_16" } )  //"Solicitação de Contrato"
  aAdd( aCores , { "C7_XCNTSOL .and. C7_XCNTADT .and. C7_XCTNCNB == '" +cC7XCTNCNB + "'"    , "RNPADITIVOCNT_16" } )  //"Solicitação de Aditivo"
  aAdd( aCores , { "C7_CONAPRO=='B' .and. C7_XCTNCNB &lt;&gt; '" +cC7XCTNCNB + "' .and. C7_QUJE&gt;=C7_QUANT" , "BPMSDOCA_16"   } )  //"Bloqueado por Contrato"
  aAdd( aCores , { ".F."                     , "CADEADO_16"   } )  //"Bloqueado por Orçamento"
  
 /*/  
 
 //Verifico se estou querendo, apenas, as informacoes da Legenda
 IF IsInCallStack( "GetC7Status" )
  //"Roubo"/Recupero as Informacoes da Legenda de Cores
  __aColors_ := aCores
  //Forco o Erro
  UserException( "IGetC7Status" )
 EndIF

Return( aCores )

/*/
 Funcao:  GetC7Status
 Autor:  Marinaldo de Jesus
 Descricao: Retornar o Status da SC7 conforme Array de Cores da mBrowse
 Sintaxe: StaticCall( U_MT120COR , GetC7Status , cAlias , cResName , lArrColors )
/*/
Static Function GetC7Status( cAlias , cResName , lArrColors )

 Local bGetColors := { || Mata120() }
 Local bGetLegend := { || A120Legenda() }

 DEFAULT cAlias   := "SC7"

Return( StaticCall( u_mBrowseLFilter , BrwGetSLeg , @cAlias , @bGetColors , @bGetLegend , @cResName , @lArrColors ) )

/*/
 Funcao:  __Dummy
 Autor:  Marinaldo de Jesus
 Data:  22/04/2011
 Descricao: __Dummy (nao faz nada, apenas previne warning de compilacao)
 Sintaxe: 
 
/*/
Static Function __Dummy( lRecursa )
 Local oException
 TRYEXCEPTION
  DEFAULT lRecursa := .F.
  IF !( lRecursa )
   BREAK
  EndIF
  GetC7Status()
  lRecursa := __Dummy( .F. )
 CATCHEXCEPTION USING oException
 ENDEXCEPTION
Return( lRecursa )

