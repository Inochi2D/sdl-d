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
    SDL Render

    See_Also:
        $(LINK2 https://wiki.libsdl.org/SDL3/CategoryRender, SDL3 Render Documentation)
    
    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
        Mireille Arseneault
*/
module sdl.render;
import sdl.stdc;
import sdl.blendmode;
import sdl.error;
import sdl.events;
import sdl.pixels;
import sdl.properties;
import sdl.rect;
import sdl.surface;
import sdl.video;
import sdl.gpu;

extern(C) nothrow @nogc:

/**
    The name of the software renderer.
*/
enum SDL_SOFTWARE_RENDERER = "software";

/**
    Vertex structure.
*/
struct SDL_Vertex
{
    /** 
        Vertex position, in $(D SDL_Renderer) coordinates.
    */
    SDL_FPoint position;

    /** 
        Vertex color.
    */
    SDL_FColor color;

    /**
        Normalized texture coordinates, if needed
    */
    SDL_FPoint tex_coord;
}

/**
    The access pattern allowed for a texture.
*/
enum SDL_TextureAccess
{
    /**
        Changes rarely, not lockable.
    */
    SDL_TEXTUREACCESS_STATIC,

    /**
        Changes frequently, lockable.
    */
    SDL_TEXTUREACCESS_STREAMING,

    /**
        Texture can be used as a render target.
    */
    SDL_TEXTUREACCESS_TARGET,
}

/**
    How the logical size is mapped to the output.
*/
enum SDL_RendererLogicalPresentation
{
    /**
        There is no logical size in effect.
    */
    SDL_LOGICAL_PRESENTATION_DISABLED,

    /**
        The rendered content is stretched to the output resolution.
    */
    SDL_LOGICAL_PRESENTATION_STRETCH,

    /**
        The rendered content is fit to the largest dimension and the other dimension is letterboxed with black bars.
    */
    SDL_LOGICAL_PRESENTATION_LETTERBOX,

    /**
        The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds.
    */
    SDL_LOGICAL_PRESENTATION_OVERSCAN,

    /**
        The rendered content is scaled up by integer multiples to fit the output resolution.
    */
    SDL_LOGICAL_PRESENTATION_INTEGER_SCALE,
}

/**
    A structure representing rendering state
*/
struct SDL_Renderer;

/**
    An efficient driver-specific representation of pixel data

    See_Also:
        $(D SDL_CreateTexture)
        $(D SDL_CreateTextureFromSurface)
        $(D SDL_CreateTextureWithProperties)
        $(D SDL_DestroyTexture)
*/
struct SDL_Texture
{
    /**
        The format of the texture, read-only.
    */
    SDL_PixelFormat format;

    /**
        The width of the texture, read-only.
    */
    int w;

    /**
        The height of the texture, read-only.
    */
    int h;

    /**
        Application reference count, used when freeing texture.
    */
    int refcount;
}

/**
    Get the number of 2D rendering drivers available for the current display.

    A render driver is a set of code that handles rendering and texture
    management on a particular display. Normally there is only one, but some
    drivers may have several available with different capabilities.

    There may be none if SDL was compiled without render support.

    Returns:
        The number of built-in render drivers.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_CreateRenderer)
        $(D SDL_GetRenderDriver)
*/
extern int SDL_GetNumRenderDrivers();

/**
    Use this function to get the name of a built in 2D rendering driver.

    The list of rendering drivers is given in the order that they are normally
    initialized by default; the drivers that seem more reasonable to choose
    first (as far as the SDL developers believe) are earlier in the list.

    The names of drivers are all simple, low-ASCII identifiers, like `"opengl"`,
    `"direct3d12"` or `"metal"`. These never have Unicode characters, and are not
    meant to be proper names.

    Params:
        index = The index of the rendering driver; the value ranges from `0` to `SDL_GetNumRenderDrivers() - 1`.

    Returns:
        The name of the rendering driver at the requested index, or `null` if an invalid index was specified.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_GetNumRenderDrivers)
*/
extern const(char)* SDL_GetRenderDriver(int index);

/**
    Create a window and default renderer.

    Params:
        title = The title of the window, in UTF-8 encoding.
        width = The width of the window.
        height = The height of the window.
        window_flags = The flags used to create the window (see $(D SDL_CreateWindow)).
        window = A pointer filled with the window, or `null` on error.
        renderer = A pointer filled with the renderer, or `null` on error.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateRenderer)
        $(D SDL_CreateWindow)
*/
extern bool SDL_CreateWindowAndRenderer(const(char)* title, int width, int height, SDL_WindowFlags window_flags, SDL_Window** window, SDL_Renderer** renderer);

/**
    Create a 2D rendering context for a window.

    If you want a specific renderer, you can specify its name here. A list of
    available renderers can be obtained by calling $(D SDL_GetRenderDriver)
    multiple times, with indices from `0` to `SDL_GetNumRenderDrivers() - 1`. If you
    don't need a specific renderer, specify `null` and SDL will attempt to choose
    the best option for you, based on what is available on the user's system.

    If `name` is a comma-separated list, SDL will try each name, in the order
    listed, until one succeeds or all of them fail.

    By default the rendering size matches the window size in pixels, but you
    can call $(D SDL_SetRenderLogicalPresentation) to change the content size and
    scaling options.

    Params:
        window = The window where rendering is displayed.
        name = The name of the rendering driver to initialize, or `null` to let SDL choose one.

    Returns:
        A valid rendering context or $(D null) if there was an error; 
        call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateRendererWithProperties)
        $(D SDL_CreateSoftwareRenderer)
        $(D SDL_DestroyRenderer)
        $(D SDL_GetNumRenderDrivers)
        $(D SDL_GetRenderDriver)
        $(D SDL_GetRendererName)
*/
extern SDL_Renderer* SDL_CreateRenderer(SDL_Window* window, const(char)* name);

/**
    Create a 2D GPU rendering context.

    Params:
        device =    the GPU device to use with the renderer, or $(D null) to create a
                    device.
        window =    the window where rendering is displayed, or $(D null) to create an
                    offscreen renderer.

    Threadsafety:
        If this function is called with a valid GPU device, it should
        be called on the thread that created the device. If this
        function is called with a valid window, it should be called
        on the thread that created the window.

    Returns:
        A valid rendering context or $(D null) if there was an error; 
        call $(D SDL_GetError) for more information.
*/
extern SDL_Renderer* SDL_CreateGPURenderer(SDL_GPUDevice* device, SDL_Window *window);

/**
    Return the GPU device used by a renderer.

    Params:
        renderer =  renderer the rendering context.
    
    Threadsafety:
        It is safe to call this function from any thread.
    
    Returns:
        The GPU device used by the renderer, or $(D null) if the renderer is
        not a GPU renderer; call $(D SDL_GetError) for more information.
*/
extern SDL_GPUDevice* SDL_GetGPURendererDevice(SDL_Renderer* renderer);

/**
    Create a 2D rendering context for a window, with the specified properties.

    These are the supported properties:

    - `SDL_PROP_RENDERER_CREATE_NAME_STRING`: the name of the rendering driver
        to use, if a specific one is desired
    - `SDL_PROP_RENDERER_CREATE_WINDOW_POINTER`: the window where rendering is
        displayed, required if this isn't a software renderer using a surface
    - `SDL_PROP_RENDERER_CREATE_SURFACE_POINTER`: the surface where rendering
        is displayed, if you want a software renderer without a window
    - `SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER`: an $(D SDL_Colorspace)
        value describing the colorspace for output to the display, defaults to
        $(D SDL_COLORSPACE_SRGB). The direct3d11, direct3d12, and metal renderers
        support $(D SDL_COLORSPACE_SRGB_LINEAR), which is a linear color space and
        supports HDR output. If you select $(D SDL_COLORSPACE_SRGB_LINEAR), drawing
        still uses the sRGB colorspace, but values can go beyond `1.0` and float
        (linear) format textures can be used for HDR content.
    - `SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER`: non-zero if you want
        present synchronized with the refresh rate. This property can take any
        value that is supported by $(D SDL_SetRenderVSync) for the renderer.

    With the vulkan renderer:

    - `SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER`: the $(D VkInstance) to use
        with the renderer, optional.
    - `SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER`: the $(D VkSurfaceKHR) to use
        with the renderer, optional.
    - `SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER`: the
        $(D VkPhysicalDevice) to use with the renderer, optional.
    - `SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER`: the $(D VkDevice) to use
        with the renderer, optional.
    - `SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER`: the
        queue family index used for rendering.
    - `SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER`: the
        queue family index used for presentation.

    Params:
        props = The properties to use.

    Returns:
        A valid rendering context, or `null` if there was an error; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateProperties)
        $(D SDL_CreateRenderer)
        $(D SDL_CreateSoftwareRenderer)
        $(D SDL_DestroyRenderer)
        $(D SDL_GetRendererName)
*/
extern SDL_Renderer* SDL_CreateRendererWithProperties(SDL_PropertiesID props);

enum SDL_PROP_RENDERER_CREATE_NAME_STRING                               = "SDL.renderer.create.name";
enum SDL_PROP_RENDERER_CREATE_WINDOW_POINTER                            = "SDL.renderer.create.window";
enum SDL_PROP_RENDERER_CREATE_SURFACE_POINTER                           = "SDL.renderer.create.surface";
enum SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER                  = "SDL.renderer.create.output_colorspace";
enum SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER                      = "SDL.renderer.create.present_vsync";
enum SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER                   = "SDL.renderer.create.vulkan.instance";
enum SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER                     = "SDL.renderer.create.vulkan.surface";
enum SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER            = "SDL.renderer.create.vulkan.physical_device";
enum SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER                     = "SDL.renderer.create.vulkan.device";
enum SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER = "SDL.renderer.create.vulkan.graphics_queue_family_index";
enum SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER  = "SDL.renderer.create.vulkan.present_queue_family_index";

/**
    Create a 2D software rendering context for a surface.

    Two other API which can be used to create $(D SDL_Renderer):
    $(D SDL_CreateRenderer) and $(D SDL_CreateWindowAndRenderer). These can
	_also_ create a software renderer, but they are intended to be used with an
    $(D SDL_Window) as the final destination and not an $(D SDL_Surface).

    Params:
        surface = The $(D SDL_Surface) structure representing the surface where rendering is done.

    Returns:
        A valid rendering context or `null` if there was an error; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_DestroyRenderer)
*/
extern SDL_Renderer* SDL_CreateSoftwareRenderer(SDL_Surface* surface);

/**
    Get the renderer associated with a window.

    Params:
        window = The window to query.

    Returns:
        The rendering context on success or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern SDL_Renderer* SDL_GetRenderer(SDL_Window* window);

/**
    Get the window associated with a renderer.

    Params:
        renderer = The renderer to query.

    Returns:
        The window on success or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern SDL_Window* SDL_GetRenderWindow(SDL_Renderer* renderer);

/**
    Get the name of a renderer.

    Params:
        renderer = The rendering context.

    Returns:
        The name of the selected renderer, or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.

    See_Also:
        $(D SDL_CreateRenderer)
        $(D SDL_CreateRendererWithProperties)
*/
extern const(char)* SDL_GetRendererName(SDL_Renderer* renderer);

/**
    Get the properties associated with a renderer.

    The following read-only properties are provided by SDL:

    - `SDL_PROP_RENDERER_NAME_STRING`: the name of the rendering driver
    - `SDL_PROP_RENDERER_WINDOW_POINTER`: the window where rendering is
      displayed, if any
    - `SDL_PROP_RENDERER_SURFACE_POINTER`: the surface where rendering is
      displayed, if this is a software renderer without a window
    - `SDL_PROP_RENDERER_VSYNC_NUMBER`: the current vsync setting
    - `SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER`: the maximum texture width
      and height
    - `SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER`: a `const(SDL_PixelFormat)*`
      array of pixel formats, terminated with `SDL_PIXELFORMAT_UNKNOWN`,
      representing the available texture formats for this renderer.
    - `SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER`: an $(D SDL_Colorspace) value
      describing the colorspace for output to the display, defaults to
      `SDL_COLORSPACE_SRGB`.
    - `SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN`: true if the output colorspace is
      `SDL_COLORSPACE_SRGB_LINEAR` and the renderer is showing on a display with
      HDR enabled. This property can change dynamically when
      `SDL_EVENT_WINDOW_HDR_STATE_CHANGED` is sent.
    - `SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT`: the value of SDR white in the
      `SDL_COLORSPACE_SRGB_LINEAR` colorspace. When HDR is enabled, this value is
      automatically multiplied into the color scale. This property can change
      dynamically when `SDL_EVENT_WINDOW_HDR_STATE_CHANGED` is sent.
    - `SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT`: the additional high dynamic range
      that can be displayed, in terms of the SDR white point. When HDR is not
      enabled, this will be 1.0. This property can change dynamically when
      `SDL_EVENT_WINDOW_HDR_STATE_CHANGED` is sent.

    With the direct3d renderer:

    - `SDL_PROP_RENDERER_D3D9_DEVICE_POINTER`: The $(D IDirect3DDevice9) associated with the renderer.

    With the direct3d11 renderer:

    - `SDL_PROP_RENDERER_D3D11_DEVICE_POINTER`: the $(D ID3D11Device) associated
      with the renderer
    - `SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER`: the $(D IDXGISwapChain1)
      associated with the renderer. This may change when the window is resized.

    With the direct3d12 renderer:

    - `SDL_PROP_RENDERER_D3D12_DEVICE_POINTER`: the $(D ID3D12Device) associated
      with the renderer
    - `SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER`: the $(D IDXGISwapChain4)
      associated with the renderer.
    - `SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER`: the $(D ID3D12CommandQueue)
      associated with the renderer

    With the vulkan renderer:

    - `SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER`: the $(D VkInstance) associated
      with the renderer
    - `SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER`: the $(D VkSurfaceKHR) associated
      with the renderer
    - `SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER`: the $(D VkPhysicalDevice)
      associated with the renderer
    - `SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER`: the $(D VkDevice) associated with
      the renderer
    - `SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER`: the queue
      family index used for rendering
    - `SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER`: the queue
      family index used for presentation
    - `SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER`: the number of
      swapchain images, or potential frames in flight, used by the Vulkan
      renderer

    With the gpu renderer:

    - `SDL_PROP_RENDERER_GPU_DEVICE_POINTER`: The $(D SDL_GPUDevice) associated with the renderer.

    Params:
        renderer = The rendering context.

    Returns:
        A valid property ID on success or `0` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern SDL_PropertiesID SDL_GetRendererProperties(SDL_Renderer* renderer);

enum SDL_PROP_RENDERER_NAME_STRING                               = "SDL.renderer.name";
enum SDL_PROP_RENDERER_WINDOW_POINTER                            = "SDL.renderer.window";
enum SDL_PROP_RENDERER_SURFACE_POINTER                           = "SDL.renderer.surface";
enum SDL_PROP_RENDERER_VSYNC_NUMBER                              = "SDL.renderer.vsync";
enum SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER                   = "SDL.renderer.max_texture_size";
enum SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER                   = "SDL.renderer.texture_formats";
enum SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER                  = "SDL.renderer.output_colorspace";
enum SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN                       = "SDL.renderer.HDR_enabled";
enum SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT                     = "SDL.renderer.SDR_white_point";
enum SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT                        = "SDL.renderer.HDR_headroom";
enum SDL_PROP_RENDERER_D3D9_DEVICE_POINTER                       = "SDL.renderer.d3d9.device";
enum SDL_PROP_RENDERER_D3D11_DEVICE_POINTER                      = "SDL.renderer.d3d11.device";
enum SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER                   = "SDL.renderer.d3d11.swap_chain";
enum SDL_PROP_RENDERER_D3D12_DEVICE_POINTER                      = "SDL.renderer.d3d12.device";
enum SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER                   = "SDL.renderer.d3d12.swap_chain";
enum SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER               = "SDL.renderer.d3d12.command_queue";
enum SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER                   = "SDL.renderer.vulkan.instance";
enum SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER                     = "SDL.renderer.vulkan.surface";
enum SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER            = "SDL.renderer.vulkan.physical_device";
enum SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER                     = "SDL.renderer.vulkan.device";
enum SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER = "SDL.renderer.vulkan.graphics_queue_family_index";
enum SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER  = "SDL.renderer.vulkan.present_queue_family_index";
enum SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER       = "SDL.renderer.vulkan.swapchain_image_count";
enum SDL_PROP_RENDERER_GPU_DEVICE_POINTER                        = "SDL.renderer.gpu.device";

/**
    Get the output size in pixels of a rendering context.

    This returns the true output size in pixels, ignoring any render targets or
    logical size and presentation.

    Params:
        renderer = The rendering context.
        w = A pointer filled in with the width in pixels.
        h = A pointer filled in with the height in pixels.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetCurrentRenderOutputSize)
*/
extern bool SDL_GetRenderOutputSize(SDL_Renderer* renderer, int* w, int* h);

/**
    Get the current output size in pixels of a rendering context.

    If a rendering target is active, this will return the size of the rendering
    target in pixels, otherwise if a logical size is set, it will return the
    logical size, otherwise it will return the value of
    $(D SDL_GetRenderOutputSize).

    Params:
        renderer = The rendering context.
        w = A pointer filled in with the current width.
        h = A pointer filled in with the current height.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderOutputSize)
*/
extern bool SDL_GetCurrentRenderOutputSize(SDL_Renderer* renderer, int* w, int* h);

/**
    Create a texture for a rendering context.

    The contents of a texture when first created are not defined.

    Params:
        renderer = The rendering context.
        format = One of the enumerated values in $(D SDL_PixelFormat).
        access = One of the enumerated values in $(D SDL_TextureAccess).
        w = The width of the texture in pixels.
        h = The height of the texture in pixels.

    Returns:
        The created texture or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateTextureFromSurface)
        $(D SDL_CreateTextureWithProperties)
        $(D SDL_DestroyTexture)
        $(D SDL_GetTextureSize)
        $(D SDL_UpdateTexture)
*/
extern SDL_Texture* SDL_CreateTexture(SDL_Renderer* renderer, SDL_PixelFormat format, SDL_TextureAccess access, int w, int h);

/**
    Create a texture from an existing surface.

    The surface is not modified or freed by this function.

    The $(D SDL_TextureAccess) hint for the created texture is $(D SDL_TEXTUREACCESS_STATIC).

    The pixel format of the created texture may be different from the pixel
    format of the surface, and can be queried using the
    $(D SDL_PROP_TEXTURE_FORMAT_NUMBER) property.

    Params:
        renderer = The rendering context.
        surface = The $(D SDL_Surface) structure containing pixel data used to fill the texture.

    Returns:
        The created texture or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateTexture)
        $(D SDL_CreateTextureWithProperties)
        $(D SDL_DestroyTexture)
*/
extern SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer* renderer, SDL_Surface* surface);

