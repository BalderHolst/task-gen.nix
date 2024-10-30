{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        task-lib.url = "git+file://../..";
    };

    outputs = { self, nixpkgs, flake-utils, task-lib, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
    task-gen = task-lib.lib."${system}";
    tasks = import ./tasks.nix { inherit task-gen; };
    pkgs = import nixpkgs { inherit system; };
    in
    {
        devShell = with pkgs; mkShell {
            buildInputs = [
                cowsay
                lolcat
                (task-gen.mkHelpScriptBin tasks)
            ] ++ (task-gen.mkScripts tasks);
        };

    });
}
