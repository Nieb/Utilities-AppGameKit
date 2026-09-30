//##############################################################################################################################################################
//##############################################################################################################################################################
TYPE vec3
    x AS FLOAT
    y AS FLOAT
    z AS FLOAT
ENDTYPE

FUNCTION vec3(X AS FLOAT, Y AS FLOAT, Z AS FLOAT)
    Result AS vec3
    Result.x = X
    Result.y = Y
    Result.z = Z
ENDFUNCTION Result

//==============================================================================================================================================================
TYPE ivec3
    x AS INTEGER
    y AS INTEGER
    z AS INTEGER
ENDTYPE

FUNCTION ivec3(X AS INTEGER, Y AS INTEGER, Z AS INTEGER)
    Result AS ivec3
    Result.x = X
    Result.y = Y
    Result.z = Z
ENDFUNCTION Result

//==============================================================================================================================================================
FUNCTION InitializeVector3()
    //  AGK does not support default values for UserTypes.
    GLOBAL Zero3     AS vec3: Zero3     = vec3(0.0, 0.0, 0.0)
    GLOBAL Axis3_X   AS vec3: Axis3_X   = vec3(1.0, 0.0, 0.0)
    GLOBAL Axis3_Y   AS vec3: Axis3_Y   = vec3(0.0, 1.0, 0.0)
    GLOBAL Axis3_Z   AS vec3: Axis3_Z   = vec3(0.0, 0.0, 1.0)

    GLOBAL Axis3_XY  AS vec3: Axis3_XY  = vec3(Sqrt2Rcp, Sqrt2Rcp,      0.0)
    GLOBAL Axis3_YZ  AS vec3: Axis3_YZ  = vec3(     0.0, Sqrt2Rcp, Sqrt2Rcp)
    GLOBAL Axis3_XZ  AS vec3: Axis3_XZ  = vec3(Sqrt2Rcp,      0.0, Sqrt2Rcp)

    GLOBAL Axis3_XYZ AS vec3: Axis3_XYZ = vec3(Sqrt3Rcp, Sqrt3Rcp, Sqrt3Rcp)
ENDFUNCTION

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                    Arithmetic Operators
FUNCTION add3( A AS vec3, B REF AS vec3):  A.x=(A.x+B.x)  :  A.y=(A.y+B.y)  :  A.z=(A.z+B.z)  :ENDFUNCTION A
FUNCTION add3f(A AS vec3, B    AS FLOAT):  A.x=(A.x+B  )  :  A.y=(A.y+B  )  :  A.z=(A.z+B  )  :ENDFUNCTION A

FUNCTION sub3( A AS vec3, B REF AS vec3):  A.x=(A.x-B.x)  :  A.y=(A.y-B.y)  :  A.z=(A.z-B.z)  :ENDFUNCTION A
FUNCTION sub3f(A AS vec3, B    AS FLOAT):  A.x=(A.x-B  )  :  A.y=(A.y-B  )  :  A.z=(A.z-B  )  :ENDFUNCTION A

FUNCTION mul3( A AS vec3, B REF AS vec3):  A.x=(A.x*B.x)  :  A.y=(A.y*B.y)  :  A.z=(A.z*B.z)  :ENDFUNCTION A
FUNCTION mul3f(A AS vec3, B    AS FLOAT):  A.x=(A.x*B  )  :  A.y=(A.y*B  )  :  A.z=(A.z*B  )  :ENDFUNCTION A

FUNCTION div3( A AS vec3, B REF AS vec3):  A.x=(A.x/B.x)  :  A.y=(A.y/B.y)  :  A.z=(A.z/B.z)  :ENDFUNCTION A
FUNCTION div3f(A AS vec3, B    AS FLOAT):  A.x=(A.x/B  )  :  A.y=(A.y/B  )  :  A.z=(A.z/B  )  :ENDFUNCTION A

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                       "Dot" Product
FUNCTION dot3(A REF AS vec3, B REF AS vec3):ENDFUNCTION (A.x*B.x + A.y*B.y + A.z*B.z)

