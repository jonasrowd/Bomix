#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"

/*/{Protheus.doc} MT110ROT()
// Ponto de entrada disparado No inico da rotina e antes da execução da Mbrowse da SC
// , utilizado para adicionar mais opções no aRotina.
// Este ponto de entrada pode ser utilizado para inserir   
// novas opções no array aRotina.
@author carlo
@since 02/12/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function MT110ROT()
//Define Array contendo as Rotinas a executar do programa     
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transa‡„o a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs     

If Findfunction("u_FCOMA007")
	aAdd(aRotina,{ 'Fluig SC(c)'	, 	'u_FCOMA007("SC")'	,0,6,}) 
Endif

Return
