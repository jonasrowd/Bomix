#include "PROTHEUS.ch"
#include "RESTFUL.ch"

#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute} => EndCase
#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise

WsRestful BaixaSaBomix Description "WebService REST para Baixa SA"

WsMethod POST Description "Sincronização de dados via POST" WsSyntax "/POST/{method}"

End WsRestful

WsMethod POST WsService BaixaSaBomix
Local cJson := ::GetContent()
Local oParser
Local aRet := {}, cRet, A , _cItem := "01"
local aCamposSCP  := {} , aCamposSD3 := {}
Local _aArea := GetArea()

::SetContentType( 'application/json' )

@{Route}
@{When '/baixasa'}

    If FwJsonDeserialize(cJson, @oParser)
    	BEGIN TRANSACTION

        //oParser:numero //Numero da SA
        //oParser:produto //Produto da SA
        //oParser:quantidade //Quantidade SA
        //oParser:lote //Numero do Lote

         
        For A:=1 To Len(oParser)

            _aArea:=GetArea()
        	
            dbSelectArea("scp")
            dbSetOrder(2)
            //If dbSeek( "010101" + oParser[A]:numero , .f. )   //+cItem)) 
            If dbSeek( "010101" + padr( oParser[A]:produto , 30 ) + oParser[A]:numero , .f. )   //+cItem))  
                _cItem := SCP->CP_ITEM
                //gera pré requisição 
                recLock("SCP",.F.)
                SCP->CP_PREREQU = "S"
                msUnlock()
                //
                dbSelectArea("SCQ")
                dbSetOrder(1)
                //If ! (  dbSeek( "010101" + oParser[A]:numero , .f. )   )  //+cItem))
                //If ! (  dbSeek( "010101" + padr( oParser[A]:numero , 6) + SCP->CP_ITEM     , .f. )  )  //+cItem))      
                    recLock("SCQ",.T.)
                    SCQ->CQ_FILIAL   = "010101"
                    SCQ->CQ_NUM      = SCP->CP_NUM
                    SCQ->CQ_NUMSQ    = "01"
                    SCQ->CQ_PRODUTO  = SCP->CP_PRODUTO
                    SCQ->CQ_DESCRI   = SCP->CP_DESCRI
                    SCQ->CQ_UM       = SCP->CP_UM
                    SCQ->CQ_SEGUM    = SCP->CP_SEGUM
                    SCQ->CQ_QTSEGUM  = SCP->CP_QTSEGUM
                    SCQ->CQ_QUANT    = val( oParser[A]:quantidade ) //SCP->CP_QUANT
                    SCQ->CQ_OBS      = ""
                    SCQ->CQ_LOCAL    = "AG"
                    SCQ->CQ_CONTA    = SCP->CP_CONTA
                    SCQ->CQ_ITEM     = SCP->CP_ITEM
                    SCQ->CQ_CC       = SCP->CP_CC
                    SCQ->CQ_DATPRF   = dDataBase
                    SCQ->CQ_QTDISP   = val( oParser[A]:quantidade ) //SCP->CP_QUANT
                    msUnlock()
                //Endif 
                
                dbSelectArea("scp")
                dbSetOrder(1)
                dbSeek( "010101" + oParser[A]:numero + _cItem  , .f. )   //+cItem)               
   
                dbSelectArea("SCQ")
                dbSetOrder(1)
                dbSeek( "010101" + oParser[A]:numero + _cItem , .f. )     //+cItem))
                
            
                aCamposSCP := { {"CP_NUM" , oParser[A]:numero ,Nil },;
                                {"CP_ITEM" , _cItem  ,Nil },;
                                {"CP_QUANT" , val( oParser[A]:quantidade ) ,Nil }}

                aCamposSD3 := { {"D3_TM" ,"501" ,Nil },; // Tipo do Mov.
                                {"D3_COD" ,  oParser[A]:produto  ,Nil },;
                                {"D3_LOCAL" , "AG"  ,Nil },;
                                {"D3_DOC" , oParser[A]:numero ,Nil },; // No.do Docto.
                                {"D3_LOTECTL" , oParser[A]:lote , Nil  },;
                                {"D3_USUARIO" , "proton" , Nil  },;
                                {"D3_EMISSAO" ,DDATABASE ,Nil }}
            Else
            	DisarmTransaction()
            	
            	Aadd(aRet,JsonObject():new())
            	nPos := Len(aRet)
            	aRet[nPos]['numero' ]  := oParser[A]:numero			
            	aRet[nPos]['produto' ] := oParser[A]:produto
				aRet[nPos]['status' ]  := "Erro"
                aRet[nPos]['message' ] := "Solicitacao não localizada"
                Exit
            Endif

            //Dados para atualização do vinculo com pms (opcional)
            aRelProj := {}
            aAdd(aRelProj,{})
            //aAdd(aRelProj[1],{"AFH_PROJET" ,"Projeto1  " ,Nil })
            //aAdd(aRelProj[1],{"AFH_TAREFA" ,"01.01       " ,Nil })
            //aAdd(aRelProj[1],{"AFH_QBAIX" ,1 ,Nil })

            aAdd(aRelProj,{})
            
            //aAdd(aRelProj[2],{"AFH_PROJ" ,"Projeto2  " ,Nil })
            //aAdd(aRelProj[2],{"AFH_TAREFA" ,"01.01       " ,Nil })
            //aAdd(aRelProj[2],{"AFH_QBAIX" ,2 ,Nil })

            Restarea(_aArea)

            lMSHelpAuto := .F.
            lMsErroAuto := .F.

            MSExecAuto({|v,x,y,z,w| mata185(v,x,y,z,w)},aCamposSCP,aCamposSD3,1,,aRelProj)   // 1 = "Baixar"  2 = "Estorno"  5 =  "Excluir"6 = "Encerrar"1 = BAIXA (ROT.AUT)

    
            If  ! (lMsErroAuto)  //InsertOK
                Aadd(aRet,JsonObject():new())
                nPos := Len(aRet)
                aRet[nPos]['numero' ]  := oParser[A]:numero				
                aRet[nPos]['produto' ] := oParser[A]:produto
                aRet[nPos]['status' ]  := "OK"
                aRet[nPos]['message' ] := "Sucesso"
                
                //
                If  !empty( oParser[A]:numero ) .and. !empty( oParser[A]:produto ) 
                	dbSelectArea("SD3")
                	dbSetOrder(2) //filial+doc+cod 
                	If dbSeek( "010101" + padr( oParser[A]:numero , 9 ) + alltrim( oParser[A]:produto )  , .f. )   //+cItem))      
        	          	while !eof() .and. SD3->D3_FILIAL == "010101" .and. alltrim(SD3->D3_DOC) == alltrim(oParser[A]:numero) .and. alltrim(SD3->D3_COD) == alltrim(oParser[A]:produto)      
        	          		If empty(SD3->D3_USUARIO)
        	          			recLock("SD3",.f.)
        	          			SD3->D3_USUARIO := "proton"
        	          			msUnlock()
        	          		Endif
        	          		
        	          		dbSelectArea("SD3")
        	          		dbSkip()
        	          	End
        	   	Endif   
              	Endif                     
                
               Restarea(_aArea)
               
            Else
                DisarmTransaction()
                cArqLog := "ErroWSBOmix.log"
                cErro := MostraErro("\log_ws", cArqLog)
                cErro := TrataErro(cErro) // –> Trata o erro para devolver para o client.
                
                Aadd(aRet,JsonObject():new())
                nPos := Len(aRet)
                aRet[nPos]['numero' ]  := oParser[A]:numero	
                aRet[nPos]['produto' ] := oParser[A]:produto
                aRet[nPos]['status' ]  := "Erro"
                aRet[nPos]['message' ] := cErro
                Exit
            EndIf
        Next A
        wrk := JsonObject():new()
        wrk:set(aRet)   
        ::SetResponse(wrk:toJSON())
        END TRANSACTION
    Else
        SetRestFault(400,'Ops')
        Return .F.
    EndIf
    


@{Default}
    SetRestFault(400,"Ops")
    Return .F.
@{EndRoute}

Return .T.


Static Function TrataErro(cErroAuto)

Local nLines   := MLCount(cErroAuto)
Local cNewErro := ""
Local nErr        := 0

For nErr := 1 To nLines
     cNewErro += AllTrim( MemoLine( cErroAuto, , nErr ) ) + " - "
Next nErr

Return(cNewErro)