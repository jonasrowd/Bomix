/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK     º Autor ³ AP6 IDE            º Data ³  28/09/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação do Item do Pedido de Venda                       º±±
±±º          ³ Este ponto de entrada é executado na mudança de linha do   º±±
±±º          ³ pedido de venda. Ele pode ser utilizado para validação.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M410LIOK 




	Local c_Produto := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
	Local c_Local   := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_LOCAL' })]
	Local a_Area    := GetArea()
	Local c_Prefixo := IIF(cFilAnt == "010101", "ABT", "ABST")
	Local l_Ret     := .T.

//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   Return(l_Ret)
endif

////////




	If INCLUI .Or. ALTERA
	
			If aCols[n][Len( aHeader )+1] .AND. !Empty(Rtrim(aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_NUMOP' })]))
				ShowHelpDlg(SM0->M0_NOME,;
				{"Produto não pode ser deletado, pois existe OP para o mesmo."},5,;
				{"Contacte o setor responsável."},5)
				Return .F.
			Endif			
	
	
	
	   	If aCols[n][Len( aHeader )+1] == .F.
			dbSelectArea("SZ7")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
				If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
					l_Ret := .T.
				Else
					l_Ret := .F.
				Endif
			Else
				l_Ret := .F.
			Endif              

			If l_Ret .And. Substr(c_Produto, 1, 1) $ c_Prefixo
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1") + c_Produto)
					If SB1->B1_PESO == 0
						If SB1->B1_TIPO == "SU" .And. cFilAnt == "020101"
							RestArea(a_Area)
							Return .T.
						Endif

						ShowHelpDlg(SM0->M0_NOME,;
						{"Cadastro do Produto " + AllTrim(c_Produto)  + " foi efetuado sem o preenchimento da informação de Peso Líquido."},5,;
						{"Contacte o responsável pelo cadastro de produtos e solicite o preenchimento do campo Peso Líquido."},5)
						RestArea(a_Area)
						Return .F.
					Endif
				Endif
            Endif
		Endif
	Endif

	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME,;
		{"O seu usuário não possui permissão para efetuar saídas no armazém " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif

	RestArea(a_Area)




Return l_Ret
