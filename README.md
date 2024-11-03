# Nix Task Generator
A nix library for creating project tasks using nix. These tasks can be embedded into your development shell and can be used to generate makefiles and git hooks.


### Available Functions
##### `mkTask`: Create a task

Source: [`./lib.nix:68`](./lib.nix?plain=1#L68)


##### `mkSeq`: Create a sequence of tasks

Source: [`./lib.nix:75`](./lib.nix?plain=1#L75)


##### `mkScriptBin`: Generate a script (package) that executes a task

Source: [`./lib.nix:78`](./lib.nix?plain=1#L78)


##### `mkScript`: Generate a script that executes a task

Source: [`./lib.nix:81`](./lib.nix?plain=1#L81)


##### `mkHelpScript`: Generate a help script that lists all tasks

Source: [`./lib.nix:84`](./lib.nix?plain=1#L84)


##### `mkHelpScriptBin`: Generate a help script (package) that lists all tasks

Source: [`./lib.nix:87`](./lib.nix?plain=1#L87)


##### `mkScripts`: Generate a list of scripts for each task

Source: [`./lib.nix:90`](./lib.nix?plain=1#L90)


##### `mkMakefile`: Generate a Makefile for tasks

Source: [`./lib.nix:93`](./lib.nix?plain=1#L93)


##### `mkShellHook`: Generate a shell hook for tasks

Source: [`./lib.nix:124`](./lib.nix?plain=1#L124)


##### `mkGenScriptsApp`: Create a flake app that generates scripts, based on a task, in specified paths

Source: [`./lib.nix:129`](./lib.nix?plain=1#L129)


##### `gen`: Set of function used to generate commonly used tasks.
See [Task Generators](#task-generators).

Source: [`./lib.nix:155`](./lib.nix?plain=1#L155)


##### `snips`: Set of snippets to be used in tasks.

Source: [`./lib.nix:158`](./lib.nix?plain=1#L158)

### Task Generators
Below is a list of functions to generate common tasks. The list is short for now, but it will grow as i find more tasks that i would like to use across projects. These tasks can be accessed through `task-gen.<system>.lib.gen`.

##### `gen-scripts`: Generate a task to run the app which generates scripts in specified paths

Source: [`./builtin-tasks.nix:5`](./builtin-tasks.nix?plain=1#L5)


##### `check-no-uncommited`: Check that the repository has no uncommitted changes

Source: [`./builtin-tasks.nix:8`](./builtin-tasks.nix?plain=1#L8)

### Shell Snippets
A collection of shell snippets to be used when generating tasks. They are mostly things i find myself writing often and have to google every time. These are available through `task-gen.<system>.lib.snips`.

##### `git-find-root`: Find the root of the current git repository

Source: [`./snippets.nix:2`](./snippets.nix?plain=1#L2)
