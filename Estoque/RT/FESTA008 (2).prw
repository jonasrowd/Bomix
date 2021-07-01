#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FESTA008  �Autor  �                    � Data �Julho/2011   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa responsavel por importacao de arquivo texto.       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FESTA008()
	Local c_Texto  := "Esta rotina tem a finalidade de importar dados para realizar ajustes internos, a partir do arquivo csv selecionado  pelo usu�rio."
	Local c_Erro   := "� necess�rio selecionar o arquivo csv para efetuar essa opera��o."

	Private c_File := Space(500)	//Arquivo
	
	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oBtn3","oGrp1")

	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 090,230,198,670,SM0->M0_NOME,,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 006,004,{||"Arquivo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 004,025,{|u| if( Pcount( )>0, c_File := u, u := c_File) },oDlg1,151,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)

	oBtn1      := TButton():New( 004,180,"&Procurar...",oDlg1,{||c_File:=cGetFile( 'Arquivos CSV |*.csv|' , '', 1, '', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE),.T., .T. ) },037,12,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 021,180,"&Importar",oDlg1,{|| iif(Empty(c_File), ShowHelpDlg("Valida��o de Arquivo",{c_Erro},5,{"Selecione um arquivo csv v�lido."},5), f_MontaRegua())},037,12,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 038,180,"&Sair",oDlg1,{|| oDlg1:End()},037,12,,,,.T.,,"",,,,.F. )

	oGrp1      := TGroup():New( 018,004,050,176,"Descri��o",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 026,016,{||c_Texto},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,036)
	
	oDlg1:Activate(,,,.T.)
Return()

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � f_MontaRegua �Autor  �                     � Data �		  ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a montagem da r�gua de processamento				  ���
�������������������������������������������������������������������������͹��
*/

