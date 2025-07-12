/**
    Bindings to SDL3.

    Importing this module imports all of the core functionality of SDL3,
    namely window and event handling.

    Copyright: © 2025 Inochi2D Project, © 1997-2025 Sam Lantinga
    License: Subject to the terms of the Zlib License, as written in the LICENSE file.
    Authors: 
        Luna Nielsen
*/
module sdl;

public import sdl.init;
public import sdl.stdc;

public import sdl.video;
public import sdl.audio;
public import sdl.camera;

public import sdl.events;
public import sdl.keyboard;
public import sdl.mouse;
public import sdl.iostream;
public import sdl.joystick;
public import sdl.gamepad;
public import sdl.touch;
public import sdl.pen;
public import sdl.pixels;
public import sdl.properties;
public import sdl.rect;
public import sdl.render;
public import sdl.sensor;