/**
    Create a texture for a rendering context with the specified properties.

    These are the supported properties:

    - `SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER`: an $(D SDL_Colorspace) value
      describing the texture colorspace, defaults to `SDL_COLORSPACE_SRGB_LINEAR`
      for floating point textures, `SDL_COLORSPACE_HDR10` for 10-bit textures,
      `SDL_COLORSPACE_SRGB` for other RGB textures and `SDL_COLORSPACE_JPEG` for
      YUV textures.
    - `SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER`: one of the enumerated values in
      `SDL_PixelFormat`, defaults to the best RGBA format for the renderer
    - `SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER`: one of the enumerated values in
      `SDL_TextureAccess`, defaults to `SDL_TEXTUREACCESS_STATIC`
    - `SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER`: the width of the texture in
      pixels, required
    - `SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER`: the height of the texture in
      pixels, required
    - `SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating
      point textures, this defines the value of 100% diffuse white, with higher
      values being displayed in the High Dynamic Range headroom. This defaults
      to 100 for HDR10 textures and 1.0 for floating point textures.
    - `SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT`: for HDR10 and floating
      point textures, this defines the maximum dynamic range used by the
      content, in terms of the SDR white point. This would be equivalent to
      maxCLL / `SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT` for HDR10 content.
      If this is defined, any values outside the range supported by the display
      will be scaled into the available HDR headroom, otherwise they are
      clipped.

    With the direct3d11 renderer:

    - `SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER`: the $(D ID3D11Texture2D)
      associated with the texture, if you want to wrap an existing texture.
    - `SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER`: the $(D ID3D11Texture2D)
      associated with the U plane of a YUV texture, if you want to wrap an
      existing texture.
    - `SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER`: the $(D ID3D11Texture2D)
      associated with the V plane of a YUV texture, if you want to wrap an
      existing texture.

    With the direct3d12 renderer:

    - `SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER`: the $(D ID3D12Resource)
      associated with the texture, if you want to wrap an existing texture.
    - `SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER`: the $(D ID3D12Resource)
      associated with the U plane of a YUV texture, if you want to wrap an
      existing texture.
    - `SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER`: the $(D ID3D12Resource)
      associated with the V plane of a YUV texture, if you want to wrap an
      existing texture.

    With the metal renderer:

    - `SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER`: the $(D CVPixelBufferRef)
      associated with the texture, if you want to create a texture from an
      existing pixel buffer.

    With the opengl renderer:

    - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER`: the `GLuint` texture
      associated with the texture, if you want to wrap an existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER`: the `GLuint` texture
      associated with the UV plane of an NV12 texture, if you want to wrap an
      existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER`: the `GLuint` texture
      associated with the U plane of a YUV texture, if you want to wrap an
      existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER`: the `GLuint` texture
      associated with the V plane of a YUV texture, if you want to wrap an
      existing texture.

    With the opengles2 renderer:

    - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER`: the `GLuint` texture
      associated with the texture, if you want to wrap an existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER`: the `GLuint` texture
      associated with the texture, if you want to wrap an existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER`: the `GLuint` texture
      associated with the UV plane of an NV12 texture, if you want to wrap an
      existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER`: the `GLuint` texture
      associated with the U plane of a YUV texture, if you want to wrap an
      existing texture.
    - `SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER`: the `GLuint` texture
      associated with the V plane of a YUV texture, if you want to wrap an
      existing texture.

    With the vulkan renderer:

    - `SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER`: the $(D VkImage) with layout
      `VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL` associated with the texture, if
      you want to wrap an existing texture.

    Params:
        renderer = The rendering context.
        props = The properties to use.

    Returns:
        The created texture or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateProperties)
        $(D SDL_CreateTexture)
        $(D SDL_CreateTextureFromSurface)
        $(D SDL_DestroyTexture)
        $(D SDL_GetTextureSize)
        $(D SDL_UpdateTexture)
*/
extern SDL_Texture* SDL_CreateTextureWithProperties(SDL_Renderer* renderer, SDL_PropertiesID props);

