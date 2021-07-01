#include 'Ap5Mail.ch'
#include "rwmake.ch"
#include "protheus.ch"

/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Programa  COM_RT02 Autor  Sandro Santos    Data   Janeiro/2013            ++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Desc.     Funcao generica para envio de e-mail                            ++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function COM_RT02(c_To,c_Body,c_Subj,c_Rotina,l_ExibeTela,cArqSa1)

Local c_Server   	:= GETMV("MV_RELSERV")	//Servidor smtp
Local c_Account  	:= GETMV("MV_RELACNT")	//Conta de e-mail
Local c_Envia    	:= GETMV("MV_RELFROM") 	//Endereco de e-mail
Local c_Password	:= GETMV("MV_RELAPSW")  //Senha da conta de e-mail
Local l_Conectou	:= .T.
Local l_DisConectou	:= .T.
Local l_Enviado		:= .T.
Default	l_ExibeTela := .T.

If c_To == NIL .or. Empty(c_To)
	Aviso(SM0->M0_NOMECOM,"O e-mail nao pode ser enviado, pois o primeiro parametro (DESTINATARIO) nao foi preenchido.",{"Ok"},2,"Erro de envio!")
	Return(.F.)
Endif

//++++++++++++++++++++++++++++++
//Conecta ao servidor de SMTP ++
//++++++++++++++++++++++++++++++
CONNECT SMTP SERVER c_Server ACCOUNT c_Account PASSWORD c_Password Result l_Conectou

//++++++++++++++++++++++++++++++++++++++++++++++++
//Verifica se houve conexao com o servidor SMTP ++
//++++++++++++++++++++++++++++++++++++++++++++++++
If !l_Conectou
	If l_ExibeTela
		Aviso(SM0->M0_NOMECOM,"Erro ao conectar servidor de E-Mail (SMTP) - " + c_Server+CHR(10)+CHR(13)+;
		"Solicite ao Administrador que seja verificado os parametros e senhas do servidor de E-Mail (SMTP)",{"Ok"},3,"Atencao!")
	Endif
	Return(.F.)
Endif

//+++++++++++++++++
//Envia o e-mail ++
//+++++++++++++++++
Alert(cArqSa1)

If cArqSa1='1'
	SEND MAIL FROM c_Envia TO Alltrim(c_To) SUBJECT c_Subj BODY c_Body RESULT l_Enviado
Else
	SEND MAIL FROM c_Envia TO Alltrim(c_To) SUBJECT c_Subj BODY c_Body ATTACHMENT cArqSa1 RESULT l_Enviado
Endif

//+++++++++++++++++++++++++++++++++++++++++++++++++++++
//Verifica possiveis erros durante o envio do e-mail ++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++

If l_Enviado
	If l_ExibeTela
		Aviso(SM0->M0_NOMECOM,"Foi enviado e-mail para "+c_To+" com sucesso!",{"Ok"},3,"Informacao!")
	Endif
Else
	c_Body := ""
	GET MAIL ERROR c_Body

	If l_ExibeTela
		Aviso(SM0->M0_NOMECOM,c_Body,{"Ok"},3,"Atencao!")
	Endif

	Return(.F.)
Endif

//++++++++++++++++++++++++++++++++++
//Desconecta o servidor de SMTP   ++
//++++++++++++++++++++++++++++++++++
DISCONNECT SMTP SERVER RESULT l_DisConectou

Return(.T.)