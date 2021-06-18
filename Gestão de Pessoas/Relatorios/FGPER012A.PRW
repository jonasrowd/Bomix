#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'SHELL.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TOPCONN.CH"

User Function FGPER012()

	Local c_Perg		:= "FGPER012"
	Private o_Telas	:= clsTelasGen():New()
	Private l_Opcao	:= o_Telas:mtdParOkCan("Acordo Compensacao de Horas","Esta rotina tem a finaldade de", "imprimir Acordo de Compensacao de Horas", "Desenvolvido pela Totvs Bahia","FGPER011")

	If l_Opcao
		If !Pergunte()
			f_ValidPerg(c_Perg)
		EndIf
			f_RelatPadrao()
	Else
		Return()
	EndIf

Return

Static Function f_ValidPerg(c_Perg)

	Local a_PAR01        := {}

	Aadd(a_PAR01, "Informe a matricula")

	//PutSx1(cGrupo,cOrdem,cPergunt,   PerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Matricula Colaborador?   ","","","mv_ch1","C",06,0,0,"G","","SRA","","","mv_PAR01","","","","","","","","","","","","","","","","",a_PAR01)

Return()

static Function f_RelatPadrao()
       
Local cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP"  
cImag001 := cBitmap 
	
	// Private	cImag001	:=	"D:\Sistemas\totvs\Protheus11\Protheus_Data\system\RODAPE.BMP"
	Private o14N			:=	TFont():New("",,14,,.T.,,,,,.F.,.F.)
	Private o10N			:=	TFont():New("",,12,,.F.,,,,,.F.,.F.)
	Private oVerda10N		:=	TFont():New("Verdana",,12,,.F.,,,,,.F.,.F.)
	Private oPrinter  	:=	tAvPrinter():New("ACORDO DE COMPENSAÇÃO DE HORAS")
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	printPage()
	oPrinter:Preview()

Return

Static Function printPage()

	// oPrinter:Box(0044,0046,3257,2403)/*Margem*/


	DbSelectArea("SRA")
	SRA->(DbSetOrder(1) )
	SRA->( DbSeek(xFilial("SRA")+mv_par01))

	If SRA->(Eof() )
		Aviso("Atenção" ,"Funcionário não encontrado!",{"Ok"},2,"Atenção")
		Return()
	Endif

	If SRA->( !Eof() )
	
		c_Nome      := Alltrim(SRA->RA_NOME )
		c_Matricula := Alltrim(SRA->RA_MAT )
		c_Empresa 	:= Alltrim(SM0->M0_NOMECOM )                                                            
		c_Carteira  := Alltrim(SRA->RA_NUMCP) + "-" +  Alltrim(SRA->RA_SERCP) + "-" + Alltrim(SRA->RA_UFCP)
	    c_EndEmpresa:= Alltrim(SM0->M0_ENDCOB)
        c_turno     := SRA->RA_TNOTRAB      
        c_Cidade := Alltrim(SM0->M0_CIDCOB) 
        c_Data   := STRZERO(Day(dDataBase), 2) + " de " + MesExtenso(dDataBase) + " de " + STRZERO(Year(dDataBase), 4)

    
   		oPrinter:Say(0151,0835,"ACORDO DE COMPENSAÇÃO DE HORAS",o14N,,0)  
		oPrinter:Say(0491,0500,"Pelo presente acordo para compensação de jornada de trabalho firmado entre a Empresa: ",o10N,,0)
		oPrinter:Say(0570,0500,c_Empresa + ", estabelecida em: "+ alltrim(c_EndEmpresa) + " com o ramo de Indústria ",o10N,,0)
		oPrinter:Say(0649,0500,"de Embalagens Plásticas,e o (a)funcionário(a)Sr.(a) " + alltrim (c_Nome) +" portador(a)da CTPS/Série:",o10N,,0)
		oPrinter:Say(0728,0500,c_Carteira,o10N,,0)
		oPrinter:Say(0807,0500,",fica convencionado o que o horario normal de trabalho sera o seguinte para",o10N,,0)
		oPrinter:Say(0886,0500,"compensação de horas nao trabalhadas nos dias de Sabado:",o10N,,0)                        
		oPrinter:Say(0965,0500,"DIAS DA SEMANA        DE      AS                 DE           AS ",o10N,,0)
	    LIN = 1035
    
		DbSelectArea("SPJ")
	    SPJ->(DbSetOrder(1))
	    dbgotop()
	    dbSeek(xFilial("SPJ")+c_turno)
		If Found()
	    	                   
		        
		   MDIA = " "
	       do While .t. 
	         
	          if SPJ->PJ_TURNO <> c_turno 
	             exit
	          endif   
	             
		      if SPJ->PJ_dia = "1"
		         mdia = "Segunda-Feira"
		      endif    
		      if SPJ->PJ_dia = "2"
		         mdia = "Terca-Feira"
		      endif
	          if SPJ->PJ_dia = "3"
		         mdia = "Quarta-Feira"
		      endif
		      if SPJ->PJ_dia = "4"
		         mdia = "Quinta-Feira"
		      endif
		      if SPJ->PJ_dia = "5"
		         mdia = "Sexta-Feira"
		      endif
		      if SPJ->PJ_dia = "6"
		         mdia = "Sabado"
		      endif 
		      if SPJ->PJ_dia = "7"
		         mdia = "Domingo"
		      endif
		                
		   
		      oPrinter:Say(LIN,0500,mdia,o10N,,0)
		      oPrinter:Say(LIN,0800,str(SPJ->PJ_ENTRA1,5,2),o10N,,0)
		      oPrinter:Say(LIN,0900,str(SPJ->PJ_SAIDA1,5,2),o10N,,0)
		      oPrinter:Say(LIN,01100,str(SPJ->PJ_ENTRA2,5,2),o10N,,0)
		      oPrinter:Say(LIN,01250,str(SPJ->PJ_SAIDA2,5,2),o10N,,0)                     
		      LIN = LIN + 60
		      dbskip()
		   enddo
		ELSE   
		   alert("TURNO NÃO ENCONTRADO")
		ENDIF         
		LIN = LIN + 60   
		oPrinter:Say(LIN,01000,"TOTAL DE HORAS SEMANAIS 44:00" ,o10N,,0) 
	    
	 
	          LIN = LIN + 200
			  oPrinter:Say(lin,1000,c_Cidade +", " + c_Data ,o10N,,0)
		      LIN = LIN + 100
		      oPrinter:Say(LIN,01000,"__________________________________________________" ,o10N,,0)        
		      LIN = LIN + 50
		      oPrinter:Say(LIN,01000,C_EMPRESA,o10N,,0) 
		      LIN = LIN + 100 
		      oPrinter:Say(LIN,01000,"__________________________________________________" ,o10N,,0)        
		      LIN = LIN + 50
		      oPrinter:Say(LIN,01000,C_MATRICULA+" - "+C_NOME,o10N,,0) 
		       
	
	endif	             
DbSelectArea("SRA") 
		
		
		
		
		
		

Return








