{
    pkgs ? import <nixpkgs> {},
    task-lib ? import ../../lib.nix { inherit pkgs; },
    test-lib ? import ../test-lib.nix { inherit pkgs; }
}:
let

    tasks = test-lib.defaultTasks;

    script1 = task-lib.mkScript tasks.task1;
    script2 = task-lib.mkScript tasks.task2;
    binScript1 = task-lib.mkScriptBin tasks.task1;
    binScript2 = task-lib.mkScriptBin tasks.task2;

    help = task-lib.mkHelpScript tasks;
    binHelp = task-lib.mkHelpScriptBin tasks;

in
assert test-lib.assertFileExists script1;
assert test-lib.assertFileExists script2;
assert test-lib.assertFileExists help;
assert test-lib.assertFileExists "${binScript1}/bin/task1";
assert test-lib.assertFileExists "${binScript2}/bin/task2";
assert test-lib.assertFileExists "${binHelp}/bin/thelp";
true
