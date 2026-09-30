//##############################################################################################################################################################
//##############################################################################################################################################################
#Constant NL = chr(10) // "NewLine"
//#Constant BR = chr(10) // Line "Break"

//==============================================================================================================================================================
//#Constant StrLeft(          = Left(
//#Constant StrRight(         = Right(
//#Constant StrSearch(        = FindString(
//#Constant StrSearchReverse( = FindStringReverse(

//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Convert to STRING, then pad left with Spaces.
//
//      "PadLeft" pads the integer-part, from the decimal.  Is effectively decimal-point aligned.
//      "TruncRight = -1"  will show all fractional digits.
//
FUNCTION PadStr(StringMe AS FLOAT, PadLeft AS INTEGER, TruncRight AS INTEGER)
    Result AS STRING: Result = str(StringMe, TruncRight)

    StringLength AS INTEGER
    IF (TruncRight = 0): StringLength = len(Result)
    ELSE               : StringLength = len(TruncateString(str(StringMe),".")) //  Length of integer-part of float.
    ENDIF

    IF (StringLength >= PadLeft) THEN EXITFUNCTION Result //  Prevent Spaces() crash.

    Result = Spaces(PadLeft-StringLength) + Result
ENDFUNCTION Result

//==============================================================================================================================================================
//
//  Convert to STRING, then pad left with 'PadWith'.
//
FUNCTION PadStrWith(StringMe AS FLOAT, PadLeft AS INTEGER, TruncRight AS INTEGER, PadWith AS STRING)
    Result AS STRING: Result = str(StringMe, TruncRight)

    StringLength AS INTEGER
    IF (TruncRight = 0): StringLength = len(Result)
    ELSE               : StringLength = len(TruncateString(str(StringMe),".")) //  Length of integer-part of float.
    ENDIF

    IF (StringLength >= PadLeft) THEN EXITFUNCTION Result //  Prevent Spaces() crash.

    PadWith = Right(PadWith,1) //  Insure PadWith is a single character?
    PadWith = ReplaceString(Spaces(PadLeft-StringLength), " ", PadWith, -1)

    Result = PadWith + Result
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Convert to Hex-STRING, then pad left with "0x" and "0"s.
//
FUNCTION Hex2(StringMe AS INTEGER, PadLeft AS INTEGER)
    Result AS STRING: Result = hex(StringMe)

    StringLength AS INTEGER: StringLength = len(Result)

    IF (StringLength >= PadLeft) THEN EXITFUNCTION "0x"+Result //  Prevent spaces() crash.

    Result = "0x"+ReplaceString(Spaces(PadLeft-StringLength)," ","0",-1) + Result
ENDFUNCTION Result

//==============================================================================================================================================================
//
//  Convert to Hex-STRING, then pad left with "0"s.
//
FUNCTION Hex3(StringMe AS INTEGER, PadLeft AS INTEGER)
    Result AS STRING: Result = hex(StringMe)

    StringLength AS INTEGER: StringLength = len(Result)

    IF (StringLength >= PadLeft) THEN EXITFUNCTION Result //  Prevent spaces() crash.

    Result = ReplaceString(Spaces(PadLeft-StringLength)," ","0",-1) + Result
ENDFUNCTION Result

//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  Convert to STRING, then insert 'Comma' every 3 digits.
//
FUNCTION CommaDelimit(StringMe AS INTEGER)
    Result       AS STRING  : Result       = ""
    NumberString AS STRING  : NumberString = str(StringMe)
    NumberLength AS INTEGER : NumberLength = len(NumberString)
    iDigit       AS INTEGER
    IF (StringMe >= -999 AND StringMe <= 999)
        Result = str(StringMe)
    ELSEIF (StringMe < 0)
        FOR iDigit = 1 TO NumberLength
            Result = mid(NumberString, NumberLength-iDigit+1, 1) + Result
            IF NOT (mod(iDigit,3) OR iDigit >= NumberLength-1) THEN Result = "," + Result
        NEXT iDigit
    ELSE
        FOR iDigit = 1 TO NumberLength
            Result = mid(NumberString, NumberLength-iDigit+1, 1) + Result
            IF NOT (mod(iDigit,3) OR iDigit >= NumberLength) THEN Result = "," + Result
        NEXT iDigit
    ENDIF
ENDFUNCTION Result

//==============================================================================================================================================================
//
//  Convert to STRING, then insert 'Comma' every 3 digits, then pad left with 'Spaces'.
//
FUNCTION PadCommaDelimit(StringMe AS INTEGER, PadLeft AS INTEGER)
    Result       AS STRING  : Result       = ""
    NumberString AS STRING  : NumberString = str(StringMe)
    NumberLength AS INTEGER : NumberLength = len(NumberString)
    iDigit       AS INTEGER
    IF (StringMe >= -999 AND StringMe <= 999)
        Result = str(StringMe)
    ELSEIF (StringMe < 0)
        FOR iDigit = 1 TO NumberLength
            Result = mid(NumberString, NumberLength-iDigit+1, 1) + Result
            IF NOT (mod(iDigit,3) OR iDigit >= NumberLength-1) THEN Result = "," + Result           //  Handles "-,123" case???
        NEXT iDigit
    ELSE
        FOR iDigit = 1 TO NumberLength
            Result = mid(NumberString, NumberLength-iDigit+1, 1) + Result
            IF NOT (mod(iDigit,3) OR iDigit >= NumberLength) THEN Result = "," + Result
        NEXT iDigit
    ENDIF
    ResultLength AS INTEGER: ResultLength = len(Result)
    IF ResultLength >= PadLeft THEN EXITFUNCTION Result //  Prevent spaces() crash.
    Result = Spaces(PadLeft-ResultLength) + Result
ENDFUNCTION Result
