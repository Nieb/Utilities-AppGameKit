//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION DrawVert(Vrt REF AS Vec3, Siz AS FLOAT, C AS INTEGER)
    DrawEllipse( GetScreenXFrom3D(Vrt.x,Vrt.y,-Vrt.z), GetScreenYFrom3D(Vrt.x,Vrt.y,-Vrt.z), Siz,Siz, C,C, 1 )
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION DrawVertC(Vrt REF AS Vec3, Siz AS FLOAT, Clr REF AS RGBA)
    C AS INTEGER: C = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r
    DrawEllipse( GetScreenXFrom3D(Vrt.x,Vrt.y,-Vrt.z), GetScreenYFrom3D(Vrt.x,Vrt.y,-Vrt.z), Siz,Siz, C,C, 1 )
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION DrawVertZ(Vrt    AS Vec3, Siz    AS FLOAT, C AS INTEGER,
                   CamPos AS Vec3, CamLok AS Vec3 )
    //  Push CamPos slightly forward:
    CamPos = add3(CamPos, mul3f(CamLok, 0.0625+0.001)) // (CamNearDist + Offset)     @@ Compute all of this once then pass to function.

    //  Prevent GetScreenPosFrom3D() from barfing because of positions behind Camera_NearPlane:
    IF dot3(CamLok, sub3(Vrt, CamPos)) <= 0.0 THEN EXITFUNCTION // Is Vertex behind Camera?

    DrawEllipse( GetScreenXFrom3D(Vrt.x,Vrt.y,-Vrt.z), GetScreenYFrom3D(Vrt.x,Vrt.y,-Vrt.z), Siz,Siz, C,C, 1 )
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION DrawEdge(EdgA AS Vec3, EdgB AS Vec3, C AS INTEGER)
    DrawLine( GetScreenXFrom3D(EdgA.x,EdgA.y,-EdgA.z),GetScreenYFrom3D(EdgA.x,EdgA.y,-EdgA.z),  GetScreenXFrom3D(EdgB.x,EdgB.y,-EdgB.z),GetScreenYFrom3D(EdgB.x,EdgB.y,-EdgB.z),  C,C)
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION DrawEdgeC(EdgA REF AS Vec3, EdgB REF AS Vec3, Clr REF AS RGBA)
    C AS INTEGER : C = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r
    DrawLine( GetScreenXFrom3D(EdgA.x,EdgA.y,-EdgA.z),GetScreenYFrom3D(EdgA.x,EdgA.y,-EdgA.z),  GetScreenXFrom3D(EdgB.x,EdgB.y,-EdgB.z),GetScreenYFrom3D(EdgB.x,EdgB.y,-EdgB.z),  C,C)
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION DrawEdgeZ(EdgA   AS Vec3, EdgB   AS Vec3, C AS INTEGER,
                   CamPos AS Vec3, CamLok AS Vec3 )
    //  Push CamPos slightly forward:
    CamPos = add3(CamPos, mul3f(CamLok, 0.0625+0.001)) // (CamNearDist + Offset)     @@ Compute all of this once then pass to function.

    VertA_IsBehindCamera AS INTEGER = 0
    VertB_IsBehindCamera AS INTEGER = 0
    IF dot3(CamLok, sub3(EdgA, CamPos)) <= 0.0 THEN VertA_IsBehindCamera = 1
    IF dot3(CamLok, sub3(EdgB, CamPos)) <= 0.0 THEN VertB_IsBehindCamera = 1

    IF     VertA_IsBehindCamera AND VertB_IsBehindCamera : EXITFUNCTION
    ELSEIF VertA_IsBehindCamera                          : EdgA = IRayVsIPlane( EdgA, nrm3(sub3(EdgB,EdgA)), CamPos, CamLok )
    ELSEIF VertB_IsBehindCamera                          : EdgB = IRayVsIPlane( EdgB, nrm3(sub3(EdgA,EdgB)), CamPos, CamLok )
    ENDIF

    DrawLine( GetScreenXFrom3D(EdgA.x,EdgA.y,-EdgA.z),GetScreenYFrom3D(EdgA.x,EdgA.y,-EdgA.z),  GetScreenXFrom3D(EdgB.x,EdgB.y,-EdgB.z),GetScreenYFrom3D(EdgB.x,EdgB.y,-EdgB.z),  C,C)
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION DrawCircle12(Cp AS Vec3, Cr AS FLOAT, C AS INTEGER,    Pch AS FLOAT, Yaw AS FLOAT )
    A AS Vec3
    B AS Vec3

    A.x = Cp.x + Cr* 0.0
    A.y = Cp.y + Cr* 0.0
    A.z = Cp.z + Cr*-1.0
    B.x = Cp.x + Cr* 0.5
    B.y = Cp.y + Cr* 0.0
    B.z = Cp.z + Cr*-0.8660254

    IF (Pch <> 0.0): A = pch3(A, Pch) : B = pch3(B, Pch) :ENDIF
    IF (Yaw <> 0.0): A = yaw3(A, Yaw) : B = yaw3(B, Yaw) :ENDIF
    GOSUB DrawSegments

    A = B
    B.x = Cp.x + Cr* 0.8660254
    B.y = Cp.y + Cr* 0.0
    B.z = Cp.z + Cr*-0.5


    IF (Pch <> 0.0) THEN B = pch3(B, Pch)
    IF (Yaw <> 0.0) THEN B = yaw3(B, Yaw)
    GOSUB DrawSegments

    A = B
    B.x = Cp.x + Cr*1.0
    B.y = Cp.y + Cr*0.0
    B.z = Cp.z + Cr*0.0

    IF (Pch <> 0.0) THEN B = pch3(B, Pch)
    IF (Yaw <> 0.0) THEN B = yaw3(B, Yaw)
    GOSUB DrawSegments

    EXITFUNCTION

    DrawSegments:
        DrawLine(GetScreenXFrom3D( A.x, A.y,- A.z), GetScreenYFrom3D( A.x, A.y,- A.z),  GetScreenXFrom3D( B.x, B.y,- B.z), GetScreenYFrom3D( B.x, B.y,- B.z),  C, C-0x00CCCC00)
        DrawLine(GetScreenXFrom3D( A.x,-A.y,--A.z), GetScreenYFrom3D( A.x,-A.y,--A.z),  GetScreenXFrom3D( B.x,-B.y,--B.z), GetScreenYFrom3D( B.x,-B.y,--B.z),  C, C-0x00FF00FF)
        DrawLine(GetScreenXFrom3D(-A.x,-A.y,--A.z), GetScreenYFrom3D(-A.x,-A.y,--A.z),  GetScreenXFrom3D(-B.x,-B.y,--B.z), GetScreenYFrom3D(-B.x,-B.y,--B.z),  C, C-0x0000CCFF)
        DrawLine(GetScreenXFrom3D(-A.x, A.y,- A.z), GetScreenYFrom3D(-A.x, A.y,- A.z),  GetScreenXFrom3D(-B.x, B.y,- B.z), GetScreenYFrom3D(-B.x, B.y,- B.z),  C, C-0x0000FF00)

      //DrawLine(GetScreenXFrom3D( A.x, A.y,- A.z), GetScreenYFrom3D( A.x, A.y,- A.z),  GetScreenXFrom3D( B.x, B.y,- B.z), GetScreenYFrom3D( B.x, B.y,- B.z),  C, C)
      //DrawLine(GetScreenXFrom3D( A.x,-A.y,--A.z), GetScreenYFrom3D( A.x,-A.y,--A.z),  GetScreenXFrom3D( B.x,-B.y,--B.z), GetScreenYFrom3D( B.x,-B.y,--B.z),  C, C)
      //DrawLine(GetScreenXFrom3D(-A.x,-A.y,--A.z), GetScreenYFrom3D(-A.x,-A.y,--A.z),  GetScreenXFrom3D(-B.x,-B.y,--B.z), GetScreenYFrom3D(-B.x,-B.y,--B.z),  C, C)
      //DrawLine(GetScreenXFrom3D(-A.x, A.y,- A.z), GetScreenYFrom3D(-A.x, A.y,- A.z),  GetScreenXFrom3D(-B.x, B.y,- B.z), GetScreenYFrom3D(-B.x, B.y,- B.z),  C, C)
    RETURN
