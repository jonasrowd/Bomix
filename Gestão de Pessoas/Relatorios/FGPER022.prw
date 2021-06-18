#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FGPER022	  �Autor �01-REGIS&CIA	     � Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de Afastamentos								  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE		  	                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FGPER022()         


Local c_Perg	:= "FGPER022"
Local c_Dados   := ""    
Public c_Texto   := "Afastamentos"
Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan(c_Texto,"Esta rotina tem a finaldade de", "imprimir os "+c_Texto, "Desenvolvido pela TI da Bomix","FGPER022")

If l_Opcao
	 
	f_ValidPerg(c_Perg)
	If !Pergunte(c_Perg,.T.)
		Return()
	Endif 
    
	c_Texto += "("+DTOC(MV_PAR05)+" at� "+DTOC(MV_PAR06)+")"
	f_RelatPadrao()
	
Else
	
	Return()
	
EndIf

Return

/*
�������������������������������������������������������������������������ͻ��
���Imprimi													   ��
�������������������������������������������������������������������������͹��
*/
Static Function f_RelatPadrao()

Private oArial30  	:=	TFont():New("Arial",,20,,.F.,,,,,.F.,.F.)
Private o11N   		:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
Private o9N			:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
Private o7N			:=	TFont():New("",,7,,.T.,,,,,.F.,.F.)
Private o8N			:=	TFont():New("",,8,,.T.,,,,,.F.,.F.)
Private o10N		:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New(c_Texto)
oPrinter:Setup()
oPrinter:SetPortrait()
oPrinter:StartPage()
printPage()
oPrinter:Preview()

Return

/*
�������������������������������������������������������������������������ͻ��
���Imprimir os HEADER													   ��
�������������������������������������������������������������������������͹��
*/
Static function f_header (c_Emp,c_CNPJ) 

Local _aBmp     := {}

aAdd (_aBmp,"\system\lgrl"+cEmpAnt+".bmp")

oPrinter:SayBitmap(045, 0100, _aBmp[1], 250, 120)


oPrinter:Box(0177,0098,0288,2321)
oPrinter:Box(0177,0098,0288,2321)
//cabe�alho
oPrinter:Say(070,2052,'Emiss�o:'   + DTOC(dDataBase),o11N,,0)
oPrinter:Say(0175,0742,c_Texto ,oArial30,,0)
oPrinter:Box(0288,0098,0340,1505)
oPrinter:Box(0288,1505,0340,2321)
oPrinter:Say(0293,0128,"Empresa :" +      c_Emp,o11N,,0)
oPrinter:Say(0300,1530,"CNPJ:"     +      TRANSFORM(c_CNPJ,"@R 99.999.999/9999-99"),o9N,,0)

//box matricula
oPrinter:Box(0362,0102,0428,0292)
//box nome
oPrinter:Box(0362,0292,0428,1050)
//box data admiss�o 1
oPrinter:Box(0362,1050,0428,1300)
//box Departamento
oPrinter:Box(0362,1300,0428,1670)


//box datas
oPrinter:Box(0362,1670,0428,1790)
oPrinter:Box(0362,1790,0428,1900)
oPrinter:Box(0362,1900,0428,2020)

//box dias
oPrinter:Box(0362,2020,0428,2120)
oPrinter:Box(0362,2120,0428,2220)
oPrinter:Box(0362,2220,0428,2320)

oPrinter:Say(0380,0109,"MATR�CULA",o8N,,0)
oPrinter:Say(0380,0300,"NOME",o8N,,0)
oPrinter:Say(0380,1055,"D.ADMISS�O",o8N,,0)
oPrinter:Say(0380,1305,"DEPARTAMENTO",o8N,,0)

oPrinter:Say(0380,1675,"DATA",o8N,,0)
oPrinter:Say(0380,1795,"Dt.INI",o8N,,0)
oPrinter:Say(0380,1905,"Dt.FIM",o8N,,0)

