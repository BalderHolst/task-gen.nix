rec {
    description = "Minimal example of task-gen library";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        task-gen.url = "github:BalderHolst/task-gen.nix";
    };

    outputs = { nixpkgs, flake-utils, task-gen, ... }:
    flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = import nixpkgs { inherit system; };

            # Import the task-gen library
            task-lib = task-gen.lib."${system}";

            # Define project tasks
            tasks = with task-lib; {

                first-task = mkTask "first-task" {
                    script = /*bash*/ ''
                        echo "Hello! This is first task!"
                    '';
                };

                second-task = mkTask "second-task" {
                    script = /*bash*/ ''
                        echo "Hi! This is SECOND task!"
                    '';
                };

                # Create a tasks that runs other tasks in sequence
                run-in-sequence = mkSeq "run-in-sequence" [
                    tasks.first-task
                    tasks.second-task
                ];

            };
        in
        {

            devShell = with pkgs; mkShell {
                buildInputs = [

                    # Put your own dependencies here...

                ] ++ (task-lib.mkScripts tasks);

                shellHook = ''
                    echo -e "${description}\n"
                '' + task-lib.mkShellHook tasks;
            };

    });
}
