rec {
    description = "Full demo of task-gen library";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        task-gen.url = "github:BalderHolst/task-gen.nix";
    };

    outputs = { nixpkgs, flake-utils, task-gen, ... }:
    flake-utils.lib.eachDefaultSystem (system:
        let
            task-lib = task-gen.lib."${system}";
            tasks = import ./tasks.nix { inherit task-lib; };
            pkgs = import nixpkgs { inherit system; };
        in
        {

            apps = {
                gen-scripts = with task-lib; mkGenScriptsApp {
                    # A list of files to generate
                    "Makefile" = mkMakefile tasks;
                    "say-hello.sh" = mkScript tasks.rainbow-hello;
                    ".hooks/pre-push" = mkScript (mkSeq "pre-push" [
                        tasks.rainbow-hello
                        tasks.rainbow-morning
                    ]);

                };
            };

            devShell = with pkgs; mkShell {
                buildInputs = [
                    cowsay
                    lolcat
                ] ++ (task-lib.mkScripts tasks);

                shellHook = ''
                    echo -e "${description}\n"
                '' + task-lib.mkShellHook tasks;
            };

    });
}
