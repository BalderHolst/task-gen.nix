{
    pkgs ? import <nixpkgs> {},
    task-lib ? import ../lib.nix { inherit pkgs; },
}:
let
    lib = pkgs.lib;
in
rec {

    defaultTasks = with task-lib; rec {
        task1 = mkTask "task1" { script = "echo 'task1' >> output.txt"; };
        task2 = mkTask "task2" { script = "echo 'task2' >> output.txt"; };
        task3 = mkTask "task3" { script = "echo 'task3' >> output.txt"; };
        seq1 = mkSeq "seq1" [ task1 task2 task3 ];
    };

    runWithTasks = tasks: script: pkgs.stdenv.mkDerivation {
        name = "runWithTasks";
        buildInputs = task-lib.mkScripts tasks;

        phases = [ "installPhase" ];

        installPhase = ''
            mkdir -p $out
            cd $out
            ${script}
        '';
    };

    diffText = expected: found:
        ''

        ------- Expected --------
        ${expected}
        ---------- Got ----------
        ${found}
        '';

    assertText = expected: found: lib.assertMsg
        (expected == found)
        (diffText expected found);

    assertFileExists = path: lib.assertMsg
        (builtins.pathExists path) "File '${path}' does not exist.";

    assertFileWithContents = path: expected:
    let
        found = builtins.readFile path;
    in
    lib.assertMsg
        (found == expected)
        ''
        File '${path}' does not contain expected contents:
        ${diffText expected found}
        '';

    # Takes a set of expected file paths and their contents
    runWithTasksExpectFiles = tasks: script: expectedFiles: let 
            derivation = runWithTasks tasks script;
        in
        builtins.all (x: x) (lib.attrsets.mapAttrsToList (path: expected:
            assertFileWithContents "${derivation}/${path}" expected
        ) expectedFiles);
}

