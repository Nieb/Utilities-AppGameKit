//##############################################################################################################################################################
//##############################################################################################################################################################
TYPE mat4
//     Col 0         Col 1         Col 2         Col 3
    xx AS FLOAT:  yx AS FLOAT:  zx AS FLOAT:  wx AS FLOAT //  Row 0
    xy AS FLOAT:  yy AS FLOAT:  zy AS FLOAT:  wy AS FLOAT //  Row 1
    xz AS FLOAT:  yz AS FLOAT:  zz AS FLOAT:  wz AS FLOAT //  Row 2
    xw AS FLOAT:  yw AS FLOAT:  zw AS FLOAT:  ww AS FLOAT //  Row 3
ENDTYPE

//==============================================================================================================================================================
FUNCTION mat4(XX AS FLOAT, YX AS FLOAT, ZX AS FLOAT, WX AS FLOAT,
              XY AS FLOAT, YY AS FLOAT, ZY AS FLOAT, WY AS FLOAT,
              XZ AS FLOAT, YZ AS FLOAT, ZZ AS FLOAT, WZ AS FLOAT,
              XW AS FLOAT, YW AS FLOAT, ZW AS FLOAT, WW AS FLOAT)
    this AS mat4
    this.xx=XX: this.yx=YX: this.zx=ZX: this.wx=WX
    this.xy=XY: this.yy=YY: this.zy=ZY: this.wy=WY
    this.xz=XZ: this.yz=YZ: this.zz=ZZ: this.wz=WZ
    this.xw=XW: this.yw=YW: this.zw=ZW: this.ww=WW
ENDFUNCTION this

FUNCTION Mat4_Zero()
    this AS mat4
    this.xx=0.0: this.yx=0.0: this.zx=0.0: this.wx=0.0
    this.xy=0.0: this.yy=0.0: this.zy=0.0: this.wy=0.0
    this.xz=0.0: this.yz=0.0: this.zz=0.0: this.wz=0.0
    this.xw=0.0: this.yw=0.0: this.zw=0.0: this.ww=0.0
ENDFUNCTION this

FUNCTION Mat4_Identity()
    this AS mat4
    this.xx=1.0: this.yx=0.0: this.zx=0.0: this.wx=0.0
    this.xy=0.0: this.yy=1.0: this.zy=0.0: this.wy=0.0
    this.xz=0.0: this.yz=0.0: this.zz=1.0: this.wz=0.0
    this.xw=0.0: this.yw=0.0: this.zw=0.0: this.ww=1.0
ENDFUNCTION this

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      Result = (Mat * Mat)
//
FUNCTION MUL_MatMat(A AS mat4, B AS mat4)
    Result AS mat4
    Result.xx = A.xx*B.xx + A.yx*B.xy + A.zx*B.xz + A.wx*B.xw   // XX = dot( A.Row0, B.Col0 )
    Result.yx = A.xx*B.yx + A.yx*B.yy + A.zx*B.yz + A.wx*B.yw   // YX = dot( A.Row0, B.Col1 )
    Result.zx = A.xx*B.zx + A.yx*B.zy + A.zx*B.zz + A.wx*B.zw   // ZX = dot( A.Row0, B.Col2 )
    Result.wx = A.xx*B.wx + A.yx*B.wy + A.zx*B.wz + A.wx*B.ww   // WX = dot( A.Row0, B.Col3 )

    Result.xy = A.xy*B.xx + A.yy*B.xy + A.zy*B.xz + A.wy*B.xw   // XY
    Result.yy = A.xy*B.yx + A.yy*B.yy + A.zy*B.yz + A.wy*B.yw   // YY
    Result.zy = A.xy*B.zx + A.yy*B.zy + A.zy*B.zz + A.wy*B.zw   // ZY
    Result.wy = A.xy*B.wx + A.yy*B.wy + A.zy*B.wz + A.wy*B.ww   // WY

    Result.xz = A.xz*B.xx + A.yz*B.xy + A.zz*B.xz + A.wz*B.xw   // XZ
    Result.yz = A.xz*B.yx + A.yz*B.yy + A.zz*B.yz + A.wz*B.yw   // YZ
    Result.zz = A.xz*B.zx + A.yz*B.zy + A.zz*B.zz + A.wz*B.zw   // ZZ
    Result.wz = A.xz*B.wx + A.yz*B.wy + A.zz*B.wz + A.wz*B.ww   // WZ

    Result.xw = A.xw*B.xx + A.yw*B.xy + A.zw*B.xz + A.ww*B.xw   // XW
    Result.yw = A.xw*B.yx + A.yw*B.yy + A.zw*B.yz + A.ww*B.yw   // YW
    Result.zw = A.xw*B.zx + A.yw*B.zy + A.zw*B.zz + A.ww*B.zw   // ZW
    Result.ww = A.xw*B.wx + A.yw*B.wy + A.zw*B.wz + A.ww*B.ww   // WW
ENDFUNCTION Result

