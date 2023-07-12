const std = @import("std");
const c = @cImport({
    @cInclude("grapheme.h");
});
const codepoint = @import("codepoint.zig");

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

/// Checks if the UTF-8-encoded string `str` is lowercase.
///
/// For non-UTF-8 input data `codepoint.isLowercase` can be used instead.
/// For null-terminated pointers whose length is not known, use `isLowercaseZ`.
pub fn isLowercase(str: []const u8) bool {
    return c.grapheme_is_lowercase_utf8(str.ptr, str.len, null);
}

/// Checks if the null-terminated, UTF-8-encoded pointer `str` is lowercase.
///
/// For non-UTF-8 input data `codepoint.isLowercase` can be used instead.
pub fn isLowercaseZ(str: [*:0]const u8) bool {
    return c.grapheme_is_lowercase_utf8(str, c.SIZE_MAX, null);
}

/// Checks if the UTF-8-encoded string `str` is lowercase and returns the
/// length of the matching lowercase sequence.
///
/// For non-UTF-8 input data `codepoint.isLowercaseLen` can be used instead.
/// For null-terminated pointers whose length is not known, use
/// `isLowercaselenZ`.
pub fn isLowercaseLen(str: []const u8) struct {
    is_lowercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_lowercase = c.grapheme_is_lowercase_utf8(str.ptr, str.len, &case_len);
    return .{
        .is_lowercase = is_lowercase,
        .case_len = case_len,
    };
}

/// Checks if the null-terminated, UTF-8-encoded pointer `str` is lowercase
/// and returns the length of the matching lowercase sequence.
///
/// For non-UTF-8 input data `codepoint.isLowercaseLenZ` can be used instead.
pub fn isLowercaseLenZ(str: [*:0]const u8) struct {
    is_lowercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_lowercase = c.grapheme_is_lowercase_utf8(str, c.SIZE_MAX, &case_len);
    return .{
        .is_lowercase = is_lowercase,
        .case_len = case_len,
    };
}

/// Converts the UTF-8-encoded string `str` to lowercase and writes the result
/// to `dest`. Returns the number of bytes in the array resulting from
/// converting `src` to lowercase, even if `dest` is not large enough.
///
/// For non-UTF-8 input data `codepoint.toLowercase` can be used instead.
/// For null-terminated pointers whose length is not known, use `toLowercaseZ`.
pub fn toLowercase(str: []const u8, dest: []u8) usize {
    return c.grapheme_to_lowercase_utf8(str.ptr, str.len, dest.ptr, dest.len);
}

/// Converts the null-terminated, UTF-8-encoded string `str` to lowercase and
/// writes the result to `dest`. Returns the number of bytes in the array
/// resulting from converting `src` to lowercase, even if `dest` is not large
/// enough.
///
/// For non-UTF-8 input data `codepoint.toLowercaseZ` can be used instead.
pub fn toLowercaseZ(str: [*:0]const u8, dest: []u8) usize {
    return c.grapheme_to_lowercase_utf8(str, c.SIZE_MAX, dest.ptr, dest.len);
}

/// Checks if the UTF-8-encoded string `str` is uppercase.
///
/// For non-UTF-8 input data `codepoint.isUppercase` can be used instead.
/// For null-terminated pointers whose length is not known, use `isUppercaseZ`.
pub fn isUppercase(str: []const u8) bool {
    return c.grapheme_is_uppercase_utf8(str.ptr, str.len, null);
}

/// Checks if the null-terminated, UTF-8-encoded pointer `str` is uppercase.
///
/// For non-UTF-8 input data `codepoint.isUppercase` can be used instead.
pub fn isUppercaseZ(str: [*:0]const u8) bool {
    return c.grapheme_is_uppercase_utf8(str, c.SIZE_MAX, null);
}

/// Checks if the UTF-8-encoded string `str` is uppercase and returns the
/// length of the matching uppercase sequence.
///
/// For non-UTF-8 input data `codepoint.isUppercaseLen` can be used instead.
/// For null-terminated pointers whose length is not known, use
/// `isUppercaselenZ`.
pub fn isUppercaseLen(str: []const u8) struct {
    is_uppercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_uppercase = c.grapheme_is_uppercase_utf8(str.ptr, str.len, &case_len);
    return .{
        .is_uppercase = is_uppercase,
        .case_len = case_len,
    };
}

