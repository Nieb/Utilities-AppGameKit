//##############################################################################################################################################################
//##############################################################################################################################################################
TYPE Canvas
    SizX AS INTEGER
    SizY AS INTEGER

    StpY AS INTEGER //  Memblock Byte-Step size.

    iMEM AS AGK_MemBlock
    iIMG AS AGK_Image
    iSPR AS AGK_Sprite
ENDTYPE
#Constant MEM_IMG_HEADER_SIZE = 12


//==============================================================================================================================================================
//
//      MyCanvas AS Canvas: MyCanvas = CreateCanvas(0, 0,  256, 256)
//
FUNCTION CreateCanvas(PosX AS INTEGER, PosY AS INTEGER,  SizX AS INTEGER, SizY AS INTEGER)
    this AS Canvas
    this.SizX = SizX
    this.SizY = SizY
    this.StpY = SizX*4
    this.iMEM = CreateMemblock(MEM_IMG_HEADER_SIZE+(SizX*SizY*4))
        // HEADER
        SetMemblockInt(this.iMEM, 0, SizX) // SizeX.
        SetMemblockInt(this.iMEM, 4, SizY) // SizeY.
        SetMemblockInt(this.iMEM, 8,   32) // BitDepth.
    this.iIMG = CreateImageFromMemblock(this.iMEM)
    this.iSPR = CreateSprite(this.iIMG)
        SetSpritePosition(this.iSPR, PosX, PosY)
        SetSpriteSize(this.iSPR, SizX, SizY)
ENDFUNCTION this


//==============================================================================================================================================================
FUNCTION DestroyCanvas(this REF AS Canvas)
    this.SizX = 0
    this.SizY = 0
    this.StpY = 0
    DeleteMemblock(this.iMEM) : this.iMEM = 0
    DeleteSprite(this.iSPR)   : this.iSPR = 0
    DeleteImage(this.iIMG)    : this.iIMG = 0
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Canvas_SetPixel(this REF AS Canvas,    iX AS INTEGER, iY AS INTEGER,    ClrABGR AS INTEGER)
    SetMemblockInt(this.iMEM, MEM_IMG_HEADER_SIZE + (iY*this.StpY) + (iX*4), ClrABGR)
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Canvas_CommitChanges(this REF AS Canvas)
    DeleteImage(this.iIMG)
    this.iIMG = CreateImageFromMemblock(this.iMEM)
    SetSpriteImage(this.iSPR, this.iIMG)
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION Canvas_RevertChanges(this REF AS Canvas)
    DeleteMemblock(this.iMEM)
    this.iMEM = CreateMemblockFromImage(this.iIMG)
ENDFUNCTION


//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Canvas_SaveImage(this REF AS Canvas, FileName AS STRING)
    SaveImage(this.iIMG, FileName)
ENDFUNCTION

