//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Aar = "Axis-Aligned Rectangle"
//
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PointVsAar(P AS Vec2,    Rp AS Vec2, Rs AS Vec2)
ENDFUNCTION (P.x < Rp.x+Rs.x AND P.x >= Rp.x AND P.y < Rp.y+Rs.y AND P.y >= Rp.y)


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION AarVsAar(Rp1 AS Vec2, Rs1 AS Vec2,    Rp2 AS Vec2, Rs2 AS Vec2)
ENDFUNCTION (Rp1.x < Rp2.x+Rs2.x AND Rp1.x+Rs1.x >= Rp2.x AND Rp1.y < Rp2.y+Rs2.y AND Rp1.y+Rs1.y >= Rp2.y)


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PointVsCircle(P AS Vec2,    Cp AS Vec2, Cr AS FLOAT)
    dX AS FLOAT: dX = P.x - Cp.x
    dY AS FLOAT: dY = P.y - Cp.y
ENDFUNCTION (dX*dX + dY*dY < Cr*Cr)


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION CircleVsCircle(Cp1 AS Vec2, Cr1 AS FLOAT,    Cp2 AS Vec2, Cr2 AS FLOAT)
    dX AS FLOAT: dX = Cp1.x - Cp2.x
    dY AS FLOAT: dY = Cp1.y - Cp2.y
ENDFUNCTION ((dX*dX + dY*dY) < (Cr1*Cr1 + Cr2*Cr2))


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION CircleVsAar(Cp AS Vec2, Cr AS FLOAT,    Rp AS Vec2, Rs AS Vec2)
    //=====================================================================================================================================
    Cir_Lf AS FLOAT: Cir_Lf = Cp.x - Cr // "Circle-Left"
    Cir_Rt AS FLOAT: Cir_Rt = Cp.x + Cr // "Circle-Right"
    Cir_Bm AS FLOAT: Cir_Bm = Cp.y - Cr // "Circle-Bottom"                   2D Y is inverted in AGK.
    Cir_Tp AS FLOAT: Cir_Tp = Cp.y + Cr // "Circle-Top"

    //=====================================================================================================================================
    Rct_Rt AS FLOAT: Rct_Rt = Rp.x + Rs.x // "Rectangle-Right"
    Rct_Tp AS FLOAT: Rct_Tp = Rp.y + Rs.y // "Rectangle-Top"                 2D Y is inverted in AGK.

    //=====================================================================================================================================
    IF (Cir_Lf > Rct_Rt OR Cir_Bm > Rct_Tp OR Cir_Rt < Rp.x OR Cir_Tp < Rp.y) THEN EXITFUNCTION 0

    //=====================================================================================================================================
    IF     (Cp.y >= Rp.y AND Cp.y < Rct_Tp) : IF (Cir_Lf < Rct_Rt AND Cir_Rt > Rp.x) THEN EXITFUNCTION 1
    ELSEIF (Cp.x >= Rp.x AND Cp.x < Rct_Rt) : IF (Cir_Bm < Rct_Tp AND Cir_Tp > Rp.y) THEN EXITFUNCTION 1
    ENDIF

    //=====================================================================================================================================
    dX AS FLOAT
    IF     (Cp.x < Rp.x  ):  dX = Cp.x - Rp.x
    ELSEIF (Cp.x > Rct_Rt):  dX = Cp.x - Rct_Rt
    ENDIF

    dY AS FLOAT
    IF     (Cp.y < Rp.y  ):  dY = Cp.y - Rp.y
    ELSEIF (Cp.y > Rct_Tp):  dY = Cp.y - Rct_Tp
    ENDIF

    IF (dX*dX + dY*dY <= Cr*Cr) THEN EXITFUNCTION 1
    //=====================================================================================================================================