//==============================================================================================================================================================
//                                                                      "Cross" Product
FUNCTION crs3(A REF AS vec3, B REF AS vec3): R AS vec3:  R.x=(A.y*B.z - A.z*B.y)  :  R.y=(A.z*B.x - A.x*B.z)  :  R.z=(A.x*B.y - A.y*B.x)  :ENDFUNCTION R

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION inv3(A AS vec3):  A.x=(   -A.x)  :  A.y=(   -A.y)  :  A.z=(   -A.z)  :ENDFUNCTION A //  "Invert"       Additive Inverse            AKA: Negation

FUNCTION cmp3(A AS vec3):  A.x=(1.0-A.x)  :  A.y=(1.0-A.y)  :  A.z=(1.0-A.z)  :ENDFUNCTION A //  "Complement"   Complimentary Inverse

FUNCTION rcp3(A AS vec3):  A.x=(1.0/A.x)  :  A.y=(1.0/A.y)  :  A.z=(1.0/A.z)  :ENDFUNCTION A //  "Reciprocal"   Multiplicative Inverse

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                          "Length"                AKA: Distance from (0,0,0)
FUNCTION len3(A AS vec3)
    A.x = sqrt(A.x*A.x + A.y*A.y + A.z*A.z)
ENDFUNCTION A.x

//==============================================================================================================================================================
//                                                                         "Distance"
FUNCTION dst3(A AS vec3, B REF AS vec3)
    A.x = B.x - A.x // "Delta_X"
    A.y = B.y - A.y // "Delta_Y"
    A.z = B.z - A.z // "Delta_Z"
    A.x = sqrt(A.x*A.x + A.y*A.y + A.z*A.z) // "Result"
ENDFUNCTION A.x

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                         "Lengthen"               'A' scaled to 'LengthNew'.
FUNCTION lenthn3(A AS vec3, LengthNew AS FLOAT)
    IF NOT (A.x = 0.0 AND A.y = 0.0 AND A.z = 0.0) // Avoid Divide-by-Zero.
        LengthNew = LengthNew/sqrt(A.x*A.x + A.y*A.y + A.z*A.z) //  (LengthNew / LengthOld)
        A.x = A.x * LengthNew
        A.y = A.y * LengthNew
        A.z = A.z * LengthNew
    ENDIF
ENDFUNCTION A

//==============================================================================================================================================================
//                                                                        "Normalize"               'A' scaled to length of 1.0.
FUNCTION nrm3(A AS vec3)
    IF NOT (A.x = 0.0 AND A.y = 0.0 AND A.z = 0.0) // Avoid Divide-by-Zero.
        Length AS FLOAT: Length = 1.0/sqrt(A.x*A.x + A.y*A.y + A.z*A.z) //  (LengthNew / LengthOld)
        A.x = A.x * Length
        A.y = A.y * Length
        A.z = A.z * Length
    ENDIF
ENDFUNCTION A

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                           "Floor"                Each component rounded down.
FUNCTION flr3(A AS vec3)
    A.x = floor(A.x)
    A.y = floor(A.y)
    A.z = floor(A.z)
ENDFUNCTION A

//==============================================================================================================================================================
//                                                                          "Ceiling"               Each component rounded up.
FUNCTION cil3(A AS vec3)
    A.x = ceil(A.x)
    A.y = ceil(A.y)
    A.z = ceil(A.z)
ENDFUNCTION A

//==============================================================================================================================================================
//                                                                           "Round"                Each component rounded to nearest Integer.
FUNCTION rnd3(A AS vec3)
    A.x = round(A.x)
    A.y = round(A.y)
    A.z = round(A.z)
ENDFUNCTION A

