//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  IRay    =  "Infinite-Ray"
//  IPlane  =  "Infinite-Plane"
//  IAap    =  "Infinite-Axis-Aligned-Plane"
//  Aab     =  "Axis-Aligned-Box"
//
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION InitializeCollision3()
    GLOBAL MISS AS FLOAT: MISS = FLT_NaN
ENDFUNCTION

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION WhichSideOfPlane(Pnt_Pos REF AS Vec3,  Pln_Pos REF AS Vec3, Pln_Nrm REF AS Vec3)
    IF dot3(Pln_Nrm, sub3(Pnt_Pos, Pln_Pos)) >= 0.0 THEN EXITFUNCTION 1 // 'Point' is on 'Pln_Nrm' side.
ENDFUNCTION 0 // 'Point' is behind plane.


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION RayVsPlane( Ray_Pos REF AS Vec3, Ray_Nrm REF AS Vec3,
                     Pln_Pos REF AS Vec3, Pln_Nrm REF AS Vec3 )
    HitPos AS Vec3
    WhichSide AS FLOAT: WhichSide = dot3(Pln_Nrm, sub3(Ray_Pos, Pln_Pos))
    Dot_RayNrm_PlnNrm AS FLOAT: Dot_RayNrm_PlnNrm = -dot3(Ray_Nrm, Pln_Nrm)

    // Is Ray pointing away from Plane?
    IF (WhichSide >= 0.0): IF (Dot_RayNrm_PlnNrm <  EPSILON): Print("WhichSide = 1") : HitPos.x = MISS : EXITFUNCTION HitPos :ENDIF
    ELSE                 : IF (Dot_RayNrm_PlnNrm > -EPSILON): Print("WhichSide = 0") : HitPos.x = MISS : EXITFUNCTION HitPos :ENDIF
    ENDIF

    // Project Ray onto Plane from Ray_Pos along Ray_Nrm.
    Distance AS FLOAT: Distance = WhichSide / Dot_RayNrm_PlnNrm
    HitPos = add3( Ray_Pos, mul3f(Ray_Nrm, Distance) )
ENDFUNCTION HitPos


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION RayVsPlaneX( Ray_Pos REF AS Vec3, Ray_Nrm REF AS Vec3,     //  Plane spans YZ.
                       PlnPosX AS FLOAT )
    HitPos AS Vec3

    Distance AS FLOAT: Distance = (PlnPosX - Ray_Pos.x) / Ray_Nrm.x

    IF (Distance < EPSILON): HitPos.x = MISS : EXITFUNCTION HitPos :ENDIF

    //HitPos = add3( Ray_Pos, mul3f(Ray_Nrm, Distance) )
    HitPos.x = Ray_Pos.x + Ray_Nrm.x * Distance
    HitPos.y = Ray_Pos.y + Ray_Nrm.y * Distance
    HitPos.z = Ray_Pos.z + Ray_Nrm.z * Distance
ENDFUNCTION HitPos


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
FUNCTION RayVsPlaneY( Ray_Pos REF AS Vec3, Ray_Nrm REF AS Vec3,     //  Plane spans XZ.
                       PlnPosY AS FLOAT )
    HitPos AS Vec3
    Distance AS FLOAT: Distance = (PlnPosY - Ray_Pos.y) / Ray_Nrm.y
    IF (Distance < EPSILON): HitPos.x = MISS : EXITFUNCTION HitPos :ENDIF
    HitPos = add3( Ray_Pos, mul3f(Ray_Nrm,Distance) )
ENDFUNCTION HitPos


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
FUNCTION RayVsPlaneZ( Ray_Pos REF AS Vec3, Ray_Nrm REF AS Vec3,     //  Plane spans XY.
                       PlnPosZ AS FLOAT )
    HitPos AS Vec3
    Distance AS FLOAT: Distance = (PlnPosZ - Ray_Pos.z) / Ray_Nrm.z
    IF (Distance < EPSILON): HitPos.x = MISS : EXITFUNCTION HitPos :ENDIF
    HitPos = add3( Ray_Pos, mul3f(Ray_Nrm,Distance) )
