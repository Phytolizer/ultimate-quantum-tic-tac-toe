const std = @import("std");
const SuperBoard = @import("SuperBoard.zig");
const c = @import("c.zig");
const root = @import("root");

board: *SuperBoard,
which: ?*SuperBoard.Board = null,

pub fn init(board: *SuperBoard) @This() {
    return .{
        .board = board,
    };
}

pub fn render(self: *@This(), cr: *c.cairo_t) !void {
    if (self.which) |subboard| {
        try subboard.render(cr);
    } else {
        c.cairo_rectangle(cr, 0, 0, root.window_width, root.window_height);
        c.cairo_set_source_rgb(cr, 0.0, 1.0, 1.0);
        c.cairo_paint(cr);
    }
}
