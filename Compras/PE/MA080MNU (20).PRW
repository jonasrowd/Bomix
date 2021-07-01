/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MA080MNU   ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para copiar a TES						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM - Compras									      º±±
±±Ì          ³ Este ponto de entrada está sendo utilizado para copiar a   ¹±±
±±º          ³ TES													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Private  aRotina:= {}

User Function MA080MNU
	aAdd(aRotina, { "Copia", "U_FCOMA001()", 0, 3} )
Return


User Function FCOMA001
	IF SF4->(EoF())
		ShowHelpDlg("ARQVAZIO", {"Apenas a operação de incluir registros pode ser feita em um arquivo vazio."},5,;
	                   			  {"Não utilize operação diferente da inclusão para um arquivo vazio."},5)
	ELSE
		c_Perg   := "FCOMA001"
		c_Filial := xFilial("SF4")
		c_Chave  := SF4->(F4_FILIAL + F4_CODIGO)

		CriaPerg(c_Perg)

		IF PERGUNTE(c_Perg, .T.)
			DBSELECTAREA("SX3")
			SX3->(DBGOTOP())
			SX3->(DBSETORDER(1))
			SX3->(DBSEEK("SF4"))
			RECLOCK("SF4", .T.)
			SF4->F4_FILIAL := c_Filial
			SF4->F4_CODIGO := MV_PAR01
			WHILE SX3->(!EoF()) .AND. SX3->X3_ARQUIVO == "SF4"
				IF SX3->X3_CONTEXT <> "V" .AND. ALLTRIM(SX3->X3_CAMPO) <> "F4_CODIGO" .AND. ALLTRIM(SX3->X3_CAMPO) <> "F4_FILIAL"
					a_AreaSF4 := SF4->(GetArea())
					c_Valor := Posicione("SF4", 1, c_Chave, SX3->X3_CAMPO)
					RestArea(a_AreaSF4)
	
					SF4->&(SX3->X3_CAMPO) := c_Valor
				ENDIF

				SX3->(DBSKIP())
			END
			MSUNLOCK()
		ENDIF
	ENDIF
Return



Static Function CriaPerg(c_Perg)
	Local a_MV_PAR01 := {}

	Aadd(a_MV_PAR01, "Informe o Codigo do Tipo Ent/Saida")

	//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Cod. Tipo ?"   	,"","","mv_ch1","C",TamSX3("F4_CODIGO")[1],0,0,"G","FG_StrZero('MV_PAR01',3).AND.ExistChav('SF4')","","","","mv_par01","","","","","","","","","","","","","","","","",a_MV_PAR01)
Return