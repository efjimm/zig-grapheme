const std = @import("std");
const c = @cImport({
    @cInclude("grapheme.h");
});

pub const Iterator = @import("Utf8Iterator.zig");

/// Returns the offset (in bytes) to the next grapheme break in the UTF-8 encoded
/// string `str`. If a grapheme begins at `str` this offset is equal to the length
/// of said grapheme.
///
/// For null-terminated strings whose length is not known, use
/// `nextCharacterBreakZ`. For non-UTF-8 input data
/// `codepoint.isCharacterBreak` and `codepoint.nextCharacterBreak` can be used
/// instead.
pub fn nextCharacterBreak(str: []const u8) usize {
    return c.grapheme_next_character_break_utf8(str.ptr, str.len);
}

/// Returns the offset (in bytes) to the next possible line break in the UTF-8
/// encoded string `str`.
///
/// For null-terminated strings whose length is not known, use
/// `nextLineBreakZ`. For non-UTF-8 input data
/// `codepiont.nextLineBreak` can be used.
pub fn nextLineBreak(str: []const u8) usize {
    return c.grapheme_next_line_break_utf8(str.ptr, str.len);
}

/// Returns the offset (in bytes) to the next sentence break in the UTF-8
/// encoded string `str`. If a sentence begins at `str` this offset is equal
/// to the length of said sentence.
///
/// For null-terminated strings whose length is not known, use
/// `nextSentenceBreakZ`. For non-UTF-8 input data
/// `codepoint.nextSentenceBreak` can be used instead.
pub fn nextSentenceBreak(str: []const u8) usize {
    return c.grapheme_next_sentence_break_utf8(str.ptr, str.len);
}

/// Returns the offset (in bytes) to the next word break in the UTF-8 encoded
/// string `str`. If a word begins at `str` this offset is equal to the length
/// of said word.
///
/// For null-terminated strings whose length is not known, use
/// `nextWordBreakZ`.
pub fn nextWordBreak(str: []const u8) usize {
    return c.grapheme_next_word_break_utf8(str.ptr, str.len);
}

/// Returns the offset (in bytes) to the next grapheme cluster break in the
/// null terminated, UTF-8 encoded string `str`. If a grapheme begins at `str`
/// this offset is equal to the length of said grapheme cluster.
///
/// For non-UTF-8 input data `codepoint.isCharacterBreak` and
/// `codepoint.nextCharacterBreak` can be used instead.
pub fn nextCharacterBreakZ(str: [*:0]const u8) usize {
    return c.grapheme_next_character_break_utf8(str, c.SIZE_MAX);
}

/// Returns the offset (in bytes) to the next possible line break in the null
/// terminated, UTF-8 encoded string `str`.
///
/// For non-UTF-8 input data `codepoint.isCharacterBreak` and
/// `codepoint.nextCharacterBreak` can be used instead.
pub fn nextLineBreakZ(str: [*:0]const u8) usize {
    return c.grapheme_next_line_break_utf8(str, c.SIZE_MAX);
}

/// Returns the offset (in bytes) to the next sentence break in the null
/// terminated, UTF-8 encoded string 'str'. If a sentence begins at `str` this
/// offset is equal to the length of said sentence.
///
/// For non-UTF-8 input data `codepoint.nextSentenceBreak` can be used instead.
pub fn nextSentenceBreakZ(str: [*:0]const u8) usize {
    return c.grapheme_next_sentence_break_utf8(str, c.SIZE_MAX);
}

/// Returns the offset (in bytes) to the next word break in the null
/// terminated, UTF-8 encoded string `str`. If a word begins at `str` this
/// offset is equal to the length of said word.
///
/// For non-UTF-8 input data `codepoint.nextWordBreak` can be used instead.
pub fn nextWordBreakZ(str: [*:0]const u8) usize {
    return c.grapheme_next_word_break_utf8(str, c.SIZE_MAX);
}

pub fn decode(bytes: []const u8) u21 {
    var cp: u32 = undefined;
    _ = c.grapheme_decode_utf8(bytes.ptr, bytes.len, &cp);
    return @intCast(cp);
}

pub fn decodeLen(bytes: []const u8) struct { codepoint: u21, len: usize } {
    var cp: u32 = undefined;
    const len = c.grapheme_decode_utf8(bytes.ptr, bytes.len, &cp);
    return .{
        .codepoint = @intCast(cp),
        .len = len,
    };
}
