#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
���Programa  �FFATR002  �Autor  � CHRISTIAN ROCHA      � Data � DEZ/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o do Certificado de Qualidade Bomix 				  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT - Faturamento                                      ���
�����������������������������������������������������������������������������
*/

User Function FFATR002

Private c_Titulo := "CERTIFICADO DE QUALIDADE"
Private c_Qry	 := ''
Private c_Data   := dtoc(DDATABASE)
Private c_Hora   := Time()

CriaPerg("FFATR002")

If !(Pergunte("FFATR002",.T.))
	Return
EndIf

RptStatus({|| ImpRel()},c_titulo)

Return

/*
�����������������������������������������������������������������������������
���Programa  �IMPREL    �Autor  �CHRISTIAN ROCHA     � Data �   DEZ/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que imprime o relatorio                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function ImpRel()     
	//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
	Private oFont01n	:= TFont():New( "Times New Roman",,20,,.T.,,,,,.F.,.F.) 
	Private oFont02		:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.F.) 
	Private oFont02n	:= TFont():New( "Arial",,12,,.T.,,,,,.F.,.F.)
	Private oFont02s	:= TFont():New( "Arial",,12,,.F.,,,,,.T.,.F.)
	Private oFont03		:= TFont():New( "Arial",,14,,.F.,,,,,.F.,.F.)
	Private oFont03n	:= TFont():New( "Arial",,14,,.T.,,,,,.F.,.F.)
	Private oFont04		:= TFont():New( "Arial",,07,,.F.,,,,,.F.,.F.)
	Private c_BitMap 	:= "\system\lgrl01.bmp"
	Private n_Lin
	Private n_QuantP	:= 0
	Private n_Pag		:= 1
	Private L			:= 1
	Private n_TotPag	:= 1 //Tota de Paginas
	Private l_Rodape    := .F.

	f_Qry()    //Chama a fun��o para gerar a query
		
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If Eof()
		Alert("Nenhum registro encontrado.")
		QRY->(dbCloseArea())
		Return
	End If

	//����������������������������������������������������������������������������������������������Ŀ
	//�Para contar a quantidade de paginas, tive que imprimir os dados no relatorio, excluir o objeto�
	//�oPrn, recri�-lo e imprimir tudo novamente.                                                    �
	//������������������������������������������������������������������������������������������������
	For L := 1 TO 2
		oPrn := TMSPrinter():New("CERTIFICADO DE QUALIDADE")
		oPrn:SetPortrait()  

		ImpCabec() //Imprime o cabecalho	
	 	
	 	If L == 2
			oPrn:Setup()
	 	EndIf
	
		oPrn:StartPage()
		dbGoTop()

		While !Eof()
			c_NumPed := QRY->C5_NUM
			ImpCabec() //Imprime o cabecalho	

			While !Eof() .And. QRY->C5_NUM == c_NumPed
				c_Lote := IIF(!Empty(QRY->C6_LOTECTL), QRY->C6_LOTECTL, QRY->D2_LOTECTL)

				c_Produto := QRY->B1_DESC
				oPrn:Say(n_lin , 120, "PRODUTO"  	,oFont03n,100)
	//			oPrn:Say(n_lin ,1650, "OP"			,oFont03n,100)
				oPrn:Say(n_lin ,1850, "LOTE"		,oFont03n,100)			
				oPrn:Say(n_lin ,2120, "DATA"	,oFont03n,100)
		
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
		
				n_Lin += 25
				PulaPag(n_Lin)
				
				oPrn:Say(n_Lin ,100 , MemoLine(c_Produto, 60, 1) ,oFont02,100)
				oPrn:Say(n_lin , 1850, c_Lote  	,oFont02,100)
				oPrn:Say(n_lin , 2120, Dtoc(Stod(QRY->B8_DATA))  	,oFont02,100)

				If MLCount(AllTrim(c_Produto), 60) > 1
					For i := 2 To MLCount(c_Produto, 60)
						n_lin += 50
						PulaPag(n_Lin)
						oPrn:Say(n_Lin ,100 , MemoLine(c_Produto, 60, i) ,oFont02,100)
					Next
				Endif

				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
		
				n_Lin += 25
				PulaPag(n_Lin)
				oPrn:Say(n_lin , 120, "Item"  	,oFont02n,100)
				oPrn:Say(n_lin , 1170, "Especifica��o"  	,oFont02n,100)
				oPrn:Say(n_lin , 1490, "Varia��o (+/-)"  	,oFont02n,100)
				oPrn:Say(n_lin , 1810, "M�dia"  	,oFont02n,100)
				oPrn:Say(n_lin , 2000, "M�nimo"  	,oFont02n,100)
				oPrn:Say(n_lin , 2180, "M�ximo"  	,oFont02n,100)

				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
				
				If "BALDE" $ c_Produto .Or. "POTE" $ c_Produto
					If QRY->BM_FSALTB > 0
						n_Lin += 25
						PulaPag(n_Lin)
						oPrn:Say(n_lin , 120, "Altura do Balde"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSALTB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVALTB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSALTB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSALTB - QRY->BM_FSVALTB),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSALTB + QRY->BM_FSVALTB),oFont02,100)
			
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSDFUNB > 0
						n_Lin += 25
						PulaPag(n_Lin)
						oPrn:Say(n_lin , 120, "Di�metro do Fundo do Balde"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSDFUNB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVDFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSDFUNB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSDFUNB-QRY->BM_FSVDFB)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSDFUNB + QRY->BM_FSVDFB)	,oFont02,100)
								
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSDEBB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Di�metro Externo da Boca do Balde (A)"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSDEBB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVDEBB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSDEBB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSDEBB - QRY->BM_FSVDEBB)		,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSDEBB + QRY->BM_FSVDEBB) 	,oFont02,100)
						
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSDEMB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Di�metro Externo M�ximo"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSDEMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVDEMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSDEMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSDEMB - QRY->BM_FSVDEMB)		,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSDEMB + QRY->BM_FSVDEMB)  	,oFont02,100)
					
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSDIBB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Di�metro Interno da Boca do Balde (B)"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSDIBB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVDIBB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSDIBB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSDIBB - QRY->BM_FSVDIBB) 	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSDIBB + QRY->BM_FSVDIBB) 	,oFont02,100)
					
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSEPLB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Espessura da Parede Lateral do Balde"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSEPLB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVEPLB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSEPLB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSEPLB - QRY->BM_FSVEPLB),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSEPLB + QRY->BM_FSVEPLB) 	,oFont02,100)
											
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSCFB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Comprimento do Fundo"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSCFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVCFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSCFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSCFB - QRY->BM_FSVCFB)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSCFB + QRY->BM_FSVCFB) 	,oFont02,100)
										
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSCMB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Comprimtento Maior"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSCMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVCMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSCMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSCMB - QRY->BM_FSVCMB),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSCMB + QRY->BM_FSVCMB) 	,oFont02,100)

						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSLFB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Largura do Fundo"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSLFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVLFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSLFB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSLFB - QRY->BM_FSVLFB),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSLFB + QRY->BM_FSVLFB) 	,oFont02,100)
							
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSLMB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Largura Maior"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSLMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVLMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSLMB) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSLMB - QRY->BM_FSVLMB),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSLMB + QRY->BM_FSVLMB) 	,oFont02,100)

						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSPESOB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Peso do Balde sem Al�a"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSPESOB) + "g"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVPESB) + "g"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSPESOB) + "g"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSPESOB - QRY->BM_FSVPESB)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSPESOB + QRY->BM_FSVPESB) 	,oFont02,100)					
					
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
			   		Endif
			   		
					If QRY->BM_FSPALCA > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Peso da Al�a"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSPALCA) + "g"  	,oFont02,100)

						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
			   		Endif

					If QRY->BM_FSVNB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Volume Nominal"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSVNB) + "ml"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVVN) + "ml"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSVNB) + "ml"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSVNB - QRY->BM_FSVVN),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSVNB + QRY->BM_FSVVN),oFont02,100)					
					
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSVRB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Volume Real"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSVRB)  + "ml" 	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVVR)  + "ml"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSVRB)  + "ml" 	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSVRB - QRY->BM_FSVVR),oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSVRB + QRY->BM_FSVVR) 	,oFont02,100)
			
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
				
					If QRY->BM_FSVTB > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Volume Total"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSVTB)  + "ml" 	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVVT)  + "ml"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSVTB)  + "ml" 	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSVTB - QRY->BM_FSVVT)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSVTB + QRY->BM_FSVVT)  	,oFont02,100)

						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif

					n_Lin += 25
					PulaPag(n_Lin)			
					oPrn:Say(n_lin , 120, "Empilhamento NBR 14952"  	,oFont02,100)
					oPrn:Say(n_lin , 1200, QRY->BM_FSEMPIL  ,oFont02,100)
				Else
					If QRY->BM_FSDTAMP > 0
						n_Lin += 25
						PulaPag(n_Lin)
						oPrn:Say(n_lin , 120, "Di�metro da Tampa"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSDTAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVDTAM) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSDTAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSDTAMP - QRY->BM_FSVDTAM)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSDTAMP + QRY->BM_FSVDTAM) 	,oFont02,100)
						
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif	

					If QRY->BM_FSLTAMP > 0
						n_Lin += 25
						PulaPag(n_Lin)
						oPrn:Say(n_lin , 120, "Largura da Tampa"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSLTAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVLTAM) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSLTAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSLTAMP - QRY->BM_FSVLTAM)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSLTAMP + QRY->BM_FSVLTAM) 	,oFont02,100)
						
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif				

					If QRY->BM_FSCTAMP > 0
						n_Lin += 25
						PulaPag(n_Lin)
						oPrn:Say(n_lin , 120, "Comprimento da Tampa"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSCTAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVCTAM) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSCTAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSCTAMP - QRY->BM_FSVCTAM)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSCTAMP + QRY->BM_FSVCTAM) 	,oFont02,100)
						
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif	

					If QRY->BM_FSETAMP > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Espessura"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSETAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVETAM) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSETAMP) + "mm"  	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSETAMP - QRY->BM_FSVETAM) 	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSETAMP + QRY->BM_FSVETAM)  	,oFont02,100)
						
						n_Lin += 50
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
			
					If QRY->BM_FSPTAMP > 0
						n_Lin += 25
						PulaPag(n_Lin)			
						oPrn:Say(n_lin , 120, "Peso"  	,oFont02,100)
						oPrn:Say(n_lin , 1200, cvaltochar(QRY->BM_FSPTAMP) + "g" 	,oFont02,100)
						oPrn:Say(n_lin , 1530, cvaltochar(QRY->BM_FSVPTAM) + "g"  	,oFont02,100)
						oPrn:Say(n_lin , 1810, cvaltochar(QRY->BM_FSPTAMP) + "g" 	,oFont02,100)
						oPrn:Say(n_lin , 2000, cvaltochar(QRY->BM_FSPTAMP - QRY->BM_FSVPTAM)	,oFont02,100)
						oPrn:Say(n_lin , 2180, cvaltochar(QRY->BM_FSPTAMP + QRY->BM_FSVPTAM) 	,oFont02,100)					
	
						n_Lin += 50
			
						PulaPag(n_Lin)
						oPrn:Line( n_Lin,100,n_Lin,2350 )
					Endif
				Endif
	
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
		
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Colora��o/Inspe��o em Linha"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
				
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
		
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Manchas/Inspe��o em Linha"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
				
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
		
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Poeira/Inspe��o em Linha"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
	
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
				
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Rebarbas/Inspe��o em Linha"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
				
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
				
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Empilhamento/Ensaio Conf.Norma NBR14952 da ABNT"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
						
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
				
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Estanqueidade/Ensaio Conf.Norma NBR14952 da ABNT"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
	
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
				
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Resist�ncias/Ensaio Conf.Norma NBR14952 da ABNT"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
	
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
	
				// Brito - Inclus�o Data de Validade
				n_Lin += 25
				PulaPag(n_Lin)			
				oPrn:Say(n_lin , 120, "Prazo de Validade: 05 anos"  	,oFont02,100)
				oPrn:Say(n_lin , 1240, "OK"  	,oFont02,100)
				oPrn:Say(n_lin , 2000, ""  	,oFont02,100)
	
				n_Lin += 50
				PulaPag(n_Lin)
				oPrn:Line( n_Lin,100,n_Lin,2350 )
				
				// ************************

				n_Lin += 25
				PulaPag(n_Lin)			

				n_Lin += 100
				PulaPag(n_Lin)
				
				dbSkip()

				If !Eof() .And. QRY->C5_NUM <> c_NumPed
					PulaPag(3030)
				Endif
			End

			ImpRodap()
		End
		
		If L == 2
			oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)
		EndIf
		
		oPrn:EndPage()

		//��������������������������������������������������������������Ŀ
		//�Aqui eu reincio as variaveis e guardo a quantidade de paginas.�
		//����������������������������������������������������������������
		If L == 1                                                              
			n_TotPag	:= n_Pag
			n_Pag		:= 1
			oPrn:ResetPrinter()  //Exclui o objeto e reinicia suas propriedades.
			oPrn:End()
		Else
			oPrn:Preview()
		EndIf
	Next
	QRY->(dbCloseArea())

Return

/*
�����������������������������������������������������������������������������
���Programa  �IMPCABEC  �Autor  � CHRISTIAN ROCHA    � Data   � DEZ/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Cabecalho 				                                  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function ImpCabec()     

oPrn:SayBitmap( 100,100,c_BitMap,540,150)

oPrn:Say(200,800, "CERTIFICADO DE QUALIDADE"			,oFont01n,100)
oPrn:Say(100,1830, "P�gina",oFont02,100)
oPrn:Say(150,1830, "Data:   " + c_Data + "   " + c_Hora,oFont02,100) 

//oPrn:Say(275,1720, "Respons�vel: "	,oFont02,100)

oPrn:Line( 325,100,325,2350 )

oPrn:Say(350 ,100, "Nota Fiscal:"	,oFont02n,100)  
//oPrn:Say(350,1720, "N� Pedido:"			,oFont03n,100)  
oPrn:Say(400 ,100, "Cliente:"  			,oFont02n,100)
oPrn:Say(450 ,100, "Endere�o:"			,oFont02n,100)
oPrn:Say(500 ,100, "Bairro:"			,oFont02n,100)
oPrn:Say(500,1050, "Cidade:"	   		,oFont02n,100)
oPrn:Say(500,1720, "Estado:"			,oFont02n,100) 
oPrn:Say(500,2000, "CEP:"				,oFont02n,100) 
oPrn:Say(550 ,100, "Contato:"			,oFont02n,100)  
oPrn:Say(550,1050, "Telefone:"			,oFont02n,100) 

oPrn:Say(350 ,340, QRY->D2_DOC									,oFont02,100)
oPrn:Say(400 ,340, QRY->A1_NOME	,oFont02,100)
oPrn:Say(450 ,340, QRY->A1_END		,oFont02,100)
oPrn:Say(500 ,340, Upper(QRY->A1_BAIRRO)									,oFont02,100)
oPrn:Say(500 ,1210, QRY->A1_MUN									,oFont02,100)
oPrn:Say(500 ,1880, QRY->A1_EST										,oFont02,100)
oPrn:Say(500 ,2110, QRY->A1_CEP		,oFont02,100)
oPrn:Say(550 ,340, QRY->A1_CONTATO							,oFont02,100)
oPrn:Say(550 ,1240, QRY->A1_TEL	,oFont02,100)

oPrn:Line( 650,100,650,2350 )
oPrn:Line( 650,100,850,100 )


oPrn:Say(675 ,130 , "A Bomix Ind�stria de Embalagens Ltda certifica as propriedades dos Lotes de sua fabrica��o,"		,oFont02n,100)
oPrn:Say(725 ,130 , "de acordo com os valores abaixo. Estes valores refletem os resultados dos controles "	,oFont02n,100)
oPrn:Say(775 ,130 , "realizados sobre uma atmosfera representativa do(s) lote(s) em refer�ncia."				,oFont02n,100)
oPrn:Line( 650,2350,850,2350 )
oPrn:Line( 850,100,850,2350 )

oPrn:Say(865 ,100, "H 27.10 C - 7 (05) REV. 14"	,oFont02s,100)

n_Lin:= 925

Return

/*
�����������������������������������������������������������������������������
���Programa  �ImpRodap  �Autor  �CHRISTIAN ROCHA      � Data � Abril/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rodap�				                                      ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function ImpRodap()
	n_Lin := 3225
	oPrn:Say(n_Lin ,1000 , "Bomix Ind�stria de Embalagens Ltda",oFont03n,100, CLR_HBLUE)

	n_lin += 50
	oPrn:Say(n_Lin ,300, "Av. Aliomar Baleeiro N 1111, 0111 CEP: 41.230-455 - Salvador - BA - Tel: (71) 3215-8600 - Fax: (71) 3392-9841 - E-mail: comercialba@bomix.com.br"					,oFont04,100)

	n_lin += 40
	oPrn:Say(n_Lin ,200, "Filial S�o Paulo: Rua Helena Conci Gaspari, 110 - Jd Campos Elsios - CEP: 13.209-810 - Jundia� - SP - Tel: (11) 4523-0100 - Fax: (11) 4522-4399 - E-mail: bomixsp@bomix.com.br"					,oFont04,100)

	n_lin += 40
	oPrn:Say(n_Lin ,100, "Filial Norte/Nordeste: Av.Washington Soares, 855 - S. 605 - Centro Empresarial Washington Soares - Edson Queiroz - CEP: 60.811-341 - Fortaleza - CE - Tel: (85) 9998-5000 - E-mail: bomixne@bomix.com.br"	,oFont04,100)		
	
Return
 
/*
�����������������������������������������������������������������������������
���Programa  �PULAPAG   �Autor  �CHRISTIAN ROCHA       � Data � Abril/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por gerar nova pagina e imprimir as      ���
���          �informacoes restantes.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function PulaPag(Linha)

	If (Linha > 3025)
		//������������������������������������������������������Ŀ
		//�So deve imprimir o total de paginas quando for a 2 vez�
		//��������������������������������������������������������
		If L == 2
			oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)  
		EndIf
		
		ImpRodap()

		oPrn:EndPage()
		n_Pag++

		oPrn:StartPage()
		oPrn:SayBitmap( 100,100,c_BitMap,540,150)
					
		oPrn:Say(200,800, "CERTIFICADO DE QUALIDADE"			,oFont01n,100)
		
		oPrn:Say(100,1830, "P�gina",oFont02,100)
		oPrn:Say(150,1830, "Data:   " + c_Data + "   " + c_Hora,oFont02,100) 

		oPrn:Line( 325,100,325,2350 )	
		n_Lin:= 350

	EndIf

Return

/*
�����������������������������������������������������������������������������
���Programa  �IMPOBS    �Autor  �CHRISTIAN ROCHA     � Data � Abril/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel imprimir a observacao do orcamento confor���
���          �me a largura da pagina.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function CriaPerg(c_Perg)
a_MV_PAR01 := {}
a_MV_PAR02 := {}

//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Pedido de Venda de ?"   ,"","","mv_ch1","C",06,0,0,"G","","SC5","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"02","Pedido de Venda at� ?"  ,"","","mv_ch2","C",06,0,0,"G","","SC5","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"03","Cliente de ?"   		,"","","mv_ch3","C",06,0,0,"G","","SA1","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"04","Cliente at� ?"  		,"","","mv_ch4","C",06,0,0,"G","","SA1","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"05","Nota Fiscal ?"		   	,"","","mv_ch5","C",09,0,0,"G","","SF2","","","mv_par05","","","","","","","","","","","","","","","","")

Return()

Static Function f_Qry()

c_Qry := " SELECT * FROM " + RetSqlName("SC5") + " SC5 " + chr(13)
c_Qry += " JOIN " + RetSqlName("SC6") + " SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + XFILIAL("SA1") + "' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SBM") + " SBM ON BM_FILIAL = '" + XFILIAL("SBM") + "' AND BM_GRUPO = B1_GRUPO AND SBM.D_E_L_E_T_<>'*' " + chr(13)

If Empty(MV_PAR05)
	c_Qry += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_FILIAL = '" + XFILIAL("SD2") + "' AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM  AND SD2.D_E_L_E_T_<>'*'  " + chr(13)
Else	
	c_Qry += " JOIN " + RetSqlName("SD2") + " SD2 ON D2_FILIAL = '" + XFILIAL("SD2") + "' AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM  AND SD2.D_E_L_E_T_<>'*'  " + chr(13)
	c_Qry += " AND D2_DOC = '" + MV_PAR05 + "' " + chr(13)
Endif

c_Qry += " LEFT JOIN " + RetSqlName("SB8") + " SB8 ON B8_FILIAL = '" + XFILIAL("SB8") + "' AND B8_PRODUTO = D2_COD AND B8_LOTECTL = D2_LOTECTL  AND SB8.D_E_L_E_T_<>'*'  " + chr(13)
c_Qry += " WHERE C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND SC5.D_E_L_E_T_<>'*' AND C5_FILIAL = '" + XFILIAL("SC5") + "' " + chr(13)
c_Qry += " AND C5_CLIENTE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + chr(13)
c_Qry += " ORDER BY C5_NUM "

MemoWrit("C:\TEMP\FFATR002.SQL",c_Qry)

Return c_Qry