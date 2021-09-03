#include "Totvs.ch"
#include "Tbiconn.ch"

/*/{Protheus.doc} CCIMOEDA
    Função utilizada para buscar a Cotação da moeda na API do Banco Central
    @type       function
    @author     lucas Silva Vieria
    @since      30/07/2021
    @version    1.0
    @sample        U_CCIMOEDA()
    @url https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/documentacao
 /*/  

User function CCIMOEDA()
	Local cBase     := 'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata'
	Local cUrl      := ''
	Local cGetParms := ''
	Local nTimeOut  := 200
	Local aHeadStr  := {'Content-Type: application/json'}
	Local cHeadGet  := ''
	Local cRet      := ''
	Local aIdMoeda  := {'USD', 'CHF', 'EUR'} //ARRAY COM MOEDAS
	Local cDtCot    := '' //MM-DD-AAAA
	Local oJObj     := ''
	Local cJRet     := ''
	Local cCotacao  := ''
	Local nY        := ''

	//Ajusta Padrão da Data para MM-DD-AAAA - cDtCot := '07-29-2021'
	cDtCot := DToS(dDataBase-1)
	cDtCot := SubStr(cDtCot,5,2) + '-' + SubStr(cDtCot,7,2) + '-' + SubStr(cDtCot,1,4)
    
    RpcSetEnv("30","302030","lvieira","251213","FIN","MATA090",{"SM2"})

	FOR nY := 1 TO LEN(aIdMoeda)
		//[GET] Consulta Dados na Api Olinda
        oJObj   := JsonObject():New()
		cUrl := cBase
		cUrl += "/CotacaoMoedaPeriodoFechamento(codigoMoeda=@idMD,dataInicialCotacao=@dtIniCt,dataFinalCotacao=@dtFinCt)"
		cUrl += "?@idMD='"+aIdMoeda[nY]+"'&@dtIniCt='"+cDtCot+"'&@dtFinCt='"+cDtCot
		cUrl += "'&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"

		cRet := HTTPGet( cUrl , cGetParms, nTimeOut, aHeadStr, @cHeadGet )

		cJRet := oJObj:FromJson(cRet)

		If ValType(cJRet) == 'U' //NIL
			//Valida se a Cotação esta liberada para o dia - oJObj:hasProperty("value")
			If Len(oJObj["value"]) > 0

                cMoeda := aIdMoeda[nY]
				nValorAtu := cValToChar(oJObj["value"][1]["cotacaoCompra"]) 

				cCotacao  += aIdMoeda[nY] + "|" 
				cCotacao  += nValorAtu  + "|" 

			EndIf
			FreeObj(oJObj)
		Else
			ConOut("Ocorreu erro no processamento do Json" + CRLF+CRLF + cJRet, ':: Cotação Moeda PTAX - BC API Olinda ::')
		EndIf
	NEXT
    aMoedaAtual := StrTokArr(cCotacao, '|')
    If Empty(aMoedaAtual) == .F.
     DbSelectArea("SM2")
	    If !DbSeek(DtoS(DATE()) )
            RecLock("SM2",.T.)
            SM2->M2_DATA    := DATE() //DATA DA INCLUSÃO
            SM2->M2_DCOTAC  := DToS(DATE()-1) //DATA DE COTAÇÃO
	    Else
            RecLock("SM2",.F.)
	    Endif
            SM2->M2_MOEDA2 := Val(aMoedaAtual[2]) //USD
            SM2->M2_MOEDA3 := 1.0641              //UFIR  
            SM2->M2_MOEDA4 := Val(aMoedaAtual[6]) //EUR 
            SM2->M2_MOEDA5 := Val(aMoedaAtual[4]) //CHF 
            MsUnlock("SM2")
        ConOut("Tabela SM2 -> Moedas atulizado com sucesso.")            
    EndIf
Return
