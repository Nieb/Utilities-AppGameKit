//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Resize2(this REF AS INTEGER[][], sX AS INTEGER, sY AS INTEGER)
    this.length = -1
    this.length = sX

    iY AS INTEGER
    FOR iY = 0 TO sX
        this[iY].length = sY
    NEXT iY
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION Resize3(this REF AS INTEGER[][][], sX AS INTEGER, sY AS INTEGER, sZ AS INTEGER)
    this.length = -1
    this.length = sX

    iY AS INTEGER
    iZ AS INTEGER
    FOR iY = 0 TO sX
        this[iY].length = sY
        FOR iZ = 0 TO sY
            this[iY,iZ].length = sZ
        NEXT iZ
    NEXT iY
ENDFUNCTION

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Mean(this REF AS INTEGER[])
    Sum AS INTEGER : Sum = 0
    i AS INTEGER
    FOR i = 0 TO this.length
        Sum = Sum + this[i]
    NEXT i
ENDFUNCTION Sum / (this.length + 1.0)

//==============================================================================================================================================================
FUNCTION Median(this AS INTEGER[])
    this.sort()
    IF mod(this.length+1,2) // Odd or even?  ZeroInclusive.
        // Odd:
        EXITFUNCTION this[ (this.length + 1) / 2 ]
    ELSE
        // Even:
        EXITFUNCTION (this[ floor(this.length / 2.0) ] + this[ ceil(this.length / 2.0) ]) / 2.0
    ENDIF
ENDFUNCTION 0.0

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Shuffle(this REF AS INTEGER[])
    i AS INTEGER
    FOR i = 0 TO this.length-1
        this.swap(i, random(i,this.length)) // Swap current item with any item AFTER it, including itself.
    NEXT i
ENDFUNCTION

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION PurgeDuplicates(this REF AS INTEGER[])
    this.sort()
    i AS INTEGER
    FOR i = this.length TO 1 STEP -1
        IF this[i] = this[i-1] THEN this.remove(i)
    NEXT i
ENDFUNCTION
