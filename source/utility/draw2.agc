//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  If "DRAW2_INVERT_Y = true", then use this:
//
//      SetViewOffset(0, -VirtualResolutionY)
//
GLOBAL DRAW2_INVERT_Y AS INTEGER = 0

//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      DrawPoint(  Point,  Size,  ColorABGR  )
//
FUNCTION DrawPoint(P REF AS Vec2, Ps AS FLOAT, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawEllipse(P.x, P.y,  Ps,Ps,  C,C, 1)
    ELSE                   : DrawEllipse(P.x,-P.y,  Ps,Ps,  C,C, 1)
    ENDIF
ENDFUNCTION

//==============================================================================================================================================================
//
//  Works with SetViewOffset(X, Y).
//
//      DrawPointV(  Point,  Size,  ColorABGR  )
//
FUNCTION DrawPointV(P REF AS Vec2, Ps AS FLOAT, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawEllipse( WorldToScreenX(P.x),WorldToScreenY( P.y),  Ps,Ps,  C,C, 1 )
    ELSE                   : DrawEllipse( WorldToScreenX(P.x),WorldToScreenY(-P.y),  Ps,Ps,  C,C, 1 )
    ENDIF
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      DrawPixel(  PixelCoord,  ColorABGR  )
//
FUNCTION DrawPixel(P REF AS Vec2, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawBox( floor(P.x),  floor(P.y),  floor(P.x)+0.99,  floor(P.y)+0.99,  C,C,C,C, 1 )
    ELSE                   : DrawBox( floor(P.x), -floor(P.y),  floor(P.x)+0.99, -floor(P.y)-0.99,  C,C,C,C, 1 )
    ENDIF
ENDFUNCTION

//==============================================================================================================================================================
//
//      DrawPixel2(  PixelCoord,  ColorABGR  )
//
FUNCTION DrawPixel2(P REF AS Vec2, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawEllipse( floor(P.x)+0.5, floor(P.y)+0.5,  0.4,0.4,  C,C, 1 )
    ELSE                   : DrawEllipse( floor(P.x)+0.5,-floor(P.y)-0.5,  0.4,0.4,  C,C, 1 )
    ENDIF
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      DrawLine_(  LinePointA,  LinePointB,  ColorABGR  )
//
FUNCTION DrawLine_(La REF AS Vec2, Lb REF AS Vec2, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawLine( La.x, La.y,  Lb.x, Lb.y,  C,C )
    ELSE                   : DrawLine( La.x,-La.y,  Lb.x,-Lb.y,  C,C )
    ENDIF
ENDFUNCTION

//==============================================================================================================================================================
//  Works with SetViewOffset(X, Y).
//
//      DrawLineV(  LinePointA,  LinePointB,  ColorABGR  )
//
FUNCTION DrawLineV(La REF AS Vec2, Lb REF AS Vec2, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawLine( WorldToScreenX(La.x),WorldToScreenY( La.y),  WorldToScreenX(Lb.x),WorldToScreenY( Lb.y),  C,C )
    ELSE                   : DrawLine( WorldToScreenX(La.x),WorldToScreenY(-La.y),  WorldToScreenX(Lb.x),WorldToScreenY(-Lb.y),  C,C )
    ENDIF
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION DrawLineC(La REF AS Vec2, Lb REF AS Vec2, Clr REF AS RGBA)
    C AS INTEGER: C = (Clr.a << 24) + (Clr.b << 16) + (Clr.g <<  8) + Clr.r
    IF NOT (DRAW2_INVERT_Y): DrawLine( La.x, La.y,  Lb.x, Lb.y,  C,C )
    ELSE                   : DrawLine( La.x,-La.y,  Lb.x,-Lb.y,  C,C )
    ENDIF
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
//
//      DrawCircle(  CirclePosition,  CircleRadius,  ColorABGR  )
//
FUNCTION DrawCircle(Cp REF AS Vec2, Cr AS FLOAT, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawEllipse( Cp.x,  Cp.y,  Cr,Cr,  C,C,  0 )
    ELSE                   : DrawEllipse( Cp.x, -Cp.y,  Cr,Cr,  C,C,  0 )
    ENDIF
ENDFUNCTION

//==============================================================================================================================================================
//
//      DrawCircleV(  CirclePosition,  CircleRadius,  ColorABGR  )
//
FUNCTION DrawCircleV(Cp REF AS Vec2, Cr AS FLOAT, C AS INTEGER)
    IF NOT (DRAW2_INVERT_Y): DrawEllipse( WorldToScreenX(Cp.x), WorldToScreenY( Cp.y),  Cr,Cr,  C,C,  0 )
    ELSE                   : DrawEllipse( WorldToScreenX(Cp.x), WorldToScreenY(-Cp.y),  Cr,Cr,  C,C,  0 )
    ENDIF
ENDFUNCTION
