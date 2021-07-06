#Include "Totvs.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} FFATC001
   Retorna a descrição do produto na consulta padrão customizada SA7FS como SA7FS1.
   @type Function
   @author  Christian Rocha
   @since   10/05/2017 08:49
   @version 12.1.25
   @return character, descrição do produto.
   @history 06/07/2021, Jonas Machado, Realizado a documentação da user function e homologada como a mais atual.
/*/
//-------------------------------------------------------------------
User Function FFATC001(c_Produto) 

	Local c_Desc := Posicione("SB1", 1, xFilial("SB1") + c_Produto, "B1_DESC")

//testa filial atual
/*
private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return
endif
*/
////////


Return c_Desc