//==============================================================================================================================================================
//                                                                         "Round To"               Each component rounded to nearest multiple of 'RoundTo'.
FUNCTION rndto3(A REF AS vec3, RoundTo AS FLOAT)
    Result AS vec3
    Result.x = fmod(A.x, RoundTo)
    Result.y = fmod(A.y, RoundTo)
    Result.z = fmod(A.z, RoundTo)
    Threshold AS FLOAT: Threshold = RoundTo * 0.5
    IF     (Result.x > 0.0): IF (Result.x >=  Threshold): Result.x = A.x + RoundTo -     Result.x  :ELSE: Result.x = A.x -     Result.x  :ENDIF
    ELSEIF (Result.x < 0.0): IF (Result.x <= -Threshold): Result.x = A.x - RoundTo + abs(Result.x) :ELSE: Result.x = A.x + abs(Result.x) :ENDIF
    ELSE                                                : Result.x = A.x
    ENDIF
    IF     (Result.y > 0.0): IF (Result.y >=  Threshold): Result.y = A.y + RoundTo -     Result.y  :ELSE: Result.y = A.y -     Result.y  :ENDIF
    ELSEIF (Result.y < 0.0): IF (Result.y <= -Threshold): Result.y = A.y - RoundTo + abs(Result.y) :ELSE: Result.y = A.y + abs(Result.y) :ENDIF
    ELSE                                                : Result.y = A.y
    ENDIF
    IF     (Result.z > 0.0): IF (Result.z >=  Threshold): Result.z = A.z + RoundTo -     Result.z  :ELSE: Result.z = A.z -     Result.z  :ENDIF
    ELSEIF (Result.z < 0.0): IF (Result.z <= -Threshold): Result.z = A.z - RoundTo + abs(Result.z) :ELSE: Result.z = A.z + abs(Result.z) :ENDIF
    ELSE                                                : Result.z = A.z
    ENDIF
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                       "Average" of 2
FUNCTION avg3_2(A AS vec3, B REF AS vec3)
    A.x = (A.x + B.x) * 0.5
    A.y = (A.y + B.y) * 0.5
    A.z = (A.z + B.z) * 0.5
ENDFUNCTION A

//==============================================================================================================================================================
//                                                                       "Average" of 3
FUNCTION avg3_3(A AS vec3, B REF AS vec3, C REF AS vec3)
    A.x = (A.x + B.x + C.x) * ONETHIRD
    A.y = (A.y + B.y + C.y) * ONETHIRD
    A.z = (A.z + B.z + C.z) * ONETHIRD
ENDFUNCTION A

//==============================================================================================================================================================
//                                                                       "Average" of 4
FUNCTION avg3_4(A AS vec3, B REF AS vec3, C REF AS vec3, D REF AS vec3)
    A.x = (A.x + B.x + C.x + D.x) * 0.25
    A.y = (A.y + B.y + C.y + D.y) * 0.25
    A.z = (A.z + B.z + C.z + D.z) * 0.25
ENDFUNCTION A

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                         "Reflect"
//
//      ref3(  A,  Surface-Normal  )
//
FUNCTION ref3(A REF AS vec3, Sn REF AS vec3)
    Dot AS FLOAT: Dot = (A.x*Sn.x + A.y*Sn.y + A.z*Sn.z)
    Result AS vec3
    Result.x = A.x + (Sn.x * Dot * -2.0)
    Result.y = A.y + (Sn.y * Dot * -2.0)
    Result.z = A.z + (Sn.z * Dot * -2.0)
ENDFUNCTION Result

//==============================================================================================================================================================
//                                                                         "Deflect"
FUNCTION def3(A REF AS vec3, Sn REF AS vec3)
    Dot AS FLOAT: Dot = (A.x*Sn.x + A.y*Sn.y + A.z*Sn.z)
    Result AS vec3
    Result.x = (Sn.x * Dot * 2.0) - A.x
    Result.y = (Sn.y * Dot * 2.0) - A.y
    Result.z = (Sn.z * Dot * 2.0) - A.z
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                        "Projection"              Get ClosestPointOnLine.
FUNCTION prj3(P REF AS vec3, La REF AS vec3, Lb REF AS vec3)
    dAP_X AS FLOAT: dAP_X = P.x - La.x
    dAP_Y AS FLOAT: dAP_Y = P.y - La.y
    dAP_Z AS FLOAT: dAP_Z = P.z - La.z

    dAB_X AS FLOAT: dAB_X = Lb.x - La.x
    dAB_Y AS FLOAT: dAB_Y = Lb.y - La.y
    dAB_Z AS FLOAT: dAB_Z = Lb.z - La.z

    Dot_AP_AB       AS FLOAT: Dot_AP_AB       = (dAP_X * dAB_X) + (dAP_Y * dAB_Y) + (dAP_Z * dAB_Z)
    dAB_Length_Sqrd AS FLOAT: dAB_Length_Sqrd = (dAB_X * dAB_X) + (dAB_Y * dAB_Y) + (dAB_Z * dAB_Z)

    //  Distance to NearestPointOnLine, from 'La' as multiple of 'dAB':
    Dist AS FLOAT: Dist = Dot_AP_AB / dAB_Length_Sqrd

    Result AS vec3
    Result.x = La.x + (dAB_X * Dist)
    Result.y = La.y + (dAB_Y * Dist)
    Result.z = La.z + (dAB_Z * Dist)
