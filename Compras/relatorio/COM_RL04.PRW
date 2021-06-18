#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³COM_RL04  ºAutor ³Renato /  Paulo Nariga 05/20/09           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressao da Cotacao de Compras Modelo Grafico            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function COM_RL04()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Cotacao de Preco"
Local cPict          := ""
Local titulo         := "Cotacao de Preco"
PRIVATE nLin         := 0
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "COM_RL04"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COM_RL04"
nRow1 := 0

aOrd := {}
cPerg :=  "COT001"

Private  _nAliqICM   := 0
Private _cMensFor    := ""
Private cString      := "SC1"
Private _cMen1       := ""
Private _cMen2       := ""
Private _cMen3       := ""
Private _cCodCli     := ""
Private _cNome       := ""
Private _cMes        := ""
Private _cMes2       := ""
Private _nVlr        := 0
Private _nVlr2       := 0
Private _nSubTot     := 0
Private _cVencto     := ""
Private _cVencto2    := ""
Private _cNumNF      := ""
Private _cEmis       := ""
Private _cNumbco     := ""
Private oGraphic
Private _cDV
Private _cnossonum   := ""
Private cBitMap      := ""
Private cAssina      := ""
Private _cEnd        := ""
Private _cBairro     := ""
Private _cMun        := ""
Private _cCEP        := ""
Private _cConsCor    := ""
Private _cCGC        := ""
Private _cDtLtAnt    := ""
Private _cDtLtPrx    := ""
Private _cPeriodo    := ""
Private _cLiberado   := ""
Private nMoeda       := 1
Private nTotDesp     := 0
linha := 800

dbSelectArea("SC1")
dbSetOrder(1)

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

_PAG := 0

RptStatus({|| RunReport() })

Return

// IMPRESSAO
Static Function RunReport()

nTotDc		:= 0
nFolha		:= 0
aSC			:= {}
aCC			:= {}
Private oFont, cCode
nHeight 	:= 15
lBold		:= .F.
lUnderLine	:= .F.
lPixel  	:= .T.
lPrint  	:= .F.

oFont	:= TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont5	:= TFont():New( "Arial",,5,,.f.,,,,,.f. )
oFont6	:= TFont():New( "Arial",,6,,.f.,,,,,.f. )
oFont7	:= TFont():New( "Arial",,7,,.f.,,,,,.f. )
oFont8b	:= TFont():New( "Arial",,8,,.t.,,,,,.f. )
oFont8	:= TFont():New( "Arial",,8,,.f.,,,,,.f. )
oFont9	:= TFont():New( "Arial",,9,,.f.,,,,,.f. )
oFont9b	:= TFont():New ( "Arial",,9,,.t.,,,,,.f. )
oFont10b:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont10	:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont102:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont10i:= TFont():New( "Arial",,10,,.t.,,,,.t.,.f. )
oFont11	:= TFont():New( "Arial",,11,,.f.,,,,,.f. )
oFont12	:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont12i:= TFont():New( "Arial",,12,,.f.,,,,.t.,.f. )
oFont122:= TFont():New( "Arial",,12,,.f.,,,,,.f.  )
oFont14	:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont142:= TFont():New( "Arial Narrow",,14,,.T.,,,,,.f. )
oFont152:= TFont():New( "Arial",,15,,.T.,,,,,.f. )
oFont16	:= TFont():New( "Arial Narrow",,16,,.f.,,,,,.f. )
oFont15	:= TFont():New( "Arial Narrow",,15,,.f.,,,,,.f. )
oFont15b:= TFont():New( "Arial Narrow",,15,,.t.,,,,,.f. )
oFont162:= TFont():New( "Arial Narrow",,14,,.T.,,,,,.f. )
oFont18	:= TFont():New( "Arial",,18,,.f.,,,,,.f. )
oFont20	:= TFont():New( "Arial",,20,,.f.,,,,,.f. )
oFont22	:= TFont():New( "Arial",,22,,.f.,,,,,.f. )
oPrn 	:= TMSPrinter():New()

_forn := ""
_PAG  := 1

DbSelectArea("SC8")
DbSetOrder(1)
DbSeek(xFilial("SC8")+MV_PAR01,.T.)
SetRegua(RecCount())

_IMP1	:= .F.
_NUMCOT := SC8->C8_NUM

