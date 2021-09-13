#Include 'TOTVS.ch'
#Include 'xmlcsvcs.ch'
#Include 'XMLXFUN.CH'
#Define CRLF Chr(13) + Chr(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦ Programa ¦ LerXml   ¦ Autor ¦  Lincoln Vasconcelos  ¦ Data ¦ 24/04/18 ¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦Descrição ¦ Ler Xml dos eventos das Nfs, e retorna os valores em um vetor¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦ Uso      ¦ Armazem                                                    ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/  

/*/{Protheus.doc} LerXml
Leitura de XmlPath
@type function
@version 12.1.27
@author jonas.machado
@since 07/06/2021
/*/
User Function LerXml(cLocalXml, cTPSchem)

Local cError   := ''
Local cWarning := ''
Local cXml := ''
Local nHandle
Local nItens
Local aDadosXml := {}
Local aDadosIde := {} 
Local aDadosEmi := {} 
Local aDadosEnd := {} 
Local aItens    := {} 
Local aTotais   := {} 
Local aOutros   := {} 

Private oXml

nHandle := FT_FUSE(cLocalXml) // fecha o arquivo em aberto

If nHandle == -1
	Conout('Fonte |'+FunName()+'-LerXml| Linha |'+AllTrim(Str(ProcLine()))+'| falha ao abrir o arquivo: '+cLocalXml)
