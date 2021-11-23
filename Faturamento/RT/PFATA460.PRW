#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} PFATA460
//Rotina para importar o XML Ct-e/NFe-S.
@author 
@since 05/05/2017
@version undefined

@type function
/*/
User Function PFATA460()

	Local a_Size		:= {}	//Dimensionamento de Tela
	Local a_Info		:= {}	//Dimensionamento de Tela
	Local a_PosObj 		:= {}	//Dimensionamento de Tela
	Local a_Objects		:= {}	//Dimensionamento de Tela
	Local l_VldoDlg		:= .F.
	//Local n_Opca		:= 0
	Local c_Bord1		:= ""
	Local a_Bord1  		:= {}
	Local a_Campos1		:= {}
	Local a_Cores 		:= {{"TRB->TB_BITMAP == 1","BR_VERDE"},{"TRB->TB_BITMAP == 2","BR_VERMELHO"}}
	Local c_Marc1		:= GetMark()

	//Chamar funcao para validacao de CNPJ
	// Private o_vldTemp  	 :=clsVldTemplate():new()
	
	// If	!o_vldTemp:mtdAceleradores()
		
	// 	Alert("Empresa não autorizada, por favor contacte a TOTVS BAHIA, informe seu CNPJ e Solicite seu acesso.")
	
	// 	Return()
	
	// Endif 

	Private c_Perg	:=	"PFATA460"

	f_CriaPerg(c_Perg)
	
	If !Pergunte(c_Perg, .T.)
		Return
	Else
		If ZF7->(!dbseek(xFilial("ZF7")+MV_PAR01,.T.))
			Alert("Tabela "+MV_PAR01+" não encontrada, a rotina será encerrada, por favor verifique o cadastro de tabela de frete e informe o código correto da tabela.")
			Return
		Endif	
	EndIf     

	Private c_Produto	:= ""
	Private c_CondPag	:= SUPERGETMV("FS_CONDPG",.F.,"001")
	Private c_Tabela	:= MV_PAR01 //SUPERGETMV("FS_TABFRT",.F.,"01") )
	
	Private c_TES		:= ""
	//Private l_VldoDlg	:= .T.
	Private c_Pedido	:= ""
	Private l_ErroPedido:= .F.
	Private l_ErrNF		:= .F.
	
	SetPrvt("o_Font1")
	SetPrvt("o_Dlg1")
	SetPrvt("o_Say1","o_Say2","o_Say3","o_Say4","o_Say5","o_Say6","o_Say7")
	SetPrvt("o_Get1","o_Get2","o_Get3","o_Get4","o_Get5","o_Get6","o_Get7")

	aAdd(a_Bord1,{"TB_OK"		,"C",TAMSX3("C5_OK")		[1],0})
	aAdd(a_Bord1,{"TB_TIPO"		,"C",4,0})
	aAdd(a_Bord1,{"TB_NUM"		,"C",TAMSX3("F2_DOC")		[1],0})
	aAdd(a_Bord1,{"TB_SER"		,"C",TAMSX3("F2_SERIE")		[1],0})
	aAdd(a_Bord1,{"TB_CLI"		,"C",TAMSX3("F2_CLIENTE")	[1],0})
	aAdd(a_Bord1,{"TB_LOJ"		,"C",TAMSX3("F2_LOJA")		[1],0})
	aAdd(a_Bord1,{"TB_NOM"		,"C",TAMSX3("A1_NOME") 		[1],0})
	aAdd(a_Bord1,{"TB_EMISSAO"	,"D",TAMSX3("F1_EMISSAO")	[1],0})
	aAdd(a_Bord1,{"TB_VALOR"	,"N",TAMSX3("F2_VALBRUT") 	[1],2})
	aAdd(a_Bord1,{"TB_CHAVE"	,"C",TAMSX3("F2_CHVNFE")	[1],0})
	aAdd(a_Bord1,{"TB_PRODUTO"	,"C",TAMSX3("C6_PRODUTO")	[1],0})
	aAdd(a_Bord1,{"TB_TES"		,"C",TAMSX3("C6_TES")		[1],0})
	aAdd(a_Bord1,{"TB_CF"		,"C",TAMSX3("C6_CF")		[1],0})
	aAdd(a_Bord1,{"TB_VENC"		,"D",TAMSX3("F1_EMISSAO")	[1],0})
	aAdd(a_Bord1,{"TB_PARC1"	,"N",TAMSX3("F2_VALBRUT") 	[1],2})

	Aadd(a_Bord1,{"TB_BITMAP"	,"N",1,0})

	c_Bord1	:= CriaTrab(a_Bord1,.t.)

	cInd1    	:= SUBSTR(c_Bord1,1,7)+"A"

	Use &c_Bord1 Shared Alias TRB New
	Index On TB_NUM+TB_SER+TB_CLI+TB_LOJ To &cInd1

	SET INDEX TO &cInd1

	AADD(a_Campos1,{'TB_OK'		,,''  			,'@!'})
	AADD(a_Campos1,{'TB_TIPO'	,,'Tipo'		,'@!'})
	AADD(a_Campos1,{'TB_NUM'	,,'Número'		,'@!'})
	AADD(a_Campos1,{'TB_SER'	,,'Serie'		,'@!'})
	AADD(a_Campos1,{'TB_CLI'	,,'Cliente'		,'@!'})
	AADD(a_Campos1,{'TB_LOJ'	,,'Loja'		,'@!'})
	AADD(a_Campos1,{'TB_NOM'	,,'Nome'		,'@!'})
	AADD(a_Campos1,{'TB_EMISSAO',,'Emissão'		,'@!'})
	AADD(a_Campos1,{'TB_VALOR'  ,,'Valor'   	,'@E 999,999,999.99'})
	AADD(a_Campos1,{'TB_CHAVE'  ,,'Chave'  		,'@!'})
	AADD(a_Campos1,{'TB_VENC'	,,'Vencimento'	,'@!'})
	AADD(a_Campos1,{'TB_PARC1'  ,,'Valor Parc' 	,'@E 999,999,999.99'})
	
	
	//Dimensionamento da tela
	
	aAdd( a_Objects, { 75, 50, .T., .T. } ) 	// Enchoice
	aAdd( a_Objects, { 00, 750, .T., .T. } ) 	// GetDados

	a_Size		:= MsAdvSize()
	a_Info 	:= { a_Size[ 1 ], a_Size[ 2 ], a_Size[ 3 ], a_Size[4]+20, 1, 1 }
	a_PosObj 	:= MsObjSize( a_Info, a_Objects, .T. )

	o_Font1   	:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	DEFINE MSDIALOG o_Dlg1 TITLE "Importação XML Ct-e/NFe-S" From a_Size[7],00 To a_Size[6],a_Size[5] OF oMainWnd PIXEL

	o_Panel3 	:= TPanel():New(0,0,"",o_Dlg1,NIL,.T.,.F.,NIL,NIL,0,1000,.T.,.F.)
	o_Panel3:Align := CONTROL_ALIGN_ALLCLIENT
		
	o_Grp1    	:= TGroup():New(a_PosObj[2,1]-11, a_PosObj[2,2], a_PosObj[2,3]-35, a_PosObj[2,4],"",o_Panel3,CLR_BLUE,CLR_WHITE,.T.,.F. )
	
	o_Brw1    	:= MsSelect():New( "TRB","TB_OK",,a_Campos1,.F.,c_Marc1,{a_PosObj[2,1]-07, a_PosObj[2,2]+4, a_PosObj[2,3]-40, a_PosObj[2,4]-4},,,o_Grp1,,a_Cores)
	o_Brw1:oBrowse:Refresh()
	o_Brw1:oBrowse:lhasMark 	:= .T.
	o_Brw1:oBrowse:lCanAllmark 	:= .F.
	o_Brw1:oBrowse:bAllMark 	:= {|| f_InvertMark(c_Marc1,1)}
	o_Brw1:bMark 				:= {|| f_Mark()}

	oBtCarr 	:= TButton():New( a_PosObj[2,3]-30,a_PosObj[2,2]+04,"Carregar XML",o_Dlg1,{||f_CarregaXml()},057,012,,o_Font1,,.T.,,"",,,,.F. )
	
	oBtImpo 	:= TButton():New( a_PosObj[2,3]-30,a_PosObj[2,2]+66,"Importar",o_Dlg1,{||IIF(f_Valida(c_Marc1),f_ImpNotas(c_Marc1), .F.)/*l_VldoDlg:= .T., o_Dlg1:END()*/},057,012,,o_Font1,,.T.,,"",,,,.F. )

	o_TBitmap1	:= TBitmap():New(a_PosObj[2,3]-30,a_PosObj[2,2]+280,360,284,"br_verde",,.T.,o_Grp1,,,.F.,.F.,,,.F.,,.T.,,.F.)
	o_Say11   	:= TSay():New( a_PosObj[2,3]-30, a_PosObj[2,2]+294,{||"Não Importado"},o_Grp1,,o_Font1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,105,008)

	o_TBitmap2	:= TBitmap():New(a_PosObj[2,3]-30,a_PosObj[2,2]+350,360,284,"br_vermelho",,.T.,o_Grp1,,,.F.,.F.,,,.F.,,.T.,,.F.)
	o_Say12   	:= TSay():New( a_PosObj[2,3]-30,a_PosObj[2,2]+364,{||"Importado"},o_Grp1,,o_Font1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,105,008)
	
	oBtSair   	:= TButton():New( a_PosObj[2,3]-30,a_PosObj[2,4]-39,"&Sair",o_Dlg1,{||l_VldoDlg:= .T., o_Dlg1:END()},037,012,,o_Font1,,.T.,,"",,,,.F. )


	o_Dlg1:Activate(,,,.T.,{||,l_VldoDlg})

	DBSELECTAREA("TRB")
	TRB->(DBCLOSEAREA())

