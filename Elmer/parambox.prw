    Documentação : http://tdn.totvs.com/display/public/mp/Parambox

Local     aPergs := {}
Local     aRet := {}
Local     cBoxProd := SPACE(15)
     
aAdd(aPergs,{1,"Codigo do Produto"             ,cBoxProd   ,""                 ,"","SB1"     ,"", 60,.T.}) // MV_PAR01
aAdd(aPergs,{1,"Capacidade da Caixa Master" ,0                ,"@E 9999.99"   ,"",""        ,"", 60,.T.})     // MV_PAR02
aAdd(aPergs,{1,"Quantidade de etiquetas"     ,0            ,"@E 9999.99"   ,"",""        ,"", 60,.T.})     // MV_PAR03

// 1 - MsGet [ParamBox]
// [2] : Descrição
// [3] : String contendo o inicializador do campo
// [4] : String contendo a Picture do campo
// [5] : String contendo a validação
// [6] : Consulta F3
// [7] : String contendo a validação When
// [8] : Tamanho do MsGet
// [9] : Flag .T./.F. Parâmetro Obrigatório ?

     If ParamBox(aPergs ,"Parametros ",aRet)
          EAN14PRO(cTitulo) // Chama o Programa
     Else
          Return()
     EndIf
