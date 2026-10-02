//##############################################################################################################################################################
//##############################################################################################################################################################
#Option_Explicit
SetErrorMode(2)
SetFolder("")

SetWindowTitle("AGK Utilities -- Build Test")
SetWindowAllowResize(0)

       SetWindowSize(1024, 768, 0)
SetVirtualResolution(1024, 768)

SetClearColor(74,50,75)

LoadFont(1, "media/ui/font/Hack-Regular.ttf")
SetPrintFont(1)
SetPrintSize(24)
SetPrintColor(240, 240, 240)


//  Garbage in, garbage out.
//      There are typically no validation checks on function parameters.
//      Use this library at your own peril.


//==============================================================================================================================================================
//InitializeColor()
InitializeFloat()
InitializeVector2()
InitializeVector3()

InitializeCollision3()

InitializePrintA() : SetPrintAFont(1)

MainLoop()
END


//##############################################################################################################################################################
//##############################################################################################################################################################
#Include "main_loop.agc"

#Include "source/utility/AGK_const.agc"
#Include "source/utility/AGK_imgui.agc"
#Include "source/utility/AGK_print_anywhere.agc"
#Include "source/utility/canvas.agc"
#Include "source/utility/collision1.agc"
#Include "source/utility/collision2.agc"
#Include "source/utility/collision3.agc"
#Include "source/utility/color.agc"
#Include "source/utility/data.agc"
#Include "source/utility/draw2.agc"
#Include "source/utility/draw3.agc"
#Include "source/utility/input_const.agc"
#Include "source/utility/input_mouse.agc"
#Include "source/utility/math.agc"
#Include "source/utility/math_const.agc"
#Include "source/utility/print.agc"
#Include "source/utility/screenshot.agc"
#Include "source/utility/shader.agc"
#Include "source/utility/time.agc"
#Include "source/utility/type_array.agc"
#Include "source/utility/type_color.agc"
#Include "source/utility/type_float.agc"
#Include "source/utility/type_integer.agc"
#Include "source/utility/type_string.agc"
#Include "source/utility/type_vector2.agc"
#Include "source/utility/type_vector3.agc"
#Include "source/utility/type_vector4.agc"
#Include "source/utility/type_matrix4.agc"

