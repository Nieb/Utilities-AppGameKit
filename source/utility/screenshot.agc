//##############################################################################################################################################################
/*##############################################################################################################################################################
                                                                             Usage
    "Save_ScreenShot()" does NOT work with "Sync()"!
    Use "Draw*()" and/or "Render*()" with "Swap()" instead.

    "Save_ScreenShot()" must be called:
        AFTER  "Draw*()" and/or "Render*()" calls.
        BEFORE "Swap()"

    Use "SetFolder("")" or "SetFolder("media")" to save screenshots into Program's directory.

//==============================================================================================================================================================
                                                                            Examples
DO
    IF GetRawKeyPressed(KEY_F12) THEN Queue_ScreenShot()


    //  Do your thing here.


    Render2DBack()
    //RenderShadowMap()
    Render3D()
    Render2DFront()

    IF ScreenShot_Queued THEN Save_ScreenShot()

    Swap()
    ClearScreen()
LOOP

//--------------------------------------------------------------------------------------------------------------------------------------------------------------
DO
    IF GetRawKeyPressed(KEY_F12) THEN Queue_ScreenShot()


    //  Do your thing here.


    AGK_Render()
LOOP

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

//############################################################################################################################################################*/
//##############################################################################################################################################################
GLOBAL ScreenShot_Queued AS INTEGER

FUNCTION Queue_ScreenShot(): ScreenShot_Queued = 1 :ENDFUNCTION

FUNCTION Save_ScreenShot()
    //  Create an Image of the BackBuffer:
    ImgScreenshot AS INTEGER
    ImgScreenshot = GetImage(GetScreenBoundsLeft(), GetScreenBoundsTop(), GetScreenBoundsRight(), GetScreenBoundsBottom())

    FileName AS STRING
    FileName = GetCurrentDate() + "_" + GetCurrentTime() + ".png"
    FileName = ReplaceString(FileName, chr(58), chr(46), -1)
    SaveImage(ImgScreenshot, "screenshot/" + FileName)

    DeleteImage(ImgScreenshot)

    ScreenShot_Queued = 0
ENDFUNCTION
