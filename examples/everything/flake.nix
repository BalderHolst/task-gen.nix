rec {
    description = "Full demo of task-lib library";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        task-lib.url = "github:BalderHolst/task-lib.nix";
    };

    outputs = { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
        let
            task-lib = inputs.task-lib.lib."${system}";
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
                    "task-scripts" = mkScriptDir tasks;
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
