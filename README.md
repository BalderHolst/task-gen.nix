# Nix Task Generator
A nix library for creating project tasks using nix. These tasks can be embedded into your development shell and can be used to generate makefiles and git hooks.


### Available Functions
`mkTask`
Create a task

`mkSeq`
Create a sequence of tasks

`mkScriptBin`
Generate a script (package) that executes a task

`mkScript`
Generate a script that executes a task

`mkHelpScript`
Generate a help script that lists all tasks

`mkHelpScriptBin`
Generate a help script (package) that lists all tasks

`mkScripts`
Generate a list of scripts for each task

`mkMakefile`
Generate a Makefile for tasks

`mkShellHook`
Generate a shell hook for tasks

`mkGenScriptsApp`
Create a flake app that generates scripts, based on a task, in specified paths

### Builtin Tasks
Below is a list of functions to generate common tasks. The list is short for now, but it will grow as i find more tasks that i would like to use across projects. These tasks can be accessed through `task-gen.<system>.lib.tasks`.

#### `meta`
Generators for `task-gen` related tasks

`gen-scripts-task`
Generate a task to run the app which generates scripts in specified paths

#### `git`
Generators for git tasks

`check-no-uncommited`
Check that the repository has no uncommitted changes
