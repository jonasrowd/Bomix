#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "STDWIN.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |FESTM001  �Autor  � 				     � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �															  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���			 �					�										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FESTM001()

	Local oReport
	Private c_Perg := 'FESTM001'
	
	If SC2->C2_STATUS == 'U' .Or. SC2->C2_QUJE = SC2->C2_QUANT .Or. SC2->C2_TPOP == 'P'
		alert("Essa rotina n�o est� dispon�vel para ordens de produ��o previstas, suspensas ou encerradas.")
	Else
//		If f_ChkUsr()		//Chama a fun��o para verificar se o usu�rio possui acesso a rotina de etiquetas
	 
			f_VldPerg()

			If Pergunte(c_Perg,.T.)
				Processa({ || xPrintRel(),OemToAnsi('Gerando o relat�rio.')}, OemToAnsi('Aguarde...'))
			Endif
//		Endif
	Endif
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDPERG �Autor  �Microsiga           � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria perguntas no SX1                                      ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function f_VldPerg()
	
	Local a_PAR01   := {}

	Aadd(a_PAR01, "Informe a quantidade de etiquetas.")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Qtd Etiquetas ?      ","","","mv_ch0","N",06,0,0,"G","","","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)	
	
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xPrintRel �Autor  �Microsiga           � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o de Etiquetas de acordo com os par�metros         ���
���          � informado pelo usu�rio.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function xPrintRel()  

	Local nX 		:= 0
	Local nQtdPag 	:= 0
 	Local c_NumOp	:= SC2->C2_NUM + SC2->C2_ITEM
 	Local c_DescPro	:= ""
 	Local c_Lote    := ""
 	Local n_QtdPE	:= SC2->C2_FSQTDPE
    Local c_Seq		:= "01"

	Private oPrint
	Private cAlias 	    := getNextAlias() //cria um alias tempor�rio
	Private oFont6		:= TFont():New('Arial',,6,,.F.,,,,.F.,.F.)
	Private oFont6n		:= TFont():New('Arial',,6,,.T.,,,,.F.,.F.)
	Private oFont8		:= TFont():New('Arial',,8,,.F.,,,,.F.,.F.)
	Private oFont8n		:= TFont():New('Arial',,8,,.T.,,,,.F.,.F.)
	Private oFont10		:= TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
	Private oFont10n	:= TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
	Private nLin		:= 0 

/*    
    dbSelectArea("SZ3")
    dbSetOrder(1)
    dbSeek(SC2->C2_FILIAL+SC2->(C2_NUM + C2_ITEM + C2_SEQUEN))
    While (!EoF()) .AND. SZ3->Z3_FILIAL == SC2->C2_FILIAL .AND.SZ3->Z3_NUMOP == SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
    	//Se possui apontamento
		If SZ3->Z3_APONT .AND. Val(c_Seq) < Val(SZ3->Z3_SEQ)   					    				
		    c_Seq := SZ3->Z3_SEQ
	    EndIf
	    SZ3->(DbSkip())
    EndDo        
*/

 	If MsgBox("Deseja efetuar a impress�o das etiquetas?",SM0->M0_NOME,"YESNO")
		dbSelectArea("SB1")
		dbGoTop()
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)

		c_DescPro := SB1->B1_DESC

		If SB1->B1_RASTRO == 'L'				//Verifica se o produto possui rastreabilidade
			c_Qry := f_Qry()                    //Chama a fun��o para selecionar o lote de maior sequencial da OP

			TCQUERY c_Qry NEW ALIAS QRY
			dbSelectArea("QRY")
			dbGoTop()
			If QRY->(!Eof()) .And. !Empty(QRY->H6_LOTECTL)                    //Se existir o maior lote, altera o valor da vari�vel c_Seq
				c_Seq := StrZero(Val(SubStr(QRY->H6_LOTECTL,9,2)) + 1, 2, 0)
			Endif

			c_Lote := c_NumOp 	// + c_Seq	//O lote retornado ser� o n�mero da OP mais o sequencial

			dbCloseArea("QRY")
		Endif

		oPrint := TMSPrinter():New(OemToAnsi('Etiquetas de Ordens de Produ��o'))
		oPrint:SetPortrait()  

		nQtdPag := (mv_par01 / 2)

		For nX := 1 to nQtdPag
			oPrint:StartPage()  

 			oPrint:Box( 020,045,325,585 )           

			oPrint:Box( 020,605,325,1145 )	 			 

			nLin  := 0030

			For i:=1 To MLCount(c_DescPro, 30)
				oPrint:Say(nLin,0050,MemoLine(c_DescPro,30,i),oFont8n,,,,0)
				oPrint:Say(nLin,0610,MemoLine(c_DescPro,30,i),oFont8n,,,,0)
	
				nLin += 0030
			Next

 			nLin += 0050

 			oPrint:Say(nLin,0050,"Cont�m " + cValToChar(n_QtdPE) + " Und.",oFont8,,,,0)
 			oPrint:Say(nLin,0610,"Cont�m " + cValToChar(n_QtdPE) + " Und.",oFont8,,,,0)

 			oPrint:Say(nLin,0280,"Lote: " + c_Lote,oFont8,,,,0)
 			oPrint:Say(nLin,0840,"Lote: " + c_Lote,oFont8,,,,0)

 			nLin += 0040

 			oPrint:Say(nLin,0050,"Data: " + dtoc(dDataBase),oFont8,,,,0)
			oPrint:Say(nLin,0610,"Data: " + dtoc(dDataBase),oFont8,,,,0)
 			oPrint:Say(nLin,0280,"Hora: " + SubStr(Time(), 1, 5) + "   AP: " + c_Seq,oFont8,,,,0)
 			oPrint:Say(nLin,0840,"Hora: " + SubStr(Time(), 1, 5) + "   AP: " + c_Seq,oFont8,,,,0)

			nLin += 0050

			oPrint:Say(nLin,0050,"BOMIX Ind�stria de Embalagens Ltda.",oFont8,,,,0)
			oPrint:Say(nLin,0610,"BOMIX Ind�stria de Embalagens Ltda.",oFont8,,,,0) 			

			oPrint:EndPage()
		Next nX