ENDFUNCTION

FUNCTION DrawCircle16(Cp AS Vec3, Cr AS FLOAT, C AS INTEGER,    Pch AS FLOAT, Yaw AS FLOAT )
    //...
ENDFUNCTION

FUNCTION DrawCircle24(Cp AS Vec3, Cr AS FLOAT, C AS INTEGER,    Pch AS FLOAT, Yaw AS FLOAT )
    //...
ENDFUNCTION

FUNCTION DrawCircle32(Cp AS Vec3, Cr AS FLOAT, C AS INTEGER,    Pch AS FLOAT, Yaw AS FLOAT )
    //...
ENDFUNCTION

FUNCTION DrawCircle48(Cp AS Vec3, Cr AS FLOAT, C AS INTEGER,    Pch AS FLOAT, Yaw AS FLOAT )
    //...
ENDFUNCTION

FUNCTION DrawCircle64(Cp AS Vec3, Cr AS FLOAT, C AS INTEGER,    Pch AS FLOAT, Yaw AS FLOAT )
    //...
ENDFUNCTION

//==============================================================================================================================================================
//FUNCTION DrawCircle(Cp REF AS Vec3, Cir_Rot REF AS Vec3    CirPch AS FLOAT, CirYaw AS FLOAT,    , Cr AS FLOAT, Segments AS INTEGER, Clr REF AS RGBA)