/// Checks if the null-terminated, UTF-8-encoded pointer `str` is uppercase
/// and returns the length of the matching uppercase sequence.
///
/// For non-UTF-8 input data `codepoint.isUppercaseLenZ` can be used instead.
pub fn isUppercaseLenZ(str: [*:0]const u8) struct {
    is_uppercase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_uppercase = c.grapheme_is_uppercase_utf8(str, c.SIZE_MAX, &case_len);
    return .{
        .is_uppercase = is_uppercase,
        .case_len = case_len,
    };
}

/// Converts the UTF-8-encoded string `str` to uppercase and writes the result
/// to `dest`. Returns the number of bytes in the array resulting from
/// converting `src` to uppercase, even if `dest` is not large enough.
///
/// For non-UTF-8 input data `codepoint.toUppercase` can be used instead.
/// For null-terminated pointers whose length is not known, use `toUppercaseZ`.
pub fn toUppercase(str: []const u8, dest: []u8) usize {
    return c.grapheme_to_uppercase_utf8(str.ptr, str.len, dest.ptr, dest.len);
}

/// Converts the null-terminated, UTF-8-encoded string `str` to uppercase and
/// writes the result to `dest`. Returns the number of bytes in the array
/// resulting from converting `src` to uppercase, even if `dest` is not large
/// enough.
///
/// For non-UTF-8 input data `codepoint.toUppercaseZ` can be used instead.
pub fn toUppercaseZ(str: [*:0]const u8, dest: []u8) usize {
    return c.grapheme_to_uppercase_utf8(str, c.SIZE_MAX, dest.ptr, dest.len);
}

/// Checks if the UTF-8-encoded string `str` is titlecase.
///
/// For non-UTF-8 input data `codepoint.isTitlecase` can be used instead.
/// For null-terminated pointers whose length is not known, use `isTitlecaseZ`.
pub fn isTitlecase(str: []const u8) bool {
    return c.grapheme_is_titlecase_utf8(str.ptr, str.len, null);
}

/// Checks if the null-terminated, UTF-8-encoded pointer `str` is titlecase.
///
/// For non-UTF-8 input data `codepoint.isTitlecase` can be used instead.
pub fn isTitlecaseZ(str: [*:0]const u8) bool {
    return c.grapheme_is_titlecase_utf8(str, c.SIZE_MAX, null);
}

/// Checks if the UTF-8-encoded string `str` is titlecase and returns the
/// length of the matching titlecase sequence.
///
/// For non-UTF-8 input data `codepoint.isTitlecaseLen` can be used instead.
/// For null-terminated pointers whose length is not known, use
/// `isTitlecaselenZ`.
pub fn isTitlecaseLen(str: []const u8) struct {
    is_titlecase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_titlecase = c.grapheme_is_titlecase_utf8(str.ptr, str.len, &case_len);
    return .{
        .is_titlecase = is_titlecase,
        .case_len = case_len,
    };
}

/// Checks if the null-terminated, UTF-8-encoded pointer `str` is titlecase
/// and returns the length of the matching titlecase sequence.
///
/// For non-UTF-8 input data `codepoint.isTitlecaseLenZ` can be used instead.
pub fn isTitlecaseLenZ(str: [*:0]const u8) struct {
    is_titlecase: bool,
    case_len: usize,
} {
    var case_len: usize = undefined;
    const is_titlecase = c.grapheme_is_titlecase_utf8(str, c.SIZE_MAX, &case_len);
    return .{
        .is_titlecase = is_titlecase,
        .case_len = case_len,
    };
}

/// Converts the UTF-8-encoded string `str` to titlecase and writes the result
/// to `dest`. Returns the number of bytes in the array resulting from
/// converting `src` to titlecase, even if `dest` is not large enough.
///
/// For non-UTF-8 input data `codepoint.toTitlecase` can be used instead.
/// For null-terminated pointers whose length is not known, use `toTitlecaseZ`.
pub fn toTitlecase(str: []const u8, dest: []u8) usize {
    return c.grapheme_to_titlecase_utf8(str.ptr, str.len, dest.ptr, dest.len);
}

/// Converts the null-terminated, UTF-8-encoded string `str` to titlecase and
/// writes the result to `dest`. Returns the number of bytes in the array
/// resulting from converting `src` to titlecase, even if `dest` is not large
/// enough.
///
/// For non-UTF-8 input data `codepoint.toTitlecaseZ` can be used instead.
pub fn toTitlecaseZ(str: [*:0]const u8, dest: []u8) usize {
    return c.grapheme_to_titlecase_utf8(str, c.SIZE_MAX, dest.ptr, dest.len);
}
