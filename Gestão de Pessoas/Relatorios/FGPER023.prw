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
���Fun��o    � FGPER023	  �Autor �01-REGIS&CIA	     � Data �  10/03/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de Faltas										  ���
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

User Function FGPER023()

Local c_Perg	:= "FGPER023"
Local c_Dados   := ""    
Public c_Texto   := "Falta(s) ou Suspens�o(�es) "
Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan(c_Texto,"Esta rotina tem a finaldade de", "imprimir as "+c_Texto, "Desenvolvido pela TI da Bomix","FGPER023")

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

//Cabe�alho
oPrinter:Say(070,2052,'Emiss�o:'   + DTOC(dDataBase),o11N,,0)
oPrinter:Say(0175,0742,c_Texto ,oArial30,,0)
oPrinter:Box(0288,0098,0340,1505)
oPrinter:Box(0288,1505,0340,2321)
oPrinter:Say(0293,0128,"Empresa :" +      c_Emp,o11N,,0)
oPrinter:Say(0300,1530,"CNPJ:"     +      TRANSFORM(c_CNPJ,"@R 99.999.999/9999-99"),o9N,,0)

//box Matr�cula
oPrinter:Box(0362,0102,0428,0292)
//box Nome
oPrinter:Box(0362,0292,0428,1050)
//box Situa��o Folha
oPrinter:Box(0362,1050,0428,1300)
//box Departamento
oPrinter:Box(0362,1300,0428,1670)

//box datas
oPrinter:Box(0362,1670,0428,1790)
oPrinter:Box(0362,1790,0428,1900)
oPrinter:Box(0362,1900,0428,2320)

oPrinter:Say(0380,0109,"MATR�CULA",o8N,,0)
oPrinter:Say(0380,0300,"NOME",o8N,,0)
oPrinter:Say(0380,1055,"S.FOLHA",o8N,,0)
oPrinter:Say(0380,1305,"DEPARTAMENTO",o8N,,0)

oPrinter:Say(0380,1675,"DATA",o8N,,0)
oPrinter:Say(0380,1795,"EVENTO",o8N,,0)
oPrinter:Say(0380,1905,"ABONO",o8N,,0)

Return

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
oPrinter:Box(n_line + 10,1900,n_altura,2320)

return


/*
�������������������������������������������������������������������������ͻ��
���Imprimir os Dados											   ��
�������������������������������������������������������������������������͹��
*/
Static Function printPage()

Local    n_pag 			:=	0
Local    n_Count     	:=	0 
Local    n_Func     	:=	0
Local 	 n_Dias			:=  0
Local    n_TotFaltas    :=  0

Private  c_Matricula  	:=	''
Private  c_Nome			:=	''
Private  c_SFolha		:=	''
Private  c_Departamento	:=	''
Private  d_Data			:=	''
Private  c_Abono		:=	''
Private  c_DescAbono	:=	''
Private  c_CCusto		:=	'' 
Private  c_DescFolha    :=  ''