//@@  Todo.
//      Produce draw-points, then rotate them.    Cache them?

//FUNCTION CreateWireMesh()
//    Mesh AS Vec3[]
//ENDFUNCTION Mesh
//FUNCTION DrawWireMesh(Pos AS Vec3, Mesh REF AS Vec3[])
//ENDFUNCTION

//    ClrABGR AS INTEGER : ClrABGR = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r
//    aX AS FLOAT : aX = Cr
//    aZ AS FLOAT : aZ = 0.0
//    bX AS FLOAT
//    bZ AS FLOAT
//    IF Segments > 1
//        StepSize AS FLOAT : StepSize = PiH / Segments
//        iSeg AS INTEGER
//        FOR iSeg = 1 TO Segments-1 // xpos = x-Cr TO xpos <= x+Cr STEP 0.1
//            bX = cosrad(StepSize * iSeg)*Cr
//            bZ = sinrad(StepSize * iSeg)*Cr
//            DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), ClrABGR,ClrABGR)
//            DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), ClrABGR,ClrABGR)
//            DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), ClrABGR,ClrABGR)
//            DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), ClrABGR,ClrABGR)
//            aX = bX
//            aZ = bZ
//        NEXT iSeg
//    ENDIF
//    bX = 0.0
//    bZ = Cr
//    DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), ClrABGR,ClrABGR)
//    DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), ClrABGR,ClrABGR)
//    DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), ClrABGR,ClrABGR)
//    DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), ClrABGR,ClrABGR)
//ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Circle is drawn on plane that spans YZ.
//
FUNCTION DrawCircleX(Cp REF AS Vec3, Cr AS FLOAT, Segments AS INTEGER, Clr REF AS RGBA)
    C AS INTEGER: C = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r

    //VertX AS FLOAT[Segments] : VertX[0] =
    //VertY AS FLOAT[Segments] : VertY[0] = Cr
    //VertZ AS FLOAT[Segments] : VertZ[0] = 0.0

    aY AS FLOAT: aY = Cr
    aZ AS FLOAT: aZ = 0.0
    bY AS FLOAT
    bZ AS FLOAT
    IF Segments > 1
        StepSize AS FLOAT : StepSize = PiH / Segments
        iSeg AS INTEGER
        FOR iSeg = 1 TO Segments-1
            bY = cosrad(StepSize*iSeg) * Cr
            bZ = sinrad(StepSize*iSeg) * Cr
            DrawLine(GetScreenXFrom3D(Cp.x,Cp.y+aY,-Cp.z-aZ), GetScreenYFrom3D(Cp.x,Cp.y+aY,-Cp.z-aZ), GetScreenXFrom3D(Cp.x,Cp.y+bY,-Cp.z-bZ), GetScreenYFrom3D(Cp.x,Cp.y+bY,-Cp.z-bZ), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x,Cp.y-aY,-Cp.z-aZ), GetScreenYFrom3D(Cp.x,Cp.y-aY,-Cp.z-aZ), GetScreenXFrom3D(Cp.x,Cp.y-bY,-Cp.z-bZ), GetScreenYFrom3D(Cp.x,Cp.y-bY,-Cp.z-bZ), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x,Cp.y-aY,-Cp.z+aZ), GetScreenYFrom3D(Cp.x,Cp.y-aY,-Cp.z+aZ), GetScreenXFrom3D(Cp.x,Cp.y-bY,-Cp.z+bZ), GetScreenYFrom3D(Cp.x,Cp.y-bY,-Cp.z+bZ), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x,Cp.y+aY,-Cp.z+aZ), GetScreenYFrom3D(Cp.x,Cp.y+aY,-Cp.z+aZ), GetScreenXFrom3D(Cp.x,Cp.y+bY,-Cp.z+bZ), GetScreenYFrom3D(Cp.x,Cp.y+bY,-Cp.z+bZ), C,C)
            aY = bY
            aZ = bZ
        NEXT iSeg
    ENDIF
    bY = 0.0
    bZ = Cr
    DrawLine(GetScreenXFrom3D(Cp.x,Cp.y+aY,-Cp.z-aZ), GetScreenYFrom3D(Cp.x,Cp.y+aY,-Cp.z-aZ), GetScreenXFrom3D(Cp.x,Cp.y+bY,-Cp.z-bZ), GetScreenYFrom3D(Cp.x,Cp.y+bY,-Cp.z-bZ), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x,Cp.y-aY,-Cp.z-aZ), GetScreenYFrom3D(Cp.x,Cp.y-aY,-Cp.z-aZ), GetScreenXFrom3D(Cp.x,Cp.y-bY,-Cp.z-bZ), GetScreenYFrom3D(Cp.x,Cp.y-bY,-Cp.z-bZ), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x,Cp.y-aY,-Cp.z+aZ), GetScreenYFrom3D(Cp.x,Cp.y-aY,-Cp.z+aZ), GetScreenXFrom3D(Cp.x,Cp.y-bY,-Cp.z+bZ), GetScreenYFrom3D(Cp.x,Cp.y-bY,-Cp.z+bZ), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x,Cp.y+aY,-Cp.z+aZ), GetScreenYFrom3D(Cp.x,Cp.y+aY,-Cp.z+aZ), GetScreenXFrom3D(Cp.x,Cp.y+bY,-Cp.z+bZ), GetScreenYFrom3D(Cp.x,Cp.y+bY,-Cp.z+bZ), C,C)
