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
    return c.grapheme_next_character_break(str.ptr, str.len);
}

/// Returns the offset (in codepoints) to the next possible line break in the
/// codepoint slice `str`.
///
/// For UTF-8-encoded input data `utf8.nextLineBreak` can be used instead.
pub fn nextLineBreak(str: []const u32) usize {
    return c.grapheme_next_line_break(str.ptr, str.len);
}

/// Returns the offset (in codepoints) to the next sentence break in the
/// codepoint slice `str`. If a sentence begins at `str` this offset is equal
/// to the length of said sentence.
///
/// For UTF-8-encoded input data `utf8.nextSentenceBreak` can be used instead
pub fn nextSentenceBreak(str: []const u32) usize {
    return c.grapheme_next_sentence_break(str.ptr, str.len);
}

/// Returns the offset (in codepoints) to the next word break in the codepoint
/// slice `str`. If a word begins at `str` this offset is equal to the length
/// of said word.
///
/// For UTF-8-encoded input data `utf8.nextWordBreak` can be used instead.
pub fn nextWordBreak(str: []const u32) usize {
    return c.grapheme_next_word_break(str.ptr, str.len);
}

/// Returns the offset (in codepoints) to the next grapheme_cluster break in
/// the null-terminated codepoint pointer `str`. If a grapheme cluster begins
/// at `str` this offset is equal to the length of said grapheme cluster.
///
/// For UTF-8-encoded input data `utf8.nextCharacterBreakZ` can be used
/// instead.
pub fn nextCharacterBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_character_break(str, c.SIZE_MAX);
}

/// Returns the offset (in codepoints) to the next possible line break in the
/// null-terminated codepoint pointer `str`.
///
/// For UTF-8-encoded input data `utf8.nextLineBreakZ` can be used instead.
pub fn nextLineBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_line_break(str, c.SIZE_MAX);
}

/// Returns the offset (in codepoints) to the next sentence break in the
/// null-terminated codepoint pointer `str`. If a sentence begins at `str` this
/// offset is equal to the length of said sentence.
///
/// For UTF-8-encoded input data `utf8.nextSentenceBreakZ` can be used instead
pub fn nextSentenceBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_sentence_break(str, c.SIZE_MAX);
}

/// Returns the offset (in codepoints) to the next word break in the
/// null-terminated codepoint pointer `str`. If a word begins at `str` this
/// offset is equal to the length of said word.
///
/// For UTF-8-encoded input data `utf8.nextWordBreakZ` can be used instead.
pub fn nextWordBreakZ(str: [*:0]const u32) usize {
    return c.grapheme_next_word_break(str, c.SIZE_MAX);
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
    return c.grapheme_is_lowercase(str.ptr, str.len, null);
}

/// Checks if the null-terminated codepoint pointer `str` is lowercase.
///
/// For UTF-8-encoded input data `utf8.isLowercaseZ` can be used instead.
pub fn isLowercaseZ(str: [*:0]const u32) bool {
    return c.grapheme_is_lowercase(str, c.SIZE_MAX, null);
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
    const is_lowercase = c.grapheme_is_lowercase(str.ptr, str.len, &case_len);
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
    const is_lowercase = c.grapheme_is_lowercase(str, c.SIZE_MAX, &case_len);
    return .{
        .is_lowercase = is_lowercase,
        .case_len = case_len,
    };
}

/// Converts the codepoint slice `str` to lowercase and writes the result to
/// `dest`. `dest.len` need not be greater than `str.len`. Returns the number
/// of codepoints in the slice resulting from converting `str` to lowercase,
/// even if `dest` is not large enough.
///
/// For UTF-8-encoded data `utf8.toLowercase` can be used instead.
/// For null-terminated codepoint pointers see `toLowercaseZ`.
pub fn toLowercase(str: []const u32, dest: []u32) usize {
    return c.grapheme_to_lowercase(str.ptr, str.len, dest.ptr, dest.len);
}

/// Converts the codepoint slice `str` to lowercase and writes the result to
/// `dest`. `dest.len` need not be greater than `str.len`.
///
/// For UTF-8-encoded data `utf8.toLowercase` can be used instead.
pub fn toLowercaseZ(str: [*:0]const u32, dest: []u32) usize {
    return c.grapheme_to_lowercase(str, c.SIZE_MAX, dest.ptr, dest.len);
}

/// Check if the codepoint slice `str` is uppercase.
///
/// For UTF-8-encoded input data `utf8.isUppercase` can be used instead.
/// For null-terminated codepoint pointers whose length is not known, use
/// `isUppercaseZ`.
pub fn isUppercase(str: []const u32) bool {
    return c.grapheme_is_uppercase(str.ptr, str.len, null);
}

