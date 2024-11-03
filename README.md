# Nix Task Generator
A nix library for creating project tasks using nix. These tasks can be embedded into your development shell and can be used to generate makefiles and git hooks.


### Available Functions
##### `mkTask`: Create a task

Source: [`./lib.nix:69`](./lib.nix?plain=1#L69)


##### `mkSeq`: Create a sequence of tasks

Source: [`./lib.nix:76`](./lib.nix?plain=1#L76)


##### `mkScriptBin`: Generate a script (package) that executes a task

Source: [`./lib.nix:79`](./lib.nix?plain=1#L79)


##### `mkScript`: Generate a script that executes a task

Source: [`./lib.nix:82`](./lib.nix?plain=1#L82)


##### `mkHelpScript`: Generate a help script that lists all tasks

Source: [`./lib.nix:85`](./lib.nix?plain=1#L85)


##### `mkHelpScriptBin`: Generate a help script (package) that lists all tasks

Source: [`./lib.nix:88`](./lib.nix?plain=1#L88)


##### `mkScripts`: Generate a list of scripts for each task

Source: [`./lib.nix:91`](./lib.nix?plain=1#L91)


##### `mkMakefile`: Generate a Makefile for tasks

Source: [`./lib.nix:94`](./lib.nix?plain=1#L94)


##### `mkShellHook`: Generate a shell hook for tasks

Source: [`./lib.nix:125`](./lib.nix?plain=1#L125)


##### `mkGenScriptsApp`: Create a flake app that generates scripts, based on a task, in specified paths

Source: [`./lib.nix:130`](./lib.nix?plain=1#L130)


##### `gen`: Set of function used to generate commonly used tasks.
See [Task Generators](#task-generators).

Source: [`./lib.nix:156`](./lib.nix?plain=1#L156)


##### `snips`: Set of snippets to be used in tasks.

Source: [`./lib.nix:159`](./lib.nix?plain=1#L159)

### Task Generators
Below is a list of functions to generate common tasks. The list is short for now, but it will grow as i find more tasks that i would like to use across projects. These tasks can be accessed through `task-gen.<system>.lib.gen`.

##### `gen-scripts`: Generate a task to run the app which generates scripts in specified paths

Source: [`./builtin-tasks.nix:6`](./builtin-tasks.nix?plain=1#L6)


##### `check-no-uncommited`: Check that the repository has no uncommitted changes

Source: [`./builtin-tasks.nix:9`](./builtin-tasks.nix?plain=1#L9)

### Shell Snippets
A collection of shell snippets to be used when generating tasks. They are mostly things i find myself writing often and have to google every time. These are available through `task-gen.<system>.lib.snips`.

##### `git-find-root`: Find the root of the current git repository

Source: [`./snippets.nix:3`](./snippets.nix?plain=1#L3)
