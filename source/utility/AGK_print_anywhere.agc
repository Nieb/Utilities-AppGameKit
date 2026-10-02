//##############################################################################################################################################################
//##############################################################################################################################################################
TYPE _PrintA_
    iTXT AS AGK_Text[PRINTA_MAX]

    ////Q_Strg AS STRING[PRINTA_MAX]
    ////Q_Algn AS INTEGER[PRINTA_MAX]
    ////Q_PosX AS FLOAT[PRINTA_MAX]
    ////Q_PosY AS FLOAT[PRINTA_MAX]
    ////Q_Size AS FLOAT[PRINTA_MAX]
    ////Q_Colr AS INTEGER[PRINTA_MAX]

    Queue AS INTEGER
ENDTYPE
GLOBAL PrntA AS _PrintA_
#Constant PRINTA_MAX = 63

//==============================================================================================================================================================
FUNCTION InitializePrintA()
    iTxt AS INTEGER
    FOR iTxt = 0 TO PRINTA_MAX
        PrntA.iTXT[iTxt] = CreateText("")
            SetTextVisible(PrntA.iTXT[iTxt],0)
            SetTextDepth(PrntA.iTXT[iTxt],1)
    NEXT iTxt

    PrntA.Queue = -1
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION SetPrintAFont(iFnt AS INTEGER)
    iTxt AS INTEGER
    FOR iTxt = 0 TO PRINTA_MAX
        SetTextFont(PrntA.iTXT[iTxt], iFnt)
    NEXT iTxt
ENDFUNCTION

////FUNCTION SetPrintA_Align(Align AS INTEGER)
////    iTxt AS INTEGER
////    FOR iTxt = 0 TO PRINTA_MAX
////        SetTextAlignment(PrntA.iTXT[iTxt], Align)
////    NEXT iTxt
////ENDFUNCTION

////FUNCTION SetPrintA_Size(Size AS FLOAT)
////    iTxt AS INTEGER
////    FOR iTxt = 0 TO PRINTA_MAX
////        SetTextSize(PrntA.iTXT[iTxt], Size)
////    NEXT iTxt
////ENDFUNCTION

////FUNCTION SetPrintA_Color(Red AS INTEGER, Grn AS INTEGER, Blu AS INTEGER, Alf AS INTEGER)
////    iTxt AS INTEGER
////    FOR iTxt = 0 TO PRINTA_MAX
////        SetTextColor(PrntA.iTXT[iTxt], Red, Grn, Blu, Alf)
////    NEXT iTxt
////ENDFUNCTION

////FUNCTION SetPrintA_ColorABGR(ClrABGR AS INTEGER)
////    iTxt AS INTEGER
////    FOR iTxt = 0 TO PRINTA_MAX
////        SetTextColor(PrntA.iTXT[iTxt], COLOR)
////    NEXT iTxt
////ENDFUNCTION

////FUNCTION SetPrintA_ColorRGBA(ClrRGBA AS INTEGER)
////    iTxt AS INTEGER
////    FOR iTxt = 0 TO PRINTA_MAX
////        SetTextColor(PrntA.iTXT[iTxt], COLOR)
////    NEXT iTxt
////ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PrintA(TextStr   AS STRING,
                Align     AS INTEGER,
                PosX      AS FLOAT,
                PosY      AS FLOAT,
                Size      AS FLOAT,
                ColorABGR AS INTEGER )
    IF (PrntA.Queue >= PRINTA_MAX)
        EXITFUNCTION
    ELSE
        INC PrntA.Queue
        SetTextString(   PrntA.iTXT[PrntA.Queue], TextStr)
        SetTextAlignment(PrntA.iTXT[PrntA.Queue], Align)
        SetTextPosition( PrntA.iTXT[PrntA.Queue], PosX, PosY)
        SetTextSize(     PrntA.iTXT[PrntA.Queue], Size)
        SetTextColor(    PrntA.iTXT[PrntA.Queue], (ColorABGR && 0x000000FF), (ColorABGR && 0x0000FF00)>>8, (ColorABGR && 0x00FF0000)>>16, (ColorABGR && 0xFF000000)>>24 )
    ENDIF
ENDFUNCTION


////FUNCTION PrintA(TextStr   AS STRING,
////                PosX      AS FLOAT,
////                PosY      AS FLOAT )
////    SetTextString(   PrntA.iTXT[PrntA.Queue],  TextStr)
////    SetTextPosition( PrntA.iTXT[PrntA.Queue],  PosX, PosY)
////ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION DrawPrintA()
    iTxt AS INTEGER
    FOR iTxt = 0 TO PrntA.Queue
        SetTextVisible(PrntA.iTXT[iTxt],1)
        DrawText(PrntA.iTXT[iTxt])
        SetTextVisible(PrntA.iTXT[iTxt],0)
    NEXT iTxt

    PrntA.Queue = -1
ENDFUNCTION