ENDFUNCTION Result

//==============================================================================================================================================================
//
//  prj3n(  Point,  Line-Position,  Line-Normal  )
//
FUNCTION prj3n(P REF AS vec3, Lp REF AS vec3, Ln REF AS vec3)
    Dist AS FLOAT: Dist = ((P.x - Lp.x) * Ln.x) + ((P.y - Lp.y) * Ln.y) + ((P.z - Lp.z) * Ln.z)
    Result AS vec3
    Result.x = Lp.x + (Ln.x * Dist)
    Result.y = Lp.y + (Ln.y * Dist)
    Result.z = Lp.z + (Ln.z * Dist)
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION RandomVec3(Signed AS INTEGER)
    Pch AS FLOAT
    Yaw AS FLOAT

    IF (Signed)
        Pch = (0.0 + Random2(0x80000001, 0x7FFFFFFF)) / 0x7FFFFFFF //  -1 to 1
        Yaw = (0.0 + Random2(0x80000001, 0x7FFFFFFF)) / 0x7FFFFFFF
    ELSE
        Pch = (0.0 + Random2(0x00000000, 0x7FFFFFFF)) / 0x7FFFFFFF //   0 to 1
        Yaw = (0.0 + Random2(0x00000000, 0x7FFFFFFF)) / 0x7FFFFFFF
    ENDIF

    Pch = asinrad(Pch)
    Yaw = Yaw * Pi

    CosPch AS FLOAT: CosPch = cosrad(Pch)

    Result AS vec3
    Result.x =  sinrad(Yaw) *  CosPch
    Result.y = -sinrad(Pch)
    Result.z =  cosrad(Yaw) * -CosPch
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION FromPch(Theta AS FLOAT)
    Theta = -Theta //  Theta is clockwise.
    Result AS vec3 //  Result will be on plane spanning ZY.
    Result.x =  0.0
    Result.y =  sin(Theta)
    Result.z = -cos(Theta)
ENDFUNCTION Result

FUNCTION FromYaw(Theta AS FLOAT)
    Theta = -Theta //  Theta is clockwise.
    Result AS vec3 //  Result will be on plane spanning XZ.
    Result.x =  cos(Theta)
    Result.y = 0.0
    Result.z = -sin(Theta)
ENDFUNCTION Result

FUNCTION FromRol(Theta AS FLOAT)
    Theta = -Theta //  Theta is clockwise.
    Result AS vec3 //  Result will be on plane spanning XY.
    Result.x = cos(Theta)
    Result.y = sin(Theta)
    Result.z = 0.0
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Pitch & Yaw are clockwise.  Z is inverted.
//      FromPitchYaw( 0,  0)  ==  ( 0, 0,-1)
//      FromPitchYaw(90,  0)  ==  ( 0,-1, 0)
//      FromPitchYaw( 0, 90)  ==  ( 1, 0, 0)
//
FUNCTION FromPitchYaw(Pch AS FLOAT, Yaw AS FLOAT)
    Result AS vec3
    Result.y = cos(Pch)

    Result.x =  Result.y * sin(Yaw)
    Result.z = -Result.y * cos(Yaw)
    Result.y =            -sin(Pch)
ENDFUNCTION Result

