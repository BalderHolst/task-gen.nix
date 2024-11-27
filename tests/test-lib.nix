{
    pkgs ? import <nixpkgs> {},
    task-lib ? import ../lib.nix { inherit pkgs; },
}:
let
    lib = pkgs.lib;
in
rec {
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

    # Takes a set of expected file paths and their contents
    runWithTasksExpectFiles = tasks: script: expectedFiles: let 
            derivation = runWithTasks tasks script;
        in
        builtins.all (x: x) (lib.attrsets.mapAttrsToList (path: expected: 
        let
            found = builtins.readFile "${derivation}/${path}";
        in
            lib.assertMsg
                (expected == found)
                ''
                File '${path}' does not contain expected contents:
                ------- Expected --------
                ${expected}
                ---------- Got ----------
                ${found}
                ''
        ) expectedFiles);
}

