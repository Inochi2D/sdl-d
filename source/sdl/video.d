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
    SDL Video

    See_Also:
        $(LINK2 https://wiki.libsdl.org/SDL3/CategoryVideo, SDL3 Video Documentation)
    
    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
*/
module sdl.video;
import sdl.stdc;
import sdl.properties;
import sdl.pixels;
import sdl.surface;
import sdl.rect;

extern(C) nothrow @nogc:

/**
    This is a unique ID for a display for the time it is connected to the
    system, and is never reused for the lifetime of the application.

    If the display is disconnected and reconnected, it will get a new ID.

    The value 0 is an invalid ID.
*/
alias SDL_DisplayID = Uint32;

/**
    This is a unique ID for a window.

    The value 0 is an invalid ID.
*/
alias SDL_WindowID = Uint32;

/**
    The pointer to the global `wl_display` object used by the Wayland video
    backend.

    Can be set before the video subsystem is initialized to import an external
    `wl_display` object from an application or toolkit for use in SDL, or read
    after initialization to export the `wl_display` used by the Wayland video
    backend. Setting this property after the video subsystem has been
    initialized has no effect, and reading it when the video subsystem is
    uninitialized will either return the user provided value, if one was set
    prior to initialization, or NULL. See docs/README-wayland.md for more
    information.
*/
enum SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER = "SDL.video.wayland.wl_display";

/**
    System theme.
*/
enum SDL_SystemTheme {
    
    /**
        Unknown system theme
    */
    SDL_SYSTEM_THEME_UNKNOWN,
    
    /**
        Light colored system theme
    */
    SDL_SYSTEM_THEME_LIGHT,
    
    /**
        Dark colored system theme
    */
    SDL_SYSTEM_THEME_DARK
}

/**
    Internal display mode data.

    This lives as a field in SDL_DisplayMode, as opaque data.

    See_Also:
        $(D SDL_DisplayMode)
*/
struct SDL_DisplayModeData;

/**
    The structure that defines a display mode.

    See_Also:
        $(D SDL_GetFullscreenDisplayModes)
        $(D SDL_GetDesktopDisplayMode)
        $(D SDL_GetCurrentDisplayMode)
        $(D SDL_SetWindowFullscreenMode)
        $(D SDL_GetWindowFullscreenMode)
*/
struct SDL_DisplayMode {
public:
    /**
        The display this mode is associated with
    */
    SDL_DisplayID displayID;
    
    /**
        Pixel format
    */
    SDL_PixelFormat format;
    
    /**
        Width
    */
    int w;
    
    /**
        Height
    */
    int h;
    
    /**
        Scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels)
    */
    float pixel_density;
    
    /**
        Refresh rate (or 0.0f for unspecified)
    */
    float refresh_rate;
    
    /**
        Precise refresh rate numerator (or 0 for unspecified)
    */
    int refresh_rate_numerator;
    
    /**
        Precise refresh rate denominator
    */
    int refresh_rate_denominator;

private:

    SDL_DisplayModeData* internal;
}

/**
    Display orientation values; the way a display is rotated.
*/
enum SDL_DisplayOrientation {
    
    /**
        The display orientation can't be determined
    */
    SDL_ORIENTATION_UNKNOWN,
    
    /**
        The display is in landscape mode, with the right side up, relative to portrait mode
    */
    SDL_ORIENTATION_LANDSCAPE,
    
    /**
        The display is in landscape mode, with the left side up, relative to portrait mode
    */
    SDL_ORIENTATION_LANDSCAPE_FLIPPED,
    
    /**
        The display is in portrait mode
    */
    SDL_ORIENTATION_PORTRAIT,
    
    /**
        The display is in portrait mode, upside down
    */
    SDL_ORIENTATION_PORTRAIT_FLIPPED
}

/**
    The struct used as an opaque handle to a window.
    
    See_Also:
        $(D SDL_CreateWindow)
*/
struct SDL_Window;

/**
    The flags on a window.

    These cover a lot of true/false, or on/off, window state. Some of it is
    immutable after being set through SDL_CreateWindow(), some of it can be
    changed on existing windows by the app, and some of it might be altered by
    the user or system outside of the app's control.

    See_Also:
        $(D SDL_GetWindowFlags)
*/
enum SDL_WindowFlags : Uint64 {
    
    /**
        Window is in fullscreen mode
    */
    SDL_WINDOW_FULLSCREEN =           0x0000000000000001,
    
    /**
        Window usable with OpenGL context
    */
    SDL_WINDOW_OPENGL =               0x0000000000000002,
    
    /**
        Window is occluded
    */
    SDL_WINDOW_OCCLUDED =             0x0000000000000004,
    
    /**
        Window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible
    */
    SDL_WINDOW_HIDDEN =               0x0000000000000008,
    
    /**
        No window decoration
    */
    SDL_WINDOW_BORDERLESS =           0x0000000000000010,
    
    /**
        Window can be resized
    */
    SDL_WINDOW_RESIZABLE =            0x0000000000000020,
    
    /**
        Window is minimized
    */
    SDL_WINDOW_MINIMIZED =            0x0000000000000040,
    
    /**
        Window is maximized
    */
    SDL_WINDOW_MAXIMIZED =            0x0000000000000080,
    
    /**
        Window has grabbed mouse input
    */
    SDL_WINDOW_MOUSE_GRABBED =        0x0000000000000100,
    
    /**
        Window has input focus
    */
    SDL_WINDOW_INPUT_FOCUS =          0x0000000000000200,
    
    /**
        Window has mouse focus
    */
    SDL_WINDOW_MOUSE_FOCUS =          0x0000000000000400,
    
    /**
        Window not created by SDL
    */
    SDL_WINDOW_EXTERNAL =             0x0000000000000800,
    
    /**
        Window is modal
    */
    SDL_WINDOW_MODAL =                0x0000000000001000,
    
    /**
        Window uses high pixel density back buffer if possible
    */
    SDL_WINDOW_HIGH_PIXEL_DENSITY =   0x0000000000002000,
    
    /**
        Window has mouse captured (unrelated to MOUSE_GRABBED)
    */
    SDL_WINDOW_MOUSE_CAPTURE =        0x0000000000004000,
    
    /**
        Window has relative mode enabled
    */
    SDL_WINDOW_MOUSE_RELATIVE_MODE =  0x0000000000008000,
    
    /**
        Window should always be above others
    */
    SDL_WINDOW_ALWAYS_ON_TOP =        0x0000000000010000,
    
    /**
        Window should be treated as a utility window, not showing in the task bar and window list
    */
    SDL_WINDOW_UTILITY =              0x0000000000020000,
    
    /**
        Window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window
    */
    SDL_WINDOW_TOOLTIP =              0x0000000000040000,
    
    /**
        Window should be treated as a popup menu, requires a parent window
    */
    SDL_WINDOW_POPUP_MENU =           0x0000000000080000,
    
    /**
        Window has grabbed keyboard input
    */
    SDL_WINDOW_KEYBOARD_GRABBED =     0x0000000000100000,
    
    /**
        Window usable for Vulkan surface
    */
    SDL_WINDOW_VULKAN =               0x0000000010000000,
    
    /**
        Window usable for Metal view
    */
    SDL_WINDOW_METAL =                0x0000000020000000,
    
    /**
        Window with transparent buffer
    */
    SDL_WINDOW_TRANSPARENT =          0x0000000040000000,
    
    /**
        Window should not be focusable
    */
    SDL_WINDOW_NOT_FOCUSABLE =        0x0000000080000000,
}


/**
    A magic value used with SDL_WINDOWPOS_UNDEFINED.

    Generally this macro isn't used directly, but rather through
    SDL_WINDOWPOS_UNDEFINED or SDL_WINDOWPOS_UNDEFINED_DISPLAY.
*/
enum SDL_WINDOWPOS_UNDEFINED_MASK = 0x1FFF0000u;

/**
    Used to indicate that you don't care what the window position is.

    If you _really_ don't care, SDL_WINDOWPOS_UNDEFINED is the same, but always
    uses the primary display instead of specifying one.

    \param X the SDL_DisplayID of the display to use.
*/
enum SDL_WINDOWPOS_UNDEFINED_DISPLAY(alias X) = SDL_WINDOWPOS_UNDEFINED_MASK | X;

/**
    Used to indicate that you don't care what the window position/display is.

    This always uses the primary display.
*/
enum SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_DISPLAY!(0);

/**
    A macro to test if the window position is marked as "undefined."

    \param X the window position value.
*/
enum SDL_WINDOWPOS_ISUNDEFINED(alias X) = ((X & 0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK);

/**
    A magic value used with SDL_WINDOWPOS_CENTERED.

    Generally this macro isn't used directly, but rather through
    SDL_WINDOWPOS_CENTERED or SDL_WINDOWPOS_CENTERED_DISPLAY.
*/
enum SDL_WINDOWPOS_CENTERED_MASK = 0x2FFF0000u;

/**
    Used to indicate that the window position should be centered.

    SDL_WINDOWPOS_CENTERED is the same, but always uses the primary display
    instead of specifying one.

    \param X the SDL_DisplayID of the display to use.
*/
enum SDL_WINDOWPOS_CENTERED_DISPLAY(alias X) = SDL_WINDOWPOS_CENTERED_MASK | X;

/**
    Used to indicate that the window position should be centered.

    This always uses the primary display.
*/
enum SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED_DISPLAY!(0);

/**
    A macro to test if the window position is marked as "centered."

    \param X the window position value.
*/
enum SDL_WINDOWPOS_ISCENTERED(alias X) = (X & 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK;

/**
    Window flash operation.
*/
enum SDL_FlashOperation {
    
    /**
        Cancel any window flash state
    */
    SDL_FLASH_CANCEL,
    
    /**
        Flash the window briefly to get attention
    */
    SDL_FLASH_BRIEFLY,
    
    /**
        Flash the window until it gets focus
    */
    SDL_FLASH_UNTIL_FOCUSED
}

/**
    Progress-state for a window.
*/
enum SDL_ProgressState {
    
    /**
        An invalid progress state indicating an error; check SDL_GetError()
    */
    SDL_PROGRESS_STATE_INVALID = -1,
    
    /**
        No progress bar is shown
    */
    SDL_PROGRESS_STATE_NONE,
    
    /**
        The progress bar is shown in a indeterminate state
    */
    SDL_PROGRESS_STATE_INDETERMINATE,
    
    /**
        The progress bar is shown in a normal state
    */
    SDL_PROGRESS_STATE_NORMAL,
    
    /**
        The progress bar is shown in a paused state
    */
    SDL_PROGRESS_STATE_PAUSED,
    
    /**
        The progress bar is shown in a state indicating the application had an error
    */
    SDL_PROGRESS_STATE_ERROR
}

/**
    An opaque handle to an OpenGL context.
    See_Also:
        $(D SDL_GL_CreateContext)
*/
struct SDL_GLContextState;
alias SDL_GLContext = SDL_GLContextState*;

/**
    Opaque type for an EGL display.
*/
alias SDL_EGLDisplay = void*;

/**
    Opaque type for an EGL config.
*/
alias SDL_EGLConfig = void*;

/**
    Opaque type for an EGL surface.
*/
alias SDL_EGLSurface = void*;

/**
    An EGL attribute, used when creating an EGL context.
*/
alias SDL_EGLAttrib = ptrdiff_t;

/**
    An EGL integer attribute, used when creating an EGL surface.
*/
alias SDL_EGLint = int;

/**
    EGL platform attribute initialization callback.

    This is called when SDL is attempting to create an EGL context, to let the
    app add extra attributes to its eglGetPlatformDisplay() call.

    The callback should return a pointer to an EGL attribute array terminated
    with `EGL_NONE`. If this function returns NULL, the SDL_CreateWindow
    process will fail gracefully.

    The returned pointer should be allocated with SDL_malloc() and will be
    passed to SDL_free().

    The arrays returned by each callback will be appended to the existing
    attribute arrays defined by SDL.

    Params:
        userdata = an app-controlled pointer that is passed to the callback.
    
    Returns:
        a newly-allocated array of attributes, terminated with `EGL_NONE`.

    See_Also:
        $(D SDL_EGL_SetAttributeCallbacks)
*/
alias SDL_EGLAttribArrayCallback = SDL_EGLAttrib* function(void* userdata);

/**
    EGL surface/context attribute initialization callback types.

    This is called when SDL is attempting to create an EGL surface, to let the
    app add extra attributes to its eglCreateWindowSurface() or
    eglCreateContext calls.

    For convenience, the EGLDisplay and EGLConfig to use are provided to the
    callback.

    The callback should return a pointer to an EGL attribute array terminated
    with `EGL_NONE`. If this function returns NULL, the SDL_CreateWindow
    process will fail gracefully.

    The returned pointer should be allocated with SDL_malloc() and will be
    passed to SDL_free().

    The arrays returned by each callback will be appended to the existing
    attribute arrays defined by SDL.

    Params:
        userdata =  an app-controlled pointer that is passed to the callback.
        display =   the EGL display to be used.
        config =    the EGL config to be used.

    Returns:
        a newly-allocated array of attributes, terminated with `EGL_NONE`.

    See_Also:
        $(D SDL_EGL_SetAttributeCallbacks)
*/
alias SDL_EGLIntArrayCallback = SDL_EGLint* function(void* userdata, SDL_EGLDisplay display, SDL_EGLConfig config);


/**
    An enumeration of OpenGL configuration attributes.

    While you can set most OpenGL attributes normally, the attributes listed
    above must be known before SDL creates the window that will be used with
    the OpenGL context. These attributes are set and read with
    SDL_GL_SetAttribute() and SDL_GL_GetAttribute().

    In some cases, these attributes are minimum requests; the GL does not
    promise to give you exactly what you asked for. It's possible to ask for a
    16-bit depth buffer and get a 24-bit one instead, for example, or to ask
    for no stencil buffer and still have one available. Context creation should
    fail if the GL can't provide your requested attributes at a minimum, but
    you should check to see exactly what you got.
*/
enum SDL_GLAttr {
    
    /**
        The minimum number of bits for the red channel of the color buffer; defaults to 3.
    */
    SDL_GL_RED_SIZE,
    
    /**
        The minimum number of bits for the green channel of the color buffer; defaults to 3.
    */
    SDL_GL_GREEN_SIZE,
    
    /**
        The minimum number of bits for the blue channel of the color buffer; defaults to 2.
    */
    SDL_GL_BLUE_SIZE,
    
    /**
        The minimum number of bits for the alpha channel of the color buffer; defaults to 0.
    */
    SDL_GL_ALPHA_SIZE,
    
    /**
        The minimum number of bits for frame buffer size; defaults to 0.
    */
    SDL_GL_BUFFER_SIZE,
    
    /**
        Whether the output is single or double buffered; defaults to double buffering on.
    */
    SDL_GL_DOUBLEBUFFER,
    
    /**
        The minimum number of bits in the depth buffer; defaults to 16.
    */
    SDL_GL_DEPTH_SIZE,
    
    /**
        The minimum number of bits in the stencil buffer; defaults to 0.
    */
    SDL_GL_STENCIL_SIZE,
    
    /**
        The minimum number of bits for the red channel of the accumulation buffer; defaults to 0.
    */
    SDL_GL_ACCUM_RED_SIZE,
    
    /**
        The minimum number of bits for the green channel of the accumulation buffer; defaults to 0.
    */
    SDL_GL_ACCUM_GREEN_SIZE,
    
    /**
        The minimum number of bits for the blue channel of the accumulation buffer; defaults to 0.
    */
    SDL_GL_ACCUM_BLUE_SIZE,
    
    /**
        The minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0.
    */
    SDL_GL_ACCUM_ALPHA_SIZE,
    
    /**
        Whether the output is stereo 3D; defaults to off.
    */
    SDL_GL_STEREO,
    
    /**
        The number of buffers used for multisample anti-aliasing; defaults to 0.
    */
    SDL_GL_MULTISAMPLEBUFFERS,
    
    /**
        The number of samples used around the current pixel used for multisample anti-aliasing.
    */
    SDL_GL_MULTISAMPLESAMPLES,
    
    /**
        Set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either.
    */
    SDL_GL_ACCELERATED_VISUAL,
    
    /**
        Not used (deprecated).
    */
    SDL_GL_RETAINED_BACKING,
    
    /**
        OpenGL context major version.
    */
    SDL_GL_CONTEXT_MAJOR_VERSION,
    
    /**
        OpenGL context minor version.
    */
    SDL_GL_CONTEXT_MINOR_VERSION,
    
    /**
        Some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0.
    */
    SDL_GL_CONTEXT_FLAGS,
    
    /**
        Type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform.
    */
    SDL_GL_CONTEXT_PROFILE_MASK,
    
    /**
        OpenGL context sharing; defaults to 0.
    */
    SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
    
    /**
        Requests sRGB capable visual; defaults to 0.
    */
    SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
    
    /**
        Sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH.
    */
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR,
    
    /**
        Set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION.
    */
    SDL_GL_CONTEXT_RESET_NOTIFICATION,

    /**
        No error reporting
    */
    SDL_GL_CONTEXT_NO_ERROR,

    /**
        Request floating-point buffers.
    */
    SDL_GL_FLOATBUFFERS,

    /**
        EGL Platform.
    */
    SDL_GL_EGL_PLATFORM
}

/**
    Possible values to be set for the SDL_GL_CONTEXT_PROFILE_MASK attribute.
*/
enum SDL_GLProfile : Uint32 {
    
    /**
        OpenGL Core Profile context
    */
    SDL_GL_CONTEXT_PROFILE_CORE =           0x0001,
    
    /**
        OpenGL Compatibility Profile context
    */
    SDL_GL_CONTEXT_PROFILE_COMPATIBILITY =  0x0002,
    
    /**
        GLX_CONTEXT_ES2_PROFILE_BIT_EXT
    */
    SDL_GL_CONTEXT_PROFILE_ES =             0x0004,
}

/**
    Possible flags to be set for the SDL_GL_CONTEXT_FLAGS attribute.
*/
enum SDL_GLContextFlag : Uint32 {
    SDL_GL_CONTEXT_DEBUG_FLAG =              0x0001,
    SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002,
    SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG =      0x0004,
    SDL_GL_CONTEXT_RESET_ISOLATION_FLAG =    0x0008,
}

/**
    Possible values to be set for the SDL_GL_CONTEXT_RELEASE_BEHAVIOR
    attribute.
*/
enum SDL_GLContextReleaseFlag : Uint32 {
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE =   0x0000,
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH =  0x0001,
}

/**
    Possible values to be set SDL_GL_CONTEXT_RESET_NOTIFICATION attribute.
*/
enum SDL_GLContextResetNotification : Uint32 {
    SDL_GL_CONTEXT_RESET_NO_NOTIFICATION =  0x0000,
    SDL_GL_CONTEXT_RESET_LOSE_CONTEXT =     0x0001,
}

/**
    Get the number of video drivers compiled into SDL.

    Returns:
        the number of built in video drivers.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetVideoDriver)
*/
extern int SDL_GetNumVideoDrivers();

/**
    Get the name of a built in video driver.

    The video drivers are presented in the order in which they are normally
    checked during initialization.

    The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
    "x11" or "windows". These never have Unicode characters, and are not meant
    to be proper names.

    Params:
        index = the index of a video driver.
    
    Returns:
        the name of the video driver with the given* *index**.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetNumVideoDrivers)
*/
extern const(char)* SDL_GetVideoDriver(int index);

/**
    Get the name of the currently initialized video driver.

    The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
    "x11" or "windows". These never have Unicode characters, and are not meant
    to be proper names.

    
    Returns:
        the name of the current video driver or NULL if no driver has been
            initialized.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetNumVideoDrivers)
        $(D SDL_GetVideoDriver)
*/
extern const(char)* SDL_GetCurrentVideoDriver();

/**
    Get the current system theme.

    
    Returns:
        the current system theme, light, dark, or unknown.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_SystemTheme SDL_GetSystemTheme();

/**
    Get a list of currently connected displays.

    Params:
        count = a pointer filled in with the number of displays returned, may
                be NULL.
    
    Returns:
        a 0 terminated array of display instance IDs or NULL on failure;
        call SDL_GetError() for more information. This should be freed
        with SDL_free() when it is no longer needed.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_DisplayID*  SDL_GetDisplays(int* count);

/**
    Return the primary display.

    
    Returns:
        the instance ID of the primary display on success or 0 on failure;
            call SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayID SDL_GetPrimaryDisplay();

/**
    Get the properties associated with a display.

    The following read-only properties are provided by SDL:

    - `SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN`: true if the display has HDR
    headroom above the SDR white point. This is for informational and
    diagnostic purposes only, as not all platforms provide this information
    at the display level.

    On KMS/DRM:

    - `SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER`: the "panel
    orientation" property for the display in degrees of clockwise rotation.
    Note that this is provided only as a hint, and the application is
    responsible for any coordinate transformations needed to conform to the
    requested display orientation.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        a valid property ID on success or 0 on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_PropertiesID SDL_GetDisplayProperties(SDL_DisplayID displayID);

enum SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN =             "SDL.display.HDR_enabled";
enum SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER = "SDL.display.KMSDRM.panel_orientation";

/**
    Get the name of a display in UTF-8 encoding.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        the name of a display or NULL on failure; call SDL_GetError() for
            more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplays)
*/
extern const(char)* SDL_GetDisplayName(SDL_DisplayID displayID);

/**
    Get the desktop area represented by a display.

    The primary display is often located at (0,0), but may be placed at a
    different location depending on monitor layout.

    Params:
        displayID = the instance ID of the display to query.
        rect =      the SDL_Rect structure filled in with the display bounds.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplayUsableBounds)
        $(D SDL_GetDisplays)
*/
extern bool SDL_GetDisplayBounds(SDL_DisplayID displayID, SDL_Rect* rect);

/**
    Get the usable desktop area represented by a display, in screen
    coordinates.

    This is the same area as SDL_GetDisplayBounds() reports, but with portions
    reserved by the system removed. For example, on Apple's macOS, this
    subtracts the area occupied by the menu bar and dock.

    Setting a window to be fullscreen generally bypasses these unusable areas,
    so these are good guidelines for the maximum space available to a
    non-fullscreen window.

    Params:
        displayID = the instance ID of the display to query.
        rect =      the SDL_Rect structure filled in with the display bounds.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplayBounds)
        $(D SDL_GetDisplays)
*/
extern bool SDL_GetDisplayUsableBounds(SDL_DisplayID displayID, SDL_Rect* rect);

/**
    Get the orientation of a display when it is unrotated.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        the SDL_DisplayOrientation enum value of the display, or
        `SDL_ORIENTATION_UNKNOWN` if it isn't available.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayOrientation SDL_GetNaturalDisplayOrientation(SDL_DisplayID displayID);

/**
    Get the orientation of a display.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        the SDL_DisplayOrientation enum value of the display, or
            `SDL_ORIENTATION_UNKNOWN` if it isn't available.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayOrientation SDL_GetCurrentDisplayOrientation(SDL_DisplayID displayID);

/**
    Get the content scale of a display.

    The content scale is the expected scale for content based on the DPI
    settings of the display. For example, a 4K display might have a 2.0 (200%)
    display scale, which means that the user expects UI elements to be twice as
    big on this display, to aid in readability.

    After window creation, SDL_GetWindowDisplayScale() should be used to query
    the content scale factor for individual windows instead of querying the
    display for a window and calling this function, as the per-window content
    scale factor may differ from the base value of the display it is on,
    particularly on high-DPI and/or multi-monitor desktop configurations.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        the content scale of the display, or 0.0f on failure; call
            SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowDisplayScale)
        $(D SDL_GetDisplays)
*/
extern float SDL_GetDisplayContentScale(SDL_DisplayID displayID);

/**
    Get a list of fullscreen display modes available on a display.

    The display modes are sorted in this priority:

    - w -> largest to smallest
    - h -> largest to smallest
    - bits per pixel -> more colors to fewer colors
    - packed pixel layout -> largest to smallest
    - refresh rate -> highest to lowest
    - pixel density -> lowest to highest

    Params:
        displayID = the instance ID of the display to query.
        count =     a pointer filled in with the number of display modes returned,
                    may be NULL.
    
    Returns:
        a NULL terminated array of display mode pointers or NULL on
        failure; call SDL_GetError() for more information. This is a
        single allocation that should be freed with SDL_free() when it is
        no longer needed.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayMode* * SDL_GetFullscreenDisplayModes(SDL_DisplayID displayID, int* count);

/**
    Get the closest match to the requested display mode.

    The available display modes are scanned and `closest` is filled in with the
    closest mode matching the requested mode and returned. The mode format and
    refresh rate default to the desktop mode if they are set to 0. The modes
    are scanned with size being first priority, format being second priority,
    and finally checking the refresh rate. If all the available modes are too
    small, then false is returned.

    Params:
        displayID =                     the instance ID of the display to query.
        w =                             the width in pixels of the desired display mode.
        h =                             the height in pixels of the desired display mode.
        refresh_rate =                  the refresh rate of the desired display mode, or 0.0f
                                        for the desktop refresh rate.
        include_high_density_modes =    boolean to include high density modes in
                                        the search.
        closest =                       a pointer filled in with the closest display mode equal to
                                        or larger than the desired mode.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplays)
        $(D SDL_GetFullscreenDisplayModes)
*/
extern bool SDL_GetClosestFullscreenDisplayMode(SDL_DisplayID displayID, int w, int h, float refresh_rate, bool include_high_density_modes, SDL_DisplayMode* closest);

/**
    Get information about the desktop's display mode.

    There's a difference between this function and SDL_GetCurrentDisplayMode()
    when SDL runs fullscreen and has changed the resolution. In that case this
    function will return the previous native display mode, and not the current
    display mode.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        a pointer to the desktop display mode or NULL on failure; call
            SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetCurrentDisplayMode)
        $(D SDL_GetDisplays)
*/
extern const(SDL_DisplayMode)* SDL_GetDesktopDisplayMode(SDL_DisplayID displayID);

/**
    Get information about the current display mode.

    There's a difference between this function and SDL_GetDesktopDisplayMode()
    when SDL runs fullscreen and has changed the resolution. In that case this
    function will return the current display mode, and not the previous native
    display mode.

    Params:
        displayID = the instance ID of the display to query.
    
    Returns:
        a pointer to the desktop display mode or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDesktopDisplayMode)
        $(D SDL_GetDisplays)
*/
extern const(SDL_DisplayMode)* SDL_GetCurrentDisplayMode(SDL_DisplayID displayID);

/**
    Get the display containing a point.

    Params:
        point = the point to query.
    
    Returns:
        the instance ID of the display containing the point or 0 on
        failure; call SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplayBounds)
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayID SDL_GetDisplayForPoint(const(SDL_Point)* point);

/**
    Get the display primarily containing a rect.

    Params:
        rect =  the rect to query.
    
    Returns:
        the instance ID of the display entirely containing the rect or
        closest to the center of the rect on success or 0 on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplayBounds)
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayID SDL_GetDisplayForRect(const(SDL_Rect)* rect);

/**
    Get the display associated with a window.

    Params:
        window =    the window to query.
    
    Returns:
        the instance ID of the display containing the center of the window
        on success or 0 on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetDisplayBounds)
        $(D SDL_GetDisplays)
*/
extern SDL_DisplayID SDL_GetDisplayForWindow(SDL_Window* window);

/**
    Get the pixel density of a window.

    This is a ratio of pixel size to window size. For example, if the window is
    1920x1080 and it has a high density back buffer of 3840x2160 pixels, it
    would have a pixel density of 2.0.

    Params:
        window = the window to query.
    
    Returns:
        the pixel density or 0.0f on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowDisplayScale)
*/
extern float SDL_GetWindowPixelDensity(SDL_Window* window);

/**
    Get the content display scale relative to a window's pixel size.

    This is a combination of the window pixel density and the display content
    scale, and is the expected scale for displaying content in this window. For
    example, if a 3840x2160 window had a display scale of 2.0, the user expects
    the content to take twice as many pixels and be the same physical size as
    if it were being displayed in a 1920x1080 window with a display scale of
    1.0.

    Conceptually this value corresponds to the scale display setting, and is
    updated when that setting is changed, or the window moves to a display with
    a different scale setting.

    Params:
        window = the window to query.
    
    Returns:
        the display scale, or 0.0f on failure; call SDL_GetError() for
            more information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern float SDL_GetWindowDisplayScale(SDL_Window* window);

/**
    Set the display mode to use when a window is visible and fullscreen.

    This only affects the display mode used when the window is fullscreen. To
    change the window size when the window is not fullscreen, use
    SDL_SetWindowSize().

    If the window is currently in the fullscreen state, this request is
    asynchronous on some windowing systems and the new mode dimensions may not
    be applied immediately upon the return of this function. If an immediate
    change is required, call SDL_SyncWindow() to block until the changes have
    taken effect.

    When the new mode takes effect, an SDL_EVENT_WINDOW_RESIZED and/or an
    SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED event will be emitted with the new mode
    dimensions.

    Params:
        window =    the window to affect.
        mode =      a pointer to the display mode to use, which can be NULL for
                    borderless fullscreen desktop mode, or one of the fullscreen
                    modes returned by SDL_GetFullscreenDisplayModes() to set an
                    exclusive fullscreen mode.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowFullscreenMode)
        $(D SDL_SetWindowFullscreen)
        $(D SDL_SyncWindow)
*/
extern bool SDL_SetWindowFullscreenMode(SDL_Window* window, const(SDL_DisplayMode)* mode);

/**
    Query the display mode to use when a window is visible at fullscreen.

    Params:
        window = the window to query.
    
    Returns:
        a pointer to the exclusive fullscreen mode to use or NULL for
        borderless fullscreen desktop mode.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowFullscreenMode)
        $(D SDL_SetWindowFullscreen)
*/
extern const(SDL_DisplayMode)*  SDL_GetWindowFullscreenMode(SDL_Window* window);

/**
    Get the raw ICC profile data for the screen the window is currently on.

    Params:
        window =    the window to query.
        size =      the size of the ICC profile.
    
    Returns:
        the raw ICC profile data on success or NULL on failure; call
        SDL_GetError() for more information. This should be freed with
        SDL_free() when it is no longer needed.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern void*  SDL_GetWindowICCProfile(SDL_Window* window, size_t* size);

/**
    Get the pixel format associated with the window.

    Params:
        window = the window to query.
    
    Returns:
        the pixel format of the window on success or
        SDL_PIXELFORMAT_UNKNOWN on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_PixelFormat SDL_GetWindowPixelFormat(SDL_Window* window);

/**
    Get a list of valid windows.

    Params:
        count = a pointer filled in with the number of windows returned, may
                be NULL.
    
    Returns:
        a NULL terminated array of SDL_Window pointers or NULL on failure;
        call SDL_GetError() for more information. This is a single
        allocation that should be freed with SDL_free() when it is no
        longer needed.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_Window* * SDL_GetWindows(int* count);

/**
    Create a window with the specified dimensions and flags.

    `flags` may be any of the following OR'd together:

    - `SDL_WINDOW_FULLSCREEN`: fullscreen window at desktop resolution
    - `SDL_WINDOW_OPENGL`: window usable with an OpenGL context
    - `SDL_WINDOW_OCCLUDED`: window partially or completely obscured by another
    window
    - `SDL_WINDOW_HIDDEN`: window is not visible
    - `SDL_WINDOW_BORDERLESS`: no window decoration
    - `SDL_WINDOW_RESIZABLE`: window can be resized
    - `SDL_WINDOW_MINIMIZED`: window is minimized
    - `SDL_WINDOW_MAXIMIZED`: window is maximized
    - `SDL_WINDOW_MOUSE_GRABBED`: window has grabbed mouse focus
    - `SDL_WINDOW_INPUT_FOCUS`: window has input focus
    - `SDL_WINDOW_MOUSE_FOCUS`: window has mouse focus
    - `SDL_WINDOW_EXTERNAL`: window not created by SDL
    - `SDL_WINDOW_MODAL`: window is modal
    - `SDL_WINDOW_HIGH_PIXEL_DENSITY`: window uses high pixel density back
    buffer if possible
    - `SDL_WINDOW_MOUSE_CAPTURE`: window has mouse captured (unrelated to
    MOUSE_GRABBED)
    - `SDL_WINDOW_ALWAYS_ON_TOP`: window should always be above others
    - `SDL_WINDOW_UTILITY`: window should be treated as a utility window, not
    showing in the task bar and window list
    - `SDL_WINDOW_TOOLTIP`: window should be treated as a tooltip and does not
    get mouse or keyboard focus, requires a parent window
    - `SDL_WINDOW_POPUP_MENU`: window should be treated as a popup menu,
    requires a parent window
    - `SDL_WINDOW_KEYBOARD_GRABBED`: window has grabbed keyboard input
    - `SDL_WINDOW_VULKAN`: window usable with a Vulkan instance
    - `SDL_WINDOW_METAL`: window usable with a Metal instance
    - `SDL_WINDOW_TRANSPARENT`: window with transparent buffer
    - `SDL_WINDOW_NOT_FOCUSABLE`: window should not be focusable

    The SDL_Window is implicitly shown if SDL_WINDOW_HIDDEN is not set.

    On Apple's macOS, you* *must** set the NSHighResolutionCapable Info.plist
    property to YES, otherwise you will not receive a High-DPI OpenGL canvas.

    The window pixel size may differ from its window coordinate size if the
    window is on a high pixel density display. Use SDL_GetWindowSize() to query
    the client area's size in window coordinates, and
    SDL_GetWindowSizeInPixels() or SDL_GetRenderOutputSize() to query the
    drawable size in pixels. Note that the drawable size can vary after the
    window is created and should be queried again if you get an
    SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED event.

    If the window is created with any of the SDL_WINDOW_OPENGL or
    SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
    (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
    corresponding UnloadLibrary function is called by SDL_DestroyWindow().

    If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
    SDL_CreateWindow() will fail, because SDL_Vulkan_LoadLibrary() will fail.

    If SDL_WINDOW_METAL is specified on an OS that does not support Metal,
    SDL_CreateWindow() will fail.

    If you intend to use this window with an SDL_Renderer, you should use
    SDL_CreateWindowAndRenderer() instead of this function, to avoid window
    flicker.

    On non-Apple devices, SDL requires you to either not link to the Vulkan
    loader or link to a dynamic library version. This limitation may be removed
    in a future version of SDL.

    Params:
        title = the title of the window, in UTF-8 encoding.
        w =     the width of the window.
        h =     the height of the window.
        flags = 0, or one or more SDL_WindowFlags OR'd together.
    
    Returns:
        the window that was created or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateWindowAndRenderer)
        $(D SDL_CreatePopupWindow)
        $(D SDL_CreateWindowWithProperties)
        $(D SDL_DestroyWindow)
*/
extern SDL_Window*  SDL_CreateWindow(const(char)* title, int w, int h, SDL_WindowFlags flags);

/**
    Create a child popup window of the specified parent window.

    The flags parameter* *must** contain at least one of the following:

    - `SDL_WINDOW_TOOLTIP`: The popup window is a tooltip and will not pass any
    input events.
    - `SDL_WINDOW_POPUP_MENU`: The popup window is a popup menu. The topmost
    popup menu will implicitly gain the keyboard focus.

    The following flags are not relevant to popup window creation and will be
    ignored:

    - `SDL_WINDOW_MINIMIZED`
    - `SDL_WINDOW_MAXIMIZED`
    - `SDL_WINDOW_FULLSCREEN`
    - `SDL_WINDOW_BORDERLESS`

    The following flags are incompatible with popup window creation and will
    cause it to fail:

    - `SDL_WINDOW_UTILITY`
    - `SDL_WINDOW_MODAL`

    The parent parameter* *must** be non-null and a valid window. The parent of
    a popup window can be either a regular, toplevel window, or another popup
    window.

    Popup windows cannot be minimized, maximized, made fullscreen, raised,
    flash, be made a modal window, be the parent of a toplevel window, or grab
    the mouse and/or keyboard. Attempts to do so will fail.

    Popup windows implicitly do not have a border/decorations and do not appear
    on the taskbar/dock or in lists of windows such as alt-tab menus.

    If a parent window is hidden or destroyed, any child popup windows will be
    recursively hidden or destroyed as well. Child popup windows not explicitly
    hidden will be restored when the parent is shown.

    Params:
        parent =    the parent of the window, must not be NULL.
        offset_x =  the x position of the popup window relative to the origin
                    of the parent.
        offset_y =  the y position of the popup window relative to the origin
                    of the parent window.
        w =         the width of the window.
        h =         the height of the window.
        flags =     SDL_WINDOW_TOOLTIP or SDL_WINDOW_POPUP_MENU, and zero or more
                    additional SDL_WindowFlags OR'd together.
    
    Returns:
        the window that was created or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateWindow)
        $(D SDL_CreateWindowWithProperties)
        $(D SDL_DestroyWindow)
        $(D SDL_GetWindowParent)
*/
extern SDL_Window*  SDL_CreatePopupWindow(SDL_Window* parent, int offset_x, int offset_y, int w, int h, SDL_WindowFlags flags);

/**
    Create a window with the specified properties.

    These are the supported properties:

    -   `SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN`: true if the window should
        be always on top
    -   `SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN`: true if the window has no
        window decoration
    -   `SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN`: true if the
        window will be used with an externally managed graphics context.
    -   `SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN`: true if the window should
        accept keyboard input (defaults true)
    -   `SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN`: true if the window should
        start in fullscreen mode at desktop resolution
    -   `SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER`: the height of the window
    -   `SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN`: true if the window should start
        hidden
    -   `SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN`: true if the window
        uses a high pixel density buffer if possible
    -   `SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN`: true if the window should
        start maximized
    -   `SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN`: true if the window is a popup menu
    -   `SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN`: true if the window will be used
        with Metal rendering
    -   `SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN`: true if the window should
        start minimized
    -   `SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN`: true if the window is modal to
        its parent
    -   `SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN`: true if the window starts
        with grabbed mouse focus
    -   `SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN`: true if the window will be used
        with OpenGL rendering
    -   `SDL_PROP_WINDOW_CREATE_PARENT_POINTER`: an SDL_Window that will be the
        parent of this window, required for windows with the "tooltip", "menu",
        and "modal" properties
    -   `SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN`: true if the window should be
        resizable
    -   `SDL_PROP_WINDOW_CREATE_TITLE_STRING`: the title of the window, in UTF-8
        encoding
    -   `SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN`: true if the window show
        transparent in the areas with alpha of 0
    -   `SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN`: true if the window is a tooltip
    -   `SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN`: true if the window is a utility
        window, not showing in the task bar and window list
    -   `SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN`: true if the window will be used
        with Vulkan rendering
    -   `SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER`: the width of the window
    -   `SDL_PROP_WINDOW_CREATE_X_NUMBER`: the x position of the window, or
        `SDL_WINDOWPOS_CENTERED`, defaults to `SDL_WINDOWPOS_UNDEFINED`. This is
        relative to the parent for windows with the "tooltip" or "menu" property
        set.
    -   `SDL_PROP_WINDOW_CREATE_Y_NUMBER`: the y position of the window, or
        `SDL_WINDOWPOS_CENTERED`, defaults to `SDL_WINDOWPOS_UNDEFINED`. This is
        relative to the parent for windows with the "tooltip" or "menu" property
        set.

    These are additional supported properties on macOS:

    - `SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER`: the
    `(__unsafe_unretained)` NSWindow associated with the window, if you want
    to wrap an existing window.
    - `SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER`: the `(__unsafe_unretained)`
    NSView associated with the window, defaults to `[window contentView]`

    These are additional supported properties on Wayland:

    - `SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN` - true if
    the application wants to use the Wayland surface for a custom role and
    does not want it attached to an XDG toplevel window. See
    [README/wayland](README/wayland) for more information on using custom
    surfaces.
    - `SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN` - true if the
    application wants an associated `wl_egl_window` object to be created and
    attached to the window, even if the window does not have the OpenGL
    property or `SDL_WINDOW_OPENGL` flag set.
    - `SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER` - the wl_surface
    associated with the window, if you want to wrap an existing window. See
    [README/wayland](README/wayland) for more information.

    These are additional supported properties on Windows:

    - `SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER`: the HWND associated with the
    window, if you want to wrap an existing window.
    - `SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER`: optional,
    another window to share pixel format with, useful for OpenGL windows

    These are additional supported properties with X11:

    - `SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER`: the X11 Window associated
    with the window, if you want to wrap an existing window.

    The window is implicitly shown if the "hidden" property is not set.

    Windows with the "tooltip" and "menu" properties are popup windows and have
    the behaviors and guidelines outlined in SDL_CreatePopupWindow().

    If this window is being created to be used with an SDL_Renderer, you should
    not add a graphics API specific property
    (`SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN`, etc), as SDL will handle that
    internally when it chooses a renderer. However, SDL might need to recreate
    your window at that point, which may cause the window to appear briefly,
    and then flicker as it is recreated. The correct approach to this is to
    create the window with the `SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN` property
    set to true, then create the renderer, then show the window with
    SDL_ShowWindow().

    Params:
        props = the properties to use.
    
    Returns:
        the window that was created or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateProperties)
        $(D SDL_CreateWindow)
        $(D SDL_DestroyWindow)
*/
extern SDL_Window* SDL_CreateWindowWithProperties(SDL_PropertiesID props);

enum SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN =               "SDL.window.create.always_on_top";
enum SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN =                  "SDL.window.create.borderless";
enum SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN =                   "SDL.window.create.focusable";
enum SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN =   "SDL.window.create.external_graphics_context";
enum SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER =                        "SDL.window.create.flags";
enum SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN =                  "SDL.window.create.fullscreen";
enum SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER =                       "SDL.window.create.height";
enum SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN =                      "SDL.window.create.hidden";
enum SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN =          "SDL.window.create.high_pixel_density";
enum SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN =                   "SDL.window.create.maximized";
enum SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN =                        "SDL.window.create.menu";
enum SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN =                       "SDL.window.create.metal";
enum SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN =                   "SDL.window.create.minimized";
enum SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN =                       "SDL.window.create.modal";
enum SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN =               "SDL.window.create.mouse_grabbed";
enum SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN =                      "SDL.window.create.opengl";
enum SDL_PROP_WINDOW_CREATE_PARENT_POINTER =                      "SDL.window.create.parent";
enum SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN =                   "SDL.window.create.resizable";
enum SDL_PROP_WINDOW_CREATE_TITLE_STRING =                        "SDL.window.create.title";
enum SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN =                 "SDL.window.create.transparent";
enum SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN =                     "SDL.window.create.tooltip";
enum SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN =                     "SDL.window.create.utility";
enum SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN =                      "SDL.window.create.vulkan";
enum SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER =                        "SDL.window.create.width";
enum SDL_PROP_WINDOW_CREATE_X_NUMBER =                            "SDL.window.create.x";
enum SDL_PROP_WINDOW_CREATE_Y_NUMBER =                            "SDL.window.create.y";
enum SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER =                "SDL.window.create.cocoa.window";
enum SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER =                  "SDL.window.create.cocoa.view";
enum SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN = "SDL.window.create.wayland.surface_role_custom";
enum SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN =   "SDL.window.create.wayland.create_egl_window";
enum SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER =          "SDL.window.create.wayland.wl_surface";
enum SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER =                  "SDL.window.create.win32.hwnd";
enum SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER =     "SDL.window.create.win32.pixel_format_hwnd";
enum SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER =                   "SDL.window.create.x11.window";

/**
    Get the numeric ID of a window.

    The numeric ID is what SDL_WindowEvent references, and is necessary to map
    these events to specific SDL_Window objects.

    Params:
        window = the window to query.
    
    Returns:
        the ID of the window on success or 0 on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowFromID)
*/
extern SDL_WindowID SDL_GetWindowID(SDL_Window* window);

/**
    Get a window from a stored ID.

    The numeric ID is what SDL_WindowEvent references, and is necessary to map
    these events to specific SDL_Window objects.

    Params:
        id = the ID of the window.
    
    Returns:
        the window associated with `id` or NULL if it doesn't exist; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowID)
*/
extern SDL_Window*  SDL_GetWindowFromID(SDL_WindowID id);

/**
    Get parent of a window.

    Params:
        window = the window to query.
    
    Returns:
        the parent of the window on success or NULL if the window has no
        parent.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreatePopupWindow)
*/
extern SDL_Window*  SDL_GetWindowParent(SDL_Window* window);

/**
    Get the properties associated with a window.

    The following read-only properties are provided by SDL:

    -   `SDL_PROP_WINDOW_SHAPE_POINTER`: the surface associated with a shaped
        window
    -   `SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN`: true if the window has HDR
        headroom above the SDR white point. This property can change dynamically
        when SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
    -   `SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT`: the value of SDR white in the
        SDL_COLORSPACE_SRGB_LINEAR colorspace. On Windows this corresponds to the
        SDR white level in scRGB colorspace, and on Apple platforms this is
        always 1.0 for EDR content. This property can change dynamically when
        SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.
    -   `SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT`: the additional high dynamic range
        that can be displayed, in terms of the SDR white point. When HDR is not
        enabled, this will be 1.0. This property can change dynamically when
        SDL_EVENT_WINDOW_HDR_STATE_CHANGED is sent.

    On Android:

    -   `SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER`: the ANativeWindow associated
        with the window
    -   `SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER`: the EGLSurface associated with
        the window

    On iOS:

    -   `SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER`: the `(__unsafe_unretained)`
        UIWindow associated with the window
    -   `SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER`: the NSInteger tag
        associated with metal views on the window
    -   `SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER`: the OpenGL view's
        framebuffer object. It must be bound when rendering to the screen using
        OpenGL.
    -   `SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER`: the OpenGL view's
        renderbuffer object. It must be bound when SDL_GL_SwapWindow is called.
    -   `SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER`: the OpenGL
        view's resolve framebuffer, when MSAA is used.

    On KMS/DRM:

    -   `SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER`: the device index associated
        with the window (e.g. the X in /dev/dri/cardX)
    -   `SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER`: the DRM FD associated with the
        window
    -   `SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER`: the GBM device associated
        with the window

    On macOS:

    -   `SDL_PROP_WINDOW_COCOA_WINDOW_POINTER`: the `(__unsafe_unretained)`
        NSWindow associated with the window
    -   `SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER`: the NSInteger tag
        assocated with metal views on the window

    On OpenVR:

    -   `SDL_PROP_WINDOW_OPENVR_OVERLAY_ID`: the OpenVR Overlay Handle ID for the
        associated overlay window.

    On Vivante:

    -   `SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER`: the EGLNativeDisplayType
        associated with the window
    -   `SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER`: the EGLNativeWindowType
        associated with the window
    -   `SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER`: the EGLSurface associated with
        the window

    On Windows:

    -   `SDL_PROP_WINDOW_WIN32_HWND_POINTER`: the HWND associated with the window
    -   `SDL_PROP_WINDOW_WIN32_HDC_POINTER`: the HDC associated with the window
    -   `SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER`: the HINSTANCE associated with
        the window

    On Wayland:

    Note: The `xdg_*` window objects do not internally persist across window
    show/hide calls. They will be null if the window is hidden and must be
    queried each time it is shown.

    -   `SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER`: the wl_display associated with
        the window
    -   `SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER`: the wl_surface associated with
        the window
    -   `SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER`: the wp_viewport associated
        with the window
    -   `SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER`: the wl_egl_window
        associated with the window
    -   `SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER`: the xdg_surface associated
        with the window
    -   `SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER`: the xdg_toplevel role
        associated with the window
    -   'SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING': the export
        handle associated with the window
    -   `SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER`: the xdg_popup role
        associated with the window
    -   `SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER`: the xdg_positioner
        associated with the window, in popup mode

    On X11:

    -   `SDL_PROP_WINDOW_X11_DISPLAY_POINTER`: the X11 Display associated with
        the window
    -   `SDL_PROP_WINDOW_X11_SCREEN_NUMBER`: the screen number associated with
        the window
    -   `SDL_PROP_WINDOW_X11_WINDOW_NUMBER`: the X11 Window associated with the
        window

    Params:
        window = the window to query.
    
    Returns:
        a valid property ID on success or 0 on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern SDL_PropertiesID SDL_GetWindowProperties(SDL_Window* window);

enum SDL_PROP_WINDOW_SHAPE_POINTER =                               "SDL.window.shape";
enum SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN =                         "SDL.window.HDR_enabled";
enum SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT =                       "SDL.window.SDR_white_level";
enum SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT =                          "SDL.window.HDR_headroom";
enum SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER =                      "SDL.window.android.window";
enum SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER =                     "SDL.window.android.surface";
enum SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER =                        "SDL.window.uikit.window";
enum SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER =                 "SDL.window.uikit.metal_view_tag";
enum SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER =             "SDL.window.uikit.opengl.framebuffer";
enum SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER =            "SDL.window.uikit.opengl.renderbuffer";
enum SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER =     "SDL.window.uikit.opengl.resolve_framebuffer";
enum SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER =                  "SDL.window.kmsdrm.dev_index";
enum SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER =                        "SDL.window.kmsdrm.drm_fd";
enum SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER =                   "SDL.window.kmsdrm.gbm_dev";
enum SDL_PROP_WINDOW_COCOA_WINDOW_POINTER =                        "SDL.window.cocoa.window";
enum SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER =                 "SDL.window.cocoa.metal_view_tag";
enum SDL_PROP_WINDOW_OPENVR_OVERLAY_ID =                           "SDL.window.openvr.overlay_id";
enum SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER =                     "SDL.window.vivante.display";
enum SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER =                      "SDL.window.vivante.window";
enum SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER =                     "SDL.window.vivante.surface";
enum SDL_PROP_WINDOW_WIN32_HWND_POINTER =                          "SDL.window.win32.hwnd";
enum SDL_PROP_WINDOW_WIN32_HDC_POINTER =                           "SDL.window.win32.hdc";
enum SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER =                      "SDL.window.win32.instance";
enum SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER =                     "SDL.window.wayland.display";
enum SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER =                     "SDL.window.wayland.surface";
enum SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER =                    "SDL.window.wayland.viewport";
enum SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER =                  "SDL.window.wayland.egl_window";
enum SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER =                 "SDL.window.wayland.xdg_surface";
enum SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER =                "SDL.window.wayland.xdg_toplevel";
enum SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING =   "SDL.window.wayland.xdg_toplevel_export_handle";
enum SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER =                   "SDL.window.wayland.xdg_popup";
enum SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER =              "SDL.window.wayland.xdg_positioner";
enum SDL_PROP_WINDOW_X11_DISPLAY_POINTER =                         "SDL.window.x11.display";
enum SDL_PROP_WINDOW_X11_SCREEN_NUMBER =                           "SDL.window.x11.screen";
enum SDL_PROP_WINDOW_X11_WINDOW_NUMBER =                           "SDL.window.x11.window";

/**
    Get the window flags.

    Params:
        window = the window to query.
    
    Returns:
        a mask of the SDL_WindowFlags associated with `window`.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateWindow)
        $(D SDL_HideWindow)
        $(D SDL_MaximizeWindow)
        $(D SDL_MinimizeWindow)
        $(D SDL_SetWindowFullscreen)
        $(D SDL_SetWindowMouseGrab)
        $(D SDL_ShowWindow)
*/
extern SDL_WindowFlags SDL_GetWindowFlags(SDL_Window* window);

/**
    Set the title of a window.

    This string is expected to be in UTF-8 encoding.

    Params:
        window =    the window to change.
        title =     the desired window title in UTF-8 format.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowTitle)
*/
extern bool SDL_SetWindowTitle(SDL_Window* window, const(char)* title);

/**
    Get the title of a window.

    Params:
        window = the window to query.
    
    Returns:
        the title of the window in UTF-8 format or "" if there is no
        title.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowTitle)
*/
extern const(char)*  SDL_GetWindowTitle(SDL_Window* window);

/**
    Set the icon for a window.

    If this function is passed a surface with alternate representations, the
    surface will be interpreted as the content to be used for 100% display
    scale, and the alternate representations will be used for high DPI
    situations. For example, if the original surface is 32x32, then on a 2x
    macOS display or 200% display scale on Windows, a 64x64 version of the
    image will be used, if available. If a matching version of the image isn't
    available, the closest larger size image will be downscaled to the
    appropriate size and be used instead, if available. Otherwise, the closest
    smaller image will be upscaled and be used instead.

    Params:
        window =    the window to change.
        icon =      an SDL_Surface structure containing the icon for the window.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern bool SDL_SetWindowIcon(SDL_Window* window, SDL_Surface* icon);

/**
    Request that the window's position be set.

    If the window is in an exclusive fullscreen or maximized state, this
    request has no effect.

    This can be used to reposition fullscreen-desktop windows onto a different
    display, however, as exclusive fullscreen windows are locked to a specific
    display, they can only be repositioned programmatically via
    SDL_SetWindowFullscreenMode().

    On some windowing systems this request is asynchronous and the new
    coordinates may not have have been applied immediately upon the return of
    this function. If an immediate change is required, call SDL_SyncWindow() to
    block until the changes have taken effect.

    When the window position changes, an SDL_EVENT_WINDOW_MOVED event will be
    emitted with the window's new coordinates. Note that the new coordinates
    may not match the exact coordinates requested, as some windowing systems
    can restrict the position of the window in certain scenarios (e.g.
    constraining the position so the window is always within desktop bounds).
    Additionally, as this is just a request, it can be denied by the windowing
    system.

    Params:
        window =    the window to reposition.
        x =         the x coordinate of the window, or `SDL_WINDOWPOS_CENTERED` or
                    `SDL_WINDOWPOS_UNDEFINED`.
        y =         the y coordinate of the window, or `SDL_WINDOWPOS_CENTERED` or
                    `SDL_WINDOWPOS_UNDEFINED`.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowPosition)
        $(D SDL_SyncWindow)
*/
extern bool SDL_SetWindowPosition(SDL_Window* window, int x, int y);

/**
    Get the position of a window.

    This is the current position of the window as last reported by the
    windowing system.

    If you do not need the value for one of the positions a NULL may be passed
    in the `x` or `y` parameter.

    Params:
        window =    the window to query.
        x =         a pointer filled in with the x position of the window, may be
                    NULL.
        y =         a pointer filled in with the y position of the window, may be
                    NULL.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowPosition)
*/
extern bool SDL_GetWindowPosition(SDL_Window* window, int* x, int* y);

/**
    Request that the size of a window's client area be set.

    If the window is in a fullscreen or maximized state, this request has no
    effect.

    To change the exclusive fullscreen mode of a window, use
    SDL_SetWindowFullscreenMode().

    On some windowing systems, this request is asynchronous and the new window
    size may not have have been applied immediately upon the return of this
    function. If an immediate change is required, call SDL_SyncWindow() to
    block until the changes have taken effect.

    When the window size changes, an SDL_EVENT_WINDOW_RESIZED event will be
    emitted with the new window dimensions. Note that the new dimensions may
    not match the exact size requested, as some windowing systems can restrict
    the window size in certain scenarios (e.g. constraining the size of the
    content area to remain within the usable desktop bounds). Additionally, as
    this is just a request, it can be denied by the windowing system.

    Params:
        window =    the window to change.
        w =         the width of the window, must be > 0.
        h =         the height of the window, must be > 0.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSize)
        $(D SDL_SetWindowFullscreenMode)
        $(D SDL_SyncWindow)
*/
extern bool SDL_SetWindowSize(SDL_Window* window, int w, int h);

/**
    Get the size of a window's client area.

    The window pixel size may differ from its window coordinate size if the
    window is on a high pixel density display. Use SDL_GetWindowSizeInPixels()
    or SDL_GetRenderOutputSize() to get the real client area size in pixels.

    Params:
        window =    the window to query the width and height from.
        w =         a pointer filled in with the width of the window, may be NULL.
        h =         a pointer filled in with the height of the window, may be NULL.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderOutputSize)
        $(D SDL_GetWindowSizeInPixels)
        $(D SDL_SetWindowSize)
*/
extern bool SDL_GetWindowSize(SDL_Window* window, int* w, int* h);

/**
    Get the safe area for this window.

    Some devices have portions of the screen which are partially obscured or
    not interactive, possibly due to on-screen controls, curved edges, camera
    notches, TV overscan, etc. This function provides the area of the window
    which is safe to have interactable content. You should continue rendering
    into the rest of the window, but it should not contain visually important
    or interactible content.

    Params:
        window =    the window to query.
        rect =      a pointer filled in with the client area that is safe for
                    interactive content.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_GetWindowSafeArea(SDL_Window* window, SDL_Rect* rect);

/**
    Request that the aspect ratio of a window's client area be set.

    The aspect ratio is the ratio of width divided by height, e.g. 2560x1600
    would be 1.6. Larger aspect ratios are wider and smaller aspect ratios are
    narrower.

    If, at the time of this request, the window in a fixed-size state, such as
    maximized or fullscreen, the request will be deferred until the window
    exits this state and becomes resizable again.

    On some windowing systems, this request is asynchronous and the new window
    aspect ratio may not have have been applied immediately upon the return of
    this function. If an immediate change is required, call SDL_SyncWindow() to
    block until the changes have taken effect.

    When the window size changes, an SDL_EVENT_WINDOW_RESIZED event will be
    emitted with the new window dimensions. Note that the new dimensions may
    not match the exact aspect ratio requested, as some windowing systems can
    restrict the window size in certain scenarios (e.g. constraining the size
    of the content area to remain within the usable desktop bounds).
    Additionally, as this is just a request, it can be denied by the windowing
    system.

    Params:
        window =        the window to change.
        min_aspect =    the minimum aspect ratio of the window, or 0.0f for no
                        limit.
        max_aspect =    the maximum aspect ratio of the window, or 0.0f for no
                        limit.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowAspectRatio)
        $(D SDL_SyncWindow)
*/
extern bool SDL_SetWindowAspectRatio(SDL_Window* window, float min_aspect, float max_aspect);

/**
    Get the size of a window's client area.

    Params:
        window =        the window to query the width and height from.
        min_aspect =    a pointer filled in with the minimum aspect ratio of the
                        window, may be NULL.
        max_aspect =    a pointer filled in with the maximum aspect ratio of the
                        window, may be NULL.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowAspectRatio)
*/
extern bool SDL_GetWindowAspectRatio(SDL_Window* window, float* min_aspect, float* max_aspect);

/**
    Get the size of a window's borders (decorations) around the client area.

    Note: If this function fails (returns false), the size values will be
    initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as if the
    window in question was borderless.

    Note: This function may fail on systems where the window has not yet been
    decorated by the display server (for example, immediately after calling
    SDL_CreateWindow). It is recommended that you wait at least until the
    window has been presented and composited, so that the window system has a
    chance to decorate the window and provide the border dimensions to SDL.

    This function also returns false if getting the information is not
    supported.

    Params:
        window =    the window to query the size values of the border
                    (decorations) from.
        top =       pointer to variable for storing the size of the top border; NULL
                    is permitted.
        left =      pointer to variable for storing the size of the left border;
                    NULL is permitted.
        bottom =    pointer to variable for storing the size of the bottom
                    border; NULL is permitted.
        right =     pointer to variable for storing the size of the right border;
                    NULL is permitted.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSize)
*/
extern bool SDL_GetWindowBordersSize(SDL_Window* window, int* top, int* left, int* bottom, int* right);

/**
    Get the size of a window's client area, in pixels.

    Params:
        window =    the window from which the drawable size should be queried.
        w =         a pointer to variable for storing the width in pixels, may be
                    NULL.
        h =         a pointer to variable for storing the height in pixels, may be
                    NULL.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateWindow)
        $(D SDL_GetWindowSize)
*/
extern bool SDL_GetWindowSizeInPixels(SDL_Window* window, int* w, int* h);

/**
    Set the minimum size of a window's client area.

    Params:
    window =    the window to change.
    min_w =     the minimum width of the window, or 0 for no limit.
    min_h =     the minimum height of the window, or 0 for no limit.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMinimumSize)
        $(D SDL_SetWindowMaximumSize)
*/
extern bool SDL_SetWindowMinimumSize(SDL_Window* window, int min_w, int min_h);

/**
    Get the minimum size of a window's client area.

    Params:
        window =    the window to query.
        w =         a pointer filled in with the minimum width of the window, may be
                    NULL.
        h =         a pointer filled in with the minimum height of the window, may be
                    NULL.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMaximumSize)
        $(D SDL_SetWindowMinimumSize)
*/
extern bool SDL_GetWindowMinimumSize(SDL_Window* window, int* w, int* h);

/**
    Set the maximum size of a window's client area.

    Params:
        window =    the window to change.
        max_w =     the maximum width of the window, or 0 for no limit.
        max_h =     the maximum height of the window, or 0 for no limit.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMaximumSize)
        $(D SDL_SetWindowMinimumSize)
*/
extern bool SDL_SetWindowMaximumSize(SDL_Window* window, int max_w, int max_h);

/**
    Get the maximum size of a window's client area.

    Params:
        window =    the window to query.
        w =         a pointer filled in with the maximum width of the window, may be
                    NULL.
        h =         a pointer filled in with the maximum height of the window, may be
                    NULL.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMinimumSize)
        $(D SDL_SetWindowMaximumSize)
*/
extern bool SDL_GetWindowMaximumSize(SDL_Window* window, int* w, int* h);

/**
    Set the border state of a window.

    This will add or remove the window's `SDL_WINDOW_BORDERLESS` flag and add
    or remove the border from the actual window. This is a no-op if the
    window's border already matches the requested state.

    You can't change the border state of a fullscreen window.

    Params:
        window =    the window of which to change the border state.
        bordered =  false to remove border, true to add border.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowFlags)
*/
extern bool SDL_SetWindowBordered(SDL_Window* window, bool bordered);

/**
    Set the user-resizable state of a window.

    This will add or remove the window's `SDL_WINDOW_RESIZABLE` flag and
    allow/disallow user resizing of the window. This is a no-op if the window's
    resizable state already matches the requested state.

    You can't change the resizable state of a fullscreen window.

    Params:
        window =    the window of which to change the resizable state.
        resizable = true to allow resizing, false to disallow.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowFlags)
*/
extern bool SDL_SetWindowResizable(SDL_Window* window, bool resizable);

/**
    Set the window to always be above the others.

    This will add or remove the window's `SDL_WINDOW_ALWAYS_ON_TOP` flag. This
    will bring the window to the front and keep the window above the rest.

    Params:
        window =    the window of which to change the always on top state.
        on_top =    true to set the window always on top, false to disable.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowFlags)
*/
extern bool SDL_SetWindowAlwaysOnTop(SDL_Window* window, bool on_top);

/**
    Show a window.

    Params:
        window = the window to show.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_HideWindow)
        $(D SDL_RaiseWindow)
*/
extern bool SDL_ShowWindow(SDL_Window* window);

/**
    Hide a window.

    Params:
        window = the window to hide.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_ShowWindow)
        $(D SDL_WINDOW_HIDDEN)
*/
extern bool SDL_HideWindow(SDL_Window* window);

/**
    Request that a window be raised above other windows and gain the input
    focus.

    The result of this request is subject to desktop window manager policy,
    particularly if raising the requested window would result in stealing focus
    from another application. If the window is successfully raised and gains
    input focus, an SDL_EVENT_WINDOW_FOCUS_GAINED event will be emitted, and
    the window will have the SDL_WINDOW_INPUT_FOCUS flag set.

    Params:
        window = the window to raise.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_RaiseWindow(SDL_Window* window);

/**
    Request that the window be made as large as possible.

    Non-resizable windows can't be maximized. The window must have the
    SDL_WINDOW_RESIZABLE flag set, or this will have no effect.

    On some windowing systems this request is asynchronous and the new window
    state may not have have been applied immediately upon the return of this
    function. If an immediate change is required, call SDL_SyncWindow() to
    block until the changes have taken effect.

    When the window state changes, an SDL_EVENT_WINDOW_MAXIMIZED event will be
    emitted. Note that, as this is just a request, the windowing system can
    deny the state change.

    When maximizing a window, whether the constraints set via
    SDL_SetWindowMaximumSize() are honored depends on the policy of the window
    manager. Win32 and macOS enforce the constraints when maximizing, while X11
    and Wayland window managers may vary.

    Params:
        window = the window to maximize.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_MinimizeWindow)
        $(D SDL_RestoreWindow)
        $(D SDL_SyncWindow)
*/
extern bool SDL_MaximizeWindow(SDL_Window* window);

/**
    Request that the window be minimized to an iconic representation.

    If the window is in a fullscreen state, this request has no direct effect.
    It may alter the state the window is returned to when leaving fullscreen.

    On some windowing systems this request is asynchronous and the new window
    state may not have been applied immediately upon the return of this
    function. If an immediate change is required, call SDL_SyncWindow() to
    block until the changes have taken effect.

    When the window state changes, an SDL_EVENT_WINDOW_MINIMIZED event will be
    emitted. Note that, as this is just a request, the windowing system can
    deny the state change.

    Params:
        window = the window to minimize.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_MaximizeWindow)
        $(D SDL_RestoreWindow)
        $(D SDL_SyncWindow)
*/
extern bool SDL_MinimizeWindow(SDL_Window* window);

/**
    Request that the size and position of a minimized or maximized window be
    restored.

    If the window is in a fullscreen state, this request has no direct effect.
    It may alter the state the window is returned to when leaving fullscreen.

    On some windowing systems this request is asynchronous and the new window
    state may not have have been applied immediately upon the return of this
    function. If an immediate change is required, call SDL_SyncWindow() to
    block until the changes have taken effect.

    When the window state changes, an SDL_EVENT_WINDOW_RESTORED event will be
    emitted. Note that, as this is just a request, the windowing system can
    deny the state change.

    Params:
        window = the window to restore.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_MaximizeWindow)
        $(D SDL_MinimizeWindow)
        $(D SDL_SyncWindow)
*/
extern bool SDL_RestoreWindow(SDL_Window* window);

/**
    Request that the window's fullscreen state be changed.

    By default a window in fullscreen state uses borderless fullscreen desktop
    mode, but a specific exclusive display mode can be set using
    SDL_SetWindowFullscreenMode().

    On some windowing systems this request is asynchronous and the new
    fullscreen state may not have have been applied immediately upon the return
    of this function. If an immediate change is required, call SDL_SyncWindow()
    to block until the changes have taken effect.

    When the window state changes, an SDL_EVENT_WINDOW_ENTER_FULLSCREEN or
    SDL_EVENT_WINDOW_LEAVE_FULLSCREEN event will be emitted. Note that, as this
    is just a request, it can be denied by the windowing system.

    Params:
        window =        the window to change.
        fullscreen =    true for fullscreen mode, false for windowed mode.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowFullscreenMode)
        $(D SDL_SetWindowFullscreenMode)
        $(D SDL_SyncWindow)
        $(D SDL_WINDOW_FULLSCREEN)
*/
extern bool SDL_SetWindowFullscreen(SDL_Window* window, bool fullscreen);

/**
    Block until any pending window state is finalized.

    On asynchronous windowing systems, this acts as a synchronization barrier
    for pending window state. It will attempt to wait until any pending window
    state has been applied and is guaranteed to return within finite time. Note
    that for how long it can potentially block depends on the underlying window
    system, as window state changes may involve somewhat lengthy animations
    that must complete before the window is in its final requested state.

    On windowing systems where changes are immediate, this does nothing.

    Params:
        window =    the window for which to wait for the pending state to be
                    applied.
    
    Returns:
        true on success or false if the operation timed out before the
            window was in the requested state.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowSize)
        $(D SDL_SetWindowPosition)
        $(D SDL_SetWindowFullscreen)
        $(D SDL_MinimizeWindow)
        $(D SDL_MaximizeWindow)
        $(D SDL_RestoreWindow)
        $(D SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS)
*/
extern bool SDL_SyncWindow(SDL_Window* window);

/**
    Return whether the window has a surface associated with it.

    Params:
        window = the window to query.
    
    Returns:
        true if there is a surface associated with the window, or false
        otherwise.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSurface)
*/
extern bool SDL_WindowHasSurface(SDL_Window* window);

/**
    Get the SDL surface associated with the window.

    A new surface will be created with the optimal format for the window, if
    necessary. This surface will be freed when the window is destroyed. Do not
    free this surface.

    This surface will be invalidated if the window is resized. After resizing a
    window this function must be called again to return a valid surface.

    You may not combine this with 3D or the rendering API on this window.

    This function is affected by `SDL_HINT_FRAMEBUFFER_ACCELERATION`.

    Params:
        window = the window to query.
    
    Returns:
        the surface associated with the window, or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_DestroyWindowSurface)
        $(D SDL_WindowHasSurface)
        $(D SDL_UpdateWindowSurface)
        $(D SDL_UpdateWindowSurfaceRects)
*/
extern SDL_Surface*  SDL_GetWindowSurface(SDL_Window* window);

/**
    Toggle VSync for the window surface.

    When a window surface is created, vsync defaults to
    SDL_WINDOW_SURFACE_VSYNC_DISABLED.

    The `vsync` parameter can be 1 to synchronize present with every vertical
    refresh, 2 to synchronize present with every second vertical refresh, etc.,
    SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync),
    or SDL_WINDOW_SURFACE_VSYNC_DISABLED to disable. Not every value is
    supported by every driver, so you should check the return value to see
    whether the requested setting is supported.

    Params:
        window =    the window.
        vsync =     the vertical refresh sync interval.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSurfaceVSync)
*/
extern bool SDL_SetWindowSurfaceVSync(SDL_Window* window, int vsync);

enum SDL_WINDOW_SURFACE_VSYNC_DISABLED = 0;
enum SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE = (-1);

/**
    Get VSync for the window surface.

    Params:
        window =    the window to query.
        vsync =     an int filled with the current vertical refresh sync interval.
                    See SDL_SetWindowSurfaceVSync() for the meaning of the value.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowSurfaceVSync)
*/
extern bool SDL_GetWindowSurfaceVSync(SDL_Window* window, int* vsync);

/**
    Copy the window surface to the screen.

    This is the function you use to reflect any changes to the surface on the
    screen.

    This function is equivalent to the SDL 1.2 API SDL_Flip().

    Params:
        window = the window to update.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSurface)
        $(D SDL_UpdateWindowSurfaceRects)
*/
extern bool SDL_UpdateWindowSurface(SDL_Window* window);

/**
    Copy areas of the window surface to the screen.

    This is the function you use to reflect changes to portions of the surface
    on the screen.

    This function is equivalent to the SDL 1.2 API SDL_UpdateRects().

    Note that this function will update _at least_ the rectangles specified,
    but this is only intended as an optimization; in practice, this might
    update more of the screen (or all of the screen!), depending on what method
    SDL uses to send pixels to the system.

    Params:
        window =    the window to update.
        rects =     an array of SDL_Rect structures representing areas of the
                    surface to copy, in pixels.
        numrects =  the number of rectangles.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSurface)
        $(D SDL_UpdateWindowSurface)
*/
extern bool SDL_UpdateWindowSurfaceRects(SDL_Window* window, const(SDL_Rect)* rects, int numrects);

/**
    Destroy the surface associated with the window.

    Params:
        window = the window to update.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowSurface)
        $(D SDL_WindowHasSurface)
*/
extern bool SDL_DestroyWindowSurface(SDL_Window* window);

/**
    Set a window's keyboard grab mode.

    Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
    the Meta/Super key. Note that not all system keyboard shortcuts can be
    captured by applications (one example is Ctrl+Alt+Del on Windows).

    This is primarily intended for specialized applications such as VNC clients
    or VM frontends. Normal games should not use keyboard grab.

    When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
    window is full-screen to ensure the user is not trapped in your
    application. If you have a custom keyboard shortcut to exit fullscreen
    mode, you may suppress this behavior with
    `SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED`.

    If the caller enables a grab while another window is currently grabbed, the
    other window loses its grab in favor of the caller's window.

    Params:
        window =    the window for which the keyboard grab mode should be set.
        grabbed =   this is true to grab keyboard, and false to release.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowKeyboardGrab)
        $(D SDL_SetWindowMouseGrab)
*/
extern bool SDL_SetWindowKeyboardGrab(SDL_Window* window, bool grabbed);

/**
    Set a window's mouse grab mode.

    Mouse grab confines the mouse cursor to the window.

    Params:
        window =    the window for which the mouse grab mode should be set.
        grabbed =   this is true to grab mouse, and false to release.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMouseRect)
        $(D SDL_SetWindowMouseRect)
        $(D SDL_SetWindowMouseGrab)
        $(D SDL_SetWindowKeyboardGrab)
*/
extern bool SDL_SetWindowMouseGrab(SDL_Window* window, bool grabbed);

/**
    Get a window's keyboard grab mode.

    Params:
        window = the window to query.
    
    Returns:
        true if keyboard is grabbed, and false otherwise.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowKeyboardGrab)
*/
extern bool SDL_GetWindowKeyboardGrab(SDL_Window* window);

/**
    Get a window's mouse grab mode.

    Params:
        window = the window to query.
    
    Returns:
        true if mouse is grabbed, and false otherwise.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMouseRect)
        $(D SDL_SetWindowMouseRect)
        $(D SDL_SetWindowMouseGrab)
        $(D SDL_SetWindowKeyboardGrab)
*/
extern bool SDL_GetWindowMouseGrab(SDL_Window* window);

/**
    Get the window that currently has an input grab enabled.

    Returns:
        the window if input is grabbed or NULL otherwise.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowMouseGrab)
        $(D SDL_SetWindowKeyboardGrab)
*/
extern SDL_Window*  SDL_GetGrabbedWindow();

/**
    Confines the cursor to the specified area of a window.

    Note that this does NOT grab the cursor, it only defines the area a cursor
    is restricted to when the window has mouse focus.

    Params:
        window =    the window that will be associated with the barrier.
        rect =      a rectangle area in window-relative coordinates. If NULL the
                    barrier for the specified window will be destroyed.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowMouseRect)
        $(D SDL_GetWindowMouseGrab)
        $(D SDL_SetWindowMouseGrab)
*/
extern bool SDL_SetWindowMouseRect(SDL_Window* window, const(SDL_Rect)* rect);

/**
    Get the mouse confinement rectangle of a window.

    Params:
        window = the window to query.
    
    Returns:
        a pointer to the mouse confinement rectangle of a window, or NULL
            if there isn't one.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowMouseRect)
        $(D SDL_GetWindowMouseGrab)
        $(D SDL_SetWindowMouseGrab)
*/
extern const(SDL_Rect)*  SDL_GetWindowMouseRect(SDL_Window* window);

/**
    Set the opacity for a window.

    The parameter `opacity` will be clamped internally between 0.0f
    (transparent) and 1.0f (opaque).

    This function also returns false if setting the opacity isn't supported.

    Params:
        window =    the window which will be made transparent or opaque.
        opacity =   the opacity value (0.0f - transparent, 1.0f - opaque).
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowOpacity)
*/
extern bool SDL_SetWindowOpacity(SDL_Window* window, float opacity);

/**
    Get the opacity of a window.

    If transparency isn't supported on this platform, opacity will be returned
    as 1.0f without error.

    Params:
        window = the window to get the current opacity value from.
    
    Returns:
        the opacity, (0.0f - transparent, 1.0f - opaque), or -1.0f on
        failure; call SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowOpacity)
*/
extern float SDL_GetWindowOpacity(SDL_Window* window);

/**
    Set the window as a child of a parent window.

    If the window is already the child of an existing window, it will be
    reparented to the new owner. Setting the parent window to NULL unparents
    the window and removes child window status.

    If a parent window is hidden or destroyed, the operation will be
    recursively applied to child windows. Child windows hidden with the parent
    that did not have their hidden status explicitly set will be restored when
    the parent is shown.

    Attempting to set the parent of a window that is currently in the modal
    state will fail. Use SDL_SetWindowModal() to cancel the modal status before
    attempting to change the parent.

    Popup windows cannot change parents and attempts to do so will fail.

    Setting a parent window that is currently the sibling or descendent of the
    child window results in undefined behavior.

    Params:
        window = the window that should become the child of a parent.
        parent = the new parent window for the child window.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowModal)
*/
extern bool SDL_SetWindowParent(SDL_Window* window, SDL_Window* parent);

/**
    Toggle the state of the window as modal.

    To enable modal status on a window, the window must currently be the child
    window of a parent, or toggling modal status on will fail.

    Params:
        window =    the window on which to set the modal state.
        modal =     true to toggle modal status on, false to toggle it off.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowParent)
        $(D SDL_WINDOW_MODAL)
*/
extern bool SDL_SetWindowModal(SDL_Window* window, bool modal);

/**
    Set whether the window may have input focus.

    Params:
        window =    the window to set focusable state.
        focusable = true to allow input focus, false to not allow input focus.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_SetWindowFocusable(SDL_Window* window, bool focusable);


/**
    Display the system-level window menu.

    This default window menu is provided by the system and on some platforms
    provides functionality for setting or changing privileged state on the
    window, such as moving it between workspaces or displays, or toggling the
    always-on-top property.

    On platforms or desktops where this is unsupported, this function does
    nothing.

    Params:
        window =    the window for which the menu will be displayed.
        x =         the x coordinate of the menu, relative to the origin (top-left) of
                    the client area.
        y =         the y coordinate of the menu, relative to the origin (top-left) of
                    the client area.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_ShowWindowSystemMenu(SDL_Window* window, int x, int y);

/**
    Possible return values from the SDL_HitTest callback.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_HitTest)
*/
enum SDL_HitTestResult {
    
    /**
        Region is normal. No special properties.
    */
    SDL_HITTEST_NORMAL,
    
    /**
        Region can drag entire window.
    */
    SDL_HITTEST_DRAGGABLE,
    
    /**
        Region is the resizable top-left corner border.
    */
    SDL_HITTEST_RESIZE_TOPLEFT,
    
    /**
        Region is the resizable top border.
    */
    SDL_HITTEST_RESIZE_TOP,
    
    /**
        Region is the resizable top-right corner border.
    */
    SDL_HITTEST_RESIZE_TOPRIGHT,
    
    /**
        Region is the resizable right border.
    */
    SDL_HITTEST_RESIZE_RIGHT,
    
    /**
        Region is the resizable bottom-right corner border.
    */
    SDL_HITTEST_RESIZE_BOTTOMRIGHT,
    
    /**
        Region is the resizable bottom border.
    */
    SDL_HITTEST_RESIZE_BOTTOM,
    
    /**
        Region is the resizable bottom-left corner border.
    */
    SDL_HITTEST_RESIZE_BOTTOMLEFT,
    
    /**
        Region is the resizable left border.
    */
    SDL_HITTEST_RESIZE_LEFT
}

/**
    Callback used for hit-testing.

    Params:
        win =   the SDL_Window where hit-testing was set on.
        area =  an SDL_Point which should be hit-tested.
        data =  what was passed as `callback_data` to SDL_SetWindowHitTest().
    
    Returns:
        An SDL_HitTestResult value.

    See_Also:
        $(D SDL_SetWindowHitTest)
*/
alias SDL_HitTest = SDL_HitTestResult function(
                        SDL_Window* win,
                        const(SDL_Point)* area,
                        void* data);

/**
    Provide a callback that decides if a window region has special properties.

    Normally windows are dragged and resized by decorations provided by the
    system window manager (a title bar, borders, etc), but for some apps, it
    makes sense to drag them from somewhere else inside the window itself; for
    example, one might have a borderless window that wants to be draggable from
    any part, or simulate its own title bar, etc.

    This function lets the app provide a callback that designates pieces of a
    given window as special. This callback is run during event processing if we
    need to tell the OS to treat a region of the window specially; the use of
    this callback is known as "hit testing."

    Mouse input may not be delivered to your application if it is within a
    special area; the OS will often apply that input to moving the window or
    resizing the window and not deliver it to the application.

    Specifying NULL for a callback disables hit-testing. Hit-testing is
    disabled by default.

    Platforms that don't support this functionality will return false
    unconditionally, even if you're attempting to disable hit-testing.

    Your callback may fire at any time, and its firing does not indicate any
    specific behavior (for example, on Windows, this certainly might fire when
    the OS is deciding whether to drag your window, but it fires for lots of
    other reasons, too, some unrelated to anything you probably care about _and
    when the mouse isn't actually at the location it is testing_). Since this
    can fire at any time, you should try to keep your callback efficient,
    devoid of allocations, etc.

    Params:
        window =        the window to set hit-testing on.
        callback =      the function to call when doing a hit-test.
        callback_data = an app-defined void pointer passed to* *callback**.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern bool SDL_SetWindowHitTest(SDL_Window* window, SDL_HitTest callback, void* callback_data);

/**
    Set the shape of a transparent window.

    This sets the alpha channel of a transparent window and any fully
    transparent areas are also transparent to mouse clicks. If you are using
    something besides the SDL render API, then you are responsible for drawing
    the alpha channel of the window to match the shape alpha channel to get
    consistent cross-platform results.

    The shape is copied inside this function, so you can free it afterwards. If
    your shape surface changes, you should call SDL_SetWindowShape() again to
    update the window. This is an expensive operation, so should be done
    sparingly.

    The window must have been created with the SDL_WINDOW_TRANSPARENT flag.

    Params:
        window =    the window.
        shape =     the surface representing the shape of the window, or NULL to
                    remove any current shape.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_SetWindowShape(SDL_Window* window, SDL_Surface* shape);

/**
    Request a window to demand attention from the user.

    Params:
        window =    the window to be flashed.
        operation = the operation to perform.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_FlashWindow(SDL_Window* window, SDL_FlashOperation operation);


/**
    Sets the state of the progress bar for the given window's taskbar icon.

    Params:
        window =    The window to set the progress state of.
        state =     The progress state to set. 

    Returns:
        $(D true) if the operation succeeded, $(D false) otherwise.
*/
extern bool SDL_SetWindowProgressState(SDL_Window *window, SDL_ProgressState state);

/**
    Get the state of the progress bar for the given window's taskbar icon.

    Params:
        window =    The window to get the progress state of.

    Returns:
        The progress state of the window.
*/
extern SDL_ProgressState SDL_GetWindowProgressState(SDL_Window *window);

/**
    Sets the value of the progress bar for the given window's taskbar icon.

    Params:
        window =    The window to set the progress value of.
        value =     The progress value to set.
    
    Returns:
        $(D true) if the operation succeeded, $(D false) otherwise.
*/
extern bool SDL_SetWindowProgressValue(SDL_Window *window, float value);

/**
    Get the value of the progress bar for the given window's taskbar icon.

    Params:
        window =    The window to get the progress value of.

    Returns:
        The progress value.
*/
extern float SDL_GetWindowProgressValue(SDL_Window *window);

/**
    Destroy a window.

    Any child windows owned by the window will be recursively destroyed as
    well.

    Note that on some platforms, the visible window may not actually be removed
    from the screen until the SDL event loop is pumped again, even though the
    SDL_Window is no longer valid after this call.

    Params:
        window = the window to destroy.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreatePopupWindow)
        $(D SDL_CreateWindow)
        $(D SDL_CreateWindowWithProperties)
*/
extern void SDL_DestroyWindow(SDL_Window* window);


/**
    Check whether the screensaver is currently enabled.

    The screensaver is disabled by default.

    The default can also be changed using `SDL_HINT_VIDEO_ALLOW_SCREENSAVER`.

    Returns:
        true if the screensaver is enabled, false if it is disabled.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_DisableScreenSaver)
        $(D SDL_EnableScreenSaver)
*/
extern bool SDL_ScreenSaverEnabled();

/**
    Allow the screen to be blanked by a screen saver.

    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_DisableScreenSaver)
        $(D SDL_ScreenSaverEnabled)
*/
extern bool SDL_EnableScreenSaver();

/**
    Prevent the screen from being blanked by a screen saver.

    If you disable the screensaver, it is automatically re-enabled when SDL
    quits.

    The screensaver is disabled by default, but this may by changed by
    SDL_HINT_VIDEO_ALLOW_SCREENSAVER.

    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_EnableScreenSaver)
        $(D SDL_ScreenSaverEnabled)
*/
extern bool SDL_DisableScreenSaver();

/**
    Dynamically load an OpenGL library.

    This should be done after initializing the video driver, but before
    creating any OpenGL windows. If no OpenGL library is loaded, the default
    library will be loaded upon creation of the first OpenGL window.

    If you do this, you need to retrieve all of the GL functions used in your
    program from the dynamic library using SDL_GL_GetProcAddress().

    Params:
        path =  the platform dependent OpenGL library name, or NULL to open the
                default OpenGL library.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_GetProcAddress)
        $(D SDL_GL_UnloadLibrary)
*/
extern bool SDL_GL_LoadLibrary(const(char)* path);

/**
    Get an OpenGL function by name.

    If the GL library is loaded at runtime with SDL_GL_LoadLibrary(), then all
    GL functions must be retrieved this way. Usually this is used to retrieve
    function pointers to OpenGL extensions.

    There are some quirks to looking up OpenGL functions that require some
    extra care from the application. If you code carefully, you can handle
    these quirks without any platform-specific code, though:

    -   On Windows, function pointers are specific to the current GL context;
        this means you need to have created a GL context and made it current
        before calling SDL_GL_GetProcAddress(). If you recreate your context or
        create a second context, you should assume that any existing function
        pointers aren't valid to use with it. This is (currently) a
        Windows-specific limitation, and in practice lots of drivers don't suffer
        this limitation, but it is still the way the wgl API is documented to
        work and you should expect crashes if you don't respect it. Store a copy
        of the function pointers that comes and goes with context lifespan.
    -   On X11, function pointers returned by this function are valid for any
        context, and can even be looked up before a context is created at all.
        This means that, for at least some common OpenGL implementations, if you
        look up a function that doesn't exist, you'll get a non-NULL result that
        is _NOT_ safe to call. You must always make sure the function is actually
        available for a given GL context before calling it, by checking for the
        existence of the appropriate extension with SDL_GL_ExtensionSupported(),
        or verifying that the version of OpenGL you're using offers the function
        as core functionality.
    -   Some OpenGL drivers, on all platforms, *will* return NULL if a function
        isn't supported, but you can't count on this behavior. Check for
        extensions you use, and if you get a NULL anyway, act as if that
        extension wasn't available. This is probably a bug in the driver, but you
        can code defensively for this scenario anyhow.
    -   Just because you're on Linux/Unix, don't assume you'll be using X11.
        Next-gen display servers are waiting to replace it, and may or may not
        make the same promises about function pointers.
    -   OpenGL function pointers must be declared `APIENTRY` as in the example
        code. This will ensure the proper calling convention is followed on
        platforms where this matters (Win32) thereby avoiding stack corruption.

    Params:
        proc = the name of an OpenGL function.
    
    Returns:
        a pointer to the named OpenGL function. The returned pointer
        should be cast to the appropriate function signature.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_ExtensionSupported)
        $(D SDL_GL_LoadLibrary)
        $(D SDL_GL_UnloadLibrary)
*/
extern SDL_FunctionPointer SDL_GL_GetProcAddress(const(char)* proc);

/**
    Get an EGL library function by name.

    If an EGL library is loaded, this function allows applications to get entry
    points for EGL functions. This is useful to provide to an EGL API and
    extension loader.

    Params:
        proc = the name of an EGL function.
    
    Returns:
        a pointer to the named EGL function. The returned pointer should
        be cast to the appropriate function signature.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_EGL_GetCurrentDisplay)
*/
extern SDL_FunctionPointer SDL_EGL_GetProcAddress(const(char)* proc);

/**
    Unload the OpenGL library previously loaded by SDL_GL_LoadLibrary().

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_LoadLibrary)
*/
extern void SDL_GL_UnloadLibrary();

/**
    Check if an OpenGL extension is supported for the current context.

    This function operates on the current GL context; you must have created a
    context and it must be current before calling this function. Do not assume
    that all contexts you create will have the same set of extensions
    available, or that recreating an existing context will offer the same
    extensions again.

    While it's probably not a massive overhead, this function is not an O(1)
    operation. Check the extensions you care about after creating the GL
    context and save that information somewhere instead of calling the function
    every time you need to know.

    Params:
        extension = the name of the extension to check.
    
    Returns:
        true if the extension is supported, false otherwise.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern bool SDL_GL_ExtensionSupported(const(char)* extension);

/**
    Reset all previously set OpenGL context attributes to their default values.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_GetAttribute)
        $(D SDL_GL_SetAttribute)
*/
extern void SDL_GL_ResetAttributes();

/**
    Set an OpenGL window attribute before window creation.

    This function sets the OpenGL attribute `attr` to `value`. The requested
    attributes should be set before creating an OpenGL window. You should use
    SDL_GL_GetAttribute() to check the values after creating the OpenGL
    context, since the values obtained can differ from the requested ones.

    Params:
        attr =  an SDL_GLAttr enum value specifying the OpenGL attribute to
                set.
        value = the desired value for the attribute.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_GetAttribute)
        $(D SDL_GL_ResetAttributes)
*/
extern bool SDL_GL_SetAttribute(SDL_GLAttr attr, int value);

/**
    Get the actual value for an attribute from the current context.

    Params:
        attr =  an SDL_GLAttr enum value specifying the OpenGL attribute to
                get.
        value = a pointer filled in with the current value of `attr`.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_ResetAttributes)
        $(D SDL_GL_SetAttribute)
*/
extern bool SDL_GL_GetAttribute(SDL_GLAttr attr, int* value);

/**
    Create an OpenGL context for an OpenGL window, and make it current.

    Windows users new to OpenGL should note that, for historical reasons, GL
    functions added after OpenGL version 1.1 are not available by default.
    Those functions must be loaded at run-time, either with an OpenGL
    extension-handling library or with SDL_GL_GetProcAddress() and its related
    functions.

    SDL_GLContext is opaque to the application.

    Params:
        window = the window to associate with the context.
    
    Returns:
        the OpenGL context associated with `window` or NULL on failure;
        call SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_DestroyContext)
        $(D SDL_GL_MakeCurrent)
*/
extern SDL_GLContext SDL_GL_CreateContext(SDL_Window* window);

/**
    Set up an OpenGL context for rendering into an OpenGL window.

    The context must have been created with a compatible window.

    Params:
        window =    the window to associate with the context.
        context =   the OpenGL context to associate with the window.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_CreateContext)
*/
extern bool SDL_GL_MakeCurrent(SDL_Window* window, SDL_GLContext context);

/**
    Get the currently active OpenGL window.

    Returns:
        the currently active OpenGL window on success or NULL on failure;
            call SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_Window*  SDL_GL_GetCurrentWindow();

/**
    Get the currently active OpenGL context.
    
    Returns:
        the currently active OpenGL context or NULL on failure; call
            SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_MakeCurrent)
*/
extern SDL_GLContext SDL_GL_GetCurrentContext();

/**
    Get the currently active EGL display.
    
    Returns:
        the currently active EGL display or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_EGLDisplay SDL_EGL_GetCurrentDisplay();

/**
    Get the currently active EGL config.
    
    Returns:
        the currently active EGL config or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_EGLConfig SDL_EGL_GetCurrentConfig();

/**
    Get the EGL surface associated with the window.

    Params:
        window = the window to query.
    
    Returns:
        the EGLSurface pointer associated with the window, or NULL on
        failure.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern SDL_EGLSurface SDL_EGL_GetWindowSurface(SDL_Window* window);

/**
    Sets the callbacks for defining custom EGLAttrib arrays for EGL
    initialization.

    Callbacks that aren't needed can be set to NULL.

    NOTE: These callback pointers will be reset after SDL_GL_ResetAttributes.

    Params:
        platformAttribCallback =    callback for attributes to pass to
                                    eglGetPlatformDisplay. May be NULL.
        surfaceAttribCallback =     callback for attributes to pass to
                                    eglCreateSurface. May be NULL.
        contextAttribCallback =     callback for attributes to pass to
                                    eglCreateContext. May be NULL.
        userdata =                  a pointer that is passed to the callbacks.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern void SDL_EGL_SetAttributeCallbacks(SDL_EGLAttribArrayCallback platformAttribCallback,
                                                        SDL_EGLIntArrayCallback surfaceAttribCallback,
                                                        SDL_EGLIntArrayCallback contextAttribCallback, void* userdata);

/**
    Set the swap interval for the current OpenGL context.

    Some systems allow specifying -1 for the interval, to enable adaptive
    vsync. Adaptive vsync works the same as vsync, but if you've already missed
    the vertical retrace for a given frame, it swaps buffers immediately, which
    might be less jarring for the user during occasional framerate drops. If an
    application requests adaptive vsync and the system does not support it,
    this function will fail and return false. In such a case, you should
    probably retry the call with 1 for the interval.

    Adaptive vsync is implemented for some glX drivers with
    GLX_EXT_swap_control_tear, and for some Windows drivers with
    WGL_EXT_swap_control_tear.

    Read more on the Khronos wiki:
    https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync

    Params:
        interval =  0 for immediate updates, 1 for updates synchronized with
                    the vertical retrace, -1 for adaptive vsync.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
            information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_GetSwapInterval)
*/
extern bool SDL_GL_SetSwapInterval(int interval);

/**
    Get the swap interval for the current OpenGL context.

    If the system can't determine the swap interval, or there isn't a valid
    current context, this function will set* interval to 0 as a safe default.

    Params:
        interval =  output interval value. 0 if there is no vertical retrace
                    synchronization, 1 if the buffer swap is synchronized with
                    the vertical retrace, and -1 if late swaps happen
                    immediately instead of waiting for the next retrace.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_SetSwapInterval)
*/
extern bool SDL_GL_GetSwapInterval(int* interval);

/**
    Update a window with OpenGL rendering.

    This is used with double-buffered OpenGL contexts, which are the default.

    On macOS, make sure you bind 0 to the draw framebuffer before swapping the
    window, otherwise nothing will happen. If you aren't using
    glBindFramebuffer(), this is the default and you won't have to do anything
    extra.

    Params:
        window = the window to change.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

*/
extern bool SDL_GL_SwapWindow(SDL_Window* window);

/**
    Delete an OpenGL context.

    Params:
        context = the OpenGL context to be deleted.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GL_CreateContext)
*/
extern bool SDL_GL_DestroyContext(SDL_GLContext context);
