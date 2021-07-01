#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"            

/*
�������������������������������������������������������������������������ͻ��
���Programa  � FGPER001 �Autor  �PABLO VB CARVALHO   � Data�   21/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de Benef�cios.					  				  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���26/01/2018�TBA007-PABLO VB   �N�o checa per�odo de experi�ncia para VA.���
�����������������������������������������������������������������������������
*/  

User Function FGPER025   
         	
	Private o_Section1
	Private o_Cell
	Private o_Break
	Private a_Ordem  	:= {"Filial e Matr�cula", "Filial e Nome", "Filial e C. Custo (C�digo)", "Filial e C. Custo (Descri��o)", "Filial e Departamento"}
	Private a_Tables	:= {"SRA", "SQB", "CTT"}
	Private c_Desc1		:= "Este programa tem como objetivo imprimir a rela��o "
	Private c_Desc2		:= "dos empregados com os valores de cada benef�cio."
	Private o_Report 	:= TReport():New("FGPER025", "Rela��o dos Benef�cios",, {|o_Report| f_Proc()}, c_Desc1 + c_Desc2)
	Private n_ordem		:= 1
	Private c_Perg 		:= padr("FGPER025", 10)	
	Private c_comp 		:= ""
	Private a_fer 		:= {} //feriados
	Private n_1q26		:= 0 //dias de cr�dito VT/VR, 1� quinzena, segunda a sexta - somente para funcion�rios em experi�ncia
	Private n_1q27		:= 0 //dias de cr�dito VT/VR, 1� quinzena, segunda a s�bado - somente para funcion�rios em experi�ncia
	Private n_2q26		:= 0 //dias de cr�dito VT/VR, 2� quinzena, segunda a sexta - somente para funcion�rios em experi�ncia
	Private n_2q27		:= 0 //dias de cr�dito VT/VR, 2� quinzena, segunda a s�bado - somente para funcion�rios em experi�ncia
	Private n_m26		:= 0 //dias de cr�dito VT/VR, mensal, segunda a sexta - somente para funcion�rios n�o mais em experi�ncia
	Private n_m27		:= 0 //dias de cr�dito VT/VR, mensal, segunda a s�bado - somente para funcion�rios n�o mais em experi�ncia
	Private a_ponto		:= {} //per�odos do ponto
	Private c_fil		:= ""
		
	f_Perg(c_perg)
	Pergunte(c_perg, .F.)	
	
	o_Report:SetLandscape()
	o_Report:SetParam("FGPER025")
	o_Report:lParamPage := .T.
	o_Report:lUserInfo := .T.
	o_Report:lUserFilter := .T.
	o_Report:lTotalInLine := .F.

	o_Section1 := TRSection():New(o_Report, "Secao1", a_Tables, a_Ordem)
	o_Section1:SetHeaderPage()	

	o_Cell := TRCell():New(o_Section1,"RA_FILIAL"	,"SRA",,,,.F.,{||})
	TRCell():New(o_Section1,"RA_CC"	 				,"SRA","C. Custo",,,.F.,{||})
	TRCell():New(o_Section1,"CTT_DESC01"			,"CTT","Descri��o",,,.F.,{||})
	TRCell():New(o_Section1,"RA_MAT"				,"SRA",,,,.F.,{||})
	TRCell():New(o_Section1,"RA_NOME"				,"SRA",,,,.F.,{||})
	TRCell():New(o_Section1,"QB_DESCRIC" 			,"SQB","Departamento",,,.F.,{||})
	TRCell():New(o_Section1,"QTDEC","","Qtde Cr�dito","@E 999",3,.F.,{||})
	TRCell():New(o_Section1,"QTDED","","Qtde D�bito","@E 999",3,.F.,{||})
	TRCell():New(o_Section1,"SALDO","","Saldo","@E 999",3,.F.,{||})
	TRCell():New(o_Section1,"VUNIT","","Valor Unit�rio","@E 999.99",6,.F.,{||})
	TRCell():New(o_Section1,"VTOTAL","","Valor Total","@E 999,999.99",9,.F.,{||})
	
	o_Break := TRBreak():New(o_Section1,{|| o_Section1:Cell("RA_FILIAL"):UPrint} ,, .F.)
	o_Break:OnBreak({|x,y| c_fil := "TOTAL DE FUNCION�RIOS DA FILIAL: " + x + " - " + FWFilName(FWCodEmp(), x)})
	o_Break:SetTotalText({|| c_fil})
	o_Break:lPageBreak := .T.
	o_Function := TRFunction():New(o_Section1:Cell("RA_FILIAL"),, "COUNT", o_Break ,,,,.F.,.F.)
	o_Function := TRFunction():New(o_Section1:Cell("VTOTAL"),, "SUM", o_Break ,,,,.F.,.F.)

	o_Report:PrintDialog()

Return

