const std = @import("std");
const utf8 = @import("utf8.zig");
const Self = @This();

bytes: []const u8,
index: usize = 0,

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
    if (self.index >= self.bytes.len) return null;
    const start = self.index;
    self.index += utf8.nextCharacterBreak(self.bytes[start..]);
    return self.bytes[start..self.index];
}

pub fn nextLineBreak(self: *Self) ?[]const u8 {
    if (self.index >= self.bytes.len) return null;
    const start = self.index;
    self.index += utf8.nextLineBreak(self.bytes[start..]);
    return self.bytes[start..self.index];
}

pub fn nextSentenceBreak(self: *Self) ?[]const u8 {
    if (self.index >= self.bytes.len) return null;
    const start = self.index;
    self.index += utf8.nextSentenceBreak(self.bytes[start..]);
    return self.bytes[start..self.index];
}

pub fn nextWordBreak(self: *Self) ?[]const u8 {
    if (self.index >= self.bytes.len) return null;
    const start = self.index;
    self.index += utf8.nextWordBreak(self.bytes[start..]);
    return self.bytes[start..self.index];
}

pub fn reset(self: *Self) void {
    self.index = 0;
}