//==============================================================================================================================================================
//
//  Rotation(Pitch, Yaw, 0)    FROM    Direction(X, Y, Z)
//
FUNCTION RotFromDir(V AS vec3)
    Result AS vec3
    V.z = -V.z

    //  Pitch:
    Result.x = atan2(-V.y, sqrt(V.x*V.x + V.z*V.z))

    //  Yaw:
    IF (abs(Result.x) >= (PIH-EPSILON))
        Result.y = 0.0
    ELSE
        Result.y = wrapf(atan2(V.x, V.z), 0.0, PI2)
    ENDIF
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                           "Pitch"
//
//      pch3(  Point,  Theta  )
//
FUNCTION pch3(P REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    Result AS vec3
    Result.x =      P.x                                 //  1.0*P.x +  0.0*P.y +   0.0*P.z
    Result.y = CosT*P.y + -SinT*P.z                     //  0.0*P.x + CosT*P.y + -SinT*P.z
    Result.z = SinT*P.y +  CosT*P.z                     //  0.0*P.x + SinT*P.y +  CosT*P.z
ENDFUNCTION Result

//==============================================================================================================================================================
//
//      pch3p(  Point,  Pivot,  Theta  )
//
FUNCTION pch3p(P REF AS vec3, V REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    dY AS FLOAT: dY = P.y - V.y
    dZ AS FLOAT: dZ = P.z - V.z

    Result AS vec3
    Result.x = P.x                                      //  V.x  +  1.0*dX +  0.0*dY +   0.0*dZ
    Result.y = V.y  +  CosT*dY + -SinT*dZ               //  V.y  +  0.0*dX + CosT*dY + -SinT*dZ
    Result.z = V.z  +  SinT*dY +  CosT*dZ               //  V.z  +  0.0*dX + SinT*dY +  CosT*dZ
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                            "Yaw"
//
//      yaw3(  Point,  Theta  )
//
FUNCTION yaw3(P REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    Result AS vec3
    Result.x =  CosT*P.x + SinT*P.z                     //   CosT*P.x + 0.0*P.y + SinT*P.z
    Result.y =       P.y                                //    0.0*P.x + 1.0*P.y +  0.0*P.z
    Result.z = -SinT*P.x + CosT*P.z                     //  -SinT*P.x + 0.0*P.y + CosT*P.z
ENDFUNCTION Result

//==============================================================================================================================================================
//
//      yaw3p(  Point,  Pivot,  Theta  )
//
FUNCTION yaw3p(P REF AS vec3, V REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    dX AS FLOAT: dX = P.x - V.x
    dZ AS FLOAT: dZ = P.z - V.z

    Result AS vec3
    Result.x = V.x  +   CosT*dX + SinT*dZ               //  V.x  +   CosT*dX + 0.0*dY + SinT*dZ
    Result.y = P.y                                      //  V.y  +    0.0*dX + 1.0*dY +  0.0*dZ
    Result.z = V.z  +  -SinT*dX + CosT*dZ               //  V.z  +  -SinT*dX + 0.0*dY + CosT*dZ
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                           "Roll"
//
//      rol3(  Point,  Theta  )
//
FUNCTION rol3(P REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    Result AS vec3
    Result.x = CosT*P.x + -SinT*P.y                     //  CosT*P.x + -SinT*P.y + 0.0*P.z
    Result.y = SinT*P.x +  CosT*P.y                     //  SinT*P.x +  CosT*P.y + 0.0*P.z
    Result.z =      P.z                                 //   0.0*P.x +   0.0*P.y + 1.0*P.z
ENDFUNCTION Result

//==============================================================================================================================================================
//
//      rol3p(  Point,  Pivot,  Theta  )
//
FUNCTION rol3p(P REF AS vec3, V REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    dX AS FLOAT: dX = P.x - V.x
    dY AS FLOAT: dY = P.y - V.y

    Result AS vec3
    Result.x = V.x  +  CosT*dX + -SinT*dY               //  V.x  +  CosT*dX + -SinT*dY + 0.0*dZ
    Result.y = V.y  +  SinT*dX +  CosT*dY               //  V.y  +  SinT*dX +  CosT*dY + 0.0*dZ
    Result.z = P.z                                      //  V.z  +   0.0*dX +   0.0*dY + 1.0*dZ
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//                                                                         "Rotation"
//
//      rot3(  Point,  Axis,  Theta  )
//
FUNCTION rot3(P REF AS vec3, A REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
     CosT AS FLOAT:  CosT = cos(Theta)
    iCosT AS FLOAT: iCosT = 1.0-CosT
     SinT AS FLOAT:  SinT = sin(Theta)

    Result AS vec3
    Result.x = P.x*(A.x*A.x*iCosT +     CosT)  +  P.y*(A.y*A.x*iCosT - A.z*SinT)  +  P.z*(A.z*A.x*iCosT + A.y*SinT)
    Result.y = P.x*(A.x*A.y*iCosT + A.z*SinT)  +  P.y*(A.y*A.y*iCosT +     CosT)  +  P.z*(A.z*A.y*iCosT - A.x*SinT)
    Result.z = P.x*(A.x*A.z*iCosT - A.y*SinT)  +  P.y*(A.y*A.z*iCosT + A.x*SinT)  +  P.z*(A.z*A.z*iCosT +     CosT)
ENDFUNCTION Result

//==============================================================================================================================================================
//
//      rot3p(  Point,  Pivot,  Axis,  Theta  )
//
FUNCTION rot3p(P REF AS vec3, V REF AS vec3, A REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0) THEN EXITFUNCTION P

    Theta = -Theta //  Theta is clockwise.
     CosT AS FLOAT:  CosT = cos(Theta)
    iCosT AS FLOAT: iCosT = 1.0-CosT
     SinT AS FLOAT:  SinT = sin(Theta)

    //  Point in Pivot LocalSpace:
    dX AS FLOAT: dX = P.x - V.x
    dY AS FLOAT: dY = P.y - V.y
    dZ AS FLOAT: dZ = P.z - V.z

    Result AS vec3
    Result.x = V.x  +  dX*(A.x*A.x * iCosT +     CosT)  +  dY*(A.y*A.x * iCosT - A.z*SinT)  +  dZ*(A.z*A.x * iCosT + A.y*SinT)
    Result.y = V.y  +  dX*(A.x*A.y * iCosT + A.z*SinT)  +  dY*(A.y*A.y * iCosT +     CosT)  +  dZ*(A.z*A.y * iCosT - A.x*SinT)
    Result.z = V.z  +  dX*(A.x*A.z * iCosT - A.y*SinT)  +  dY*(A.y*A.z * iCosT + A.x*SinT)  +  dZ*(A.z*A.z * iCosT +     CosT)
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Simultaneous Multi-Axis Rotation.
//
//      rot3m(  Point,  Theta(Pitch, Yaw, Roll)  )
//
FUNCTION rot3m(P REF AS vec3, ThetaV REF AS vec3)
    IF (ThetaV.x = 0.0 AND ThetaV.y = 0.0 AND ThetaV.z = 0.0) THEN EXITFUNCTION P

    //  Derive singular rotation Theta. (Length of 'ThetaV'.)
    Theta AS FLOAT: Theta = -sqrt(ThetaV.x*ThetaV.x + ThetaV.y*ThetaV.y + ThetaV.z*ThetaV.z) //  Theta is clockwise.

    //  Derive singular rotation Axis. ('ThetaV' normalized.)
    ThetaRcp AS FLOAT: ThetaRcp = 1.0 / Theta
    Ax AS FLOAT: Ax = ThetaV.x * ThetaRcp
    Ay AS FLOAT: Ay = ThetaV.y * ThetaRcp
    Az AS FLOAT: Az = ThetaV.z * ThetaRcp

     CosT AS FLOAT:  CosT = cos(Theta)
    iCosT AS FLOAT: iCosT = 1.0-CosT
     SinT AS FLOAT:  SinT = sin(Theta)

    Result AS vec3
    Result.x = P.x*(Ax*Ax * iCosT +    CosT)  +  P.y*(Ay*Ax * iCosT - Az*SinT)  +  P.z*(Az*Ax * iCosT + Ay*SinT)
    Result.y = P.x*(Ax*Ay * iCosT + Az*SinT)  +  P.y*(Ay*Ay * iCosT +    CosT)  +  P.z*(Az*Ay * iCosT - Ax*SinT)
    Result.z = P.x*(Ax*Az * iCosT - Ay*SinT)  +  P.y*(Ay*Az * iCosT + Ax*SinT)  +  P.z*(Az*Az * iCosT +    CosT)
ENDFUNCTION Result