Static Function f_MontaRegua()
	Processa({|| f_Importa()}, "Aguarde...", "Analisando os dados do arquivo...",.F.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_Importa     �Autor  �                � Data � Julho/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao resposnavel pela leitura do arquivo texto e gravacao ���
���          �dos dados                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_Importa()
	Private n_Pos      := 1     //Numero da linha do arquivo
	Private n_QtdInc   := 0    	//Conta quantas linhas foram importadas
	Private n_QtdUpd   := 0    	//Conta quantas linhas foram atualizadas
	Private n_QtdErr   := 0    	//Conta quantas linhas n�o foram importadas	
	Private c_Buffer   := ""   	//Buffer do arquivo
	Private a_Buffer   := {}   	//Array com o Buffer do arquivo
	Private c_Linha    := ""
	Private c_Filial   := "" 	// Filial
	Private c_TM	   := "" 	// Tipo de Movimenta��o
	Private c_DescTM   := "" 	// Descri��o do Tipo de Movimenta��o
	Private c_Produto  := "" 	// Produto
	Private c_Desc     := "" 	// Descri��o do Produto
	Private c_Local    := "" 	// Armaz�m
	Private n_Quant    := 0 	// Quantidade
	Private n_Custo    := 0 	// Custo
	Private c_Obs      := ""
	Private d_Data     := DDATABASE

	Private l_CriaTb := .F. //Controla a criacao da tabela temporaria
	Private c_Bord   := ""   //Borda da tabela tempor�ria
	Private a_Bord   := {}   //Array da tabela tempor�ria
	Private a_Campos := {}   //Campos da tabela tempor�ria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	IF AVISO(SM0->M0_NOMECOM,"Esta rotina ir� importar os dados do arquivo csv para realizar ajustes internos. Deseja realmente continuar?",{"Sim","N�o"},2,"Aten��o") == 1
		IF !l_CriaTb
			Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
			Aadd(a_Bord,{"TB_FILIAL"  ,"C",TamSX3("CT1_FILIAL")[1],0})
			Aadd(a_Bord,{"TB_TM" 	  ,"C",TamSX3("D3_TM")[1],0})
			Aadd(a_Bord,{"TB_DESCTM"  ,"C",TamSX3("F5_TEXTO")[1],0})
			Aadd(a_Bord,{"TB_PRODUTO" ,"C",TamSX3("B1_COD")[1],0})
			Aadd(a_Bord,{"TB_DESC"    ,"C",TamSX3("B1_DESC")[1],0})
			Aadd(a_Bord,{"TB_LOCAL"   ,"C",TamSX3("B2_LOCAL")[1],0})
			Aadd(a_Bord,{"TB_QUANT"   ,"N",14,2})
			Aadd(a_Bord,{"TB_CUSTO"   ,"N",14,2})			
			Aadd(a_Bord,{"TB_CUSTO1"  ,"N",14,2})						
			Aadd(a_Bord,{"TB_OBS"     ,"C",100,0})

			c_Bord := CriaTrab(a_Bord,.t.)
			Use &c_Bord Shared Alias TRC New
			Index On TB_POS To &c_Bord

			SET INDEX TO &c_Bord

			l_CriaTb:= .T.	 
		ENDIF	

		IF FT_FUSE(ALLTRIM(c_File)) == -1
	  		ShowHelpDlg("Valida��o de Arquivo",;
	  		{"O arquivo "+ALLTRIM(c_File)+" n�o foi encontrado."},5,;
		  	{"Verifique se o caminho est� correto ou se o arquivo ainda se encontra no local indicado."},5)
			Return()
		Endif
	 
		ProcRegua(FT_FLastRec())

		WHILE !FT_FEOF()
			c_Buffer := FT_FREADLN()
			c_Buffer := IIF(SubStr(c_Buffer, 1, 1) == ";", " " + c_Buffer, c_Buffer)
			a_Item := StrTokArr(c_Buffer, ";",,.T.)

			/*
			Estrutura do Item da Planilha
			1  - Produto
			2  - Tipo	
			3  - Grupo	
			4  - Descri��o
			5  - Unidade de Medida	
			6  - Filial	
			7  - Armazem
			8  - Saldo em Estoque
			9  - Valor em Estoque
			10 - Custo Unit�rio
			11 - Ajuste de Quantidade
			12 - Ajuste do Custo Unit�rio
			13 - Quantidade Correta
			14 - Custo Unit�rio Correto
			15 - Valor de Custo
			*/
			
			c_Produto    := IIF(!Empty(a_Item[1]), Padr(a_Item[1], TamSX3("B1_COD")[1]), c_Produto)
			c_Filial     := "020101"
//			c_Filial     := a_Item[6]
//			c_Local      := Padr(a_Item[7], TamSX3("B1_LOCPAD")[1])
			c_Local      := Padr(a_Item[2], TamSX3("B1_LOCPAD")[1])
//			n_Saldo      := IIF((AllTrim(a_Item[8]) == "-" .Or. Empty(a_Item[8])), 0, Val(StrTran(a_Item[8], ",", "."))) 
//			n_CustoUnt   := IIF((AllTrim(a_Item[10]) == "-" .Or. Empty(a_Item[10])), 0, Val(StrTran(a_Item[10], ",", "."))) 
//			n_Quant      := IIF((AllTrim(a_Item[11]) == "-" .Or. Empty(a_Item[11])), 0, Val(StrTran(a_Item[11], ",", "."))) 
//			n_Custo      := IIF((AllTrim(a_Item[12]) == "-" .Or. Empty(a_Item[12])), 0, Val(StrTran(a_Item[12], ",", "."))) 
			a_Item[5]	 := StrTran(a_Item[5], ".", "")
			n_Custo      := IIF((AllTrim(a_Item[5]) == "-" .Or. Empty(a_Item[5])), 0, Val(StrTran(a_Item[5], ",", "."))) 
//			n_QuantOk    := IIF((AllTrim(a_Item[13]) == "-" .Or. Empty(a_Item[13])), 0, Val(StrTran(a_Item[13], ",", "."))) 
//			n_CustoOk    := IIF((AllTrim(a_Item[14]) == "-" .Or. Empty(a_Item[14])), 0, Val(StrTran(a_Item[14], ",", "."))) 
			a_Item[9]	 := StrTran(a_Item[9], ".", "")
			n_CustoOk    := IIF((AllTrim(a_Item[9]) == "-" .Or. Empty(a_Item[9])), 0, Val(StrTran(a_Item[9], ",", "."))) 
			n_CustoTotal := 0
			n_Ajuste     := 0
			c_Obs        := ""
			c_TM         := ""
			c_DescTM     := ""

			If c_Filial == cFilAnt
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1") + c_Produto)
					c_Desc := SB1->B1_DESC

					dbSelectArea("NNR")
					dbSetOrder(1)
					If dbSeek(xFilial("NNR") + c_Local)
						/*
						Tipos de Movimenta��o
						102 - Ajuste de Quantidade (+)
						502 - Ajuste de Quantidade (-)
						200 - Ajuste de Valor (+)
						700 - Ajuste de Valor (-)
						*/

						a_TM := {}

						dbSelectArea("SB2")
						dbSetOrder(1)
						If dbSeek(xFilial("SB2") + c_Produto + c_Local)
							RecLock("SB2", .F.)
							SB2->B2_CM1 := n_CustoOk
							MsUnlock()

							n_CustoTotal := n_CustoOk * SB2->B2_QATU
							n_Ajuste     := n_CustoTotal - SB2->B2_VATU1
							
							If n_Ajuste > 0
								aadd(a_TM, "200")
							Elseif n_Ajuste < 0
								n_Ajuste := n_Ajuste * (-1)
								aadd(a_TM, "700")
							Endif                            
/*
							If n_Quant <> 0 .And. n_Custo <> 0		//Ajuste de Quantidade e Custo
								If n_QuantOk > n_Saldo
									aadd(a_TM, "102")
								Else
									aadd(a_TM, "502")
								Endif
								
								If n_CustoOk > n_CustoUnt
									aadd(a_TM, "200")
								Else
									aadd(a_TM, "700")
								Endif
							Elseif n_Quant <> 0 .And. n_Custo == 0		//Ajuste de Quantidade
								If n_QuantOk > n_Saldo
									aadd(a_TM, "102")
								Else
									aadd(a_TM, "502")
								Endif
							Elseif n_Quant == 0 .And. n_Custo <> 0		//Ajuste de Custo
								If n_CustoOk > n_CustoUnt
									aadd(a_TM, "200")
								Else
									aadd(a_TM, "700")
								Endif
							Endif
*/							
							If Len(a_TM) > 0
								For i:=1 To Len(a_TM)
									dbSelectArea("SF5")
									dbSetOrder(1)
									If dbSeek(xFilial("SF5") + a_TM[i])
										c_TM     := SF5->F5_CODIGO
										c_DescTM := SF5->F5_TEXTO
	
										If f_Mata240()
											c_Obs += "Ajuste Interno efetuado pela rotina."
									    	n_QtdInc++
										Else
										    c_Obs := "Erro de inclus�o do Ajuste Interno."
									   		n_QtdErr++
										Endif
									Else
									    c_Obs := "C�digo do Tipo de Movimenta��o inv�lido."
								   		n_QtdErr++				
									Endif
								Next
							Else
							    c_Obs := "Ajuste Interno j� realizado pela rotina ou desnecess�rio."
						   		n_QtdErr++				
							Endif
						Else
						    c_Obs := "Saldo em Estoque n�o encontrado."
					   		n_QtdErr++			
						Endif
					Else
					    c_Obs := "C�digo do Armaz�m inv�lido."
				   		n_QtdErr++			
					Endif
				Else
				    c_Obs := "C�digo do Produto inv�lido."
			   		n_QtdErr++			
				Endif
			Else
			    c_Obs := "C�digo da Filial inv�lido."
		   		n_QtdErr++				
			Endif

			RECLOCK("TRC",.T.)
			TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
			TRC->TB_FILIAL  := c_Filial
			TRC->TB_TM      := c_TM
			TRC->TB_DESCTM  := c_DescTM
			TRC->TB_PRODUTO	:= c_Produto
			TRC->TB_DESC    := c_Desc
			TRC->TB_LOCAL   := c_Local
			TRC->TB_QUANT   := n_Quant
			TRC->TB_CUSTO   := n_Custo
			TRC->TB_CUSTO1  := n_CustoTotal
			TRC->TB_OBS     := c_Obs
			MSUNLOCK()			

			FT_FSKIP()
			n_Pos++
			IncProc()
		ENDDO

		FT_FUSE()
		AVISO(SM0->M0_NOME,"O programa processou todo o arquivo com " + ALLTRIM(STR(n_QtdInc+n_QtdUpd+n_QtdErr)) + " registros. Foram efetuados " + ALLTRIM(STR(n_QtdInc)) + " ajustes internos e " + ALLTRIM(STR(n_QtdErr)) + " ajustes internos n�o foram realizados.",{"OK"},2,"Aviso")

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

	 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'      	,'@!'})
		Aadd(a_Campos,{"TB_FILIAL"  ,,'Filial'     	,'@!'})
		Aadd(a_Campos,{"TB_TM" 		,,'Tipo Mov.'	,'@!'})
		Aadd(a_Campos,{"TB_DESCTM"  ,,'Descri��o'  	,'@!'})
		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  	,'@!'})
		Aadd(a_Campos,{"TB_DESC"    ,,'Descri��o'  	,'@!'})
		Aadd(a_Campos,{"TB_LOCAL"   ,,'Armazem'  	,'@!'})
		Aadd(a_Campos,{"TB_QUANT"   ,,'Quantidade' 	,'@E 99,999,999,999.99'})
		Aadd(a_Campos,{"TB_CUSTO"   ,,'Custo'	 	,'@E 99,999,999,999.99'})		
		Aadd(a_Campos,{"TB_CUSTO1"  ,,'Novo Custo' 	,'@E 99,999,999,999.99'})				
		Aadd(a_Campos,{"TB_OBS"     ,,'Observa��o' 	,'@!'})

		o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de Importa��es/Atualiza��es",,,.F.,,,,,,.T.,,,.T. )
		o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdUpd+n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn:= TButton():New( 253,10,"Exp p/ Texto" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
		o_Btn:= TButton():New( 253,60,"Sair"   ,o_Dlg,{|| o_Dlg:End() },041,012,,,,.T.,,"",,,,.F. )

		o_Dlg:Activate(,,,.T.)

		DBSELECTAREA("TRC")
		TRC->(DBCLOSEAREA())
	ENDIF
Return() 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � f_ExpLog � Autor �                  � Data �    Julho/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Exporta o log de importa��o para um arquivo texto          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function f_ExpLog()
	Local c_Destino := FCREATE("C:\TEMP\LOG_IMPORTA��O_AJUSTE_INTERNO.TXT")
	Local c_Linha := ""

	// TESTA A CRIA��O DO ARQUIVO DE DESTINO
	IF c_Destino == -1
		MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
	 	RETURN
	ENDIF

	DBSELECTAREA("TRC")
	TRC->(DBGOTOP())
	
	Count To n_Reg
	ProcRegua(n_Reg)

	TRC->(DBGOTOP())
	WHILE !(TRC->(EOF()))
		c_Linha:= STRZERO(TRC->TB_POS,6)+"   "+TRC->TB_FILIAL+"   "+TRC->TB_TM+"   "+TRC->TB_DESCTM+"   "+TRC->TB_PRODUTO+"   "+TRC->TB_DESC+"   "+TRC->TB_LOCAL+"   "+Transform(TRC->TB_QUANT, "@E 99,999,999,999.99")+"   "+Transform(TRC->TB_CUSTO, "@E 99,999,999,999.99")+"   "+Transform(TRC->TB_CUSTO1, "@E 99,999,999,999.99")+"   "+TRC->TB_OBS + CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
				DBSELECTAREA("TRC")
				DBGOTOP()
	   	   		Return
			ENDIF
	 	ENDIF
	 	
	 	IncProc()
	 	TRC->(DBSKIP())
	ENDDO 

	AVISO(SM0->M0_NOMECOM,"Arquivo exportado para C:\TEMP\LOG_IMPORTA��O_AJUSTE_INTERNO.TXT",{"Ok"},2,"Aten��o")
	FCLOSE(c_Destino)
	DBSELECTAREA("TRC")
	DBGOTOP()
Return

Static Function f_Mata240
	Local ExpA1  := {}
	Local ExpN2  := 3
	Local lRet   := .F.

	Private lMsErroAuto := .F.          

	Begin Transaction   	
		ExpA1 := {} 		
		aadd(ExpA1,{"D3_TM", c_TM, Nil})	
		aadd(ExpA1,{"D3_COD", c_Produto, Nil})	
		aadd(ExpA1,{"D3_LOCAL", c_Local, Nil})	
		aadd(ExpA1,{"D3_QUANT", n_Quant, Nil})	
		aadd(ExpA1,{"D3_CUSTO1", n_Ajuste, Nil})
		aadd(ExpA1,{"D3_EMISSAO", DDATABASE, Nil})		        
		
		MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)		
		
		If lMsErroAuto		
			MostraErro()
		Else
			lRet := .T.
		EndIf	
	End Transaction
Return lRet