const std = @import("std");
const g = @import("global.zig");
const c = @import("c.zig");

subs: [9]Board = [_]Board{.{}} ** 9,

pub const Board = struct {
    state: [9]State = [_]State{.{
        .entangled = std.ArrayList(Play).init(g.allocator),
    }} ** 9,

    pub const State = union(enum) {
        /// any number of plays, not collapsed
        entangled: std.ArrayList(Play),
        /// final state, collapsed
        collapsed: Play,
    };

    pub const Play = struct {
        player: Player,
        move_num: usize,

        pub const Player = enum {
            x,
            o,
        };
    };

    pub fn render(self: *@This(), cr: *c.cairo_t) !void {
        // [TODO] render small board over entire window
        _ = self;
        _ = cr;
    }
};