enum SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER           = "SDL.texture.create.colorspace";
enum SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER               = "SDL.texture.create.format";
enum SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER               = "SDL.texture.create.access";
enum SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER                = "SDL.texture.create.width";
enum SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER               = "SDL.texture.create.height";
enum SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT       = "SDL.texture.create.SDR_white_point";
enum SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT          = "SDL.texture.create.HDR_headroom";
enum SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER       = "SDL.texture.create.d3d11.texture";
enum SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER     = "SDL.texture.create.d3d11.texture_u";
enum SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER     = "SDL.texture.create.d3d11.texture_v";
enum SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER       = "SDL.texture.create.d3d12.texture";
enum SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER     = "SDL.texture.create.d3d12.texture_u";
enum SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER     = "SDL.texture.create.d3d12.texture_v";
enum SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER   = "SDL.texture.create.metal.pixelbuffer";
enum SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER       = "SDL.texture.create.opengl.texture";
enum SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER    = "SDL.texture.create.opengl.texture_uv";
enum SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER     = "SDL.texture.create.opengl.texture_u";
enum SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER     = "SDL.texture.create.opengl.texture_v";
enum SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER    = "SDL.texture.create.opengles2.texture";
enum SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER = "SDL.texture.create.opengles2.texture_uv";
enum SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER  = "SDL.texture.create.opengles2.texture_u";
enum SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER  = "SDL.texture.create.opengles2.texture_v";
enum SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER       = "SDL.texture.create.vulkan.texture";

/**
    Get the properties associated with a texture.

    The following read-only properties are provided by SDL:

    - `SDL_PROP_TEXTURE_COLORSPACE_NUMBER`: an $(D SDL_Colorspace) value
      describing the texture colorspace.
    - `SDL_PROP_TEXTURE_FORMAT_NUMBER`: one of the enumerated values in
      $(D SDL_PixelFormat).
    - `SDL_PROP_TEXTURE_ACCESS_NUMBER`: one of the enumerated values in
      $(D SDL_TextureAccess).
    - `SDL_PROP_TEXTURE_WIDTH_NUMBER`: the width of the texture in pixels.
    - `SDL_PROP_TEXTURE_HEIGHT_NUMBER`: the height of the texture in pixels.
    - `SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating point
      textures, this defines the value of 100% diffuse white, with higher
      values being displayed in the High Dynamic Range headroom. This defaults
      to 100 for HDR10 textures and 1.0 for other textures.
    - `SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT`: for HDR10 and floating point
      textures, this defines the maximum dynamic range used by the content, in
      terms of the SDR white point. If this is defined, any values outside the
      range supported by the display will be scaled into the available HDR
      headroom, otherwise they are clipped. This defaults to 1.0 for SDR
      textures, 4.0 for HDR10 textures, and no default for floating point
      textures.

    With the direct3d11 renderer:

    - `SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER`: the $(D ID3D11Texture2D) associated
      with the texture
    - `SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER`: the $(D ID3D11Texture2D)
      associated with the U plane of a YUV texture
    - `SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER`: the $(D ID3D11Texture2D)
      associated with the V plane of a YUV texture

    With the direct3d12 renderer:

    - `SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER`: the $(D ID3D12Resource) associated
      with the texture
    - `SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER`: the $(D ID3D12Resource) associated
      with the U plane of a YUV texture
    - `SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER`: the $(D ID3D12Resource) associated
      with the V plane of a YUV texture

    With the vulkan renderer:

    - `SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER`: the $(D VkImage) associated with the
      texture

    With the opengl renderer:

    - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER`: the `GLuint` texture associated
      with the texture
    - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER`: the `GLuint` texture
      associated with the UV plane of an NV12 texture
    - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER`: the `GLuint` texture associated
      with the U plane of a YUV texture
    - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER`: the `GLuint` texture associated
      with the V plane of a YUV texture
    - `SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER`: the `GLenum` for the
      texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_RECTANGLE_ARB`, etc)
    - `SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT`: the texture coordinate width of
      the texture (0.0 - 1.0)
    - `SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT`: the texture coordinate height of
      the texture (0.0 - 1.0)

    With the opengles2 renderer:

    - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER`: the `GLuint` texture
      associated with the texture
    - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER`: the `GLuint` texture
      associated with the UV plane of an NV12 texture
    - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER`: the `GLuint` texture
      associated with the U plane of a YUV texture
    - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER`: the `GLuint` texture
      associated with the V plane of a YUV texture
    - `SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER`: the `GLenum` for the
      texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_EXTERNAL_OES`, etc)

    Params:
        texture = The texture to query.

    Returns:
        A valid property ID on success or `0` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern SDL_PropertiesID SDL_GetTextureProperties(SDL_Texture* texture);

enum SDL_PROP_TEXTURE_COLORSPACE_NUMBER                  = "SDL.texture.colorspace";
enum SDL_PROP_TEXTURE_FORMAT_NUMBER                      = "SDL.texture.format";
enum SDL_PROP_TEXTURE_ACCESS_NUMBER                      = "SDL.texture.access";
enum SDL_PROP_TEXTURE_WIDTH_NUMBER                       = "SDL.texture.width";
enum SDL_PROP_TEXTURE_HEIGHT_NUMBER                      = "SDL.texture.height";
enum SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT              = "SDL.texture.SDR_white_point";
enum SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT                 = "SDL.texture.HDR_headroom";
enum SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER              = "SDL.texture.d3d11.texture";
enum SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER            = "SDL.texture.d3d11.texture_u";
enum SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER            = "SDL.texture.d3d11.texture_v";
enum SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER              = "SDL.texture.d3d12.texture";
enum SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER            = "SDL.texture.d3d12.texture_u";
enum SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER            = "SDL.texture.d3d12.texture_v";
enum SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER              = "SDL.texture.opengl.texture";
enum SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER           = "SDL.texture.opengl.texture_uv";
enum SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER            = "SDL.texture.opengl.texture_u";
enum SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER            = "SDL.texture.opengl.texture_v";
enum SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER       = "SDL.texture.opengl.target";
enum SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT                 = "SDL.texture.opengl.tex_w";
enum SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT                 = "SDL.texture.opengl.tex_h";
enum SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER           = "SDL.texture.opengles2.texture";
enum SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER        = "SDL.texture.opengles2.texture_uv";
enum SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER         = "SDL.texture.opengles2.texture_u";
enum SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER         = "SDL.texture.opengles2.texture_v";
enum SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER    = "SDL.texture.opengles2.target";
enum SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER              = "SDL.texture.vulkan.texture";

/**
    Get the renderer that created an $(D SDL_Texture).

    Params:
        texture = The texture to query.

    Returns:
        A pointer to the $(D SDL_Renderer) that created the texture, or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is safe to call this function from any thread.
*/
extern SDL_Renderer* SDL_GetRendererFromTexture(SDL_Texture* texture);

