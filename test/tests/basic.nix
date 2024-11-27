{
    pkgs ? import <nixpkgs> {},
    task-lib ? import ../../lib.nix { inherit pkgs; },
    test-lib ? import ../test-lib.nix { inherit pkgs; }
}:
let
    tasks = test-lib.defaultTasks;
    test = cmd: expected: test-lib.runWithTasksExpectFiles tasks cmd expected;
in
[

    (test "task1" {
        "output.txt" = ''
            task1
        '';
    })

    (test "task3;task1" {
        "output.txt" = ''
            task3
            task1
        '';
    })

    (test "seq1" {
        "output.txt" = ''
            task1
            task2
            task3
        '';
    })
]