Return()

/*/{Protheus.doc} f_CarregaXml
//Carrega o Xml.
@author carlo
@since 05/05/2017
@version undefined

@type function
/*/
Static Function f_CarregaXml()

	Local o_Font2	:= TFont():New( "Calibri",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )
	Local a_Size2	:= {}	//Array contendo Tamanho da Tela
	Local a_Info2	:= {}
	Local a_PosOb2 	:= {}
	Local a_Bord2	:= {}
	Local a_Campos2	:= {}
	Local a_Object2	:= {}	//Array do aObjects (dimensionamento da MSDialog)
	Local l_VldoDl2	:= .F.				//Flag de validacao da tela
	Local c_Caminho	:= ""
	Local c_Marc2	:= GetMark()

	aAdd(a_Bord2,{"TC_OK"		,"C",TAMSX3("C5_OK")[1],0})
	aAdd(a_Bord2,{"TC_ARQUIVO"	,"C",100,0})
	c_Bord2	:= CriaTrab(a_Bord2,.t.)
	Use &c_Bord2 Shared Alias TRC New
	aAdd(a_Campos2,{"TC_OK"			,,''		,'@!'})
	AADD(a_Campos2,{'TC_ARQUIVO'	,,'Arquivo'	,'@!'})

	aAdd( a_Object2, { 315,  50, .T., .T. } )
	aAdd( a_Object2, { 100, 100, .T., .T. } )

	a_Size2	:= MsAdvSize()
	a_Info2 	:= { a_Size2[ 1 ], a_Size2[ 2 ], a_Size2[ 3 ]-300, a_Size2[4], 3, 3 }
	a_PosOb2	:= MsObjSize( a_Info2, a_Object2, .T. )

	DEFINE MSDIALOG oDlg TITLE 'Carregar arquivo XML Ct-e/NFe-S' From a_Size2[7],00 To a_Size2[6]-140,a_Size2[5]-733 OF oMainWnd PIXEL
	o_Panel2 	:= TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,1000,.T.,.F.)
	o_Panel2:Align := CONTROL_ALIGN_ALLCLIENT

	o_Grp2    	:= TGroup():New(a_PosOb2[2,1]-86, a_PosOb2[2,2], a_PosOb2[2,1]-48, a_PosOb2[2,4]-64," - Carregar Ct-e/NFe-S:",o_Panel2,CLR_BLUE,CLR_WHITE,.T.,.F. )

	oSay1     	:= TSay():New( a_PosOb2[2,1]-76, a_PosOb2[2,2]+04,{||"Caminho do(s) arquivo(s):"},o_Grp2,,o_Font2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,132,008)
	oGet1     	:= TGet():New( a_PosOb2[2,1]-64, a_PosOb2[2,2]+04,{|u| if(pcount()>0,c_Caminho:=u,c_Caminho)},o_Grp2,a_PosOb2[2,4]-94/*258*/,009,'',,CLR_BLUE,CLR_WHITE,o_Font2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet1:Disable()
	oBtAbr 	:= TButton():New( a_PosOb2[2,1]-64,a_PosOb2[2,4]-84/*a_PosOb2[2,2]+263*/,"...",oDlg,{||f_Caminho(@c_Caminho, c_Marc2)},017,012,,o_Font2,,.T.,,"",,,,.F. )

	o_Grp3    	:= TGroup():New(a_PosOb2[2,1]-44, a_PosOb2[2,2], a_PosOb2[2,3]-80, a_PosOb2[2,4]-64,"",o_Panel2,CLR_BLUE,CLR_WHITE,.T.,.F. )

	o_Brw2  	:= MsSelect():New( "TRC","TC_OK",,a_Campos2,.F.,c_Marc2,{a_PosOb2[2,1]-40, a_PosOb2[2,2]+04, a_PosOb2[2,3]-84, a_PosOb2[2,4]-68},,,oDlg)
	o_Brw2:oBrowse:Refresh()
	o_Brw2:oBrowse:lhasMark 		:= .T.
	o_Brw2:oBrowse:lCanAllmark 	:= .F.
	o_Brw2:oBrowse:bAllMark 		:= {|| f_InvertMark(c_Marc2,2)}

	oBtOK 		:= TButton():New( a_PosOb2[2,3]-74,a_PosOb2[2,2]+86,"OK",oDlg,{||f_CarrTRB(@l_VldoDl2, c_Marc2, c_Caminho)},047,012,,o_Font2,,.T.,,"",,,,.F. )
	oBtFech   	:= TButton():New( a_PosOb2[2,3]-74,a_PosOb2[2,2]+156,"Sair",oDlg,{||l_VldoDl2:= .T., oDlg:END()},047,012,,o_Font2,,.T.,,"",,,,.F. )

	oDlg:Activate(,,,.T.,{||,l_VldoDl2})

	DBSELECTAREA("TRC")
	TRC->(DBCLOSEAREA())

	DBSELECTAREA("TRB")
	TRB->(DBGOTOP())

Return()

/*/{Protheus.doc} f_CarrTRB
//Carrega a tabela principal TRB.
@author carlo
@since 05/05/2017
@version undefined
@param l_VldoDl2, logical, descricao
@param c_Marc2, characters, descricao
@param c_Caminho, characters, descricao
@type function
/*/
Static Function f_CarrTRB(l_VldoDl2, c_Marc2, c_Caminho)

	Local nHdl, oXml, oArqXml
	Local c_File		:= ""
	Local cBuffer		:= ""
	Local nTamFile	:= 0
	Local nBtLidos	:= 0
	Local c_CNPJ   	:= ""
	Local c_NumCTE	:= ""
	Local c_SerCTE	:= ""
	Local c_NumSER	:= ""
	Local c_SerSER	:= ""
	Local d_Emissao	:= ""
	Local n_VlrSer	:= 0
	Local n_VlrISS	:= 0
	Local c_Codigo	:= ""
	Local c_Loja	:= ""
	Local c_Nome	:= ""
	Local c_Chave	:= ""
	Local cAviso 	:= ""
	Local cErro  	:= ""
	Local l_Preenche:= .F.
	Local a_Notas	:= {}
	Local I			:= 0
	Local c_CTE		:= ""
	Local c_SER		:= ""
	Local l_Cte		:= .F.
	Local l_XmlCan	:= .F.
	Local n_QtdSer	:= 0
	Local n_CodigoServicoMunicipal:= 0
	Local c_CFOP	:= ""
    Local a_CNPJ	:= {}
    Local l_TagDup	:=	.F.

	Private d_Venc	:=	DTOS(Ctod("  /  /  "))
	Private n_VDup	:=	0
    
	DBSELECTAREA("TRC")
	TRC->(DBGOTOP())
	WHILE !(TRC->(EOF()))
	
		IF TRC->TC_OK == c_Marc2
			
			c_Tes	:= ""
			c_CFOP	:= ""		
			c_File	:= c_Caminho+"\"+TRC->TC_ARQUIVO
			l_XmlCan:= .F.
		
			If !File(c_File)
				ShowHelpDlg("Arquivo XML",{"Arquivo XML não encontrado!"},5,{"Localize o arquivo XML!"},5)
				Return(.F.)
			Endif
	
			nHdl    := fOpen(c_File,0)
	
			If nHdl == -1
				If !Empty(c_File)
					ShowHelpDlg("Validação",{"O arquivo de nome "+c_File+" não pode ser aberto!"},5,{"Verifique os parâmetros."},5)
				Endif
				Return(.F.)
			Endif
	
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
			fClose(nHdl)
		    
		    //Incrementando duplicata
		    l_TagDup	:=	(at("<dup>",cBuffer) > 0) .And. (at("dVenc",cBuffer) > 0) .And. (at("vDup",cBuffer) > 0)
		    
			l_Cte		:= .F.
			oXml := XmlParser(cBuffer,"_",@cAviso,@cErro)
		
			IF (XmlChildEx(oXml, "_CTE") <> NIL) //SE EXISTE A TAG DO XML DE CTE
				oArqXml 	:= oXml:_CTE
				l_Cte		:= .T.
			ELSEIF (XmlChildEx(oXml, "_CTEPROC") <> NIL) //SE EXISTE A TAG DO XML DE CTE			
				oArqXml 	:= oXml:_CTEPROC:_CTE
				l_Cte		:= .T.
			ELSEIF (XmlChildEx(oXml, "_TCLISTANFSE") <> NIL) //SE EXISTE A TAG DO XML DE SERVICO
				oArqXml := oXml:_TCLISTANFSE:_NFSE
				l_Cte		:= .F.
			ELSEIF (XmlChildEx(oXml, "_EVENTOCTE") <> NIL) //XML DE CANCELAMENTO
				oArqXml := oXml:_EVENTOCTE:_INFEVENTO
				l_XmlCan	:= .T.				
			ELSEIF (XmlChildEx(oXml, "_PROCEVENTOCTE") <> NIL) //XML DE CANCELAMENTO
				oArqXml := oXml:_PROCEVENTOCTE:_EVENTOCTE:_INFEVENTO
				l_XmlCan	:= .T.								
			ENDIF
		    
			IF (l_XmlCan)
			
				c_Chave	:= oArqXml:_CHCTE:TEXT
				//f_ConsChav( c_Chave )  //consulta a chave
				
			ELSEIF (l_Cte) .AND. !(l_XmlCan)//SE FOR CTE
		
				c_CTE	:= oArqXml:_INFCTE:_ID:TEXT //CTE
				c_Chave	:= SUBSTR(c_CTE,4,LEN(c_CTE)) //CHAVE DO CTE
				
				/* INFORMACAO SOBRE O TOMADOR DE SERVIRÃO:
				0-Remetente, 1-Expedidor, 2-Recebedor, 3-Destinatário ou 4-Outros.
				Obs.: Os dados cadastrais do tomador só serão informados quando o tomador for 4-Outros, 
				nos demais casos serão utilizados os dados cadastrais já¡ informados no respectivo grupo.
				*/
				IF (XmlChildEx(oArqXml:_INFCTE:_IDE, "_TOMA4") <> NIL) //SE EXISTE ESSA TAG		
				
					c_CNPJ   := oArqXml:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT //CNPJ DO TOMADOR DE SERVIÇO
				
				ELSE	
					
					c_Toma:= oArqXml:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT
							 
					IF c_Toma = "0" //REMETENTE
						c_CNPJ   := oArqXml:_INFCTE:_REM:_CNPJ:TEXT
					ELSEIF c_Toma = "1" //EXPEDITOR
						c_CNPJ   := oArqXml:_INFCTE:_EXPED:_CNPJ:TEXT
					ELSEIF c_Toma = "2" //RECEBEDOR
						c_CNPJ   := oArqXml:_INFCTE:_RECEB:_CNPJ:TEXT
					ELSEIF c_Toma = "3" //DESTINATARIO
						c_CNPJ   := oArqXml:_INFCTE:_DEST:_CNPJ:TEXT
					ENDIF	
										
				ENDIF

				c_NumCTE	:= oArqXml:_INFCTE:_IDE:_NCT:TEXT //NUMERO DO CTE
				c_SerCTE	:= oArqXml:_INFCTE:_IDE:_SERIE:TEXT //SERIE DO CTE
			
				d_Emissao	:= SUBSTR(oArqXml:_INFCTE:_IDE:_DHEMI:TEXT,1,10)
				d_Emissao	:= SUBSTR(d_Emissao,1,4)+SUBSTR(d_Emissao,6,2)+SUBSTR(d_Emissao,9,2)

				//Incrementando coleta da data de vencimento da duplicata
				//Vencimento
				If l_TagDup //Valida se a tag existe
					IF (ValType(oArqXml:_INFCTE:_INFCTENORM:_COBR:_DUP:_DVENC:TEXT) == "U")
						d_Venc	:=	DTOS(Ctod("  /  /  "))
					Else
						d_Venc	:= SUBSTR(oArqXml:_INFCTE:_INFCTENORM:_COBR:_DUP:_DVENC:TEXT,1,10)
						d_Venc	:= SUBSTR(d_Venc,1,4)+SUBSTR(d_Venc,6,2)+SUBSTR(d_Venc,9,2)
					Endif
	
					//valor Duplicata
					IF (ValType(oArqXml:_INFCTE:_INFCTENORM:_COBR:_DUP:_VDUP:TEXT) == "U")
						n_VDup	:=	0
					Else
						n_VDup	:= Val(oArqXml:_INFCTE:_INFCTENORM:_COBR:_DUP:_VDUP:TEXT)		
					Endif
				
				Else
					d_Venc	:=	DTOS(Ctod("  /  /  "))
					n_VDup	:=	0
				
				Endif
						
				IF (ValType("oArqXml:_INFCTE:_VPREST:_VTPREST:TEXT") == "U")
				
					n_VlrSer	:=  0
				
				ELSE
			
					n_VlrSer:= Val(oArqXml:_INFCTE:_VPREST:_VTPREST:TEXT)
			
				ENDIF
				
				//BUSCA O PRODUTO E A TES PARA OS TIPOS DE SERVICOS PRESTADOS - CTE				
				//SERVICO DE TRANSPORTE INTERMUNICIPAL E SERVICO DE TRANSPORTE INTERESTADUAL
				//ESSES TRES TIPOS DE SERVICOS POSSUEM A TAG _CFOP
								
				IF (XmlChildEx(oArqXml:_INFCTE:_IDE, "_CFOP") <> NIL)

					c_CFOP		:=	ALLTRIM(oArqXml:_INFCTE:_IDE:_CFOP:TEXT)
					If ZF7->(dbseek(xFilial("ZF7")+c_Tabela+c_CFOP,.T.))
						c_Produto	:= 	ZF7->ZF7_PROD	//PRODUTO SERVICE
						c_Tes		:= 	ZF7->ZF7_TES	//TES	
					Else
						c_Produto	:= 	""				//PRODUTO SERVICE
						c_Tes		:= 	""				//TES
					Endif	
					
					MsgAlert("Teste!!!!!","Aviso")

				ELSE
					MsgAlert("XML (Ct-e): "+TRC->TC_ARQUIVO+" não possui a TAG _CFOP. Este Xml será¡ ignorado na rotina!","Aviso")
					DBSELECTAREA("TRC")
					TRC->(DBSKIP())
					LOOP
						
				ENDIF				
		
			ELSEIF !(l_Cte) .AND. !(l_XmlCan) //SE FOR SERVICO
			
				IF VALTYPE(oArqXml) == "O" //CASO DE UM UNICO SERVICO
					n_QtdSer:= 1
				ELSEIF VALTYPE(oArqXml) == "A" //CASO DE VARRIOS SERVICOS
					n_QtdSer:= LEN(oArqXml)
				ENDIF
								
				IF (n_QtdSer = 1)
			
					c_SER		:= oArqXml:_ID:TEXT //CTE
					c_Chave		:= c_SER
					c_CNPJ   	:= oArqXml:_DADOSTOMADOR:_IDENTIFICACAOTOMADOR:_CPFCNPJ:TEXT //CNPJ DO TOMADOR
					c_NumSER	:= oArqXml:_IDENTIFICACAONFSE:_NUMERO:TEXT //NUMERO DO RPS
					c_SerSER	:= oArqXml:_IDENTIFICACAONFSE:_SERIE:TEXT //SERIE DO RPS
				
					d_Emissao	:= SUBSTR(oArqXml:_DATAEMISSAO:TEXT,1,4)+SUBSTR(oArqXml:_DATAEMISSAO:TEXT,6,2)+SUBSTR(oArqXml:_DATAEMISSAO:TEXT,9,2)
					d_Emissao	:= SUBSTR(d_Emissao,1,4)+SUBSTR(d_Emissao,5,2)+SUBSTR(d_Emissao,7,2)
					n_VlrSer	:= VAL(oArqXml:_SERVICOS:_VALORSERVICO:TEXT)
					n_VlrISS	:= VAL(oArqXml:_SERVICOS:_VALORISSQN:TEXT)
					
					//BUSCA O PRODUTO E A TES PARA OS TIPOS DE SERVICOS PRESTADOS - SERVICO				
					//SERVICO INTRAMUNICIPAL, SERVICO DE REPRESENTACAO, SERVICO DE ARMAZENAGEM
					//ESSES TRES TIPOS DE SERVICOS POSSUEM A TAG _CODIGOSERVICOMUNICIPAL
	
					IF (XmlChildEx(oArqXml:_SERVICOS, "_CODIGOSERVICOMUNICIPAL") <> NIL)
						
						n_CodigoServicoMunicipal:= VAL(oArqXml:_SERVICOS:_CODIGOSERVICOMUNICIPAL:TEXT)
						
						IF n_CodigoServicoMunicipal = 16.01 //SERVICO INTRAMUNICIPAL
						
							c_Produto	:= GETMV("FS_PRINTRA") //'100100025'
							c_Tes		:= GETMV("FS_TSINTRA")//'518'
							c_CFOP		:= ""//nao tem cfop 	
						
						ELSEIF n_CodigoServicoMunicipal = 10.09 //SERVICO DE REPRESENTACAO
					
							c_Produto	:= GETMV("FS_PRREPRE") 	//'100100028'
							c_Tes		:= GETMV("FS_TSREPRE")	//'521' 
							c_CFOP		:= ""//nao tem cfop
							
						ELSEIF n_CodigoServicoMunicipal = 11.04 //SERVICO DE ARMAZENAGEM
						
							c_Produto	:= GETMV("FS_PRARMAZ") 	//'100100029'
							c_Tes		:= GETMV("FS_TSARMAZ")	//'522' 
							c_CFOP		:= ""//nao tem cfop
							
						ENDIF
					
					ELSE
						
						MsgAlert("XML (Serviço): "+TRC->TC_ARQUIVO+" não possui a TAG _CODIGOSERVICOMUNICIPAL. Este Xml será¡ ignorado na rotina!","Aviso")
						DBSELECTAREA("TRC")
						TRC->(DBSKIP())
						LOOP
			
					ENDIF	
				
				ELSE
				
					FOR I:= 1 TO n_QtdSer
					
						c_SER		:= oArqXml[I]:_ID:TEXT //CTE
						c_Chave		:= c_SER
						c_CNPJ   	:= oArqXml[I]:_DADOSTOMADOR:_IDENTIFICACAOTOMADOR:_CPFCNPJ:TEXT //CNPJ DO TOMADOR
						c_NumSER	:= oArqXml[I]:_IDENTIFICACAONFSE:_NUMERO:TEXT //NUMERO DO RPS
						c_SerSER	:= oArqXml[I]:_IDENTIFICACAONFSE:_SERIE:TEXT //SERIE DO RPS
					
						d_Emissao	:= SUBSTR(oArqXml[I]:_DATAEMISSAO:TEXT,1,4)+SUBSTR(oArqXml[I]:_DATAEMISSAO:TEXT,6,2)+SUBSTR(oArqXml[I]:_DATAEMISSAO:TEXT,9,2)
						d_Emissao	:= SUBSTR(d_Emissao,1,4)+SUBSTR(d_Emissao,5,2)+SUBSTR(d_Emissao,7,2)
						
						//Em alguns Xml's a tag Servicos vem como um array de duas posições (exemplo abaixo) daí­ eu busco o valor do serviço da primeira posição
						If (ValType(oArqXml[I]:_SERVICOS) == "O") //Testa se eh um objeto
							
							n_VlrSer	:= VAL(oArqXml[I]:_SERVICOS:_VALORSERVICO:TEXT)
							n_VlrISS	:= VAL(oArqXml[I]:_SERVICOS:_VALORISSQN:TEXT)
							
							//BUSCA O PRODUTO E A TES PARA OS TIPOS DE SERVICOS PRESTADOS - SERVICO				
							//SERVICO INTRAMUNICIPAL, SERVICO DE REPRESENTACAO, SERVICO DE ARMAZENAGEM
							//ESSES TRES TIPOS DE SERVICOS POSSUEM A TAG _CODIGOSERVICOMUNICIPAL
			
							IF (XmlChildEx(oArqXml[I]:_SERVICOS, "_CODIGOSERVICOMUNICIPAL") <> NIL)
								
								n_CodigoServicoMunicipal:= VAL(oArqXml[I]:_SERVICOS:_CODIGOSERVICOMUNICIPAL:TEXT)
								
								IF n_CodigoServicoMunicipal = 16.01 //SERVICO INTRAMUNICIPAL
								
									c_Produto	:= GETMV("FS_PRINTRA") //'100100025'
									c_Tes		:= GETMV("FS_TSINTRA") //'518' 	
									c_CFOP		:= ""//nao tem cfop
									
								ELSEIF n_CodigoServicoMunicipal = 10.09 //SERVICO DE REPRESENTACAO
							
									c_Produto	:= GETMV("FS_PRREPRE") 	//'100100028'
									c_Tes		:= GETMV("FS_TSREPRE")	//'521' 
									c_CFOP		:= ""//nao tem cfop
										
								ELSEIF n_CodigoServicoMunicipal = 11.04 //SERVICO DE ARMAZENAGEM
								
									c_Produto	:= GETMV("FS_PRARMAZ") //'100100029'
									c_Tes		:= GETMV("FS_TSARMAZ")	//'522' 
									c_CFOP		:= ""//nao tem cfop
									
								ENDIF
							
							ELSE
								
								MsgAlert("XML (Serviço): "+TRC->TC_ARQUIVO+" não possui a TAG _CODIGOSERVICOMUNICIPAL. Este Xml será¡ ignorado na rotina!","Aviso")
								DBSELECTAREA("TRC")
								TRC->(DBSKIP())
								LOOP
					
							ENDIF
						Else
							
							n_VlrSer	:= VAL(oArqXml[I]:_SERVICOS[1]:_VALORSERVICO:TEXT) //Pego o valor da primeira posição , pois pelo visto são iguais
							n_VlrISS	:= VAL(oArqXml[I]:_SERVICOS[1]:_VALORISSQN:TEXT)//Pego o valor da primeira posições , pois pelo visto são iguais
							
							//BUSCA O PRODUTO E A TES PARA OS TIPOS DE SERVICOS PRESTADOS - SERVICO				
							//SERVICO INTRAMUNICIPAL, SERVICO DE REPRESENTACAO, SERVICO DE ARMAZENAGEM
							//ESSES TRES TIPOS DE SERVICOS POSSUEM A TAG _CODIGOSERVICOMUNICIPAL
			
							IF (XmlChildEx(oArqXml[I]:_SERVICOS[1], "_CODIGOSERVICOMUNICIPAL") <> NIL)
								
								n_CodigoServicoMunicipal:= VAL(oArqXml[I]:_SERVICOS[1]:_CODIGOSERVICOMUNICIPAL:TEXT)
								
								IF n_CodigoServicoMunicipal = 16.01 //SERVICO INTRAMUNICIPAL
								
									c_Produto	:= GETMV("FS_PRINTRA") //'100100025'
									c_Tes		:= GETMV("FS_TSINTRA") //'518' 	
									c_CFOP		:= ""//nao tem cfop
									
								ELSEIF n_CodigoServicoMunicipal = 10.09 //SERVICO DE REPRESENTACAO
							
									c_Produto	:= GETMV("FS_PRREPRE") //'100100028'
									c_Tes		:= GETMV("FS_TSREPRE") //'521' 
									c_CFOP		:= ""//nao tem cfop
										
								ELSEIF n_CodigoServicoMunicipal = 11.04 //SERVICO DE ARMAZENAGEM
								
									c_Produto	:= GETMV("FS_PRARMAZ") //'100100029'
									c_Tes		:= GETMV("FS_TSARMAZ") //'522' 
									c_CFOP		:= ""//nao tem cfop
									
								ENDIF
							
							ELSE
								
								MsgAlert("XML (Serviço): "+TRC->TC_ARQUIVO+" não possui a TAG _CODIGOSERVICOMUNICIPAL. Este Xml será¡ ignorado na rotina!","Aviso")
								DBSELECTAREA("TRC")
								TRC->(DBSKIP())
								LOOP
					
							ENDIF 
							
						EndIF					
						
						DBSELECTAREA("SA1")
						DBSETORDER(3)
						IF DBSEEK(XFILIAL("SA1")+c_CNPJ)
					
							c_Codigo	:= SA1->A1_COD
							c_Loja		:= SA1->A1_LOJA
							c_Nome		:= SA1->A1_NOME
						
							l_Preenche:= .T.
						
							AADD(a_Notas,{"SER",c_NumSER,c_SerSER,c_Codigo,c_Loja,c_Nome,STOD(d_Emissao),n_VlrSer,c_Chave, c_Produto, c_Tes, c_CFOP})
			
						ELSE
						
							//MsgAlert("CNPJ "+c_CNPJ+" do XML(Serviço): "+c_SER+" não encontrado no cadastro de clientes!","Aviso")
							IF (Ascan(a_CNPJ,c_CNPJ) == 0)	
								AADD(a_CNPJ,Transform(c_CNPJ, "@R 99.999.999/9999-99" ) )
							ENDIF
							
						ENDIF
								
					NEXT
			
				ENDIF				
				
			ENDIF
		
			IF (l_Cte) .OR. (n_QtdSer = 1) //O SERVICO JA FACO NO TRECHO ACIMA
			
				DBSELECTAREA("SA1")
				DBSETORDER(3)
				IF DBSEEK(XFILIAL("SA1")+c_CNPJ)
			
					c_Codigo	:= SA1->A1_COD
					c_Loja		:= SA1->A1_LOJA
					c_Nome		:= SA1->A1_NOME
				
					l_Preenche:= .T.
				
					IF (l_Cte)
									
						AADD(a_Notas,{"CTE",c_NumCTE,c_SerCTE,c_Codigo,c_Loja,c_Nome,STOD(d_Emissao),n_VlrSer,c_Chave, c_Produto, c_Tes, c_CFOP ,STOD(d_Venc) ,n_VDup})
				
					ELSE
						d_Venc	:=	DTOS(Ctod("  /  /  "))
						n_VDup	:=	0
						AADD(a_Notas,{"SER",c_NumSER,c_SerSER,c_Codigo,c_Loja,c_Nome,STOD(d_Emissao),n_VlrSer,c_Chave, c_Produto, c_Tes, c_CFOP, STOD(d_Venc) ,n_VDup})
				
					ENDIF
	
				ELSE
				
					IF (l_Cte)
				
						//MsgAlert("CNPJ "+c_CNPJ+" do XML(Ct-e): "+c_CTE+" não encontrado no cadastro de clientes!","Aviso")
						IF (Ascan(a_CNPJ,c_CNPJ) == 0)	
							AADD(a_CNPJ,Transform(c_CNPJ, "@R 99.999.999/9999-99" ) )
						ENDIF
						
					ELSE
					
						//MsgAlert("CNPJ "+c_CNPJ+" do XML(Serviço): "+c_SER+" não encontrado no cadastro de clientes!","Aviso")
						IF (Ascan(a_CNPJ,c_CNPJ) == 0)	
							AADD(a_CNPJ,Transform(c_CNPJ, "@R 99.999.999/9999-99" ) )
						ENDIF
						
					ENDIF
							
				ENDIF
		
			ENDIF
		
		ENDIF
		
		DBSELECTAREA("TRC")
		TRC->(DBSKIP())
	
	ENDDO

	IF (l_Preenche)

		DBSELECTAREA("TRB")
		TRB->(DBGOTOP())
		WHILE TRB->(!EOF())
	
			RECLOCK("TRB",.F.)
			DBDELETE()
			MSUNLOCK()
		
			TRB->(DBSKIP())
		
		ENDDO
	
		DBSELECTAREA("TRB")
		TRB->(DBGOTOP())
	
		FOR I:= 1 TO LEN(a_Notas)
		
			DBSELECTAREA("TRB")
			RECLOCK("TRB",.T.)
			TRB->TB_TIPO	:= a_Notas[I][1]
			TRB->TB_NUM		:= STRZERO(VAL(a_Notas[I][2]),9) //PADRRAO DE NOTA DO PROTHEUS, MINUMO 6 DIGITOS
			TRB->TB_SER		:= a_Notas[I][3]
			TRB->TB_CLI		:= a_Notas[I][4]
			TRB->TB_LOJ		:= a_Notas[I][5]
			TRB->TB_NOM		:= a_Notas[I][6]
			TRB->TB_EMISSAO	:= a_Notas[I][7]
			TRB->TB_VALOR	:= a_Notas[I][8]
			TRB->TB_CHAVE	:= a_Notas[I][9]
			TRB->TB_PRODUTO	:= a_Notas[I][10]
			TRB->TB_TES		:= a_Notas[I][11]
			TRB->TB_CF		:= a_Notas[I][12]
			TRB->TB_VENC	:= a_Notas[I][13]
			TRB->TB_PARC1	:= a_Notas[I][14]
		
			DBSELECTAREA("SF2")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SF2")+TRB->TB_NUM+TRB->TB_SER)
		
				TRB->TB_BITMAP:= 2
			
			ELSE
		
				TRB->TB_BITMAP:= 1
		
			ENDIF
		
			MSUNLOCK()
	        
		NEXT
	
	ENDIF

	DBSELECTAREA("TRB")
	TRB->(DBGOTOP())
	
	l_VldoDl2:= .T.
	oDlg:END()
    
	IF LEN(a_CNPJ) > 0  //mostra a tela com os cnpj não encontrados na base
	
		f_Tela(a_CNPJ)
		
	ENDIF
	
Return

/*/{Protheus.doc} f_ImpNotas
//Importa das Notas.
@author 
@since 05/05/2017
@version undefined
@param c_Marc1, characters, descricao
@type function
/*/
Static Function f_ImpNotas(c_Marc1)
	//Local c_TES	:= ""
	
	DBSELECTAREA("TRB")
	TRB->(DBGOTOP())
	WHILE TRB->(!EOF())
	
		IF TRB->TB_OK == c_Marc1
	
			IF TRB->TB_BITMAP = 1 //VERDE - NAO IMPORTADA
				
				BEGIN TRANSACTION
					
					DBSELECTAREA("SF4")
					DBSETORDER(1)
					IF (DBSEEK(XFILIAL("SF4")+TRB->TB_TES))
						
						l_Continua := .T.
						If SF4->(FieldPos("SF4->F4_FSCC")) > 0
							If EMPTY(SF4->F4_FSCC)
								l_Continua := .F.										
							Endif
						Endif
											
						IF !l_Continua
							
							MsgAlert("A TES: "+TRB->TB_TES+" não possui o centro de resultado amarrado. Realize a amarração do Centro de Resultado no cadastro da TES.","Aviso")	
																				
						ELSE
							//Coletando Condição de Pagamento no cliente
							c_UsaCond := Upper(Alltrim(SuperGetMV("FS_XMLCD",.F.,"P"))) //C=cadastro do cliente X=Xml Tag dVenc P=Parametro Global FS_CONDPG 
							
							If c_UsaCond == "C" 
								c_CondPag	:=	Posicione("SA1",1,xFilial("SA1")+TRB->TB_CLI+TRB->TB_LOJ,"A1_COND")
								d_Venc		:=	Ctod("  /  /  ")
								n_Parcela	:=	0	
							ElseIf c_UsaCond == "P"
								c_CondPag	:=	Alltrim(SUPERGETMV("FS_CONDPG",.F.,"001"))
								d_Venc		:=	Ctod("  /  /  ")
								n_Parcela	:=	0	
							ElseIf c_UsaCond == "X"
								c_CondPag	:=	Alltrim(SUPERGETMV("FS_CONDPG",.F.,"001"))
								If TRB->(!Empty(TRB->TB_VENC) .And. !Empty(TB_PARC1))
									d_Venc		:=	TRB->TB_VENC
									n_Parcela	:=	TRB->TB_PARC1
								Else
									d_Venc		:=	Ctod("  /  /  ")
									n_Parcela	:=	0	
								Endif	
							Else
								d_Venc		:=	Ctod("  /  /  ")
								n_Parcela	:=	0	
							Endif

							l_CondPag := SE4->(dbSeek(xFilial("SE4")+c_CondPag,.T.))
							
							If !l_CondPag
								If !msgYesNo("Documento No.[ "+TRB->TB_NUM+"] não foi processado porque a condição de pagamento código ["+c_CondPag+"] não está cadastrada nesta filial. Deseja Continuar o processo de importação ? ")
									msgInfo("Xml atual não importado, processo de importação será encerrado.")
									Return//Exit
								Else
									msgInfo("Xml atual não importado, processo de importação continuará com o próximo da lista.")
								Endif
							Else 
								//Geracao de nota com pedido de venda
								LjMsgRun("Aguarde... Gerando Pedido de Venda...","Importação Ct-e/NFe-S",{|| f_GeraPedidoVenda(TRB->TB_CLI, TRB->TB_LOJ, TRB->TB_NOM, c_CondPag, TRB->TB_EMISSAO, TRB->TB_PRODUTO, TRB->TB_TES, TRB->TB_VALOR,d_Venc,n_Parcela) })
							
							Endif
							
							IF !(l_ErroPedido)
							
								LjMsgRun("Aguarde... Gerando Nota Fiscal...","Importação Ct-e/NFe-S",{|| f_GeraNota(c_Pedido, TRB->TB_NUM, TRB->TB_SER) })
							
								//ATUALIZA O FLAG
								DBSELECTAREA("TRB")
								RECLOCK("TRB",.F.)
								TRB->TB_BITMAP:= 2
								TRB->TB_OK		:= "  "
								MSUNLOCK()
							
							ENDIF 
							
						ENDIF
					
					ENDIF
					
				END TRANSACTION
								
			ENDIF
		
		ENDIF
		
		DBSELECTAREA("TRB")
		TRB->(DBSKIP())
	
	ENDDO
	
	DBSELECTAREA("TRB")
	TRB->(DBGOTOP())
	
Return()

/*/{Protheus.doc} f_Caminho
//Caminho do arquivo
@author 
@since 05/05/2017
@version undefined
@param c_Caminho, characters, descricao
@param c_Marc2, characters, descricao
@type function
/*/
Static Function f_Caminho(c_Caminho, c_Marc2)

	Local a_Files	:= {}
	Local i		:= 1
 
	c_Caminho:= cGetFile( "Arquivo CT-e (*.xml) | *.xml" , 'Arquivos XML', 1, 'C:\temp\', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY, GETF_NETWORKDRIVE ),.T., .T. )
	oGet1:Refresh()

	a_Files := Directory(c_Caminho+"\*.xml", "D")

	For i:= 1 to Len(a_Files)
	
		DBSELECTAREA("TRC")
		RECLOCK("TRC",.T.)
		TRC->TC_OK			:= c_Marc2
		TRC->TC_ARQUIVO	:= a_Files[i,1]
		MSUNLOCK()
	
	Next

	DBSELECTAREA("TRC")
	TRC->(DBGOTOP())

Return()

/*/{Protheus.doc} f_InvertMark
//Inverte a marca.
@author 
@since 05/05/2017
@version undefined
@param c_Marca, characters, descricao
@param c_Tipo, characters, descricao
@type function
/*/
Static Function f_InvertMark(c_Marca, c_Tipo)

	IF (c_Tipo = 1)

		DBSELECTAREA("TRB")
		TRB->(DBGOTOP())
		WHILE TRB->(!EOF())
		
			RECLOCK("TRB",.F.)			
			IF TRB->TB_OK <> c_Marca
				IF TRB->TB_BITMAP = 1 //NAO IMPORTADO
					TRB->TB_OK := c_Marca
				ENDIF
			ELSE
				TRB->TB_OK := " "
			ENDIF
			MSUNLOCK()
		
			TRB->(DBSKIP())
		
		ENDDO
	
		TRB->(DBGOTOP())
		o_Brw1:oBrowse:Refresh()

	ELSE

		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())
		WHILE TRC->(!EOF())
		
			RECLOCK("TRC",.F.)
			IF TRC->TC_OK <> c_Marca
				TRC->TC_OK := c_Marca
			ELSE
				TRC->TC_OK := " "
			ENDIF
			MSUNLOCK()
		
			TRC->(DBSKIP())
		
		ENDDO
	
		TRC->(DBGOTOP())
		o_Brw2:oBrowse:Refresh()
	
	ENDIF

Return()

/*/{Protheus.doc} f_Valida
//Funcao responsavel por gerar o relatorio 
@author carlo
@since 05/05/2017
@version undefined
@param c_Marc1, characters, descricao
@type function
/*/
Static Function f_Valida(c_Marc1)
Local l_TemMarcados	:= .F.
Local l_Ret			:= .T.

DBSELECTAREA("TRB")
TRB->(DBGOTOP())
DO WHILE TRB->(!EOF())
	
	IF TRB->TB_OK == c_Marc1  //SE NAO ESTA MARCADO
		l_TemMarcados:= .T.
		EXIT		
	ENDIF
	TRB->(DBSKIP())
	
ENDDO

IF !(l_TemMarcados)
	
	MsgAlert("Marque algum registro!","Aviso")
	TRB->(DBGOTOP())
	l_Ret:= .F.

ELSE
	
	DBSELECTAREA("TRB")
	TRB->(DBGOTOP())
	DO WHILE TRB->(!EOF())
		
		IF TRB->TB_OK == c_Marc1  //SE NAO ESTA MARCADO
			
			IF TRB->TB_BITMAP = 2
			
				MsgAlert("Existe algum registro marcado que já¡ foi importado!","Aviso")	
				TRB->(DBGOTOP())
				l_Ret:= .F.
				EXIT	
			
			ENDIF
				
		ENDIF
		
		TRB->(DBSKIP())
		
	ENDDO
	
ENDIF


Return(l_Ret)

/*/{Protheus.doc} f_GeraPedidoVenda
//Funcao responsavel por gerar o pedido de venda
@author 
@since 05/05/2017
@version undefined
@param c_Cliente, characters, descricao
@param c_Loja, characters, descricao
@param c_Nome, characters, descricao
@param c_CondPag, characters, descricao
@param d_Emissao, date, descricao
@param c_Prod, characters, descricao
@param c_TesPV, characters, descricao
@param n_Valor, numeric, descricao
@type function
/*/
Static Function f_GeraPedidoVenda(c_Cliente, c_Loja, c_Nome, c_CondPag, d_Emissao, c_Prod, c_TesPV, n_Valor ,d_Venc ,n_Parcela)

	Local a_CabSC5		:= {}
	Local a_IteSC6		:= {}
	Local c_CF			:= ""
	Local n_X			
	Private INCLUI 		:= .T.	// Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
	Private ALTERA 		:= .F.	// Variavel necessária para o ExecAuto identificar que se
	Private lMsHelpAuto 	:= .T.
	Private lMsErroAuto 	:= .F.

	Default d_Venc		:=	Ctod("  /  /  ")
	Default n_Parcela	:=	0
	
	//PREENCHE AS VARIAVEIS PARA O PEDIDO DE VENDA		
	a_CabSC5	:= {}
	a_IteSC6	:= {}
	
	DBSELECTAREA("SF4")
	DBSETORDER(1)
	IF (DBSEEK(XFILIAL("SF4")+c_TesPV))
							
		c_CF:= SF4->F4_CF
		c_Resultado:= IIF(SF4->(FieldPos("F4_FSCC")) > 0, SF4->F4_FSCC, "")
	
	ENDIF

	n_Valor	:=	Iif(n_Valor > 0, Round(n_Valor,2), n_Valor)
			
	a_CabSC5	:=	{}
	AADD(a_CabSC5,{"C5_FILIAL"	, CFILANT 		,NIL})	//FILIAL
	AADD(a_CabSC5,{"C5_TIPO" 	, "N"   		,NIL})	//TIPO DE PEDIDO - NORMAL
	AADD(a_CabSC5,{"C5_CLIENTE"	, c_Cliente		,NIL})	//CLIENTE
	AADD(a_CabSC5,{"C5_LOJACLI"	, c_Loja		,NIL})	//LOJA
	AADD(a_CabSC5,{"C5_NOMCLI" 	, c_Nome		,NIL})	//NOME CLIENTE
	AADD(a_CabSC5,{"C5_TIPOCLI"	, "F"			,NIL})	//TIPO DO CLIENTE
	AADD(a_CabSC5,{"C5_CONDPAG"	, c_CondPag		,NIL})	//COND. PAGAMENTO(E4_COND TEM QUE SER IGUAL A ZERO P NAO GERAR DUPLICATA)
	If SC5->(FieldPos("C5_CC")) > 0
		AADD(a_CabSC5,{"C5_CC"	, c_Resultado	,NIL})	//C.RESULRADO
	Endif
	AADD(a_CabSC5,{"C5_EMISSAO"	, d_Emissao		,NIL})	//EMISSAO DO TITULO
	AADD(a_CabSC5,{"C5_MOEDA"  	, 1				,NIL})	//MOEDA
	If !Empty(d_Venc) .And. !Empty(n_Parcela)
		AADD(a_CabSC5,{"C5_DATA1", d_Venc		,NIL})	//Vencimento Parcela 1
		AADD(a_CabSC5,{"C5_PARC1", n_Valor 		,NIL}) 	//Valor da parcela 1
	Endif

	If ExistBlock( "PFT460A" ) //PE PARA INCLUIR CAMPOS NO CABECALHO DO PEDIDO
		a_Campos	:= ExecBlock( "PFT460A", .F., .F. )//, {a_Campos} )
		If !Empty(a_Campos) .And. a_Campos <> Nil
			For n_X := 1 to len(a_Campos)
				AADD(a_CabSC5,{ aCampos[n_X][1], aCampos[n_X][2], aCampos[n_X][3] } )
			Next 
		Endif
	EndIf

	
	a_IteSC6	:=	{}
	a_Campos	:=	{}
	AADD(a_Campos,{"C6_FILIAL" 		, CFILANT			,NIL})												//FILIAL
	AADD(a_Campos,{"C6_ITEM"	 	, "01"				,NIL}) 												//NUMERO DO ITEM DO PEDIDO
	//If SC6->(FieldPos("C6_FSMIX")) > 0
	//	AADD(a_Campos,{"C6_FSMIX" 	, 1					,NIL})
	//Endif
	AADD(a_Campos,{"C6_PRODUTO"		, c_Prod			,NIL})												//PRODUTO
	AADD(a_Campos,{"C6_DESCRI" 		, Posicione("SB1",1,xFilial("SB1")+c_Prod,"B1_DESC") 			,NIL})	//DESCRICAO
	AADD(a_Campos,{"C6_UM"  	 	, Posicione("SB1",1,xFilial("SB1")+c_Prod,"B1_UM") 				,NIL})	//UNIDADE DE MEDIDA
	AADD(a_Campos,{"C6_CLI"  		, c_Cliente			,NIL})												//CLIENTE
	AADD(a_Campos,{"C6_LOJA" 		, c_Loja			,NIL})												//LOJA
	AADD(a_Campos,{"C6_TES"  		, c_TesPV			,NIL})												//TES
	AADD(a_Campos,{"C6_ENTREGA" 	, d_Emissao			,NIL})												//ENTREGA
	AADD(a_Campos,{"C6_QTDVEN" 		, 1					,NIL})												//QUANTIDADE
	AADD(a_Campos,{"C6_PRCVEN" 		, n_Valor			,NIL})												//VALOR UNITÁRIO
	AADD(a_Campos,{"C6_VALOR " 		, n_Valor			,NIL})												//DATA DE ENTREGA
	
	If ExistBlock( "PFT460B" ) //PE PARA INCLUIR CAMPOS NOS ITENS DO PEDIDO
		a_Camitens	:= ExecBlock( "PFT460B", .F., .F.)//, a_Campos )
		If Valtype(a_Camitens) == "A"
			If !Empty(a_Camitens) .And. a_Camitens <> Nil
				For n_X := 1 to len(a_Camitens)
					AADD(a_Campos,{ a_Camitens[n_X][1], a_Camitens[n_X][2], a_Camitens[n_X][3] } )
				Next 
			Endif
		Endif
	EndIf
	
	aAdd(a_IteSC6,a_Campos)
	
	BEGIN TRANSACTION
		
		//GRAVACAO DO PEDIDO DE VENDA		
		lMsHelpAuto 	:= .T.
		lMsErroAuto 	:= .F.
		INCLUI 			:= .T.
		ALTERA 			:= .F.
	
		MSExecAuto({|x,y,z| MATA410(x,y,z)},a_CabSC5,a_IteSC6,3)
		
		l_ErroPedido:= .F.
	
		IF lMsErroAuto
		
			l_ErroPedido:= .T.
			If l_ErroPedido
				MostraErro()
				DisarmTransaction()
				BREAK
			Endif
			
			
		Endif
		
		If !l_ErroPedido
		
			//Chama a funcao de liberacao de pedido
			MA410LBNFS(2)
			
			//Chama evento de liberacao de regras com o SC5 posicionado 
			MaAvalSC5("SC5",9)
		
			c_Pedido:= SC5->C5_NUM
			
			//GRAVA O FORNECEDOR DE ISS			
			DBSELECTAREA("SC5")
			RECLOCK("SC5",.F.)
			SC5->C5_FORNISS:= GETMV("FS_FORISS")
			MSUNLOCK()
						
		ENDIF

	END TRANSACTION

Return()

/*/{Protheus.doc} f_GeraNota
//Rotina que gera a NF de Saida.
@author carlo
@since 05/05/2017
@version undefined
@param c_NumPed, characters, descricao
@param c_Doc, characters, descricao
@param c_SerDoc, characters, descricao
@type function
/*/
Static Function f_GeraNota(c_NumPed, c_Doc, c_SerDoc)
	
	Local cTes			:= ""
	Local cCondPag	:= ""
	Local cNota		:= ""
	Private cSerie	:= c_SerDoc
	Private cNumero	:= c_Doc
	
	aPVlNFs := {}
	
	//Funcao automatica para pegar a serie e o numero da nota fiscal.
	//lRet := Sx5NumNota()
	
	DbSelectArea("SX5")
	DbSetOrder(1)
	If !DbSeek(xFilial("SX5")+"01"+cSerie)
		MsgInfo("Série Inválida!","Geração de NF")
		Return()     
	Else
		RecLock("SX5",.F.)              
		SX5->X5_DESCRI 	:= cNumero
		SX5->X5_DESCSPA := cNumero
		SX5->X5_DESCENG := cNumero
      MsUnlock()	
	EndIF
	
	IncProc()
	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+c_NumPed)
	While !EOF() .And. (C9_FILIAL+C9_PEDIDO = xFilial("SC9")+c_NumPed)
	     If SC9->C9_BLCRED == "  " .And. SC9->C9_BLEST == "  "
	          
	          cTes := Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,"C6_TES")
	          cCondPag := Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,"C5_CONDPAG")
	          aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
	          SC9->C9_ITEM,;
	          SC9->C9_SEQUEN,;
	          SC9->C9_QTDLIB,;
	          SC9->C9_PRCVEN,;
	          SC9->C9_PRODUTO,;
	          SF4->F4_ISS=="S",;
	          SC9->(RecNo()),;
	          SC5->(Recno(Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,""))),;
	          SC6->(Recno(Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,""))),;
	          SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+cCondPag,""))),;
	          SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
	          SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO,""))),;
	          SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+cTes,""))),;
	          Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO,"B2_LOCAL"),;
	          1,;
	          SC9->C9_QTDLIB2})
	          
	     EndIf
	     DbSelectArea("SC9")
	     DbSkip()
	End
		
	If Len(aPvlNfs) > 0
	     
	     Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"")
	     
	     cNota := MAPVLNFS(aPVlNFs,cSerie,.F.,.F.,.F.,.F.,.F.,1,1,.T.,.F.,,,)
	     
	     If Empty(cNota)
	          
	          Alert("Ocorreu um problema na geração da Nota Fiscal")
	          
	     Else
	          //MsgAlert(cNota,"Nota")
	     EndIf
	     
	Else
	     Alert("Pedido com itens não liberados!")
	EndIf