/**
    Get the size of a texture, as floating point values.

    Params:
        texture = The texture to query.
        w = A pointer filled in with the width of the texture in pixels. This argument can be `null` if you don't need this information.
        h = A pointer filled in with the height of the texture in pixels. This argument can be `null` if you don't need this information.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_GetTextureSize(SDL_Texture* texture, float* w, float* h);

/**
    Set an additional color value multiplied into render copy operations.

    When this texture is rendered, during the copy operation each source color
    channel is modulated by the appropriate color value according to the
    following formula:

    `srcC = srcC * (color / 255)`

    Color modulation is not always supported by the renderer; it will return
    `false` if color modulation is not supported.

    Params:
        texture = The texture to update.
        r = The red color value multiplied into copy operations.
        g = The green color value multiplied into copy operations.
        b = The blue color value multiplied into copy operations.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureColorMod)
        $(D SDL_SetTextureAlphaMod)
        $(D SDL_SetTextureColorModFloat)
*/
extern bool SDL_SetTextureColorMod(SDL_Texture* texture, Uint8 r, Uint8 g, Uint8 b);

/**
    Set an additional color value multiplied into render copy operations.

    When this texture is rendered, during the copy operation each source color
    channel is modulated by the appropriate color value according to the
    following formula:

    `srcC = srcC * color`

    Color modulation is not always supported by the renderer; it will return
    `false` if color modulation is not supported.

    Params:
        texture = The texture to update.
        r = The red color value multiplied into copy operations.
        g = The green color value multiplied into copy operations.
        b = The blue color value multiplied into copy operations.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureColorModFloat)
        $(D SDL_SetTextureAlphaModFloat)
        $(D SDL_SetTextureColorMod)
*/
extern bool SDL_SetTextureColorModFloat(SDL_Texture* texture, float r, float g, float b);

/**
    Get the additional color value multiplied into render copy operations.

    Params:
        texture = The texture to query.
        r = A pointer filled in with the current red color value.
        g = A pointer filled in with the current green color value.
        b = A pointer filled in with the current blue color value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureAlphaMod)
        $(D SDL_GetTextureColorModFloat)
        $(D SDL_SetTextureColorMod)
*/
extern bool SDL_GetTextureColorMod(SDL_Texture *texture, Uint8 *r, Uint8 *g, Uint8 *b);

/**
    Get the additional color value multiplied into render copy operations.

    Params:
        texture = The texture to query.
        r = A pointer filled in with the current red color value.
        g = A pointer filled in with the current green color value.
        b = A pointer filled in with the current blue color value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureAlphaModFloat)
        $(D SDL_GetTextureColorMod)
        $(D SDL_SetTextureColorModFloat)
*/
extern bool SDL_GetTextureColorModFloat(SDL_Texture *texture, float *r, float *g, float *b);

/**
    Set an additional alpha value multiplied into render copy operations.

    When this texture is rendered, during the copy operation the source alpha
    value is modulated by this alpha value according to the following formula:

    `srcA = srcA * (alpha / 255)`

    Alpha modulation is not always supported by the renderer; it will return
    `false` if alpha modulation is not supported.

    Params:
        texture = The texture to update.
        alpha = The source alpha value multiplied into copy operations.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureAlphaMod)
        $(D SDL_SetTextureAlphaModFloat)
        $(D SDL_SetTextureColorMod)
*/
extern bool SDL_SetTextureAlphaMod(SDL_Texture* texture, Uint8 alpha);

/**
    Set an additional alpha value multiplied into render copy operations.

    When this texture is rendered, during the copy operation the source alpha
    value is modulated by this alpha value according to the following formula:

    `srcA = srcA * alpha`

    Alpha modulation is not always supported by the renderer; it will return
    `false` if alpha modulation is not supported.

    Params:
        texture = The texture to update.
        alpha = The source alpha value multiplied into copy operations.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureAlphaModFloat)
        $(D SDL_SetTextureAlphaMod)
        $(D SDL_SetTextureColorModFloat)
*/
extern bool SDL_SetTextureAlphaModFloat(SDL_Texture* texture, float alpha);

/**
    Get the additional alpha value multiplied into render copy operations.

    Params:
        texture = The texture to query.
        alpha = A pointer filled in with the current alpha value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureAlphaModFloat)
        $(D SDL_GetTextureColorMod)
        $(D SDL_SetTextureAlphaMod)
*/
extern bool SDL_GetTextureAlphaMod(SDL_Texture* texture, Uint8* alpha);

/**
    Get the additional alpha value multiplied into render copy operations.

    Params:
        texture = The texture to query.
        alpha = A pointer filled in with the current alpha value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureAlphaMod)
        $(D SDL_GetTextureColorModFloat)
        $(D SDL_SetTextureAlphaModFloat)
*/
extern bool SDL_GetTextureAlphaModFloat(SDL_Texture* texture, float* alpha);

/**
    Set the blend mode for a texture, used by $(D SDL_RenderTexture).

    If the blend mode is not supported, the closest supported mode is chosen
    and this function returns `false`.

    Params:
        texture = The texture to update.
        blendMode = The $(D SDL_BlendMode) to use for texture blending.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureBlendMode)
*/
extern bool SDL_SetTextureBlendMode(SDL_Texture* texture, SDL_BlendMode blendMode);

/**
    Get the blend mode used for texture copy operations.

    Params:
        texture = The texture to query.
        blendMode =  A pointer filled in with the current $(D SDL_BlendMode).

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetTextureBlendMode)
*/
extern bool SDL_GetTextureBlendMode(SDL_Texture* texture, SDL_BlendMode* blendMode);

/**
    Set the scale mode used for texture scale operations.

    The default texture scale mode is $(D SDL_SCALEMODE_LINEAR).

    If the scale mode is not supported, the closest supported mode is chosen.

    Params:
        texture = The texture to update.
        scaleMode = The $(D SDL_ScaleMode) to use for texture scaling.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetTextureScaleMode)
*/
extern bool SDL_SetTextureScaleMode(SDL_Texture* texture, SDL_ScaleMode scaleMode);

/**
    Get the scale mode used for texture scale operations.

    Params:
        texture = The texture to query.
        scaleMode = A pointer filled in with the current scale mode.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetTextureScaleMode)
*/
extern bool SDL_GetTextureScaleMode(SDL_Texture* texture, SDL_ScaleMode* scaleMode);

/**
    Update the given texture rectangle with new pixel data.

    The pixel data must be in the pixel format of the texture, which can be
    queried using the $(D SDL_PROP_TEXTURE_FORMAT_NUMBER) property.

    This is a fairly slow function, intended for use with static textures that
    do not change often.

    If the texture is intended to be updated often, it is preferred to create
    the texture as streaming and use the locking functions referenced below.
    While this function will work with streaming textures, for optimization
    reasons you may not get the pixels back if you lock the texture afterward.

    Params:
        texture = The texture to update.
        rect = An $(D SDL_Rect) structure representing the area to update, or `null` to update the entire texture.
        pixels = The raw pixel data in the format of the texture.
        pitch = The number of bytes in a row of pixel data, including padding between lines.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_LockTexture)
        $(D SDL_UnlockTexture)
        $(D SDL_UpdateNVTexture)
        $(D SDL_UpdateYUVTexture)
*/
extern bool SDL_UpdateTexture(SDL_Texture* texture, const(SDL_Rect)* rect, const(void)* pixels, int pitch);

