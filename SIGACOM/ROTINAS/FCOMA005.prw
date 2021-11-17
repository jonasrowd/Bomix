#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#Include 'FWMVCDef.ch'
#Include "TOPCONN.CH"
#include "vkey.ch"
#INCLUDE "TOTVS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"

#DEFINE ENTER CHR(13) + CHR(10)

User Function FCOMA005()
Local	l_PCLibAlt	:=	SUPERGETMV("FS_LPCALT" ,.F.,.F.)
Local 	a_Area   	:= 	GetArea()
Private o_Browse
Private aRotina			:= MenuDef()
Private c_Cadastro 		:= "Alteração de  Pedido de Compra sem Fluxo de Aprovação"
Private a_Seek 			:= {},  a_FieFilter := {}
Private	c_NumPC			:=	SC7->C7_NUM

If SC7->C7_CONAPRO == 'L' .And. l_PCLibAlt
	msginfo("Pedido Liberado. Conforme definido no parâmetro FS_LPCALT, pedidos liberados não podem ser alterados.")
	Return
Endif

//Campos que irão compor o combo de pesquisa na tela principal
Aadd(a_Seek,{"Item"   , {{"","C",TAMSX3("C7_ITEM")[1],TAMSX3("C7_ITEM")[2], "C7_ITEM"   ,"@!"}}, 1, .T. } )

//Campos que irão compor a tela de filtro
Aadd(a_FieFilter,{"C7_ITEM"	, "Item"   , "C", TAMSX3("C7_ITEM")[1], TAMSX3("C7_ITEM")[2],"@!"})

dbSelectArea("SC7")
SC7->(DbSetFilter({|| Alltrim(C7_NUM)= c_NumPC},"Alltrim(C7_NUM)= '"+c_NumPC+"'"))

o_Browse := FWmBrowse():New()
o_Browse:SetAlias( "SC7" )
o_Browse:SetDescription( c_Cadastro )
o_Browse:SetSeek(,a_Seek)
o_Browse:SetLocate()
o_Browse:SetUseFilter(.F.)
o_Browse:SetFieldFilter(a_FieFilter)
o_Browse:SetOnlyFields( { 'C7_NUM', 'C7_ITEM', 'C7_PRODUTO','C7_DESCRI','C7_FSMARCA','C7_DATPRF','C7_OBS' } )
o_Browse:Activate()

dbSelectarea("SC7")
Set Filter To

restArea(a_Area)

return(Nil)