Do While !Eof() .And. C8_FILIAL = xFilial("SC8") .And. C8_NUM >= mv_par01 .And. C8_NUM <= mv_par02
	
	_cNumPC := SC8->C8_NUM
	nTotal  := 0
	nTotBr  := 0
	nMoeda  := SC8->C8_MOEDA
	
	DbSelectArea("SC8")
	
	If _forn <> SC8->C8_FORNECE
		_forn := SC8->C8_FORNECE
		_PAG  := 1
		
		If _IMP1
			ImpRoda()
		Endif
		
		ImpCabec()
		_IMP1 := .T.
		nLin  := LINHA
	Endif
	
	n := 1
	
	If nLin > 2080
		nLin := LINHA
		
		If _IMP1
			ImpRoda()
		Endif
		
		Impcabec()
	Endif
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+SC8->C8_PRODUTO)
		_DESC := SB1->B1_DESC
	Else
		_DESC := ""
	Endif
	
	nlin:= nlin + 50
	
	oPrn:Say(nLin,0065,SC8->C8_ITEM,oFont10,100)
	
	//	P..Lz - Escolha da Unidade de Medida
	If MV_PAR03 == 1 // escolhe a 1 para 1a unidade de medida e 2 para 2a unidade de medida em Parametros
		
		// 1 unidade
		If SC8->C8_QUANT <> 0.00
			oPrn:Say(nLin,0170,trans(round(SC8->C8_QUANT,2),"@E 999,999,999.99"),oFont12,100)
			oPrn:Say(nLin,0425,SC8->C8_UM,oFont12,100)
		Endif
		
		// 2 unidade
		If SC8->C8_QTSEGUM <> 0.00
			oPrn:Say(nLin,0170,trans(round(SC8->C8_QTSEGUM,2),"@E 999,999,999.99"),oFont12,100)
			oPrn:Say(nLin,0425,SC8->C8_SEGUM,oFont12,100)
		Endif
	Else
		// 1 unidade
		If SC8->C8_QUANT <> 0.00 .AND. MV_PAR03 <> 2
			oPrn:Say(nLin,0170,trans(round(SC8->C8_QUANT,2),"@E 999,999,999.99"),oFont12,100)
			oPrn:Say(nLin,0425,SC8->C8_UM,oFont12,100)
		Endif
	
		// 2 unidade
		If SC8->C8_QTSEGUM <> 0.00.AND. MV_PAR03 == 2
			oPrn:Say(nLin,0170,trans(round(SC8->C8_QTSEGUM,2),"@E 999,999,999.99"),oFont12,100)
			oPrn:Say(nLin,0425,SC8->C8_SEGUM,oFont12,100)
		Endif
	Endif

	If nLin > 2080
		If _IMP1
			ImpRoda()
		Endif
		Impcabec()
	Endif
	
	//** retirar a descrição do produto (será apenas comentanda, caso exista uma necessidade posterior que a descrição apareça novamente - 28/10/2010 (email do dia 27/10/2010, solicitando tal alteração)
	//**	if ! empty(_DESC)
	//**		oPrn:Say( nLin,0530,Alltrim(_DESC),oFont14,100)
	//**	ENDIF
	
	TamLn1    := 60
	
	If !Empty(SB1->B1_DESCDET)
		
		nLin := nLin + 50
		oPrn:Say( nLin,0530,"DESCRICAO DETALHADA:",oFont9,100)
		nLin:=nLin+100

		For X:=1 to MLCOUNT(SB1->B1_DESCDET, TamLn1 + 5 , 4, .t.)
			_TEXTO := MEMOLINE(SB1->B1_DESCDET,TamLn1 + 5,X,4,.t.)     //79
			oPrn:Say(nLin,0530,_TEXTO,oFont10,100)
			nLin := nLin + 40
			
			If nLin > 2080
				If _IMP1
					ImpRoda()
				Endif
				Impcabec()
			Endif
		Next
	Endif
	
	//Impressao de observacao
	If ! Empty(SC8->C8_OBS)
		If nLin > 2000
			nLin := LINHA
			If _IMP1
				ImpRoda()
			Endif
			Impcabec()
		Endif
		
		nLin:=nLin+30
		oPrn:Say( nLin,0530,"OBSERVAÇÕES: ",oFont10,100)
		nLin:=nLin+20
		oPrn:Say( nLin,0530,"____________________________________________________________________",oFont10,100)
		nLin:=nLin+50
		
		If Len(Alltrim(SC8->C8_OBS)) < 70
			oPrn:Say( nLin,0535,Alltrim(SC8->C8_OBS),oFont11,100)
		Else
			oPrn:Say( nLin,0535,SubStr(SC8->C8_OBS,1,70),oFont11,100)
			nLin:=nLin+50
			oPrn:Say( nLin,0535,SubStr(SC8->C8_OBS,71,80),oFont11,100)
		Endif
		nLin := nLin + 50
	Endif
	
	If nLin > 2080
		nLin := LINHA
		If _IMP1
			ImpRoda()
		Endif
		Impcabec()
	Endif
	
	DbSelectArea("SC8")
	DbSkip()
	
