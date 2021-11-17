#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTALCDOC  ºAutor  ³FRANCISCO REZENDE   º Data ³  16/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na analise da cotacao.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTALCDOC()
Local a_SC7Area	:= SC7->(GetArea())
Local a_SC8Area	:= SC8->(GetArea())
Local a_SA2Area	:= SA2->(GetArea())
Local a_SE4Area	:= SE4->(GetArea())
Local a_SCRArea	:= SCR->(GetArea())
Local a_SALArea	:= SAL->(GetArea())
Local a_AreaSC1		:= SC1->(GetArea())//Salva area de trabalho
Local l_Ret 		:= Findfunction("U_PCOMA011") 
Local aData := {}
Local cDataUTC := ""
 
cDataUTC := DateTimeUTC(aData)

If l_Ret
	U_PCOMA011(ParamIxb, FUNNAME()) //CHAMA A ROTINA QUE ENVIA O EMAIL PARA O APROVADOR DO PROXIMO NIVEL
Endif

//intergracao Fluig
l_Ret 		:= Findfunction("U_FCOMA002") .And. Findfunction("U_FCOMA003")  
If l_Ret

	IF PARAMIXB[3] == 1	//Operacao de inclusao

		IF FUNNAME() <> "MATA235"
		
			if !EMPTY(AllTrim(PARAMIXB[1][6]))
				U_FCOMA002(.F.,PARAMIXB[1][6])
			ENDIF
		ENDIF

	ELSEIF PARAMIXB[3] == 3
		U_FCOMA003()

	ENDIF
	
	Conout("C7_NUM =>"+SC7->C7_NUM)
	Conout("C7_FSFLUIG =>"+cvaltochar(SC7->C7_FSFLUIG))
	Conout("OPERACAO =>"+cvaltochar(PARAMIXB[3]))
	Conout("DATA =>"+cDataUTC)
	Conout("FUNNAME=>"+FUNNAME())
Endif



RestArea(a_AreaSC1)
RestArea( a_SC7Area )
RestArea( a_SC8Area )
RestArea( a_SA2Area )
RestArea( a_SE4Area )
RestArea( a_SCRArea )
RestArea( a_SALArea )

Return()