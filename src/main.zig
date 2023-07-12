const std = @import("std");

pub const utf8 = @import("utf8.zig");
pub const codepoint = @import("codepoint.zig");

test {
    std.testing.refAllDeclsRecursive(utf8);
    std.testing.refAllDeclsRecursive(codepoint);
}
