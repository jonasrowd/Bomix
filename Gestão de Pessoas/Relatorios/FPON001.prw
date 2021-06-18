#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"


#DEFINE OLECREATELINK  400
#DEFINE OLECLOSELINK   401
#DEFINE OLEOPENFILE    403
#DEFINE OLESAVEASFILE  405
#DEFINE OLECLOSEFILE   406
#DEFINE OLESETPROPERTY 412
#DEFINE OLEWDVISIBLE   "206"
#DEFINE WDFORMATTEXT   "2"
#DEFINE WDFORMATPDF    "17" // FORMATO PDF
#DEFINE ENTER CHR(10)+CHR(13)
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE       


User Function FPON001()

	Local c_Perg		:= "FPON001"

	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Importação Protheus X DMPREP","Esta rotina tem como obejtivo efetuar a geração de arquivo .TXT", "dos funcionários para integração com o DMPREP. ", "Desenvolvido pela TI - Bomix","FPON001")
	
	f_ValidPerg( "FPON001")

	If l_Opcao
		f_Gera_Arquivo()
	Else
		Return()
	EndIf

Return
/*
000000000000010000014444444444200000015102010Funcionário 0001000001 Analista
1000001 00000000000000000001
001 a 020 – Número do Crachá (será o código de cadastro).
021 a 031 – Número do PIS do funcionário.
032 a 037 – Senha do funcionário (preencher com 000000).
038 a 045 – Data de admissão do funcionário no formato (DDMMYYYY)
046 a 097 – Nome do Funcionário com 52 posições (completar com espaço)
098 a 127 – Função do Funcionário com 30 posições (completar com espaço)
128 a 147 – Número da Credencial utilizada pelo Funcionário. (Campo obrigatório somente se for
selecionado no menu “Arquivo” – “Configurações”, na aba “Config. Gerais” o campo “Utiliza
matrícula diferente da credencial”.
*/  


Static Function f_Gera_Arquivo ()
Local c_Query := " "
Local _cSRA   := retsqlname("SRA") 
Local _cSRJ   := retsqlname("SRJ")
Local c_Func  := ""    

Local c_Matricula := ""
Local c_PIS       := ""
Local c_Senha     := ""
Local c_Admissao  := ""
Local c_Nome	  := ""
Local c_Funcao    := ""


c_Query += " SELECT  ISNULL((SELECT RTRIM(RJ_DESC) FROM "+_cSRJ+"  RJ WHERE RJ_FILIAL ='"+xFilial("SRJ")+"' AND RJ.D_E_L_E_T_<> '*'  AND RJ.RJ_FUNCAO = RA_CODFUNC),' ') AS FUNCAO,* "
c_Query += " FROM  "+_cSRA+" "
c_Query += "  WHERE D_E_L_E_T_ <> '*' AND RA_FILIAL ='"+xFilial("SRA")+"' AND RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "


If Select("QRY") <> 0
	DBSelectArea("QRY")
	DBCLOSEAREA("QRY")
Endif  

TCQUERY c_Query NEW ALIAS "QRY"  

DbSelectArea("QRY")
DbGoTop()  

While QRY->( !Eof() )
                       
	c_Matricula := STRZERO(VAL(QRY->RA_MAT),20)
	c_PIS       := TRIM(QRY->RA_PIS)
	c_Senha     := "000000"
	c_Admissao  := SUBSTR(QRY->RA_ADMISSA,7,2)+SUBSTR(QRY->RA_ADMISSA,5,2)+SUBSTR(QRY->RA_ADMISSA,1,4) //YYYYMMDD
	c_Nome	    := IIF(LEN(TRIM(QRY->RA_NOME)) >= 52, SUBSTR(TRIM(QRY->RA_NOME),1,52), TRIM(QRY->RA_NOME)+SPACE(52-LEN(TRIM(QRY->RA_NOME))))
	c_Funcao    := IIF(LEN(TRIM(QRY->FUNCAO))  >= 30, SUBSTR(TRIM(QRY->FUNCAO),1,30), TRIM(QRY->FUNCAO)+SPACE(30-LEN(TRIM(QRY->FUNCAO))))

	c_Func += c_Matricula+c_PIS+c_Senha+c_Admissao+c_Nome+c_Funcao+CHR(13)+CHR(10)
		
					
	QRY->( DbSkip() )					
Enddo 

DbCloseArea("QRY")

Grava_Arquivo(c_Func)

Return

Static Function Grava_Arquivo(c_Dados)
	Local c_Dir     := cGetFile( '*.*' , '', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY, GETF_LOCALHARD, GETF_NETWORKDRIVE), .F., .T. )
	Local c_File    := "FUNCIONARIOS"+"_"+MV_PAR01+"_"+MV_PAR02+"_"+DTOS(DDATABASE)+"_"+SUBSTR(STRTRAN(TIME(),":"),1,6)+".TXT"
	Local c_Linha   := ""

	If !Empty(c_Dir)
		c_Destino := FCREATE(c_Dir + c_File)

		// TESTA A CRIAÇÃO DO ARQUIVO DE DESTINO
		IF c_Destino == -1
			MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
		 	RETURN
		ENDIF  
	
		c_Linha:= c_Dados

		IF FWRITE(c_Destino,c_Dados,LEN(c_Dados)) != LEN(c_Dados)
			IF !MSGALERT("Ocorreu um erro na gravação do arquivo destino. Continuar?","Atenção")
				FCLOSE(c_Destino)
	   	   		Return
			ENDIF
	 	ENDIF
	
		AVISO(SM0->M0_NOMECOM,"Arquivo exportado para " + c_Dir + c_File,{"Ok"},2,"Atenção")
		FCLOSE(c_Destino)
	Endif
Return 

Static Function f_ValidPerg(p_Perg)
//funciando com o parte de ser quarta-feira
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01            // Cliente de                           ³
//³ mv_par02            // Cliente ate                          ³
//³ mv_par03            // Loja de                              ³
//³ mv_par04            // Loja até                             ³
//³ mv_par05            // Data de Faturamento                  ³
//³ mv_par06            // Data de Faturamento                  ³
//³ mv_par07            // Produto de                           ³
//³ mv_par08            // Produto ate                          ³
//³ mv_par09            // Junta Periodo                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ/

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