/**
    Update a rectangle within a planar YV12 or IYUV texture with new pixel data.

    You can use $(D SDL_UpdateTexture) as long as your pixel data is a contiguous
    block of Y and U/V planes in the proper order, but this function is
    available if your pixel data is not contiguous.

    Params:
        texture = The texture to update.
        rect = A pointer to the rectangle of pixels to update, or `null` to update the entire texture.
        Yplane = The raw pixel data for the Y plane.
        Ypitch = The number of bytes between rows of pixel data for the Y plane.
        Uplane = The raw pixel data for the U plane.
        Upitch = The number of bytes between rows of pixel data for the U plane.
        Vplane = The raw pixel data for the V plane.
        Vpitch = The number of bytes between rows of pixel data for the V plane.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_UpdateNVTexture)
        $(D SDL_UpdateTexture)
*/
extern bool SDL_UpdateYUVTexture(SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* Uplane, int Upitch, const(ubyte)* Vplane, int Vpitch);

/**
    Update a rectangle within a planar NV12 or NV21 texture with new pixels.

    You can use $(D SDL_UpdateTexture) as long as your pixel data is a contiguous
    block of NV12/21 planes in the proper order, but this function is available
    if your pixel data is not contiguous.

    Params:
        texture = The texture to update.
        rect = A pointer to the rectangle of pixels to update, or `null` to update the entire texture.
        Yplane = The raw pixel data for the Y plane.
        Ypitch = The number of bytes between rows of pixel data for the Y plane.
        UVplane = The raw pixel data for the UV plane.
        UVpitch = The number of bytes between rows of pixel data for the UV plane.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_UpdateTexture)
        $(D SDL_UpdateYUVTexture)
*/
extern bool SDL_UpdateNVTexture(SDL_Texture* texture, const(SDL_Rect)* rect, const(ubyte)* Yplane, int Ypitch, const(ubyte)* UVplane, int UVpitch);

/**
    Lock a portion of the texture for **write-only** pixel access.

    As an optimization, the pixels made available for editing don't necessarily
    contain the old texture data. This is a write-only operation, and if you
    need to keep a copy of the texture data you should do that at the
    application level.

    You must use $(D SDL_UnlockTexture) to unlock the pixels and apply any changes.

    Params:
        texture = The texture to lock for access, which was created with $(D SDL_TEXTUREACCESS_STREAMING).
        rect = An $(D SDL_Rect) structure representing the area to lock for access; `null` to lock the entire texture.
        pixels = This is filled in with a pointer to the locked pixels, appropriately offset by the locked area.
        pitch = This is filled in with the pitch of the locked pixels; the pitch is the length of one row in bytes.

    Returns:
        `true` on success or `false` if the texture is not valid or was not created with $(D SDL_TEXTUREACCESS_STREAMING); call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_LockTextureToSurface)
        $(D SDL_UnlockTexture)
*/
extern bool SDL_LockTexture(SDL_Texture* texture, const(SDL_Rect)* rect, void** pixels, int* pitch);

/**
    Lock a portion of the texture for **write-only** pixel access, and expose
    it as an $(D SDL_Surface).

    Besides providing an $(D SDL_Surface) instead of raw pixel data, this function
    operates like $(D SDL_LockTexture).

    As an optimization, the pixels made available for editing don't necessarily
    contain the old texture data. This is a write-only operation, and if you
    need to keep a copy of the texture data you should do that at the
    application level.

    You must use $(D SDL_UnlockTexture) to unlock the pixels and apply any
    changes.

    The returned surface is freed internally after calling $(D SDL_UnlockTexture)
    or $(D SDL_DestroyTexture). The caller should not free it.

    Params:
        texture = The texture to lock for access, which must be created with $(D SDL_TEXTUREACCESS_STREAMING).
        rect = A pointer to the rectangle to lock for access. If the rect is `null`, the entire texture will be locked.
        surface = A pointer to an $(D SDL_Surface) of size **rect**. Don't assume any specific pixel content.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_LockTexture)
        $(D SDL_UnlockTexture)
*/
extern bool SDL_LockTextureToSurface(SDL_Texture* texture, const(SDL_Rect)* rect, SDL_Surface** surface);

/**
    Unlock a texture, uploading the changes to video memory, if needed.

    **Warning**: Please note that $(D SDL_LockTexture) is intended to be
    write-only; it will not guarantee the previous contents of the texture will
    be provided. You must fully initialize any area of a texture that you lock
    before unlocking it, as the pixels might otherwise be uninitialized memory.

    Which is to say: locking and immediately unlocking a texture can result in
    corrupted textures, depending on the renderer in use.

    Params:
        texture = A texture locked by $(D SDL_LockTexture).

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_LockTexture)
*/
extern void SDL_UnlockTexture(SDL_Texture* texture);

/**
    Set a texture as the current rendering target.

    The default render target is the window for which the renderer was created.
    To stop rendering to a texture and render to the window again, call this
    function with a `null` texture.

    Params:
        renderer = The rendering context.
        texture = The targeted texture, which must be created with the $(D SDL_TEXTUREACCESS_TARGET) flag, or `null` to render to the window instead of a texture.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderTarget)
*/
extern bool SDL_SetRenderTarget(SDL_Renderer* renderer, SDL_Texture* texture);

/**
    Get the current render target.

    The default render target is the window for which the renderer was created,
    and is reported a `null` here.

    Params:
        renderer = The rendering context.

    Returns:
        The current render target or `null` for the default render target.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderTarget)
*/
extern SDL_Texture* SDL_GetRenderTarget(SDL_Renderer* renderer);

/**
    Set a device independent resolution and presentation mode for rendering.

    This function sets the width and height of the logical rendering output.
    The renderer will act as if the window is always the requested dimensions,
    scaling to the actual window resolution as necessary.

    This can be useful for games that expect a fixed size, but would like to
    scale the output to whatever is available, regardless of how a user resizes
    a window, or if the display is high DPI.

    You can disable logical coordinates by setting the mode to
    $(D SDL_LOGICAL_PRESENTATION_DISABLED), and in that case you get the full pixel
    resolution of the output window; it is safe to toggle logical presentation
    during the rendering of a frame: perhaps most of the rendering is done to
    specific dimensions but to make fonts look sharp, the app turns off logical
    presentation while drawing text.

    Letterboxing will only happen if logical presentation is enabled during
    $(D SDL_RenderPresent); be sure to reenable it first if you were using it.

    You can convert coordinates in an event into rendering coordinates using
    $(D SDL_ConvertEventToRenderCoordinates).

    Params:
        renderer = The rendering context.
        w = The width of the logical resolution.
        h = The height of the logical resolution.
        mode = The presentation mode used.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_ConvertEventToRenderCoordinates)
        $(D SDL_GetRenderLogicalPresentation)
        $(D SDL_GetRenderLogicalPresentationRect)
*/
extern bool SDL_SetRenderLogicalPresentation(SDL_Renderer* renderer, int w, int h, SDL_RendererLogicalPresentation mode);

/**
    Get device independent resolution and presentation mode for rendering.

    This function gets the width and height of the logical rendering output, or
    the output size in pixels if a logical resolution is not enabled.

    Params:
        renderer = The rendering context.
        w = An int to be filled with the width.
        h = An int to be filled with the height.
        mode = The presentation mode used.

    Returns:
        true on success or false on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderLogicalPresentation)
*/
extern bool SDL_GetRenderLogicalPresentation(SDL_Renderer* renderer, int* w, int* h, SDL_RendererLogicalPresentation* mode);

/**
    Get the final presentation rectangle for rendering.

    This function returns the calculated rectangle used for logical
    presentation, based on the presentation mode and output size. If logical
    presentation is disabled, it will fill the rectangle with the output size,
    in pixels.

    Params:
        renderer = The rendering context.
        rect = A pointer filled in with the final presentation rectangle, may be `null`.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderLogicalPresentation)
*/
extern bool SDL_GetRenderLogicalPresentationRect(SDL_Renderer* renderer, SDL_FRect* rect);

/**
    Get a point in render coordinates when given a point in window coordinates.

    This takes into account several states:

    - The window dimensions.
    - The logical presentation settings $(D SDL_SetRenderLogicalPresentation)
    - The scale $(D SDL_SetRenderScale)
    - The viewport $(D SDL_SetRenderViewport)

    Params:
        renderer = The rendering context.
        window_x = The x coordinate in window coordinates.
        window_y = The y coordinate in window coordinates.
        x = A pointer filled with the x coordinate in render coordinates.
        y = A pointer filled with the y coordinate in render coordinates.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderLogicalPresentation)
        $(D SDL_SetRenderScale)
*/
extern bool SDL_RenderCoordinatesFromWindow(SDL_Renderer* renderer, float window_x, float window_y, float* x, float* y);

/**
    Get a point in window coordinates when given a point in render coordinates.

    This takes into account several states:

    - The window dimensions.
    - The logical presentation settings $(D SDL_SetRenderLogicalPresentation)
    - The scale $(D SDL_SetRenderScale)
    - The viewport $(D SDL_SetRenderViewport)

    Params:
        renderer = The rendering context.
        x = The x coordinate in render coordinates.
        y = The y coordinate in render coordinates.
        window_x = A pointer filled with the x coordinate in window coordinates.
        window_y = A pointer filled with the y coordinate in window coordinates.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderLogicalPresentation)
        $(D SDL_SetRenderScale)
        $(D SDL_SetRenderViewport)
*/
extern bool SDL_RenderCoordinatesToWindow(SDL_Renderer* renderer, float x, float y, float* window_x, float* window_y);

