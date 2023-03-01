const std = @import("std");
const c = @import("c.zig");

pub const Error = error{SDL};

pub inline fn check_code(code: i32) Error!void {
    if (code != 0) {
        const msg = std.mem.span(@ptrCast([*:0]const u8, c.SDL_GetError()));
        show_err(msg);
        return error.SDL;
    }
}

fn NotNull(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .Optional => |opt| opt.child,
        else => T,
    };
}

pub inline fn check_ptr(ptr: anytype) Error!NotNull(@TypeOf(ptr)) {
    if (ptr == null) {
        const msg = std.mem.span(@ptrCast([*:0]const u8, c.SDL_GetError()));
        show_err(msg);
        return error.SDL;
    }
    return ptr.?;
}

inline fn show_err(msg: []const u8) void {
    std.debug.print("SDL Error: {s}\n", .{msg});
}