oPrinter:Say(0380,2025,"PER�ODO ",o7N,,0)
oPrinter:Say(0380,2125,"ATESTADO",o7N,,0)
oPrinter:Say(0380,2225,"C.I.D",o8N,,0)

return

/*
�������������������������������������������������������������������������ͻ��
���Imprimir os Grid														   ��
�������������������������������������������������������������������������͹��
*/
Static function f_grid(n_line)

local  n_altura := n_line + 60
//  n_line := + 10
//box matricula
oPrinter:Box(n_line + 10 ,0102,n_altura,0292)
//box nome
oPrinter:Box(n_line + 10 ,0292,n_altura,1050)
//box data de admiss�o
oPrinter:Box(n_line + 10 ,1050,n_altura,1300)
//box Departamento
oPrinter:Box(n_line + 10 ,1300,n_altura,1670)


//box datas
oPrinter:Box(n_line + 10,1670,n_altura,1790)
oPrinter:Box(n_line + 10,1790,n_altura,1900)
oPrinter:Box(n_line + 10,1900,n_altura,2020)
//box dias
oPrinter:Box(n_line + 10 ,2020,n_altura,2120)
oPrinter:Box(n_line + 10 ,2120,n_altura,2220)
oPrinter:Box(n_line + 10 ,2220,n_altura,2320)

return


/*
�������������������������������������������������������������������������ͻ��
���Imprimir os Dados											   ��
�������������������������������������������������������������������������͹��
*/
Static Function printPage()

Local    n_pag 			:=	0
Local    n_Count     	:=	0 
Local 	 n_Dias			:=  0 

Private  c_Matricula  	:=	''
Private  c_Nome			:=	''
Private  d_DataAdmi		
Private  c_Departamento	:=	''
Private  d_Data			:=	''

Private  d_DataInicio	:=	''
Private  d_DataFim		:=	''
Private  d_DataTmp		:=	''


Private  nI				:=	0
Public 	 n_Row	:= 0370    
Public 	 a_Mes01		:=  {}
Public 	 a_Mes02		:=  {}
Public 	 a_Mes03		:=  {}

c_Emp 	:= SM0->M0_NOMECOM
c_CNPJ  := SM0->M0_CGC

c_Dados := ""

//imprime cabe�alho
f_header (c_Emp,c_CNPJ)

f_SelDados()
DbSelectArea("QRY")
DbGoTop()  


