#include "rwmake.ch"    
#include "topconn.ch"    

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³SF2460I ºAutor ³						º Data ³ 		 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ PE para gravar informações do PV na NF de saída.     	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ SIGAFAT														  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function SF2460I     

//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return
endif

////////



	a_Area    := GetArea()
	a_AreaSD2 := SD2->(GetArea())	
	a_AreaSC5 := SC5->(GetArea())

	If SF2->F2_TIPO == "N"
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA))
		While SD2->(!EoF()) .And. SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) == xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)
			d_FecEnt := Ctod("  /  /    ")

			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(xFilial("SC5") + SD2->D2_PEDIDO)
				d_FecEnt := SC5->C5_FECENT
			Endif

			RecLock("SD2", .F.)
			SD2->D2_FSDTPCP := d_FecEnt
			MsUnlock()

			SD2->(dbSkip())
		End
	Endif       
	
	//TBA001 -XXX 14-01-2016 CONTORNO DO PROBLEMA DE DADOS DO TRANSPORTADOR ( VOLUMES E PESOS) NÃO ESTÃO SENDO APRESENTADOS
	SF2->F2_ESPECI1 :=	SC5->C5_ESPECI1
	SF2->f2_VOLUME1  :=	SC5->C5_VOLUME1
	// FIM DO CONTORNO

	RestArea(a_AreaSC5)
	RestArea(a_AreaSD2)
	RestArea(a_Area)
Return