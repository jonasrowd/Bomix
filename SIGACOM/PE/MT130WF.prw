/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++Programa  MT130WF   Autor  Anilson Lima    Data   JULHO/2011            ++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++          Este ponto de entrada tem o objetivo de permitir a customiza  ++
++          cao de workflow baseado nas informacoes de cotacoes que       ++
++          estao sendo geradas pela rotina em execução.                  ++
++          Executado após atualização de arquivos na geracao de cotacoes ++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function MT130WF()
Local a_Area	:= GetArea()
Local c_NumCot	:= ParamIxb[1]
LOcal c_NumSC	:= SC1->C1_NUM
Local l_Ret 	:= Findfunction("U_PCOMA008")

If l_Ret .And. !Empty(c_NumCot) 
	//Diligenciamento
	U_PCOMA008(c_NumCot, c_NumSC) //CHAMA O FONTE PARA ENVIAR O EMAIL PARA O SOLICITANTE.
Endif

l_Ret 	:= Findfunction("U_FCOMA004")
If l_Ret .And. !Empty(c_NumCot) 
	//Integração Fluig
	U_FCOMA004( c_NumCot )
	
Endif

U_COM_RT03() //Código existente na bomix

RestArea(a_Area)


Return()
