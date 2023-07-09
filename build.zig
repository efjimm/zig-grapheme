const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const grapheme = b.dependency("libgrapheme", .{ .target = target, .optimize = optimize });

    _ = b.addModule("libgrapheme-zig", .{
        .source_file = .{ .path = "src/main.zig" },
    });

    // Hacky way to avoid having to expose a custom `link` function to users of this library
    const lib = b.addStaticLibrary(.{
        .name = "grapheme-zig",
        .root_source_file = .{ .path = "stub.c" },
        .optimize = optimize,
        .target = target,
    });
    lib.linkLibrary(grapheme.artifact("grapheme"));
    b.installArtifact(lib);
}
