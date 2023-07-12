# libgrapheme-zig

Requires Zig master.

Zig bindings for [libgrapheme](https://libs.suckless.org/libgrapheme/), packaged
via the Zig package manager.
Provides wrappers for all libgrapheme functions as well as iterator types.

This library is not tested. It should download and compile without error, however.

## Usage

You can use this library via the Zig package manager. In your build.zig.zon:

```zig
.{
  // ...
  .dependencies = .{
    .libgrapheme = .{
      .url = "https://github.com/efjimm/libgrapheme-zig/archive/master.tar.gz",
      // .hash = ...
    }
  },
}
```

Compiling with this will give an error with the necessary .hash field to add.
If you later get a 'bad hash' error, it's because this library was updated and
the hash for the most recent commit no longer matches. You can find the new
hash value the same way (by removing the hash field and reading the compile
error). You can alternatively pin to a specific commit by replacing `master`
in the URL with the full hash of a commit.

In your build.zig, add:

```zig
//...

const g = b.dependency("libgrapheme_zig", .{
  .target = target,
  .optimize = optimize,
  .shared = false, // optional parameter, can be excluded
});

// Compiles and links the libgrapheme C library statically
exe.linkLibrary(g.artifact("grapheme"));
// Adds the "grapheme" module so you can @import("grapheme") in your code
exe.addModule("grapheme", g.module("grapheme"));

//...
```
