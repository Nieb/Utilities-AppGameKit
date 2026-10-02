//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION GetBit(IntVar AS INTEGER, iBit AS INTEGER)
    IF iBit < 0 OR iBit > 31 THEN EXITFUNCTION 0
ENDFUNCTION (IntVar >> iBit) && %1

//==============================================================================================================================================================
FUNCTION SetBit(IntVar AS INTEGER, iBit AS INTEGER, SetTo AS INTEGER)
    IF iBit  < 0 OR iBit  > 31 THEN EXITFUNCTION 0
    IF SetTo < 0 OR SetTo >  1 THEN EXITFUNCTION 0
    IntVar = IntVar &&   !(%1 << iBit) // Zero target bit via mask.
ENDFUNCTION  IntVar || (SetTo << iBit) // Set bit.

//==============================================================================================================================================================
FUNCTION ToggleBit(IntVar AS INTEGER, iBit AS INTEGER)
    IF iBit < 0 OR iBit > 31 THEN EXITFUNCTION 0
ENDFUNCTION IntVar ~~ (%1 << iBit)


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION GetTubit(IntVar AS INTEGER, iTubit AS INTEGER)
    IF iTubit < 0 OR iTubit > 15 THEN EXITFUNCTION 0
ENDFUNCTION (IntVar >> (2*iTubit)) && %11

//==============================================================================================================================================================
FUNCTION SetTubit(IntVar AS INTEGER, iTubit AS INTEGER, SetTo AS INTEGER)
    IF iTubit < 0 OR iTubit > 15 THEN EXITFUNCTION 0
    IF SetTo  < 0 OR SetTo  >  3 THEN EXITFUNCTION 0
    IntVar = IntVar &&  !(%11 << iTubit*2) // Zero target bits via mask.
ENDFUNCTION  IntVar || (SetTo << iTubit*2) // Set Tubit.


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION GetNibble(IntVar AS INTEGER, iNibble AS INTEGER)
    IF iNibble < 0 OR iNibble > 7 THEN EXITFUNCTION 0
ENDFUNCTION (IntVar >> (4*iNibble)) && %1111

//==============================================================================================================================================================
FUNCTION SetNibble(IntVar AS INTEGER, iNibble AS INTEGER, SetTo AS INTEGER)
    IF iNibble < 0 OR iNibble >  7 THEN EXITFUNCTION 0
    IF SetTo   < 0 OR SetTo   > 15 THEN EXITFUNCTION 0
    IntVar = IntVar && !(%1111 << iNibble*4) // Zero target bits via mask.
ENDFUNCTION  IntVar ||  (SetTo << iNibble*4) // Set Nibble.


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION GetByte(IntVar AS INTEGER, iByte AS INTEGER)
    IF iByte < 0 OR iByte > 3 THEN EXITFUNCTION 0
ENDFUNCTION (IntVar >> (8*iByte)) && %11111111

//==============================================================================================================================================================
FUNCTION SetByte(IntVar AS INTEGER, iByte AS INTEGER, SetTo AS INTEGER)
    IF iByte < 0 OR iByte >         3 THEN EXITFUNCTION 0
    IF SetTo < 0 OR SetTo > %11111111 THEN EXITFUNCTION 0
    IntVar = IntVar && !(%11111111 << iByte*8) // Zero target bits via mask.
ENDFUNCTION  IntVar ||      (SetTo << iByte*8) // Set Byte.


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION GetShort(IntVar AS INTEGER, iShort AS INTEGER)
    IF     iShort = 0 : EXITFUNCTION (IntVar && 0x0000FFFF)
    ELSEIF iShort = 1 : EXITFUNCTION (IntVar && 0xFFFF0000) >> 16
    ENDIF
ENDFUNCTION 0

//==============================================================================================================================================================
FUNCTION SetShort(IntVar AS INTEGER, iShort AS INTEGER, SetTo AS INTEGER)
    IF SetTo  < 0 OR SetTo  > 0x0000FFFF THEN EXITFUNCTION 0
    //                               Zero target bits via mask. Set Short.
    IF     iShort = 0 : EXITFUNCTION (IntVar && 0xFFFF0000) ||  SetTo
    ELSEIF iShort = 1 : EXITFUNCTION (IntVar && 0x0000FFFF) || (SetTo << 16)
    ENDIF
ENDFUNCTION 0
