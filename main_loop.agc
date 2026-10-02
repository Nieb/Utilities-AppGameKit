//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION MainLoop()
    DO
        IF GetRawKeyPressed(KEY_Escape) THEN END

        Print("")
        Print("")
        Print("        FPS: "+str(ScreenFPS(),3)+"  "+str(GetFrameTime()) )
        Print("")
        Print("")
        Print("            It works!")
        Print("")
        Print("")

        IF 1
            Millis AS INTEGER: Millis = GetMilliseconds()
            Clr AS INTEGER: Clr = 0xFF000000
            Clr = Clr + (round( (sin(Millis*1.6) * 0.5 + 0.5) * 255 )<<16)
            Clr = Clr + (round( (sin(Millis*0.7) * 0.5 + 0.5) * 255 )<< 8)
            Clr = Clr +  round( (sin(Millis*1.0) * 0.5 + 0.5) * 255 )
            PrintA("BLARG!", 0, cos(Millis*0.1)*250+512, sin(Millis*0.2)*250+384, 32, Clr)
            DrawPrintA()
        ENDIF
        IF 0
            Mx    AS FLOAT: Mx    = GetRawMouseX()*0.01 - 5.0
            MxW_0 AS FLOAT: MxW_0 = wrapf(Mx-5.0, 1.25, 2.25)
            MxW_1 AS FLOAT: MxW_1 = wrapf(Mx    , 1.25, 2.25)

            DrawLine_(vec2(500, 490), vec2(500, 510), 0xFFEEEEEE) //   0
            DrawLine_(vec2(625, 490), vec2(625, 510), 0xFFEEEEEE) //  +1.5
            DrawLine_(vec2(725, 490), vec2(725, 510), 0xFFEEEEEE) //  +2.5
            PrintA("0"   , 1, 500, 520, 24, 0xFFEEEEEE)
            PrintA("1.25", 1, 625, 520, 24, 0xFFEEEEEE)
            PrintA("2.25", 1, 725, 520, 24, 0xFFEEEEEE)

            DrawPoint(vec2(Mx   *100+500, 490), 3.0, 0xFF0000EE) // Red
            DrawPoint(vec2(MxW_0*100+500, 500), 3.0, 0xFF10EE10) // Grn
            DrawPoint(vec2(MxW_1*100+500, 510), 3.0, 0xFFFF7000) // Blu
            PrintA(str(Mx,2), 1, Mx*100+500, 456, 24, 0xFFEEEEEE)

            DrawPrintA()
        ENDIF
        IF 0
            Print2(" FromAngle(  0) = ", FromAngle(  0), 2, 6)
            Print2(" FromAngle( 90) = ", FromAngle( 90), 2, 6)
            Print2(" FromAngle(180) = ", FromAngle(180), 2, 6)
            Print2(" FromAngle(270) = ", FromAngle(270), 2, 6)
        ENDIF

    IF GetRawKeyPressed(KEY_F12) THEN Queue_ScreenShot()

        AGK_Render()
        //Sync()

    LOOP
ENDFUNCTION

FUNCTION AGK_Render()
    Render2DBack()          //  Draw ALL 2D things that are set to "Visible" and behind "SetGlobal3DDepth(100)".

    //RenderShadowMap()     //  Must be called if using 3D ShadowMapping.
    Render3D()              //  Draw ALL 3D things that are set to "Visible".

    //IF ScreenShot_Queued THEN Save_ScreenShot()   Place here if you don't want GUI stuff in your 3D-scene screenshot.

    Render2DFront()         //  Draw ALL 2D things that are set to "Visible" and infront of "SetGlobal3DDepth(100)".

    IF ScreenShot_Queued THEN Save_ScreenShot()

    Swap()
    ClearScreen()
ENDFUNCTION
