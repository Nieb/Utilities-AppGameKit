//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  For use with   SetShaderConstantByName(ShdrID, "UniformName", 1, 2, N_A, N_A)
//
#Constant N_A = 0.0

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION LoadGLSL(FilePath AS STRING)
    IF NOT GetFileExists(FilePath)
        Message("Error!" + chr(10)+chr(10) + "LoadGLSL("+chr(34)+FilePath+chr(34)+")" + chr(10)+chr(10) + "File not found.")
        EXITFUNCTION 0

    ELSE
        ShdrFile     AS INTEGER : ShdrFile     = OpenToRead(FilePath)
        ShdrFileSize AS INTEGER : ShdrFileSize = GetFileSize(ShdrFile)
        ShdrFileLine AS STRING  = ""

        ShdrVert  AS STRING  = ""
        ShdrFrag  AS STRING  = ""
        FoundVert AS INTEGER = 0
        FoundFrag AS INTEGER = 0

        DO
            IF GetFilePos(ShdrFile) >= ShdrFileSize THEN EXIT

            ShdrFileLine = ReadLine(ShdrFile)

            IF     FindString( ShdrFileLine, "//BEGIN_VERT" ) = 1 AND FoundVert
                Message("Error!" + chr(10)+chr(10) + "LoadGLSL("+chr(34)+FilePath+chr(34)+")" + chr(10)+chr(10) + "Found '//BEGIN_VERT' more than once.")
                CloseFile(ShdrFile)
                EXITFUNCTION 0
            ELSEIF FindString( ShdrFileLine, "//BEGIN_VERT" ) = 1 AND NOT FoundVert
                FoundVert = 1
                CONTINUE
            ELSEIF FindString( ShdrFileLine, "//BEGIN_FRAG" ) = 1 AND FoundFrag
                Message("Error!" + chr(10)+chr(10) + "LoadGLSL("+chr(34)+FilePath+chr(34)+")" + chr(10)+chr(10) + "Found '//BEGIN_FRAG' more than once.")
                CloseFile(ShdrFile)
                EXITFUNCTION 0
            ELSEIF FindString( ShdrFileLine, "//BEGIN_FRAG" ) = 1 AND NOT FoundFrag AND NOT FoundVert
                Message("Error!" + chr(10)+chr(10) + "LoadGLSL("+chr(34)+FilePath+chr(34)+")" + chr(10)+chr(10) + "Found '//BEGIN_FRAG' before '//BEGIN_VERT'." + chr(10)+chr(10) + "'//BEGIN_VERT' must be first.")
                CloseFile(ShdrFile)
                EXITFUNCTION 0
            ELSEIF FindString( ShdrFileLine, "//BEGIN_FRAG" ) = 1 AND NOT FoundFrag
                FoundFrag = 1
                CONTINUE
            ELSEIF FindString( ShdrFileLine, "//" ) = 1
                CONTINUE // Ignore commented lines.
            ELSEIF Len( ShdrFileLine ) <= 0
                CONTINUE // Ignore empty lines.
            ELSEIF FoundFrag
                ShdrFrag = ShdrFrag + ShdrFileLine + chr(10)
                CONTINUE
            ELSEIF FoundVert
                ShdrVert = ShdrVert + ShdrFileLine + chr(10)
                CONTINUE
            ELSE
                CONTINUE // We haven't found either BEGIN yet.
            ENDIF
        LOOP

        IF NOT FoundVert : Message("Error!" + chr(10)+chr(10) + "LoadGLSL("+chr(34)+FilePath+chr(34)+")" + chr(10)+chr(10) + "Failed to find '//BEGIN_VERT'.") : CloseFile(ShdrFile) : EXITFUNCTION 0 : ENDIF
        IF NOT FoundFrag : Message("Error!" + chr(10)+chr(10) + "LoadGLSL("+chr(34)+FilePath+chr(34)+")" + chr(10)+chr(10) + "Failed to find '//BEGIN_FRAG'.") : CloseFile(ShdrFile) : EXITFUNCTION 0 : ENDIF

        IF 0 // Debug
            ShdrVert = ReplaceString( ShdrVert, " ", "•", -1 )
            ShdrFrag = ReplaceString( ShdrFrag, " ", "•", -1 )
            ShdrVert = ReplaceString( ShdrVert, chr(10), "¶"+chr(10), -1 )
            ShdrFrag = ReplaceString( ShdrFrag, chr(10), "¶"+chr(10), -1 )
            DO
                Print("===============================================================================")
                Print(ShdrVert)
                Print("===============================================================================")
                Print(ShdrFrag)
                Print("===============================================================================")
                Sync()
                ClearScreen()
                ClearDepthBuffer()
            LOOP
        ENDIF

        iShdr AS INTEGER: iShdr = LoadShaderFromString(ShdrVert, ShdrFrag)
        EXITFUNCTION iShdr
    ENDIF
ENDFUNCTION 0

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION DumpObjectShader(ObjID AS INTEGER)
    FileName AS STRING
    FileName = "shaderdump__obj" + str(ObjID) + "__" + GetCurrentDate() + "_" + GetCurrentTime() + ".glsl"
    FileName = ReplaceString( FileName , chr(58) , chr(46) , -1 ) // Replace ":" with ".", ":" is not allowed in file names.
    FileID AS INTEGER
    FileID = OpenToWrite(FileName, 0)  // ( FileNameString, Replace|Append )
    WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
    WriteLine(FileID, "//BEGIN_VERT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
    WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
    WriteLine(FileID,  GetObjectMeshVSSource(ObjID,1)  )
    WriteLine(FileID, "")
    WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
    WriteLine(FileID, "//BEGIN_FRAG///////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
    WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
    WriteLine(FileID,  GetObjectMeshPSSource(ObjID,1)  )
    CloseFile(FileID)
ENDFUNCTION

//==============================================================================================================================================================
FUNCTION DumpObjectShaderMulti(ObjID AS INTEGER)
    iMesh AS INTEGER
    FOR iMesh = 1 TO GetObjectNumMeshes( ObjID )
        FileName AS STRING
        FileName = "shaderdump__obj" + str(ObjID) + "_mesh" + str(iMesh) + "__" + GetCurrentDate() + "_" + GetCurrentTime() + ".glsl"
        FileName = ReplaceString( FileName , chr(58) , chr(46) , -1 ) // Replace ":" with ".", ":" is not allowed in file names.
        FileID AS INTEGER
        FileID = OpenToWrite(FileName, 0)  // ( FileNameString, Replace|Append )
        WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
        WriteLine(FileID, "//BEGIN_VERT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
        WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
        WriteLine(FileID,  GetObjectMeshVSSource(ObjID,iMesh)  )
        WriteLine(FileID, "")
        WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
        WriteLine(FileID, "//BEGIN_FRAG///////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
        WriteLine(FileID, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////")
        WriteLine(FileID,  GetObjectMeshPSSource(ObjID,iMesh)  )
        CloseFile(FileID)
    NEXT iMesh
ENDFUNCTION