ENDFUNCTION HitPos


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      PointVsBox( Point, BoxPosition, BoxSize )
//
FUNCTION PointVsBox(P REF AS Vec3,  Bp REF AS Vec3, Bs REF AS Vec3)
    IF (P.x >= Bp.x AND P.x < Bp.x+Bs.x) AND (P.y >= Bp.y AND P.y < Bp.y+Bs.y) AND (P.z >= Bp.z AND P.z < Bp.z+Bs.z) THEN EXITFUNCTION 1
ENDFUNCTION 0


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION RayVsBox(Rp REF AS Vec3, Rn REF AS Vec3,     Bp REF AS Vec3, Bs REF AS Vec3 )
    //  Does not Hit=True if Ray_Pos is inside Box.
    //@@    Do we want it to do so?

    //  Distance to bounds Planes from Ray_Pos, for 3 Axes Min & Max, 6 total.
    DstMinX AS FLOAT: DstMinX = (Bp.x      - Rp.x) / Rn.x  // We can avoid div here by using (1.0 / RayNormal).
    DstMaxX AS FLOAT: DstMaxX = (Bp.x+Bs.x - Rp.x) / Rn.x
    DstMinY AS FLOAT: DstMinY = (Bp.y      - Rp.y) / Rn.y
    DstMaxY AS FLOAT: DstMaxY = (Bp.y+Bs.y - Rp.y) / Rn.y
    DstMinZ AS FLOAT: DstMinZ = (Bp.z      - Rp.z) / Rn.z
    DstMaxZ AS FLOAT: DstMaxZ = (Bp.z+Bs.z - Rp.z) / Rn.z

    //       +Y  │      │
    //           │      │                                          +Y -Z (far)
    //       ────┼──────┼──── ◀── DstMaxY                           │ /
    //           │      │                                           │/
    //           │      │                            DstMinZ ──▶    +──── +X
    //           │      │                                          /
    //       ────┼──────┼──── ◀── DstMinY                         /
    //           │      │                                        /
    //       0   │      │  +X                    DstMaxZ ──▶   +Z (near)
    //           🡅
    //        DstMinX   🡅
    //               DstMaxX

    //  Reorient Min<──>Max relative to Ray_Pos.
    HoldMe AS FLOAT
    IF (DstMinX > DstMaxX):  HoldMe = DstMinX : DstMinX = DstMaxX : DstMaxX = HoldMe  :ENDIF // max(DstMinX, DstMaxX)
    IF (DstMinY > DstMaxY):  HoldMe = DstMinY : DstMinY = DstMaxY : DstMaxY = HoldMe  :ENDIF // max(DstMinY, DstMaxY)
    IF (DstMinZ > DstMaxZ):  HoldMe = DstMinZ : DstMinZ = DstMaxZ : DstMaxZ = HoldMe  :ENDIF // max(DstMinZ, DstMaxZ)

    //  Select PlaneHits in Quadrant/Octant of Box.
    DistFront AS FLOAT
    IF (DstMinX > DstMinY) // max(DstMinX, DstMinY)
        IF (DstMinX > DstMinZ): DistFront = DstMinX :ELSE: DistFront = DstMinZ :ENDIF // max(DstMinX, DstMinZ)
    ELSE
        IF (DstMinY > DstMinZ): DistFront = DstMinY :ELSE: DistFront = DstMinZ :ENDIF // max(DstMinY, DstMinZ)
    ENDIF

    DistBack AS FLOAT
    IF (DstMaxX < DstMaxY) // min(DstMaxX, DstMaxY)
        IF (DstMaxX < DstMaxZ): DistBack = DstMaxX :ELSE: DistBack = DstMaxZ :ENDIF // min(DstMaxX, DstMaxZ)
    ELSE
        IF (DstMaxY < DstMaxZ): DistBack = DstMaxY :ELSE: DistBack = DstMaxZ :ENDIF // min(DstMaxY, DstMaxZ)
    ENDIF

    //  Did we hit it?
    HitPos AS Vec3
    IF     (DistBack  <      0.0): HitPos.x = MISS //  Box is behind us.
    ELSEIF (DistFront > DistBack): HitPos.x = MISS //  Ray does not collide.
    ELSE
        HitPos.x = Rp.x + Rn.x*DistFront  //  Get HitPosition.
        HitPos.y = Rp.y + Rn.y*DistFront  //: HitPos   = add3( Ray_Pos, mul3f(Ray_Nrm,DistFront) )
        HitPos.z = Rp.z + Rn.z*DistFront
    ENDIF