ENDFUNCTION 0


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//
//         P           1
//
//  A──────P──────B    0
//
//         P          -1
//
FUNCTION WhichSideOfLine(P REF AS Vec2,  La REF AS Vec2, Lb REF AS Vec2)
    Determinant AS FLOAT: Determinant = (P.x-La.x)*(Lb.y-La.y) - (P.y-La.y)*(Lb.x-La.x) //  cross(DeltaAP, DeltaAB)
ENDFUNCTION 0.0+(Determinant > 0.0)-(Determinant < 0.0)


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      PointVsLine(  Point,  LinA, LinB,  Tolerance  )
//
FUNCTION PointVsLine(P REF AS Vec2,    La AS Vec2, Lb AS Vec2,    Tolerance AS FLOAT)
    dAP_X AS FLOAT: dAP_X =  P.x - La.x
    dAP_Y AS FLOAT: dAP_Y =  P.y - La.y

    dAB_X AS FLOAT: dAB_X = Lb.x - La.x
    dAB_Y AS FLOAT: dAB_Y = Lb.y - La.y

    DotAP_AB AS FLOAT: DotAP_AB = (dAP_X * dAB_X) + (dAP_Y * dAB_Y)
    DotAB_AB AS FLOAT: DotAB_AB = (dAB_X * dAB_X) + (dAB_Y * dAB_Y)

    //  Get distance to NearestPointOnLine from 'La', as multiple of 'DltAB':
    Scaler AS FLOAT: Scaler = DotAP_AB / DotAB_AB

    //  Is ProjectedPoint going to be between 'La' and 'Lb':
    IF (Scaler < 0.0 OR Scaler >= 1.0) THEN EXITFUNCTION 0 // -1

    //  Project 'P' onto Line:
    PrjPnt_X AS FLOAT: PrjPnt_X = dAB_X * Scaler
    PrjPnt_Y AS FLOAT: PrjPnt_Y = dAB_Y * Scaler

    //  Distance between 'P' and 'PrjPnt':
    dPP_X AS FLOAT: dPP_X = dAP_X - PrjPnt_X
    dPP_Y AS FLOAT: dPP_Y = dAP_Y - PrjPnt_Y

ENDFUNCTION (dPP_X*dPP_X + dPP_Y*dPP_Y < Tolerance*Tolerance)


//==============================================================================================================================================================
FUNCTION PointVsLine1(P REF AS Vec2,    La REF AS Vec2, Lb REF AS Vec2,    Tolerance AS FLOAT)
    dPA_X AS FLOAT: dPA_X = La.x - P.x
    dPA_Y AS FLOAT: dPA_Y = La.y - P.y

    dPB_X AS FLOAT: dPB_X = Lb.x - P.x
    dPB_Y AS FLOAT: dPB_Y = Lb.y - P.y

    APB_Len AS FLOAT: APB_Len = sqrt(dPA_X*dPA_X + dPA_Y*dPA_Y) + sqrt(dPB_X*dPB_X + dPB_Y*dPB_Y)   //@@  SQRTs can likely be optimized out.

    dAB_X AS FLOAT: dAB_X = Lb.x - La.x
    dAB_Y AS FLOAT: dAB_Y = Lb.y - La.y

    AB_Len  AS FLOAT: AB_Len  = sqrt(dAB_X*dAB_X + dAB_Y*dAB_Y)    //@@  SQRT can likely be optimized out.

ENDFUNCTION (APB_Len < AB_Len + Tolerance) && (APB_Len > AB_Len - Tolerance)


