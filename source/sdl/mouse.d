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
    SDL Mouse Handling

    See_Also:
        $(LINK2 https://wiki.libsdl.org/SDL3/CategoryMouse, SDL3 Mouse Documentation)
    
    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
*/
module sdl.mouse;
import sdl.video;
import sdl.surface;
import sdl.stdc;

extern (C) nothrow @nogc:

/**
    This is a unique ID for a mouse for the time it is connected to the system,
    and is never reused for the lifetime of the application.

    If the mouse is disconnected and reconnected, it will get a new ID.

    The value 0 is an invalid ID.
*/
alias SDL_MouseID = Uint32;

/**
    The structure used to identify an SDL cursor.

    This is opaque data.
*/
struct SDL_Cursor;

/**
    Cursor types for SDL_CreateSystemCursor().
*/
enum SDL_SystemCursor {

    /**
        Default cursor. Usually an arrow.
    */
    SDL_SYSTEM_CURSOR_DEFAULT,

    /**
        Text selection. Usually an I-beam.
    */
    SDL_SYSTEM_CURSOR_TEXT,

    /**
        Wait. Usually an hourglass or watch or spinning ball.
    */
    SDL_SYSTEM_CURSOR_WAIT,

    /**
        Crosshair.
    */
    SDL_SYSTEM_CURSOR_CROSSHAIR,

    /**
        Program is busy but still interactive. Usually it's WAIT with an arrow.
    */
    SDL_SYSTEM_CURSOR_PROGRESS,

    /**
        Double arrow pointing northwest and southeast.
    */
    SDL_SYSTEM_CURSOR_NWSE_RESIZE,

    /**
        Double arrow pointing northeast and southwest.
    */
    SDL_SYSTEM_CURSOR_NESW_RESIZE,

    /**
        Double arrow pointing west and east.
    */
    SDL_SYSTEM_CURSOR_EW_RESIZE,

    /**
        Double arrow pointing north and south.
    */
    SDL_SYSTEM_CURSOR_NS_RESIZE,

    /**
        Four pointed arrow pointing north, south, east, and west.
    */
    SDL_SYSTEM_CURSOR_MOVE,

    /**
        Not permitted. Usually a slashed circle or crossbones.
    */
    SDL_SYSTEM_CURSOR_NOT_ALLOWED,

    /**
        Pointer that indicates a link. Usually a pointing hand.
    */
    SDL_SYSTEM_CURSOR_POINTER,

    /**
        Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE.
    */
    SDL_SYSTEM_CURSOR_NW_RESIZE,

    /**
        Window resize top. May be NS_RESIZE.
    */
    SDL_SYSTEM_CURSOR_N_RESIZE,

    /**
        Window resize top-right. May be NESW_RESIZE.
    */
    SDL_SYSTEM_CURSOR_NE_RESIZE,

    /**
        Window resize right. May be EW_RESIZE.
    */
    SDL_SYSTEM_CURSOR_E_RESIZE,

    /**
        Window resize bottom-right. May be NWSE_RESIZE.
    */
    SDL_SYSTEM_CURSOR_SE_RESIZE,

    /**
        Window resize bottom. May be NS_RESIZE.
    */
    SDL_SYSTEM_CURSOR_S_RESIZE,

    /**
        Window resize bottom-left. May be NESW_RESIZE.
    */
    SDL_SYSTEM_CURSOR_SW_RESIZE,

    /**
        Window resize left. May be EW_RESIZE.
    */
    SDL_SYSTEM_CURSOR_W_RESIZE,
    SDL_SYSTEM_CURSOR_COUNT
}

/**
    Scroll direction types for the Scroll event
*/
enum SDL_MouseWheelDirection {

    /**
        The scroll direction is normal
    */
    SDL_MOUSEWHEEL_NORMAL,

    /**
        The scroll direction is flipped / natural
    */
    SDL_MOUSEWHEEL_FLIPPED
}

/**
    Animated cursor frame info.
*/
struct SDL_CursorFrameInfo {
    
    /**
        The surface data for this frame
    */
    SDL_Surface* surface;
    
    /**
        The frame duration in milliseconds (a duration of 0 is infinite)
    */
    uint duration;
}

/**
    A bitmask of pressed mouse buttons, as reported by SDL_GetMouseState, etc.

    - Button 1: Left mouse button
    - Button 2: Middle mouse button
    - Button 3: Right mouse button
    - Button 4: Side mouse button 1
    - Button 5: Side mouse button 2
    
    See_Also:
        $(D SDL_GetMouseState)
        $(D SDL_GetGlobalMouseState)
        $(D SDL_GetRelativeMouseState)
*/
enum SDL_MouseButtonFlags : Uint32 {
    BUTTON_LEFT = 1,
    BUTTON_MIDDLE = 2,
    BUTTON_RIGHT = 3,
    BUTTON_X1 = 4,
    BUTTON_X2 = 5,
}

enum SDL_BUTTON_MASK(Uint32 X) = cast(SDL_MouseButtonFlags)(1u << ((X) - 1));
enum SDL_BUTTON_LMASK = cast(SDL_MouseButtonFlags) SDL_BUTTON_MASK!(
        SDL_MouseButtonFlags.BUTTON_LEFT);
enum SDL_BUTTON_MMASK = cast(SDL_MouseButtonFlags) SDL_BUTTON_MASK!(
        SDL_MouseButtonFlags.BUTTON_MIDDLE);
enum SDL_BUTTON_RMASK = cast(SDL_MouseButtonFlags) SDL_BUTTON_MASK!(
        SDL_MouseButtonFlags.BUTTON_RIGHT);
enum SDL_BUTTON_X1MASK = cast(SDL_MouseButtonFlags) SDL_BUTTON_MASK!(SDL_MouseButtonFlags.BUTTON_X1);
enum SDL_BUTTON_X2MASK = cast(SDL_MouseButtonFlags) SDL_BUTTON_MASK!(SDL_MouseButtonFlags.BUTTON_X2);

/**
    Return whether a mouse is currently connected.

    Returns:
        true if a mouse is connected, false otherwise.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetMice)
*/
extern bool SDL_HasMouse();

/**
    Get a list of currently connected mice.

    Note that this will include any device or virtual driver that includes
    mouse functionality, including some game controllers, KVM switches, etc.
    You should wait for input from a device before you consider it actively in
    use.

    Params:
        count = a pointer filled in with the number of mice returned, may be
                NULL.
    
    Returns:
        a 0 terminated array of mouse instance IDs or NULL on failure;
            call SDL_GetError() for more information. This should be freed
            with SDL_free() when it is no longer needed.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetMouseNameForID)
        $(D SDL_HasMouse)
*/
extern SDL_MouseID* SDL_GetMice(int* count);

/**
    Get the name of a mouse.

    This function returns "" if the mouse doesn't have a name.

    Params:
        instance_id = the mouse instance ID.
    
    Returns:
        The name of the selected mouse, or NULL on failure; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetMice)
*/
extern const(char)* SDL_GetMouseNameForID(SDL_MouseID instance_id);

/**
    Get the window which currently has mouse focus.

    Returns:
        The window with mouse focus.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern SDL_Window* SDL_GetMouseFocus();

/**
    Query SDL's cache for the synchronous mouse button state and the
    window-relative SDL-cursor position.

    This function returns the cached synchronous state as SDL understands it
    from the last pump of the event queue.

    To query the platform for immediate asynchronous state, use
    SDL_GetGlobalMouseState.

    Passing non-NULL pointers to `x` or `y` will write the destination with
    respective x or y coordinates relative to the focused window.

    In Relative Mode, the SDL-cursor's position usually contradicts the
    platform-cursor's position as manually calculated from
    SDL_GetGlobalMouseState() and SDL_GetWindowPosition.

    Params:
        x = a pointer to receive the SDL-cursor's x-position from the focused
            window's top left corner, can be NULL if unused.
        y = a pointer to receive the SDL-cursor's y-position from the focused
            window's top left corner, can be NULL if unused.
    
    Returns:
        A 32-bit bitmask of the button state that can be bitwise-compared
        against the SDL_BUTTON_MASK(X) macro.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetGlobalMouseState)
        $(D SDL_GetRelativeMouseState)
*/
extern SDL_MouseButtonFlags SDL_GetMouseState(float* x, float* y);

/**
    Query the platform for the asynchronous mouse button state and the
    desktop-relative platform-cursor position.

    This function immediately queries the platform for the most recent
    asynchronous state, more costly than retrieving SDL's cached state in
    SDL_GetMouseState().

    Passing non-NULL pointers to `x` or `y` will write the destination with
    respective x or y coordinates relative to the desktop.

    In Relative Mode, the platform-cursor's position usually contradicts the
    SDL-cursor's position as manually calculated from SDL_GetMouseState() and
    SDL_GetWindowPosition.

    This function can be useful if you need to track the mouse outside of a
    specific window and SDL_CaptureMouse() doesn't fit your needs. For example,
    it could be useful if you need to track the mouse while dragging a window,
    where coordinates relative to a window might not be in sync at all times.

    Params:
        x = a pointer to receive the platform-cursor's x-position from the
            desktop's top left corner, can be NULL if unused.
        y = a pointer to receive the platform-cursor's y-position from the
            desktop's top left corner, can be NULL if unused.
    
    Returns:
        A 32-bit bitmask of the button state that can be bitwise-compared
        against the SDL_BUTTON_MASK(X) macro.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CaptureMouse)
        $(D SDL_GetMouseState)
        $(D SDL_GetGlobalMouseState)
*/
extern SDL_MouseButtonFlags SDL_GetGlobalMouseState(float* x, float* y);

/**
    Query SDL's cache for the synchronous mouse button state and accumulated
    mouse delta since last call.

    This function returns the cached synchronous state as SDL understands it
    from the last pump of the event queue.

    To query the platform for immediate asynchronous state, use
    SDL_GetGlobalMouseState.

    Passing non-NULL pointers to `x` or `y` will write the destination with
    respective x or y deltas accumulated since the last call to this function
    (or since event initialization).

    This function is useful for reducing overhead by processing relative mouse
    inputs in one go per-frame instead of individually per-event, at the
    expense of losing the order between events within the frame (e.g. quickly
    pressing and releasing a button within the same frame).

    Params:
        x = a pointer to receive the x mouse delta accumulated since last
            call, can be NULL if unused.
        y = a pointer to receive the y mouse delta accumulated since last
            call, can be NULL if unused.
    
    Returns:
        A 32-bit bitmask of the button state that can be bitwise-compared
        against the SDL_BUTTON_MASK(X) macro.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetMouseState)
        $(D SDL_GetGlobalMouseState)
*/
extern SDL_MouseButtonFlags SDL_GetRelativeMouseState(float* x, float* y);

/**
    Move the mouse cursor to the given position within the window.

    This function generates a mouse motion event if relative mode is not
    enabled. If relative mode is enabled, you can force mouse events for the
    warp by setting the SDL_HINT_MOUSE_RELATIVE_WARP_MOTION hint.

    Note that this function will appear to succeed, but not actually move the
    mouse when used over Microsoft Remote Desktop.

    Params:
        window =    the window to move the mouse into, or NULL for the current
                    mouse focus.
        x =         the x coordinate within the window.
        y =         the y coordinate within the window.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_WarpMouseGlobal)
*/
extern void SDL_WarpMouseInWindow(SDL_Window* window,
    float x, float y);

/**
    Move the mouse to the given position in global screen space.

    This function generates a mouse motion event.

    A failure of this function usually means that it is unsupported by a
    platform.

    Note that this function will appear to succeed, but not actually move the
    mouse when used over Microsoft Remote Desktop.

    Params:
        x = the x coordinate.
        y = the y coordinate.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_WarpMouseInWindow)
*/
extern bool SDL_WarpMouseGlobal(float x, float y);

/**
    Set relative mouse mode for a window.

    While the window has focus and relative mouse mode is enabled, the cursor
    is hidden, the mouse position is constrained to the window, and SDL will
    report continuous relative mouse motion even if the mouse is at the edge of
    the window.

    If you'd like to keep the mouse position fixed while in relative mode you
    can use SDL_SetWindowMouseRect(). If you'd like the cursor to be at a
    specific location when relative mode ends, you should use
    SDL_WarpMouseInWindow() before disabling relative mode.

    This function will flush any pending mouse motion for this window.

    Params:
        window =    the window to change.
        enabled =   true to enable relative mode, false to disable.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetWindowRelativeMouseMode)
*/
extern bool SDL_SetWindowRelativeMouseMode(SDL_Window* window, bool enabled);

/**
    Query whether relative mouse mode is enabled for a window.

    Params:
        window = the window to query.
    
    Returns:
        true if relative mode is enabled for a window or false otherwise.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetWindowRelativeMouseMode)
*/
extern bool SDL_GetWindowRelativeMouseMode(SDL_Window* window);

/**
    Capture the mouse and to track input outside an SDL window.

    Capturing enables your app to obtain mouse events globally, instead of just
    within your window. Not all video targets support this function. When
    capturing is enabled, the current window will get all mouse events, but
    unlike relative mode, no change is made to the cursor and it is not
    restrained to your window.

    This function may also deny mouse input to other windows--both those in
    your application and others on the system--so you should use this function
    sparingly, and in small bursts. For example, you might want to track the
    mouse while the user is dragging something, until the user releases a mouse
    button. It is not recommended that you capture the mouse for long periods
    of time, such as the entire time your app is running. For that, you should
    probably use SDL_SetWindowRelativeMouseMode() or SDL_SetWindowMouseGrab(),
    depending on your goals.

    While captured, mouse events still report coordinates relative to the
    current (foreground) window, but those coordinates may be outside the
    bounds of the window (including negative values). Capturing is only allowed
    for the foreground window. If the window loses focus while capturing, the
    capture will be disabled automatically.

    While capturing is enabled, the current window will have the
    `SDL_WINDOW_MOUSE_CAPTURE` flag set.

    Please note that SDL will attempt to "auto capture" the mouse while the
    user is pressing a button; this is to try and make mouse behavior more
    consistent between platforms, and deal with the common case of a user
    dragging the mouse outside of the window. This means that if you are
    calling SDL_CaptureMouse() only to deal with this situation, you do not
    have to (although it is safe to do so). If this causes problems for your
    app, you can disable auto capture by setting the
    `SDL_HINT_MOUSE_AUTO_CAPTURE` hint to zero.

    Params:
        enabled = true to enable capturing, false to disable.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetGlobalMouseState)
*/
extern bool SDL_CaptureMouse(bool enabled);

/**
    Create a cursor using the specified bitmap data and mask (in MSB format).

    `mask` has to be in MSB (Most Significant Bit) format.

    The cursor width (`w`) must be a multiple of 8 bits.

    The cursor is created in black and white according to the following:

    - data=0, mask=1: white
    - data=1, mask=1: black
    - data=0, mask=0: transparent
    - data=1, mask=0: inverted color if possible, black if not.

    Cursors created with this function must be freed with SDL_DestroyCursor().

    If you want to have a color cursor, or create your cursor from an
    SDL_Surface, you should use SDL_CreateColorCursor(). Alternately, you can
    hide the cursor and draw your own as part of your game's rendering, but it
    will be bound to the framerate.

    Also, SDL_CreateSystemCursor() is available, which provides several
    readily-available system cursors to pick from.

    Params:
        data =  the color value for each pixel of the cursor.
        mask =  the mask value for each pixel of the cursor.
        w =     the width of the cursor.
        h =     the height of the cursor.
        hot_x = the x-axis offset from the left of the cursor image to the
                mouse x position, in the range of 0 to `w` - 1.
        hot_y = the y-axis offset from the top of the cursor image to the
                mouse y position, in the range of 0 to `h` - 1.
    
    Returns:
        A new cursor with the specified parameters on success or NULL on
        failure; call SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateColorCursor)
        $(D SDL_CreateSystemCursor)
        $(D SDL_DestroyCursor)
        $(D SDL_SetCursor)
*/
extern SDL_Cursor* SDL_CreateCursor(const Uint8* data,
    const Uint8* mask,
    int w, int h, int hot_x,
    int hot_y);

/**
    Create a color cursor.

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
        surface =   an SDL_Surface structure representing the cursor image.
        hot_x =     the x position of the cursor hot spot.
        hot_y =     the y position of the cursor hot spot.
    
    Returns:
        The new cursor on success or NULL on failure; call SDL_GetError()
        for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateCursor)
        $(D SDL_CreateSystemCursor)
        $(D SDL_DestroyCursor)
        $(D SDL_SetCursor)
*/
extern SDL_Cursor* SDL_CreateColorCursor(SDL_Surface* surface,
    int hot_x,
    int hot_y);

/**
    Create an animated color cursor.

    Params:
        frames =        pointer to an array of frames for the cursor.
        frame_count =   the amount of frames in the array.
        hot_x =         the x position of the cursor hot spot.
        hot_y =         the y position of the cursor hot spot.
*/
extern SDL_Cursor* SDL_CreateAnimatedCursor(SDL_CursorFrameInfo* frames, int frame_count, int hot_x, int hot_y);

/**
    Create a system cursor.

    Params:
        id = an SDL_SystemCursor enum value.
    
    Returns:
        A cursor on success or NULL on failure; call SDL_GetError() for
        more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_DestroyCursor)
*/
extern SDL_Cursor* SDL_CreateSystemCursor(SDL_SystemCursor id);

/**
    Set the active cursor.

    This function sets the currently active cursor to the specified one. If the
    cursor is currently visible, the change will be immediately represented on
    the display. SDL_SetCursor(NULL) can be used to force cursor redraw, if
    this is desired for any reason.

    Params:
        cursor = a cursor to make active.
    
    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetCursor)
*/
extern bool SDL_SetCursor(SDL_Cursor* cursor);

/**
    Get the active cursor.

    This function returns a pointer to the current cursor which is owned by the
    library. It is not necessary to free the cursor with SDL_DestroyCursor().

    Returns:
        The active cursor or NULL if there is no mouse.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetCursor)
*/
extern SDL_Cursor* SDL_GetCursor();

/**
    Get the default cursor.

    You do not have to call SDL_DestroyCursor() on the return value, but it is
    safe to do so.

    Returns:
        The default cursor on success or NULL on failuree; call
        SDL_GetError() for more information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern SDL_Cursor* SDL_GetDefaultCursor();

/**
    Free a previously-created cursor.

    Use this function to free cursor resources created with SDL_CreateCursor(),
    SDL_CreateColorCursor() or SDL_CreateSystemCursor().

    Params:
        cursor = the cursor to free.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateColorCursor)
        $(D SDL_CreateCursor)
        $(D SDL_CreateSystemCursor)
*/
extern void SDL_DestroyCursor(SDL_Cursor* cursor);

/**
    Show the cursor.

    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CursorVisible)
        $(D SDL_HideCursor)
*/
extern bool SDL_ShowCursor();

/**
    Hide the cursor.

    Returns:
        true on success or false on failure; call SDL_GetError() for more
        information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CursorVisible)
        $(D SDL_ShowCursor)
*/
extern bool SDL_HideCursor();

/**
    Return whether the cursor is currently being shown.

    Returns:
        `true` if the cursor is being shown, or `false` if the cursor is
        hidden.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_HideCursor)
        $(D SDL_ShowCursor)
*/
extern bool SDL_CursorVisible();
