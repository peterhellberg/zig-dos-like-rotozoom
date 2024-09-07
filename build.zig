const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable(.{
        .name = "zig-dos-like-rotozoom",
        .root_source_file = b.path("src/rotozoom.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });

    exe.addCSourceFile(.{ .file = b.path("dos/dos.c") });
    exe.addIncludePath(b.path("dos"));

    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("GLEW");
    exe.linkSystemLibrary("pthread");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
