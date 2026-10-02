//##############################################################################################################################################################
//##############################################################################################################################################################
TYPE _Mouse_
    Pos     AS Vec2
    PosOld  AS Vec2
    PosLock AS Vec2
    Delta   AS Vec2

    Lock AS INTEGER

    //Ray AS Ray
    RayPos    AS Vec3
    RayNrm    AS Vec3
    RayNrmRcp AS Vec3 // "Reciprocal"

    //Visible AS INTEGER = 1   // AGK does not support initialized values in UserTypes.
ENDTYPE
GLOBAL Mouse AS _Mouse_


//  https://learn.microsoft.com/en-us/windows/win32/dxtecharts/taking-advantage-of-high-dpi-mouse-movement?redirectedfrom=MSDN#WM_INPUT


//##############################################################################################################################################################
//##############################################################################################################################################################
GLOBAL _____MouseVisible AS INTEGER = 1
FUNCTION SetMouseVisible(SetTo AS INTEGER)
    IF     (SetTo = 1 AND _____MouseVisible = 0) : _____MouseVisible = 1 : SetRawMouseVisible(1)
    ELSEIF (SetTo = 0 AND _____MouseVisible = 1) : _____MouseVisible = 0 : SetRawMouseVisible(0)
    ENDIF
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION SetMouseLock(SetTo AS INTEGER)
    IF SetTo
        Mouse.Lock = 1
        Mouse.PosLock.x = GetRawMouseX()
        Mouse.PosLock.y = GetRawMouseY()
    ELSE
        Mouse.Lock = 0
        Mouse.PosLock.x = 0.0
        Mouse.PosLock.y = 0.0
    ENDIF
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION UpdateMouseRay()
    Mouse.RayPos.x =  GetCameraX(1)
    Mouse.RayPos.y =  GetCameraY(1)
    Mouse.RayPos.z = -GetCameraZ(1) // Z is inverted.

    Mouse.RayNrm.x =  Get3DVectorXFromScreen(Mouse.Pos.x, Mouse.Pos.y)
    Mouse.RayNrm.y =  Get3DVectorYFromScreen(Mouse.Pos.x, Mouse.Pos.y)
    Mouse.RayNrm.z = -Get3DVectorZFromScreen(Mouse.Pos.x, Mouse.Pos.y) // Z is inverted.

    Mouse.RayNrmRcp.x = 1.0/Mouse.RayNrm.x
    Mouse.RayNrmRcp.y = 1.0/Mouse.RayNrm.y
    Mouse.RayNrmRcp.z = 1.0/Mouse.RayNrm.z
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION UpdateInputMouse()
    IF Mouse.Lock
        Mouse.Pos.x = GetRawMouseX()
        Mouse.Pos.y = GetRawMouseY()

        SetRawMousePosition(Mouse.PosLock.x, Mouse.PosLock.y)

        Mouse.PosOld.x = GetRawMouseX()
        Mouse.PosOld.y = GetRawMouseY()
    ELSE
        Mouse.PosOld.x = Mouse.Pos.x
        Mouse.PosOld.y = Mouse.Pos.y

        Mouse.Pos.x = GetRawMouseX()
        Mouse.Pos.y = GetRawMouseY()
    ENDIF
    Mouse.Delta.x = Mouse.Pos.x - Mouse.PosOld.x
    Mouse.Delta.y = Mouse.Pos.y - Mouse.PosOld.y

    UpdateMouseRay()
ENDFUNCTION
