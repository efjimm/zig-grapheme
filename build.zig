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

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    tests.linkLibrary(grapheme.artifact("grapheme"));
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run all unit tests");
    test_step.dependOn(&run_tests.step);
}
