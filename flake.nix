{
    description = "A task library for Nix";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        flake-utils.url = "github:numtide/flake-utils";
        txtx = {
            url = "github:BalderHolst/txtx";
            inputs.flake-utils.follows = "flake-utils";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
    let
        task-lib = import ./lib.nix {pkgs = pkgs; };
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.txtx.overlays."${system}".default ];
        };
        tasks = import ./tasks.nix { inherit task-lib; };
    in
    {
        lib = task-lib;

        apps.gen-scripts = with task-lib; mkGenScriptsApp {
            ".hooks/pre-push" = mkScript pre-push;
        };

        devShells = {
            default = pkgs.mkShell {
                buildInputs = with pkgs; [
                    txtx
                    python3
                ] ++ (task-lib.mkScripts tasks);
            };

            shellHook = ''
                git config core.hooksPath .hooks

                echo -e "Welcome to the task library dev shell!\n"
            '' + task-lib.mkShellHook tasks;
        };
    });
}