ENDFUNCTION HitPos


//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION RayVsTriangle( Ray_Pos REF AS Vec3, Ray_Nrm REF AS Vec3, Ray_Len AS FLOAT,
                        TriVrt AS Vec3[], BackFaceTest AS INTEGER )
    HitPos AS Vec3

    TriVrt[1] = sub3(TriVrt[1], TriVrt[0])
    TriVrt[2] = sub3(TriVrt[2], TriVrt[0])

    Tri_Nrm AS Vec3 : Tri_Nrm = crs3(TriVrt[1], TriVrt[2])

    RayPosLocal AS Vec3 : RayPosLocal = sub3(TriVrt[0], Ray_Pos)

    Dtrmnt AS FLOAT: Dtrmnt = dot3(Ray_Nrm, Tri_Nrm)

    Crs_RPL_RN AS Vec3 : Crs_RPL_RN = crs3(RayPosLocal, Ray_Nrm)

    Dot_CrsRPLRN_V2 AS FLOAT
    Dot_CrsRPLRN_V1 AS FLOAT
    Dot_RPL_TN AS FLOAT
    IF Dtrmnt >= 0.0 // Ray is pointing same direction as TriangleNormal.
        IF NOT BackFaceTest : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
        Dot_CrsRPLRN_V2 =  dot3(Crs_RPL_RN,  TriVrt[2]) : IF (Dot_CrsRPLRN_V2 < 0.0  OR  Dot_CrsRPLRN_V2 > Dtrmnt)                          : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
        Dot_CrsRPLRN_V1 = -dot3(Crs_RPL_RN,  TriVrt[1]) : IF (Dot_CrsRPLRN_V1 < 0.0  OR  Dot_CrsRPLRN_V2 + Dot_CrsRPLRN_V1 > Dtrmnt)        : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
        Dot_RPL_TN      =  dot3(RayPosLocal, Tri_Nrm)   : IF (Dot_RPL_TN      < 0.0  OR  Dot_RPL_TN > Ray_Len*Dtrmnt  OR  Dtrmnt < EPSILON) : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
    ELSE // Ray is pointing opposite of TriangleNormal.
        Dot_CrsRPLRN_V2 =  dot3(Crs_RPL_RN,  TriVrt[2]) : IF (Dot_CrsRPLRN_V2 > 0.0  OR  Dot_CrsRPLRN_V2 < Dtrmnt)                          : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
        Dot_CrsRPLRN_V1 = -dot3(Crs_RPL_RN,  TriVrt[1]) : IF (Dot_CrsRPLRN_V1 > 0.0  OR  Dot_CrsRPLRN_V2 + Dot_CrsRPLRN_V1 < Dtrmnt)        : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
        Dot_RPL_TN      =  dot3(RayPosLocal, Tri_Nrm)   : IF (Dot_RPL_TN      > 0.0  OR  Dot_RPL_TN < Ray_Len*Dtrmnt)                       : HitPos.x = MISS : EXITFUNCTION HitPos : ENDIF
    ENDIF

    HitDist AS FLOAT: HitDist = Dot_RPL_TN * (1.0 / Dtrmnt)
    HitPos.x = Ray_Pos.x + (Ray_Nrm.x * HitDist)
    HitPos.y = Ray_Pos.y + (Ray_Nrm.y * HitDist)
    HitPos.z = Ray_Pos.z + (Ray_Nrm.z * HitDist)
ENDFUNCTION HitPos

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PointVsSphere( Pnt_Pos REF AS Vec3,
                        Sph_Pos REF AS Vec3, Sph_Rds AS FLOAT )
    Dlt_X AS FLOAT: Dlt_X = Sph_Pos.x - Pnt_Pos.x
    Dlt_Y AS FLOAT: Dlt_Y = Sph_Pos.y - Pnt_Pos.y
    Dlt_Z AS FLOAT: Dlt_Z = Sph_Pos.z - Pnt_Pos.z
ENDFUNCTION (Dlt_X*Dlt_X + Dlt_Y*Dlt_Y + Dlt_Z*Dlt_Z <= Sph_Rds*Sph_Rds)