/**
    Convert the coordinates in an event to render coordinates.

    This takes into account several states:

    - The window dimensions.
    - The logical presentation settings $(D SDL_SetRenderLogicalPresentation)
    - The scale $(D SDL_SetRenderScale)
    - The viewport $(D SDL_SetRenderViewport)

    Various event types are converted with this function: mouse, touch, pen, etc.

    Touch coordinates are converted from normalized coordinates in the window
    to non-normalized rendering coordinates.

    Relative mouse coordinates (xrel and yrel event fields) are _also_
    converted. Applications that do not want these fields converted should use
    $(D SDL_RenderCoordinatesFromWindow) on the specific event fields instead of
    converting the entire event structure.

    Once converted, coordinates may be outside the rendering area.

    Params:
        renderer = The rendering context.
        event = The event to modify.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderCoordinatesFromWindow)
*/
extern bool SDL_ConvertEventToRenderCoordinates(SDL_Renderer* renderer, SDL_Event* event);

/**
    Set the drawing area for rendering on the current target.

    Drawing will clip to this area (separately from any clipping done with
    $(D SDL_SetRenderClipRect)), and the top left of the area will become
    coordinate (0, 0) for future drawing commands.

    The area's width and height must be >= 0.

    Params:
        renderer = The rendering context.
        rect = The $(D SDL_Rect) structure representing the drawing area, or `null` to set the viewport to the entire target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderViewport)
        $(D SDL_RenderViewportSet)
*/
extern bool SDL_SetRenderViewport(SDL_Renderer* renderer, const(SDL_Rect)* rect);

/**
    Get the drawing area for the current target.

    Params:
        renderer = The rendering context.
        rect = An $(D SDL_Rect) structure filled in with the current drawing area.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderViewportSet)
        $(D SDL_SetRenderViewport)
*/
extern bool SDL_GetRenderViewport(SDL_Renderer* renderer, SDL_Rect* rect);

/**
    Return whether an explicit rectangle was set as the viewport.

    This is useful if you're saving and restoring the viewport and want to know
    whether you should restore a specific rectangle or `null`. Note that the
    viewport is always reset when changing rendering targets.

    Params:
        renderer = The rendering context.

    Returns:
        `true` if the viewport was set to a specific rectangle, or `false` if it was set to `null` (the entire target).

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderViewport)
        $(D SDL_SetRenderViewport)
*/
extern bool SDL_RenderViewportSet(SDL_Renderer* renderer);

/**
    Get the safe area for rendering within the current viewport.

    Some devices have portions of the screen which are partially obscured or
    not interactive, possibly due to on-screen controls, curved edges, camera
    notches, TV overscan, etc. This function provides the area of the current
    viewport which is safe to have interactible content. You should continue
    rendering into the rest of the render target, but it should not contain
    visually important or interactible content.

    Params:
        renderer = The rendering context.
        rect = A pointer filled in with the area that is safe for interactive content.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_GetRenderSafeArea(SDL_Renderer* renderer, SDL_Rect* rect);

/**
    Set the clip rectangle for rendering on the specified target.

    Params:
        renderer = The rendering context.
        rect = An $(D SDL_Rect) structure representing the clip area, relative to the viewport, or `null` to disable clipping.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderClipRect)
        $(D SDL_RenderClipEnabled)
*/
extern bool SDL_SetRenderClipRect(SDL_Renderer* renderer, const(SDL_Rect)* rect);

/**
    Get the clip rectangle for the current target.

    Params:
        renderer = The rendering context.
        rect = An $(D SDL_Rect) structure filled in with the current clipping area or an empty rectangle if clipping is disabled.

    Returns:
        true on success or false on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderClipEnabled)
        $(D SDL_SetRenderClipRect)
*/
extern bool SDL_GetRenderClipRect(SDL_Renderer* renderer, SDL_Rect* rect);

/**
    Get whether clipping is enabled on the given renderer.

    Params:
        renderer = The rendering context.

    Returns:
        `true` if clipping is enabled or `false` if not; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderClipRect)
        $(D SDL_SetRenderClipRect)
*/
extern bool SDL_RenderClipEnabled(SDL_Renderer* renderer);

/**
    Set the drawing scale for rendering on the current target.

    The drawing coordinates are scaled by the x/y scaling factors before they
    are used by the renderer. This allows resolution independent drawing with a
    single coordinate system.

    If this results in scaling or subpixel drawing by the rendering backend, it
    will be handled using the appropriate quality hints. For best results use
    integer scaling factors.

    Params:
        renderer = The rendering context.
        scaleX = The horizontal scaling factor.
        scaleY = The vertical scaling factor.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderScale)
*/
extern bool SDL_SetRenderScale(SDL_Renderer* renderer, float scaleX, float scaleY);

/**
    Get the drawing scale for the current target.

    Params:
        renderer = The rendering context.
        scaleX = A pointer filled in with the horizontal scaling factor.
        scaleY = A pointer filled in with the vertical scaling factor.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderScale)
*/
extern bool SDL_GetRenderScale(SDL_Renderer* renderer, float* scaleX, float* scaleY);

/**
    Set the color used for drawing operations.

    Set the color for drawing or filling rectangles, lines, and points, and for
    $(D SDL_RenderClear).

    Params:
        renderer = The rendering context.
        r = The red value used to draw on the rendering target.
        g = The green value used to draw on the rendering target.
        b = The blue value used to draw on the rendering target.
        a = The alpha value used to draw on the rendering target; usually `SDL_ALPHA_OPAQUE` (255). Use $(D SDL_SetRenderDrawBlendMode) to specify how the alpha channel is used.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderDrawColor)
        $(D SDL_SetRenderDrawColorFloat)
*/
extern bool SDL_SetRenderDrawColor(SDL_Renderer* renderer, ubyte r, ubyte g, ubyte b, ubyte a);

/**
    Set the color used for drawing operations (Rect, Line and Clear).

    Set the color for drawing or filling rectangles, lines, and points, and for
    $(D SDL_RenderClear).

    Params:
        renderer = The rendering context.
        r = The red value used to draw on the rendering target.
        g = The green value used to draw on the rendering target.
        b = The blue value used to draw on the rendering target.
        a = The alpha value used to draw on the rendering target. Use $(D SDL_SetRenderDrawBlendMode) to specify how the alpha channel is used.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderDrawColorFloat)
        $(D SDL_SetRenderDrawColor)
*/
extern bool SDL_SetRenderDrawColorFloat(SDL_Renderer* renderer, float r, float g, float b, float a);

/**
    Get the color used for drawing operations (Rect, Line and Clear).

    Params:
        renderer = The rendering context.
        r = A pointer filled in with the red value used to draw on the rendering target.
        g = A pointer filled in with the green value used to draw on the rendering target.
        b = A pointer filled in with the blue value used to draw on the rendering target.
        a = A pointer filled in with the alpha value used to draw on the rendering target; usually $(D SDL_ALPHA_OPAQUE) `255`.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderDrawColorFloat)
        $(D SDL_SetRenderDrawColor)
*/
extern bool SDL_GetRenderDrawColor(SDL_Renderer* renderer, ubyte* r, ubyte* g, ubyte* b, ubyte* a);

/**
    Get the color used for drawing operations (Rect, Line and Clear).

    Params:
        renderer = The rendering context.
        r = A pointer filled in with the red value used to draw on the rendering target.
        g = A pointer filled in with the green value used to draw on the rendering target.
        b = A pointer filled in with the blue value used to draw on the rendering target.
        a = A pointer filled in with the alpha value used to draw on the rendering target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderDrawColorFloat)
        $(D SDL_GetRenderDrawColor)
*/
extern bool SDL_GetRenderDrawColorFloat(SDL_Renderer* renderer, float* r, float* g, float* b, float* a);

/**
    Set the color scale used for render operations.

    The color scale is an additional scale multiplied into the pixel color
    value while rendering. This can be used to adjust the brightness of colors
    during HDR rendering, or changing HDR video brightness when playing on an
    SDR display.

    The color scale does not affect the alpha channel, only the color
    brightness.

    Params:
        renderer = The rendering context.
        scale = The color scale value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderColorScale)
*/
extern bool SDL_SetRenderColorScale(SDL_Renderer* renderer, float scale);

/**
    Get the color scale used for render operations.

    Params:
        renderer = The rendering context.
        scale = A pointer filled in with the current color scale value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderColorScale)
*/
extern bool SDL_GetRenderColorScale(SDL_Renderer* renderer, float* scale);

/**
    Set the blend mode used for drawing operations (Fill and Line).

    If the blend mode is not supported, the closest supported mode is chosen.

    Params:
        renderer = The rendering context.
        blendMode = The $(D SDL_BlendMode) to use for blending.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderDrawBlendMode)
*/
extern bool SDL_SetRenderDrawBlendMode(SDL_Renderer* renderer, SDL_BlendMode blendMode);

/**
    Get the blend mode used for drawing operations.

    Params:
        renderer = The rendering context.
        blendMode = A pointer filled in with the current $(D SDL_BlendMode).

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderDrawBlendMode)
*/
extern bool SDL_GetRenderDrawBlendMode(SDL_Renderer* renderer, SDL_BlendMode* blendMode);

/**
    Clear the current rendering target with the drawing color.

    This function clears the entire rendering target, ignoring the viewport and
    the clip rectangle. Note, that clearing will also set/fill all pixels of
    the rendering target to current renderer draw color, so make sure to invoke
    $(D SDL_SetRenderDrawColor) when needed.

    Params:
        renderer = The rendering context.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderDrawColor)
*/
extern bool SDL_RenderClear(SDL_Renderer* renderer);

