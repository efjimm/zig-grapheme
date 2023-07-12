const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const grapheme = b.dependency("libgrapheme", .{ .target = target, .optimize = optimize });

    _ = b.addModule("grapheme", .{
        .source_file = .{ .path = "src/main.zig" },
    });
    b.installArtifact(grapheme.artifact("grapheme"));

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
