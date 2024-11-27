{
    pkgs ? import <nixpkgs> {},
    task-lib ? import ../lib.nix { inherit pkgs; },
    test-lib ? import ./test-lib.nix { inherit pkgs; }
}:
let

    # Define the tasks
    tasks = with task-lib; rec {
        task1 = mkTask "task1" { script = "echo 'task1' >> output.txt"; };
        task2 = mkTask "task2" { script = "echo 'task2' >> output.txt"; };
        task3 = mkTask "task3" { script = "echo 'task3' >> output.txt"; };
        seq1 = mkSeq "seq1" [ task1 task2 task3 ];
    };


in
test-lib.runWithTasksExpectFiles tasks "seq1" {
    "output.txt" = ''
        task1
        task2
        task3
        '';
}
