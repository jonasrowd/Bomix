	#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "SHELL.CH"

/*/{Protheus.doc} PCOMR001
Impressao do Mapa de Cotacao
@author Francisco
@since 11/11/2016
@version 11.80
@param c_NumCot, characters, numero da cotacao
@param c_Arquivo, characters, nome do arquivo
@param c_PRoot, characters, caminho para salvar o arquivo
@param c_PComp, characters, caminho completo para salvar o arquivo
@param l_Ret, logical, controle da variavel l_RetArray
@type function
/*/
User Function PCOMR001(c_NumCot, c_Arquivo, c_PRoot, c_PComp, l_Ret, lFluig)

	c_Perg := "PCOMR001"
	Criaperg()
	c_Fil := xFilial("SC8")
	a_Forn := {}
	c_Comprador := ""
	c_CodCom := ""
	n_ValCDesc := 0
	c_Caminho := ""

	Default lFluig	:=	.F.

	Private a_ArrayRet	:=	{}//Array(3)

	Private   l_RetArray	:= .F.
	If l_Ret
		l_RetArray	:=	l_Ret
	Endif

	//alert(cValToChar(l_RetArray))

	Private	c_Arq				:=	""
	If !empty(c_Arquivo)
		c_Extensao := Alltrim(SuperGetMv( "FS_EXTCOT" , .F. , ".html" ,  ))
		c_Arq	:=	"cotacao_" + c_Arquivo + c_Extensao
	Endif

	Private	c_Pasta			:=	""
	If !Empty(c_PRoot)
		c_Pasta	:=	c_PRoot
	Endif

	Private	c_PastaCompleta	:=	""
	If !empty(c_PComp)
		c_PastaCompleta	:=	c_PComp
	Endif

	If Empty( c_NumCot ) .And. lFluig
		Return()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamar funcao para validacao de CNPJ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private o_vldTemp  	 := clsVldTemplate():new()

	/*If	!o_vldTemp:mtdMapaCotacaoExcel()

		RestArea(a_SD1Area)
		RestArea(a_SF1Area)
		RestArea(a_SC7Area)
		RestArea(a_SB1Area)
		RestArea(a_SA5Area)
		RestArea(a_SA1Area)
		RestArea(a_SA2Area)

		Alert("Empresa não autorizada")

		Return()

	Endif*/

	If ValType(c_NumCot) == "C" //Alterado em 08/11/16 para permitir geracao de arquivo e integração via fluig
		If FUNNAME() == "MATA160"
			Pergunte(c_Perg,.F.)
			If	Empty(c_NumCot)
				MV_PAR01 :=	SC8->C8_NUM
				MV_PAR02 := "C:\TEMP"
			Else
				MV_PAR01 := c_NumCot
				MV_PAR02 := "FABRICATOTVSBA\pedido_compra\"
			Endif
			Processa( {|| Obt_Dados() },"Selecionando Registros - Aguarde")
			If	Len(a_Forn) > 0
				//Processa( {|| Planilha() },"Gerando planilha - Aguarde")
				Processa( {|| Planilha(c_Arq, c_Pasta, c_PastaCompleta, l_RetArray) },"Gerando planilha - Aguarde")
			Endif
		ElseIf !Empty(c_Pasta) .And. !Empty(c_PastaCompleta) .And. !empty(c_Arq)

			//Alert(c_NumCot)

			MV_PAR01 :=	c_NumCot
			MV_PAR02 := 	Iif(Empty(c_Pasta), "FABRICATOTVSBA\pedido_compra\",c_PastaCompleta)
			If l_RetArray
				AADD(a_ArrayRet, c_Pasta )
				AADD(a_ArrayRet, c_Arq )
				AADD(a_ArrayRet, c_PastaCompleta )
			Endif
			Processa( {|| Obt_Dados() },"Selecionando Registros - Aguarde")
			If	Len(a_Forn) > 0
				//Processa( {|| Planilha() },"Gerando planilha - Aguarde")
				a_ArrayRet	:=	Planilha(c_Arq, c_Pasta, c_PastaCompleta, l_RetArray)
			Endif

		Else
			Alert("Parâmetros não informados")
			Conout("ROTINA PCOMR001: Parâmetros não informados")
			Return
		Endif
	Else

		If	Pergunte(c_Perg,.T.)=.T.
			If	Empty(MV_PAR02)
				Alert("Preencha o parâmetro Local geração arquivo.")
				Return
			Endif
			Processa( {|| Obt_Dados() },"Selecionando Registros - Aguarde")
			If	Len(a_Forn) > 0
				//Processa( {|| Planilha() },"Gerando planilha - Aguarde")
				Processa( {|| Planilha(c_Arq, c_Pasta, c_PastaCompleta, l_RetArray) },"Gerando planilha - Aguarde")
			Endif
		Endif

	Endif

Return(a_ArrayRet)

Static Function Obt_Dados()

	IIf(Select('aQry')>0,aQry->(dbCloseArea()),Nil)
	cQry := " SELECT DISTINCT C8_FORNECE, C8_LOJA, C8_VALIDA, C8_NUMPRO, A2_NREDUZ, A2_EST, C8_VALFRE, C8_DESPESA
	cQry += " FROM "+RetSqlName("SC8")+" SC8 "
	cQry += " INNER JOIN "+RetSqlName("SA2")+"  SA2 ON (C8_FORNECE = A2_COD AND C8_LOJA = A2_LOJA AND A2_FILIAL = SUBSTRING(C8_FILIAL,1,4) AND SA2.D_E_L_E_T_ = '')
	cQry += " WHERE SC8.D_E_L_E_T_ = ''
	cQry += " AND C8_FILIAL = '"+c_Fil+"'"
	cQry += " AND C8_NUM = '"+MV_PAR01+"'"
	cQry += " ORDER BY C8_FORNECE
	TCQUERY cQry NEW ALIAS "aQry"

	DbSelectArea("aQry")
	DbGoTop()
	If	Eof()
		Alert("Cotação não encontrada!")
		DbCloseArea("aQry")
		Return
	Endif
	n_CHR := 65
	Do	While !Eof()

		/* 07/11/16 - identificando a zorra da matriz
		[01]	Fornecedor
		[02]	Loja
		[03]	Codigo - Fantasia - Estado do fornecedor
		[04] 	???
		[05]	???
		[06]	???
		[07]	???
		[08]	???
		[09]	???
		[10]	???
		[11]	???
		[12]	Validade da cotação
		[13]	Numero da proposta
		[14]   Coluna do fornecedor na cotação
		[15]   Total da melhor oferta por fornecedor
		[16]   Valor frete
		[17]   Despesas

		*/
		c_COLUNA := CHR(n_CHR)
		n_CHR++
		AADD(a_Forn, {C8_FORNECE, C8_LOJA, C8_FORNECE +" - "+ Alltrim(A2_NREDUZ)+" - "+A2_EST,0,'','',0,0,'','','',DTOC(STOD(C8_VALIDA)),C8_NUMPRO,c_COLUNA, 0, C8_VALFRE, C8_DESPESA})

		DbSkip()
	Enddo
	DbCloseArea("aQry")

	//OBTER O COMPRADOR
	cCQry := "SELECT Y1_COD,Y1_NOME FROM "+RetSqlName("SY1")+" SY1 "
	cCQry += "	INNER JOIN "+RetSqlName("SC1")+" SC1 ON SC1.C1_CODCOMP = SY1.Y1_COD AND SY1.Y1_FILIAL = SUBSTRING(SC1.C1_FILIAL,1,4) AND SC1.C1_COTACAO = '"+MV_PAR01+"' AND SC1.D_E_L_E_T_ <> '*'  "
	cCQry += "	WHERE SY1.D_E_L_E_T_ <> '*'"
	TCQUERY cCQry NEW ALIAS "aCQry"
	DbSelectArea("aCQry")
	DbGoTop()
	If !Eof()
		c_Comprador := Y1_NOME
		c_CodCom	:= Y1_COD
	Endif
	DbCloseArea("aQry")
	//FIM OBTER COMPRADOR

	//CORRIGIDO EM 09/11/2016
	// Incluido JOIN SC1 (Utilizado para buscar decrição do produto customizada)
	cQry := " SELECT DISTINCT C8_PRODUTO, C8_ITEM = MAX(C8_ITEM), C1_DESCRI B1_DESC, '' C8_FSPARTN, C8_QUANT, C8_UM, B1_UCOM, B1_UPRC, B1_IPI, '' C1_FSSTAT, C8_NUMSC, C8_ITEMSC, '' AS EQUIP, C1_OBS AS OBS "
	//cQry := " SELECT DISTINCT C1_CC, C1_ITEMCTA, C8_PRODUTO, C8_ITEM, B1_DESC, '' C8_FSPARTN, C8_QUANT, C8_UM, B1_UCOM, B1_UPRC, '' C1_FSSTAT, C8_NUMSC, C8_ITEMSC, '' AS EQUIP "
	cQry += " FROM "+RetSqlName("SC8")+" SC8 "
	cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (C8_PRODUTO = B1_COD AND SB1.B1_FILIAL = SUBSTRING(SC8.C8_FILIAL,1,4) AND SB1.D_E_L_E_T_ = '') "
	cQry += " INNER JOIN "+RetSqlName("SC1")+" SC1 ON (SC1.C1_FILIAL = SC8.C8_FILIAL AND SC1.C1_COTACAO = SC8.C8_NUM AND SC1.C1_ITEM = SC8.C8_ITEMSC AND SC1.C1_NUM = SC8.C8_NUMSC  AND SC1.D_E_L_E_T_ = '') "
	//cQry += " LEFT JOIN "+RETSQLNAME("STJ")+" STJ ON (STJ.TJ_ORDEM = SC1.C1_OS AND STJ.D_E_L_E_T_ <> '*') "
	cQry += " WHERE SC8.D_E_L_E_T_ = '' "
	cQry += " AND C8_FILIAL = '"+c_Fil+"'"
	cQry += " AND C8_NUM = '"+MV_PAR01+"'"
	//Group By adicionado para impedir duplicação de itens no mapa de cotação gerado pela P12 na FJC. 13/11/2017 - inicio
	cQry += " GROUP BY 
	cQry += " 		C8_PRODUTO	"
	cQry += " 		, C1_DESCRI	"
	cQry += " 		, C8_QUANT	"
	cQry += " 		, C8_UM		"
	cQry += " 		, B1_UCOM	"
	cQry += " 		, B1_UPRC	"
	cQry += " 		, B1_IPI	"
	cQry += " 		, C8_NUMSC	"
	cQry += " 		, C8_ITEMSC	"
	cQry += " 		, C1_OBS	"
	//Group By adicionado para impedir duplicação de itens no mapa de cotação gerado pela P12 na FJC. 13/11/2017 - fim
	cQry += " ORDER BY C8_NUMSC, C8_ITEMSC "
	TCQUERY cQry NEW ALIAS "aQry"

Return

Static Function Planilha()

	cTime := TIME() // Resultado: HH:MM:SS
	cHora := SUBSTR(cTime, 1, 2) // Resultado: HH
	cMinutos := SUBSTR(cTime,4, 2) // Resultado: MM
	cTime := cHora+":"+cMinutos
	n_Quant := 0
	c_Motivo := ""

	//Adicionado em 08/11/16 - Tabela com dados finais da cotação
	n_TSelec		:=	0	//Total selecionado na cotacao
	n_TgerPC		:=	0	//TOTAL GERAL PC					=	TOTAL DE TODAS AS FILIAIS
	n_TdescPC		:=	0	//TOTAL DESCONTO PC				=	TOTAL DE DESCONTO DE TODAS AS FILIAIS
	n_TGdescPC		:=	0	//TOTAL GERAL PC COM DESCONTO	=	TOTAL DE TODAS AS FILIAIS COM DESCONTO
	n_TGOferta		:=	0	//TOTAL GERAL MELHOR OFERTA		=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
	n_Diferenca	:=	0	//Diferença						=	VARIACAO DO TOTAL COM DESCONTO E TOTAL DA MELHOR OFERTA DE TOTAL DE TODAS AS FILIAIS


	// Monta HTML formatado para o EXCEL - Cabecalho Excel

	cTexto := ' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	cTexto += ' <html xmlns="http://www.w3.org/1999/xhtml">
	cTexto += ' <head>
	cTexto += ' <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	cTexto += ' <title>Mapa de Coleta de Precos</title>
	cTexto += ' </head>

	cTexto += ' <body>

	cTexto += ' <table width="1232px" style="width: 1232px;" border="0"> '
	cTexto += '   <tr><td><div align="right">&nbsp;</div></td></tr> '
	cTexto += '   <tr><td><div align="right">&nbsp;</div></td></tr>'
	cTexto += '   <tr> '
	cTexto += '     <td colspan="6"><p align="center"><font face="Verdana" size="5"><B>MAPA DE COLETA DE PRE&Ccedil;OS</B></font></p></td> '
	cTexto += '     <td><p align="left"><font face="Verdana"><B>N&ordm;</B></font></p></td> '
	cTexto += '     <td><div><p align="left"><font face="Verdana"><B>'+"<span style='color: #FFFFFF'>'</span>"+ MV_PAR01 +'</B></font></p></div></td>'
	cTexto += '   </tr>'
	cTexto += '   <tr> '
	cTexto += '     <td colspan="6"><p align="center"><font face="Verdana"><B>' + SM0->M0_NOMECOM + '</B></font></p></td> '
	cTexto += '     <td><p align="left"><font face="Verdana"><B>DATA</B></font></p></td> '
	cTexto += '     <td><p align="left"><font face="Verdana"><B>'+"<span style='color: #FFFFFF'>'</span>" + Dtoc(dDataBase) + " " + cTime + '</B></font></p></td> '
	cTexto += '   </tr> '
	cTexto += '   <tr><td><div align="right">&nbsp;</div></td></tr> '
	cTexto += '   <tr> '
	cTexto += '     <td colspan="7"><font face="Verdana"><B><strong>COMPRADOR: '+c_CodCom+' - '+ c_Comprador +'</B></font></strong></td> '
	cTexto += '   </tr> '
	cTexto += ' </table> '

	cTexto += '   <table width="1232px" style="width: 1232px;" border="1"> '
	cTexto += '   <tr> '
	//cTexto += '     <td width="61" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Equip.</strong></div></td> '
	cTexto += '     <td width="10" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Linha</strong></div></td> ' //ADICIONADO EM 09/01/16
	cTexto += '     <td width="202" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Descri&ccedil;&atilde;o Material / Servi&ccedil;o</strong></div></td> '
	//cTexto += '     <td width="44" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Part Number</strong></div></td> '
	cTexto += '     <td width="44" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Qtde</strong></div></td> '
	cTexto += '     <td width="30" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Un.</strong></div></td> '
	cTexto += '     <td width="30" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Observa&ccedil;&atilde;o</strong></div></td> '
	cTexto += '     <td colspan="2"><div align="center"><strong>&Uacute;ltimo Pre&ccedil;o</strong></div></td> '
	//cTexto += '     <td width="48" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>Obra</strong></div></td> '
	cTexto += '     <td width="48" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>SC</strong></div></td> '

	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><div align="center"><strong>'+a_Forn[I,14]+'<br>'+a_Forn[I,3]+'<br>Proposta '+a_Forn[I,13]+'</strong></div></td> ' //ADICIONAR COLUNA - 09/11/16
	Next

	//cTexto += '     <td width="35" rowspan="2" style="text-align:center;vertical-align:middle;"><div align="center"><strong>ST</strong></div></td> '
	cTexto += '   </tr> '


	cTexto += '   <tr> '
	//cTexto += '     <td><div align="center"></div></td>
	//cTexto += '     <td><div align="center"></div></td>
	//cTexto += '     <td><div align="center"></div></td>
	//cTexto += '     <td><div align="center"></div></td>
	cTexto += '     <td width="72"><div align="center"><strong>Data</strong></div></td> '
	cTexto += '     <td width="58"><div align="center"><strong>Valor</strong></div></td> '
	//cTexto += '     <td><div align="center"></div></td>
	//cTexto += '     <td><div align="center"></div></td>

	For	I = 1 to Len(a_Forn)
		cTexto += '     <td width="59"><div align="center"><strong>Valor Unitario</strong></div></td> '
		cTexto += '     <td width="70"><div align="center"><strong>Total</strong></div></td> '
		cTexto += '     <td width="42"><div align="center"><strong>Prazo Entrega(dias)</strong></div></td> '
		cTexto += '     <td width="42"><div align="center"><strong>Observa&ccedil;&atilde;o</strong></div></td> '
	Next

	//cTexto += '     <td width="42"><div align="center"></div></td>
	//cTexto += '     <td><div align="center"></div></td>

	//Acrescentando mais uma coluna - 07/11/16
	//Variacao do melhor
	//preco em relacao ao
	//ultimo preco
	cTexto += '  		<td width="42"><div align="center"><strong>Variacao do melhor<br>preco em relacao ao<br>ultimo preco</strong></div></td>'
	//Acrescentando mais uma coluna - 07/11/16
	//Auditoria Cotação
	cTexto += '     	<td width="42"><div align="center"><strong>Auditoria</strong></div></td> '

	cTexto += '   </tr> '

	n_Menor := 0
	DbSelectArea("aQRY")
	DbGoTop()
	c_Menor := ""
	n_Linha := 1
	Do	While !Eof()

		cTexto += '   <tr> '

		//	cTexto += '     <td>'+aQRY->EQUIP+'</td>'

		cTexto += '     <td><p align="center">'+Alltrim(Str(n_Linha))+'</p></td> ' //adicionado em 09/11/16
		n_Linha++

		cTexto += '     <td>'+EncodeUTF8(aQRY->B1_DESC)+'</td> '
		//	cTexto += '     <td><p align="left">'+ALLTRIM(aQRY->C8_FSPARTN)+'</p></td> '
		cTexto += '     <td><p align="right">'+"<span style='color: #FFFFFF'>'</span>"+Transform(aQRY->C8_QUANT,"@E 99,999,999.9999")+'</p></td> '
		cTexto += '     <td><p align="center">'+aQRY->C8_UM+'</p></td> '
		/*DBSELECTAREA("SC8")
		DBGOTOP()
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC8")+MV_PAR01)*/
		n_UltPrec:= aQRY->B1_UPRC + (aQRY->B1_UPRC*aQRY->B1_IPI/100)
		cTexto += '     <td><p align="center">'+aQRY->OBS+'</p></td> '
		cTexto += '     <td><p align="center">'+Dtoc(Stod(aQRY->B1_UCOM))+'</p></td> '
		cTexto += '     <td><p align="right">'+"<span style='color: #FFFFFF'>'</span>"+Transform(n_UltPrec,"@E 99,999.99")+'</p></td> '
		//	cTexto += '     <td><p align="center">&#160;'+aQRY->C1_ITEMCTA+'</p></td> '
		cTexto += '     <td><p align="center">&#160;'+aQRY->C8_NUMSC+'</p></td> '

		//c_Menor := ''
		//c_NumPro:= ''

		cQry := " SELECT "
		cQry += " TOP 1 "
		cQry += " C8_FORNECE, C8_LOJA, C8_TOTAL, C8_VLDESC, C8_VALIPI, C8_NUMPRO, C8_PRODUTO, C8_ITEM "  //08/11/16 - CORRIGIDO

		//	Adicionando para compor formula para calculo de % de nova coluna adicionado - 07/11/16
		cQry += " ,C8_DESC ,C8_ALIIPI ,C8_PRECO ,B1_UPRC = ISNULL((SELECT B1_UPRC FROM "+RETSQLNAME("SB1")+" WHERE D_E_L_E_T_ = '' AND B1_FILIAL = SUBSTRING(C8_FILIAL,1,4) AND B1_COD = C8_PRODUTO ), 0) "

		cQry += " FROM "+RetSqlName("SC8")+" SC8 "
		cQry += " INNER JOIN "+RetSqlName("SA2")+"  SA2 ON (C8_FORNECE = A2_COD AND A2_FILIAL = SUBSTRING(C8_FILIAL,1,4) AND C8_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = '')
		cQry += " WHERE SC8.D_E_L_E_T_ = ''
		cQry += " AND C8_NUM = '"+MV_PAR01+"'"
		cQry += " AND C8_PRODUTO = '"+aQRY->C8_PRODUTO+"'"
		cQry += " AND C8_ITEM = '"+aQRY->C8_ITEM+"'"
		cQry += " AND C8_TOTAL <> 0 "
		cQry += " ORDER BY C8_TOTAL "

		TCQUERY cQry NEW ALIAS "bQry"

		DbSelectArea("bQry")
		DbGoTop()
		c_Menor += "[" + bQry->C8_FORNECE+bQry->C8_LOJA+bQry->C8_NUMPRO+bQry->C8_PRODUTO+bQry->C8_ITEM + "]" //09/11/16 - CORRIGIDO
		c_NumPro:= bQry->C8_NUMPRO

		n_PrecoFin:= bQRY->C8_PRECO - (bQRY->C8_PRECO*bQRY->C8_DESC/100) + (bQRY->C8_PRECO*bQRY->C8_ALIIPI/100)
		n_Variac:=	Iif(n_PrecoFin > 0, (n_PrecoFin/bQry->B1_UPRC)-1, 0) //Adicionando para compor formula para calculo de % de nova coluna adicionado - 07/11/16
		n_Variac:=	Iif(n_Variac <> 0, Round(n_Variac * 100,2), 0)

		DbCloseArea("bQry")

		// Verifica se a cotação já foi analisada e considera como o menor preço o fornecedor escolhido

		cQry := " SELECT "
		cQry += " CE_FORNECE, CE_LOJA, CE_NUMPRO, ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CE_MOTVENC)),'') CE_MOTVENC, CE_PRODUTO, CE_ITEMCOT "
		cQry += " FROM "+RetSqlName("SCE")+" SCE "
		cQry += " WHERE SCE.D_E_L_E_T_ = ''
		cQry += " AND CE_NUMCOT = '"+MV_PAR01+"'"
		cQry += " AND CE_PRODUTO = '"+aQRY->C8_PRODUTO+"'"
		cQry += " AND CE_NUMPRO = '"+c_NUMPRO+"'"
		cQry += " AND CE_QUANT <> 0 "

		TCQUERY cQry NEW ALIAS "bQry" 

		DbSelectArea("bQry")
		DbGoTop()
		c_Motivo:= ""
		n_SeqMot:= 0
		c_Selecionado := ""
		If	!Eof()
			While !Eof()
				c_Selecionado += "[" + bQry->CE_FORNECE+bQry->CE_LOJA+bQry->CE_NUMPRO+bQry->CE_PRODUTO+bQry->CE_ITEMCOT + "]"
				If Alltrim(bQry->CE_MOTVENC) <> "ENCERRADO AUTOMATICAMENTE"
					c_Motivo	+=	Iif(Empty(bQry->CE_MOTVENC),c_Motivo,Iif(!Empty(bQry->CE_MOTVENC) .And. n_SeqMot == 0,bQry->CE_MOTVENC,","+bQry->CE_MOTVENC))
					n_SeqMot	:=	Iif(!Empty(bQry->CE_MOTVENC),n_SeqMot+1,n_SeqMot)
				Endif
				dbSkip()
			End
		Endif
		DbCloseArea("bQry")

		For	I = 1 to Len(a_Forn)
			cQry := " SELECT C8_NUM, C8_ITEM, C8_PRODUTO, C8_NUMSC, C8_FORNECE, C8_LOJA, C8_PRECO, C8_TOTAL, C8_PRAZO, C8_ALIIPI,
			cQry += " A2_CONTATO, A2_DDD, A2_TEL, C8_COND, E4_DESCRI, C8_TPFRETE, C8_DESC, C8_VLDESC, C8_VALIPI, C8_VALIDA, C8_OBS, C8_NUMPED, C8_CONTATO, C8_VALFRE, C8_DESPESA
			cQry += " FROM "+RetSqlName("SC8")+" SC8 "
			cQry += " INNER JOIN "+RetSqlName("SE4")+" SE4 ON (C8_COND = E4_CODIGO AND E4_FILIAL = C8_FILIAL  AND SE4.D_E_L_E_T_ = '')
			cQry += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON (C8_FORNECE = A2_COD AND A2_FILIAL = SUBSTRING(C8_FILIAL,1,4) AND C8_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = '')
			cQry += " WHERE SC8.D_E_L_E_T_ = ''
			cQry += " AND C8_FILIAL = '"+c_Fil+"'"
			cQry += " AND C8_NUM = '"+MV_PAR01+"'"
			cQry += " AND C8_NUMSC = '"+aQRY->C8_NUMSC+"'"
			cQry += " AND C8_ITEMSC = '"+aQRY->C8_ITEMSC+"'"
			cQry += " AND C8_FORNECE = '"+a_Forn[I,1]+"'"
			cQry += " AND C8_LOJA = '"+a_Forn[I,2]+"'"
			cQry += " AND C8_NUMPRO = '"+a_Forn[I,13]+"'"
			TCQUERY cQry NEW ALIAS "bQry"
			//@E 999,999.9999
			n_ValCTotal := 0
			n_ValMOferta:= 0
			DbSelectArea("bQry")
			DbGoTop()
			If	Eof()
				cTexto += '     <td><div align="right">&nbsp;</div></td> '
				cTexto += '     <td><div align="right">&nbsp;</div></td> '
				cTexto += '     <td><div align="right">&nbsp;</div></td> '
				cTexto += '     <td><div align="right">&nbsp;</div></td> '
			Else
				c_ProdCot	:=	bQRY->C8_PRODUTO
				c_ItemCot	:=	bQRY->C8_ITEM

				n_ValCDesc 	:= bQRY->C8_PRECO - (bQRY->C8_PRECO*bQRY->C8_DESC/100) + (bQRY->C8_PRECO*bQRY->C8_ALIIPI/100)
				n_ValCTotal := (bQRY->C8_TOTAL-bQRY->C8_VLDESC)+bQRY->C8_VALIPI
				n_ValCTotal	:= IIF( n_ValCTotal < 0, 0, n_ValCTotal )

				If (a_Forn[I,1]+a_Forn[I,2]+a_Forn[I,13]+c_ProdCot+c_ItemCot $ c_Menor)
					n_ValMOferta	+=	n_ValCTotal	//menor oferta fornecedor
					n_TGOferta		+=	n_ValCTotal	//TOTAL GERAL MELHOR OFERTA		=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
				Endif

				If	( (a_Forn[I,1]+a_Forn[I,2]+a_Forn[I,13]+c_ProdCot+c_ItemCot $ c_Menor) .And. Empty(Alltrim(bQRY->C8_NUMPED)) ) //Cotacao ainda não foi analisada neste ponto - 09/11/16 - ajuste
					cTexto += '     <td bgcolor="#CCCCCC"><div align="right"><span style="color: #CCCCCC"></span><strong>'+Transform(n_ValCDesc,"@E 999,999.999999")+'</strong></div></td> '
					cTexto += '     <td bgcolor="#CCCCCC"><div align="right"><span style="color: #CCCCCC"></span><strong>'+Transform(n_ValCTotal,"@E 99,999,999.99")+'</strong></div></td> '
					//n_Menor += n_ValCTotal
					//Adicionando novas variaveis para totalizaçoes - 08/11/16
					//n_TGOferta		+=	n_ValCTotal	//TOTAL GERAL MELHOR OFERTA		=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
					//n_ValMOferta	+=	n_ValCTotal	//menor oferta fornecedor
					n_TSelec		+=	n_ValCTotal	//total dos itens selecionados na cotacao
				ElseIf	( (a_Forn[I,1]+a_Forn[I,2]+a_Forn[I,13]+c_ProdCot+c_ItemCot $ c_Menor) .And. Alltrim(bQRY->C8_NUMPED) <> "XXXXXX" .And. !Empty(Alltrim(bQRY->C8_NUMPED)) ) //Cotacao foi analisada neste ponto - 09/11/16 - ajuste
					cTexto += '     <td bgcolor="#CCCCCC"><div align="right"><span style="color: #CCCCCC"></span><strong>'+Transform(n_ValCDesc,"@E 999,999.999999")+'</strong></div></td> '
					cTexto += '     <td bgcolor="#CCCCCC"><div align="right"><span style="color: #CCCCCC"></span><strong>'+Transform(n_ValCTotal,"@E 99,999,999.99")+'</strong></div></td> '
					//n_Menor += n_ValCTotal
					//Adicionando novas variaveis para totalizaçoes - 08/11/16
					//n_TGOferta		+=	n_ValCTotal	//TOTAL GERAL MELHOR OFERTA		=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
					//n_ValMOferta	+=	n_ValCTotal	//menor oferta fornecedor
					n_TSelec		+=	n_ValCTotal	//total dos itens selecionados na cotacao

				ElseIf  (a_Forn[I,1]+a_Forn[I,2]+a_Forn[I,13]+c_ProdCot+c_ItemCot $ c_Selecionado) .And. Alltrim(bQRY->C8_NUMPED) <> "XXXXXX" .And. !Empty(Alltrim(bQRY->C8_NUMPED))//Adicionando cor vermelha em precos que não sejam o menor valor. - 08/11/16
					cTexto += '     <td bgcolor="RED"><div align="right"><span style="color: WHITE"></span><strong>'+Transform(n_ValCDesc,"@E 999,999.999999")+'</strong></div></td> '
					cTexto += '     <td bgcolor="RED"><div align="right"><span style="color: WHITE"></span><strong>'+Transform(n_ValCTotal,"@E 99,999,999.99")+'</strong></div></td> '
					//Adicionando novas variaveis para totalizaçoes - 08/11/16
					//n_TGOferta		+=	n_ValCTotal	//TOTAL GERAL MELHOR OFERTA		=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
					n_TSelec		+=	n_ValCTotal	//total dos itens selecionados na cotacao

				Else
					cTexto += '     <td><div align="right"><span style="color: #FFFFFF"></span>'+Transform(n_ValCDesc,"@E 999,999.999999")+'</div></td> '
					cTexto += '     <td><div align="right"><span style="color: #FFFFFF"></span>'+Transform(n_ValCTotal,"@E 99,999,999.99")+'</div></td> '

				Endif
				cTexto += '     <td><div align="right">'+Transform(bQRY->C8_PRAZO,"@E 999")+'</div></td> '
				cTexto += '     <td><div align="center">&nbsp;</div></td> '

				n_ValCDesc := 0
			Endif
			a_Forn[I,4] += n_ValCTotal
			a_Forn[I,5] := IIF(bQRY->C8_TPFRETE="C","CIF","FOB")
			a_Forn[I,6] := bQRY->E4_DESCRI
			a_Forn[I,7] := IIF( bQRY->C8_DESC = 0 , bQRY->C8_VLDESC, bQRY->C8_DESC )
			a_Forn[I,8] := bQRY->C8_VALIPI
			//a_Forn[I,9] += Alltrim(c_Motivo)               //Observacao
			a_Forn[I,10] := bQRY->C8_CONTATO
			a_Forn[I,11] := "("+Alltrim(bQRY->A2_DDD)+")"+Alltrim(A2_TEL)
			a_Forn[I,15] += n_ValMOferta
			a_Forn[I,16] += bQRY->C8_VALFRE 
			a_Forn[I,17] += bQRY->C8_DESPESA

			DbCloseArea("bQry")
		Next
		//	cTexto += '     <td><div align="center">'+aQRY->C1_FSSTAT+'</div></td> '

		//adicionar novas coluna de variação de preço e auditoria - 08/11/16
		//c_Motivo	:=	Iif(Alltrim(c_Motivo) == "ENCERRADO AUTOMATICAMENTE", "", c_Motivo)
		cTexto += '     <td><div align="right">'+"<span style='color: #FFFFFF'>'</span>"+Transform(n_Variac,"@E 999.99")+"%"+'</div></td> '
		cTexto += '     <td><div align="right">'+"<span style='color: #FFFFFF'>'</span>"+c_Motivo+'</div></td> '


		cTexto += ' </tr> '
		DbSelectArea("aQRY")
		DbSkip()
	Enddo

	DbCloseArea("aQry")

	cTexto += '   <tr></br></tr> '
	cTexto += '   <tr> '
	cTexto += '     <td colspan="7" rowspan="8" valign="top"></td> '
	cTexto += '     <td><strong>Total</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="2"><p align="right"><strong>'+"<span style='color: #FFFFFF'>'</span>"+Transform(a_Forn[I,4],"@E 99,999,999.99")+'</strong></td> '
		cTexto += '     <td colspan="2"></td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Total Melhor Oferta</strong></td> ' //Adicionado em 09/11/16
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center"><strong>'+"<span style='color: #FFFFFF'>'</span>"+Transform(a_Forn[I,15],"@E 99,999,999.99")+'</strong></td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Frete</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+a_Forn[I,5]+'</strong></td> '
	Next
	cTexto += '   </tr> '
	
	cTexto += '   <tr> '
	cTexto += '     <td><strong>Vl. Frete</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+Transform(a_Forn[I,16],"@E 99,999.99")+'</strong></td> '
	Next
	cTexto += '   </tr> '
	
	cTexto += '   <tr> '
	cTexto += '     <td><strong>Despesas</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+Transform(a_Forn[I,17],"@E 99,999.99")+'</strong></td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Cond Pgto</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+a_Forn[I,6]+'</td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Desconto</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+Transform(a_Forn[I,7],"@E 999,999.9999")+'</td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Contato</strong></td>   '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+a_Forn[I,10]+'</td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Telefone</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+a_Forn[I,11]+'</td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td><strong>Validade Prop.</strong></td> '
	For	I = 1 to Len(a_Forn)
		cTexto += '     <td colspan="4"><p align="center">'+a_Forn[I,12]+'</td> '
	Next
	cTexto += '   </tr> '

	cTexto += '   <tr> '
	cTexto += '     <td colspan="6" rowspan="2" style="text-align:right;vertical-align:middle;padding: 2px;"><font face="Verdana" size="4"><strong>TOTAL DA OFERTA</strong></font></td> '
	cTexto += '     <td colspan="'+CVALTOCHAR((Len(a_Forn)*4)+6)+'" rowspan="2" style="text-align:left;vertical-align:middle;padding: 2px;"><font face="Verdana" size="4"><strong>R$ '+Transform(n_TSelec,"@E 99,999,999.99")+'</strong></font></td> '
	cTexto += '   </tr> '

	cTexto += '   <tr>
	cTexto += '     <td>&nbsp;</td>
	cTexto += '   </tr>

	cTexto += ' </table> '
	//cTexto += ' <p>&nbsp;</p> '
	//cTexto += ' <p>&nbsp;</p> '

	//Incluir nova tabela com os seguintes dados:
	/*
	TOTAL GERAL PC				=	TOTAL DE TODAS AS FILIAIS
	TOTAL DESCONTO PC				=	TOTAL DE DESCONTO DE TODAS AS FILIAIS
	TOTAL GERAL PC COM DESCONTO	=	TOTAL DE TODAS AS FILIAIS COM DESCONTO
	TOTAL GERAL MELHOR OFERTA	=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
	Diferença						=	VARIACAO DO TOTAL COM DESCONTO E TOTAL DA MELHOR OFERTA DE TOTAL DE TODAS AS FILIAIS
	*/

	//********************************************************************************************************
	//*Em 05/10/2017 esses totalizadores deixaram de ser por toda empresa e passaram a ser por filial logada.*
	//********************************************************************************************************

	//Query para coletar dados dos Pedidos gerados a partir desta cotação
	c_SC7Alias := GetNextAlias()
	BEGINSQL ALIAS c_SC7Alias

	SELECT
		TgerPC	= SUM(C7_TOTAL + C7_VALIPI + C7_VALFRE + C7_DESPESA + C7_SEGURO)
		,TdescPC = SUM(C7_VLDESC)
		,TGdescPC = SUM((C7_TOTAL + C7_VALIPI + C7_VALFRE + C7_DESPESA + C7_SEGURO) - C7_VLDESC)
		FROM %TABLE:SC7% SC7
		WHERE
			SC7.C7_FILIAL = %XFILIAL:SC7%
			AND SC7.%NOTDEL%
			AND	SC7.C7_NUMCOT = %EXP:MV_PAR01%

	ENDSQL
    n_TgerPC		:=	(c_SC7Alias)->TgerPC
	n_TdescPC		:=	(c_SC7Alias)->TdescPC
	n_TGdescPC		:=	(c_SC7Alias)->TGdescPC

	(c_SC7Alias)->(dbCloseArea())

	n_Diferenca	:=	n_TGdescPC-n_TGOferta

	c_SinalDif		:=	Iif(n_Diferenca < 0, " - ", " + ")+"R$ "
	n_Diferenca	:=	Iif(n_Diferenca < 0, n_Diferenca * (-1), n_Diferenca)
	n_PDif			:=	(n_Diferenca/n_TGOferta)*100

	//cTexto += ' <table> '
	cTexto += ' <table border="2"> '
	//TOTAL GERAL PC				=	TOTAL DE TODAS AS FILIAIS
	//n_TgerPC	:=	0
	cTexto += ' 	<tr> '
	cTexto += ' 	<td colspan="1" rowspan="6" valign="top"></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>TOTAL GERAL PC</strong></font></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>'+"   R$ "+Transform(n_TgerPC,"@E 99,999,999,999.99")+'</strong></font></td> '
	cTexto += ' 	</tr> '
	//TOTAL DESCONTO PC				=	TOTAL DE DESCONTO DE TODAS AS FILIAIS
	//n_TdescPC	:=	0
	cTexto += ' 	<tr> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>TOTAL DESCONTO</strong></font></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>'+"   R$ "+Transform(n_TdescPC,"@E 99,999,999,999.99")+'</strong></font></td> '
	cTexto += ' 	</tr> '
	//TOTAL GERAL PC COM DESCONTO	=	TOTAL DE TODAS AS FILIAIS COM DESCONTO
	//n_TGdescPC	:=	0
	cTexto += ' 	<tr> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>TOTAL GERAL PC COM DESCONTO</strong></font></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>'+"   R$ "+Transform(n_TGdescPC,"@E 99,999,999,999.99")+'</strong></font></td> '
	cTexto += ' 	</tr> '
	//TOTAL GERAL MELHOR OFERTA	=	TOTAL COM O MELHOR OFERTA DE TODAS AS FILIAIS
	//n_TGOferta	- Variavel sendo totalizada durante impressão dos itens na planilha.
	cTexto += ' 	<tr> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>TOTAL GERAL MELHOR OFERTA</strong></font></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>'+"   R$ "+Transform(n_TGOferta,"@E 99,999,999,999.99")+'</strong></font></td> '
	cTexto += ' 	</tr> '
	//Diferença						=	VARIACAO DO TOTAL COM DESCONTO E TOTAL DA MELHOR OFERTA DE TOTAL DE TODAS AS FILIAIS
	//n_Diferenca	:=	0
	cTexto += ' 	<tr> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>DIFERENCA</strong></font></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>'+c_SinalDif+Transform(n_Diferenca,"@E 99,999,999,999.99")+'</strong></font></td> '
	cTexto += ' 	</tr> '
	//% da diferenca - adicionado em 09/11/16
	cTexto += ' 	<tr> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>% Diferenca</strong></font></td> '
	cTexto += '     <td><font face="Verdana" size="4"><strong>'+Transform(n_PDif,"@E 999.99")+'%'+'</strong></font></td> '
	cTexto += ' 	</tr> '


	cTexto += ' </table> '

	cTexto += ' <p>&nbsp;</p> '
	//cTexto += ' <p>&nbsp;</p> '

	//Adicionado em 08/11/16 em atendimento a necessidades da Fundação josé carvalho
	If ExistBlock("PCOMR01F") //Ponto de entrada para impressões complementares de dados no mapa de cotação.
		cTexto +=  ExecBlock("PCOMR01F")
	Endif

	//cTexto += ' <p>&nbsp;</p> '
	//cTexto += ' <p>&nbsp;</p> '
	cTexto += ' </body> '
	cTexto += ' </html> '


	MemoWrite("C:/FCOMR001.TXT", cTexto)
	cPath := ""
	c_Caminho := Alltrim(MV_PAR02)

	//alert(cValToChar(l_RetArray))

	If !l_RetArray
		cNewExcelFile := c_Caminho+"\COT-"+MV_PAR01+".xls"

		Memowrite(cNewExcelFile,cTexto) // Salva codigo HTML num arquivo EXCEL

		If 	!ApOleClient("MsExcel")
			MsgAlert("MsExcel não instalado")
			Return
		Endif

		oExcelApp 	:= MsExcel():New()

		oExcelApp:WorkBooks:Open(cNewExcelFile) // Abre uma planilha

		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
		//PsExecute( cNewExcelFile )

	Else
		//c_Caminho		:=	"C:\TOTVS\"
		//cNewExcelFile := c_Caminho+c_Arq
		//conout("gravacao da cotacao: "+cNewExcelFile)
		//Conout(len(cTexto))
		//Memowrite(cNewExcelFile,cTexto) // Salva codigo HTML num arquivo EXCEL
		Memowrite(c_Arq,cTexto)
		conout("Arquivo de Cotacao: "+c_Arq+" gravado com successo.")
	Endif

	//alert(cValToChar(l_RetArray))
	If !l_RetArray
		a_ArrayRet	:=	{}
	Else
		Conout("Gravacao cotacao")
	Endif

	//alert(a_ArrayRet[1])
	//alert(a_ArrayRet[2])
	//alert(a_ArrayRet[3])

Return(a_ArrayRet)



/*/{Protheus.doc} CriaPerg
(long_description)
@type function
@author carlo
@since 08/11/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function CriaPerg
	_aMV_PAR02 := {}

	Aadd(_aMV_PAR02, "Digite o local onde deseja que a planilha seja salva.")
	Aadd(_aMV_PAR02, "Exemplo: C:\Mapas")

	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Cotação?               ","","","mv_ch1","C",06,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(c_Perg,"02","Local geração arquivo? ","","","mv_ch2","C",50,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",_aMV_PAR02)

Return