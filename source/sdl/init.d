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
    SDL Initialization

    See_Also:
        $(LINK2 https://wiki.libsdl.org/SDL3/CategoryInit, SDL3 Documentation)
    
    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
*/
module sdl.init;
import sdl.stdc;
import sdl.events;

/**
    Initialization flags for $(D SDL_Init) and/or $(D SDL_InitSubSystem)

    These are the flags which may be passed to $(D SDL_Init). You should specify
    the subsystems which you will be using in your application.

    See_Also:
        $(D SDL_Init)
        $(D SDL_Quit)
        $(D SDL_InitSubSystem)
        $(D SDL_QuitSubSystem)
        $(D SDL_WasInit)
*/
alias SDL_InitFlags = Uint32;

/**
    $(D SDL_INIT_AUDIO) implies $(D SDL_INIT_EVENTS)
*/
enum SDL_InitFlags SDL_INIT_AUDIO = 0x00000010u;

/**
    $(D SDL_INIT_VIDEO) implies $(D SDL_INIT_EVENTS), should be initialized on the main thread
*/
enum SDL_InitFlags SDL_INIT_VIDEO = 0x00000020u;

/**
    $(D SDL_INIT_JOYSTICK) implies $(D SDL_INIT_EVENTS), should be initialized on the same thread as $(D SDL_INIT_VIDEO) on Windows if you don't set $(D SDL_HINT_JOYSTICK_THREAD)
*/
enum SDL_InitFlags SDL_INIT_JOYSTICK = 0x00000200u;

/**
    $(D SDL_INIT_GAMEPAD) implies $(D SDL_INIT_JOYSTICK)
*/
enum SDL_InitFlags SDL_INIT_GAMEPAD = 0x00002000u;

/**
    $(D SDL_INIT_SENSOR) implies $(D SDL_INIT_EVENTS)
*/
enum SDL_InitFlags SDL_INIT_SENSOR = 0x00008000u;

/**
    $(D SDL_INIT_CAMERA) implies $(D SDL_INIT_EVENTS)
*/
enum SDL_InitFlags SDL_INIT_CAMERA = 0x00010000u;

enum SDL_InitFlags SDL_INIT_EVENTS = 0x00004000u;
enum SDL_InitFlags SDL_INIT_HAPTIC = 0x00001000u;
enum SDL_InitFlags SDL_INIT_EVERYTHING = 
    SDL_INIT_AUDIO | SDL_INIT_VIDEO | 
    SDL_INIT_GAMEPAD | SDL_INIT_CAMERA | 
    SDL_INIT_SENSOR;

/**
    Return values for optional main callbacks.

    Returning SDL_APP_SUCCESS or SDL_APP_FAILURE from SDL_AppInit,
    SDL_AppEvent, or SDL_AppIterate will terminate the program and report
    success/failure to the operating system. What that means is
    platform-dependent. On Unix, for example, on success, the process error
    code will be zero, and on failure it will be 1. This interface doesn't
    allow you to return specific exit codes, just whether there was an error
    generally or not.

    Returning SDL_APP_CONTINUE from these functions will let the app continue
    to run.

    See $(LINK2 https://wiki.libsdl.org/SDL3/README/main-functions#main-callbacks-in-sdl3, Main callbacks in SDL3)
    for complete details.
*/
enum SDL_AppResult {

    /**
        Value that requests that the app continue from the main callbacks.
    */
    SDL_APP_CONTINUE,

    /**
        Value that requests termination with success from the main callbacks.
    */
    SDL_APP_SUCCESS,

    /**
        Value that requests termination with error from the main callbacks.
    */
    SDL_APP_FAILURE
}

/**
    Function pointer typedef for SDL_AppInit.

    These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
    the scenes for apps using the optional main callbacks. Apps that want to
    use this should just implement SDL_AppInit directly.

    Params:
        appstate =  a place where the app can optionally store a pointer for
                    future use.
        argc =      the standard ANSI C main's argc; number of elements in `argv`.
        argv =      the standard ANSI C main's argv; array of command line
                    arguments.
    
    Returns:
        SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
        terminate with success, SDL_APP_CONTINUE to continue.
*/
alias SDL_AppInit_func = extern (C) SDL_AppResult function(void** appstate, int argc, char** argv);

/**
    Function pointer typedef for SDL_AppIterate.

    These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
    the scenes for apps using the optional main callbacks. Apps that want to
    use this should just implement SDL_AppIterate directly.

    Params:
        appstate = an optional pointer, provided by the app in SDL_AppInit.
    
    Returns:
        SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
        terminate with success, SDL_APP_CONTINUE to continue.

*/
alias SDL_AppIterate_func = extern (C) SDL_AppResult function(void* appstate);

/**
    Function pointer typedef for SDL_AppEvent.

    These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
    the scenes for apps using the optional main callbacks. Apps that want to
    use this should just implement SDL_AppEvent directly.

    Params:
        appstate =  an optional pointer, provided by the app in SDL_AppInit.
        event =     the new event for the app to examine.
    
    Returns:
        SDL_APP_FAILURE to terminate with an error, SDL_APP_SUCCESS to
        terminate with success, SDL_APP_CONTINUE to continue.

*/
alias SDL_AppEvent_func = extern (C) SDL_AppResult function(void* appstate, SDL_Event* event);

/**
    Function pointer typedef for SDL_AppQuit.

    These are used by SDL_EnterAppMainCallbacks. This mechanism operates behind
    the scenes for apps using the optional main callbacks. Apps that want to
    use this should just implement SDL_AppEvent directly.

    \param appstate an optional pointer, provided by the app in SDL_AppInit.
    \param result the result code that terminated the app (success or failure).

*/
alias SDL_AppQuit_func = extern (C) void function(void* appstate, SDL_AppResult result);

extern (C) nothrow @nogc:

/**
    Initialize the SDL library.

    SDL_Init() simply forwards to calling SDL_InitSubSystem(). Therefore, the
    two may be used interchangeably. Though for readability of your code
    SDL_InitSubSystem() might be preferred.

    The file I/O (for example: SDL_IOFromFile) and threading (SDL_CreateThread)
    subsystems are initialized by default. Message boxes
    (SDL_ShowSimpleMessageBox) also attempt to work without initializing the
    video subsystem, in hopes of being useful in showing an error dialog when
    SDL_Init fails. You must specifically initialize other subsystems if you
    use them in your application.

    Logging (such as SDL_Log) works without initialization, too.

    `flags` may be any of the following OR'd together:

    -   `SDL_INIT_AUDIO`: audio subsystem; automatically initializes the events
        subsystem
    -   `SDL_INIT_VIDEO`: video subsystem; automatically initializes the events
        subsystem, should be initialized on the main thread.
    -   `SDL_INIT_JOYSTICK`: joystick subsystem; automatically initializes the
        events subsystem
    -   `SDL_INIT_HAPTIC`: haptic (force feedback) subsystem
    -   `SDL_INIT_GAMEPAD`: gamepad subsystem; automatically initializes the
        joystick subsystem
    -   `SDL_INIT_EVENTS`: events subsystem
    -   `SDL_INIT_SENSOR`: sensor subsystem; automatically initializes the events
        subsystem
    -   `SDL_INIT_CAMERA`: camera subsystem; automatically initializes the events
        subsystem

    Subsystem initialization is ref-counted, you must call SDL_QuitSubSystem()
    for each SDL_InitSubSystem() to correctly shutdown a subsystem manually (or
    call SDL_Quit() to force shutdown). If a subsystem is already loaded then
    this call will increase the ref-count and return.

    Consider reporting some basic metadata about your application before
    calling SDL_Init, using either SDL_SetAppMetadata() or
    SDL_SetAppMetadataProperty().

    Params:
        flags = subsystem initialization flags.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    See_Also:
        $(D SDL_SetAppMetadata)
        $(D SDL_SetAppMetadataProperty)
        $(D SDL_InitSubSystem)
        $(D SDL_Quit)
        $(D SDL_SetMainReady)
        $(D SDL_WasInit)
*/
extern bool SDL_Init(SDL_InitFlags flags);

/**
    Compatibility function to initialize the SDL library.

    This function and SDL_Init() are interchangeable.

    Params:
        flags = any of the flags used by SDL_Init(); see SDL_Init for details.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    See_Also:
        $(D SDL_Init)
        $(D SDL_Quit)
        $(D SDL_QuitSubSystem)
*/
extern bool SDL_InitSubSystem(SDL_InitFlags flags);

/**
    Shut down specific SDL subsystems.

    You still need to call SDL_Quit() even if you close all open subsystems
    with SDL_QuitSubSystem().

    Params:
        flags = any of the flags used by SDL_Init(); see SDL_Init for details.

    See_Also:
        $(D SDL_InitSubSystem)
        $(D SDL_Quit)
*/
extern void SDL_QuitSubSystem(SDL_InitFlags flags);

/**
    Get a mask of the specified subsystems which are currently initialized.

    Params:
        flags = any of the flags used by SDL_Init(); see SDL_Init for details.
    
    Returns:
        A mask of all initialized subsystems if `flags` is 0, otherwise it
        returns the initialization status of the specified subsystems.

    See_Also:
        $(D SDL_Init)
        $(D SDL_InitSubSystem)
*/
extern SDL_InitFlags SDL_WasInit(SDL_InitFlags flags);

/**
    Clean up all initialized subsystems.

    You should call this function even if you have already shutdown each
    initialized subsystem with SDL_QuitSubSystem(). It is safe to call this
    function even in the case of errors in initialization.

    You can use this function with atexit() to ensure that it is run when your
    application is shutdown, but it is not wise to do this from a library or
    other dynamically loaded code.

    See_Also:
        $(D SDL_Init)
        $(D SDL_QuitSubSystem)
*/
extern void SDL_Quit();

/**
    Return whether this is the main thread.

    On Apple platforms, the main thread is the thread that runs your program's
    main() entry point. On other platforms, the main thread is the one that
    calls SDL_Init(SDL_INIT_VIDEO), which should usually be the one that runs
    your program's main() entry point. If you are using the main callbacks,
    SDL_AppInit(), SDL_AppIterate(), and SDL_AppQuit() are all called on the
    main thread.

    Returns:
        true if this thread is the main thread, or false otherwise.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_RunOnMainThread)
*/
extern bool SDL_IsMainThread();

/**
    Callback run on the main thread.

    \param userdata an app-controlled pointer that is passed to the callback.


    \sa SDL_RunOnMainThread
*/
alias SDL_MainThreadCallback = void function(void* userdata);

/**
    Call a function on the main thread during event processing.

    If this is called on the main thread, the callback is executed immediately.
    If this is called on another thread, this callback is queued for execution
    on the main thread during event processing.

    Be careful of deadlocks when using this functionality. You should not have
    the main thread wait for the current thread while this function is being
    called with `wait_complete` true.

    Params:
        callback =      the callback to call on the main thread.
        userdata =      a pointer that is passed to `callback`.
        wait_complete = true to wait for the callback to complete, false to
                        return immediately.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_IsMainThread)
*/
extern bool SDL_RunOnMainThread(SDL_MainThreadCallback callback, void* userdata, bool wait_complete);

/**
    Specify basic metadata about your app.

    You can optionally provide metadata about your app to SDL. This is not
    required, but strongly encouraged.

    There are several locations where SDL can make use of metadata (an "About"
    box in the macOS menu bar, the name of the app can be shown on some audio
    mixers, etc). Any piece of metadata can be left as NULL, if a specific
    detail doesn't make sense for the app.

    This function should be called as early as possible, before SDL_Init.
    Multiple calls to this function are allowed, but various state might not
    change once it has been set up with a previous call to this function.

    Passing a NULL removes any previous metadata.

    This is a simplified interface for the most important information. You can
    supply significantly more detailed metadata with
    SDL_SetAppMetadataProperty().

    Params:
        appname =       The name of the application ("My Game 2: Bad Guy's
                        Revenge!").
        appversion =    The version of the application ("1.0.0beta5" or a git
                        hash, or whatever makes sense).
        appidentifier = A unique string in reverse-domain format that
                        identifies this app ("com.example.mygame2").
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_SetAppMetadataProperty)
*/
extern bool SDL_SetAppMetadata(const(char)* appname, const(char)* appversion, const(char)* appidentifier);

/**
    Specify metadata about your app through a set of properties.

    You can optionally provide metadata about your app to SDL. This is not
    required, but strongly encouraged.

    There are several locations where SDL can make use of metadata (an "About"
    box in the macOS menu bar, the name of the app can be shown on some audio
    mixers, etc). Any piece of metadata can be left out, if a specific detail
    doesn't make sense for the app.

    This function should be called as early as possible, before SDL_Init.
    Multiple calls to this function are allowed, but various state might not
    change once it has been set up with a previous call to this function.

    Once set, this metadata can be read using SDL_GetAppMetadataProperty().

    These are the supported properties:

    -   `SDL_PROP_APP_METADATA_NAME_STRING`: The human-readable name of the
        application, like "My Game 2: Bad Guy's Revenge!". This will show up
        anywhere the OS shows the name of the application separately from window
        titles, such as volume control applets, etc. This defaults to "SDL
        Application".
    -   `SDL_PROP_APP_METADATA_VERSION_STRING`: The version of the app that is
        running; there are no rules on format, so "1.0.3beta2" and "April 22nd,
        2024" and a git hash are all valid options. This has no default.
    -   `SDL_PROP_APP_METADATA_IDENTIFIER_STRING`: A unique string that
        identifies this app. This must be in reverse-domain format, like
        "com.example.mygame2". This string is used by desktop compositors to
        identify and group windows together, as well as match applications with
        associated desktop settings and icons. If you plan to package your
        application in a container such as Flatpak, the app ID should match the
        name of your Flatpak container as well. This has no default.
    -   `SDL_PROP_APP_METADATA_CREATOR_STRING`: The human-readable name of the
        creator/developer/maker of this app, like "MojoWorkshop, LLC"
    -   `SDL_PROP_APP_METADATA_COPYRIGHT_STRING`: The human-readable copyright
        notice, like "Copyright (c) 2024 MojoWorkshop, LLC" or whatnot. Keep this
        to one line, don't paste a copy of a whole software license in here. This
        has no default.
    -   `SDL_PROP_APP_METADATA_URL_STRING`: A URL to the app on the web. Maybe a
        product page, or a storefront, or even a GitHub repository, for user's
        further information This has no default.
    -   `SDL_PROP_APP_METADATA_TYPE_STRING`: The type of application this is.
        Currently this string can be "game" for a video game, "mediaplayer" for a
        media player, or generically "application" if nothing else applies.
        Future versions of SDL might add new types. This defaults to
        "application".

    Params:
        name =  the name of the metadata property to set.
        value = the value of the property, or NULL to remove that property.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_GetAppMetadataProperty)
        $(D SDL_SetAppMetadata)
*/
extern bool SDL_SetAppMetadataProperty(const(char)* name, const(char)* value);

enum SDL_PROP_APP_METADATA_NAME_STRING = "SDL.app.metadata.name";
enum SDL_PROP_APP_METADATA_VERSION_STRING = "SDL.app.metadata.version";
enum SDL_PROP_APP_METADATA_IDENTIFIER_STRING = "SDL.app.metadata.identifier";
enum SDL_PROP_APP_METADATA_CREATOR_STRING = "SDL.app.metadata.creator";
enum SDL_PROP_APP_METADATA_COPYRIGHT_STRING = "SDL.app.metadata.copyright";
enum SDL_PROP_APP_METADATA_URL_STRING = "SDL.app.metadata.url";
enum SDL_PROP_APP_METADATA_TYPE_STRING = "SDL.app.metadata.type";

/**
    Get metadata about your app.

    This returns metadata previously set using SDL_SetAppMetadata() or
    SDL_SetAppMetadataProperty(). See SDL_SetAppMetadataProperty() for the list
    of available properties and their meanings.

    Params:
        name =  the name of the metadata property to get.
    
    Returns:
        The current value of the metadata property, or the default if it
        is not set, NULL for properties with no default.

    Threadsafety:
        It is safe to call this function from any thread, although
        the string returned is not protected and could potentially be
        freed if you call SDL_SetAppMetadataProperty() to set that
        property from another thread.

    See_Also:
        $(D SDL_SetAppMetadata)
        $(D SDL_SetAppMetadataProperty)
*/
extern const(char)* SDL_GetAppMetadataProperty(const(char)* name);
