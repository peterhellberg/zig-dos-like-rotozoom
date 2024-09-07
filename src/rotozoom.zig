// Zig port of Mattias Gustavssons port of
// rotozoom code by seancode
//
// - https://github.com/mattiasgustavsson/dos-like/blob/main/source/rotozoom.c
// - https://seancode.com/demofx/
//
// See end of file for original license
//                     / Peter Hellberg

const std = @import("std");

const ctr = std.zig.c_translation;

const dos = @cImport({
    @cInclude("dos.h");
});

pub extern fn main() u8;

pub export fn dosmain() u8 {
    dos.setvideomode(dos.videomode_320x200);
    dos.setdoublebuffer(1);

    var palette: [768]u8 = undefined;
    var gifWidth: c_int = 0;
    var gifHeight: c_int = 0;
    var palcount: c_int = 0;

    const gif = dos.loadgif(
        "files/rotozoom.gif",
        &gifWidth,
        &gifHeight,
        &palcount,
        &palette,
    );

    var i: c_int = 0;

    while (i < palcount) : (i += 1) {
        dos.setpal(
            i,
            @as(
                c_int,
                @bitCast(@as(
                    c_uint,
                    palette[@as(c_uint, @intCast(3 * i + 0))],
                )),
            ),
            @as(
                c_int,
                @bitCast(@as(
                    c_uint,
                    palette[@as(c_uint, @intCast(3 * i + 1))],
                )),
            ),
            @as(
                c_int,
                @bitCast(@as(
                    c_uint,
                    palette[@as(c_uint, @intCast(3 * i + 2))],
                )),
            ),
        );
    }

    var buffer: [*c]u8 = dos.screenbuffer();

    var angle: c_int = 0;

    while (!(dos.shuttingdown() != 0)) {
        dos.waitvbl();

        const s: f32 = std.math.sin(
            @as(f32, @floatFromInt(angle)) * 3.1415927410125732 / 180.0,
        );

        const c: f32 = std.math.cos(
            @as(f32, @floatFromInt(angle)) * 3.1415927410125732 / 180.0,
        );

        angle = ctr.signedRemainder(angle + 1, 360);

        var destOfs: c_int = 0;

        var y: c_int = 0;

        while (y < 200) : (y += 1) {
            var x: c_int = 0;

            while (x < 320) : (x += 1) {
                var u: c_int = ctr.signedRemainder(
                    @as(c_int, @intFromFloat(
                        (((@as(f32, @floatFromInt(x)) * c) -
                            (@as(f32, @floatFromInt(y)) * s)) * s + 1) + 64,
                    )),
                    gifWidth,
                );

                var v: c_int = ctr.signedRemainder(
                    @as(c_int, @intFromFloat(
                        (((@as(f32, @floatFromInt(x)) * s) +
                            (@as(f32, @floatFromInt(y)) * c)) * s + 1) + 64,
                    )),
                    gifHeight,
                );

                if (u < 0) {
                    u += gifWidth;
                }

                if (v < 0) {
                    v += gifHeight;
                }

                const srcOfs: c_int = u + (v * gifWidth);

                (blk: {
                    const tmp = blk_1: {
                        const ref = &destOfs;
                        const tmp_2 = ref.*;

                        ref.* += 1;

                        break :blk_1 tmp_2;
                    };

                    if (tmp >= 0) break :blk buffer +
                        @as(usize, @intCast(tmp)) else break :blk buffer -
                        ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
                }).* = (blk: {
                    const tmp = srcOfs;

                    if (tmp >= 0) break :blk gif +
                        @as(usize, @intCast(tmp)) else break :blk gif -
                        ~@as(usize, @bitCast(@as(isize, @intCast(tmp)) +% -1));
                }).*;
            }
        }

        buffer = dos.swapbuffers();

        if (dos.keystate(@as(c_uint, @bitCast(dos.KEY_ESCAPE))) != 0) break;
    }

    return 0;
}

// License of the original version by seancode

// Copyright (c) 2021, seancode
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGE.
