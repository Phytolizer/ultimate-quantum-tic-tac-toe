const std = @import("std");
const g = @import("global.zig");

pub const SuperBoard = struct {
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
    };
};
