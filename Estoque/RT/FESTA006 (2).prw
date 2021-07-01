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
���Programa  �FESTA006  �Autor  �                    � Data �Julho/2011   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa responsavel por importacao de arquivo texto.       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FESTA006()
	Local c_Texto  := "Esta rotina tem a finalidade de importar dados para tabela SB7 - Invent�rio, a partir do arquivo csv selecionado  pelo usu�rio."
	Local c_Erro   := "� necess�rio selecionar o arquivo csv para efetuar essa opera��o."

	Private c_File := Space(500)	//Arquivo
	Private c_Perg := "FESTA006"
	
	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oBtn3","oGrp1")

	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 090,230,198,670,SM0->M0_NOME,,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 006,004,{||"Arquivo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 004,025,{|u| if( Pcount( )>0, c_File := u, u := c_File) },oDlg1,151,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)

	oBtn1      := TButton():New( 004,180,"&Procurar...",oDlg1,{||c_File:=cGetFile( 'Arquivos Texto |*.csv|' , '', 1, '', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE),.T., .T. ) },037,12,,,,.T.,,"",,,,.F. )
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
���Programa  �f_ImportaDados�Autor  �                � Data � Julho/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao resposnavel pela leitura do arquivo texto e gravacao ���
���          �dos dados                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_Importa()
	Private n_Pos      := 1      //Numero da linha do arquivo
	Private n_QtdInc   := 0    //Conta quantas linhas foram importadas
	Private n_QtdUpd   := 0    //Conta quantas linhas foram atualizadas
	Private n_QtdErr   := 0    //Conta quantas linhas n�o foram importadas	
	Private c_Buffer   := ""   //Buffer do arquivo
	Private a_Buffer   := {}   //Array com o Buffer do arquivo
	Private c_Linha    := ""
	Private c_Filial   := xFilial("SB7") // Filial do Invent�rio
	Private c_Produto  := "" // Produto
	Private c_Desc     := "" // Descri��o do Produto
	Private c_Doc      := "" // Documento
	Private c_Local    := "" // Armaz�m
	Private c_Lote     := "" // Lote
	Private c_DtValid  := "" // Data de Validade do Lote
	Private c_Endereco := "" // Endere�o
	Private n_PrValid  := 0  // Prazo de Validade do Produto em dias
	Private c_Obs      := ""
	Private d_Data     := DDATABASE

	Private l_CriaTb := .F. //Controla a criacao da tabela temporaria
	Private c_Bord   := ""   //Borda da tabela tempor�ria
	Private a_Bord   := {}   //Array da tabela tempor�ria
	Private a_Campos := {}   //Campos da tabela tempor�ria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	IF AVISO(SM0->M0_NOMECOM,"Esta rotina ir� importar os dados do arquivo texto para a tabela SB7 - Invent�rio. Deseja realmente continuar?",{"Sim","N�o"},2,"Aten��o") == 1
		CriaPerg(c_Perg)

		If !(Pergunte(c_Perg, .T.))
			Return
		Else
			If Empty(MV_PAR01)
				ShowHelpDlg(SM0->M0_NOME, {"O Documento est� em branco."},5,;
	                           			  {"Informe o n�mero do Documento para efetuar a importa��o."},5)
				Return
			Endif
		EndIf

		c_Doc := MV_PAR01

		IF !l_CriaTb
			Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
			Aadd(a_Bord,{"TB_FILIAL"  ,"C",TamSX3("CT1_FILIAL")[1],0})
			Aadd(a_Bord,{"TB_PRODUTO" ,"C",TamSX3("B1_COD")[1],0})
			Aadd(a_Bord,{"TB_DESC"    ,"C",TamSX3("B1_DESC")[1],0})
			Aadd(a_Bord,{"TB_LOCAL"   ,"C",TamSX3("B2_LOCAL")[1],0})
			Aadd(a_Bord,{"TB_LOTECTL" ,"C",TamSX3("B8_LOTECTL")[1],0})
			Aadd(a_Bord,{"TB_DTVALID" ,"D",TamSX3("B8_DTVALID")[1],0})
			Aadd(a_Bord,{"TB_LOCALIZ" ,"C",TamSX3("BF_LOCALIZ")[1],0})
			Aadd(a_Bord,{"TB_QUANT"   ,"N",17,5})
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
		FT_FGoTop()
		WHILE !FT_FEOF()
			c_Buffer := FT_FREADLN()
			
			//+chr(13)+chr(10)
			
			c_Buffer := StrTran(c_Buffer, ";;", "; ;")+ chr(13)
			a_Invent := StrTokArr(c_Buffer, ";")

			c_Produto  := Padr(a_Invent[1], TamSX3("B1_COD")[1])
			c_Desc     := ""
			c_Local    := a_Invent[4]
			n_Quant    := Val(StrTran(a_Invent[6], ",", "."))
			c_Lote     := a_Invent[7] //IIF(Len(a_Invent) >= 7, a_Invent[7], "")
			c_DtValid  := IIF(Len(a_Invent) >= 8, LEFT(a_Invent[8],10), "")
			c_Endereco := "" //a_Invent[7] //IIF(Len(a_Invent) >= 7, Padr(a_Invent[7], TamSX3("B7_LOCALIZ")[1]), "")
			n_PrValid  := 0
			c_Obs      := ""

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1") + c_Produto)
				c_Desc    := SB1->B1_DESC
				n_PrValid := SB1->B1_PRVALID

				//dbSelectArea("NNR")
				dbSelectArea("SZ1")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ1") + c_Local)
					If f_Mata270()
						c_Obs += "Invent�rio importado pela rotina."
				    	n_QtdInc++
					Else
					    c_Obs := "Erro de inclus�o do Invent�rio."
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

			RECLOCK("TRC",.T.)
			TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
			TRC->TB_FILIAL  := c_Filial
			TRC->TB_PRODUTO	:= c_Produto
			TRC->TB_DESC    := c_Desc
			TRC->TB_LOCAL   := c_Local
			TRC->TB_LOTECTL := c_Lote
			TRC->TB_DTVALID := Ctod(c_DtValid)
			TRC->TB_LOCALIZ := c_Endereco
			TRC->TB_QUANT   := n_Quant
			TRC->TB_OBS     := c_Obs
			MSUNLOCK()			

			FT_FSKIP()
			n_Pos++
			IncProc()
		ENDDO

		FT_FUSE()
		AVISO(SM0->M0_NOME,"O programa processou todo o arquivo com " + ALLTRIM(STR(n_QtdInc+n_QtdUpd+n_QtdErr)) + " registros. Foram importados " + ALLTRIM(STR(n_QtdInc)) + " registros, " + ALLTRIM(STR(n_QtdUpd)) + " registros foram atualizados e " + ALLTRIM(STR(n_QtdErr)) + " registros n�o foram importados.",{"OK"},2,"Aviso")

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

	 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'      	,'@!'})
		Aadd(a_Campos,{"TB_FILIAL"  ,,'Filial'     	,'@!'})
		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  	,'@!'})
		Aadd(a_Campos,{"TB_DESC"    ,,'Descri��o'  	,'@!'})
		Aadd(a_Campos,{"TB_LOCAL"   ,,'Armazem'  	,'@!'})
		Aadd(a_Campos,{"TB_LOTECTL" ,,'Lote'   		,'@!'})
		Aadd(a_Campos,{"TB_DTVALID" ,,'Data de Validade'	,'@!'})
		Aadd(a_Campos,{"TB_LOCALIZ" ,,'Endere�o'  	,'@!'})
		Aadd(a_Campos,{"TB_QUANT"   ,,'Quantidade' 	,'@E 99,999,999,999.99999'})
		Aadd(a_Campos,{"TB_OBS"     ,,'Observa��o' 	,'@!'})

		o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de Importa��es/Atualiza��es",,,.F.,,,,,,.T.,,,.T. )
		o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdUpd+n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn:= TButton():New( 253,10,"Salvar" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
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
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function f_ExpLog()
	Local c_Destino := FCREATE("C:\TEMP\LOG_IMPORTA��O_INVENT�RIO_" + AllTrim(c_Doc) + ".CSV")
	Local c_Linha := ""

	// TESTA A CRIA��O DO ARQUIVO DE DESTINO
	IF c_Destino == -1
		MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
	 	RETURN
	ENDIF

	c_Linha:= "REGISTRO;FILIAL;PRODUTO;DESCRI��O;LOCAL;LOTE;DATA DE VALIDADE;ENDERE�O;QUANTIDADE;OBSERVA��O" + CHR(13)+CHR(10)

	IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
		IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
			FCLOSE(c_Destino)
			DBSELECTAREA("TRC")
			DBGOTOP()
   	   		Return
		ENDIF
 	ENDIF

	DBSELECTAREA("TRC")
	TRC->(DBGOTOP())
	
	Count To n_Reg
	ProcRegua(n_Reg)

	TRC->(DBGOTOP())
	WHILE !(TRC->(EOF()))
		c_Linha:= STRZERO(TRC->TB_POS,6)+";"+TRC->TB_FILIAL+";"+TRC->TB_PRODUTO+";"+TRC->TB_DESC+";"+TRC->TB_LOCAL+";"+TRC->TB_LOTECTL+";"+Dtoc(TRC->TB_DTVALID)+";"+TRC->TB_LOCALIZ+";"+Transform(TRC->TB_QUANT, "@E 999,999.99")+";"+TRC->TB_OBS + CHR(13)+CHR(10)

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

	AVISO(SM0->M0_NOMECOM,"Arquivo exportado para C:\TEMP\LOG_IMPORTA��O_INVENT�RIO_" + AllTrim(c_Doc) + ".CSV",{"Ok"},2,"Aten��o")
	FCLOSE(c_Destino)
	DBSELECTAREA("TRC")
	DBGOTOP()
Return



 
Static Function f_Mata270
Local aVetor        := {}
Local lRet          := .T.
Private lMsErroAuto := .F.

aVetor :=   {;
            {"B7_FILIAL", 	xFilial("SB7"),	Nil},;
            {"B7_COD",		c_Produto,		Nil},;
            {"B7_DOC",		c_Doc,	Nil},;
            {"B7_LOTECTL",	c_Lote,			Nil},;            
            {"B7_QUANT",	n_Quant,		Nil},;
            {"B7_LOCAL",	c_Local,		Nil},;
            {"B7_DATA",		d_Data,			Nil} }

If !Empty(c_Lote)
	If Empty(c_DtValid)
		c_DtValid := Dtoc(DaySum(DDATABASE, IIF(n_PrValid > 0, n_PrValid, 365)))
	Endif

	AADD(aVetor, {"B7_DTVALID",	Ctod(c_DtValid),		Nil})
Endif

If !Empty(c_Endereco)
	AADD(aVetor, {"B7_LOCALIZ",	Padr(c_Endereco, TamSX3("B7_LOCALIZ")[1]),		Nil})
Endif

MSExecAuto({|x,y,z| mata270(x,y,z)}, aVetor, .T., 3)

If lMsErroAuto
    MostraErro()
    lRet := .F.
EndIf

Return lRet



Static Function CriaPerg(c_Perg)
	a_MV_PAR01 := {}

	Aadd(a_MV_PAR01, "Informe o n�mero do documento")
	Aadd(a_MV_PAR01, "que ser� criado.")

	//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Documento ?"   ,"","","mv_ch1","C",09,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",a_MV_PAR01)
Return