/**
    Draw a point on the current rendering target at subpixel precision.

    Params:
        renderer = The renderer which should draw a point.
        x = The x coordinate of the point.
        y = The y coordinate of the point.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    Returns:
        $(D SDL_RenderPoints)
*/
extern bool SDL_RenderPoint(SDL_Renderer* renderer, float x, float y);

/**
    Draw multiple points on the current rendering target at subpixel precision.

    Params:
        renderer = The renderer which should draw multiple points.
        points = The points to draw.
        count = The number of points to draw.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderPoint)
*/
extern bool SDL_RenderPoints(SDL_Renderer* renderer, const(SDL_FPoint)* points, int count);

/**
    Draw a line on the current rendering target at subpixel precision.

    Params:
        renderer = The renderer which should draw a line.
        x1 = The x coordinate of the start point.
        y1 = The y coordinate of the start point.
        x2 = The x coordinate of the end point.
        y2 = The y coordinate of the end point.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderLines)
*/
extern bool SDL_RenderLine(SDL_Renderer* renderer, float x1, float y1, float x2, float y2);

/**
    Draw a series of connected lines on the current rendering target at
    subpixel precision.

    Params:
        renderer = The renderer which should draw multiple lines.
        points = The points along the lines.
        count = The number of points, drawing count-1 lines.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderLine)
*/
extern bool SDL_RenderLines(SDL_Renderer* renderer, const(SDL_FPoint)* points, int count);

/**
    Draw a rectangle on the current rendering target at subpixel precision.

    Params:
        renderer = The renderer which should draw a rectangle.
        rect = A pointer to the destination rectangle, or `null` to outline the entire rendering target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderRects)
*/
extern bool SDL_RenderRect(SDL_Renderer* renderer, const(SDL_FRect)* rect);

/**
    Draw some number of rectangles on the current rendering target at subpixel
    precision.

    Params:
        renderer = The renderer which should draw multiple rectangles.
        rects = A pointer to an array of destination rectangles.
        count = The number of rectangles.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderRect)
*/
extern bool SDL_RenderRects(SDL_Renderer* renderer, const(SDL_FRect)* rects, int count);

/**
    Fill a rectangle on the current rendering target with the drawing color at
    subpixel precision.

    Params:
        renderer = The renderer which should fill a rectangle.
        rect = A pointer to the destination rectangle, or `null` for the entire rendering target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderFillRects)
*/
extern bool SDL_RenderFillRect(SDL_Renderer* renderer, const(SDL_FRect)* rect);

/**
    Fill some number of rectangles on the current rendering target with the
    drawing color at subpixel precision.

    Params:
        renderer = The renderer which should fill multiple rectangles.
        rects = A pointer to an array of destination rectangles.
        count = The number of rectangles.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderFillRect)
*/
extern bool SDL_RenderFillRects(SDL_Renderer* renderer, const(SDL_FRect)* rects, int count);

/**
    Copy a portion of the texture to the current rendering target at subpixel precision.

    Params:
        renderer = The renderer which should copy parts of a texture.
        texture = The source texture.
        srcrect = A pointer to the source rectangle, or `null` for the entire texture.
        dstrect = A pointer to the destination rectangle, or `null` for the entire rendering target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderTextureRotated)
        $(D SDL_RenderTextureTiled)
*/
extern bool SDL_RenderTexture(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FRect)* dstrect);

/**
    Copy a portion of the source texture to the current rendering target, with
    rotation and flipping, at subpixel precision.

    Params:
        renderer = The renderer which should copy parts of a texture.
        texture = The source texture.
        srcrect = A pointer to the source rectangle, or `null` for the entire texture.
        dstrect = A pointer to the destination rectangle, or `null` for the entire rendering target.
        angle = An angle in degrees that indicates the rotation that will be applied to dstrect, rotating it in a clockwise direction.
        center = A pointer to a point indicating the point around which dstrect will be rotated (if `null`, rotation will be done around dstrect.w/2, dstrect.h/2).
        flip = An $(D SDL_FlipMode) value stating which flipping actions should be performed on the texture.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderTexture)
*/
extern bool SDL_RenderTextureRotated(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FRect)* dstrect, double angle, const(SDL_FPoint)* center, SDL_FlipMode flip);

/**
    Copy a portion of the source texture to the current rendering target, with
    affine transform, at subpixel precision.

    Params:
        renderer = The renderer which should copy parts of a texture.
        texture = The source texture.
        srcrect = A pointer to the source rectangle, or `null` for the entire texture.
        origin = A pointer to a point indicating where the top-left corner of srcrect should be mapped to, or `null` for the rendering target's origin.
        right = A pointer to a point indicating where the top-right corner of srcrect should be mapped to, or `null` for the rendering target's top-right corner.
        down = A pointer to a point indicating where the bottom-left corner of srcrect should be mapped to, or `null` for the rendering target's bottom-left corner.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        You may only call this function from the main thread.

    See_Also:
        $(D SDL_RenderTexture)
*/
extern bool SDL_RenderTextureAffine(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, const(SDL_FPoint)* origin, const(SDL_FPoint)* right, const(SDL_FPoint)* down);

/**
    Tile a portion of the texture to the current rendering target at subpixel
    precision.

    The pixels in `srcrect` will be repeated as many times as needed to
    completely fill `dstrect`.

    Params:
        renderer = The renderer which should copy parts of a texture.
        texture = The source texture.
        srcrect = A pointer to the source rectangle, or `null` for the entire texture.
        scale = The scale used to transform srcrect into the destination rectangle, e.g. a 32x32 texture with a scale of 2 would fill 64x64 tiles.
        dstrect = A pointer to the destination rectangle, or `null` for the entire rendering target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderTexture)
*/
extern bool SDL_RenderTextureTiled(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, float scale, const(SDL_FRect)* dstrect);

/**
    Perform a scaled copy using the 9-grid algorithm to the current rendering
    target at subpixel precision.

    The pixels in the texture are split into a 3x3 grid, using the different
    corner sizes for each corner, and the sides and center making up the
    remaining pixels. The corners are then scaled using `scale` and fit into
    the corners of the destination rectangle. The sides and center are then
    stretched into place to cover the remaining destination rectangle.

    Params:
        renderer = The renderer which should copy parts of a texture.
        texture = The source texture.
        srcrect = The $(D SDL_Rect) structure representing the rectangle to be used for the 9-grid, or `null` to use the entire texture.
        left_width = The width, in pixels, of the left corners in `srcrect`.
        right_width = The width, in pixels, of the right corners in `srcrect`.
        top_height = The height, in pixels, of the top corners in `srcrect`.
        bottom_height = The height, in pixels, of the bottom corners in `srcrect`.
        scale = The scale used to transform the corner of `srcrect` into the corner of `dstrect`, or `0.0f` for an unscaled copy.
        dstrect = A pointer to the destination rectangle, or `null` for the entire rendering target.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderTexture)
*/
extern bool SDL_RenderTexture9Grid(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_FRect)* srcrect, float left_width, float right_width, float top_height, float bottom_height, float scale, const(SDL_FRect)* dstrect);

/**
    Render a list of triangles, optionally using a texture and indices into the
    vertex array Color and alpha modulation is done per vertex
    ($(D SDL_SetTextureColorMod) and $(D SDL_SetTextureAlphaMod) are ignored).

    Params:
        renderer = The rendering context.
        texture = (optional) The $(D SDL_Texture) to use.
        vertices = Vertices.
        num_vertices = Number of vertices.
        indices = (optional) An array of integer indices into the 'vertices' array, if `null` all vertices will be rendered in sequential order.
        num_indices = Number of indices.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderGeometryRaw)
*/
extern bool SDL_RenderGeometry(SDL_Renderer* renderer, SDL_Texture* texture, const(SDL_Vertex)* vertices, int num_vertices, const(int)* indices, int num_indices);

/**
    Render a list of triangles, optionally using a texture and indices into the
    vertex arrays Color and alpha modulation is done per vertex
    ($(D SDL_SetTextureColorMod) and $(D SDL_SetTextureAlphaMod) are ignored).

    Params:
        renderer = The rendering context.
        texture = (optional) The $(D SDL_Texture) to use.
        xy = Vertex positions.
        xy_stride = Byte size to move from one element to the next element.
        color = Vertex colors (as $(D SDL_FColor)).
        color_stride = Byte size to move from one element to the next element.
        uv = Vertex normalized texture coordinates.
        uv_stride = Byte size to move from one element to the next element.
        num_vertices = Number of vertices.
        indices = (optional) An array of indices into the 'vertices' arrays, if `null` all vertices will be rendered in sequential order.
        num_indices = Number of indices.
        size_indices = Index size: 1 (byte), 2 (short), 4 (int).

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderGeometry)
*/
extern bool SDL_RenderGeometryRaw(SDL_Renderer* renderer, SDL_Texture* texture, const(float)* xy, int xy_stride, const(SDL_FColor)* color, int color_stride, const(float)* uv, int uv_stride, int num_vertices, const(void)* indices, int num_indices, int size_indices);