Enddo

ImpRoda()

DbSelectArea("SC8")
DbCloseArea()

oPrn:Setup() // para configurar impressora
oPrn:Preview()
MS_FLUSH()

Return

// CABECALHO
Static Function ImpCabec()

oPrn:StartPage()

oPrn:Box(50,1500,800,2350)   // DE 350 PARA 550 - ESTAVA EM 2200 - oPrn:Box(50,50,460,2500)

_DtE := DTOS(SC8->C8_EMISSAO)
_Dte := SubStr(_DtE,7,2)+"/"+SubStr(_DtE,5,2)+"/"+SubStr(_DtE,1,4)

oPrn:Say(070,50,"COTAÇÃO DE PREÇO N. " + SC8->C8_NUM , oFont20,100)
oPrn:Say(070,1600,"COLOCAR O CARIMBO DA EMPRESA," , oFont11,100)    //42
oPrn:Say(120,1700," CNPJ E ASSINATURA" , oFont11,100)               //92
oPrn:Say(150,50,"FAVOR CONFIRMAR O RECEBIMENTO PARA O TELEFONE (71) 3116-2828/2898" , oFont9,100)
oPrn:Say(200,50,"SEÇÃO DE COMPRAS - " + "PAG: " + Transform(_PAG,"@E 999"), oFont9,100)
_PAG := _PAG + 1

oPrn:Say(300,50,"EMITENTE" , oFont11,100)
cBitMap2 := FisxLogo("1")  //"M:\TOTVS\Protheus10\Protheus_Data\system\lgrl01.bmp"
oPrn:SayBitMap(340,50,cBitMap2,1000,200)  // oPrn:SayBitMap(360,50,cBitMap2,0500,150)

oPrn:Say(550,50,"DESTINATÁRIO" , oFont11,100)

DbSelectArea("SA2")
DbSetOrder(1)
If DbSeek(xFilial("SA2") + SC8->C8_FORNECE + SC8->C8_LOJA)
	oPrn:Say(600,050,SA2->A2_NOME , oFont9,100)
	oPrn:Say(650,050,Alltrim(SA2->A2_END) + " - " + Alltrim(A2_NR_END) , oFont9,100)
	oPrn:Say(700,050,Alltrim(SA2->A2_BAIRRO) + " - " + Alltrim(SA2->A2_MUN) + " - " + Alltrim(SA2->A2_EST) , oFont9,100)
	oPrn:Say(750,050,"TEL: " + Alltrim(SA2->A2_TEL) + " / FAX: " + Alltrim(SA2->A2_FAX) , oFont9,100)
Else
	oPrn:Say(600,050,"NAO ENCONTRADO FORNECEDOR" , oFont15b,100)
Endif

linha := 800
linha := linha + 100

// P..Lz - Retirada dos Boxes do Relatorio de Cotação

oPrn:Box(linha,0050,linha+100,2350)  // box principal
oPrn:Box(linha,0050,linha+100,0150)  // item
oPrn:Box(linha,0150,linha+100,0400)  // quantidade
oPrn:Box(linha,0400,linha+100,0500)  // unidade
oPrn:Box(linha,0500,linha+100,1900)  // descricao
oPrn:Box(linha,1900,linha+100,2100)  // pco.unitario
oPrn:Box(linha,2100,linha+100,2350)  // total

