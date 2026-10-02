//##############################################################################################################################################################
//##############################################################################################################################################################
TYPE _Time_
    LastFrame  AS FLOAT
    ThisFrame  AS FLOAT
    Delta      AS FLOAT

    Speed AS FLOAT
ENDTYPE
GLOBAL Time AS _Time_

//##############################################################################################################################################################
//##############################################################################################################################################################
FUNCTION Time_Update()
  //Time.ThisFrame = Time.ThisFrame + GetFrameTime() * Time.Speed

    Time.ThisFrame = Timer()
    Time.Delta     = Time.ThisFrame - Time.LastFrame

    //  This maintains timer precision to: ~0.000_001 Seconds (1 MicroSecond).  (Assuming 32-bit float timer.)
    IF (Time.ThisFrame >= 60.0): ResetTimer()
                                 Time.LastFrame = Timer()
    ELSE                       : Time.LastFrame = Time.ThisFrame
    ENDIF
ENDFUNCTION

//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//##############################################################################################################################################################
//
//  1 Hour                       3,600 Seconds
//  1 Day                       86,400 Seconds
//  1 Week                     604,800 Seconds
//  1 Month (30.44 days)     2,629,743 Seconds
//  1 Year (365.24 days)    31,556,926 Seconds
//
FUNCTION UnixTimeToString(TimeUnix AS INTEGER)
    ClientTimeZoneOffset AS INTEGER: ClientTimeZoneOffset = val(left(GetCurrentTime(),2)) - GetHoursFromUnix(GetUnixTime())

    TimeUnix = TimeUnix + (3600 * ClientTimeZoneOffset)

    TimeUnixStr AS STRING
    TimeUnixStr =                      str(   GetYearFromUnix(TimeUnix)           )+"-"
    TimeUnixStr = TimeUnixStr + padstrwith(  GetMonthFromUnix(TimeUnix), 2, 0, "0")+"-"
    TimeUnixStr = TimeUnixStr + padstrwith(   GetDaysFromUnix(TimeUnix), 2, 0, "0")+" "
    TimeUnixStr = TimeUnixStr + padstrwith(  GetHoursFromUnix(TimeUnix), 2, 0, "0")+":"
    TimeUnixStr = TimeUnixStr + padstrwith(GetMinutesFromUnix(TimeUnix), 2, 0, "0")+":"
    TimeUnixStr = TimeUnixStr + padstrwith(GetSecondsFromUnix(TimeUnix), 2, 0, "0")
ENDFUNCTION TimeUnixStr
