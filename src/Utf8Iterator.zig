const std = @import("std");
const utf8 = @import("utf8.zig");
const Self = @This();

bytes: []const u8,
index: usize = 0,

fn next(self: *Self, comptime func: fn ([]const u8) usize) ?[]const u8 {
    if (self.index >= self.bytes.len) return null;
    const start = self.index;
    self.index += func(self.bytes[self.index..]);
    return self.bytes[start..self.index];
}

pub fn nextCodepoint(self: *Self) ?u21 {
    const slice = self.nextCodepointSlice() orelse return null;
    return std.unicode.utf8Decode(slice) catch unreachable;
}

pub fn nextCodepointSlice(self: *Self) ?[]const u8 {
    if (self.index >= self.bytes.len) return null;
    const start = self.index;
    self.index += std.unicode.utf8ByteSequenceLength(self.bytes[self.index]) catch unreachable;
    return self.bytes[start..self.index];
}

pub fn nextGrapheme(self: *Self) ?[]const u8 {
    return self.next(utf8.nextCharacterBreak);
}

pub fn nextLineBreak(self: *Self) ?[]const u8 {
    return self.next(utf8.nextLineBreak);
}

pub fn nextSentenceBreak(self: *Self) ?[]const u8 {
    return self.next(utf8.nextSentenceBreak);
}

pub fn nextWordBreak(self: *Self) ?[]const u8 {
    return self.next(utf8.nextWordBreak);
}

pub fn reset(self: *Self) void {
    self.index = 0;
}