FUNCTION PointVsLine2(P AS Vec2,    La AS Vec2, Lb AS Vec2,    Tolerance AS FLOAT)
    dAB_X AS FLOAT: dAB_X = Lb.x - La.x
    dAB_Y AS FLOAT: dAB_Y = Lb.y - La.y
    LenAB AS FLOAT: LenAB = dAB_X*dAB_X + dAB_Y*dAB_Y

    dPA_X AS FLOAT: dPA_X = La.x - P.x
    dPA_Y AS FLOAT: dPA_Y = La.y - P.y
    LenPA AS FLOAT: LenPA = dPA_X*dPA_X + dPA_Y*dPA_Y
    IF LenPA > LenAB THEN EXITFUNCTION 0

    dPB_X AS FLOAT: dPB_X = Lb.x - P.x
    dPB_Y AS FLOAT: dPB_Y = Lb.y - P.y
    LenPB   AS FLOAT: LenPB = dPB_X*dPB_X + dPB_Y*dPB_Y
    IF LenPB > LenAB THEN EXITFUNCTION 0

    LenAB = 1.0 / sqrt(LenAB)   //@@ SQRT can likely be optimized out.

    Dtrmnt AS FLOAT
    Dtrmnt = dPB_X*dPA_Y - dPA_X*dPB_Y
    Dtrmnt = Dtrmnt*LenAB
ENDFUNCTION (Dtrmnt > -Tolerance) && (Dtrmnt < Tolerance)


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Parallel overlapping Lines will not test positive as a collision.
//
FUNCTION LineVsLine(La1 REF AS Vec2, Lb1 REF AS Vec2,  La2 REF AS Vec2, Lb2 REF AS Vec2)
    dL1_X AS FLOAT: dL1_X = Lb1.x - La1.x //  Line1 in LocalSpace.   A = (0,0)  B = (#,#)
    dL1_Y AS FLOAT: dL1_Y = Lb1.y - La1.y

    dL2_X AS FLOAT: dL2_X = Lb2.x - La2.x //  Line2 in LocalSpace.   A = (0,0)  B = (#,#)
    dL2_Y AS FLOAT: dL2_Y = Lb2.y - La2.y

    dAA_X AS FLOAT: dAA_X = La1.x - La2.x
    dAA_Y AS FLOAT: dAA_Y = La1.y - La2.y

    d AS FLOAT: d =  dL1_X*dL2_Y - dL1_Y*dL2_X              //  dL1  cross  dL2
    r AS FLOAT: r = (dL1_X*dAA_Y - dL1_Y*dAA_X) / d
    s AS FLOAT: s = (dL2_X*dAA_Y - dL2_Y*dAA_X) / d