While QRY->( !Eof() )

		c_Matricula		:= QRY->MATRICULA
		c_Nome		    := QRY->NOME      
		d_DataAdmi		:= DTOC(STOD(QRY->DATA_ADMISSAO))
		c_Departamento	:= QRY->DEPARTAMENTO
		d_Data			:= DTOC(STOD(QRY->DATA))
		n_Dias		  	:= 0 
		
		d_DataInicio	:=	StoD(QRY->R8_DATAINI)
		d_DataFim		:=	StoD(QRY->R8_DATAFIM)
		d_DataTmp 		:= 	StoD(QRY->R8_DATAINI)
		l_TrbSabado     :=  f_TrbSabado(QRY->TURNO)
		
        
		While d_DataTmp <= d_DataFim  

			  If d_DataTmp >= MV_PAR05 .and. d_DataTmp <= MV_PAR06
			  	 
			  	If dow(d_DataTmp)<> 1  
					 n_Dias ++			  
				EndIf			 					 	 
				                                                  
				If l_TrbSabado .and. 	dow(d_DataTmp)<> 7
				  	 n_Dias --
				Endif    
				 
			  EndIf
			
			d_DataTmp:= d_DataTmp+1
			
		EndDo  
				
		If n_Dias == 0  
			QRY->( DbSkip() )
			Loop
		Endif  
		

		a_Mes01		:=  f_MesAnterior(1,QRY->MATRICULA)
		a_Mes02		:=  f_MesAnterior(2,QRY->MATRICULA)
		a_Mes03		:=  f_MesAnterior(3,QRY->MATRICULA)  

		n_Row := n_Row + 50
		
		f_grid(n_Row)//imprime a grid dos itens
		
		oPrinter:Say(n_Row + 16,0109,Transform(c_Matricula,"@! 999999"),o9N,,0)
		oPrinter:Say(n_Row + 16,0301,SUBSTR(c_Nome,1,40),o9N,,0)
		oPrinter:Say(n_Row + 16,1055,d_DataAdmi,o9N,,0)
		oPrinter:Say(n_Row + 16,1310,SUBSTR(c_Departamento,1,21),o9N,,0)
		                            
		
		oPrinter:Say(n_Row + 16,1675,d_Data,o9N,,0)
		oPrinter:Say(n_Row + 16,1795,DTOC(d_DataInicio),o9N,,0)
		oPrinter:Say(n_Row + 16,1905,DTOC(d_DataFim),o9N,,0)
		
		
		oPrinter:Say(n_Row + 16,2025,	Transform(n_Dias,"@E# 9999"),o9N,,0)
		oPrinter:Say(n_Row + 16,2125,	Transform(QRY->R8_DURACAO,"@E# 9999"),o9N,,0)
		oPrinter:Say(n_Row + 16,2225,	TRIM(QRY->R8_CID),o9N,,0)
		
		c_Dados += c_Matricula+";"+;
					SUBSTR(c_Nome,1,40)+";"+;
					d_DataAdmi+";"+;
					SUBSTR(QRY->FUNCAO,1,40)+";"+;
					SUBSTR(c_Departamento,1,40)+";"+;
					d_Data+";"+;
					DTOC(d_DataInicio)+";"+;
					DTOC(d_DataFim)+";"+;
					Transform(n_Dias,"@E# 9999")+";"+;
					Transform(QRY->R8_DURACAO,"@E# 9999")+";"+;
					TRIM(QRY->R8_CID)+";"+;
					TRIM(QRY->DESCRICAO_CID)+";"+;
					TRIM(IIF(f_PlanoSaude(QRY->MATRICULA),"Sim","N�o"))+";"+;
					TRIM(IIF(a_Mes03[1][1],"Sim","N�o"))+";"+;
					TRIM(IIF(a_Mes02[1][1],"Sim","N�o"))+";"+;
					TRIM(IIF(a_Mes01[1][1],"Sim","N�o"))+CHR(13)+CHR(10)
		
		n_Count++
		
		//quebra de p�gina a cada 56 registro
		if (MOD(n_Count, 56) = 0)
			//imprime cabe�alho
			f_header (c_Emp,c_CNPJ)
			f_grid(0420)//imprime a grid dos itens 
			n_Row := 0370
			n_pag ++
			oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Count)	,o10N,,0)//roda p�
			oPrinter:Say(3317,1884,'P�g.:' + cValToChar(n_pag),o10N,,0)
			n_Count:= 0
			oPrinter:EndPage()
		endIf
	
	QRY->( DbSkip() )
Enddo     



If (n_Count < 51) .and. n_pag == 0
	oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Count)	,o10N,,0)//roda p�
	oPrinter:Say(3317,1884,'P�g.:' + cValToChar(n_pag++),o10N,,0)
EndIf 

If (n_Count < 51) .and. n_pag >= 1 
	f_header (c_Emp,c_CNPJ)
	f_grid(0420)//imprime a grid dos itens   
	oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Count)	,o10N,,0)//roda p�
	oPrinter:Say(3317,1884,'P�g.:' + cValToChar(n_pag+1),o10N,,0)   
EndIf 

DbCloseArea("QRY")

If !Empty(c_Dados) .and. mv_par07 == 2
	If MSGYESNO("Deseja exportar esses dados para um arquivo CSV ?")
	   	f_ExpCSV (c_Dados)
	Endif           
Endif

return
/*
�������������������������������������������������������������������������ͻ��
���Selecionar dados para exibi��o										   ��
�������������������������������������������������������������������������͹��
*/
Static Function f_Seldados()

Local cQuery := ""
Local _cSRA := retsqlname("SRA")
Local _cSR8 := retsqlname("SR8")
Local _cSQB := retsqlname("SQB")
Local _cTMR := retsqlname("TMR")
Local _cSRJ := retsqlname("SRJ")

