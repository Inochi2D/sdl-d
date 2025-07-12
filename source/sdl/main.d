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
    SDL Main

    Exposes the building blocks of SDL_main.h to the user. This is also where
    an app can be configured to use the main callbacks.

    For more information, see:

    https://wiki.libsdl.org/SDL3/README-main-functions
*/
module sdl.main;
import sdl.init;
import sdl.stdc;
import sdl.error;
import sdl.events;

/**
    The prototype for the application's `main()` function

    Params:
        argc = An ANSI-C style main function's argc.
        argv = An ANSI-C style main function's argv.

    Returns:
        an ANSI-C main return code; generally 0 is considered successful program
        completion, and small non-zero values are considered errors.
*/
alias SDL_main_func = extern (C) int function(int argc, char** argv);

extern (C) nothrow @nogc:

/**
    Circumvent failure of $(D SDL_Init) when not using `SDL_main()` as an entry point.

    See_Also:
        $(D SDL_Init)
*/
extern void SDL_SetMainReady();

/**
    Initializes and launches an SDL application, by doing platform-specific
    initialization before calling your mainFunction and cleanups after it
    returns, if that is needed for a specific platform, otherwise it just calls
    mainFunction.

    You can use this if you want to use your own `main` implementation without
    using SDL_main (like when using `SDL_MAIN_HANDLED`). When using this, you do
    *not* need `SDL_SetMainReady`.

    Params:
        argc = The argc parameter from the application's `main` function, or `0` if the platform's main-equivalent has no `argc`.
        argv = The argv parameter from the application's `main` function, or `null` if the platform's main-equivalent has no `argv`.
        mainFunction = Your SDL app's C-style `main`.
        reserved = Should be `null` (reserved for future use, will probably be platform-specific then).

    Returns:
        The return value from `mainFunction`: `0` on success, otherwise failure;
        `SDL_GetError` might have more information on the failure.

    Threadsafety:
        Generally this is called once, near startup, from the process's initial thread.
*/
extern int SDL_RunApp(int argc, char** argv, SDL_main_func mainFunction, void* reserved);

/**
    An entry point for SDL's use in `SDL_MAIN_USE_CALLBACKS`.

    Generally, you should not call this function directly. This only exists to
    hand off work into SDL as soon as possible, where it has a lot more control
    and functionality available, and make the inline code in SDL_main.h as
    small as possible.

    Not all platforms use this, its actual use is hidden in a magic
    header-only library, and you should not call this directly unless you
    _really_ know what you're doing.

    Params:
        argc = Standard Unix main argc.
        argv = Standard Unix main argv.
        appinit = The application's $(D SDL_AppInit) function.
        appiter = The application's $(D SDL_AppIterate) function.
        appevent = The application's $(D SDL_AppEvent) function.
        appquit = The application's $(D SDL_AppQuit) function.

    Returns:
        Standard Unix main return value.

    Threadsafety:
        It is not safe to call this anywhere except as the only function call in `SDL_main`.

	See_Also:
		$(D AppMain)
*/
extern int SDL_EnterAppMainCallbacks(int argc, char** argv, SDL_AppInit_func appinit, SDL_AppIterate_func appiter, SDL_AppEvent_func appevent, SDL_AppQuit_func appquit);

version (Windows) {
    /**
        Register a win32 window class for SDL's use.

        This can be called to set the application window class at startup. It is
        safe to call this multiple times, as long as every call is eventually
        paired with a call to $(D SDL_UnregisterApp), but a second registration
        attempt while a previous registration is still active will be ignored,
        other than to increment a counter.

        Most applications do not need to, and should not, call this directly;
        SDL will call it when initializing the video subsystem.

        Params:
            name = The window class name, in UTF-8 encoding. If `null`, SDL currently uses "SDL_app" but this isn't guaranteed.
            style = The value to use in WNDCLASSEX::style. If `name` is `null`, SDL currently uses `(CS_BYTEALIGNCLIENT | CS_OWNDC)` regardless of what is specified here.
            hInst = The `HINSTANCE` to use in WNDCLASSEX::hInstance. If zero, SDL will use `GetModuleHandle(null)` instead.

        Returns:
            `true` on success or `false` on failure; call $(D SDL_GetError) for more information.
    */
    extern bool SDL_RegisterApp(const(char)* name, Uint32 style, void* hInst);

    /**
        Deregister the win32 window class from an $(D SDL_RegisterApp) call.

        This can be called to undo the effects of $(D SDL_RegisterApp).

        Most applications do not need to, and should not, call this directly;
        SDL will call it when deinitializing the video subsystem.

        It is safe to call this multiple times, as long as every call is eventually
        paired with a prior call to $(D SDL_RegisterApp). The window class will
        only be deregistered when the registration counter in $(D SDL_RegisterApp)
        decrements to zero through calls to this function.
    */
    extern void SDL_UnregisterApp();
}

/**
    Callback from the application to let the suspend continue.

    This function is only needed for Xbox GDK support; all other platforms will
    do nothing and set an "unsupported" error message.
*/
extern void SDL_GDKSuspendComplete();