//==============================================================================================================================================================
//
//                                     Vx    Vy    Vz    Vw   |
//                                  --------------------------+----
//                                     Mxx + Myx + Mzx + Mwx  | Rx
//                                                            |
//                                     Mxy + Myy + Mzy + Mwy  | Ry
//      Result = (Vec * Mat)                                  |
//                                     Mxz + Myz + Mzz + Mwz  | Rz
//                                                            |
//                                     Mxw + Myw + Mzw + Mww  | Rw
//                                                            |
//
FUNCTION MUL_VecMat(V AS vec4, M AS mat4)
    Result AS vec4
    Result.x = V.x*M.xx + V.y*M.yx + V.z*M.zx + V.w*M.wx
    Result.y = V.x*M.xy + V.y*M.yy + V.z*M.zy + V.w*M.wy
    Result.z = V.x*M.xz + V.y*M.yz + V.z*M.zz + V.w*M.wz
    Result.w = V.x*M.xw + V.y*M.yw + V.z*M.zw + V.w*M.ww
ENDFUNCTION Result

//==============================================================================================================================================================
//
//                                      |
//                                   Vx |  Mxx   Myx   Mzx   Mwx
//                                      |   +     +     +     +
//                                   Vy |  Mxy   Myy   Mzy   Mwy
//      Result = (Mat * Vec)            |   +     +     +     +
//                                   Vz |  Mxz   Myz   Mzz   Mwz
//                                      |   +     +     +     +
//                                   Vw |  Mxw   Myw   Mzw   Mww
//                                  ----+-------------------------
//                                      |  Rx    Ry    Rz    Rw
//
FUNCTION MUL_MatVec(M AS mat4, V AS vec4)
    Result AS vec4
    Result.x = V.x*M.xx + V.x*M.xy + V.x*M.xz + V.x*M.xw
    Result.y = V.y*M.yx + V.y*M.yy + V.y*M.yz + V.y*M.yw
    Result.z = V.z*M.zx + V.z*M.zy + V.z*M.zz + V.z*M.zw
    Result.w = V.w*M.wx + V.w*M.wy + V.w*M.wz + V.w*M.ww
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION mPch(Theta AS FLOAT)
    IF (Theta = 0.0)
        Result = Mat4_Identity()
        EXITFUNCTION Result
    ENDIF

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    Result AS mat4
    Result.xx = 1:  Result.yx =     0:  Result.zx =     0:  Result.wx = 0
    Result.xy = 0:  Result.yy =  CosT:  Result.zy = -SinT:  Result.wy = 0
    Result.xz = 0:  Result.yz =  SinT:  Result.zz =  CosT:  Result.wz = 0
    Result.xw = 0:  Result.yw =     0:  Result.zw =     0:  Result.ww = 1
ENDFUNCTION Result

//==============================================================================================================================================================
FUNCTION mYaw(Theta AS FLOAT)
    IF (Theta = 0.0)
        Result = Mat4_Identity()
        EXITFUNCTION Result
    ENDIF

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    Result AS mat4
    Result.xx =  CosT:  Result.yx = 0:  Result.zx = SinT:  Result.wx = 0
    Result.xy =     0:  Result.yy = 1:  Result.zy =    0:  Result.wy = 0
    Result.xz = -SinT:  Result.yz = 0:  Result.zz = CosT:  Result.wz = 0
    Result.xw =     0:  Result.yw = 0:  Result.zw =    0:  Result.ww = 1
ENDFUNCTION Result

//==============================================================================================================================================================
FUNCTION mRol(Theta AS FLOAT)
    IF (Theta = 0.0)
        Result = Mat4_Identity()
        EXITFUNCTION Result
    ENDIF

    Theta = -Theta //  Theta is clockwise.
    CosT AS FLOAT: CosT = cos(Theta)
    SinT AS FLOAT: SinT = sin(Theta)

    Result AS mat4
    Result.xx = CosT:  Result.yx = -SinT:  Result.zx = 0:  Result.wx = 0
    Result.xy = SinT:  Result.yy =  CosT:  Result.zy = 0:  Result.wy = 0
    Result.xz =    0:  Result.yz =     0:  Result.zz = 1:  Result.wz = 0
    Result.xw =    0:  Result.yw =     0:  Result.zw = 0:  Result.ww = 1
ENDFUNCTION Result

//==============================================================================================================================================================
FUNCTION mRot(A REF AS vec3, Theta AS FLOAT)
    IF (Theta = 0.0)
        Result = Mat4_Identity()
        EXITFUNCTION Result
    ENDIF

    Theta = -Theta //  Theta is clockwise.
     CosT AS FLOAT:  CosT = cos(Theta)
    iCosT AS FLOAT: iCosT = 1.0-CosT
     SinT AS FLOAT:  SinT = sin(Theta)

    Result AS mat4
    Result.xx = (A.x*A.x*iCosT +     CosT):  Result.yx = (A.y*A.x*iCosT - A.z*SinT):  Result.zx = (A.z*A.x*iCosT + A.y*SinT):  Result.wx = 0
    Result.xy = (A.x*A.y*iCosT + A.z*SinT):  Result.yy = (A.y*A.y*iCosT +     CosT):  Result.zy = (A.z*A.y*iCosT - A.x*SinT):  Result.wy = 0
    Result.xz = (A.x*A.z*iCosT - A.y*SinT):  Result.yz = (A.y*A.z*iCosT + A.x*SinT):  Result.zz = (A.z*A.z*iCosT +     CosT):  Result.wz = 0
    Result.xw =                          0:  Result.yw =                          0:  Result.zw =                          0:  Result.ww = 1
ENDFUNCTION Result