Private  nI				:=	0
Public 	 n_Row			:= 0370  
  


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
             
		While QRY->MATRICULA  == c_Matricula

		c_Matricula		:= QRY->MATRICULA
		c_Nome		    := QRY->NOME      
		c_SFolha		:= QRY->SITUACAO_FOLHA
		c_Departamento	:= QRY->DEPARTAMENTO
		d_Data			:= DTOC(STOD(QRY->DATA))
		c_Abono			:= QRY->MOTIVO_ABONO
		c_DescAbono		:= QRY->DESC_MOT_ABONO
		c_CCusto		:= QRY->DESC_CCUSTO 
		c_DescFolha		:= " "    
		
		n_Dias		  	:= 0 
		
		
		If n_Dias > 1
			n_Dias+=1		
		EndIf 	
		 
		n_Row := n_Row + 50
		
		f_grid(n_Row)//imprime a grid dos itens   
		
		
		Do Case
		   case c_SFolha == 'D'
		   		c_DescFolha := "DEMITIDO"
		   case c_SFolha == 'A'
		   		c_DescFolha := "AFASTADO"			
		   case c_SFolha == 'F'
		   		c_DescFolha := "F�RIAS"
		   case c_SFolha == 'T'
		   		c_DescFolha := "TRANSFERIDO"		   		
		   OtherWise
		        c_DescFolha := " " 		   		
        EndCase
		
		
		oPrinter:Say(n_Row + 16,0109,Transform(c_Matricula,"@! 999999"),o9N,,0)
		oPrinter:Say(n_Row + 16,0301,SUBSTR(c_Nome,1,40),o9N,,0)
		oPrinter:Say(n_Row + 16,1055,c_DescFolha,o9N,,0)
		oPrinter:Say(n_Row + 16,1310,SUBSTR(c_Departamento,1,21),o9N,,0)
		oPrinter:Say(n_Row + 16,1675,d_Data,o9N,,0)
		oPrinter:Say(n_Row + 16,1795,c_Abono,o9N,,0)
		oPrinter:Say(n_Row + 16,1905,c_DescAbono,o9N,,0)

		c_Dados += c_Matricula+";"+;
					SUBSTR(c_Nome,1,40)+";"+;
					c_DescFolha+";"+;
					SUBSTR(QRY->FUNCAO,1,40)+";"+;
					SUBSTR(c_Departamento,1,40)+";"+;
					d_Data+";"+;
					c_Abono+";"+;
					c_DescAbono+";"+;
					TRIM(c_CCusto)+CHR(13)+CHR(10)
		
		n_Count  ++ 
		n_Func   ++ 
		
		if (n_Count >= 52)
			//imprime cabe�alho
			f_header (c_Emp,c_CNPJ)
			n_Row := 0370 
			f_grid(0420)//imprime a grid dos itens  			
			n_pag ++
			oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Func)	,o10N,,0)//roda p�
			oPrinter:Say(3317,1884,'P�g.:' + cValToChar(n_pag),o10N,,0)
			n_Count:= 0
			n_Func := 0
			oPrinter:EndPage()
		endIf 
		
		n_TotFaltas ++
		
		QRY->( DbSkip() )
		
     Enddo 
     
     
    n_Row 	:= n_Row + 50
    
	oPrinter:Say(n_Row + 22,0109,"Total ------>",o9N,,0)
	oPrinter:Say(n_Row + 22,0301,Transform(n_TotFaltas,"@E# 9999"),o9N,,0)
     
    c_Dados += "Total ("+c_Nome+");"+Transform(n_TotFaltas,"@E# 9999")+";;;;;;;"+CHR(13)+CHR(10)

   	n_Count		:= 	n_Count +1 

	n_TotFaltas := 0    

	//quebra de p�gina a cada 52 registro

	iF (n_Count >= 51)
		//imprime cabe�alho
		f_header (c_Emp,c_CNPJ)
		f_grid(0420)//imprime a grid dos itens  
		n_Row := 0370
		n_pag ++
		oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Func)	,o10N,,0)//roda p�
		oPrinter:Say(3317,1884,'P�g.:' + cValToChar(n_pag),o10N,,0)
		n_Count:= 0 
		n_Func := 0
		oPrinter:EndPage()
	endIf 

Enddo  

If (n_Count < 51) .and. n_pag == 0
	oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Func)	,o10N,,0)//roda p�
	oPrinter:Say(3317,1884,'P�g.:' + cValToChar(n_pag++),o10N,,0)
EndIf 

If (n_Count < 51) .and. n_pag >= 1 
	f_header (c_Emp,c_CNPJ)
	f_grid(0420)//imprime a grid dos itens   
	oPrinter:Say(3317,0084,"Total:"+ cValToChar(n_Func)	,o10N,,0)//roda p�
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
Local _cSPC := retsqlname("SPC")
Local _cSP6 := retsqlname("SP6")
Local _cSQB := retsqlname("SQB")
Local _cCTT := retsqlname("CTT")
Local _cSRJ := retsqlname("SRJ")