cQuery += " SELECT  "
cQuery += " RA.RA_MAT AS MATRICULA, "
cQuery += " RA.RA_NOME AS NOME, "
cQuery += " RA.RA_ADMISSA AS DATA_ADMISSAO, "
cQuery += " RA.RA_TNOTRAB AS TURNO, "
cQuery += " (SELECT RTRIM(QB.QB_DESCRIC) FROM "+_cSQB+" QB WHERE QB.QB_FILIAL ='"+xFilial("SQB")+"' AND QB.D_E_L_E_T_<> '*'  AND QB.QB_DEPTO = RA.RA_DEPTO) AS DEPARTAMENTO, "
cQuery += " R8_DATA AS DATA,  "
cQuery += " R8_TIPO,  "
cQuery += " R8_DATAINI, " 
cQuery += " R8_DATAFIM, "
cQuery += " R8_DURACAO, "
cQuery += " R8_CID,  "
cQuery += " ISNULL((SELECT RTRIM(TMR_DOENCA) FROM "+_cTMR+" TMR WHERE TMR_FILIAL ='"+xFilial("TMR")+"' AND TMR.D_E_L_E_T_<> '*'  AND TMR.TMR_CID = R8.R8_CID),' ') AS DESCRICAO_CID, "
cQuery += " R8_TPEFD, "
cQuery += " ISNULL((SELECT RTRIM(RJ_DESC) FROM "+_cSRJ+"  RJ WHERE RJ_FILIAL ='"+xFilial("SRJ")+"' AND RJ.D_E_L_E_T_<> '*'  AND RJ.RJ_FUNCAO = RA.RA_CODFUNC),' ') AS FUNCAO "
cQuery += " FROM "+_cSR8+" R8, "+_cSRA+" RA "
cQuery += " WHERE "
cQuery += " R8.R8_FILIAL ='"+xFilial("SR8")+"' "
cQuery += " AND RA.RA_FILIAL ='"+xFilial("SRA")+"' "
cQuery += " AND RA.D_E_L_E_T_ <> '*' "
cQuery += " AND R8.D_E_L_E_T_ <> '*' "
cQuery += " AND RA.RA_MAT = R8.R8_MAT "
cQuery += " AND RA.RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND RA.RA_DEPTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND R8_TIPO = 'P' "
cQuery += " AND R8_TPEFD = '03' "
cQuery += " AND R8_DATAINI <> '' "
cQuery += " AND R8_DATAFIM <> '' "
cQuery += " AND R8_DATAFIM >= '"+dtos(MV_PAR05)+"'


If Select("QRY") <> 0
	DBSelectArea("QRY")
	DBCLOSEAREA("QRY")
Endif 

TCQUERY cQuery NEW ALIAS "QRY"


Return
        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � f_ExpCSV � Autor � TBA001 -XXX      � Data �    Julho/2011 ���
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

Static Function f_ExpCSV(c_Dados)
	Local c_Dir     := cGetFile( '*.*' , '', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY, GETF_LOCALHARD, GETF_NETWORKDRIVE), .F., .T. )
	Local c_File    := "AFASTAMENTOS"+"_" + DTOS(DDATABASE) + "_" + SUBSTR(STRTRAN(TIME(),":"),1,6) + ".CSV"
	Local c_Linha   := ""

	If !Empty(c_Dir)
		c_Destino := FCREATE(c_Dir + c_File)

		// TESTA A CRIA��O DO ARQUIVO DE DESTINO
		IF c_Destino == -1
			MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
		 	RETURN
		ENDIF  
		
				
		c_Titulo  := ";"+c_Texto+";;;;;;;;" +CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Titulo,LEN(c_Titulo)) != LEN(c_Titulo)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF
		
		c_Titulo  := ";Emiss�o:"+DTOC(dDataBase)+";;;;;;;;;" +CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Titulo,LEN(c_Titulo)) != LEN(c_Titulo)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF

		
		c_Header  := "MATR�CULA;NOME;D.ADMISS�O;FUN��O;DEPARTAMENTO;DATA;Dt.INI;Dt.FIM;DIAS NO PER�ODO;DIAS DO ATESTADO;C.I.D;DESCRI��O DO C.I.D;PLANO DE SA�DE;"+a_Mes03[1][2]+";"+a_Mes02[1][2]+";"+a_Mes01[1][2]+";"
	
		c_Linha:= c_Header+CHR(13)+CHR(10)
	
		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF
	
		c_Linha:= c_Dados

		IF FWRITE(c_Destino,c_Dados,LEN(c_Dados)) != LEN(c_Dados)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF
	
		AVISO(SM0->M0_NOMECOM,"Arquivo exportado para " + c_Dir + c_File,{"Ok"},2,"Aten��o")
		FCLOSE(c_Destino)
	Endif