Return()

/*/{Protheus.doc} f_Mark
//valida a marcacao (duplo clique no registro 
@author carlo
@since 05/05/2017
@version undefined

@type function
/*/
Static Function f_Mark()
	
	IF TRB->TB_BITMAP == 2
			
		MsgAlert("Xml já¡ importado!","Aviso")
		RECLOCK("TRB",.F.)
		TRB->TB_OK := " "
		MSUNLOCK()
		
	ENDIF
	
Return()

/*/{Protheus.doc} f_Tela
//
@author 
@since 05/05/2017
@version undefined
@param a_CNPJ, array, descricao
@type function
/*/
Static Function f_Tela(a_CNPJ)
Local i				:= 0
Local a_Size		:= {}	//Dimensionamento de Tela
Local a_Info		:= {}	//Dimensionamento de Tela
Local a_PosObj 		:= {}	//Dimensionamento de Tela
Local a_Objects		:= {}	//Dimensionamento de Tela
Local l_Vld			:= .F.
Local oFont			:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
Local o_Dlg2
Local c_CNPJ		:= ""
If Len(a_CNPJ) > 0
		
	l_Continua:= .F.
	
	For i:= 1 To Len(a_CNPJ)
		c_CNPJ+= a_CNPJ[i] + CHR(13)+CHR(10)
	Next
	
	MsgAlert("Existem CNPJs que não foram encontrados no Protheus!","Aviso")
	
	aAdd( a_Objects, { 75, 50, .T., .T. } ) 	// Enchoice
	aAdd( a_Objects, { 00, 750, .T., .T. } ) 	// GetDados
	
	a_Size		:= MsAdvSize()
	a_Info 	:= { a_Size[ 1 ], a_Size[ 2 ], a_Size[ 3 ], a_Size[4]+20, 1, 1 }
	a_PosObj 	:= MsObjSize( a_Info, a_Objects, .T. )	
	o_Font1   	:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	
	DEFINE MSDIALOG o_Dlg2 TITLE "CNPJ Não Encontrados" From a_Size[7],00 To a_Size[6],a_Size[5]-960 OF oMainWnd PIXEL
	o_Panel3 	:= TPanel():New(0,0,"",o_Dlg2,NIL,.T.,.F.,NIL,NIL,0,1000,.T.,.F.)
	o_Panel3:Align := CONTROL_ALIGN_ALLCLIENT	
	o_Grp1    	:= TGroup():New(a_PosObj[2,1]-11, a_PosObj[2,2], a_PosObj[2,3]-35, a_PosObj[2,4]-478,"",o_Panel3,CLR_BLUE,CLR_WHITE,.T.,.F. )
	oMGet 	:= TMultiget():New(a_PosObj[2,1]-07, a_PosObj[2,2]+4,{|u|if(Pcount()>0,c_CNPJ:=u,c_CNPJ)},o_Grp1,164,a_PosObj[2,3]-55,,,,,,.T.)
	oBtOk   := TButton():New(  a_PosObj[2,3]-30,a_PosObj[2,2]+4,"Fechar",o_Dlg2,{||l_Vld:= .T., o_Dlg2:END()},037,012,,oFont,,.T.,,"",,,,.F. )
	o_Dlg2:Activate(,,,.T.,{||,l_Vld})
		