/**
    Read pixels from the current rendering target.

    The returned surface should be freed with $(D SDL_DestroySurface).

    **WARNING**: This is a very slow operation, and should not be used
    frequently. If you're using this on the main rendering target, it should be
    called after rendering and before $(D SDL_RenderPresent).

    Params:
        renderer = The rendering context.
        rect = An $(D SDL_Rect) structure representing the area in pixels relative to the to current viewport, or `null` for the entire viewport.

    Returns:
        A new $(D SDL_Surface) on success or `null` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern SDL_Surface* SDL_RenderReadPixels(SDL_Renderer* renderer, const(SDL_Rect)* rect);

/**
    Update the screen with any rendering performed since the previous call.

    SDL's rendering functions operate on a backbuffer; that is, calling a
    rendering function such as $(D SDL_RenderLine) does not directly put a line
    on the screen, but rather updates the backbuffer. As such, you compose your
    entire scene and *present* the composed backbuffer to the screen as a
    complete picture.

    Therefore, when using SDL's rendering API, one does all drawing intended
    for the frame, and then calls this function once per frame to present the
    final drawing to the user.

    The backbuffer should be considered invalidated after each present; do not
    assume that previous contents will exist between frames. You are strongly
    encouraged to call $(D SDL_RenderClear) to initialize the backbuffer before
    starting each new frame's drawing, even if you plan to overwrite every
    pixel.

    Please note, that in case of rendering to a texture - there is **no need**
    to call $(D SDL_RenderPresent) after drawing needed objects to a texture,
    and should not be done; you are only required to change back the rendering
    target to default via `SDL_SetRenderTarget(renderer, null)` afterwards, as
    textures by themselves do not have a concept of backbuffers. Calling
    $(D SDL_RenderPresent) while rendering to a texture will still update the
    screen with any current drawing that has been done _to the window itself_.

    Params:
        renderer = The rendering context.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateRenderer)
        $(D SDL_RenderClear)
        $(D SDL_RenderFillRect)
        $(D SDL_RenderFillRects)
        $(D SDL_RenderLine)
        $(D SDL_RenderLines)
        $(D SDL_RenderPoint)
        $(D SDL_RenderPoints)
        $(D SDL_RenderRect)
        $(D SDL_RenderRects)
        $(D SDL_SetRenderDrawBlendMode)
        $(D SDL_SetRenderDrawColor)
*/
extern bool SDL_RenderPresent(SDL_Renderer* renderer);

/**
    Destroy the specified texture.

    Passing `null` or an otherwise invalid texture will set the SDL error
    message to "Invalid texture".

    Params:
        texture = The texture to destroy.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateTexture)
        $(D SDL_CreateTextureFromSurface)
*/
extern void SDL_DestroyTexture(SDL_Texture* texture);

/**
    Destroy the rendering context for a window and free all associated
    textures.

    This should be called before destroying the associated window.

    Params:
        renderer = The rendering context.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_CreateRenderer)
*/
extern void SDL_DestroyRenderer(SDL_Renderer* renderer);

/**
    Force the rendering context to flush any pending commands and state.

    You do not need to (and in fact, shouldn't) call this function unless you
    are planning to call into OpenGL/Direct3D/Metal/whatever directly, in
    addition to using an $(D SDL_Renderer).

    This is for a very-specific case: if you are using SDL's render API, and
    you plan to make OpenGL/D3D/whatever calls in addition to SDL render API
    calls. If this applies, you should call this function between calls to
    SDL's render API and the low-level API you're using in cooperation.

    In all other cases, you can ignore this function.

    This call makes SDL flush any pending rendering work it was queueing up to
    do later in a single batch, and marks any internal cached state as invalid,
    so it'll prepare all its state again later, from scratch.

    This means you do not need to save state in your rendering code to protect
    the $(D SDL_Renderer). However, there lots of arbitrary pieces of Direct3D
    and OpenGL state that can confuse things; you should use your best judgment
    and be prepared to make changes if specific state needs to be protected.

    Params:
        renderer = The rendering context.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.
*/
extern bool SDL_FlushRenderer(SDL_Renderer* renderer);

/**
    Get the $(D CAMetalLayer) associated with the given Metal renderer.

    This function returns `void *`, so SDL doesn't have to include Metal's
    headers, but it can be safely cast to a `CAMetalLayer *`.

    Params:
        renderer = The renderer to query.

    Returns:
        A `CAMetalLayer *` on success, or `null` if the renderer isn't a Metal renderer.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderMetalCommandEncoder)
*/
extern void* SDL_GetRenderMetalLayer(SDL_Renderer* renderer);

/**
    Get the Metal command encoder for the current frame.

    This function returns `void *`, so SDL doesn't have to include Metal's
    headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.

    This will return `null` if Metal refuses to give SDL a drawable to render
    to, which might happen if the window is hidden/minimized/offscreen. This
    doesn't apply to command encoders for render targets, just the window's
    backbuffer. Check your return values!

    Params:
        renderer = The renderer to query.

    Returns:
        An `id<MTLRenderCommandEncoder>` on success, or `null` if the renderer isn't a Metal renderer or there was an error.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderMetalLayer)
*/
extern void* SDL_GetRenderMetalCommandEncoder(SDL_Renderer* renderer);

/**
    Add a set of synchronization semaphores for the current frame.

    The Vulkan renderer will wait for `wait_semaphore` before submitting
    rendering commands and signal `signal_semaphore` after rendering commands
    are complete for this frame.

    This should be called each frame that you want semaphore synchronization.
    The Vulkan renderer may have multiple frames in flight on the GPU, so you
    should have multiple semaphores that are used for synchronization. Querying
    `SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER` will give you the
    maximum number of semaphores you'll need.

    Params:
        renderer = The rendering context.
        wait_stage_mask = The $(D VkPipelineStageFlags) for the wait.
        wait_semaphore = A $(D VkSempahore) to wait on before rendering the current frame, or `0` if not needed.
        signal_semaphore = A $(D VkSempahore) that SDL will signal when rendering for the current frame is complete, or `0` if not needed.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        It is **NOT** safe to call this function from two threads at once.
*/
extern bool SDL_AddVulkanRenderSemaphores(SDL_Renderer* renderer, uint wait_stage_mask, long wait_semaphore, long signal_semaphore);

/**
    Toggle VSync of the given renderer.

    When a renderer is created, vsync defaults to `SDL_RENDERER_VSYNC_DISABLED`.

    The `vsync` parameter can be 1 to synchronize present with every vertical
    refresh, 2 to synchronize present with every second vertical refresh, etc.,
    `SDL_RENDERER_VSYNC_ADAPTIVE` for late swap tearing (adaptive vsync), or
    `SDL_RENDERER_VSYNC_DISABLED` to disable. Not every value is supported by
    every driver, so you should check the return value to see whether the
    requested setting is supported.

    Params:
        renderer = The renderer to toggle.
        vsync = The vertical refresh sync interval.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_GetRenderVSync)
*/
extern bool SDL_SetRenderVSync(SDL_Renderer* renderer, int vsync);

enum SDL_RENDERER_VSYNC_DISABLED =  0;
enum SDL_RENDERER_VSYNC_ADAPTIVE = -1;

/**
    Get VSync of the given renderer.

    Params:
        renderer = The renderer to toggle.
        vsync = An int filled with the current vertical refresh sync interval. See $(D SDL_SetRenderVSync) for the meaning of the value.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_SetRenderVSync)
*/
extern bool SDL_GetRenderVSync(SDL_Renderer* renderer, int* vsync);

/**
    The size, in pixels, of a single $(D SDL_RenderDebugText) character.

    The font is monospaced and square, so this applies to all characters.

    See_Also:
        $(D SDL_RenderDebugText)
*/
enum SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE = 8;

/**
    Draw debug text to an $(D SDL_Renderer).

    This function will render a string of text to an $(D SDL_Renderer). Note
    that this is a convenience function for debugging, with severe limitations,
    and not intended to be used for production apps and games.

    Among these limitations:

    - It accepts UTF-8 strings, but will only renders ASCII characters.
    - It has a single, tiny size (8x8 pixels). One can use logical presentation
      or scaling to adjust it, but it will be blurry.
    - It uses a simple, hardcoded bitmap font. It does not allow different font
      selections and it does not support truetype, for proper scaling.
    - It does no word-wrapping and does not treat newline characters as a line
      break. If the text goes out of the window, it's gone.

    For serious text rendering, there are several good options, such as
    SDL_ttf, stb_truetype, or other external libraries.

    On first use, this will create an internal texture for rendering glyphs.
    This texture will live until the renderer is destroyed.

    The text is drawn in the color specified by $(D SDL_SetRenderDrawColor).

    Params:
        renderer = The renderer which should draw a line of text.
        x = The x coordinate where the top-left corner of the text will draw.
        y = The y coordinate where the top-left corner of the text will draw.
        str = The string to render.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderDebugTextFormat)
        $(D SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE)
*/
extern bool SDL_RenderDebugText(SDL_Renderer* renderer, float x, float y, const(char)* str);

/**
    Draw debug text to an $(D SDL_Renderer).

    This function will render a `printf()`-style format string to a renderer.
    Note that this is a convinence function for debugging, with severe
    limitations, and is not intended to be used for production apps and games.

    For the full list of limitations and other useful information, see
    $(D SDL_RenderDebugText).

    Params:
        renderer = The renderer which should draw the text.
        x = The x coordinate where the top-left corner of the text will draw.
        y = The y coordinate where the top-left corner of the text will draw.
        fmt = The format string to draw.
        rest = Additional parameters matching `%` tokens in the `fmt` string, if any.

    Returns:
        `true` on success or `false` on failure; call $(D SDL_GetError) for more information.

    Threadsafety:
        This function should only be called on the main thread.

    See_Also:
        $(D SDL_RenderDebugText)
        $(D SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE)
*/
extern bool SDL_RenderDebugTextFormat(SDL_Renderer* renderer, float x, float y, const(char)* fmt, ...);
