# zig-grapheme

Requires Zig master.

Zig bindings for [libgrapheme](https://libs.suckless.org/libgrapheme/), packaged
via the Zig package manager.
Provides wrappers for all libgrapheme functions as well as iterator types.

This library is not tested. It should download and compile without error, however.

## Installing

You can use this library via the Zig package manager. In your build.zig.zon:

```zig
.{
  .dependencies = .{
    .zig_grapheme = .{
      .url = "https://github.com/efjimm/zig-grapheme/archive/master.tar.gz",
      // .hash = ...
    }
  },
}
```

Compiling with this will give an error with the necessary .hash field to add.
If you later get a 'bad hash' error, it's because this library was updated and
the hash for the most recent commit no longer matches. You can find the new hash
value the same way (by removing the hash field and reading the compile error).
You can alternatively pin to a specific commit by replacing `master` in the URL
with the full hash of a commit.

In your build.zig, add:

```zig
const g = b.dependency("zig_grapheme", .{
  .target = target,
  .optimize = optimize,

  // Whether to build libgrapheme as a shared library (default: false, can be excluded)
  .shared = false,
});

// Compiles and links the libgrapheme C library
exe.linkLibrary(g.artifact("grapheme"));
// Adds the "grapheme" module so you can @import("grapheme") in your code
exe.addModule("grapheme", g.module("grapheme"));
```

## Usage

The only exposed module is named "grapheme". It has two namespaces: `codepoint`
and `utf8`. The `codepoint` namespace provides utility functions for working with
raw codepoints, and the utf8 namespace provides functions for utf8 slices and
null-terminated pointers.

The functions provided by this library all have a doc comment explaining their
usage. For a little more detailed overview of all libgrapheme functions, see
the libgrapheme manpages.

### Codepoints

Note that codepoints are *not* `u21` in this library, due to how libgrapheme
works. libgrapheme uses `uint_least32_t` for codepoints, which the C99
standard allows to be any size >= 32 bits. On most (practically all) platforms
this is going to be a `u32`. This library provides an alias to this type as
`codepoint.Codepoint`. If you want to pass `u21` slices to this library you
have to either manually convert the slice to a `Codepoint` slice, or you can
alternatively do two things:

1. Ensure that `@sizeOf(grapheme.codepoint.Codepoint) == @sizeOf(u21)`
2. Ensure that any padding bits for each `u21` are zeroed

Number 2 is due to the fact that the byte size of integers is rounded up to
the next or equal power of two. If these two conditions are met then you can
use `u21` slices by casting them to `u32` slices before passing them to this
library.