EndIf

Return()

/*/{Protheus.doc} f_GeraNF
//.
@author 
@since 05/05/2017
@version undefined
@param c_Cliente, characters, descricao
@param c_Loja, characters, descricao
@param c_Doc, characters, descricao
@param c_Serie, characters, descricao
@param d_Emissao, date, descricao
@param c_Chave, characters, descricao
@param c_Prod, characters, descricao
@param n_Valor, numeric, descricao
@param c_TesPV, characters, descricao
@type function
/*/
Static Function f_GeraNF(c_Cliente, c_Loja, c_Doc, c_Serie, d_Emissao, c_Chave, c_Prod, n_Valor, c_TesPV)

	Local aCabec 	:= {}
	Local aItens 	:= {}
	Local aLinha 	:= {}
	Local c_CF		:= ""
	
	PRIVATE lMsErroAuto 	:= .F.

	aadd(aCabec,{"F2_TIPO"   	,"N"})
	aadd(aCabec,{"F2_FORMUL" 	,"N"}) 
	aadd(aCabec,{"F2_DOC"    	,c_Doc})
	aadd(aCabec,{"F2_SERIE"  	,c_Serie})
	aadd(aCabec,{"F2_EMISSAO"	,d_Emissao})
	aadd(aCabec,{"F2_CLIENTE"	,c_Cliente})
	aadd(aCabec,{"F2_LOJA"   	,c_Loja})
	aadd(aCabec,{"F2_ESPECIE"	,"CTE"})  
	aadd(aCabec,{"F2_DESCONT"	,0})
	aadd(aCabec,{"F2_FRETE"		,0})
	aadd(aCabec,{"F2_SEGURO"	,0})
	aadd(aCabec,{"F2_DESPESA"	,0})			
	aadd(aCabec,{"F2_CHVNFE"	,c_Chave})		
	
	DBSELECTAREA("SF4")
	DBSETORDER(1)
	IF (DBSEEK(XFILIAL("SF4")+c_TesPV))					
		c_CF:= SF4->F4_CF	
	ENDIF
	
	aLinha := {}
	aadd(aLinha,{"D2_ITEM"  ,"01"	,Nil})
	aadd(aLinha,{"D2_COD"  	,c_Prod	,Nil})
	aadd(aLinha,{"D2_QUANT"	,1		,Nil})
	aadd(aLinha,{"D2_PRCVEN",n_Valor,Nil})
	aadd(aLinha,{"D2_TOTAL"	,n_Valor,Nil})				
	aadd(aLinha,{"D2_TES"	,c_TesPV,Nil})
	aadd(aItens,aLinha)

	Begin Transaction
				
		lMsErroAuto 	:= .F.		
						
		MATA920(aCabec,aItens)
		
		IF lMsErroAuto
			
			l_ErrNF :=.T.
			MostraErro()
			DisarmTransaction()
			break
							
		ELSE
		    
		    l_ErrNF:= .F.
			//LIMPA O ORIGLAN PARA PODER EXCLUIR PELA ROTINA PADRÃƒO
			DBSELECTAREA("SD2")
			DBSETORDER(3)
			IF DBSEEK(XFILIAL("SD2")+c_Doc+SPACE(TAMSX3("D2_DOC")[1]-LEN(c_Doc))+c_Serie+c_Cliente+c_Loja)
			
				WHILE !(SD2->(EOF())) .AND. (SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == XFILIAL("SD2")+c_Doc+SPACE(TAMSX3("D2_DOC")[1]-LEN(c_Doc))+c_Serie+c_Cliente+c_Loja)
				
					RECLOCK("SD2",.F.)
					SD2->D2_ORIGLAN:= ""			
					MSUNLOCK()	
									
					DBSELECTAREA("SD2")
					SD2->(DBSKIP())
					
				ENDDO
			
			ENDIF
											
		ENDIF							
		
	End Transaction

