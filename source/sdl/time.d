/*
    DSDL
    Copyright (C) 2025 Inochi2D Project <luna@foxgirls.gay>

    This software is provided 'as-is', without any express or implied
    warranty.  In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software
        in a product, an acknowledgment in the product documentation would be
        appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be
        misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.

    ==========================================================================

    Simple DirectMedia Layer
    Copyright (C) 1997-2025 Sam Lantinga <slouken@libsdl.org>

    This software is provided 'as-is', without any express or implied
    warranty.  In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software
        in a product, an acknowledgment in the product documentation would be
        appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be
        misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.
*/

/**
    SDL Time

    SDL realtime clock and date/time routines.

    See_Also:
        $(LINK2 https://wiki.libsdl.org/SDL3/CategoryTime, SDL3 Time Documentation)
    
    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
*/
module sdl.time;
import sdl.stdc;

extern(C) nothrow @nogc:

/**
    A structure holding a calendar date and time broken down into its
    components.
*/
struct SDL_DateTime {

    /**
        Year 
    */
    int year;                  

    /**
        Month [01-12] 
    */
    int month;                 

    /**
        Day of the month [01-31] 
    */
    int day;                   

    /**
        Hour [0-23] 
    */
    int hour;                  

    /**
        Minute [0-59] 
    */
    int minute;                

    /**
        Seconds [0-60] 
    */
    int second;                

    /**
        Nanoseconds [0-999999999] 
    */
    int nanosecond;            

    /**
        Day of the week [0-6] (0 being Sunday) 
    */
    int day_of_week;           

    /**
        Seconds east of UTC 
    */
    int utc_offset;
}
/**
    The preferred date format of the current system locale.

    See_Also:
        $(D SDL_GetDateTimeLocalePreferences)
*/
enum SDL_DateFormat {
    
    /**
        Year/Month/Day
    */
    SDL_DATE_FORMAT_YYYYMMDD = 0, 
    
    /**
        Day/Month/Year
    */
    SDL_DATE_FORMAT_DDMMYYYY = 1, 
    
    /**
        Month/Day/Year
    */
    SDL_DATE_FORMAT_MMDDYYYY = 2  
}

/**
    The preferred time format of the current system locale.

    See_Also:
        $(D SDL_GetDateTimeLocalePreferences)
*/
enum SDL_TimeFormat {
    
    /**
        24 hour time 
    */
    SDL_TIME_FORMAT_24HR = 0, 
    
    /**
        12 hour time 
    */
    SDL_TIME_FORMAT_12HR = 1  
}

/**
    Gets the current preferred date and time format for the system locale.
    This might be a "slow" call that has to query the operating system. It's
    best to ask for this once and save the results. However, the preferred
    formats can change, usually because the user has changed a system
    preference outside of your program.

    Params:
        dateFormat =    A pointer to the SDL_DateFormat to hold the returned date
                        format, may be $(D null).
        timeFormat =    A pointer to the SDL_TimeFormat to hold the returned time
                        format, may be $(D null).
    Returns:
        $(D true) on success or $(D false) on failure; 
        call SDL_GetError() for more information.

    Threadsafety:
        This function is not thread safe.
*/
extern bool SDL_GetDateTimeLocalePreferences(SDL_DateFormat *dateFormat, SDL_TimeFormat *timeFormat);

/**
    Gets the current value of the system realtime clock in nanoseconds since
    Jan 1, 1970 in Universal Coordinated Time (UTC).

    Params:
        ticks = The SDL_Time to hold the returned tick count.
    
    Returns:
        $(D true) on success or $(D false) on failure;
        call SDL_GetError() for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern bool SDL_GetCurrentTime(ref SDL_Time ticks);

/**
    Converts an SDL_Time in nanoseconds since the epoch to a calendar time in
    the SDL_DateTime format.

    Params:
        ticks =     The SDL_Time to be converted.
        dt =        The resulting SDL_DateTime.
        localTime = The resulting SDL_DateTime will be expressed in local time
                    if true, otherwise it will be in Universal Coordinated
                    Time (UTC).

    Returns:
        $(D true) on success or $(D false) on failure; 
        call SDL_GetError() for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern bool SDL_TimeToDateTime(SDL_Time ticks, ref SDL_DateTime dt, bool localTime);

/**
    Converts a calendar time to an SDL_Time in nanoseconds since the epoch.
    
    This function ignores the day_of_week member of the SDL_DateTime struct, so
    it may remain unset.
    
    Params:
        dt =    the source SDL_DateTime.
        ticks = the resulting SDL_Time.

    Returns:
        $(D true) on success or $(D false) on failure; 
        call SDL_GetError() for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern bool SDL_DateTimeToTime(const(SDL_DateTime)* dt, ref SDL_Time ticks);

/**
    Converts an SDL time into a Windows FILETIME (100-nanosecond intervals
    since January 1, 1601).
    
    This function fills in the two 32-bit values of the FILETIME structure.
    
    Params:
        ticks =             The time to convert.
        dwLowDateTime =     A pointer filled in with the low portion of the
                            Windows FILETIME value.
        dwHighDateTime =    A pointer filled in with the high portion of the
                            Windows FILETIME value.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern void SDL_TimeToWindows(SDL_Time ticks, ref Uint32 dwLowDateTime, ref Uint32 dwHighDateTime);

/**
    Converts a Windows FILETIME (100-nanosecond intervals since January 1,
    1601) to an SDL time.
    
    This function takes the two 32-bit values of the FILETIME structure as
    parameters.
    
    Params:
        dwLowDateTime =     The low portion of the Windows FILETIME value.
        dwHighDateTime =    The high portion of the Windows FILETIME value.

    Returns:
        The converted SDL time.
    
    Threadsafety:
        It is safe to call this function from any thread.
*/
extern SDL_Time SDL_TimeFromWindows(Uint32 dwLowDateTime, Uint32 dwHighDateTime);

/**
    Get the number of days in a month for a given year.
    
    Params:
        year =  The year.
        month = The month [1-12].

    Returns:
        The number of days in the requested month or $(D -1) on failure; call
        $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern int SDL_GetDaysInMonth(int year, int month);

/**
    Get the day of year for a calendar date.
    
    Params:
        year =  The year component of the date.
        month = The month component of the date.
        day =   The day component of the date.

    Returns:
        The day of year $(D [0..365]) if the date is valid or $(D -1) on failure;
        call SDL_GetError() for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern int SDL_GetDayOfYear(int year, int month, int day);

/**
    Get the day of week for a calendar date.

    Params:
        year =  The year component of the date.
        month = The month component of the date.
        day =   The day component of the date.

    Returns:
        A value between 0 and 6 (0 being Sunday) if the date is valid or
        $(D -1) on failure; call $(D SDL_GetError) for more information.
    
    Threadsafety:
        It is safe to call this function from any thread.
*/
extern int SDL_GetDayOfWeek(int year, int month, int day);
