{ pkgs, lib }:
let

    script-msg = ''
        # This script was generated by Nix.
        # To make changes edit the `tasks.nix` file.

    '';

    help-task-name = "task-help";

    taskScriptString = task: level: ''
        echo "${ lib.strings.replicate level "--" }->> Running '${task.name}'"
        # Dependencies for ${task.name}
        ${builtins.concatStringsSep "\n" (map (j: taskScriptString j (level+1)) task.depends)}
        # Run ${task.name} task
        ${task.script}
    '';

    tab-indent = s: (if s == "" then "" else "\t") + (builtins.concatStringsSep "\n\t" (
        builtins.filter (e: builtins.typeOf e != "list") (builtins.split "\n" s)
    ));

    _mkScript = write_script: task: write_script task.name (script-msg + (taskScriptString task 0));

    _mkHelpScript = write_script: tasks:
    let
        task_names = if builtins.typeOf tasks == "list" then tasks else builtins.attrValues tasks;
    in
    write_script "${help-task-name}" ''
        echo "Available Tasks:"
        ${ builtins.concatStringsSep "\n" (map (j:  "echo -e '\t${j.name}'") task_names) }

        # Only print if `${help-task-name}` is in current PATH
        which ${help-task-name} 2>&1 > /dev/null && echo -e "\nUse '${help-task-name}' command to show this list."
    '';

in
rec {

    mkTask = name: { script ? "", depends ? [], }: {
        name = name;
        script = script;
        depends = depends;
    };

    mkSeq = name: seq: mkTask name { depends = seq; };

    mkScriptBin = _mkScript pkgs.writeShellScriptBin;
    mkScript    = _mkScript pkgs.writeShellScript;

    mkHelpScript    = _mkHelpScript pkgs.writeShellScript;
    mkHelpScriptBin = _mkHelpScript pkgs.writeShellScriptBin;

    mkScripts = tasks: (lib.attrsets.mapAttrsToList (_: j: mkScriptBin j) tasks) ++ [(mkHelpScriptBin tasks)];

    mkMakefile = tasks: let
        task_list = if builtins.typeOf tasks == "list" then tasks else builtins.attrValues tasks;
    in
    pkgs.writeText "Makefile" (''
        # This Makefile was generated by Nix.
        # To make changes edit the `tasks.nix` file.

        main: ${help-task-name}

        all: ${ builtins.concatStringsSep " " (map (j: "${j.name}") task_list) }

        ${help-task-name}:
        ${ tab-indent /*bash*/ ''
            @echo "usage: make <task>"
            @echo ""
            @echo "Available Tasks:"
            ${ (builtins.concatStringsSep "\n" (map (j:  "@echo -e '\t${j.name}'") task_list)) }
            @echo -e "\nUse 'make ${help-task-name}' command to show this list."
        ''}

    '' +
        (builtins.concatStringsSep "\n\n" (map (task: ''
            ${task.name}: ${ builtins.concatStringsSep " " (map (j: "${j.name}") task.depends) }
            ${
                if task.script == "" then "" else "\t"
            }${
                builtins.concatStringsSep "\n\t" (
                    builtins.filter (e: builtins.typeOf e != "list") (builtins.split "\n" task.script)
                )}
        '') task_list))
    );

    mkShellHook = tasks: /*bash*/ ''
        ${mkHelpScript tasks}
    '';

    mkGenScriptsApp = task-files: {
        type = "app";
        program = let
            parts = lib.attrsets.mapAttrsToList (path: script: /*bash*/ ''
                echo "Generating ${path}..."

                # Create directory if it doesn't exist
                mkdir -p $(dirname ${path})

                # Copy script to destination
                cp -f ${script} ${path} || {
                    echo "Failed to generate ${path}."
                    exit 1
                }

            '') task-files;
            script = builtins.concatStringsSep "\n" parts;
        in
        toString (pkgs.writeShellScript "gen-scripts" /*bash*/ ''
            ${if builtins.length parts == 0 then "echo 'No scripts to generate.'; exit 0" else script}
            echo 'Done.'
        '');
    };

    # TODO: This assumes execution from the root of the project
    mkGenScriptsTask = name: mkTask "generate-scripts" { script = "nix run .#${name}"; };

}
