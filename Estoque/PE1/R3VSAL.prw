#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*
    Funcao:     R3V2Sal
    Autor:      Marinaldo de Jesus
    Data:       02/03/2012
    Descricao:  Atualizar Salario do SRA de acordo com o R3_VALOR e Data de Referencia
*/
User Function R3V2Sal( cFil , cMat , cSData )

    Local aArea          := GetArea()
    Local aSRAArea       := SRA->( GetArea() )

    Local cCRLF          := CRLF
    Local cQuery         := ""
    Local cMsgOut        := ""
    Local cKeySeek       := ""

    Local cSRASqlName    := RetSqlName("SRA")
    Local cSR3SqlName    := RetSqlName("SR3")
    Local cTCSqlError

    Local nSalario       := 0
    Local nRecno         := 0
    Local nSRAOrder      := RetOrder( "SRA" , "RA_FILIAL+RA_MAT" )

    DEFAULT cFil         := SRA->RA_FILIAL
    DEFAULT cMat         := SRA->RA_MAT
    DEFAULT cSData       := Dtos( dDataBase )

    cKeySeek             += ( cFil + cMat )

    cQuery    += "UPDATE" + cCRLF
    cQuery    += "    " + cSRASqlName + cCRLF
    cQuery    += "SET" + cCRLF
    cQuery    += "    " + cSRASqlName+".RA_SALARIO = " + cSR3SqlName+".R3_VALOR" + cCRLF
    cQuery    += "FROM" + cCRLF
    cQuery    += "    (" + cCRLF
    cQuery    += "        SELECT" + cCRLF
    cQuery    += "            SRA.RA_FILIAL," + cCRLF
    cQuery    += "            SRA.RA_MAT," + cCRLF
    cQuery    += "            MAX(SR3.R3_DATA) R3_DATA" + cCRLF
    cQuery    += "        FROM" + cCRLF
    cQuery    += "            " + cSRASqlName + " AS SRA," + cCRLF
    cQuery    += "            " + cSR3SqlName + " AS SR3" + cCRLF
    cQuery    += "        WHERE" + cCRLF
    cQuery    += "            SRA.D_E_L_E_T_ = ' '" + cCRLF
    cQuery    += "        AND" + cCRLF
    cQuery    += "            SR3.D_E_L_E_T_ = ' '" + cCRLF
    cQuery    += "        AND" + cCRLF
    cQuery    += "            SRA.RA_FILIAL = SR3.R3_FILIAL" + cCRLF
    cQuery    += "        AND" + cCRLF
    cQuery    += "            SRA.RA_MAT = SR3.R3_MAT" + cCRLF
    cQuery    += "        AND" + cCRLF
    cQuery    += "            SR3.R3_DATA <= '" + cSData + "'" + cCRLF
    cQuery    += "        GROUP BY" + cCRLF
    cQuery    += "            SRA.RA_FILIAL," + cCRLF
    cQuery    += "            SRA.RA_MAT" + cCRLF
    cQuery    += "    ) AS SAL," + cCRLF
    cQuery    += "    " + cSR3SqlName+ " AS " +cSR3SqlName + cCRLF
    cQuery    += "WHERE" + cCRLF
    cQuery    += "    " +cSRASqlName+".RA_FILIAL = '" + cFil + "'" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " +cSRASqlName+".RA_MAT = '" + cMat + "'"  + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    SAL.RA_FILIAL = "+cSRASqlName+".RA_FILIAL" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    SAL.RA_MAT    = "+cSRASqlName+".RA_MAT" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " + cSRASqlName+".D_E_L_E_T_ = ' '" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " + cSR3SqlName+".D_E_L_E_T_ = ' '" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " + cSRASqlName+".RA_FILIAL = " + cSR3SqlName+".R3_FILIAL" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " + cSRASqlName+".RA_MAT = " + cSR3SqlName+".R3_MAT" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " + cSR3SqlName+".R3_DATA = SAL.R3_DATA" + cCRLF
    cQuery    += "AND" + cCRLF
    cQuery    += "    " + cSR3SqlName+".R3_VALOR > 0" + cCRLF

    TRYEXCEPTION

        TcCommit(1,ProcName())    //Begin Transaction

        IF ( TcSqlExec( cQuery ) < 0 )
            cTCSqlError := TCSQLError()
            ConOut( cMsgOut += ( "[ProcName: " + ProcName() + "]" ) )
            cMsgOut += cCRLF
            ConOut( cMsgOut += ( "[ProcLine:" + Str(ProcLine()) + "]" ) )
            cMsgOut += cCRLF
            ConOut( cMsgOut += ( "[TcSqlError:" + cTCSqlError + "]" ) )
            cMsgOut += cCRLF
            UserException( cMsgOut )
        EndIF

        TcCommit(2,ProcName())    //Commit
        TcCommit(4)                //End Transaction

    CATCHEXCEPTION   

        TcCommit(3) //RollBack
        TcCommit(4) //End Transaction

    ENDEXCEPTION

    RestArea( aSRAArea )
    RestArea( aArea )

Return( nSalario )



//Read more: http://www.blacktdn.com.br/2012/03/blacktdn-funcao-nao-documentada.html#ixzz6QUswmDxg