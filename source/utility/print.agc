//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Print1(Label AS STRING, PrintMe AS FLOAT, PadLeft AS INTEGER, FractionalDigits AS INTEGER)
    Print(Label + padstr(PrintMe, PadLeft, FractionalDigits))
ENDFUNCTION

FUNCTION Print2(Label AS STRING, PrintMe REF AS vec2, PadLeft AS INTEGER, FractionalDigits AS INTEGER)
    Print(Label + padstr(PrintMe.x, PadLeft, FractionalDigits)+" "+padstr(PrintMe.y, PadLeft, FractionalDigits))
ENDFUNCTION

FUNCTION Print3(Label AS STRING, PrintMe REF AS vec3, PadLeft AS INTEGER, FractionalDigits AS INTEGER)
    Print(Label + padstr(PrintMe.x, PadLeft, FractionalDigits)+" "+padstr(PrintMe.y, PadLeft, FractionalDigits)+" "+padstr(PrintMe.z, PadLeft, FractionalDigits))
ENDFUNCTION

FUNCTION Print4(Label AS STRING, PrintMe REF AS vec4, PadLeft AS INTEGER, FractionalDigits AS INTEGER)
    Print(Label + padstr(PrintMe.x, PadLeft, FractionalDigits)+" "+padstr(PrintMe.y, PadLeft, FractionalDigits)+" "+padstr(PrintMe.z, PadLeft, FractionalDigits)+" "+padstr(PrintMe.w, PadLeft, FractionalDigits))
ENDFUNCTION

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PrintColor(Label AS STRING, PrintMe REF AS RGBA)
    Print(Label + padstr(PrintMe.r, 3, 0)+" "+padstr(PrintMe.g, 3, 0)+" "+padstr(PrintMe.b, 3, 0)+" "+padstr(PrintMe.a, 3, 0))
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION PrintColorf(Label AS STRING, PrintMe REF AS RGBAf, TruncRight AS INTEGER)
    Print(Label + padstr(PrintMe.r, 1, TruncRight)+" "+padstr(PrintMe.g, 1, TruncRight)+" "+padstr(PrintMe.b, 1, TruncRight)+" "+padstr(PrintMe.a, 1, TruncRight))
ENDFUNCTION