Return()

/*/{Protheus.doc} f_CancNF
//
@author 
@since 05/05/2017
@version undefined
@param c_Cliente, characters, descricao
@param c_Loja, characters, descricao
@param c_Doc, characters, descricao
@param c_Serie, characters, descricao
@param c_Chave, characters, descricao
@type function
/*/
Static Function f_CancNF(c_Cliente, c_Loja, c_Doc, c_Serie, c_Chave)
	
	Local aCabec 		:= {}
	Local aItens 		:= {}
	Local aLinha 		:= {}
	Local d_DtCanc		:= ""
	Local l_JaCancelou	:= .F.
	
	PRIVATE lMsErroAuto := .F.
			
	l_JaCancelou:= .F.
	
	//VERIFICA SE JA CANCELOU				
	c_Qry	:= "SELECT F3_OBSERV, F3_CHVNFE, F3_NFISCAL, F3_SERIE FROM "+RETSQLNAME("SF3")+" SF3 WHERE D_E_L_E_T_ <> '*' AND F3_CHVNFE = '"+c_Chave+"' "
	TCQUERY c_QRY ALIAS QRYF3 NEW
	IF !QRYF3->(EOF())
		
		IF ALLTRIM(QRYF3->F3_OBSERV) == "NF CANCELADA"
			
			l_JaCancelou:= .T.
		
		ENDIF 
	
	ENDIF				
	
	QRYF3->(DBCLOSEAREA())
	
	IF !(l_JaCancelou)
		
		aCabec 	:= {}
		aItens 	:= {}
		
		DBSELECTAREA("SF2")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SF2")+c_Doc+SPACE(TAMSX3("D2_DOC")[1]-LEN(c_Doc))+c_Serie+c_Cliente+c_Loja)
						
			aadd(aCabec,{"F2_TIPO"   	,SF2->F2_TIPO})
			aadd(aCabec,{"F2_FORMUL" 	,SF2->F2_FORMUL})
			aadd(aCabec,{"F2_DOC"    	,SF2->F2_DOC})
			aadd(aCabec,{"F2_SERIE"  	,SF2->F2_SERIE})
			aadd(aCabec,{"F2_EMISSAO"	,SF2->F2_EMISSAO})
			aadd(aCabec,{"F2_CLIENTE"	,SF2->F2_CLIENTE})
			aadd(aCabec,{"F2_LOJA"   	,SF2->F2_LOJA})
			
			d_DtCanc:= SF2->F2_EMISSAO
										
			//RETORNA O ORIGLAN PARA PODER EXCLUIR PELA ROTINA MATA920
			DBSELECTAREA("SD2")
			DBSETORDER(3)
			IF DBSEEK(XFILIAL("SD2")+c_Doc+SPACE(TAMSX3("D2_DOC")[1]-LEN(c_Doc))+c_Serie+c_Cliente+c_Loja)
			
				WHILE !(SD2->(EOF())) .AND. (SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == XFILIAL("SD2")+c_Doc+SPACE(TAMSX3("D2_DOC")[1]-LEN(c_Doc))+c_Serie+c_Cliente+c_Loja)
				
					RECLOCK("SD2",.F.)
					SD2->D2_ORIGLAN:= "LF"			
					MSUNLOCK()	
					
					aadd(aLinha,{"D2_ITEM"  ,SD2->D2_ITEM	,Nil})
					aadd(aLinha,{"D2_COD"  	,SD2->D2_COD	,Nil})
					aadd(aLinha,{"D2_QUANT"	,SD2->D2_QUANT	,Nil})
					aadd(aLinha,{"D2_PRCVEN",SD2->D2_PRCVEN	,Nil})
					aadd(aLinha,{"D2_TOTAL"	,SD2->D2_TOTAL	,Nil})
					aadd(aLinha,{"D2_TES"	,SD2->D2_TES	,Nil})
					aadd(aLinha,{"D2_CF"	,SD2->D2_CF		,Nil})				
					aadd(aLinha,{"D2_VALICM",SD2->D2_VALICM	,Nil})
					aadd(aLinha,{"D2_VALCOF",SD2->D2_VALCOF	,Nil})
					aadd(aLinha,{"D2_VALPIS",SD2->D2_VALPIS	,Nil})
									
					DBSELECTAREA("SD2")
					SD2->(DBSKIP())
					
				ENDDO
			
			ENDIF
		
		ENDIF
						
		lMsErroAuto := .F.		
				
		MATA920(aCabec,aItens,5)
		
		IF lMsErroAuto
		
			l_ErrNF:= .T.
			MostraErro()
			DisarmTransaction()
			break
							
		ELSE
			
			l_ErrNF:= .F.
			
			//ALTERA A DATA O CANCELAMENTO PARA AS NOTAS CANCELADAS FICAREM COM A DATA DE CANCELAMENTO IGUAL AO DIA DA EMISSAO
			DbSelectArea("SF3")
		    dbSetOrder(5)
		    IF (dbSeek(xFilial("SF3")+QRY->ZQ_SERIE+QRY->ZQ_DOC+SPACE(TAMSX3("D2_DOC")[1]-LEN(QRY->ZQ_DOC))+c_Cliente+c_Loja))
	                                             					        
	   			RECLOCK("SF3",.F.)
	   			SF3->F3_DTCANC:= d_DtCanc    		 
	   			MSUNLOCK()
			  	
			ENDIF
			
			DBSELECTAREA("SFT")
			DBSETORDER(1)//FT_FILIAL, FT_TIPOMOV, FT_ENTRADA, FT_SERIE, FT_NFISCAL, FT_CLIEFOR, FT_LOJA
			IF (DBSEEK(xFilial("SFT")+"S"+QRY->ZQ_SERIE+QRY->ZQ_DOC+SPACE(TAMSX3("D2_DOC")[1]-LEN(QRY->ZQ_DOC))+c_Cliente+c_Loja))					
				
				WHILE !(SFT->(EOF())) .AND. (SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == xFilial("SF3")+"S"+QRY->ZQ_SERIE+QRY->ZQ_DOC+SPACE(TAMSX3("D2_DOC")[1]-LEN(QRY->ZQ_DOC))+c_Cliente+c_Loja)	
					
					RECLOCK("SFT",.F.)
		   			SFT->FT_DTCANC:= d_DtCanc    		 
		   			MSUNLOCK()
		   			
		   			SFT->(DBSKIP())
		   		
		   		ENDDO

			ENDIF

		ENDIF
		
	ENDIF