Else

	FT_FGOTOP() // Posiciona no 1º registro		
	While !FT_FEOF()
		cXml += FT_FReadln() // retorna a linha inteira
		FT_FSKIP() // pula uma linha do registro.
	End
	FT_FUSE() // fecha o arquivo em aberto	
	
	If FErase(cLocalXml) == -1
		Conout('Fonte |'+FunName()+'-LerXml| Linha |'+AllTrim(Str(ProcLine()))+'| falha na deleção do Arquivo: '+cLocalXml)		
	Else    				
		
		oXml := XmlParser( cXml, "_", @cError, @cWarning ) // Gera o Objeto XML
		
		If cTPSchem == '1' // ResNfe
	
			AADD(aDadosXml, oXml:_RESNFE:_CHNFE:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_CNPJ:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_CSITNFE:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_DHEMI:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_DHRECBTO:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_DIGVAL:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_IE:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_NPROT:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_TPNF:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_VERSAO:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_VNF:TEXT)
			AADD(aDadosXml, oXml:_RESNFE:_XNOME:TEXT)
			AADD(aDadosXml, cXml)		
		
		ElseIf cTPSchem == '2' // JProcNFe

			//Dados Gerais da Nf
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_CMUNFG:TEXT) // Município do fato.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_CNF:TEXT) // Código numérico da nota aleatório.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_CUF:TEXT) // Uf do emitente da nota.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT) // Data e hora da emissão
			AADD(aDadosIde, If(Type('oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHSAIENT:TEXT') == 'U',' ',oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHSAIENT:TEXT)) // Data e hora da saída e entrada.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_FINNFE:TEXT) // Finalidade da Nfe (1=NF-e normal; 2=NF-e complementar; 3=NF-e de ajuste; 4=Devolução de mercadoria).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_IDDEST:TEXT) // Id do destinatário (1=Operação interna; 2=Operação interestadual; 3=Operação com exterior).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_INDFINAL:TEXT) // Operação com o consumidor final (0=Normal; 1=Consumidor final).
			AADD(aDadosIde, If(Type('oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_INDPAG:TEXT') == 'U',' ',oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_INDPAG:TEXT)) // Indicador da forma de pagamento (0=Pagamento à vista; 1=Pagamento a prazo; 2=Outros).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_INDPRES:TEXT) // Indicador de presença do comprador no estabelecimento comercial no momento da operação, 1=Operação presencial; 2=Operação não presencial, pela Internet; 3=Operação não presencial, Teleatendimento; 4=NFC-e em operação com entrega a domicílio; 9=Operação não presencial, outros.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT) // Código do Modelo do Documento Fiscal, (55=NF-e emitida em substituição ao modelo 1 ou 1A; 65=NFC-e, utilizada nas operações de venda no varejo (a critério da UF aceitar este modelo de documento)).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT) // Descrição da Natureza da Operação.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT) // Número do Documento Fiscal.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_PROCEMI:TEXT) // Processo de emissão da NF-e, (0=Emissão de NF-e com aplicativo do contribuinte; 1=Emissão de NF-e avulsa pelo Fisco; 2=Emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco; 3=Emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT) // Serie da Nota.
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_TPAMB:TEXT) // Identificação do Ambiente, 1=Produção/2=Homologação.   
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT) // Tipo de Emissão da NF-e, (1=Emissão normal (não em contingência); 2=Contingência FS-IA, com impressão do DANFE em formulário de segurança; 3=Contingência SCAN (Sistema de Contingência do Ambiente Nacional); 4=Contingência DPEC (Declaração Prévia da Emissão em Contingência); 5=Contingência FS-DA, com impressão do DANFE em formulário de segurança; 6=Contingência SVC-AN (SEFAZ Virtual de Contingência do AN); 7=Contingência SVC-RS (SEFAZ Virtual de Contingência do RS)).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_TPNF:TEXT) // Tipo de Operação (0=Entrada; 1=Saída).
			AADD(aDadosIde, oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_VERPROC:TEXT) // Versão do Processo de emissão da NF-e.
		    	    	    
		    // Dados do endereço do emitente(Fornecedor)   
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT) // Cep do emitente.
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT) // Codigo do município do emitente.
			AADD(aDadosEnd, If(Type('oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CPAIS:TEXT') == 'U',' ',oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CPAIS:TEXT)) // Codigo do pais do emitente.    
			AADD(aDadosEnd, If(Type('oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT') == 'U',' ',oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT)) // Fone do emitente.
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT) // Numero.     
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT) // Uf do emitente.  
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT) // Bairro.
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT) // Logradouro. 
			AADD(aDadosEnd, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT) // Município.
			AADD(aDadosEnd, If(Type('oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XPAIS:TEXT') == 'U',' ',oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XPAIS:TEXT)) // Pais.
		    	    
			// Dados gerais do emitente(Fornecedor) da Nota fiscal.
			AADD(aDadosEmi, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT) // CNPJ do emitente.
			AADD(aDadosEmi, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CRT:TEXT) // Código de Regime Tributário, (1=Simples Nacional; 2=Simples Nacional, excesso sublimite de receita bruta; 3=Regime Normal. (v2.0)).
			AADD(aDadosEmi, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_IE:TEXT) // CNPJ do emitente.
			AADD(aDadosEmi, If(Type('oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XFANT:TEXT') == 'U',' ',oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XFANT:TEXT)) // Nome fantasia.
			AADD(aDadosEmi, oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT) // Razão Social ou Nome do emitente.		
			AADD(aDadosEmi, aDadosEnd) // Dados do endereço do emitente.
			
			If Type('oXml:_NFEPROC:_NFE:_INFNFE:_DET') <> 'A' // se vier apenas um item na nota.
			                 
				AADD(aItens, {oXml:_NFEPROC:_NFE:_INFNFE:_DET:_NITEM:TEXT,/*Número do item na Nf*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT,/*Código do produto no fornecedor*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT,/*Descrição do produto no fornecedor*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT,/*CFOP*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CEANTRIB:TEXT,/*Codigo de barras*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT,/*NCM do Produto*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT,/*Unidade do produto*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT,/*Quantidade do produto*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT,/*Valor unitário*/;
							  oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT/*Valor Total do produto*/;
				})		
			Else // Se vier vários itens na nota.
				For nItens := 1 To Len(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
					AADD(aItens, {oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_NITEM:TEXT,/*Número do item na Nf*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_CPROD:TEXT,/*Código do produto no fornecedor*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_XPROD:TEXT,/*Descrição do produto no fornecedor*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_CFOP:TEXT,/*CFOP*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_CEANTRIB:TEXT,/*Codigo de barras*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_NCM:TEXT,/*NCM do Produto*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_UCOM:TEXT,/*Unidade do produto*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_QCOM:TEXT,/*Quantidade do produto*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_VUNCOM:TEXT,/*Valor unitário*/;
								  oXml:_NFEPROC:_NFE:_INFNFE:_DET[nItens]:_PROD:_VPROD:TEXT/*Valor Total do produto*/;
					})
				Next nItens
			EndIf
		              
			// Dados dos totais da Nota
			AADD(aTotais, oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT) // Valor Total da NF-e.
			AADD(aTotais, oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT) // Base de Cálculo do ICMS.
			AADD(aTotais, oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT) // Valor Total do ICMS.    
			AADD(aTotais, oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPIS:TEXT) // Valor do Pis.
			AADD(aTotais, oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VCOFINS:TEXT) // Valor do Cofins.
			
			AADD(aOutros, oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT) // Chave da nota.
			AADD(aOutros, oXml:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT) // Data e hora do recebimento.
			AADD(aOutros, oXml:_NFEPROC:_VERSAO:TEXT) // Versão da XML.			
			
			aDadosXml := {aDadosIde, aDadosEmi, aItens, aTotais, aOutros, cXml}
		
		ElseIf cTpSchem == '3' // ResEvento
		
			AADD(aDadosXml, oXml:_RESEVENTO:_CHNFE:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_CNPJ:TEXT)
			AADD(aDadosXml,	oXml:_RESEVENTO:_CORGAO:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_DHEVENTO:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_DHRECBTO:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_NPROT:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_NSEQEVENTO:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_TPEVENTO:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_VERSAO:TEXT)
			AADD(aDadosXml, oXml:_RESEVENTO:_XEVENTO:TEXT)
			AADD(aDadosXml, cXml)
		
		ElseIf cTPSchem == '4' // ProcEventoNfe
		
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CHNFE:TEXT)
			If Type('oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CNPJ:TEXT') <> 'U'
				AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CNPJ:TEXT)
			Else
				AADD(aDadosXml,' ')
			EndIf
			AADD(aDadosXml,	oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CORGAO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_DESCEVENTO:TEXT)
			If Type('oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_NPROT:TEXT') <> 'U'
				AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_NPROT:TEXT) 
			Else
				AADD(aDadosXml,' ')			
			EndIf                                                                  
			If Type('oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_XJUST:TEXT') <> 'U'
				AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_XJUST:TEXT)
			Else
				AADD(aDadosXml,' ')			
			EndIf
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DHEVENTO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_NSEQEVENTO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_TPAMB:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_TPEVENTO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_VEREVENTO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CHNFE:TEXT)   
			If Type('oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CNPJDEST:TEXT') <> 'U'
				AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CNPJDEST:TEXT)
			Else                          
				AADD(aDadosXml,' ')
			EndIf	
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CORGAO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_DHREGEVENTO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_NPROT:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_NSEQEVENTO:TEXT) 
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_TPAMB:TEXT) 
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_VERAPLIC:TEXT)
			AADD(aDadosXml, oXml:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT)	
			AADD(aDadosXml, cXml)
					
		EndIf	
	
	EndIf

EndIf
	
Return aDadosXml
