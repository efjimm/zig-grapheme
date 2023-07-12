const std = @import("std");
const c = @cImport({
    @cInclude("grapheme.h");
});
const utf8 = @import("utf8.zig");

comptime {
    std.debug.assert(@sizeOf(c.uint_least32_t) == @sizeOf(u32));
    std.debug.assert(@sizeOf(c.uint_least16_t) == @sizeOf(u16));
}

pub const Iterator = @import("CodepointIterator.zig");

/// Returns the offset (in codepoints) to the next grapheme_cluster break in
/// the codepoint slice `str`. If a grapheme cluster begins at `str` this
/// offset is equal to the length of said grapheme cluster.
///
/// For UTF-8-encoded input data `utf8.nextCharacterBreak` can be used
/// instead.
pub fn nextCharacterBreak(str: []const u32) usize {
    return c.grapheme_next_character_break(@ptrCast(str.ptr), str.len);
}

/// Returns the offset (in codepoints) to the next possible line break in the
/// codepoint slice `str`.
///
/// For UTF-8-encoded input data `utf8.nextLineBreak` can be used instead.
pub fn nextLineBreak(str: []const u32) usize {
    return c.grapheme_next_line_break(@ptrCast(str.ptr), str.len);
}

/// Returns the offset (in codepoints) to the next sentence break in the
/// codepoint slice `str`. If a sentence begins at `str` this offset is equal
/// to the length of said sentence.
///
/// For UTF-8-encoded input data `utf8.nextSentenceBreak` can be used instead
pub fn nextSentenceBreak(str: []const u32) usize {
    return c.grapheme_next_sentence_break(@ptrCast(str.ptr), str.len);
}

/// Returns the offset (in codepoints) to the next word break in the codepoint
/// slice `str`. If a word begins at `str` this offset is equal to the length
/// of said word.
///
/// For UTF-8-encoded input data `utf8.nextWordBreak` can be used instead.
pub fn nextWordBreak(str: []const u32) usize {
    return c.grapheme_next_word_break(@ptrCast(str.ptr), str.len);
}

/// Returns the offset (in codepoints) to the next grapheme_cluster break in
/// the null-terminated codepoint pointer `str`. If a grapheme cluster begins
/// at `str` this offset is equal to the length of said grapheme cluster.
///
/// For UTF-8-encoded input data `utf8.nextCharacterBreakZ` can be used
/// instead.
pub fn nextCharacterBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_character_break(@ptrCast(str), c.SIZE_MAX);
}

/// Returns the offset (in codepoints) to the next possible line break in the
/// null-terminated codepoint pointer `str`.
///
/// For UTF-8-encoded input data `utf8.nextLineBreakZ` can be used instead.
pub fn nextLineBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_line_break(@ptrCast(str), c.SIZE_MAX);
}

/// Returns the offset (in codepoints) to the next sentence break in the
/// null-terminated codepoint pointer `str`. If a sentence begins at `str` this
/// offset is equal to the length of said sentence.
///
/// For UTF-8-encoded input data `utf8.nextSentenceBreakZ` can be used instead
pub fn nextSentenceBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_sentence_break(@ptrCast(str), c.SIZE_MAX);
}

/// Returns the offset (in codepoints) to the next word break in the
/// null-terminated codepoint pointer `str`. If a word begins at `str` this
/// offset is equal to the length of said word.
///
/// For UTF-8-encoded input data `utf8.nextWordBreakZ` can be used instead.
pub fn nextWordBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_word_break(@ptrCast(str), c.SIZE_MAX);
}

/// Determines if there is a grapheme cluster break between the two codepoints
/// `cp1` and `cp2`. By specificatino this decision depends on a `state` that
/// can at most be completely reset after detecting a break and must be reset
/// every time one deviates from sequential processing.
///
/// If `state` is null `isCharacterBreak` behaves as if it was called with a
/// fully reset state.
pub fn isCharacterBreak(cp1: u32, cp2: u32, state: ?*u16) bool {
    return c.grapheme_is_character_break(cp1, cp2, state);
}

/// Checks if the codepoint slice `str` is lowercase.
///
/// For UTF-8-encoded input data `utf8.isLowercase` can be used instead.
/// For null-terminated codepoint pointers `isLowercaseZ` can be used instead.
pub fn isLowercase(str: []const u32) bool {
    return c.grapheme_is_lowercase(@ptrCast(str.ptr), str.len, null);
}

/// Checks if the null-terminated codepoint pointer `str` is lowercase.
///
/// For UTF-8-encoded input data `utf8.isLowercaseZ` can be used instead.
pub fn isLowercaseZ(str: [*:0]const u32) bool {
    return c.grapheme_is_lowercase(@ptrCast(str), c.SIZE_MAX, null);
}

/// Checks if the codepoint slice `str` is lowercase and also returns the
/// length of the matching lowercase sequence.
///
/// For UTF-8-encoded input data `utf8.isLowercaseLen` can be used instead.
/// For null-terminated codepoint pointers see `isLowercaseLenZ`.
pub fn isLowercaseLen(str: []const u32) struct {
    is_lowercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_lowercase = c.grapheme_is_lowercase(@ptrCast(str.ptr), str.len, &case_len);
    return .{
        .is_lowercase = is_lowercase,
        .case_len = case_len,
    };
}

/// Checks if the null-terminated codepoint pointer `str` is lowercase and
/// also returns the length of the matching lowercase sequence.
///
/// For UTF-8-encoded input data `utf8.isLowercaseLen` can be used instead.
pub fn isLowercaseLenZ(str: [*:0]const u32) struct {
    is_lowercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_lowercase = c.grapheme_is_lowercase(@ptrCast(str), c.SIZE_MAX, &case_len);
    return .{
        .is_lowercase = is_lowercase,
        .case_len = case_len,
    };
}

/// Converts the codepoint slice `str` to lowercase and writes the result to
/// `dest`. `dest.len` need not be greater than `src.len`. Returns the number
/// of codepoints in the slice resulting from converting `src` to lowercase,
/// even if `dest` is not large enough.
///
/// For UTF-8-encoded data `utf8.toLowercase` can be used instead.
/// For null-terminated codepoint pointers see `toLowercaseZ`.
pub fn toLowercase(src: []const u32, dest: []u32) usize {
    return c.grapheme_to_lowercase(@ptrCast(src.ptr), src.len, @ptrCast(dest.ptr), dest.len);
}

/// Returns the number of codepoints required to convert `src` to lowercase.
pub fn toLowercaseLen(src: []const u32) usize {
    return c.grapheme_to_lowercase(@ptrCast(src.ptr), src.len, null, 0);
}

/// Converts the codepoint slice `str` to lowercase and writes the result to
/// `dest`. `dest.len` need not be greater than `src.len`.
///
/// For UTF-8-encoded data `utf8.toLowercase` can be used instead.
pub fn toLowercaseZ(src: [*:0]const u32, dest: []u32) usize {
    return c.grapheme_to_lowercase(@ptr(src), c.SIZE_MAX, @ptrCast(dest.ptr), dest.len);
}

/// Returns the number of codepoints required to convert `src` to lowercase.
pub fn toLowercaseLenZ(src: [*:0]const u32) usize {
    return c.grapheme_to_lowercase(@ptrCast(ptr), c.SIZE_MAX, null, 0);
}