/*
�������������������������������������������������������������������������ͻ��
���Fun��o    �f_Perg    �Autor  �PABLO VB CARVALHO   � Data �  21/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Trata as perguntas da rotina.	          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Perg(cperg)

	Local aregs		:= {}
	Local i, j		:= 0
	
	//grupo/ordem/pergunta/perg.spa/perg.eng/variavel/tipo/tamanho/decimal/presel/gsc/valid/ var01/def01/def1.spa/def1.eng/cnt01/var02/def02/def1.spa/def1.eng/cnt02/var03/def03/def1.spa/def1.eng/cnt03/var04/def04/def1.spa/def1.eng/cnt04/var05/def05/def1.spa/def1.eng/cnt05/f3/pyme/grpsxg/help/picture/idfil
	aadd(aregs, {cperg, "01", "Filial De				", "�De sucursal ?              ","From Branch ?                 ", "mv_ch1", "C", FWGETTAMFILIAL, 			0, 0, "G", ""						, "mv_par01", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILDE.", "", ""})
	aadd(aregs, {cperg, "02", "Filial At�           	", "�A Sucursal ?         	    ","To Branch ?                   ", "mv_ch2", "C", FWGETTAMFILIAL, 			0, 0, "G", "naovazio()"				, "mv_par02", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILAT.", "", ""})
	aadd(aregs, {cperg, "03", "Centro de Custo De   	", "�De Centro de Costo ?       ","From Cost Center ?            ", "mv_ch3", "C", tamsx3("RA_CC")[1], 		0, 0, "G", ""						, "mv_par03", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCDE.", "", ""})
	aadd(aregs, {cperg, "04", "Centro de Custo At�		", "�A Centro de Costo ?        ","To Cost Center ?              ", "mv_ch4", "C", tamsx3("RA_CC")[1], 		0, 0, "G", "naovazio()"				, "mv_par04", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCAT.", "", ""})
	aadd(aregs, {cperg, "05", "Departamento De 			", "�De Depto. ?               	","Department From ?             ", "mv_ch5", "C", tamsx3("RA_DEPTO")[1],	0, 0, "G", ""						, "mv_par05", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"	, "S", "025", ".RHDPTDE.", "", ""})
	aadd(aregs, {cperg, "06", "Departamento At�			", "�A Depto. ?                	","Department To ?               ", "mv_ch6", "C", tamsx3("RA_DEPTO")[1], 	0, 0, "G", "naovazio()"				, "mv_par06", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"	, "S", "025", ".RHDPTAT.", "", ""})
	aadd(aregs, {cperg, "07", "Matricula De        		", "�De Matricula ?            	","From Registration ?           ", "mv_ch7", "C", tamsx3("RA_MAT")[1],		0, 0, "G", ""						, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATD.", "", ""})
	aadd(aregs, {cperg, "08", "Matricula At�       		", "�A Matricula ?             	","To Registration ?             ", "mv_ch8", "C", tamsx3("RA_MAT")[1],		0, 0, "G", "naovazio()"				, "mv_par08", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATA.", "", ""})
	aadd(aregs, {cperg, "09", "Data do Cr�dito			", "Data do Cr�dito		      	","Data do Cr�dito				 ", "mv_ch9", "D", 8, 						0, 0, "G", "naovazio()"				, "mv_par09", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "10", "Tipo"				     , "Tipo                        ","Tipo                          ", "mv_cha", "N", 1,                       0, 0, "C",""                        , "mv_par10","Vale Refei��o","Vale Refei��o","Vale Refei��o","","","Vale Aliment.","Vale Aliment.","Vale Aliment.","","","Vale Transporte","Vale Transporte","Vale Transporte","","","","","","","","","","","","","","","","",""})
	aadd(aregs, {cperg, "11", "Categorias	      		", "Categorias	             	","Categorias 			         ", "mv_chb", "C", 15,                 		0, 0, "G", "fCategoria()"			, "mv_par11", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHCATEG.", "", ""})
	aadd(aregs, {cperg, "12", "Situa��es	      		", "Situa��es	             	","Situa��es 			         ", "mv_chc", "C", 5,                 		0, 0, "G", "fSituacao"				, "mv_par12", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHSITUA.", "", ""})
	aadd(aregs, {cperg, "13", "Per�odo"				     , "Per�odo                     ","Per�odo                       ", "mv_chd", "N", 1,                       0, 0, "C",""                        , "mv_par13","Mensal","Mensal","Mensal","","","2� Quinzena","2� Quinzena","2� Quinzena","","","","","","","","","","","","","","","","","","","","","",""})
			
	dbselectarea("sx1")
	sx1->( dbsetorder(1))
	
	if !sx1->(dbseek(cperg))
		for i := 1 to len(aregs)
			if	!sx1->(dbseek(cperg + aregs[i, 2]))
				reclock("sx1", .t.)
				for j := 1 to fcount()
					fieldput(j, aregs[i, j])
				next
				msunlock("sx1")
			endif
		next
	endif

Return

/*
�������������������������������������������������������������������������ͻ��
���Fun��o    �f_Proc    �Autor  �PABLO VB CARVALHO   � Data �  18/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento.					          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Proc()
	
	Local l_exper	:= .F.
	Local l_ponto	:= .F.
	Local n_vlalim	:= 0
	Local n_vlref	:= 0
	Local l_jvapr	:= .F.	
	Local n_pisoal	:= 0
	Local a_result	:= {}
	Local n_totreg	:= 0
	
	if mv_par10 == 1 .or. mv_par10 == 3 //VR ou VT
		do case
			case mv_par13 == 1 //mensal
				c_comp := substr(dtos(lastdate(mv_par09) + 1), 5, 2) + substr(dtos(lastdate(mv_par09) + 1), 1, 4)
			case mv_par13 == 2 //2� quinzena
				c_comp := substr(dtos(mv_par09), 5, 2) + substr(dtos(mv_par09), 1, 4)
		endcase
		f_DiasCVTVR() //preenche as vari�veis de dias de cr�dito VT e VR
		f_Feriados("1", "1") //carrega o vetor de feriados para VT e VR - segunda a sexta, 1� quinzena
		f_Feriados("1", "2") //carrega o vetor de feriados para VT e VR - segunda a sexta, 2� quinzena
		f_Feriados("2", "1") //carrega o vetor de feriados para VT e VR - segunda a s�bado, 1� quinzena
		f_Feriados("2", "2") //carrega o vetor de feriados para VT e VR - segunda a s�bado, 2� quinzena
		f_Feriados("3", "1") //carrega o vetor de feriados para VT e VR - segunda a sexta, mensal
		f_Feriados("3", "2") //carrega o vetor de feriados para VT e VR - segunda a s�bado, mensal
	else
		if mv_par10 == 2 //VA
			c_comp 	:= substr(dtos(mv_par09), 5, 2) + substr(dtos(mv_par09), 1, 4)
			n_pisoal:= val(alltrim(posicione("RCA", 1, xfilial("RCA") + "M_00000003", "RCA_CONTEU")))
		endif
	endif
	
	f_Ponto()
	
	o_Section1 	:= o_Report:Section(1)
	o_Section1:Init()
	n_ordem		:= o_Section1:GetOrder()
		
	TCQUERY f_Qry() NEW ALIAS "QRY"		
	dbselectarea("QRY")	
	Count To n_totreg
	o_Report:SetMeter(n_totreg)
	QRY->(dbgotop())
	
	if mv_par10 == 1 .or. mv_par10 == 2 //sodexo VR ou VA
		while QRY->(!eof())
			o_Report:IncMeter()
			l_exper := iif(substr(dtos(stod(QRY->RA_ADMISSA) + 89), 1, 6) > substr(c_comp, 3, 4) + substr(c_comp, 1, 2), .T., .F.)
			l_jvapr	:= iif(QRY->RA_VIEMRAI == "55", .T., .F.)					
			if !l_jvapr .and.; //n�o � jovem aprendiz
				((mv_par13 == 1 .and. mv_par10 == 1) .or.; //mensal e VR
				(mv_par13 == 1 .and. mv_par10 == 2) .or.; //mensal e VA
				(mv_par13 == 2 .and. mv_par10 == 1 .and. l_exper)) //2� quinzena e VR e estiver em experi�ncia
				l_ponto := iif(QRY->RA_REGRA == "99" .or. empty(alltrim(QRY->RA_REGRA)), .F., .T.)
										
				o_Section1:Cell("RA_FILIAL"):SetValue(QRY->RA_FILIAL)
				o_Section1:Cell("RA_CC"):SetValue(alltrim(QRY->RA_CC))
				o_Section1:Cell("CTT_DESC01"):SetValue(alltrim(QRY->CTT_DESC01))				
				o_Section1:Cell("RA_MAT"):SetValue(QRY->RA_MAT)
				o_Section1:Cell("RA_NOME"):SetValue(alltrim(QRY->RA_NOME))				
				o_Section1:Cell("QB_DESCRIC"):SetValue(alltrim(QRY->QB_DESCRIC))
				
				do case
					case mv_par10 == 1 //VR
						n_vlref	:= QRY->N_REF
						a_result := f_Calc(QRY->RA_FILIAL, QRY->RA_MAT, l_exper, QRY->R6_X_BOESC, l_ponto, n_vlref, n_vlalim)
						o_Section1:Cell("QTDEC"):SetValue(a_result[1])
						o_Section1:Cell("QTDED"):SetValue(a_result[2])
						o_Section1:Cell("SALDO"):SetValue(a_result[1] - a_result[2])
						o_Section1:Cell("VUNIT"):SetValue(n_vlref)
						o_Section1:Cell("VTOTAL"):SetValue(a_result[3])
					case mv_par10 == 2 //VA
						n_vlalim := iif(QRY->N_ALIM == 0, n_pisoal, QRY->N_ALIM)
						a_result := f_Calc(QRY->RA_FILIAL, QRY->RA_MAT, l_exper, QRY->R6_X_BOESC, l_ponto, n_vlref, n_vlalim)
						o_Section1:Cell("QTDEC"):SetValue(a_result[1])
						o_Section1:Cell("QTDED"):SetValue(a_result[2])
						o_Section1:Cell("SALDO"):SetValue(a_result[1] - a_result[2])
						o_Section1:Cell("VUNIT"):Disable()						
						o_Section1:Cell("VTOTAL"):SetValue(a_result[3])
				endcase				
				
				o_Section1:PrintLine()
			endif
			QRY->(dbskip())
			a_result := {}
		enddo
	else
		if mv_par10 == 3 //salvador card VT
			while QRY->(!eof())
				o_Report:IncMeter()
				l_exper := iif(substr(dtos(stod(QRY->RA_ADMISSA) + 89), 1, 6) > substr(c_comp, 3, 4) + substr(c_comp, 1, 2), .T., .F.)					
				if mv_par13 == 1 .or.; //mensal e VT
					(mv_par13 == 2 .and. l_exper) //2� quinzena e VT e estiver em experi�ncia
					l_ponto := iif(QRY->RA_REGRA == "99" .or. empty(alltrim(QRY->RA_REGRA)), .F., .T.)
					
					o_Section1:Cell("RA_FILIAL"):SetValue(QRY->RA_FILIAL)
					o_Section1:Cell("RA_CC"):SetValue(alltrim(QRY->RA_CC))
					o_Section1:Cell("CTT_DESC01"):SetValue(alltrim(QRY->CTT_DESC01))				
					o_Section1:Cell("RA_MAT"):SetValue(QRY->RA_MAT)
					o_Section1:Cell("RA_NOME"):SetValue(alltrim(QRY->RA_NOME))				
					o_Section1:Cell("QB_DESCRIC"):SetValue(alltrim(QRY->QB_DESCRIC))
					a_result := f_Calc(QRY->RA_FILIAL, QRY->RA_MAT, l_exper, QRY->R6_X_BOESC, l_ponto)
					o_Section1:Cell("QTDEC"):SetValue(a_result[1])
					o_Section1:Cell("QTDED"):SetValue(a_result[2])
					o_Section1:Cell("SALDO"):SetValue(a_result[1] - a_result[2])
					o_Section1:Cell("VUNIT"):Disable()
					o_Section1:Cell("VTOTAL"):Disable()					
					o_Section1:PrintLine()					
				endif
				QRY->(dbskip())
				a_result := {}
			enddo
		endif
	endif
	
	o_Section1:Finish()
	dbselectarea("QRY")
	dbclosearea()
	
Return

/*
�������������������������������������������������������������������������ͻ��
���Fun��o    �f_DiasCVTVR �Autor  �PABLO VB CARVALHO � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega vari�veis de dias de cr�dito VT e VR.			  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_DiasCVTVR()

	Local d_ini		:= ctod("01/" + substr(c_comp, 1, 2) + "/" + substr(c_comp, 3, 4)) 
	Local d_aux1	:= ctod("  /  /    ")
	Local d_aux2	:= ctod("  /  /    ")
		
	//dias de cr�dito VT/VR, 1� quinzena, segunda a sexta - somente para funcion�rios em experi�ncia
	d_aux1 := d_ini
	d_aux2 := d_ini + 14
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 6
			n_1q26 ++
		endif
		d_aux1 ++
	enddo
	
	//dias de cr�dito VT/VR, 1� quinzena, segunda a s�bado - somente para funcion�rios em experi�ncia
	d_aux1 := d_ini
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 7
			n_1q27 ++
		endif
		d_aux1 ++
	enddo
	
	//dias de cr�dito VT/VR, 2� quinzena, segunda a sexta - somente para funcion�rios em experi�ncia
	d_aux1 := d_ini + 15
	d_aux2 := lastdate(d_aux1)
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 6
			n_2q26 ++
		endif
		d_aux1 ++
	enddo

	//dias de cr�dito VT/VR, 2� quinzena, segunda a s�bado - somente para funcion�rios em experi�ncia
	d_aux1 := d_ini + 15
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 7
			n_2q27 ++
		endif
		d_aux1 ++
	enddo
	
	//dias de cr�dito VT/VR, mensal, segunda a sexta - somente para funcion�rios n�o mais em experi�ncia
	n_m26 := n_1q26 + n_2q26
	
	//dias de cr�dito VT/VR, mensal, segunda a s�bado - somente para funcion�rios n�o mais em experi�ncia
	n_m27 := n_1q27 + n_2q27

Return

/*
�����������������������������������������������������������������������������
���Fun��o    �f_Feriados�Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega o vetor de feriados.		          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Feriados(c_dias, c_per)

	Local c_qry 	:= ""
	Local c_dsemfim	:= ""
	Local c_dtini	:= ""
	Local c_dtfim	:= ""
	Local c_mes		:= substr(c_comp, 1, 2)
	Local c_ano		:= substr(c_comp, 3, 4)
	Local n_cont	:= 1
	Local c_fil		:= ""
	Local n_aux		:= 0
	
	if c_dias $ "1/2"
		do case
			case c_dias == "1" //segunda a sexta
				c_dsemfim := "6"
			case c_dias == "2" //segunda a s�bado
				c_dsemfim := "7"
		endcase
				
		do case
			case c_per == "1" //1� quinzena
				c_dtini := dtos(ctod("01/" + substr(c_comp, 1, 2) + "/" + substr(c_comp, 3, 4)))
				c_dtfim := dtos(stod(c_dtini) + 14)
			case c_per == "2" //2� quinzena
				c_dtini := dtos(ctod("16/" + substr(c_comp, 1, 2) + "/" + substr(c_comp, 3, 4)))
				c_dtfim := dtos(lastdate(stod(c_dtini)))
		endcase
		
		c_qry := "SELECT AUX.P3_FILIAL, SUM(AUX.N_TOTAL) AS N_TOTAL FROM (" + CRLF
		c_qry += "		SELECT P3_FILIAL, COUNT(*) AS N_TOTAL" + CRLF
		c_qry += "		FROM " + retsqlname("SP3") + CRLF
		c_qry += "		WHERE P3_DATA 				>= '" + c_dtini + "'" + CRLF
		c_qry += "		AND P3_DATA 				<= '" + c_dtfim + "'" + CRLF
		c_qry += "		AND P3_FIXO 				= 'N'" + CRLF
		c_qry += "		AND DATEPART(DW, P3_DATA) 	>= 2" + CRLF
		c_qry += "		AND DATEPART(DW, P3_DATA) 	<= " + c_dsemfim + CRLF
		c_qry += "		AND D_E_L_E_T_ <> '*'" + CRLF
		c_qry += "		GROUP BY P3_FILIAL" + CRLF
		
		c_qry += "		UNION ALL" + CRLF
		
		c_qry += "		SELECT P3_FILIAL, COUNT(*) AS N_TOTAL" + CRLF
		c_qry += "		FROM " + retsqlname("SP3") + CRLF
		c_qry += "		WHERE P3_FIXO 					= 'S'" + CRLF
		c_qry += "		AND SUBSTRING(P3_MESDIA, 1, 2)	= '" + c_mes + "'" + CRLF
		do case
			case c_per == "1"
				c_qry += " AND SUBSTRING(P3_MESDIA, 3, 2) 	<= '15'" + CRLF
			case c_per == "2"
				c_qry += " AND SUBSTRING(P3_MESDIA, 3, 2) 	>= '16'" + CRLF
		endcase
		c_qry += "		AND DATEPART(DW, '" + c_ano + "' + SUBSTRING(P3_DATA, 5, 4)) 	>= 2" + CRLF
		c_qry += "		AND DATEPART(DW, '" + c_ano + "' + SUBSTRING(P3_DATA, 5, 4)) 	<= " + c_dsemfim + CRLF
		c_qry += "		AND D_E_L_E_T_ <> '*'" + CRLF
		c_qry += "		GROUP BY P3_FILIAL) AUX" + CRLF
		
		c_qry += " GROUP BY AUX.P3_FILIAL" + CRLF
		c_qry += " ORDER BY AUX.P3_FILIAL" + CRLF
		
		TCQUERY c_qry NEW ALIAS "QRY"
				
		dbselectarea("QRY")
		while QRY->(!eof())
			aadd(a_fer, {QRY->P3_FILIAL, c_dias + c_per, QRY->N_TOTAL})
			QRY->(dbskip())
		enddo
		dbclosearea()
	else
		if len(a_fer) > 0
			asort(a_fer, , , { | x,y | x[1] + x[2] < y[1] + y[2]} )
			while n_cont <= len(a_fer)
				c_fil := a_fer[n_cont, 1]
				while n_cont <= len(a_fer) .and. c_fil == a_fer[n_cont, 1] 
					if substr(a_fer[n_cont, 2], 1, 1) == c_per
						n_aux += a_fer[n_cont, 3]
					endif
					n_cont ++
				enddo
				if n_aux > 0
					aadd(a_fer, {c_fil, "3" + c_per, n_aux})
				endif
				n_aux := 0
			enddo
			asort(a_fer, , , { | x,y | x[1] + x[2] < y[1] + y[2]} )
		endif
	endif

Return

/*
�����������������������������������������������������������������������������
���Fun��o    �f_Calc    �Autor  �PABLO VB CARVALHO   � Data �  18/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � C�lculo dos valores.				          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Calc(c_fil, c_mat, l_experi, c_escala, l_pt, n_ref, n_alim)

	Local a_ret	:= {0, 0, 0}
	
	do case
		case mv_par10 == 1 //VR
			a_ret[1]	:= f_DiasCVR(c_fil, l_experi, c_escala)
			a_ret[2]	:= f_DiasDeb(c_fil, c_mat, l_pt, c_escala, "VR")
			a_ret[3] 	:= (a_ret[1] - a_ret[2]) * n_ref
		case mv_par10 == 2 //VA
			a_ret[1] 	:= 30
			a_ret[2]	:= f_DiasDeb(c_fil, c_mat, l_pt, c_escala, "VA")
			a_ret[3] 	:= (n_alim/30) * (a_ret[1] - a_ret[2])
		case mv_par10 == 3 //VT
			n_diasc		:= f_DiasCVT(c_fil, l_experi, c_escala)
			n_diasd		:= f_DiasDeb(c_fil, c_mat, l_pt, c_escala, "VT") 
			a_ret[1] 	:= n_diasc
			a_ret[2] 	:= n_diasd
	endcase
		
Return(a_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_DiasCVR �Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Dias de cr�dito VR do funcion�rio.          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_DiasCVR(c_fil, l_experi, c_escala)

	Local n_ret := 0
	
	if l_experi //funcion�rio em experi�ncia
		do case
			case mv_par13 == 1 //1� quinzena
				do case
					case c_escala $ "1/3" //segunda a sexta e segunda a s�bado 1/2 turno
						n_ret := n_1q26 - f_BuscaFer(c_fil, "11")
					case c_escala == "2" //segunda a s�bado integral
						n_ret := n_1q27 - f_BuscaFer(c_fil, "21")
				endcase
			case mv_par13 == 2 //2� quinzena
				do case
					case c_escala $ "1/3" //segunda a sexta e segunda a s�bado 1/2 turno
						n_ret := n_2q26 - f_BuscaFer(c_fil, "12")
					case c_escala == "2" //segunda a s�bado integral
						n_ret := n_2q27 - f_BuscaFer(c_fil, "22")
				endcase
		endcase
	else //funcion�rio n�o mais em experi�ncia
		if mv_par13 == 1 //mensal
			do case
				case c_escala $ "1/3" //segunda a sexta e segunda a s�bado 1/2 turno
					n_ret := n_m26 - f_BuscaFer(c_fil, "31")
				case c_escala == "2" //segunda a s�bado integral
					n_ret := n_m27 - f_BuscaFer(c_fil, "32")
			endcase
		endif
	endif

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_BuscaFer�Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca no vetor de feriados.		          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_BuscaFer(c_fil, c_tipo)

	Local n_ret := 0
	Local n_pos := 0

	if len(a_fer) > 0
		n_pos := ascan(a_fer, { |x| x[1] == c_fil .and. x[2] == c_tipo})	
		if n_pos > 0
			n_ret := a_fer[n_pos, 3]
		endif
	endif

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_DiasCVT �Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Dias de cr�dito VT do funcion�rio.          				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_DiasCVT(c_fil, l_experi, c_escala)

	Local n_ret := 0
	
	if l_experi //funcion�rio em experi�ncia
		do case
			case mv_par13 == 1 //1� quinzena
				do case
					case c_escala == "1" //segunda a sexta
						n_ret := n_1q26 - f_BuscaFer(c_fil, "11")
					case c_escala $ "2/3" //segunda a s�bado integral e segunda a s�bado 1/2 turno
						n_ret := n_1q27 - f_BuscaFer(c_fil, "21")
				endcase
			case mv_par13 == 2 //2� quinzena
				do case
					case c_escala == "1" //segunda a sexta
						n_ret := n_2q26 - f_BuscaFer(c_fil, "12")
					case c_escala $ "2/3" //segunda a s�bado integral e segunda a s�bado 1/2 turno
						n_ret := n_2q27 - f_BuscaFer(c_fil, "22")
				endcase
		endcase
	else //funcion�rio n�o mais em experi�ncia
		if mv_par13 == 1 //mensal
			do case
				case c_escala == "1" //segunda a sexta
					n_ret := n_m26 - f_BuscaFer(c_fil, "31")
				case c_escala $ "2/3" //segunda a s�bado integral e segunda a s�bado 1/2 turno
					n_ret := n_m27 - f_BuscaFer(c_fil, "32")
			endcase
		endif
	endif

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_DiasDeb �Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Dias de d�bito.                            				  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_DiasDeb(c_fil, c_mat, l_pt, c_escala, c_tipo)

	Local n_ret 	:= 0
	Local n_faltas	:= 0
	Local n_afafer	:= 0

	if mv_par13 == 1
		n_afafer := f_BuscaAfaFer(c_fil, c_mat, c_tipo, c_escala, l_pt)
		if l_pt
			n_faltas := f_BuscaPon(c_fil, c_mat, c_tipo)
		else
			n_faltas := f_BuscaFol(c_fil, c_mat)
		endif
		n_ret := n_faltas + n_afafer
	endif

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_Ponto   �Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega os per�odos do ponto de todas as filiais.		  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Ponto()

	Local a_fil 	:= FWAllFilial(, , FWGrpCompany(), .F.)
	Local n_cont	:= 0
	Local c_dini	:= ""
	Local c_dfim	:= ""
	Local c_mini	:= ""
	Local c_mfim	:= ""
	Local c_aini	:= ""
	Local c_afim	:= ""
	Local l_fech	:= .F.
	Local c_ini		:= ""
	Local c_fim		:= ""	
	
	for n_cont := 1 to len(a_fil)
		if a_fil[n_cont] >= mv_par01 .and. a_fil[n_cont] <= mv_par02 
			c_dini := substr(supergetmv("MV_PONMES", , , a_fil[n_cont]), 7, 2)
			c_dfim := substr(supergetmv("MV_PONMES", , , a_fil[n_cont]), 16, 2)
			if !empty(alltrim(c_dini)) .and. !empty(alltrim(c_dfim))
				n_aux := val(substr(c_comp, 1, 2)) - 2
				if n_aux <= 0
					c_mini := strzero(12 + n_aux, 2)
					c_aini := alltrim(cvaltochar(val(substr(c_comp, 3, 4)) - 1))				
				else
					c_mini := strzero(n_aux, 2)
					c_aini := substr(c_comp, 3, 4)
				endif
				n_aux := val(substr(c_comp, 1, 2)) - 1
				if n_aux <= 0
					c_mfim := strzero(12 + n_aux, 2)
					c_afim := alltrim(cvaltochar(val(substr(c_comp, 3, 4)) - 1))
				else
					c_mfim := strzero(n_aux, 2)
					c_afim := substr(c_comp, 3, 4)				
				endif
				c_ini := c_aini + c_mini + c_dini
				c_fim := c_afim + c_mfim + c_dfim
				l_fech := f_PonFech(a_fil[n_cont], c_ini, c_fim)					
				aadd(a_ponto, {a_fil[n_cont], c_ini, c_fim, l_fech})
			endif
		endif
	next

Return

/*
�����������������������������������������������������������������������������
���Fun��o    �f_BuscaPon�Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca informa��es de d�bito no apontamento do ponto.		  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_BuscaPon(c_fil, c_mat, c_tipo)

	Local n_ret 	:= 0
	Local c_qry 	:= ""
	Local l_fech	:= .F.
	Local n_pos		:= 0
	Local c_alias	:= ""
	Local c_pref	:= ""
	Local c_relfil	:= ""
		
	if len(a_ponto) > 0
		n_pos := ascan(a_ponto, { |x| x[1] == c_fil})
		if n_pos > 0
			l_fech := a_ponto[n_pos, 4]
			if l_fech
				c_alias := "SPH"
				c_pref := "PH"
			else
				c_alias := "SPC"
				c_pref := "PC"
			endif
			c_relfil := StrTran(FWJoinFilial(c_alias, "SP6"), c_alias, "APONT")
			c_qry := "SELECT COUNT(*) AS N_TOTAL" + CRLF
			c_qry += " FROM " + retsqlname(c_alias) + " APONT" + CRLF
			c_qry += " LEFT JOIN " + retsqlname("SP6") + " SP6 ON " + c_relfil + " AND APONT." + c_pref + "_ABONO = SP6.P6_CODIGO AND SP6.D_E_L_E_T_ <> '*'" + CRLF
			c_qry += " WHERE APONT.D_E_L_E_T_ <> '*'" + CRLF
			c_qry += " AND APONT." + c_pref + "_DATA 	>= '" + a_ponto[n_pos, 2] + "'" + CRLF
			c_qry += " AND APONT." + c_pref + "_DATA 	<= '" + a_ponto[n_pos, 3] + "'" + CRLF
			c_qry += " AND APONT." + c_pref + "_FILIAL 	= '" + c_fil + "'" + CRLF
			c_qry += " AND APONT." + c_pref + "_MAT 	= '" + c_mat + "'" + CRLF
			c_qry += " AND ((APONT." + c_pref + "_PD 	= '010' AND APONT." + c_pref + "_ABONO = '   ')" + CRLF
			c_qry += " OR (APONT." + c_pref + "_PD 		IN ('008', '010') AND APONT." + c_pref + "_ABONO <> '   ' AND SP6.P6_X_BO" + c_tipo + " = 'S'))" + CRLF
			
			TCQUERY c_qry NEW ALIAS "QRY2"
			
			dbselectarea("QRY2")
			if QRY2->(!eof())
				n_ret := QRY2->N_TOTAL
			endif
			dbclosearea()
		endif
	endif

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_PonFech �Autor  �PABLO VB CARVALHO   � Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o per�odo est� fechado.						  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_PonFech(c_fil, c_ini, c_fim)

	Local l_ret := .F.
	Local c_qry := ""
	
	c_qry := "SELECT COUNT(*) AS N_TOTAL" + CRLF
	c_qry += " FROM " + retsqlname("SPO") + CRLF
	c_qry += " WHERE D_E_L_E_T_ <> '*'" + CRLF
	c_qry += " AND PO_DATAINI = '" + c_ini + "'" + CRLF
	c_qry += " AND PO_DATAFIM = '" + c_fim + "'" + CRLF
	c_qry += " AND PO_FILIAL = '" + substr(c_fil, 1, 4) + "'" + CRLF
	
	TCQUERY c_qry NEW ALIAS "QRY"
				
	dbselectarea("QRY")
	if QRY->(!eof())
		if QRY->N_TOTAL > 0
			l_ret := .T.
		endif
	endif
	dbclosearea()

Return(l_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_BuscaAfaFer�Autor  �PABLO VB CARVALHO� Data �  22/03/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca informa��es de d�bito nos afastamentos e f�rias.	  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_BuscaAfaFer(c_fil, c_mat, c_tipo, c_escala, l_pt)

	Local n_ret 	:= 0
	Local c_qry 	:= ""
	Local n_pos		:= 0
	Local d_ini		:= ctod("  /  /    ")
	Local d_fim		:= ctod("  /  /    ")
	Local c_inif	:= ""
	Local c_fimf	:= ""
	Local c_inia	:= ""
	Local c_fima	:= ""
	Local n_aux		:= 0
	Local c_mini	:= ""
	Local c_aini	:= ""
	Local n_dfim	:= 0
		
	n_aux := val(substr(c_comp, 1, 2)) - 2
	if n_aux <= 0
		c_mini := strzero(12 + n_aux, 2)
		c_aini := alltrim(cvaltochar(val(substr(c_comp, 3, 4)) - 1))				
	else
		c_mini := strzero(n_aux, 2)
		c_aini := substr(c_comp, 3, 4)
	endif
	c_inif := c_aini + c_mini + "01"
	c_fimf := dtos(lastdate(stod(c_inif)))

	if l_pt
		if len(a_ponto) > 0
			n_pos := ascan(a_ponto, { |x| x[1] == c_fil})
			if n_pos > 0
				c_inia := a_ponto[n_pos, 2]
				c_fima := a_ponto[n_pos, 3]
			endif
		endif	
	else
		c_inia := c_inif
		c_fima := c_fimf
	endif
			
	c_qry := "SELECT R8_DATAINI, R8_DATAFIM, R8_TIPO" + CRLF
	c_qry += " FROM " + retsqlname("SR8") + CRLF
	c_qry += " WHERE D_E_L_E_T_ <> '*'" + CRLF
	c_qry += " AND R8_TIPO 		<> 'F'" + CRLF
	c_qry += " AND R8_DATAFIM	<> '        '" + CRLF
	c_qry += " AND (((R8_DATAINI BETWEEN '" + c_inia + "' AND '" + c_fima + "')" + CRLF
	c_qry += " OR (R8_DATAFIM BETWEEN '" + c_inia + "' AND '" + c_fima + "'))" + CRLF
	c_qry += " OR (('" + c_inia + "' BETWEEN R8_DATAINI AND R8_DATAFIM)" + CRLF
	c_qry += " OR ('" + c_fima + "' BETWEEN R8_DATAINI AND R8_DATAFIM)))" + CRLF
	c_qry += " AND R8_FILIAL 	= '" + c_fil + "'" + CRLF
	c_qry += " AND R8_MAT 		= '" + c_mat + "'" + CRLF
	c_qry += " AND R8_X_BO" + c_tipo + " = 'S'" + CRLF
	
	c_qry += " UNION ALL" + CRLF

	c_qry += " SELECT R8_DATAINI, R8_DATAFIM, R8_TIPO" + CRLF
	c_qry += " FROM " + retsqlname("SR8") + CRLF
	c_qry += " WHERE D_E_L_E_T_ <> '*'" + CRLF
	c_qry += " AND R8_TIPO 		<> 'F'" + CRLF
	c_qry += " AND R8_DATAFIM	= '        '" + CRLF
	c_qry += " AND R8_DATAINI	<= '" + c_fima + "'" + CRLF
	c_qry += " AND R8_FILIAL 	= '" + c_fil + "'" + CRLF
	c_qry += " AND R8_MAT 		= '" + c_mat + "'" + CRLF
	c_qry += " AND R8_X_BO" + c_tipo + " = 'S'" + CRLF	
	
	if c_tipo <> "VA"
		c_qry += " UNION ALL" + CRLF
	
		c_qry += " SELECT R8_DATAINI, R8_DATAFIM, R8_TIPO" + CRLF
		c_qry += " FROM " + retsqlname("SR8") + CRLF
		c_qry += " WHERE D_E_L_E_T_ <> '*'" + CRLF
		c_qry += " AND R8_TIPO 		= 'F'" + CRLF
		c_qry += " AND (((R8_DATAINI BETWEEN '" + c_inif + "' AND '" + c_fimf + "')" + CRLF
		c_qry += " OR (R8_DATAFIM BETWEEN '" + c_inif + "' AND '" + c_fimf + "'))" + CRLF
		c_qry += " OR (('" + c_inif + "' BETWEEN R8_DATAINI AND R8_DATAFIM)" + CRLF
		c_qry += " OR ('" + c_fimf + "' BETWEEN R8_DATAINI AND R8_DATAFIM)))" + CRLF
		c_qry += " AND R8_FILIAL 	= '" + c_fil + "'" + CRLF
		c_qry += " AND R8_MAT 		= '" + c_mat + "'" + CRLF
	endif
	
	TCQUERY c_qry NEW ALIAS "QRY2"
	
	dbselectarea("QRY2")
	while QRY2->(!eof())
		if QRY2->R8_TIPO == "F"
			if QRY2->R8_DATAINI <= c_inif
				d_ini := stod(c_inif)
			else
				d_ini := stod(QRY2->R8_DATAINI)
			endif
			if QRY2->R8_DATAFIM >= c_fimf 
				d_fim := stod(c_fimf)
			else 
				d_fim := stod(QRY2->R8_DATAFIM)
			endif
		else
			if QRY2->R8_DATAINI <= a_ponto[n_pos, 2]
				d_ini := stod(a_ponto[n_pos, 2])
			else
				d_ini := stod(QRY2->R8_DATAINI)
			endif
			if empty(alltrim(QRY2->R8_DATAFIM)) .or. QRY2->R8_DATAFIM >= a_ponto[n_pos, 3] 
				d_fim := stod(a_ponto[n_pos, 3])
			else 
				d_fim := stod(QRY2->R8_DATAFIM)
			endif
		endif
		do case
			case c_tipo $ "VR/VA"
				do case
					case c_escala $ "1/3"
						n_dfim := 6
					case c_escala == "2"
						n_dfim := 7
				endcase
			case c_tipo == "VT"
				do case
					case c_escala == "1"
						n_dfim := 6
					case c_escala $ "2/3"
						n_dfim := 7
				endcase
		endcase
		while d_ini <= d_fim
			if dow(d_ini) >= 2 .and. dow(d_ini) <= n_dfim
				if !f_Holid(c_fil, d_ini) 	
				//Checa se � feriado para n�o descontar novamente na compet�ncia futura caso o afastamento/f�rias seja num feriado.
				//Ex: gerando para maio, 01/05 ser� descontado dos dias de cr�dito, pois � feriado.
				//Gerando para junho, se ele teve afastamento em 01/05, esse dia n�o pode ser abatido novamente.
					n_ret ++
				endif
			endif
			d_ini ++
		enddo
		QRY2->(dbskip())
	enddo
	dbselectarea("QRY2")
	dbclosearea()

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_BuscaFol�Autor  �PABLO VB CARVALHO   � Data �  01/04/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca informa��es de d�bito na folha.                	  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_BuscaFol(c_fil, c_mat)

	Local n_ret 	:= 0
	Local c_qry 	:= ""
	Local n_aux		:= 0
	Local c_mini	:= ""
	Local c_aini	:= ""
	Local c_cmpfol	:= ""
		
	n_aux := val(substr(c_comp, 1, 2)) - 2
	if n_aux <= 0
		c_mini := strzero(12 + n_aux, 2)
		c_aini := alltrim(cvaltochar(val(substr(c_comp, 3, 4)) - 1))				
	else
		c_mini := strzero(n_aux, 2)
		c_aini := substr(c_comp, 3, 4)
	endif
	c_cmpfol := c_aini + c_mini
		
	c_qry := "SELECT SUM(RD_HORAS) AS N_TOTAL" + CRLF
	c_qry += " FROM " + retsqlname("SRD") + CRLF
	c_qry += " WHERE D_E_L_E_T_ <> '*'" + CRLF
	c_qry += " AND RD_FILIAL 	= '" + c_fil + "'" + CRLF
	c_qry += " AND RD_MAT  		= '" + c_mat + "'" + CRLF
	c_qry += " AND RD_PD  		= '420'" + CRLF
	c_qry += " AND RD_DATARQ	= '" + c_cmpfol + "'" + CRLF
	
	TCQUERY c_qry NEW ALIAS "QRY2"
	
	dbselectarea("QRY2")
	if QRY2->(!eof())
		n_ret := QRY2->N_TOTAL
	endif
	dbclosearea()

Return(n_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_Qry             �PABLO VB CARVALHO   � Data �  01/04/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta a query principal.                             	  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Qry()

	Local c_ret 	:= ""
	Local n_cont	:= 0
	Local c_txt		:= ""
	Local c_txt2	:= ""
	
	c_ret := "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01, SQB.QB_DESCRIC, SRA.RA_ADMISSA," + CRLF
	c_ret += " SRA.RA_REGRA, SRA.RA_VIEMRAI, SR6.R6_X_BOESC" + CRLF
	
	do case
		case mv_par10 == 1 //VR
			c_ret += ", (SELECT SR0.R0_VLRVALE FROM " + retsqlname("SR0") + " SR0 WHERE SR0.R0_FILIAL = SRA.RA_FILIAL AND SR0.R0_MAT = SRA.RA_MAT AND SRA.D_E_L_E_T_ <> '*' AND SR0.D_E_L_E_T_ <> '*' AND SR0.R0_TPVALE = '1') AS N_REF" + CRLF	
		case mv_par10 == 2 //VA
			c_ret += ", SRA.RA_VLRVR AS N_ALIM" + CRLF
	endcase
	
	c_ret += " FROM " + retsqlname("SRA") + " SRA" + CRLF
	c_ret += " INNER JOIN " + retsqlname("SR6") + " SR6 ON " + FWJoinFilial("SRA", "SR6") + " AND SRA.RA_TNOTRAB = SR6.R6_TURNO" + CRLF
	c_ret += " INNER JOIN " + retsqlname("CTT") + " CTT ON " + FWJoinFilial("SRA", "CTT") + " AND SRA.RA_CC = CTT.CTT_CUSTO" + CRLF
	c_ret += " INNER JOIN " + retsqlname("SQB") + " SQB ON " + FWJoinFilial("SRA", "SQB") + " AND SRA.RA_DEPTO = SQB.QB_DEPTO" + CRLF
	c_ret += " WHERE SRA.D_E_L_E_T_ <> '*'" + CRLF
	c_ret += " AND SR6.D_E_L_E_T_ 	<> '*'" + CRLF
	c_ret += " AND CTT.D_E_L_E_T_ 	<> '*'" + CRLF
	c_ret += " AND SQB.D_E_L_E_T_ 	<> '*'" + CRLF
	c_ret += " AND SRA.RA_FILIAL 	>= '" + mv_par01 + "'" + CRLF
	c_ret += " AND SRA.RA_FILIAL 	<= '" + mv_par02 + "'" + CRLF
	c_ret += " AND SRA.RA_CC 		>= '" + mv_par03 + "'" + CRLF
	c_ret += " AND SRA.RA_CC	 	<= '" + mv_par04 + "'" + CRLF
	c_ret += " AND SRA.RA_DEPTO		>= '" + mv_par05 + "'" + CRLF
	c_ret += " AND SRA.RA_DEPTO		<= '" + mv_par06 + "'" + CRLF
	c_ret += " AND SRA.RA_MAT	 	>= '" + mv_par07 + "'" + CRLF
	c_ret += " AND SRA.RA_MAT	 	<= '" + mv_par08 + "'" + CRLF
	
	if mv_par13 == 2
		c_ret += " AND SRA.RA_ADMISSA 	<=  '" + substr(c_comp, 3, 4) + substr(c_comp, 1, 2) + "15'" + CRLF
		c_txt2	:= "2� Quinzena"
	else
		c_ret += " AND SRA.RA_ADMISSA 	<  '" + substr(c_comp, 3, 4) + substr(c_comp, 1, 2) + "01'" + CRLF
		c_txt2	:= "Mensal"
	endif
	
	c_ret += " AND "	
	do case
		case mv_par10 == 1 //VR
			c_ret += "SRA.RA_DESCVR = '1'" + CRLF
			c_txt := "Vale Refei��o"
		case mv_par10 == 2 //VA
			c_ret += "SRA.RA_DESCVA = '1'" + CRLF
			c_txt := "Vale Alimenta��o"
		case mv_par10 == 3 //VT
			c_ret += "SRA.RA_DESCVT = '1'" + CRLF
			c_txt := "Vale Transporte"
	endcase
	
	c_ret += " AND SRA.RA_CATFUNC 	IN ("
	for n_cont := 1 to len(mv_par11)
		c_ret += "'" + substr(mv_par11, n_cont, 1) + "', " 
	next
	c_ret := substr(c_ret, 1, len(c_ret) - 2) + ")" + CRLF
	
	c_ret += " AND SRA.RA_SITFOLH 	IN ("			
	for n_cont := 1 to len(mv_par12)
		c_ret += "'" + substr(mv_par12, n_cont, 1) + "', " 
	next			
	c_ret := substr(c_ret, 1, len(c_ret) - 2) + ")" + CRLF
	
	c_ret += " ORDER BY "
	
	do case
		case n_ordem == 1 //filial e matr�cula
			c_ret += "SRA.RA_FILIAL, SRA.RA_MAT"
			o_Report:SetTitle("Rela��o de Benef�cios - " + c_txt + " - " + c_txt2 + " - Cr�dito: " + dtoc(mv_par09) + " - Ordem de Impress�o: Filial e Matr�cula")
		case n_ordem == 2 //filial e nome
			c_ret += "SRA.RA_FILIAL, SRA.RA_NOME"
			o_Report:SetTitle("Rela��o de Benef�cios - " + c_txt + " - " + c_txt2 + " - Cr�dito: " + dtoc(mv_par09) + " - Ordem de Impress�o: Filial e Nome")
		case n_ordem == 3 //filial e c�digo do centro de custo
			c_ret += "SRA.RA_FILIAL, SRA.RA_CC"
			o_Report:SetTitle("Rela��o de Benef�cios - " + c_txt + " - " + c_txt2 + " - Cr�dito: " + dtoc(mv_par09) + " - Ordem de Impress�o: Filial e C�digo do Centro de Custo")
		case n_ordem == 4 //filial e descri��o do centro de custo
			c_ret += "SRA.RA_FILIAL, CTT.CTT_DESC01"
			o_Report:SetTitle("Rela��o de Benef�cios - " + c_txt + " - " + c_txt2 + " - Cr�dito: " + dtoc(mv_par09) + " - Ordem de Impress�o: Filial e Descri��o do Centro de Custo")
		case n_ordem == 5 //filial e departamento
			c_ret += "SRA.RA_FILIAL, SQB.SQB_DESCRIC"
			o_Report:SetTitle("Rela��o de Benef�cios - " + c_txt + " - " + c_txt2 + " - Cr�dito: " + dtoc(mv_par09) + " - Ordem de Impress�o: Filial e Departamento")
	endcase

Return(c_ret)

/*
�����������������������������������������������������������������������������
���Fun��o    �f_Holid           �PABLO VB CARVALHO   � Data �  05/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa se � feriado no ponto.                            	  ���
�������������������������������������������������������������������������͹��
���Uso       � FGPER025	                                                  ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�����������������������������������������������������������������������������
*/

Static Function f_Holid(c_fil, d_data)

	Local l_ret := .F.
	Local c_qry := ""
	
	c_qry += "SELECT *" + CRLF
	c_qry += " FROM " + retsqlname("SP3") + CRLF
	c_qry += " WHERE P3_FILIAL = '" + c_fil + "'"
	c_qry += " AND ((P3_FIXO = 'N' AND P3_DATA = '" + dtos(d_data) + "') OR" + CRLF
	c_qry += " (P3_FIXO = 'S' AND P3_MESDIA = '" + substr(dtos(d_data), 5, 4) + "'))" + CRLF
	c_qry += " AND D_E_L_E_T_ <> '*'" + CRLF
	
	TCQUERY c_qry NEW ALIAS "QRY3"
	
	dbselectarea("QRY3")
	if QRY3->(!eof())
		l_ret := .T.
	endif
	dbclosearea()

Return(l_ret)