ENDFUNCTION (r >= 0.0 && r <= 1.0) && (s >= 0.0 && s <= 1.0)


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      LineVsAar(  LinePointA, LinePointB,  RectanglePosition, RectangleSize  )
//
FUNCTION LineVsAar(La REF AS Vec2, Lb REF AS Vec2,  Rp REF AS Vec2, Rs REF AS Vec2 )
    Rct_Rt AS FLOAT: Rct_Rt = Rp.x + Rs.x
    Rct_Bm AS FLOAT: Rct_Bm = Rp.y + Rs.y

    //=====================================================================================================================================
    // Is Area-of-Line over Area-of-Rectangle?
    Lin_Lf AS FLOAT
    Lin_Rt AS FLOAT
    IF     (La.x <= Lb.x) : Lin_Lf = La.x : Lin_Rt = Lb.x
    ELSEIF (La.x >  Lb.x) : Lin_Lf = Lb.x : Lin_Rt = La.x
    ENDIF

    Lin_Bm AS FLOAT
    Lin_Tp AS FLOAT
    IF     (La.y <= Lb.y) : Lin_Bm = Lb.y : Lin_Tp = La.y
    ELSEIF (La.y >  Lb.y) : Lin_Bm = La.y : Lin_Tp = Lb.y
    ENDIF
    IF Rp.x >= Lin_Rt OR Rp.y >= Lin_Bm OR Rct_Rt < Lin_Lf OR Rct_Bm < Lin_Tp THEN EXITFUNCTION 0

    //=====================================================================================================================================
    // Is PointB in Rectangle?
    IF (Lb.x < Rct_Rt AND Lb.x >= Rp.x AND Lb.y < Rct_Bm AND Lb.y >= Rp.y) THEN EXITFUNCTION 1

    // Is PointA in Rectangle?
    IF (La.x < Rct_Rt AND La.x >= Rp.x AND La.y < Rct_Bm AND La.y >= Rp.y) THEN EXITFUNCTION 1

    //=====================================================================================================================================
    // Are any of the 4 Rectangle-Lines colliding with the Line?
    dAB_X AS FLOAT: dAB_X = Lb.x - La.x
    dAB_Y AS FLOAT: dAB_Y = Lb.y - La.y
    d2A_2B_X AS FLOAT: d2A_2B_Y AS FLOAT
    d1A_2A_X AS FLOAT: d1A_2A_Y AS FLOAT
    d AS FLOAT: r AS FLOAT: s AS FLOAT

    d2A_2B_X = Rct_Rt - Rp.x
    d2A_2B_Y = 0.0
    d1A_2A_X = La.x - Rp.x
    d1A_2A_Y = La.y - Rp.y
    d  = (dAB_X * d2A_2B_Y) - (dAB_Y * d2A_2B_X)
    r  = (d1A_2A_Y*dAB_X    - d1A_2A_X*dAB_Y   )/d
    s  = (d1A_2A_Y*d2A_2B_X - d1A_2A_X*d2A_2B_Y)/d
    IF (r >= 0.0 AND r <= 1.0) AND (s >= 0.0 AND s <= 1.0) THEN EXITFUNCTION 1

    d2A_2B_X = 0.0
    d2A_2B_Y = Rct_Bm - Rp.y
    d1A_2A_X = La.x - Rct_Rt
    d1A_2A_Y = La.y - Rp.y
    d  = (dAB_X * d2A_2B_Y) - (dAB_Y * d2A_2B_X)
    r  = (d1A_2A_Y*dAB_X    - d1A_2A_X*dAB_Y   )/d
    s  = (d1A_2A_Y*d2A_2B_X - d1A_2A_X*d2A_2B_Y)/d
    IF (r >= 0.0 AND r <= 1.0) AND (s >= 0.0 AND s <= 1.0) THEN EXITFUNCTION 1

    d2A_2B_X = Rp.x  - Rct_Rt
    d2A_2B_Y = 0.0
    d1A_2A_X = La.x - Rct_Rt
    d1A_2A_Y = La.y - Rct_Bm
    d  = (dAB_X * d2A_2B_Y) - (dAB_Y * d2A_2B_X)
    r  = (d1A_2A_Y*dAB_X    - d1A_2A_X*dAB_Y   )/d
    s  = (d1A_2A_Y*d2A_2B_X - d1A_2A_X*d2A_2B_Y)/d
    IF (r >= 0.0 AND r <= 1.0) AND (s >= 0.0 AND s <= 1.0) THEN EXITFUNCTION 1

    // The function will never make it here.
    //d2A_2B_X = Rp.x  - Rp.x
    //d2A_2B_Y = Rp.y  - Rct_Bm
    //d1A_2A_X = La.x - Rp.x
    //d1A_2A_Y = La.y - Rct_Bm
    //d  = (dAB_X * d2A_2B_Y) - (dAB_Y * d2A_2B_X)
    //r  = (d1A_2A_Y*dAB_X    - d1A_2A_X*dAB_Y   )/d
    //s  = (d1A_2A_Y*d2A_2B_X - d1A_2A_X*d2A_2B_Y)/d
    //IF (r >= 0.0 AND r <= 1.0) AND (s >= 0.0 AND s <= 1.0) THEN EXITFUNCTION 1