cQuery += " 	SELECT RA_MAT AS MATRICULA, "
cQuery += " 	RA_NOME AS NOME, "
cQuery += " 	ISNULL((SELECT RTRIM(QB.QB_DESCRIC) FROM  "+_cSQB+" QB WHERE QB.QB_FILIAL ='"+xFilial("SQB")+"' AND QB.D_E_L_E_T_<> '*'  AND QB.QB_DEPTO = SRA.RA_DEPTO),' ') AS DEPARTAMENTO ,  "
cQuery += " 	RA_SITFOLH AS SITUACAO_FOLHA,  "
cQuery += " 	PC_DATA AS DATA ,  "
cQuery += " 	PC_PD AS EVENTO,  "
cQuery += " 	PC_ABONO AS MOTIVO_ABONO, "
cQuery += " 	ISNULL((SELECT RTRIM(P6.P6_DESC) FROM  "+_cSP6+" P6 WHERE P6.P6_FILIAL ='"+xFilial("SP6")+"' AND P6.D_E_L_E_T_<> '*'  AND P6.P6_CODIGO = SPC.PC_ABONO),' ') AS DESC_MOT_ABONO ,  "
cQuery += " 	CTT_DESC01 AS DESC_CCUSTO, "
cQuery += " 	CTT_CUSTO AS CENTRO_CUSTO,  "
cQuery += " 	ISNULL((SELECT RTRIM(RJ_DESC) FROM "+_cSRJ+"  RJ WHERE RJ_FILIAL ='"+xFilial("SRJ")+"' AND RJ.D_E_L_E_T_<> '*'  AND RJ.RJ_FUNCAO = SRA.RA_CODFUNC),' ') AS FUNCAO "
cQuery += " 	FROM "+_cSRA+" AS SRA, "+_cSPC+" AS SPC , "+_cCTT+" AS CTT "
cQuery += " 	WHERE  "
cQuery += " 	SPC.PC_FILIAL BETWEEN '"+xFilial("SPC")+"' AND '"+xFilial("SPC")+"' "
cQuery += " 	AND SPC.D_E_L_E_T_ <> '*' "
cQuery += " 	AND SRA.D_E_L_E_T_ <> '*' "
cQuery += " 	AND CTT.D_E_L_E_T_ <> '*' "
cQuery += " 	AND SRA.RA_FILIAL  BETWEEN '"+xFilial("SRA")+"' AND '"+xFilial("SRA")+"' "
cQuery += " 	AND CTT.CTT_FILIAL BETWEEN '"+xFilial("CTT")+"' AND '"+xFilial("CTT")+"' "
cQuery += " 	AND SPC.PC_MAT     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " 	AND SRA.RA_DEPTO   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " 	AND SPC.PC_CC      BETWEEN '         ' AND 'ZZZZZZZZZ' "
cQuery += " 	AND SPC.PC_DATA    BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"'"
cQuery += " 	AND SPC.PC_MAT	  = SRA.RA_MAT "
cQuery += " 	AND CTT.CTT_CUSTO = SPC.PC_CC "
cQuery += " 	AND (SPC.PC_PD = '009' OR SPC.PC_PD = '010') " 

If MV_PAR08 == 2 
	cQuery += " AND PC_ABONO = 	'035' " 
Else
	cQuery += " AND PC_ABONO = '' " 
Endif

cQuery 	   += "	ORDER BY RA_NOME, PC_DATA "

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
	Local c_File    := "FALTAS_SUSPENSOES"+"_" + DTOS(DDATABASE) + "_" + SUBSTR(STRTRAN(TIME(),":"),1,6) + ".CSV"
	Local c_Linha   := ""

	If !Empty(c_Dir)
		c_Destino := FCREATE(c_Dir + c_File)

		// TESTA A CRIA��O DO ARQUIVO DE DESTINO
		IF c_Destino == -1
			MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
		 	RETURN
		ENDIF  
		
				
		c_Titulo  := ";"+c_Texto+";;;;;;" +CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Titulo,LEN(c_Titulo)) != LEN(c_Titulo)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF
		
		c_Titulo  := ";Emiss�o:"+DTOC(dDataBase)+";;;;;;" +CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Titulo,LEN(c_Titulo)) != LEN(c_Titulo)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF

		
		c_Header  := "MATR�CULA;NOME;S.FOLHA;FUN��O;DEPARTAMENTO;DATA;MOTIVO ABONO;ABONO;C.CUSTO;"
	
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
aAdd(aRegs,{cPerg,"08","Tipo 		 	   ?","","","MV_CH8","C",1,0,1, "C","","MV_PAR08","Faltas","","","","","Suspens�o","","","","","","","","","","","","","","","","","","",""})

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


