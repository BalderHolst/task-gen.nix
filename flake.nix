{
    description = "A task library for Nix";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };
    in
    {
        lib = import ./lib.nix {pkgs = pkgs; };
    });
}