ENDFUNCTION 0


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      LineVsCircle(  LinePointA, LinePointB,  CirclePosition, CircleRadius  )
//
FUNCTION LineVsCircle(La REF AS Vec2, Lb REF AS Vec2,  Cp REF AS Vec2, Cr AS FLOAT)
    Cir_Lf AS FLOAT: Cir_Lf = Cp.x - Cr
    Cir_Tp AS FLOAT: Cir_Tp = Cp.y - Cr
    Cir_Rt AS FLOAT: Cir_Rt = Cp.x + Cr
    Cir_Bm AS FLOAT: Cir_Bm = Cp.y + Cr

    //=====================================================================================================================================
    // Is Area-of-Line over Area-of-Circle?
    Lin_Lf AS FLOAT
    Lin_Rt AS FLOAT
    IF     (La.x <= Lb.x): Lin_Lf = La.x : Lin_Rt = Lb.x
    ELSEIF (La.x >  Lb.x): Lin_Lf = Lb.x : Lin_Rt = La.x
    ENDIF

    Lin_Tp AS FLOAT
    Lin_Bm AS FLOAT
    IF     (La.y <= Lb.y): Lin_Tp = La.y : Lin_Bm = Lb.y
    ELSEIF (La.y >  Lb.y): Lin_Tp = Lb.y : Lin_Bm = La.y
    ENDIF
    IF (Cir_Lf > Lin_Rt OR Cir_Tp > Lin_Bm OR Cir_Rt < Lin_Lf OR Cir_Bm < Lin_Tp) THEN EXITFUNCTION 0

    //=====================================================================================================================================
    CrCr AS FLOAT: CrCr = Cr*Cr

    //=====================================================================================================================================
    // Is PointB in Circle?                                Check PointB first, it's typically used as the destination of a movement vector.
    dBC_X AS FLOAT: dBC_X = Cp.x - Lb.x
    dBC_Y AS FLOAT: dBC_Y = Cp.y - Lb.y
    IF (dBC_X*dBC_X + dBC_Y*dBC_Y) < CrCr THEN EXITFUNCTION 1

    // Is PointA in Circle?
    dAC_X AS FLOAT: dAC_X = Cp.x - La.x
    dAC_Y AS FLOAT: dAC_Y = Cp.y - La.y
    IF (dAC_X*dAC_X + dAC_Y*dAC_Y) < CrCr THEN EXITFUNCTION 1

    //=====================================================================================================================================
    // PointD = CircleCenter projected on to Line.
    dAB_X AS FLOAT: dAB_X = Lb.x - La.x
    dAB_Y AS FLOAT: dAB_Y = Lb.y - La.y
    dAD_L AS FLOAT: dAD_L = (dAC_X*dAB_X + dAC_Y*dAB_Y) / (dAB_X*dAB_X + dAB_Y*dAB_Y)
    PntD_X    AS FLOAT: PntD_X = La.x + dAB_X * dAD_L
    PntD_Y    AS FLOAT: PntD_Y = La.y + dAB_Y * dAD_L

    // Is PntD between PointA and PointB?
    IF (PntD_X > Lin_Rt OR PntD_Y > Lin_Bm OR PntD_X < Lin_Lf OR PntD_Y < Lin_Tp) THEN EXITFUNCTION 0

    // Is PntD in Circle?
    dDC_X AS FLOAT: dDC_X = PntD_X - Cp.x
    dDC_Y AS FLOAT: dDC_Y = PntD_Y - Cp.y
    IF (dDC_X*dDC_X + dDC_Y*dDC_Y) < CrCr THEN EXITFUNCTION 1
ENDFUNCTION 0


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PointVsTriangle(P AS Vec2, Ta AS Vec2, Tb AS Vec2, Tc AS Vec2)
    dPA_x AS FLOAT: dPA_x = Ta.x - P.x
    dPA_y AS FLOAT: dPA_y = Ta.y - P.y
    dPB_x AS FLOAT: dPB_x = Tb.x - P.x
    dPB_y AS FLOAT: dPB_y = Tb.y - P.y
    dPC_x AS FLOAT: dPC_x = Tc.x - P.x
    dPC_y AS FLOAT: dPC_y = Tc.y - P.y
ENDFUNCTION (dPA_x*dPC_y <= dPC_x*dPA_y  AND  dPB_x*dPA_y <= dPA_x*dPB_y  AND  dPC_x*dPB_y <= dPB_x*dPC_y)
