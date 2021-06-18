#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FGPEM001 บAutor  ณPABLO VB CARVALHO   บ Dataณ   18/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera็ใo de Arquivo Sodexo e Salvador Card.  				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ26/01/2018บTBA007-PABLO VB   บNใo checa perํodo de experi๊ncia para VA.บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function FGPEM001
         	
	Private bProcesso	:= { |oSelf| f_Proc(oSelf)}
	Private c_perg 		:= padr("FGPEM001", 10)
	Private nHdl    	:= 0
	Private cArqTxt 	:= ""
	Private c_comp 		:= ""
	Private a_fer 		:= {} //feriados
	Private n_1q26		:= 0 //dias de cr้dito VT/VR, 1ช quinzena, segunda a sexta - somente para funcionแrios em experi๊ncia
	Private n_1q27		:= 0 //dias de cr้dito VT/VR, 1ช quinzena, segunda a sแbado - somente para funcionแrios em experi๊ncia
	Private n_2q26		:= 0 //dias de cr้dito VT/VR, 2ช quinzena, segunda a sexta - somente para funcionแrios em experi๊ncia
	Private n_2q27		:= 0 //dias de cr้dito VT/VR, 2ช quinzena, segunda a sแbado - somente para funcionแrios em experi๊ncia
	Private n_m26		:= 0 //dias de cr้dito VT/VR, mensal, segunda a sexta - somente para funcionแrios nใo mais em experi๊ncia
	Private n_m27		:= 0 //dias de cr้dito VT/VR, mensal, segunda a sแbado - somente para funcionแrios nใo mais em experi๊ncia
	Private a_ponto		:= {} //perํodos do ponto
		
	f_Perg(c_perg)
	Pergunte(c_perg, .F.)	
	tNewProcess():New("FGPEM001", "Sodexo - Salvador Card", bProcesso, "    Esta rotina tem por objetivo gerar os arquivos texto referente ao Sodexo e ao Salvador Card conforme parโmetros informados pelo usuแrio.", c_perg, , , , , .T., .T.)

