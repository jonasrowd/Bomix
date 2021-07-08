#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"    



User Function FGPER003()

Local c_Perg		:= "FGPER003"
Private o_Telas	:= clsTelasGen():New()
Private l_Opcao	:= o_Telas:mtdParOkCan("Rela��o de Demitidos","Esta rotina tem a finaldade de", "imprimir a rela��o de demitidos", "Desenvolvido pela Totvs Bahia","FGPER003")

If l_Opcao
	
	If !Pergunte(c_Perg,.T.)
		Return()
	Endif
	
	f_RelatPadrao()
	
Else
	
	Return()
	
EndIf


Return


Static Function printPage()

	Local            	n_pag 		:=	0
	Local           	n_Count     :=	0
	private    	   		c_Matricula :=	''
	private 			c_Nome		:=	''
	private 			c_Demissa	:=	''
	private 			c_Cargo		:=	''
	private 			c_CartPonto	:=	''
	private     		nI			:=	0
	public 				n_Row		:= 0370
	c_Emp 	:= SM0->M0_NOMECOM
	c_CNPJ := SM0->M0_CGC
	DbSelectArea("SRA")
	SRA->( DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA") ))
    dbGoTop()     

	If SRA->( Eof() )
		Aviso("Aten��o" ,"Funcion�rio n�o encontrado!",{"Ok"},2,"Aten��o")
		Return()
	Endif
	//imprime cabe�alho
	f_header (c_Emp,c_CNPJ)
	While SRA->( !Eof() ) .AND. SRA->RA_FILIAL = xFilial("SRA")    
	
		
		If SRA->RA_DEMISSA >= MV_PAR01 .AND. SRA->RA_DEMISSA <= MV_PAR02    
		
			DbSelectArea("SRJ")
			SRJ->( DbSetOrder(1) )
			dbGoTop()
		
			DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC )
			
			IF Alltrim(SRA->RA_SITFOLH) =="D"
				n_Row := n_Row + 50
				c_Matricula	:=	 SRA->RA_MAT
				c_Nome		    :=	 SRA->RA_NOME
				c_Demissa		:=	 SRA->RA_DEMISSA
				c_Cargo	      	:=  SRJ->RJ_DESC
				c_CartPonto  	:=  SRA->RA_CRACHA
	
				f_grid(n_Row)//imprime a grid dos itens
	
				oPrinter:Say(n_Row + 16,0109,c_Matricula,o9N,,0)
				oPrinter:Say(n_Row + 16,0401,SUBSTR(c_Nome,1,40),o9N,,0)
				oPrinter:Say(n_Row + 16,1140,dtoc(c_Demissa),o9N,,0)
				oPrinter:Say(n_Row + 16,1412,SUBSTR(c_Cargo,1,40),o9N,,0)
				oPrinter:Say(n_Row + 16,2046,c_CartPonto,o9N,,0)
				n_Count++
	
				//quebra de p�gina a cada 56 registro
				if (MOD(n_Count, 56) = 0)
					//imprime cabe�alho
					f_header (c_Emp,c_CNPJ)
					oPrinter:Box(0177,0098,0288,2321)
					n_Row := 0442
					n_pag ++
					oPrinter:Say(3357,0084,"Total:"+ cValToChar(n_Count)	,o10N,,0)//roda p�
					oPrinter:Say(3357,1884,'P�g.:' + cValToChar(n_pag),o10N,,0)
					n_Count:= 0
					oPrinter:EndPage()
					//ELSEIF n_Count < 56
					//oPrinter:Say(3357,0084,"Total:"+ cValToChar(n_Count)	,o10N,,0)
					//oPrinter:Say(3357,1884,'P�g.:' + cValToChar(n_pag+1),o10N,,0)
				endIf
			endif  
			
		EndIf
		SRA->( DbSkip() )
	Enddo
return

static Function f_RelatPadrao()
	Private oArial30  	:=	TFont():New("Arial",,30,,.F.,,,,,.F.,.F.)
	Private o11N	:=	TFont():New("",,11,,.T.,,,,,.F.,.F.)
	Private o9N	:=	TFont():New("",,9,,.T.,,,,,.F.,.F.)
	Private o10N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("Rela��o de Demitidos")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()
Return



//--------------------------------------------------------------
/*/{Protheus.doc}  frmR001
Description  tela de op��o de impress�o

@param     xParam Parameter Description
@return    xRet Return Description
@author  - Ivan Amado
@since     04/05/2015
/*/
static function f_header (c_Emp,c_CNPJ)

	oPrinter:Box(0177,0098,0288,2321)
	oPrinter:Box(0177,0098,0288,2321)
	//cabe�alho
	oPrinter:Say(070,2052,'Emiss�o:'   + DTOC(dDataBase),o11N,,0)
	oPrinter:Say(0175,0742,"Rela��o de Demitidos",oArial30,,0)
	oPrinter:Box(0288,0098,0340,1505)
	oPrinter:Box(0288,1505,0340,2321)
	oPrinter:Say(0293,0128,"Empresa :" +      c_Emp,o11N,,0)
	oPrinter:Say(0300,1530,"CNPJ:"     +      c_CNPJ,o9N,,0)
	//box matricula
	oPrinter:Box(0362,0102,0428,0392)
	//box nome
	oPrinter:Box(0362,0392,0428,1132)
	//box demiss�o
	oPrinter:Box(0362,1134,0428,1400)
	//box cargo
	oPrinter:Box(0362,1403,0428,2034)
	//box Cart�o de Ponto
	oPrinter:Box(0362,2034,0428,2319)
	oPrinter:Say(0380,0109,"MATR�CULA",o10N,,0)
	oPrinter:Say(0380,0400,"NOME",o10N,,0)
	oPrinter:Say(0380,1140,"DEMISS�O",o10N,,0)
	oPrinter:Say(0380,1410,"FUNCAO",o10N,,0)
	oPrinter:Say(0380,2040,"CRACH�",o10N,,0)
return

static function f_grid(n_line)

  local  n_altura := n_line + 60
  //  n_line := + 10
   //box matricula
	oPrinter:Box(n_line + 10 ,0102,n_altura,0392)
	//box nome
	oPrinter:Box(n_line + 10,0392,n_altura,1132)
	//box demiss�o
	oPrinter:Box(n_line + 10,1134,n_altura,1400)
	//box cargo
	oPrinter:Box(n_line + 10 ,1403,n_altura,2034)

	//box Cart�o de Ponto
	oPrinter:Box(n_line + 10,2034,n_altura,2319)
return