//		oPrint:Preview()
 		oPrint:Print({1},nQtdPag)
		oPrint:end()
	EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |f_ChkUsr  �Autor  � 				     � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �	Fun��o para verificar se o usu�rio possui permiss�o de    ���
���          �	a rotina de etiquetas.									  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST/SIGAPCP                                            ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���			 �					�										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_ChkUsr
	Local c_CodGrps := ''						//C�digos dos grupos cadastrados no parametro FS_CODGRP
	Local a_CodGrps := {}						//Array com os c�digos dos grupos cadastrados no parametro FS_CODGRP
	Local a_GrpUsr  := UsrRetGrp(__CUSERID)     //Array contendo os c�digos dos grupos que o usu�rio pertence
	Local l_Ret     := .F.
	
	If GETMV("FS_CODGRP", .T., )
		c_CodGrps := AllTrim(GETMV("FS_CODGRP"))
	Else
		ShowHelpDlg(SM0->M0_NOME, {"O par�metro FS_CODGRP n�o est� cadastrado na SX6."},5,;
	  	{"Contacte o administrador do sistema e solicite a cria��o deste par�metro."},5)
	  	Return()
	Endif

	If Empty(c_CodGrps)
		l_Ret := .F.
	Else
		a_CodGrps := StrTokArr(c_CodGrps, ";")
	  	For i := 1 To Len(a_CodGrps)
	  		For k:= 1 To Len(a_GrpUsr)
		   		If a_CodGrps[i] == a_GrpUsr[k]
		    		l_Ret := .T.
		    		Exit
		   		Endif
			Next k
			
			If l_Ret
				Exit
			Endif
	  	Next i
	Endif

	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME, {"Voc� n�o possui permiss�o de acesso a esta rotina."},5,;
	  	{"Contacte o administrador do sistema e solicite acesso a esta rotina."},5)
	Endif
Return l_Ret

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_Qry     �Autor  �Microsiga           � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Query para selecionar o maior lote apontado da ordem de    ���
���          � produ��o atual.			                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function f_Qry
	c_Qry := " SELECT MAX(H6_LOTECTL) H6_LOTECTL FROM " + RETSQLNAME("SH6") + " WHERE H6_LOTECTL LIKE '" + SC2->C2_NUM + SC2->C2_ITEM + "%' AND " + CHR(13)
	c_Qry += " H6_FILIAL = '" + XFILIAL("SH6") + "' AND D_E_L_E_T_ <> '*' " + CHR(13)
Return c_Qry