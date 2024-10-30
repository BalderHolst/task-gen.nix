{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        task-lib.url = "git+file://../..";
    };

    outputs = { nixpkgs, flake-utils, task-lib, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
    task-gen = task-lib.lib."${system}";
    tasks = import ./tasks.nix { inherit task-gen; };
    pkgs = import nixpkgs { inherit system; };
    in
    {

        apps = {
            gen-scripts = task-gen.mkGenScriptsApp {

                # A list of files to generate
                "Makefile" = task-gen.mkMakefile tasks;
                "say-hello.sh" = task-gen.mkScript tasks.rainbow-hello;
                ".hooks/pre-push" = task-gen.mkScript (task-gen.mkSeq "pre-push" [
                    tasks.rainbow-hello
                    tasks.rainbow-morning
                ]);

            };
        };

        devShell = with pkgs; mkShell {
            buildInputs = [
                cowsay
                lolcat
            ] ++ (task-gen.mkScripts tasks);

            shellHook = ''
                echo -e "Welcome to the devShell!\n"
            '' + task-gen.mkShellHook tasks;
        };

    });
}