/*/{Protheus.doc} MenuDef
//menu da rotina
//	AADD(aRotina1, {"Consulta Produto"	, "MATC050()"		, 0, 6, 0, Nil })
//	AADD(aRotina1, {"Legenda"			, "U_EXEM992L"		, 0,11, 0, Nil })
//	AADD(a_Rotina, {"Pesquisar"			, "PesqBrw"			, 0, 1, 0, .T. })
//	AADD(aRotina, {"Visualizar"			, "U_EXEM992I"		, 0, 2, 0, .F. })
//	AADD(aRotina, {"Incluir"			, "U_EXEM992I"		, 0, 3, 0, Nil })
//	AADD(a_Rotina, {"Alterar"			, "U_EXEM992I"		, 0, 4, 0, Nil })
//	AADD(aRotina, {"Excluir"			, "U_EXEM992I"		, 0, 5, 3, Nil })
//	AADD(aRotina, {"Mais ações..."    	, aRotina1                   , 0, 4, 0, Nil }      )

@author carlo
@since 03/12/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MenuDef()
	Local aRotina 	:= {}
	AADD(aRotina, {"Editar"			, "U_FCOMT005"		, 0, 4, 0, Nil })
Return( aRotina )


User Function FCOMT005()
Local c_FSMarca	:=	Iif(Empty(SC7->C7_FSMARCA),Space(TamSx3("C7_FSMARCA")[1]),Alltrim(SC7->C7_FSMARCA)+Space(TamSx3("C7_FSMARCA")[1]-len(Alltrim(SC7->C7_FSMARCA))))
Local d_DatPrf	:=	SC7->C7_DATPRF
Local d_DatFat	:=	SC7->C7_FSDTPRE
Local c_Obs		:=	Iif(Empty(SC7->C7_OBS),Space(TamSx3("C7_OBS")[1]),Alltrim(SC7->C7_OBS)+Space(TamSx3("C7_OBS")[1]-len(Alltrim(SC7->C7_OBS))))
Local o_BtCancela
Local o_BtConfirma
Local o_FontTela:= TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
Local o_FrmPedido
Local o_SDataPrf
Local o_SDataFat
Local o_SMarca
Local o_SObs

Private o_GDatPrf
Private c_GDatPrf := d_DatPrf
Private o_GDatFat
Private c_GDatFat := d_DatFat
Private o_GFSMarca
Private c_GFSMarca:= c_FSMarca
Private o_GObs
Private c_GObs 	:= c_Obs
Private o_Dlg

DEFINE MSDIALOG o_Dlg FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 024, 012 GROUP 	o_FrmPedido TO 152, 243 	PROMPT "Alteração de Dados do Pedido" 	OF o_Dlg 						COLOR 0, 16777215 	PIXEL
	@ 041, 020 SAY 		o_SMarca 					PROMPT "Marca" 				SIZE 032, 012 	OF o_Dlg FONT o_FontTela 	COLORS 0, 16777215 	PIXEL
	@ 051, 020 MSGET 	o_GFSMarca 					VAR c_GFSMarca SIZE 133, 014				OF o_Dlg FONT o_FontTela	COLORS 0, 16777215  PIXEL
	@ 075, 020 SAY 		o_SDataPrf 					PROMPT "Data Entrega" 		SIZE 050, 012 	OF o_Dlg FONT o_FontTela 	COLORS 0, 16777215 	PIXEL
	@ 087, 020 MSGET 	o_GDatPrf 					VAR c_GDatPrf SIZE 080, 014 				OF o_Dlg FONT o_FontTela	COLORS 0, 16777215  PIXEL
	@ 075, 156 SAY 		o_SDataFat 					PROMPT "Dt Prev Fat" 		SIZE 050, 012 	OF o_Dlg FONT o_FontTela 	COLORS 0, 16777215 	PIXEL
	@ 087, 156 MSGET 	o_GDatFat 					VAR c_GDatFat SIZE 080, 014 				OF o_Dlg FONT o_FontTela	COLORS 0, 16777215  PIXEL
	@ 111, 020 SAY 		o_SObs 						PROMPT "Observação" 		SIZE 200, 012 	OF o_Dlg FONT o_FontTela 	COLORS 0, 16777215 	PIXEL
	@ 121, 020 MSGET 	o_GObs 						VAR c_GObs SIZE 200, 014 					OF o_Dlg FONT o_FontTela	COLORS 0, 16777215  PIXEL
	@ 133, 020 BUTTON 	o_BtConfirma 				PROMPT "Confirma" 			SIZE 050, 012 	OF o_Dlg FONT o_FontTela 	ACTION f_Confirma() PIXEL
	@ 133, 077 BUTTON 	o_BtCancela 				PROMPT "Cancela" 			SIZE 050, 012 	OF o_Dlg FONT o_FontTela 	ACTION o_Dlg:End() 	PIXEL

ACTIVATE MSDIALOG o_Dlg CENTERED

Return

Static Function f_Confirma()
	Local l_Replica	:=	.F.
	Local l_ReplFat	:=	.F.
	Local c_Num		:=	SC7->C7_NUM
	Local c_Fil		:=	SC7->C7_FILIAL
	Local n_Reg		:=	SC7->(Recno())
	If SC7->C7_DATPRF <> c_GDatPrf
		If msgYesNo("Replica Data de Entrega para todos os itens do Pedido?")
			l_Replica	:=	.T.
		Endif
	Endif

	If SC7->C7_DATPRF <> c_GDatFat
		If msgYesNo("Replica Data de Faturamento para todos os itens do Pedido?")
			l_ReplFat	:=	.T.
		Endif
	Endif

	If SC7->(RecLock("SC7",.F.))
		SC7->C7_FSMARCA	:=	c_GFSMarca
		SC7->C7_DATPRF	:=	c_GDatPrf
		SC7->C7_FSDTPRE	:=	c_GDatFat
		SC7->C7_OBS		:=	c_GObs
		SC7->(msUnlock())
		
		If l_Replica .or. l_ReplFat
			DBSELECTAREA("SC7")
			DBSETORDER(1)
			DBSEEK( XFILIAL("SC7") + c_Num )
			WHILE SC7->(!EOF()) .AND. SC7->C7_FILIAL + SC7->C7_NUM == c_Fil + c_Num 
				If SC7->(Recno()) <> n_Reg 
					If SC7->(RecLock("SC7",.F.))
						If l_Replica
							SC7->C7_DATPRF	:=	c_GDatPrf
						Endif
						If l_ReplFat
							SC7->C7_FSDTPRE	:=	c_GDatFat
						Endif
						SC7->(msUnlock())
					Endif
				Endif
				SC7->(dbSkip())
			Enddo
			
			SC7->(dbGoTo(n_Reg))

			msgInfo("Registros Alterados!","Atenção")
			
		Endif
	Else
		Alert("Registro Boqueado. Alteração abortada.")
	Endif
	o_Dlg:End()

Return