Return()

/*/{Protheus.doc} f_CriaPerg
Funcao responsavel pela criacao das perguntas no dicionario

@author francisco.ssa
@since 14/08/2015
@version 1.0

@param c_Perg, character, Grupo de Perguntas

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
Static Function f_CriaPerg(c_Perg)

Local a_PAR01	:= {}
Private	o_Perg	:=	clsComponentes():New()

c_Perg := PADR(c_Perg,10)

Aadd(a_PAR01, "Informe Tabela de Cálculo")

//		        (X1_GRUPO, X1_ORDEM, X1_PERGUNT              , X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO			, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_VAR01  , X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_VAR02, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_CNT02, X1_VAR03, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_CNT03, X1_VAR04, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_CNT04, X1_VAR05, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, X1_CNT05, X1_F3	, X1_PYME, X1_GRPSXG, X1_HELP, X1_PICTURE, X1_IDFIL )
o_Perg:mtdPutSX1(c_Perg  ,"01"     ,"Tabela de Cálculo  ?"	 ,""        ,""        ,"mv_ch1"   ,"C"     ,TAMSX3("ZF7_TAB")[1]	,0		   ,0		   ,"G"	   ,""	     ,"mv_par01" ,""       ,""        ,""          ,""       ,""       ,""       ,""         ,""         ,""       ,""       ,""       ,""         ,""         ,""       ,""       ,""       , ""        , ""        , ""      , ""      , ""      , ""        , ""        , ""      , "ZF7"	, ""     , ""       , ""     , ""        , ""       )

Return
