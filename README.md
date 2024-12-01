# Nix Task Generator
A nix library for creating project tasks using nix. These tasks can be embedded into your development shell and can be used to generate makefiles and git hooks.

- [Minimal Example](#minimal-example)
- [Available Functions and Sets](#available-functions-and-sets)
- [Task Generators](#task-generators)
- [Shell Snippets](#shell-snippets)


## Minimal Example
In the following code we define three tasks:
- "first-task"
- "second-task"
- "run-in-sequence"

They are all injected into the `$PATH` the dev-shell meaning that they can be run directly from within the shell.

```nix
rec {
    description = "Minimal example of task-lib library";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        task-lib.url = "github:BalderHolst/task-lib.nix";
    };

    outputs = { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = import nixpkgs { inherit system; };

            # Import the task-gen library
            task-lib = inputs.task-lib.lib."${system}";

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
```
(This code can be found in [./examples/minimal](./examples/minimal))

Entering the dev-shell greets you with the following:
```text
Minimal example of task-lib library

Available Tasks:
	first-task
	run-in-sequence
	second-task

Use 'thelp' command to show this list.
```

The tasks can be run as follows:
```console
$ first-task
->> Running 'first-task'
Hello! This is first task!

$ second-task
->> Running 'second-task'
Hi! This is SECOND task!

$ run-in-sequence
->> Running 'run-in-sequence'
--->> Running 'first-task'
Hello! This is first task!
--->> Running 'second-task'
Hi! This is SECOND task!
```

## Available Functions and Sets
- [mkTask](#mkTask-name-details)
- [mkSeq](#mkSeq-name-seq)
- [mkScript](#mkScript-task)
- [mkScriptBin](#mkScriptBin-task)
- [mkHelpScript](#mkHelpScript-tasks)
- [mkHelpScriptBin](#mkHelpScriptBin-tasks)
- [mkScripts](#mkScripts-tasks)
- [mkScriptDir](#mkScriptDir-tasks)
- [mkMakefile](#mkMakefile-tasks)
- [mkShellHook](#mkShellHook-tasks)
- [mkGenScriptsApp](#mkGenScriptsApp-task-files)
- [gen](#gen-)
- [snips](#snips-)

--------

#### **`mkTask`** *name* *details*

Create a task

*Args:*
- `name`: `string` - The name of the task
- `details`: `{ script?: string, depends?: list[task] }` - A set maybe containing a script and dependencies

Returns: `task`

Source: [`./lib.nix:72`](./lib.nix?plain=1#L72)


#### **`mkSeq`** *name* *seq*

Create a sequence of tasks

*Args:*
- `name`: `string` - The name of the sequence task
- `seq`: `list[task]` - A list of tasks to be executed in sequence

Returns: `task`

Source: [`./lib.nix:82`](./lib.nix?plain=1#L82)


#### **`mkScript`** *task*

Generate a script that executes a task

*Args:*
- `task`: `task` - The task to be executed

Returns: `path` - Path to the generated script in nix store

Source: [`./lib.nix:87`](./lib.nix?plain=1#L87)


#### **`mkScriptBin`** *task*

Generate a script (package) that executes a task

*Args:*
- `task`: `task` - The task to be executed

Returns: `package` - Path to the package in nix store

Source: [`./lib.nix:92`](./lib.nix?plain=1#L92)


#### **`mkHelpScript`** *tasks*

Generate a help script that lists all tasks

*Args:*
- `tasks`: `list[task]`

Returns: `path` - Path to help script in nix store

Source: [`./lib.nix:97`](./lib.nix?plain=1#L97)


#### **`mkHelpScriptBin`** *tasks*

Generate a help script (package) that lists all tasks

*Args:*
- `tasks`: `list[task]`

Returns: `package` - Path to help script package in nix store

Source: [`./lib.nix:102`](./lib.nix?plain=1#L102)


#### **`mkScripts`** *tasks*

Generate a packaged script for each task

*Args:*
- `tasks`: `list[task]`

Returns: `list[package]` - List of packages in nix store. These can be appended to shell inputs.

Source: [`./lib.nix:107`](./lib.nix?plain=1#L107)


#### **`mkScriptDir`** *tasks*

Generate a directory of scripts for each task

*Args:*
- `tasks`: `list[task]`

Returns: `package` - Path to the directory of scripts in nix store

Source: [`./lib.nix:112`](./lib.nix?plain=1#L112)


#### **`mkMakefile`** *tasks*

Generate a Makefile for tasks

*Args:*
- `tasks`: `list[task]`

Returns: `path` - Path to generate Makefile in nix store

Source: [`./lib.nix:131`](./lib.nix?plain=1#L131)


#### **`mkShellHook`** *tasks*

Generate a shell hook for tasks

*Args:*
- `tasks`: `list[task]`

Returns: `string` - Shell hook string

Source: [`./lib.nix:164`](./lib.nix?plain=1#L164)


#### **`mkGenScriptsApp`** *task-files*

Create a flake app that generates scripts, based on a task, in specified paths

*Args:*
- `task-files`: `set<string, script>` - A set of paths and scripts to be generated

Returns: `app` - A flake app that generates scripts scripts in specified paths

Source: [`./lib.nix:171`](./lib.nix?plain=1#L171)


#### **`gen`** 

Set of function used to generate commonly used tasks.
See [Task Generators](#task-generators).

Source: [`./lib.nix:203`](./lib.nix?plain=1#L203)


#### **`snips`** 

Set of snippets to be used in tasks.

Source: [`./lib.nix:206`](./lib.nix?plain=1#L206)

## Task Generators
Below is a list of functions to generate common tasks. The list is short for now, but it will grow as i find more tasks that i would like to use across projects. These tasks can be accessed through `task-gen.<system>.lib.gen`.

- [gen-scripts](#gen-scripts-name)
- [check-no-uncommited](#check-no-uncommited-msg)

--------

#### **`gen-scripts`** *name*

Generate a task to run the app which generates scripts in specified paths

*Args:*
- `name`: `string` - Name of the app which generates scripts (usually "gen-scripts")

Source: [`./builtin-tasks.nix:7`](./builtin-tasks.nix?plain=1#L7)


#### **`check-no-uncommited`** *msg*

Check that the repository has no uncommitted changes and fail if so

*Args:*
- `msg`: `string` - Message to display if there are uncommitted changes

Source: [`./builtin-tasks.nix:11`](./builtin-tasks.nix?plain=1#L11)

## Shell Snippets
A collection of shell snippets to be used when generating tasks. They are mostly things i find myself writing often and have to google every time. These are available through `task-gen.<system>.lib.snips`.

- [git-find-root](#git-find-root-)

--------

#### **`git-find-root`** 

Find the root of the current git repository

Source: [`./snippets.nix:3`](./snippets.nix?plain=1#L3)