Return

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_Perg    บAutor  ณPABLO VB CARVALHO   บ Data ณ  18/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata as perguntas da rotina.	          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_Perg(cperg)

	Local aregs		:= {}
	Local i, j		:= 0
	
	//grupo/ordem/pergunta/perg.spa/perg.eng/variavel/tipo/tamanho/decimal/presel/gsc/valid/ var01/def01/def1.spa/def1.eng/cnt01/var02/def02/def1.spa/def1.eng/cnt02/var03/def03/def1.spa/def1.eng/cnt03/var04/def04/def1.spa/def1.eng/cnt04/var05/def05/def1.spa/def1.eng/cnt05/f3/pyme/grpsxg/help/picture/idfil
	aadd(aregs, {cperg, "01", "Filial De				", "ฟDe sucursal ?              ","From Branch ?                 ", "mv_ch1", "C", FWGETTAMFILIAL, 			0, 0, "G", ""						, "mv_par01", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILDE.", "", ""})
	aadd(aregs, {cperg, "02", "Filial At้           	", "ฟA Sucursal ?         	    ","To Branch ?                   ", "mv_ch2", "C", FWGETTAMFILIAL, 			0, 0, "G", "naovazio()"				, "mv_par02", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILAT.", "", ""})
	aadd(aregs, {cperg, "03", "Centro de Custo De   	", "ฟDe Centro de Costo ?       ","From Cost Center ?            ", "mv_ch3", "C", tamsx3("RA_CC")[1], 		0, 0, "G", ""						, "mv_par03", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCDE.", "", ""})
	aadd(aregs, {cperg, "04", "Centro de Custo At้		", "ฟA Centro de Costo ?        ","To Cost Center ?              ", "mv_ch4", "C", tamsx3("RA_CC")[1], 		0, 0, "G", "naovazio()"				, "mv_par04", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCAT.", "", ""})
	aadd(aregs, {cperg, "05", "Departamento De 			", "ฟDe Depto. ?               	","Department From ?             ", "mv_ch5", "C", tamsx3("RA_DEPTO")[1],	0, 0, "G", ""						, "mv_par05", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"	, "S", "025", ".RHDPTDE.", "", ""})
	aadd(aregs, {cperg, "06", "Departamento At้			", "ฟA Depto. ?                	","Department To ?               ", "mv_ch6", "C", tamsx3("RA_DEPTO")[1], 	0, 0, "G", "naovazio()"				, "mv_par06", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"	, "S", "025", ".RHDPTAT.", "", ""})
	aadd(aregs, {cperg, "07", "Matricula De        		", "ฟDe Matricula ?            	","From Registration ?           ", "mv_ch7", "C", tamsx3("RA_MAT")[1],		0, 0, "G", ""						, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATD.", "", ""})
	aadd(aregs, {cperg, "08", "Matricula At้       		", "ฟA Matricula ?             	","To Registration ?             ", "mv_ch8", "C", tamsx3("RA_MAT")[1],		0, 0, "G", "naovazio()"				, "mv_par08", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATA.", "", ""})
	aadd(aregs, {cperg, "09", "Data do Cr้dito			", "Data do Cr้dito		      	","Data do Cr้dito				 ", "mv_ch9", "D", 8, 						0, 0, "G", "naovazio()"				, "mv_par09", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "10", "Diret๓rio de grava็ใo    ", "Diret๓rio de grava็ใo       ","Diret๓rio de grava็ใo         ", "mv_cha", "C", 99,                      0, 0, "G", "U_FGPEM002('FGPEM001')"	, "mv_par10", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "11", "Tipo"				     , "Tipo                        ","Tipo                          ", "mv_chb", "N", 1,                       0, 0, "C",""                        , "mv_par11","Vale Refei็ใo","Vale Refei็ใo","Vale Refei็ใo","","","Vale Aliment.","Vale Aliment.","Vale Aliment.","","","Vale Transporte","Vale Transporte","Vale Transporte","","","","","","","","","","","","","","","","",""})
	aadd(aregs, {cperg, "12", "Categorias	      		", "Categorias	             	","Categorias 			         ", "mv_chc", "C", 15,                 		0, 0, "G", "fCategoria()"			, "mv_par12", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHCATEG.", "", ""})
	aadd(aregs, {cperg, "13", "Situa็๕es	      		", "Situa็๕es	             	","Situa็๕es 			         ", "mv_chd", "C", 5,                 		0, 0, "G", "fSituacao"				, "mv_par13", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHSITUA.", "", ""})
	aadd(aregs, {cperg, "14", "Perํodo"				     , "Perํodo                     ","Perํodo                       ", "mv_che", "N", 1,                       0, 0, "C",""                        , "mv_par14","Mensal","Mensal","Mensal","","","2ช Quinzena","2ช Quinzena","2ช Quinzena","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aregs, {cperg, "15", "Codigo da Empresa - Sodexo", "Codigo da Empresa - Sodexo ","Codigo da Empresa - Sodexo    ", "mv_chf", "C", 8,                       0, 0, "G", ""						, "mv_par15", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "16", "Cod. Departamento - Sodexo", "Cod. Departamento - Sodexo ","Cod. Departamento - Sodexo    ", "mv_chg", "C", 18,                      0, 0, "G", ""						, "mv_par16", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "17", "Nome Departamento - Sodexo", "Nome Departamento - Sodexo ","Nome Departamento - Sodexo    ", "mv_chh", "C", 35,                      0, 0, "G", ""						, "mv_par17", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})	
	aadd(aregs, {cperg, "18", "Responsavel Depart. - Sodexo", "Responsavel Depart. - Sodexo","Responsavel Depart. - Sodexo", "mv_chi", "C", 20,                      0, 0, "G", ""						, "mv_par18", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
			
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
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_Proc    บAutor  ณPABLO VB CARVALHO   บ Data ณ  18/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento.					          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_Proc(oSelf)
	
	Local n_totreg 	:= 0
	Local c_datag	:= ""
	Local c_diag	:= ""
	Local c_mesg	:= ""
	Local c_anog	:= ""
	Local c_datac	:= ""
	Local c_diac	:= ""
	Local c_mesc	:= ""
	Local c_anoc	:= ""
	Local c_prod	:= ""
	Local c_forma	:= ""
	Local c_reg0	:= ""
	Local c_reg3	:= ""
	Local c_reg4	:= ""
	Local c_reg9	:= ""
	Local l_exper	:= .F.
	Local l_ponto	:= .F.
	Local n_vlalim	:= 0
	Local n_vlref	:= 0
	Local l_jvapr	:= .F.
	Local c_tiplog	:= ""	
	Local c_desclog	:= ""
	Local c_numlog	:= ""
	
	if mv_par11 == 1 .or. mv_par11 == 3 //VR ou VT
		do case
			case mv_par14 == 1 //mensal
				c_comp := substr(dtos(lastdate(mv_par09) + 1), 5, 2) + substr(dtos(lastdate(mv_par09) + 1), 1, 4)
			case mv_par14 == 2 //2ช quinzena
				c_comp := substr(dtos(mv_par09), 5, 2) + substr(dtos(mv_par09), 1, 4)
		endcase
		f_DiasCVTVR() //preenche as variแveis de dias de cr้dito VT e VR
		f_Feriados("1", "1") //carrega o vetor de feriados para VT e VR - segunda a sexta, 1ช quinzena
		f_Feriados("1", "2") //carrega o vetor de feriados para VT e VR - segunda a sexta, 2ช quinzena
		f_Feriados("2", "1") //carrega o vetor de feriados para VT e VR - segunda a sแbado, 1ช quinzena
		f_Feriados("2", "2") //carrega o vetor de feriados para VT e VR - segunda a sแbado, 2ช quinzena
		f_Feriados("3", "1") //carrega o vetor de feriados para VT e VR - segunda a sexta, mensal
		f_Feriados("3", "2") //carrega o vetor de feriados para VT e VR - segunda a sแbado, mensal
	else
		if mv_par11 == 2 //VA
			c_comp := substr(dtos(mv_par09), 5, 2) + substr(dtos(mv_par09), 1, 4)
		endif
	endif
	
	f_Ponto()
		
	if f_Arq()
		if mv_par11 == 1 .or. mv_par11 == 2 //sodexo VR ou VA
			c_datag	:= dtoc(date())
			c_diag	:= substr(c_datag, 1, 2)
			c_mesg	:= substr(c_datag, 4, 2)
			c_anog	:= substr(c_datag, 7, 4)
			c_datac	:= dtoc(mv_par09)
			c_diac	:= substr(c_datac, 1, 2)
			c_mesc	:= substr(c_datac, 4, 2)
			c_anoc	:= substr(c_datac, 7, 4)
			do case
				case mv_par11 == 1 //VR		
					c_prod 	:= "001"
					c_forma	:= "002"
				case mv_par11 == 2 //VA		
					c_prod 	:= "002"
					c_forma	:= "004"
			endcase
		
			//REGISTRO TIPO 0
				c_reg0 := "0"
				c_reg0 += strzero(val(mv_par15), 8)
				c_reg0 += padr(alltrim(FWFilRazSocial()), 40)
				c_reg0 += space(6)
				c_reg0 += c_comp
				c_reg0 += "005"
				c_reg0 += "001"
				c_reg0 += space(1)
				c_reg0 += c_diag + c_mesg + c_anog
				c_reg0 += c_diac + c_mesc + c_anoc
				c_reg0 += c_diac + c_mesc + c_anoc
				c_reg0 += CRLF
				If fWrite(nHdl, c_reg0, Len(c_reg0)) != Len(c_reg0)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif
			//FIM
			
			//REGISTRO TIPO 3
				c_reg3 := "3"
				c_reg3 += space(6)
				c_reg3 += upper(padr(alltrim(mv_par16), 18))
				c_reg3 += space(12)
				c_reg3 += upper(padr(alltrim(mv_par17), 35))
				c_reg3 += space(5)
				c_reg3 += upper(padr(alltrim(mv_par18), 20))
				c_reg3 += space(14)
				dbselectarea("RCA")
				dbsetorder(1)
				if dbseek(FWCodEmp() + FWUnitBusiness() + "  " + "M_TIPOLOGR")
					c_tiplog := strtran(alltrim(RCA->RCA_CONTEU), '"')
					c_tiplog := upper(padr(c_tiplog, 6))
				endif
				if dbseek(FWCodEmp() + FWUnitBusiness() + "  " + "M_DESCLOGR")
					c_desclog := strtran(alltrim(RCA->RCA_CONTEU), '"')
					c_desclog := upper(padr(c_desclog, 40))
				endif
				if dbseek(FWCodEmp() + FWUnitBusiness() + "  " + "M_NUMLOGR")
					c_numlog := strtran(alltrim(RCA->RCA_CONTEU), '"')
					c_numlog := upper(padr(c_numlog, 8))
				endif
				c_reg3 += c_tiplog + c_desclog + c_numlog
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_COMPENT, 1, 20)), 20))
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_BAIRENT, 1, 15)), 15))
				c_reg3 += space(5)
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_CIDENT, 1, 20)), 20))
				c_reg3 += space(10)
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_ESTENT, 1, 2)), 2))
				c_reg3 += padr(alltrim(substr(SM0->M0_CEPENT, 1, 8)), 8)
				c_reg3 += space(384)
				c_reg3 += CRLF
				If fWrite(nHdl, c_reg3, Len(c_reg3)) != Len(c_reg3)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif
			//FIM		
			
			//REGISTRO TIPO 4				
				TCQUERY f_Qry() NEW ALIAS "QRY"
			
				dbselectarea("QRY")
				Count To n_totreg
				oSelf:SetRegua1(n_totreg)
				
				QRY->(dbgotop())
				while QRY->(!eof())
					oself:incregua1(oemtoansi("Processando funcionแrio: ") + alltrim(QRY->RA_FILIAL) + " - " + QRY->RA_MAT + " - " + alltrim(QRY->RA_NOME))
					l_exper := iif(substr(dtos(stod(QRY->RA_ADMISSA) + 89), 1, 6) > substr(c_comp, 3, 4) + substr(c_comp, 1, 2), .T., .F.)
					l_jvapr	:= iif(QRY->RA_VIEMRAI == "55", .T., .F.)					
					if !l_jvapr .and.; //nใo ้ jovem aprendiz
						((mv_par14 == 1 .and. mv_par11 == 1) .or.; //mensal e VR
						(mv_par14 == 1 .and. mv_par11 == 2) .or.; //mensal e VA
						(mv_par14 == 2 .and. mv_par11 == 1 .and. l_exper)) //2ช quinzena e VR e estiver em experi๊ncia
						l_ponto := iif(QRY->RA_REGRA == "99" .or. empty(alltrim(QRY->RA_REGRA)), .F., .T.)
						
						do case
							case mv_par11 == 1 //VR
								n_vlref	:= QRY->N_REF
							case mv_par11 == 2 //VA
								n_vlalim := iif(QRY->N_ALIM == 0, val(alltrim(posicione("RCA", 1, xfilial("RCA") + "M_00000003", "RCA_CONTEU"))), QRY->N_ALIM)
						endcase
						
						c_reg4 := "4"
						c_reg4 += space(36)
						c_reg4 += strzero(val(QRY->RA_MAT), 10)
						c_reg4 += padr(alltrim(substr(QRY->RA_NOME, 1, 40)), 40)
						c_reg4 += space(1)
						c_reg4 += substr(QRY->RA_NASC, 7, 2) + substr(QRY->RA_NASC, 5, 2) + substr(QRY->RA_NASC, 1, 4) 
						c_reg4 += QRY->RA_CIC
						c_reg4 += QRY->RA_SEXO
						c_reg4 += c_prod
						c_reg4 += c_forma
						c_reg4 += replicate("0", 5)
						c_reg4 += replicate("0", 2)
						c_reg4 += f_Calc(QRY->RA_FILIAL, QRY->RA_MAT, l_exper, QRY->R6_X_BOESC, l_ponto, n_vlref, n_vlalim) 
						c_reg4 += CRLF
						If fWrite(nHdl, c_reg4, Len(c_reg4)) != Len(c_reg4)
							aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
							Return
						Endif
					endif
					QRY->(dbskip())
				enddo
				dbselectarea("QRY")
				dbclosearea()
			//FIM
		
			//REGISTRO TIPO 9
				c_reg9 := "9"
				c_reg9 += CRLF
				If fWrite(nHdl, c_reg9, Len(c_reg9)) != Len(c_reg9)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif
			//FIM
		else
			if mv_par11 == 3 //salvador card VT
				TCQUERY f_Qry() NEW ALIAS "QRY"
			
				dbselectarea("QRY")
				Count To n_totreg
				oSelf:SetRegua1(n_totreg)
				
				QRY->(dbgotop())
				while QRY->(!eof())
					oself:incregua1(oemtoansi("Processando funcionแrio: ") + alltrim(QRY->RA_FILIAL) + " - " + QRY->RA_MAT + " - " + alltrim(QRY->RA_NOME))
					l_exper := iif(substr(dtos(stod(QRY->RA_ADMISSA) + 89), 1, 6) > substr(c_comp, 3, 4) + substr(c_comp, 1, 2), .T., .F.)					
					if mv_par14 == 1 .or.; //mensal e VT
						(mv_par14 == 2 .and. l_exper) //2ช quinzena e VT e estiver em experi๊ncia
						l_ponto := iif(QRY->RA_REGRA == "99" .or. empty(alltrim(QRY->RA_REGRA)), .F., .T.)
						
						c_reg0 := strzero(val(QRY->RA_MAT), 15)
						c_reg0 += f_Calc(QRY->RA_FILIAL, QRY->RA_MAT, l_exper, QRY->R6_X_BOESC, l_ponto)
						c_reg0 += CRLF
						If fWrite(nHdl, c_reg0, Len(c_reg0)) != Len(c_reg0)
							aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
							Return
						Endif
					endif
					QRY->(dbskip())
				enddo
				dbselectarea("QRY")
				dbclosearea()				
			endif
		endif
		
		aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Processamento finalizado.",{"OK"},2,"Aviso")
		fClose(nHdl)	
	endif

Return

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_DiasCVTVR บAutor  ณPABLO VB CARVALHO บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega variแveis de dias de cr้dito VT e VR.			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_DiasCVTVR()

	Local d_ini		:= ctod("01/" + substr(c_comp, 1, 2) + "/" + substr(c_comp, 3, 4)) 
	Local d_aux1	:= ctod("  /  /    ")
	Local d_aux2	:= ctod("  /  /    ")
		
	//dias de cr้dito VT/VR, 1ช quinzena, segunda a sexta - somente para funcionแrios em experi๊ncia
	d_aux1 := d_ini
	d_aux2 := d_ini + 14
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 6
			n_1q26 ++
		endif
		d_aux1 ++
	enddo
	
	//dias de cr้dito VT/VR, 1ช quinzena, segunda a sแbado - somente para funcionแrios em experi๊ncia
	d_aux1 := d_ini
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 7
			n_1q27 ++
		endif
		d_aux1 ++
	enddo
	
	//dias de cr้dito VT/VR, 2ช quinzena, segunda a sexta - somente para funcionแrios em experi๊ncia
	d_aux1 := d_ini + 15
	d_aux2 := lastdate(d_aux1)
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 6
			n_2q26 ++
		endif
		d_aux1 ++
	enddo

	//dias de cr้dito VT/VR, 2ช quinzena, segunda a sแbado - somente para funcionแrios em experi๊ncia
	d_aux1 := d_ini + 15
	while d_aux1 <= d_aux2
		if dow(d_aux1) >= 2 .and. dow(d_aux1) <= 7
			n_2q27 ++
		endif
		d_aux1 ++
	enddo
	
	//dias de cr้dito VT/VR, mensal, segunda a sexta - somente para funcionแrios nใo mais em experi๊ncia
	n_m26 := n_1q26 + n_2q26
	
	//dias de cr้dito VT/VR, mensal, segunda a sแbado - somente para funcionแrios nใo mais em experi๊ncia
	n_m27 := n_1q27 + n_2q27

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_FeriadosบAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o vetor de feriados.		          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
			case c_dias == "2" //segunda a sแbado
				c_dsemfim := "7"
		endcase
				
		do case
			case c_per == "1" //1ช quinzena
				c_dtini := dtos(ctod("01/" + substr(c_comp, 1, 2) + "/" + substr(c_comp, 3, 4)))
				c_dtfim := dtos(stod(c_dtini) + 14)
			case c_per == "2" //2ช quinzena
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
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_Arq 	บAutor  ณPABLO VB CARVALHO   บ Data ณ  18/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define o nome do arquivo e chama a fun็ใo de cria็ใo.	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_Arq()

	Local l_ret	:= .F.
	
	do case
		case mv_par11 == 1 //VR		
			cArqTxt := "SDXV5_" + strzero(val(mv_par15), 8) + "_VR" + c_comp + ".TXT"
		case mv_par11 == 2 //VA		
			cArqTxt := "SDXV5_" + strzero(val(mv_par15), 8) + "_VA" + c_comp + ".TXT"			
		case mv_par11 == 3 //VT		
			cArqTxt := "VT" + c_comp + ".TXT"
	endcase
			
	cArqTxt := alltrim(mv_par10) + cArqTxt
	if file(cArqTxt)
		if aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Arquivo " + upper(cArqTxt) + " jแ existe. Deseja sobrepor?",{"Sim", "Nใo"},2,"Aviso") == 1
			l_ret := f_CriArq()
		endif
	else
		l_ret := f_CriArq()		
	endif

Return(l_ret)

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_CriArq  บAutor  ณPABLO VB CARVALHO   บ Data ณ  18/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata a cria็ใo do arquivo.				 				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_CriArq()

	Local n_cod	:= 0
	Local c_msg	:= ""
	Local l_ret	:= .F.
	
	nHdl 	:= fCreate(cArqTxt)
	n_cod	:= fError()
	if nHdl == -1
		c_msg := "Erro na cria็ใo do arquivo. Verifique se hแ espa็o disponํvel e se voc๊ tem acesso de grava็ใo." + CRLF + CRLF
		c_msg += "Detalhes do erro:" + CRLF
		do case
			case n_cod == 2
				c_msg += "Arquivo nใo encontrado."
			case n_cod == 3
				c_msg += "Diret๓rio nใo encontrado."
			case n_cod == 4
				c_msg += "Muitos arquivos foram abertos. Verifique o parโmetro FILES."
			case n_cod == 5
				c_msg += "Impossํvel acessar o arquivo."
			case n_cod == 6
				c_msg += "N๚mero de manipula็ใo de arquivo invแlido.'
			case n_cod == 8
				c_msg += "Mem๓ria insuficiente."
			case n_cod == 15
				c_msg += "Acionador (Drive) de discos invแlido."
			case n_cod == 19
				c_msg += "Tentativa de gravar sobre um disco protegido contra escrita."
			case n_cod == 21
				c_msg += "Acionador (Drive) de discos inoperante."
			case n_cod == 23
				c_msg += "Erro de dados no disco."
			case n_cod == 29
				c_msg += "Erro de grava็ใo no disco."
			case n_cod == 30
				c_msg += "Erro de leitura no disco."
			case n_cod == 32
				c_msg += "Viola็ใo de compartilhamento."
			case n_cod == 33
				c_msg += "Viola็ใo de bloqueio."
		endcase
		aviso(alltrim(SM0->M0_NOMECOM) + " - GPE",c_msg,{"OK"},2,"Problema")
	else
		l_ret := .T. 
	endif
	
Return(l_ret)

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_Calc    บAutor  ณPABLO VB CARVALHO   บ Data ณ  18/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cแlculo dos valores.				          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_Calc(c_fil, c_mat, l_experi, c_escala, l_pt, n_ref, n_alim)

	Local n_valor	:= 0
	Local c_ret		:= ""
	Local n_diasc	:= 0
	Local n_diasd	:= 0
	Local n_tam		:= 12
	
	do case
		case mv_par11 == 1 //VR
			n_diasc		:= f_DiasCVR(c_fil, l_experi, c_escala)
			n_diasd		:= f_DiasDeb(c_fil, c_mat, l_pt, c_escala, "VR")  
			n_valor		:= (n_diasc - n_diasd) * n_ref * 100				
		case mv_par11 == 2 //VA
			n_diasd		:= f_DiasDeb(c_fil, c_mat, l_pt, c_escala, "VA")
			n_valor		:= (n_alim/30) * (30 - n_diasd) * 100
		case mv_par11 == 3 //VT
			n_diasc		:= f_DiasCVT(c_fil, l_experi, c_escala)
			n_diasd		:= f_DiasDeb(c_fil, c_mat, l_pt, c_escala, "VT")
			n_valor		:= n_diasc - n_diasd
			n_tam		:= 2
	endcase
	
	if n_valor >= 0
		c_ret := strzero(n_valor, n_tam)
	endif

Return(c_ret)

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_DiasCVR บAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dias de cr้dito VR do funcionแrio.          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_DiasCVR(c_fil, l_experi, c_escala)

	Local n_ret := 0
	
	if l_experi //funcionแrio em experi๊ncia
		do case
			case mv_par14 == 1 //1ช quinzena
				do case
					case c_escala $ "1/3" //segunda a sexta e segunda a sแbado 1/2 turno
						n_ret := n_1q26 - f_BuscaFer(c_fil, "11")
					case c_escala == "2" //segunda a sแbado integral
						n_ret := n_1q27 - f_BuscaFer(c_fil, "21")
				endcase
			case mv_par14 == 2 //2ช quinzena
				do case
					case c_escala $ "1/3" //segunda a sexta e segunda a sแbado 1/2 turno
						n_ret := n_2q26 - f_BuscaFer(c_fil, "12")
					case c_escala == "2" //segunda a sแbado integral
						n_ret := n_2q27 - f_BuscaFer(c_fil, "22")
				endcase
		endcase
	else //funcionแrio nใo mais em experi๊ncia
		if mv_par14 == 1 //mensal
			do case
				case c_escala $ "1/3" //segunda a sexta e segunda a sแbado 1/2 turno
					n_ret := n_m26 - f_BuscaFer(c_fil, "31")
				case c_escala == "2" //segunda a sแbado integral
					n_ret := n_m27 - f_BuscaFer(c_fil, "32")
			endcase
		endif
	endif

Return(n_ret)

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_BuscaFerบAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca no vetor de feriados.		          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_DiasCVT บAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dias de cr้dito VT do funcionแrio.          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_DiasCVT(c_fil, l_experi, c_escala)

	Local n_ret := 0
	
	if l_experi //funcionแrio em experi๊ncia
		do case
			case mv_par14 == 1 //1ช quinzena
				do case
					case c_escala == "1" //segunda a sexta
						n_ret := n_1q26 - f_BuscaFer(c_fil, "11")
					case c_escala $ "2/3" //segunda a sแbado integral e segunda a sแbado 1/2 turno
						n_ret := n_1q27 - f_BuscaFer(c_fil, "21")
				endcase
			case mv_par14 == 2 //2ช quinzena
				do case
					case c_escala == "1" //segunda a sexta
						n_ret := n_2q26 - f_BuscaFer(c_fil, "12")
					case c_escala $ "2/3" //segunda a sแbado integral e segunda a sแbado 1/2 turno
						n_ret := n_2q27 - f_BuscaFer(c_fil, "22")
				endcase
		endcase
	else //funcionแrio nใo mais em experi๊ncia
		if mv_par14 == 1 //mensal
			do case
				case c_escala == "1" //segunda a sexta
					n_ret := n_m26 - f_BuscaFer(c_fil, "31")
				case c_escala $ "2/3" //segunda a sแbado integral e segunda a sแbado 1/2 turno
					n_ret := n_m27 - f_BuscaFer(c_fil, "32")
			endcase
		endif
	endif

Return(n_ret)

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_DiasDeb บAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dias de d้bito.                            				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_DiasDeb(c_fil, c_mat, l_pt, c_escala, c_tipo)

	Local n_ret 	:= 0
	Local n_faltas	:= 0
	Local n_afafer	:= 0

	if mv_par14 == 1
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_Ponto   บAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os perํodos do ponto de todas as filiais.		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_BuscaPonบAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca informa็๕es de d้bito no apontamento do ponto.		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_PonFech บAutor  ณPABLO VB CARVALHO   บ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o perํodo estแ fechado.						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_BuscaAfaFerบAutor  ณPABLO VB CARVALHOบ Data ณ  22/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca informa็๕es de d้bito nos afastamentos e f้rias.	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
				//Checa se ้ feriado para nใo descontar novamente na compet๊ncia futura caso o afastamento/f้rias seja num feriado.
				//Ex: gerando para maio, 01/05 serแ descontado dos dias de cr้dito, pois ้ feriado.
				//Gerando para junho, se ele teve afastamento em 01/05, esse dia nใo pode ser abatido novamente.
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_BuscaFolบAutor  ณPABLO VB CARVALHO   บ Data ณ  01/04/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca informa็๕es de d้bito na folha.                	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_Qry             ณPABLO VB CARVALHO   บ Data ณ  01/04/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a query principal.                             	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function f_Qry()

	Local c_ret 	:= ""
	Local n_cont	:= 0
	
	c_ret := "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_NASC, SRA.RA_CIC, SRA.RA_SEXO, SRA.RA_ADMISSA," + CRLF
	c_ret += " SRA.RA_REGRA, SRA.RA_VIEMRAI, SR6.R6_X_BOESC" + CRLF
	
	do case
		case mv_par11 == 1 //VR
			c_ret += ", (SELECT SR0.R0_VLRVALE FROM " + retsqlname("SR0") + " SR0 WHERE SR0.R0_FILIAL = SRA.RA_FILIAL AND SR0.R0_MAT = SRA.RA_MAT AND SRA.D_E_L_E_T_ <> '*' AND SR0.D_E_L_E_T_ <> '*' AND SR0.R0_TPVALE = '1') AS N_REF" + CRLF	
		case mv_par11 == 2 //VA
			c_ret += ", SRA.RA_VLRVR AS N_ALIM" + CRLF
	endcase
	
	c_ret += " FROM " + retsqlname("SRA") + " SRA" + CRLF
	c_ret += " INNER JOIN " + retsqlname("SR6") + " SR6 ON SRA.RA_TNOTRAB = SR6.R6_TURNO AND SRA.RA_FILIAL = SR6.R6_FILIAL" + CRLF
	c_ret += " WHERE SRA.D_E_L_E_T_ <> '*'" + CRLF
	c_ret += " AND SR6.D_E_L_E_T_ 	<> '*'" + CRLF
	c_ret += " AND SRA.RA_FILIAL 	>= '" + mv_par01 + "'" + CRLF
	c_ret += " AND SRA.RA_FILIAL 	<= '" + mv_par02 + "'" + CRLF
	c_ret += " AND SRA.RA_CC 		>= '" + mv_par03 + "'" + CRLF
	c_ret += " AND SRA.RA_CC	 	<= '" + mv_par04 + "'" + CRLF
	c_ret += " AND SRA.RA_DEPTO		>= '" + mv_par05 + "'" + CRLF
	c_ret += " AND SRA.RA_DEPTO		<= '" + mv_par06 + "'" + CRLF
	c_ret += " AND SRA.RA_MAT	 	>= '" + mv_par07 + "'" + CRLF
	c_ret += " AND SRA.RA_MAT	 	<= '" + mv_par08 + "'" + CRLF
	
	if mv_par14 == 2
		c_ret += " AND SRA.RA_ADMISSA 	<=  '" + substr(c_comp, 3, 4) + substr(c_comp, 1, 2) + "15'" + CRLF
	else
		c_ret += " AND SRA.RA_ADMISSA 	<  '" + substr(c_comp, 3, 4) + substr(c_comp, 1, 2) + "01'" + CRLF
	endif
	
	c_ret += " AND "	
	do case
		case mv_par11 == 1 //VR
			c_ret += "SRA.RA_DESCVR = '1'" + CRLF
		case mv_par11 == 2 //VA
			c_ret += "SRA.RA_DESCVA = '1'" + CRLF
		case mv_par11 == 3 //VT
			c_ret += "SRA.RA_DESCVT = '1'" + CRLF
	endcase
	
	c_ret += " AND SRA.RA_CATFUNC 	IN ("
	for n_cont := 1 to len(mv_par12)
		c_ret += "'" + substr(mv_par12, n_cont, 1) + "', " 
	next
	c_ret := substr(c_ret, 1, len(c_ret) - 2) + ")" + CRLF
	
	c_ret += " AND SRA.RA_SITFOLH 	IN ("			
	for n_cont := 1 to len(mv_par13)
		c_ret += "'" + substr(mv_par13, n_cont, 1) + "', " 
	next			
	c_ret := substr(c_ret, 1, len(c_ret) - 2) + ")" + CRLF
	
	c_ret += " ORDER BY SRA.RA_FILIAL, SRA.RA_MAT"

Return(c_ret)

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_Holid           ณPABLO VB CARVALHO   บ Data ณ  05/05/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Checa se ้ feriado no ponto.                            	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FGPEM001	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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