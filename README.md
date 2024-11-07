# Nix Task Generator
A nix library for creating project tasks using nix. These tasks can be embedded into your development shell and can be used to generate makefiles and git hooks.

- [Available Functions and Sets](#available-functions-and-sets)
- [Task Generators](#task-generators)
- [Shell Snippets](#shell-snippets)

## Available Functions and Sets
- [mkTask](#mkTask-name-details)
- [mkSeq](#mkSeq-name-seq)
- [mkScript](#mkScript-task)
- [mkScriptBin](#mkScriptBin-task)
- [mkHelpScript](#mkHelpScript-tasks)
- [mkHelpScriptBin](#mkHelpScriptBin-tasks)
- [mkScripts](#mkScripts-tasks)
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

Generate a list of scripts for each task

*Args:*
- `tasks`: `list[task]`

Returns: `list[package]` - List of packages in nix store. These can be appended to shell inputs.

Source: [`./lib.nix:107`](./lib.nix?plain=1#L107)


#### **`mkMakefile`** *tasks*

Generate a Makefile for tasks

*Args:*
- `tasks`: `list[task]`

Returns: `path` - Path to generate Makefile in nix store

Source: [`./lib.nix:112`](./lib.nix?plain=1#L112)


#### **`mkShellHook`** *tasks*

Generate a shell hook for tasks

*Args:*
- `tasks`: `list[task]`

Returns: `string` - Shell hook string

Source: [`./lib.nix:145`](./lib.nix?plain=1#L145)


#### **`mkGenScriptsApp`** *task-files*

Create a flake app that generates scripts, based on a task, in specified paths

*Args:*
- `task-files`: `set<string, script>` - A set of paths and scripts to be generated

Returns: `app` - A flake app that generates scripts scripts in specified paths

Source: [`./lib.nix:152`](./lib.nix?plain=1#L152)


#### **`gen`** 

Set of function used to generate commonly used tasks.
See [Task Generators](#task-generators).

Source: [`./lib.nix:178`](./lib.nix?plain=1#L178)


#### **`snips`** 

Set of snippets to be used in tasks.

Source: [`./lib.nix:181`](./lib.nix?plain=1#L181)

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