Return 


Return c_Ret   

Static Function f_PlanoSaude(p_Mat)
Local cQuery := ""  
Local c_Periodo := "" 
Local lRet  := .F.   
Local _cRHK 	   := retsqlname("RHK ") 

c_Periodo := SUBSTR(DTOS(MV_PAR06),5,2)+SUBSTR(DTOS(MV_PAR06),1,4)

cQuery += " SELECT R_E_C_N_O_ FROM "+_cRHK+" WHERE RHK_FILIAL ='"+xFilial("RHK")+"' AND D_E_L_E_T_ <> '*' AND RHK_MAT = '"+p_Mat+"' AND RHK_PERINI <= '"+c_Periodo+"' AND (RHK_PERFIM = '      ' OR RHK_PERFIM>='"+c_Periodo+"') "

If Select("QRY3") <> 0
	DBSelectArea("QRY3")
	DBCLOSEAREA("QRY3")
Endif 

TCQUERY cQuery NEW ALIAS "QRY3"

DbSelectArea("QRY3")
DbGoTop()    

If QRY3->(!EOF())
    lRet := .T.     
EndIf

DbCloseArea("QRY3")

Return lRet


Static Function f_MesAnterior(nMes,c_Mat)
Local d_MesIniPer  
Local d_MesFimPer  
Local l_Ret 	   := .F.   
Local c_DiaIni     := "16"
Local c_DiaFim     := "15" 
Local c_MesIni     := ""
Local c_MesFim     := ""
Local c_AnoIni     := ""
Local c_AnoFim     := ""  
Local cQuery 	   := ""
Local _cSRA 	   := retsqlname("SRA")
Local _cSR8 	   := retsqlname("SR8")
Local _cSQB 	   := retsqlname("SQB")
Local _cTMR 	   := retsqlname("TMR")
Local _cSRJ 	   := retsqlname("SRJ") 
Local d_DataInicio	
Local d_DataFim		
Local d_DataTmp 
Local c_NomeMes := "          "	
Local a_Ret := {}