//linha := linha + 100
oPrn:Say(linha+20,0065,"ITEM"                         , oFont9b,100)
oPrn:Say(linha+20,0178,"QUANTIDADE"                   , oFont9b,100)
oPrn:Say(linha+20,0420,"UNID."                        , oFont9b,100)
oPrn:Say(linha+20,0550,"DESCRIÇÃO MATERIAL / SERVIÇO" , oFont9b,100)
oPrn:Say(linha+20,1930,"PCO UNIT"                   , oFont9b,100)
oPrn:Say(linha+20,2135,"PCO TOTAL"                  , oFont9b,100)

linha := linha + 100
oPrn:Line (linha,0050,2160,0050)
oPrn:Line (linha,0150,2160,0150)
oPrn:Line (linha,0400,2160,0400)
oPrn:Line (linha,0500,2160,0500)
oPrn:Line (linha,1900,2160,1900)
oPrn:Line (linha,2100,2160,2100)
oPrn:Line (linha,2350,2160,2350)
nLin := LINHA

Return

//Imprime rodapé
Static Function ImpRoda()

// ..lz
nTotBr:=0
nTotal:=0

nTotBr:=nTotBr+nTotDesp
nTotal:=nTotal+nTotDesp

_Exten := Extenso(nTotal,.F.,nMoeda)

oPrn:Box(2160,0050,2350,2350)  // item
oPrn:Box(2160,0700,2350,2350)  // quantidade
oPrn:Box(2160,1300,2350,2350)  // quantidade
oPrn:Box(2160,1900,2350,2350)  // unidade

oPrn:Say( 2170,0150,"CONDIÇÕES DE PAGAMENTO",oFont10,100)
oPrn:Say( 2170,0790,"VALIDADE DA PROPOSTA",oFont10,100)
oPrn:Say( 2170,1440,"PRAZO DE ENTREGA",oFont10,100)
oPrn:Say( 2170,2050,"FRETE",oFont10,100)
oPrn:Say( 2240,1950,"               CIF",oFont10,100)

oPrn:Say( 2400,50,"OBS. 1: Nas aquisições de materiais de consumo e ativo imobilizado, quando realizadas fora do Estado da Bahia, o fornecedor será o ",oFont10,100)
oPrn:Say( 2450,50,"               responsável pelo recolhimento do imposto decorrente da diferença entre a alíquota interna do Estado da Bahia em relação  á",oFont10,100)
oPrn:Say( 2500,50,"               aliquota do Estado de origem, anexando cópia do DAE pago à Nota Fiscal de Fornecimento.",oFont10,100)
oPrn:Say( 2550,50,"OBS. 2:Os dados constantes da nota fiscal deverão ser transmitidos através de programa disponibilizado pela secretaria da fazenda,",oFont10,100)
oPrn:Say( 2600,50,"               no endereço eletronico www.sefaz.ba.gov.br, cujo comprovante de transmissão deverá ser anexado ao documento  ",oFont10,100)
oPrn:Say( 2650,50,"               fiscal(compra legal) e conforme artigo 228B do ICMS/BA, Decreto 6284 de 14/03/1997.",oFont10,100)
oPrn:Say( 2700,50,"OBS. 3: É obrigatório informar a Classificação Fiscal NCM(Nomenclatura Comum do Mercosul) do produto na Nota Fiscal.",oFont10,100)
oPrn:Say( 2750,50,"OBS. 4: Condiçao de Pagamento até 08 dias úteis",oFont10,100)

oPrn:Say( 2850,50,"Atenciosamente,",oFont12,100)

_CQ := " SELECT DISTINCT Y1_NOME AS NOME, Y1_TEL AS TEL, Y1_EMAIL AS EMAIL , Y1_FAX AS FAX FROM SC8010 A, SC1010 B, SY1010 C "
_CQ += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' "
_CQ += " AND C8_NUMSC = C1_NUM AND Y1_COD = C1_CODCOMP AND C8_NUM = '" + _NUMCOT + "' "
TCQUERY _cQ NEW ALIAS "COMP"

oPrn:Say( 3000,50,COMP->NOME ,oFont10,100)
oPrn:Say( 3050,50,"Seção de Compras",oFont10,100)
oPrn:Say( 3100,50,"Telefone: " + Alltrim(COMP->TEL) + " / Fax: " + COMP->FAX,oFont10,100)
oPrn:Say( 3150,50,COMP->EMAIL,oFont14,100)
DBCLOSEAREA("COMP")

oPrn:EndPage()

Return