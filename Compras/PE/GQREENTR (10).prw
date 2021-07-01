#Include "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �GQREENTR  �Autor  �Sandro Santos       � Data �  17/01/2012 ���
�����������������������������������������������������������������������������
���Desc.     �Ponto de Entrada no documento de entrada. Apos gravacao das ���
���          �tabelas                                                     ���
�����������������������������������������������������������������������������
���Uso       � SIGACOM                                                    ���
�����������������������������������������������������������������������������
���                     A L T E R A C O E S                               ���
��� Utilizando o mesmo Ponto de Entrada para ajusta os LOTES+ VALIDADE    ���
��� no momento da grava��o dos itens.                                     ���
�����������������������������������������������������������������������������
*/        

User Function GQREENTR()

Local a_AreaSF1 	:= SF1->(GetArea())	//Salva Area do Cabecalho do Documento de Entrada
Local a_AreaSD1 	:= SD1->(GetArea())	//Salva Area dos Itens do Documento de Entrada

IF SF1->F1_TIPO $ "N|C"						//Verifica se os tipos da nota sao Normal ou Complemento

	IF ALLTRIM( SF1->F1_ESPECIE ) == 'SPED'	//Verifica se trata de Especie SPED
	
		IF SF1->F1_EST == 'EX'				//Verifica a UF Origem do Fornecedor
		
			//������������������������������������������������������
			//�Executa a rotina de complementos do documento fiscal�
			//������������������������������������������������������
			MATA926( SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_ESPECIE,SF1->F1_FORNECE,SF1->F1_LOJA,"E",SF1->F1_TIPO )
			
		ENDIF
		
	ENDIF
	       
	/*   
	cDtvalid:= SB8->B8_DTVALID 
	cData:= SD1->D1_LOTECTL
	
	DBSELECTAREA("SB8")
	cDtvalid(DBGOTOP())
	WHILE cDtvalid->(!EOF())
	IF S->B8_DTVALID ==	D1_LOTECTL					
       //Reclock
	IF ALLTRIM( SB8->B8_DTVALID ) == '31\12\2050'	
						
		ENDIF
	  */ 
	  
ENDIF

RestArea(a_AreaSF1)
RestArea(a_AreaSD1)

Return()