/// Check if the null-terminated codepoint pointer `str` is uppercase.
///
/// For UTF-8-encoded input data `utf8.isUppercaseZ` can be used instead.
pub fn isUppercaseZ(str: [*:0]const u32) bool {
    return c.grapheme_is_uppercase(str, c.SIZE_MAX, null);
}

/// Check if the codepoint slice `str` is uppercase and returns the length of
/// the matching uppercase sequence.
///
/// For UTF-8-encoded data `utf8.isUppercase` can be used instead.
/// For null-terminated codepoint pointers whose length is not known, use
/// `isUppercaseLenZ`.
pub fn isUppercaseLen(str: []const u32) struct {
    is_uppercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_uppercase = c.grapheme_is_uppercase(str.ptr, str.len, &case_len);
    return .{
        .is_uppercase = is_uppercase,
        .case_len = case_len,
    };
}

/// Check if the null-terminated codepoint pointer `str` is uppercase and
/// returns the length of the matching uppercase sequence.
///
/// For UTF-8-encoded data `utf8.isUppercaseZ` can be used instead.
pub fn isUppercaseLenZ(str: [*:0]const u32) struct {
    is_uppercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_uppercase = c.grapheme_is_uppercase(str, c.SIZE_MAX, &case_len);
    return .{
        .is_uppercase = is_uppercase,
        .case_len = case_len,
    };
}

/// Converts the codepoint slice `src` to uppercase and writes the result to
/// `dest`. `dest.len` need not be greater than `src.len`.
///
/// For UTF-8-encoded input data `utf8.toUppercase` can be used instead.
/// For null-terminated codepoint pointers whose length is not known, use
/// `toUppercaseZ`.
pub fn toUppercase(src: []const u32, dest: []u32) usize {
    return c.grapheme_to_uppercase(src.ptr, src.len, dest.ptr, dest.len);
}

/// Converts the null-terminated codepoint pointer `src` to uppercase and
/// writes the result to `dest`. `dest.len` need not be greater than `src.len`.
///
/// For UTF-8-encoded input data `utf8.toUppercase` can be used instead.
pub fn toUppercaseZ(src: [*:0]const u32, dest: []u32) usize {
    return c.grapheme_to_uppercase(src, c.SIZE_MAX, dest.ptr, dest.len);
}

/// Checks if the codepoint slice `str` is titlecase.
///
// For UTF-8-encoded input data use `utf8.isTitlecase` instead.
/// For null-terminated codepoint pointers whose length is not known, use
/// `isTitlecaseZ`.
pub fn isTitlecase(str: []const u32) bool {
    return c.grapheme_is_titlecase(str.ptr, str.len, null);
}

/// Checks if the null-terminated codepoint pointer `str` is titlecase.
///
// For UTF-8-encoded input data use `utf8.isTitlecase` instead.
pub fn isTitleCaseZ(str: [*:0]const u32) bool {
    return c.grapheme_is_titlecase(str, c.SIZE_MAX, null);
}

/// Check if the codepoint slice `str` is titlecase and returns the length of
/// the matching titlecase sequence.
///
/// For UTF-8-encoded data `utf8.isTitlecase` can be used instead.
/// For null-terminated codepoint pointers whose length is not known, use
/// `isTitlecaseLenZ`.
pub fn isTitlecaseLen(str: []const u32) struct {
    is_titlecase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_titlecase = c.grapheme_is_titlecase(str.ptr, str.len, &case_len);
    return .{
        .is_titlecase = is_titlecase,
        .case_len = case_len,
    };
}

/// Check if the codepoint slice `str` is titlecase and returns the length of
/// the matching titlecase sequence.
///
/// For UTF-8-encoded data `utf8.isTitlecase` can be used instead.
pub fn isTitlecaseLenZ(str: [*:0]const u32) struct {
    is_titlecase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_titlecase = c.grapheme_is_titlecase(str, c.SIZE_MAX, &case_len);
    return .{
        .is_titlecase = is_titlecase,
        .case_len = case_len,
    };
}

/// Converts the codepoint slice `src` to titlecase and writes the result to
/// `dest`. `dest.len` need not be greater than `src.len`.
///
/// For UTF-8-encoded input data `utf8.toTitlecase` can be used instead.
/// For null-terminated codepoint pointers whose length is not known, use
/// `toTitlecaseZ`.
pub fn toTitlecase(str: []const u32, dest: []u32) usize {
    return c.grapheme_to_titlecase(str.ptr, str.len, dest.ptr, dest.len);
}

/// Converts the null-terminated codepoint pointer `src` to titlecase and
/// writes the result to `dest`. `dest.len` need not be greater than `src.len`.
///
/// For UTF-8-encoded input data `utf8.toTitlecase` can be used instead.
pub fn toTitlecaseZ(str: [*:0]const u32, dest: []u32) usize {
    return c.grapheme_to_titlecase(str, c.SIZE_MAX, dest.ptr, dest.len);
}
