# zig-dos-like-rotozoom :floppy_disk:

Getting the [rotozoom](https://github.com/mattiasgustavsson/dos-like/blob/main/source/rotozoom.c)
example from [dos-like](https://github.com/mattiasgustavsson/dos-like) to build in
[Zig](https://ziglang.org/) :zap:

> [!Note]
> `zig translate-c -lc rotozoom.c > rotozoom.zig` was used as a starting point of the port.
>
> Most of the time was spent figuring out how to setup the build :joy:

## Rotozoom effect

![rotozoom](files/rotozoom.gif)

This image is used in the rotozoom effect.

## Requirements

A fairly recent version of [Zig master](https://ziglang.org/download/#release-master)
(which would be `0.14.0-dev.1472` when this was written)

 - `SDL2`
 - `GLEW`
 - `pthread`

## Compilation

You should hopefully be able to compile the binary by calling `zig build`

> [!Note]
> As a convenience you can compile and run the binary via `zig build run`
> (or `zig build run -- -w` if you want to start in windowed mode)

## Links

 - https://mattiasgustavsson.itch.io/dos-like
 - https://ziglang.org/
 - https://seancode.com/demofx/