ENDFUNCTION


//==============================================================================================================================================================
//
//  Circle is drawn on plane that spans ZX.
//
FUNCTION DrawCircleY(Cp REF AS Vec3, Cr AS FLOAT, Segments AS INTEGER, Clr REF AS RGBA)
    C AS INTEGER: C = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r
    aX AS FLOAT: aX = Cr
    aZ AS FLOAT: aZ = 0.0
    bX AS FLOAT
    bZ AS FLOAT
    IF Segments > 1
        StepSize AS FLOAT : StepSize = PiH / Segments
        iSeg AS INTEGER
        FOR iSeg = 1 TO Segments-1
            bX = cosrad(StepSize*iSeg) * Cr
            bZ = sinrad(StepSize*iSeg) * Cr
            DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), C,C)
            aX = bX
            aZ = bZ
        NEXT iSeg
    ENDIF
    bX = 0.0
    bZ = Cr
    DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z-bZ), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z-aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z-bZ), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x-aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x-bX,Cp.y,-Cp.z+bZ), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenYFrom3D(Cp.x+aX,Cp.y,-Cp.z+aZ), GetScreenXFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), GetScreenYFrom3D(Cp.x+bX,Cp.y,-Cp.z+bZ), C,C)
ENDFUNCTION


//==============================================================================================================================================================
//
//  Circle is drawn on plane that spans XY.
//
FUNCTION DrawCircleZ(Cp REF AS Vec3, Cr AS FLOAT, Segments AS INTEGER, Clr REF AS RGBA)
    C AS INTEGER : C = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r
    aX AS FLOAT: aX = Cr
    aY AS FLOAT: aY = 0.0
    bX AS FLOAT
    bY AS FLOAT
    IF Segments > 1
        StepSize AS FLOAT : StepSize = PiH / Segments
        iSeg AS INTEGER
        FOR iSeg = 1 TO Segments-1
            bX = cosrad(StepSize*iSeg) * Cr
            bY = sinrad(StepSize*iSeg) * Cr
            DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y-aY,-Cp.z), GetScreenYFrom3D(Cp.x+aX,Cp.y-aY,-Cp.z), GetScreenXFrom3D(Cp.x+bX,Cp.y-bY,-Cp.z), GetScreenYFrom3D(Cp.x+bX,Cp.y-bY,-Cp.z), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y-aY,-Cp.z), GetScreenYFrom3D(Cp.x-aX,Cp.y-aY,-Cp.z), GetScreenXFrom3D(Cp.x-bX,Cp.y-bY,-Cp.z), GetScreenYFrom3D(Cp.x-bX,Cp.y-bY,-Cp.z), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y+aY,-Cp.z), GetScreenYFrom3D(Cp.x-aX,Cp.y+aY,-Cp.z), GetScreenXFrom3D(Cp.x-bX,Cp.y+bY,-Cp.z), GetScreenYFrom3D(Cp.x-bX,Cp.y+bY,-Cp.z), C,C)
            DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y+aY,-Cp.z), GetScreenYFrom3D(Cp.x+aX,Cp.y+aY,-Cp.z), GetScreenXFrom3D(Cp.x+bX,Cp.y+bY,-Cp.z), GetScreenYFrom3D(Cp.x+bX,Cp.y+bY,-Cp.z), C,C)
            aX = bX
            aY = bY
        NEXT iSeg
    ENDIF
    bX = 0.0
    bY = Cr
    DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y-aY,-Cp.z), GetScreenYFrom3D(Cp.x+aX,Cp.y-aY,-Cp.z), GetScreenXFrom3D(Cp.x+bX,Cp.y-bY,-Cp.z), GetScreenYFrom3D(Cp.x+bX,Cp.y-bY,-Cp.z), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y-aY,-Cp.z), GetScreenYFrom3D(Cp.x-aX,Cp.y-aY,-Cp.z), GetScreenXFrom3D(Cp.x-bX,Cp.y-bY,-Cp.z), GetScreenYFrom3D(Cp.x-bX,Cp.y-bY,-Cp.z), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x-aX,Cp.y+aY,-Cp.z), GetScreenYFrom3D(Cp.x-aX,Cp.y+aY,-Cp.z), GetScreenXFrom3D(Cp.x-bX,Cp.y+bY,-Cp.z), GetScreenYFrom3D(Cp.x-bX,Cp.y+bY,-Cp.z), C,C)
    DrawLine(GetScreenXFrom3D(Cp.x+aX,Cp.y+aY,-Cp.z), GetScreenYFrom3D(Cp.x+aX,Cp.y+aY,-Cp.z), GetScreenXFrom3D(Cp.x+bX,Cp.y+bY,-Cp.z), GetScreenYFrom3D(Cp.x+bX,Cp.y+bY,-Cp.z), C,C)
ENDFUNCTION
