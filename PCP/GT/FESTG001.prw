//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Totvs.ch"
#include "rwmake.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FESTG001     � Autor � AP6 IDE            �     �  		  ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para preencher a quantidade destino do produto     ���
���          � destino no Apontamento de Perda/Classifica��o da Perda	  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/   


User Function FESTG001
	Local a_Area    := GetArea()
	Local n_QtdDest := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDEST'})]

	If aCols[n][Len(aHeader) + 1] == .F.
		c_Prod   := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_PRODUTO'})]
		n_QtdPer := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]
		c_Um     := ""
		n_Peso   := 0
		c_Grupo  := ""

		c_Dest   := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_CODDEST'})]
		c_UmDest := ""

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1") + c_Prod))
			c_Um    := SB1->B1_UM
			c_Grupo := SB1->B1_GRUPO
		Endif

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1") + c_Dest))
			c_UmDest := SB1->B1_UM
		Endif		


		// VERIFICA��O DA CONDI��O DE UN/PC FRACIONADO INSERIDO POR VICTOR SOUSA 02/12/19

		if RTRIM(c_Um) $ "UN/PC" .AND.  n_QtdPer%1<>0

			MsgBox("Quantidade fracionada n�o permitida para este produto") 	
			aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QUANT'})]:=0
			Return  0
		endif



		If c_Um == c_UmDest
			n_QtdDest := n_QtdPer

		Elseif c_Um $ "UN/PC" .And. c_UmDest $ "UN/PC"
			n_QtdDest := n_QtdPer
		Elseif c_Um $ "UN/PC" .And. c_UmDest == "KG"
			dbSelectArea("SBM")
			SBM->(dbSetOrder(1))
			/*
			If SBM->(dbSeek(xFilial("SBM") + c_Grupo))
			If SubStr(SBM->BM_GRUPO, 1, 1) == "B"
			n_Peso := SBM->BM_FSPESOB/1000
			Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "A"
			n_Peso := SBM->BM_FSPALCA/1000
			Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "T"
			n_Peso := SBM->BM_FSPTAMP/1000
			Endif

			Endif
			*/
			n_QtdDest := n_QtdPer * n_Peso

			aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'BC_QTDDES2'})] := 0
		Endif
	Endif

	RestArea(a_Area)
Return n_QtdDest
