#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ BXGTZO     ºAutor ³TBA001 -XXX     º Data ³  04/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho de Preenchimento do campo Z0_GRUPO - Bomix.	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BXGTZO			                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
//EXECBLOCK("BXGTZO")
User Function BXGTZO  


Local c_Ret   		 := ""
Local c_TipoProduto  := ""
Local c_Tamanho 	 := ""
Local c_Formato      := "" 
Local D_TipoProduto  := trim(REPLACE(M->ZO_TPPROD ,"*",""))
Local D_DTamanho 	 := trim(REPLACE(M->ZO_TAMANHO,"*",""))
Local D_Formato      := trim(REPLACE(M->ZO_FORMATO,"*",""))
Local nX := 0

                                    
If !Empty(D_TipoProduto) 
	c_TipoProduto += "("
	For nX:=1 to len(D_TipoProduto)
		_TipoDescri   := TRIM(POSICIONE("SX5",1,xFilial("SX5")+"XT"+Substr(D_TipoProduto,nX,2),"X5_DESCRI"))
		c_TipoProduto += IIF(!EMPTY(_TipoDescri), _TipoDescri  +  " / ","")
		nx=nX+2
	Next 
	c_TipoProduto := substr(c_TipoProduto,1,len(c_TipoProduto)-3)
	c_TipoProduto += ")"
EndIf  

If !Empty(D_DTamanho) 
	c_Tamanho += "("
	For nX:=1 to len(D_DTamanho)
	    _TamanhoDescri := TRIM(POSICIONE("SX5",1,xFilial("SX5")+"XM"+Substr(D_DTamanho,nX,2),"X5_DESCRI")) 
		c_Tamanho +=  IIF(!EMPTY(_TamanhoDescri), _TamanhoDescri  +  " / ","")
		nx=nX+2
	Next
	c_Tamanho := substr(c_Tamanho,1,len(c_Tamanho)-3)
	c_Tamanho += ")"
EndIf 
  
If !Empty(D_Formato) 
	c_Formato += "("
	For nX:=1 to len(D_Formato)  
		_FormatoDescri:= TRIM(POSICIONE("SX5",1,xFilial("SX5")+"XF"+Substr(D_Formato,nX,2),"X5_DESCRI"))
		c_Formato += IIF(!EMPTY(_FormatoDescri), _FormatoDescri  +  " / ","")
		nx=nX+2
	Next
	c_Formato := substr(c_Formato,1,len(c_Formato)-3)
	c_Formato += ")"
EndIf                                                    

 
If !Empty(c_TipoProduto) .or. !Empty(c_Tamanho) .or. !Empty(c_Formato) 
	c_Ret := c_TipoProduto+ " " +c_Tamanho+ " "+c_Formato
Endif


Return c_Ret