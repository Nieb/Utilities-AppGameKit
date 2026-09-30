//##############################################################################################################################################################
//##############################################################################################################################################################
#Constant INT_MIN = 0x80000000 // -2,147,483,648
#Constant INT_MAX = 0x7FFFFFFF //  2,147,483,647

#Constant INT_Baf = 0xbafff1ed //   -989,852,142    3,137,335,789
#Constant INT_Ded = 0xdeadbeef // -1,588,444,912    3,735,928,559

//  3-bit Int
//  0  1  2  3  4  5  6  7  Unsigned    [   4s  2s  1s ]
//  0  1  2  3 -4 -3 -2 -1  Signed      [ Sign  2s  1s ]

//##############################################################################################################################################################
//##############################################################################################################################################################
//  For explicit casting:
FUNCTION int(x AS FLOAT)
    Result AS INTEGER: Result = trunc(x)
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION clamp(ClampMe AS INTEGER, ClampMin AS INTEGER, ClampMax AS INTEGER)
    IF     (ClampMe < ClampMin): EXITFUNCTION ClampMin
    ELSEIF (ClampMe > ClampMax): EXITFUNCTION ClampMax
    ENDIF
ENDFUNCTION ClampMe

//==============================================================================================================================================================
FUNCTION wrap(WrapMe AS INTEGER, WrapMin AS INTEGER, WrapMax AS INTEGER)
    IF (WrapMe >= WrapMin AND WrapMe < WrapMax) THEN EXITFUNCTION WrapMe
    WrapMe  = WrapMe  - WrapMin
    WrapMax = WrapMax - WrapMin
    IF     (WrapMe <        0): WrapMe = WrapMin + WrapMax + mod(WrapMe, WrapMax)
    ELSEIF (WrapMe >= WrapMax): WrapMe = WrapMin +           mod(WrapMe, WrapMax)
    ENDIF
ENDFUNCTION WrapMe

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION min(IntA AS INTEGER, IntB AS INTEGER): IF (IntA < IntB) THEN EXITFUNCTION IntA : ENDFUNCTION IntB
FUNCTION max(IntA AS INTEGER, IntB AS INTEGER): IF (IntA > IntB) THEN EXITFUNCTION IntA : ENDFUNCTION IntB

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION sign(SignMe AS INTEGER)
    IF (SignMe < 0) THEN EXITFUNCTION -1
ENDFUNCTION 1

//##############################################################################################################################################################
//##############################################################################################################################################################
//FUNCTION CountTowards( CountFrom AS INTEGER, CountTo AS INTEGER)
//    IF CountFrom = CountTo THEN EXITFUNCTION CountTo
//    CountNew AS INTEGER
//    IF CountFrom < CountTo : CountNew = CountFrom +  ceil((CountTo - CountFrom) * (0.07 * Time.Multiplier)) // Count Up.
//    ELSE                   : CountNew = CountFrom + floor((CountTo - CountFrom) * (0.07 * Time.Multiplier)) // Count Down.
//    ENDIF
//ENDFUNCTION CountNew