Do Case
	Case Month2Str(MV_PAR06) == "01"
			Do Case
				Case nMes == 1
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := strzero(Year(MV_PAR06)-1,4)
					c_MesIni := "11"
					c_MesFim := "12"
				Case nMes == 2
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := strzero(Year(MV_PAR06)-1,4)
					c_MesIni := "10"
					c_MesFim := "11"
				Case nMes == 3    
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := strzero(Year(MV_PAR06)-1,4)
					c_MesIni := "09"
					c_MesFim := "10"
			EndCase
	Case Month2Str(MV_PAR06) == "02"
			Do Case
				Case nMes == 1
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := Year2Str(MV_PAR06)
					c_MesIni := "12"
					c_MesFim := "01"
				Case nMes == 2
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := strzero(Year(MV_PAR06)-1,4)
					c_MesIni := "11"
					c_MesFim := "12"
				Case nMes == 3    
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := strzero(Year(MV_PAR06)-1,4)
					c_MesIni := "10"
					c_MesFim := "11"
			EndCase
	Case Month2Str(MV_PAR06) == "03"
			Do Case
				Case nMes == 1
					c_AnoIni := Year2Str(MV_PAR06)
					c_AnoFim := Year2Str(MV_PAR06)
					c_MesIni := "01"
					c_MesFim := "02"
				Case nMes == 2
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := Year2Str(MV_PAR06)
					c_MesIni := "12"
					c_MesFim := "01"
				Case nMes == 3    
					c_AnoIni := strzero(Year(MV_PAR06)-1,4)
					c_AnoFim := strzero(Year(MV_PAR06)-1,4)
					c_MesIni := "11"
					c_MesFim := "12"
			EndCase			
	OtherWise
			Do Case
				Case nMes == 1
					c_AnoIni := Year2Str(MV_PAR06)
					c_AnoFim := Year2Str(MV_PAR06)
					c_MesIni := strzero(Month(MV_PAR05)-1,2)
					c_MesFim := Month2Str(MV_PAR05)
				Case nMes == 2
					c_AnoIni := Year2Str(MV_PAR06)
					c_AnoFim := Year2Str(MV_PAR06)
					c_MesIni := strzero(Month(MV_PAR05)-2,2)
					c_MesFim := strzero(Month(MV_PAR05)-1,2)
				Case nMes == 3    
					c_AnoIni := Year2Str(MV_PAR06)
					c_AnoFim := Year2Str(MV_PAR06)
					c_MesIni := strzero(Month(MV_PAR05)-3,2)
					c_MesFim := strzero(Month(MV_PAR05)-2,2)
			EndCase
EndCase

d_MesIniPer := stod(c_AnoIni+c_MesIni+c_DiaIni)
d_MesFimPer := stod(c_AnoFim+c_MesFim+c_DiaFim)  

c_NomeMes := MesExtenso(c_MesFim)

//Alert( dtoc(d_MesIniPer)+"......"+dtoc(d_MesFimPer) )


cQuery += " SELECT  "
cQuery += " RA.RA_MAT AS MATRICULA, "
cQuery += " RA.RA_NOME AS NOME, "
cQuery += " RA.RA_ADMISSA AS DATA_ADMISSAO, "
cQuery += " (SELECT RTRIM(QB.QB_DESCRIC) FROM "+_cSQB+" QB WHERE QB.QB_FILIAL ='"+xFilial("SQB")+"' AND QB.D_E_L_E_T_<> '*'  AND QB.QB_DEPTO = RA.RA_DEPTO) AS DEPARTAMENTO, "
cQuery += " R8_DATA AS DATA,  "
cQuery += " R8_TIPO,  "
cQuery += " R8_DATAINI, " 
cQuery += " R8_DATAFIM, "
cQuery += " R8_DURACAO, "
cQuery += " R8_CID,  "
cQuery += " ISNULL((SELECT RTRIM(TMR_DOENCA) FROM "+_cTMR+" TMR WHERE TMR_FILIAL ='"+xFilial("TMR")+"' AND TMR.D_E_L_E_T_<> '*'  AND TMR.TMR_CID = R8.R8_CID),' ') AS DESCRICAO_CID, "
cQuery += " R8_TPEFD, "
cQuery += " ISNULL((SELECT RTRIM(RJ_DESC) FROM "+_cSRJ+"  RJ WHERE RJ_FILIAL ='"+xFilial("SRJ")+"' AND RJ.D_E_L_E_T_<> '*'  AND RJ.RJ_FUNCAO = RA.RA_CODFUNC),' ') AS FUNCAO "
cQuery += " FROM "+_cSR8+" R8, "+_cSRA+" RA "
cQuery += " WHERE "
cQuery += " R8.R8_FILIAL ='"+xFilial("SR8")+"' "
cQuery += " AND RA.RA_FILIAL ='"+xFilial("SRA")+"' "
cQuery += " AND RA.D_E_L_E_T_ <> '*' "
cQuery += " AND R8.D_E_L_E_T_ <> '*' "
cQuery += " AND RA.RA_MAT = R8.R8_MAT "
cQuery += " AND RA.RA_MAT BETWEEN '"+c_Mat+"' AND '"+c_Mat+"'"
cQuery += " AND R8_TIPO = 'P' "
cQuery += " AND R8_TPEFD = '03' "
cQuery += " AND R8_DATAINI <> '' "
cQuery += " AND R8_DATAFIM <> '' "
//cQuery += " AND R8_DATAFIM >= '"+dtos(d_MesIniPer)+"'


