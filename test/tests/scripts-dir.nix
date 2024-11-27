{
    pkgs ? import <nixpkgs> {},
    task-lib ? import ../../lib.nix { inherit pkgs; },
    test-lib ? import ../test-lib.nix { inherit pkgs; }
}:
let

    tasks = with task-lib; {
        task1 = mkTask "task1-script" { script = "1"; };
        task2 = mkTask "task2-script" { script = "2"; };
    };

    derivation = task-lib.mkScriptDir tasks;

in
assert test-lib.assertFileExists "${derivation}/task1-script";
assert test-lib.assertFileExists "${derivation}/task2-script";
true
