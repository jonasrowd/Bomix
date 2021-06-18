#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � BXZOTM     �Autor �TBA001 -XXX     � Data �  02/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Plus Produtos - Bomix.						  ���
�������������������������������������������������������������������������͹��
���Uso       � BXZOTM			                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function BXAFASTAMENTO
Local d_PerIni := STOD("20160116")
Local d_PerFim := STOD("20160215")
Local n_Ret    := 0
//IIF(SR8->R8_DATAFIM > STOD("20160216"),STOD("20160215") - SR8->R8_DATAINI,IIF(SR8->R8_DATAINI < STOD("20160117"),SR8->R8_DATAFIM-STOD("20160116") ,SR8->R8_DURACAO))                                                                                           
Do Case 
	case SR8->R8_DATAFIM <= d_PerFim .and.  SR8->R8_DATAINI >= d_PerIni
		n_Ret := SR8->R8_DURACAO    
		
	case SR8->R8_DATAINI < d_PerIni	 .and.  SR8->R8_DATAFIM <= d_PerFim
	    n_Ret := SR8->R8_DATAFIM - d_PerIni                               
	    
	case SR8->R8_DATAFIM > 	d_PerFim .and.  SR8->R8_DATAINI >=  d_PerIni
		n_Ret := d_PerFim - R8->R8_DATAINI
		
	OtherWise
		n_Ret := (d_PerFim - d_PerIni)+1
EndCase

Return n_Ret