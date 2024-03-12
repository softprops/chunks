const std = @import("std");
const testing = std.testing;

/// Returns a type that represents an iterator over chunks of a give size
///
/// If data.len is not evenly divisible by the chunk size the last chunk will be
/// less than the requested size
pub fn Chunks(comptime A: type, comptime size: usize) type {
    return struct {
        data: []const A,
        i: usize = 0,
        /// create a new instance of this type with a slice of data
        fn init(data: []const A) @This() {
            return .{ .data = data };
        }
        /// implements the interator pattern. Each time `next` is called
        /// we iterate through a chunk of data
        pub fn next(it: *@This()) ?[]const A {
            if (it.i == it.data.len) {
                return null;
            }
            const prev = it.i;
            it.i = @min(it.i + size, it.data.len);
            return it.data[prev..it.i];
        }
    };
}

test "iteration" {
    var chunks = Chunks(u8, 3).init(&([_]u8{ 1, 2, 3, 4, 5, 6, 7, 8 }));
    try testing.expectEqualSlices(u8, &([_]u8{ 1, 2, 3 }), chunks.next().?);
    try testing.expectEqualSlices(u8, &([_]u8{ 4, 5, 6 }), chunks.next().?);
    try testing.expectEqualSlices(u8, &([_]u8{ 7, 8 }), chunks.next().?);
    try testing.expect(chunks.next() == null);
}
