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
    SDL Log Handling

    See_Also:
        $(LINK2 https://wiki.libsdl.org/SDL3/CategoryLog, SDL3 Log Documentation)
    
    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors:
        Maxwell Ruben
*/
module sdl.log;
import core.stdc.stdarg : va_list;

extern(C) nothrow @nogc:

/**
    The predefined log categories

    By default the application and gpu categories are enabled at the INFO
    level, the assert category is enabled at the WARN level, test is enabled at
    the VERBOSE level and all other categories are enabled at the ERROR level.
*/
enum SDL_LogCategory {
    SDL_LOG_CATEGORY_APPLICATION,
    SDL_LOG_CATEGORY_ERROR,
    SDL_LOG_CATEGORY_ASSERT,
    SDL_LOG_CATEGORY_SYSTEM,
    SDL_LOG_CATEGORY_AUDIO,
    SDL_LOG_CATEGORY_VIDEO,
    SDL_LOG_CATEGORY_RENDER,
    SDL_LOG_CATEGORY_INPUT,
    SDL_LOG_CATEGORY_TEST,
    SDL_LOG_CATEGORY_GPU,

    /**
        Reserved for future SDL library use
    */
    SDL_LOG_CATEGORY_RESERVED2,
    SDL_LOG_CATEGORY_RESERVED3,
    SDL_LOG_CATEGORY_RESERVED4,
    SDL_LOG_CATEGORY_RESERVED5,
    SDL_LOG_CATEGORY_RESERVED6,
    SDL_LOG_CATEGORY_RESERVED7,
    SDL_LOG_CATEGORY_RESERVED8,
    SDL_LOG_CATEGORY_RESERVED9,
    SDL_LOG_CATEGORY_RESERVED10,

    /**
        Beyond this point is reserved for application use, e.g.
        enum {
            MYAPP_CATEGORY_AWESOME1 = SDL_LOG_CATEGORY_CUSTOM,
            MYAPP_CATEGORY_AWESOME2,
            MYAPP_CATEGORY_AWESOME3,
            ...
        };
    */
    SDL_LOG_CATEGORY_CUSTOM,
}

/**
    The predefined log priorities
*/
enum SDL_LogPriority {
    SDL_LOG_PRIORITY_INVALID,
    SDL_LOG_PRIORITY_TRACE,
    SDL_LOG_PRIORITY_VERBOSE,
    SDL_LOG_PRIORITY_DEBUG,
    SDL_LOG_PRIORITY_INFO,
    SDL_LOG_PRIORITY_WARN,
    SDL_LOG_PRIORITY_ERROR,
    SDL_LOG_PRIORITY_CRITICAL,
    SDL_LOG_PRIORITY_COUNT,
}

/**
    Set the priority of all log categories.
    
    Params:
        priority = the SDL_LogPriority to assign.
    
    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:    
        $(D SDL_ResetLogPriorities)
        $(D SDL_SetLogPriority)
*/
extern void SDL_SetLogPriorities(SDL_LogPriority priority);

/**
    Set the priority of a particular log category.
    
    Params:
        category = the category to assign a priority to.
        priority = the SDL_LogPriority to assign.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_GetLogPriority)
        $(D SDL_ResetLogPriorities)
        $(D SDL_SetLogPriorities)
*/
extern void SDL_SetLogPriority(int category, SDL_LogPriority priority);

/**
    Get the priority of a particular log category.
   
    Params:
        category = the category to query.

    Returns:
        the SDL_LogPriority for the requested category.
   
    Threadsafety:
        It is safe to call this function from any thread.
      
    See_Also:
        $(D SDL_SetLogPriority)
*/
SDL_LogPriority SDL_GetLogPriority(int category);

/**
    Reset all priorities to default.
    
    This is called by SDL_Quit().
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_SetLogPriorities)
        $(D SDL_SetLogPriority)
*/
void SDL_ResetLogPriorities();

/**
    Set the text prepended to log messages of a given priority.
    
    By default SDL_LOG_PRIORITY_INFO and below have no prefix, and
    SDL_LOG_PRIORITY_WARN and higher have a prefix showing their priority, e.g.
    "WARNING\: ".
    
    This function makes a copy of its string argument, **prefix**, so it is not
    necessary to keep the value of **prefix** alive after the call returns.
    
    Params:
        priority =  the SDL_LogPriority to modify.
        prefix =    the prefix to use for that log priority, or NULL to use no
                    prefix.
    Returns:
        true on success or false on failure; call SDL_GetError() for more
             information.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_SetLogPriorities)
        $(D SDL_SetLogPriority)
*/
bool SDL_SetLogPriorityPrefix(SDL_LogPriority priority, const (char)* prefix);

/**
    Log a message with SDL_LOG_CATEGORY_APPLICATION and SDL_LOG_PRIORITY_INFO.
    
    Params:
        fmt =   a printf() style message format string.
        ... =   additional parameters matching % tokens in the `fmt` string, if
                any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_Log(const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_TRACE.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogTrace(int category, const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_VERBOSE.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogWarn)
*/
void SDL_LogVerbose(int category, const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_DEBUG.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogDebug(int category, const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_INFO.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogInfo(int category, const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_WARN.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
*/
void SDL_LogWarn(int category, const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_ERROR.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogError(int category, const(char)* fmt, ...);

/**
    Log a message with SDL_LOG_PRIORITY_CRITICAL.
    
    Params:
        category =  the category of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogCritical(int category, const(char)* fmt, ...);

/**
    Log a message with the specified category and priority.
    
    Params:
        category =  the category of the message.
        priority =  the priority of the message.
        fmt =       a printf() style message format string.
        ... =       additional parameters matching % tokens in the **fmt** string,
                    if any.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessageV)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogMessage(int category, SDL_LogPriority priority, const(char)* fmt, ...);

/**
    Log a message with the specified category and priority.
    
    Params:
        category =  the category of the message.
        priority =  the priority of the message.
        fmt =       a printf() style message format string.
        ap =        a variable argument list.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_Log)
        $(D SDL_LogCritical)
        $(D SDL_LogDebug)
        $(D SDL_LogError)
        $(D SDL_LogInfo)
        $(D SDL_LogMessage)
        $(D SDL_LogTrace)
        $(D SDL_LogVerbose)
        $(D SDL_LogWarn)
*/
void SDL_LogMessageV(int category, SDL_LogPriority priority, const(char)* fmt, va_list ap);

/**
    The prototype for the log output callback function.
    
    This function is called by SDL when there is new text to be logged. A mutex
    is held so that this function is never called by more than one thread at
    once.
    
    Params:
        userdata =  what was passed as `userdata` to
                    SDL_SetLogOutputFunction().
        category =  the category of the message.
        priority =  the priority of the message.
        message =   the message being output.
*/
alias SDL_LogOutputFunction = void function(void* userdata, int category, SDL_LogPriority priority, const(char)* message);

/**
    Get the default log output function.
    
    Returns:
        the default log output callback.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_SetLogOutputFunction)
        $(D SDL_GetLogOutputFunction)
*/
SDL_LogOutputFunction SDL_GetDefaultLogOutputFunction();

/**
    Get the current log output function.
    
    Params:
        callback =  an SDL_LogOutputFunction filled in with the current log
                    callback.
        userdata =  a pointer filled in with the pointer that is passed to
                    `callback`.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_GetDefaultLogOutputFunction)
        $(D SDL_SetLogOutputFunction)
*/
void SDL_GetLogOutputFunction(SDL_LogOutputFunction* callback, void** userdata);


/**
    Replace the default log output function with one of your own.
    
    Params:
        callback = an SDL_LogOutputFunction to call instead of the default.
        userdata = a pointer that is passed to `callback`.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    See_Also:
        $(D SDL_GetDefaultLogOutputFunction)
        $(D SDL_GetLogOutputFunction)
*/
void SDL_SetLogOutputFunction(SDL_LogOutputFunction callback, void* userdata);