If Select("QRY2") <> 0
	DBSelectArea("QRY2")
	DBCLOSEAREA("QRY2")
Endif 

TCQUERY cQuery NEW ALIAS "QRY2"

DbSelectArea("QRY2")
DbGoTop()  


While QRY2->( !Eof() ) 

		d_DataInicio	:=	StoD(QRY2->R8_DATAINI)
		d_DataFim		:=	StoD(QRY2->R8_DATAFIM)
		d_DataTmp 		:= 	StoD(QRY2->R8_DATAINI)

		While d_DataTmp <= d_DataFim      
			
			  If d_DataTmp >= d_MesIniPer .and. d_DataTmp <= d_MesFimPer
					 l_Ret := .T.
					 Exit			  	 
			  EndIf
			
			d_DataTmp:= d_DataTmp+1
			
		EndDo  

	QRY2->( DbSkip() )
EndDo 
DbCloseArea("QRY2")

aadd(a_Ret,{l_Ret,UPPER(c_NomeMes)})

Return a_Ret  

Static Function  f_TrbSabado(p_Turno)
Local l_Ret  := .F. 
Local _cSPJ  := retsqlname("SPJ") 
Local cQuery := ""

cQuery += " SELECT * FROM "+_cSPJ+" WHERE PJ_FILIAL ='"+xFilial("SPJ")+"' AND PJ_DIA = '7' AND PJ_TPDIA = 'S' AND PJ_TURNO = '"+p_Turno+"' AND D_E_L_E_T_ <> '*' " 

If Select("QRY4") <> 0
	DBSelectArea("QRY4")
	DBCLOSEAREA("QRY4")
Endif 

TCQUERY cQuery NEW ALIAS "QRY4"

DbSelectArea("QRY4")
DbGoTop()    

If QRY4->(!EOF())
    lRet := .T.     
EndIf

DbCloseArea("QRY4")



Return l_Ret


Static Function f_ValidPerg(p_Perg)
//funciando com o parte de ser quarta-feira
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para par�metros                        �
//� mv_par01            // Cliente de                           �
//� mv_par02            // Cliente ate                          �
//� mv_par03            // Loja de                              �
//� mv_par04            // Loja at�                             �
//� mv_par05            // Data de Faturamento                  �
//� mv_par06            // Data de Faturamento                  �
//� mv_par07            // Produto de                           �
//� mv_par08            // Produto ate                          �
//� mv_par09            // Junta Periodo                        �
//��������������������������������������������������������������/

//-->> Compatibiliza o SX1 com novas perguntas
cAlias:=Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := p_Perg
cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )
aRegs:={}

//-->> Novo grupo de perguntas
aAdd(aRegs,{cPerg,"01","Matricula de       ?","","","MV_CH1","C",6,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
aAdd(aRegs,{cPerg,"02","Matricula ate      ?","","","MV_CH2","C",6,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
aAdd(aRegs,{cPerg,"03","Departamento de    ?","","","MV_CH3","C",9,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SQB"})
aAdd(aRegs,{cPerg,"04","Departamento at�   ?","","","MV_CH4","C",9,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SQB"})
aAdd(aRegs,{cPerg,"05","Dt. Apura��o de    ?","","","MV_CH5","D",8,0,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Dt. Apura��o ate   ?","","","MV_CH6","D",8,0,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Exporta CSV.       ?","","","MV_CH7","C",1,0,1, "C","","MV_PAR07","N�o","","","","","Sim","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DBSELECTAREA( cAlias)

RETURN  

