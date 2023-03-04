const std = @import("std");
const c = @import("c.zig");
const sdl = @import("sdl.zig");
const SuperBoard = @import("SuperBoard.zig");
const View = @import("View.zig");

pub fn main() void {
    // Using a separate `run()` function avoids two issues:
    //
    // * By default, if the main function returns an error, the Zig runtime prints the
    //   error name as it appears in source code, which is not user-friendly. This pattern
    //   catches the error and exits the program with a status code of 1 instead, so the
    //   run() function can print a nicer error message before exiting.
    //
    // * If we put deferred cleanup in the main function, as in the code
    //   example below, it might not be called if an error occurs. By moving all the
    //   interesting code into a separate `run()` function, we ensure that cleanup is
    //   always executed, even if an error occurs.
    //
    //   fn main() !void {
    //       const x = init_something();
    //       defer x.deinit();
    //       something_that_could_fail() catch {
    //           std.process.exit(1);
    //       }
    //       // ...
    //   }
    //
    //   In this example, `x.deinit()` would not be called if `something_that_could_fail()`
    //   fails.
    run() catch std.process.exit(1);
}

pub const window_width = 640 * 2;
pub const window_height = 480 * 2;

fn run() !void {
    try sdl.check_code(c.SDL_Init(c.SDL_INIT_VIDEO));
    defer c.SDL_Quit();

    const window = try sdl.check_ptr(c.SDL_CreateWindow(
        "Hello, World!",
        c.SDL_WINDOWPOS_UNDEFINED,
        c.SDL_WINDOWPOS_UNDEFINED,
        window_width,
        window_height,
        c.SDL_WINDOW_SHOWN,
    ));
    defer c.SDL_DestroyWindow(window);

    const renderer = try sdl.check_ptr(c.SDL_CreateRenderer(
        window,
        -1,
        c.SDL_RENDERER_PRESENTVSYNC,
    ));
    defer c.SDL_DestroyRenderer(renderer);

    const texture = try sdl.check_ptr(c.SDL_CreateTexture(
        renderer,
        c.SDL_PIXELFORMAT_ARGB8888,
        c.SDL_TEXTUREACCESS_STREAMING,
        window_width,
        window_height,
    ));
    defer c.SDL_DestroyTexture(texture);

    var play_board = SuperBoard{};
    std.debug.print("{any}\n", .{play_board});
    var view = View.init(&play_board);

    mainLoop: while (true) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                c.SDL_QUIT => break :mainLoop,
                else => {},
            }
        }

        try sdl.check_code(c.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255));
        try sdl.check_code(c.SDL_RenderClear(renderer));
        try renderToTexture(texture, &view);
        try sdl.check_code(c.SDL_RenderCopy(renderer, texture, null, null));
        c.SDL_RenderPresent(renderer);
    }
}

fn renderToTexture(texture: *c.SDL_Texture, view: *View) !void {
    var pixels: ?*anyopaque = undefined;
    var pitch: c_int = undefined;
    try sdl.check_code(c.SDL_LockTexture(texture, null, &pixels, &pitch));
    defer c.SDL_UnlockTexture(texture);

    const surface = c.cairo_image_surface_create_for_data(
        @ptrCast([*c]u8, pixels),
        c.CAIRO_FORMAT_ARGB32,
        window_width,
        window_height,
        pitch,
    );
    defer c.cairo_surface_destroy(surface);
    const cr = c.cairo_create(surface).?;
    defer c.cairo_destroy(cr);

    c.cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
    c.cairo_paint(cr);

    try view.render(cr);

    const font_name = "Sans Bold 100";
    const layout = c.pango_cairo_create_layout(cr);
    defer c.g_object_unref(layout);
    c.pango_layout_set_text(layout, "Hello, World!", -1);
    const desc = c.pango_font_description_from_string(font_name);
    c.pango_layout_set_font_description(layout, desc);
    c.pango_font_description_free(desc);

    c.cairo_set_source_rgb(cr, 0.0, 0.0, 0.0);
    c.cairo_move_to(cr, 10.0, 10.0);
    c.pango_cairo_update_layout(cr, layout);
    c.pango_cairo_show_layout(cr, layout);
}
