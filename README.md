# Nix Task Generator
A nix library for creating project tasks using nix. These tasks can be embedded into your development shell and can be used to generate makefiles and git hooks.


### Available Functions
#### **`mkTask`**: Create a task

*Args:*
- `name`: `string`
- `details`: `{ script?: string, depends?: list[task] }`

Source: [`./lib.nix:71`](./lib.nix?plain=1#L71)


#### **`mkSeq`**: Create a sequence of tasks

*Args:*
- `name`: `string`
- `seq`: `list[task]`

Source: [`./lib.nix:80`](./lib.nix?plain=1#L80)


#### **`mkScript`**: Generate a script that executes a task

*Args:*
- `task`: `task`

Source: [`./lib.nix:84`](./lib.nix?plain=1#L84)


#### **`mkScriptBin`**: Generate a script (package) that executes a task

*Args:*
- `task`: `task`

Source: [`./lib.nix:88`](./lib.nix?plain=1#L88)


#### **`mkHelpScript`**: Generate a help script that lists all tasks

*Args:*
- `tasks`: `list[task]`

Source: [`./lib.nix:92`](./lib.nix?plain=1#L92)


#### **`mkHelpScriptBin`**: Generate a help script (package) that lists all tasks

*Args:*
- `tasks`: `list[task]`

Source: [`./lib.nix:96`](./lib.nix?plain=1#L96)


#### **`mkScripts`**: Generate a list of scripts for each task

*Args:*
- `tasks`: `list[task]`

Source: [`./lib.nix:100`](./lib.nix?plain=1#L100)


#### **`mkMakefile`**: Generate a Makefile for tasks

*Args:*
- `tasks`: `list[task]`

Source: [`./lib.nix:104`](./lib.nix?plain=1#L104)


#### **`mkShellHook`**: Generate a shell hook for tasks

*Args:*
- `tasks`: `list[task]`

Source: [`./lib.nix:136`](./lib.nix?plain=1#L136)


#### **`mkGenScriptsApp`**: Create a flake app that generates scripts, based on a task, in specified paths

*Args:*
- `task-files`: `set<string, script>`

Source: [`./lib.nix:142`](./lib.nix?plain=1#L142)


#### **`gen`**: Set of function used to generate commonly used tasks.
See [Task Generators](#task-generators).

Source: [`./lib.nix:168`](./lib.nix?plain=1#L168)


#### **`snips`**: Set of snippets to be used in tasks.

Source: [`./lib.nix:171`](./lib.nix?plain=1#L171)

### Task Generators
Below is a list of functions to generate common tasks. The list is short for now, but it will grow as i find more tasks that i would like to use across projects. These tasks can be accessed through `task-gen.<system>.lib.gen`.

#### **`gen-scripts`**: Generate a task to run the app which generates scripts in specified paths

*Args:*
- `name`: `string` - Name of the app which generates scripts (usually "gen-scripts")

Source: [`./builtin-tasks.nix:7`](./builtin-tasks.nix?plain=1#L7)


#### **`check-no-uncommited`**: Check that the repository has no uncommitted changes and fail if so.

*Args:*
- `msg`: `string` - Message to display if there are uncommitted changes

Source: [`./builtin-tasks.nix:11`](./builtin-tasks.nix?plain=1#L11)

### Shell Snippets
A collection of shell snippets to be used when generating tasks. They are mostly things i find myself writing often and have to google every time. These are available through `task-gen.<system>.lib.snips`.

#### **`git-find-root`**: Find the root of the current git repository

Source: [`./snippets.nix:3`](./snippets.nix?plain=1#L3)
