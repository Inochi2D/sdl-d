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
*/

/**
    DLang helpers for SDL.
    
    Copyright: © 2025 Inochi2D Project
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
*/
module sdl.d;

import sdl.init;

/**
    Creates a new unique handle type.

    Handle types are pointers to opaque structs.

    See_Also:
        $(LINK2 https://github.com/Inochi2D/numem/blob/main/source/numem/core/types.d, Original Implementation)

    Params:
        name = Unique name of the handle.

    License:
        This template is subject to the Boost License found in numem.

    Examples:
        ---
        alias VkInstance = OpaqueHandle!("VkInstance");
        ---
*/
template OpaqueHandle(string name) {
    struct OpaqueHandleT(string name);
    alias OpaqueHandle = OpaqueHandleT!(name)*;
}

/** 
	Traits used to determine whether a given class can be used as the main app.

	Params:
	  T = A class type that matches the interface required by $(D AppMain).
*/
template isAppMain(T) if (is(T == class)) {
	import sdl.events;

	enum hasConstructor = __traits(compiles, (string[] args) {
		new T(args);
	});

	enum hasIterate = __traits(compiles, (T app) {
		app.iterate();
	});

	enum hasHandle = __traits(compiles, (T app, SDL_Event* event) {
		SDL_AppResult _ = app.handle(*event);
	});

	enum isAppMain = hasConstructor && hasIterate && hasHandle;
}

/**
    Template mixin that declares its own main and maps the SDL main callbacks to
	methods in a given class. This class is instantiated by said main function
	and its methods invoked by SDl main callbacks.
*/
mixin template AppMain(T) if (isAppMain!T) {
	import sdl.main;

    int main() {
        return SDL_RunApp(0, null, &SDL_main, null);
    }

	extern (C) int SDL_main(int, char**) {
		return SDL_EnterAppMainCallbacks(0, null, &SDL_AppInit, &SDL_AppIterate, &SDL_AppEvent, &SDL_AppQuit);
	}

    extern (C) SDL_AppResult SDL_AppInit(void** appstate, int, char**) nothrow {
        import core.runtime;
        import core.lifetime;
        import core.stdc.stdlib;

        *(cast(T**) appstate) = emplace!(T)(cast(T*) malloc(T.sizeof));

        with (SDL_AppResult) try {
            **(cast(T**) appstate) = new T(Runtime.args);
            return SDL_APP_CONTINUE;
        } catch (Exception e) {
            return SDL_APP_FAILURE;
        }
    }

    extern (C) void SDL_AppQuit(void* appstate, SDL_AppResult) nothrow {
        import core.lifetime;
        import core.stdc.stdlib;

        destroy!false(*cast(T*) appstate);
        free(appstate);
    }

    extern (C) SDL_AppResult SDL_AppIterate(void* appstate) nothrow {
        with (SDL_AppResult) try {
            (cast(T*) appstate).iterate();
            return SDL_APP_CONTINUE;
        } catch (Exception e) {
            return SDL_APP_FAILURE;
        }
    }

    extern (C) SDL_AppResult SDL_AppEvent(void* appstate, SDL_Event* event) nothrow {
        with (SDL_AppResult) try {
            return (cast(T*) appstate).handle(*event);
        } catch (Exception e) {
            return SDL_APP_FAILURE;
        }
    }
}