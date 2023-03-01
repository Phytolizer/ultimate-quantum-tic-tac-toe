const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("ultimate-quantum-tic-tac-toe", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();
    exe.linkLibC();
    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("cairo");
    exe.linkSystemLibrary("pangocairo");
    exe.linkSystemLibrary("pthread");

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    run_cmd.expected_exit_code = null;

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
